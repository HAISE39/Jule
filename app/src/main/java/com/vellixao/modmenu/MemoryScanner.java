package com.vellixao.modmenu;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import java.util.List;

/**
 * MemoryScanner - Sistem pencarian memori Java Heap (dalvik-main)
 * Dibuat untuk AIDE Pro - Fokus pada pure Java (Bukan JNI)
 */
public class MemoryScanner {

    private static final String MAPS_FILE = "/proc/self/maps";
    private static final String MEM_FILE = "/proc/self/mem";

    public static class MemoryRange {
        public long start;
        public long end;

        public MemoryRange(long start, long end) {
            this.start = start;
            this.end = end;
        }
    }

    // Mendapatkan list region Java Heap (dalvik-main)
    public static List<MemoryRange> getJavaHeapRanges() {
        List<MemoryRange> ranges = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(MAPS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                // Mencari region dalvik-main
                if (line.contains("[anon:dalvik-main]")) {
                    String[] parts = line.split(" ");
                    String[] addresses = parts[0].split("-");
                    long start = Long.parseLong(addresses[0], 16);
                    long end = Long.parseLong(addresses[1], 16);
                    ranges.add(new MemoryRange(start, end));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ranges;
    }

    // Mencari nilai Integer (Dword) di Java Heap
    public static List<Long> searchDword(int value) {
        List<Long> results = new ArrayList<>();
        List<MemoryRange> ranges = getJavaHeapRanges();

        byte[] target = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(value).array();

        try (RandomAccessFile mem = new RandomAccessFile(MEM_FILE, "r")) {
            for (MemoryRange range : ranges) {
                long size = range.end - range.start;
                byte[] buffer = new byte[65536]; // Scan per 64KB

                for (long offset = 0; offset < size; offset += buffer.length - 3) {
                    long currentPos = range.start + offset;
                    mem.seek(currentPos);
                    int bytesRead = mem.read(buffer);
                    if (bytesRead <= 0) break;

                    for (int i = 0; i <= bytesRead - 4; i++) {
                        if (buffer[i] == target[0] && buffer[i+1] == target[1] &&
                            buffer[i+2] == target[2] && buffer[i+3] == target[3]) {
                            results.add(currentPos + i);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return results;
    }

    // Mengubah nilai di alamat tertentu
    public static boolean writeDword(long address, int newValue) {
        try (RandomAccessFile mem = new RandomAccessFile(MEM_FILE, "rw")) {
            byte[] data = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(newValue).array();
            mem.seek(address);
            mem.write(data);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Mencari nilai Float
    public static List<Long> searchFloat(float value) {
        int intBits = Float.floatToIntBits(value);
        return searchDword(intBits);
    }
}
