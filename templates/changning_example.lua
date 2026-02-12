-- Template Mod Menu ELGG (Changning E03PRO)
-- Dibuat berdasarkan rekomendasi modul UI modern

function init()
    -- Pemetaan variabel internal library ke global environment
    stab = _ENV["halaman"]
    ttitle = _ENV["judul"]
    xfcpic = _ENV["ikon_jendela_mengambang"]
end

-- Memuat Library Changning (Hash contoh)
-- loadYunLuaGroup("hash_library_di_sini")

-- Contoh Fitur Mod
function fitur_unlimited_hp(state)
    if state then
        print("Unlimited HP Aktif")
        -- Logika pencarian memory di sini
    else
        print("Unlimited HP Nonaktif")
    end
end

-- Inisialisasi Data UI
_ENV["judul"] = "ELGG MOD MENU"
_ENV["ikon_jendela_mengambang"] = "https://example.com/icon.png"
_ENV["halaman"] = {
    {
        "Main Menu", -- Judul Tab
        {
            -- Menggunakan komponen CA (Changning API)
            CAswitch("Unlimited HP", fitur_unlimited_hp, nil, "Membuat HP tidak terbatas"),
            CAbutton("Refresh Skill", function() print("Skill Refreshed") end, "#FFBB86FC"),
        }
    },
    {
        "Settings",
        {
            CAtext("Mod Menu Version 1.0", "#FFFFFFFF", 14, true),
        }
    }
}

-- Jalankan Inisialisasi
init()

-- Fungsi untuk memulai UI
function StartUI()
    uistart({
        {
            -- Layout Sidebar / Drawer
            stab,
            ttitle,
            xfcpic
        }
    })
end

-- Entry Point ELGG
Lock.Ui(StartUI, nil, function(err)
    print("Error: " .. tostring(err))
end)
