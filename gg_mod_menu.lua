-- VELLIXAO Android Mod Menu Template (Game Guardian)
-- Target: Java Heap (dalvik-main)
-- Region ini biasanya digunakan untuk game berbasis Java/ART (bukan native/JNI)

-- Mengatur range pencarian ke Java Heap
gg.setRanges(gg.REGION_JAVA_HEAP)

function Main()
    local menu = gg.choice({
        "🔍 Search & Edit Dword (Integer)",
        "🌊 Search & Edit Float (Decimal)",
        "🧹 Clear Results",
        "ℹ️ About",
        "❌ Exit"
    }, nil, "VELLIXAO Mod Menu - Java Heap Edition")

    if menu == nil then return end
    if menu == 1 then EditValue(gg.TYPE_DWORD, "Dword") end
    if menu == 2 then EditValue(gg.TYPE_FLOAT, "Float") end
    if menu == 3 then
        gg.clearResults()
        gg.toast("Results cleared / Hasil dibersihkan")
    end
    if menu == 4 then About() end
    if menu == 5 then os.exit() end
end

function EditValue(v_type, name)
    local prompt = gg.prompt({
        "Cari nilai (" .. name .. "):",
        "Ubah menjadi:"
    }, {
        "100",
        "999"
    }, {
        "number",
        "number"
    })

    if prompt == nil then return end

    gg.clearResults()
    gg.toast("Searching in Java Heap...")
    gg.searchNumber(prompt[1], v_type)

    local count = gg.getResultCount()
    if count == 0 then
        gg.alert("Nilai tidak ditemukan di Java Heap!\nPastikan game benar-benar menggunakan region ini.")
    else
        gg.getResults(count)
        gg.editAll(prompt[2], v_type)
        gg.toast("Berhasil mengubah " .. count .. " nilai")
    end
end

function About()
    gg.alert("VELLIXAO Mod Menu Template\n\nFokus: Java_Heap memory dalvik-main\nPlatform: Android (Game Guardian)\n\nScript ini digunakan untuk mencari value pada game yang tidak menggunakan JNI/Native, melainkan berjalan di atas ART (Android Runtime).")
end

-- Menjalankan menu utama saat script pertama kali dijalankan
Main()

-- Loop untuk mendeteksi icon Game Guardian diklik
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        Main()
    end
    gg.sleep(100)
end
