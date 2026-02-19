-- Template Mod Menu ELGG (Official Style)
-- Mengacu pada dokumentasi Gitee: https://gitee.com/xiaomanyun/elgg

function init()
    -- Sinkronisasi variabel lingkungan untuk library UI
    stab = _ENV["halaman"]
    ttitle = _ENV["judul"]
    xfcpic = _ENV["ikon_jendela_mengambang"]
end

-- 1. Pemuatan Library (Contoh Material3 dari Gitee)
-- loadYunLuaGroup("material3_hash")

-- 2. Contoh Fitur Menggunakan luajava (Akses API Android)
function showToast(text)
    luajava.import("android.widget.Toast")
    luajava.import("android.app.ActivityThread")
    local activity = ActivityThread.currentActivityThread():getApplication()
    Toast.makeText(activity, text, Toast.LENGTH_SHORT).show()
end

-- 3. Contoh Logika Modifikasi Memori
function toggle_mod(state)
    if state then
        showToast("Mod Aktif!")
        -- Gunakan gg atau modul memory eksternal
    else
        showToast("Mod Nonaktif!")
    end
end

-- 4. Konfigurasi UI
_ENV["judul"] = "ELGG OFFICIAL TEMPLATE"
_ENV["ikon_jendela_mengambang"] = "https://gitee.com/xiaomanyun/elgg/raw/main/favicon.ico"
_ENV["halaman"] = {
    {
        "BERANDA",
        {
            -- Komponen library Material3/Changning
            CAswitch("Aktifkan Fitur X", toggle_mod, nil, "Deskripsi fitur di sini"),
            CAbutton("Test Android Toast", function() showToast("Halo dari luajava!") end, "#FFBB86FC"),
        }
    },
    {
        "PENGATURAN",
        {
            CAtext("Versi Script: 2.0 (Stable)", "#FFFFFFFF", 14, true),
            CAbutton("Keluar", function() os.exit() end, "#FFFF5252"),
        }
    }
}

-- Jalankan Inisialisasi Environment
init()

-- 5. Fungsi Utama untuk Meluncurkan UI
function StartUI()
    -- Memastikan antarmuka berjalan di thread yang benar
    uistart({
        {
            stab,
            ttitle,
            xfcpic
        }
    })
end

-- 6. Entry Point Resmi ELGG
-- Menggunakan Lock.Ui untuk stabilitas dan proteksi error
Lock.Ui(StartUI, nil, function(err)
    print("ELGG Error: " .. tostring(err))
end)

-- Catatan: Simpan script ini dan gunakan 'ELGG Toolbox' untuk enkripsi Lua-to-Dex
-- sebelum didistribusikan ke pengguna.
