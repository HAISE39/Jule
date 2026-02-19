import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.*"
import "android.graphics.drawable.*"
import "android.ext.*"
import "android.graphics.drawable.GradientDrawable"
import "android.graphics.*"
import "android.graphics.drawable.ColorDrawable"
import "android.content.Context"
import "android.media.AudioManager"
import "android.webkit.MimeTypeMap"

marker_path = "/sdcard/Android/.ok"

context = activity
window = context.getSystemService("window")
if Build.VERSION.SDK_INT >= 26 then
    windowtype = 2038
else
    windowtype = 2003
end

function threadStart(runnable)
    local newRun = luajava.createProxy("java.lang.Runnable", runnable)
    local subThread = luajava.newInstance("java.lang.Thread", newRun)
    subThread:start()
    return subThread
end

function getShepeBackground(color, radiu)
    local drawable = luajava.new(GradientDrawable)
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadii({ radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu })
    return drawable
end

function miaobian(d, r, t, y)
    local InsideColor = Color.parseColor(t)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(InsideColor)
    drawable.setCornerRadii({ r, r, r, r, r, r, r, r })
    drawable.setStroke(d, Color.parseColor(y))
    return drawable
end

-- Reusable Login Dialog Function
function showLoginDialog(target_password, marker, successCallback)
    local login = loadlayout({
        LinearLayout,
        layout_width = "fill",
        layout_height = "fill",
        gravity = "center",
        {
            CardView,
            layout_width = "180dp",
            layout_height = "290dp",
            Elevation = '15dp',
            radius = '15',
            CardBackgroundColor = "#FFFFFFFF",
            {
                LinearLayout,
                layout_width = -1,
                layout_height = -1,
                gravity = "center",
                orientation = "vertical",
                {
                    CardView,
                    layout_width = -1,
                    layout_height = "140dp",
                    layout_margin = "20dp",
                    CardBackgroundColor = "#00FFFFFF",
                    radius = '15',
                    {
                        ImageView,
                        layout_width = -1,
                        layout_height = -1,
                        scaleType = "fitCenter",
                        id = "pic",
                    },
                },
                {
                    EditText,
                    layout_width = -1,
                    layout_margin = "5dp",
                    layout_height = "40dp",
                    background = miaobian(3, 20, "#FFF9F9F9", "#FF000000"),
                    textColor = 4278224127,
                    padding = "5dp",
                    inputType = "textPassword",
                    hint = "Masukkan Password",
                    id = "edit",
                },
                {
                    TextView,
                    layout_width = -1,
                    layout_margin = "10dp",
                    layout_height = -1,
                    text = "Login",
                    gravity = "center",
                    textSize = "17sp",
                    textColor = 0xFFFFFFFF,
                    background = getShepeBackground(4278224127, 20),
                    onClick = function()
                        local input = edit.getText().toString()
                        if input == target_password then
                            if dlg_create then dlg_create.dismiss() end
                            if marker then
                                file.mkdir("/sdcard/.txj")
                                io.open(marker, "w"):write("ok"):close()
                            end
                            print("Password Benar")
                            if successCallback then successCallback() end
                        else
                            print("Password Salah")
                        end
                    end,
                },
            },
        },
    })

    threadStart({
        run = function()
            bit1 = loadbitmap("https://files.catbox.moe/p7yibm.png")
            activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
                run = function()
                    local create_dlg = AlertDialog.Builder(activity)
                    create_dlg.setView(login)
                    create_dlg.setCancelable(false)
                    dlg_create = create_dlg.create()
                    dlg_create.getWindow().setType(windowtype)
                    dlg_create.getWindow().setBackgroundDrawable(ColorDrawable(0x00FFFFFF))
                    dlg_create.show()
                    pic.setImageBitmap(bit1)
                end
            }))
        end
    })
end

-- Main Login Check
if io.open(marker_path) == nil then
    Lock.Ui(function()
        showLoginDialog("̧̡̡̨̧̻̦̭͕͉̮̤͓̤̣̮̣̰͕̤͓̲͚̝̭̣̺̣̰̞̦͕̖͇̗͈̞̲̙̘̖̞͉̖̠̲̹̠̹̺͈̟̲̝̜͚̖̙͕͕̞͈̗̝͙̩̹͜ͅ", marker_path)
    end, nil, function(err)
        print(err)
        luajava.exit()
    end)
end


loadYunLuaGroup("5C3C4E3813681C4C204C35346F1B4C2F7EFF612D2B22176FF346535E1C0B1E493339036EE15318")
function init()
	stab = _ENV["halaman"]
	ttitle = _ENV["judul"]
	xfcpic = _ENV["ikon_jendela_mengambang"]
end

_ENV["ikon_jendela_mengambang"] = 'https://files.catbox.moe/mbkj32.png'
_ENV["judul"] = 'ELGG - UI'
_ENV["halaman"] = {
	'PLAYER',
	'FARM',
	'VIP MENU',
	'OTHER GAME',
	'PENGATURAN',
}

init()

function searchInDalvikMainSpace(searchString, searchType, sign)
    gg.setRanges(gg.REGION_JAVA_HEAP)
    local ranges = gg.getRangesList()
    local matched = {}

    for i, r in ipairs(ranges) do
        if r.name and r.name:lower():find("dalvik%-main space") then
            table.insert(matched, r)
        elseif tostring(r):lower():find("dalvik%-main space") then
            table.insert(matched, r)
        end
    end

    if #matched == 0 then
        gg.toast("❌ Tidak menemukan range dalvik-main space")
        return false
    end

    local totalFound = 0
    for i, r in ipairs(matched) do
        local startAddr = tonumber(r.start) or tonumber(tostring(r.start), 16)
        local endAddr   = tonumber(r["end"]) or tonumber(tostring(r["end"]), 16)

        if startAddr and endAddr and startAddr < endAddr then
            gg.searchNumber(searchString, searchType, false, sign, startAddr, endAddr, 0)
            local count = gg.getResultCount()
            if count > 0 then
                totalFound = totalFound + count
                gg.toast("✓ Range ke-" .. i .. ": " .. count .. " hasil")
                return true
            end
        end
    end

    if totalFound == 0 then
        gg.toast("❌ Tidak ada hasil ditemukan")
        return false
    end
end

uistart({
	{ --1 Halaman PLAYER
		CAtext('MOD AURCUS ONLINE BY: VELLIXAO', '#005BFF', '14sp'),

		CAbox({ 'BYPASS MENU',

			CAbutton(
			'Bypass Login',
			function()
				gg.setVisible(false)
				gg.clearResults()
				gg.processResume()
				gg.searchNumber("1337;1;0;0::17", gg.TYPE_DWORD)
				gg.refineNumber("1337")
				local r = gg.getResults(10)
				for i, v in ipairs(r) do
					v.value = "0"
					v.freeze = true
				end
				gg.addListItems(r)
			end),

			CAbutton(
			'Optimizer Map',
			function()
				gg.setVisible(false)
				function disableGGDetection()
					gg.setRanges(gg.REGION_CODE_APP | gg.REGION_JAVA_HEAP)
					gg.searchNumber("4761214;1162690580::17", gg.TYPE_DWORD)
					gg.clearResults()
					gg.toast("Bypass Deteksi GG Aktif")
				end

				function advancedMapStabilizer()
					gg.clearResults()
					gg.setRanges(gg.REGION_C_ALLOC)
					gg.searchNumber("20000000~60000000", gg.TYPE_DWORD)
					local res = gg.getResults(20)
					for i, v in ipairs(res) do
						v.value = "0"
						v.freeze = true
					end
					gg.addListItems(res)
					gg.toast("Advanced Stabilizer Aktif")
				end

				disableGGDetection()
				advancedMapStabilizer()
				gg.setVisible(false)
				gg.clearResults()
				gg.setRanges(gg.REGION_C_DATA)
				gg.searchNumber("gg", gg.TYPE_BYTE)
				gg.clearResults()
				gg.clearList()
			end),
		}),

		CAbox({ 'SAVE ITEM',
			CAbutton(
			'STORAGE',
			function()
				gg.clearResults()
				gg.setVisible(false)
				if searchInDalvikMainSpace("-1;2;-1:9", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
					gg.processResume()
					gg.toast("BUKA ENCHANTMENT")
					gg.sleep(5000)
					gg.refineNumber("-1;59;-1:9", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
					gg.refineNumber("59", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
					rv = gg.getResults (1)
					if #rv > 0 then
						local v0_0 = {}
						v0_0[1] = {}
						v0_0[1].address = rv[1].address + 4
						v0_0[1].flags = gg.TYPE_DWORD
						v0_0[1].value = "12"
						v0_0[1].freeze = false
						gg.setValues(v0_0)
					end
				end
			end),
			CAbutton(
			'MARKET',
			function()
				gg.clearResults()
				gg.setVisible(false)
				if searchInDalvikMainSpace("-1;2;-1:9", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
					gg.processResume()
					gg.toast("BUKA ENCHANTMENT")
					gg.sleep(5000)
					gg.refineNumber("-1;59;-1:9", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
					gg.refineNumber("59", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
					rTv = gg.getResults (1)
					if #rTv > 0 then
						local Tv0_0 = {}
						Tv0_0[1] = {}
						Tv0_0[1].address = rTv[1].address + 4
						Tv0_0[1].flags = gg.TYPE_DWORD
						Tv0_0[1].value = "27"
						Tv0_0[1].freeze = false
						gg.setValues(Tv0_0)
					end
				end
			end),
		}),
		CAbox({ 'BASIC JOB DAMAGE',
			CAbutton(
			'SWORDMAN',
			function()
				gg.sleep(200)
				gg.clearResults()
				gg.setVisible(false)
				gg.setRanges(gg.REGION_JAVA_HEAP)
				local matched = {}
				for _, r in ipairs(gg.getRangesList()) do
					if r.name and r.name:lower():find("dalvik%-main space") then
						table.insert(matched, r)
					end
				end

				if #matched > 0 then
					for _, r in ipairs(matched) do
						local startAddr = tonumber(r.start) or tonumber(tostring(r.start), 16)
						local endAddr   = tonumber(r["end"]) or tonumber(tostring(r["end"]), 16)

						if startAddr and endAddr and startAddr < endAddr then
							gg.searchNumber("h 03 00 00 00 1E 00 00 00 01 00 00 00 02 00 00 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, startAddr, endAddr, 0)
							if gg.getResultCount() > 0 then
								gg.processResume()
								gg.refineNumber("30", gg.TYPE_BYTE, false, gg.SIGN_EQUAL)
								r = gg.getResults (1)
								if #r > 0 then
									local L0_0 = {}
									L0_0[1] = {address = r[1].address + 24, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									L0_0[2] = {address = r[1].address + 28, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									gg.setValues(L0_0)
									gg.addListItems(L0_0)
								end
								break
							end
						end
					end
				end
				gg.clearResults()
			end),
			CAbutton(
			'ARCHER',
			function()
				gg.sleep(200)
				gg.clearResults()
				gg.setVisible(false)
				gg.setRanges(gg.REGION_JAVA_HEAP)
				local matched = {}
				for _, r in ipairs(gg.getRangesList()) do
					if r.name and r.name:lower():find("dalvik%-main space") then
						table.insert(matched, r)
					end
				end

				if #matched > 0 then
					for _, r in ipairs(matched) do
						local startAddr = tonumber(r.start) or tonumber(tostring(r.start), 16)
						local endAddr   = tonumber(r["end"]) or tonumber(tostring(r["end"]), 16)

						if startAddr and endAddr and startAddr < endAddr then
							gg.searchNumber("h 07 00 00 00 22 00 00 00 01 00 00 00 04 00 00 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, startAddr, endAddr, 0)
							if gg.getResultCount() > 0 then
								gg.processResume()
								gg.refineNumber("34", gg.TYPE_BYTE, false, gg.SIGN_EQUAL)
								r1 = gg.getResults (1)
								if #r1 > 0 then
									local L1_0 = {}
									L1_0[1] = {address = r1[1].address + 24, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									L1_0[2] = {address = r1[1].address + 28, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									gg.setValues(L1_0)
									gg.addListItems(L1_0)
								end
								break
							end
						end
					end
				end
				gg.clearResults()
			end),
			CAbutton(
			'MAGE',
			function()
				gg.sleep(200)
				gg.clearResults()
				gg.setVisible(false)
				gg.setRanges(gg.REGION_JAVA_HEAP)
				local matched = {}
				for _, r in ipairs(gg.getRangesList()) do
					if r.name and r.name:lower():find("dalvik%-main space") then
						table.insert(matched, r)
					end
				end

				if #matched > 0 then
					for _, r in ipairs(matched) do
						local startAddr = tonumber(r.start) or tonumber(tostring(r.start), 16)
						local endAddr   = tonumber(r["end"]) or tonumber(tostring(r["end"]), 16)

						if startAddr and endAddr and startAddr < endAddr then
							gg.searchNumber("h05000000200000000100000003000000", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, startAddr, endAddr, 0)
							if gg.getResultCount() > 0 then
								gg.processResume()
								gg.refineNumber("32", gg.TYPE_BYTE, false, gg.SIGN_EQUAL)
								r2 = gg.getResults (1)
								if #r2 > 0 then
									local L2_0 = {}
									L2_0[1] = {address = r2[1].address + 24, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									L2_0[2] = {address = r2[1].address + 28, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									gg.setValues(L2_0)
									gg.addListItems(L2_0)
								end
								break
							end
						end
					end
				end
				gg.clearResults()
			end),
			CAbutton(
			'TANK/SUPPORT',
			function()
				gg.sleep(200)
				gg.clearResults()
				gg.setVisible(false)
				gg.setRanges(gg.REGION_JAVA_HEAP)
				local matched = {}
				for _, r in ipairs(gg.getRangesList()) do
					if r.name and r.name:lower():find("dalvik%-main space") then
						table.insert(matched, r)
					end
				end

				if #matched > 0 then
					for _, r in ipairs(matched) do
						local startAddr = tonumber(r.start) or tonumber(tostring(r.start), 16)
						local endAddr   = tonumber(r["end"]) or tonumber(tostring(r["end"]), 16)

						if startAddr and endAddr and startAddr < endAddr then
							gg.searchNumber("h 01 00 00 00 1C 00 00 00 01 00 00 00 01 00 00 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, startAddr, endAddr, 0)
							if gg.getResultCount() > 0 then
								gg.processResume()
								gg.refineNumber("28", gg.TYPE_BYTE, false, gg.SIGN_EQUAL)
								r3 = gg.getResults (1)
								if #r3 > 0 then
									local L3_0 = {}
									L3_0[1] = {address = r3[1].address + 24, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									L3_0[2] = {address = r3[1].address + 28, flags = gg.TYPE_DWORD, value = "h 7F 96 98 00"}
									gg.setValues(L3_0)
									gg.addListItems(L3_0)
								end
								break
							end
						end
					end
				end
				gg.clearResults()
			end),
		}),
		CAtext('OTHER'),
		CAcheck({
			{
				"STATUS PLAYER",
				function()
					gg.clearResults()
					gg.setVisible(false)
					d=gg.prompt({"Masukan Jumlah Move"}, {0}, {"number"})
					if d == nil then return end

					local searchPattern = "211;" .. d[1] .. ";200"
					if searchInDalvikMainSpace(searchPattern, gg.TYPE_DWORD, gg.SIGN_EQUAL) then
						gg.getResults (10)
						gg.refineAddress("D8", -1, gg.TYPE_DWORD, gg.SIGN_EQUAL)
						gg.refineNumber(d[1], gg.TYPE_DWORD, false, gg.SIGN_EQUAL)
						r = gg.getResults (1)

						if #r > 0 then
							local L0_0 = {}
							L0_0[1] = {address = r[1].address - 72, flags = gg.TYPE_DWORD, value = "999999999", freeze = true}
							L0_0[2] = {address = r[1].address + 300, flags = gg.TYPE_DWORD, value = "-999", freeze = true}
							L0_0[3] = {address = r[1].address + 304, flags = gg.TYPE_DWORD, value = "-999", freeze = true}
							gg.setValues(L0_0)
							gg.addListItems(L0_0)
							local ox = gg.prompt({"Select: [5;10000]"}, {0}, {"number"})
							if ox then
								gg.editAll(ox[1], 4)
								local t = gg.getResults(100)
								for _, v in ipairs(t) do
									v.value = ox[1]
									v.freeze = true
								end
								gg.addListItems(t)
							end
						end
					end
				end,
				function() end
			}, {
				"DUNGEON CODE",
				function()
					gg.alert('DESKRIPSI SCRIPT DUGEON\n...')
				end,
				function() end
			}, {
				"Ambil Watergun",
				function()
					gg.clearResults()
					gg.setVisible(false)
					if searchInDalvikMainSpace("964;2;1:9", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
						gg.processResume()
						gg.refineNumber("964", gg.TYPE_DWORD, false, gg.SIGN_EQUAL)
						gg.editAll("1185", gg.TYPE_DWORD)
					end
					gg.processResume()
				end,
				function() end
			},
		}),

		CAtext('Other Bonus Fiture'),

		CAswitch("WaterBoom", function()
			gg.setVisible(false)
			gg.processResume()
			if searchInDalvikMainSpace("1F;11524;16:97", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
				gg.refineNumber("11524", gg.TYPE_DWORD)
				gg.editAll("11001", gg.TYPE_DWORD)
			end
			if searchInDalvikMainSpace("1F;11522;16:97", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
				gg.refineNumber("11522", gg.TYPE_DWORD)
				gg.editAll("10308", gg.TYPE_DWORD)
			end
			gg.processResume()
		end, function()
			gg.setVisible(false)
			gg.processResume()
			if searchInDalvikMainSpace("1F;11001;16:97", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
				gg.refineNumber("11001", gg.TYPE_DWORD)
				gg.editAll("11524", gg.TYPE_DWORD)
			end
			if searchInDalvikMainSpace("1F;10308:97", gg.TYPE_DWORD, gg.SIGN_EQUAL) then
				gg.refineNumber("10308", gg.TYPE_DWORD)
				gg.editAll("11522", gg.TYPE_DWORD)
			end
			gg.processResume()
		end, 'Wajib Menggunakan Ke Dua WaterShoot Terlebih Dahulu'),

		CAswitch("Auto Buff", function()
			threadStart({run = function()
				gg.setVisible(false)
				local farmingEffectCodes = {178, 178, 134, 134, 200, 200, 432, 432, 110, 110, 111, 111, 117, 117, 253, 253, 254, 254, 369, 369, 165, 165, 442, 442, 52, 52, 51, 51}
				local xpEffectCodes = {133, 133, 157, 157, 200, 200, 222, 222, 432, 432, 192, 192, 199, 199, 197, 197, 164, 164, 216, 216, 217, 217, 555, 555, 553, 553, 545, 545, 49, 49, 50, 50, 57, 57, 202, 202}

				gg.clearResults()
				gg.setRanges(gg.REGION_JAVA_HEAP)
				searchInDalvikMainSpace("1D;-1D;1008981770D;1.0F;65793D:61", gg.TYPE_DWORD)
				local results = gg.getResults(1000)
				local offsetList = {}
				for _, v in ipairs(results) do
					table.insert(offsetList, {address = v.address + 0x60, flags = gg.TYPE_DWORD, value = 0, name = "trigger"})
				end
				gg.addListItems(offsetList)

				gg.clearResults()
				searchInDalvikMainSpace("65536;210;1:17", gg.TYPE_DWORD)
				local buffRes = gg.getResults(1)
				if #buffRes > 0 then
					buffRes[1].name = "buff"
					gg.addListItems(buffRes)
				end

				local choice = gg.choice({"📦 Farming Only", "📘 XP Only", "❌ Keluar"}, nil, "Auto Buff Menu")
				if choice and choice <= 2 then
					local effects = (choice == 1) and farmingEffectCodes or xpEffectCodes
					local list = gg.getListItems()
					local buffAddr = nil
					local trigs = {}
					for _, v in ipairs(list) do
						if v.name == "buff" then buffAddr = v.address end
						if v.name == "trigger" then table.insert(trigs, v) end
					end

					if buffAddr then
						gg.setValues({{address = buffAddr + 4, flags = gg.TYPE_DWORD, value = 1, freeze = true}, {address = buffAddr, flags = gg.TYPE_DWORD, value = 61, freeze = true}})
					end
					for _, v in ipairs(trigs) do v.value = 9876258 v.freeze = true end
					gg.setValues(trigs)

					for _, val in ipairs(effects) do
						gg.editAll(tostring(val), gg.TYPE_DWORD)
						gg.toast("✔ Efek " .. val .. " diterapkan.")
						gg.sleep(1000)
					end
				end
			end})
		end, function() end, 'Only Evade Sino'),

		CAswitch("Refresh Skill", function()
			gg.setVisible(false)
			if searchInDalvikMainSpace("3;81;20:9", gg.TYPE_DWORD) then
				gg.refineNumber("3", gg.TYPE_DWORD)
				gg.editAll("25", gg.TYPE_DWORD)
			end
		end, function()
			gg.setVisible(false)
			if searchInDalvikMainSpace("25;81;20:9", gg.TYPE_DWORD) then
				gg.refineNumber("25", gg.TYPE_DWORD)
				gg.editAll("3", gg.TYPE_DWORD)
			end
		end, 'Menu Status'),
	}, {
		--2 FARM
		CAswitch("Night Knight", function()
			local patterns = {"246;1008981770;1800;1175::50", "161;1008981770;1556;1176::50", "96;1008981770;3085;1174::50"}
			for _, p in ipairs(patterns) do
				if searchInDalvikMainSpace(p, gg.TYPE_DWORD) then
					gg.refineNumber("1008981770", gg.TYPE_DWORD)
					gg.editAll("-1", gg.TYPE_DWORD)
				end
				gg.clearResults()
			end
		end, function() end),
	}, {
		--3 VIP MENU
		CAbox({ 'TRADE GATE ITEM',
			CAbutton('TRADE SKIN', function()
				showLoginDialog("̧̡̡̻̦̭͕͉̮̤͓̤̣̮̣̰͕̤͓̲͚̝̭̣̺̣̰̞̦͜jsjjs̨̧̞͉̖̠̲̹̠̹̺͈̟̲̝̜͚̖̙͕͕̞͈̗̝͙̩̹ͅ", "/sdcard/Android/.pk", function()
					gg.toast("Trade Skin unlocked!")
				end)
			end),
			CAbutton('ACCESORIES', function()
				showLoginDialog("̧̡̡̻̦̭͕͉̮̤͓̤̣̮̣̰͕̤͓̲͚̝̭̣̺̣̰̞̦͜jsjjs̨̧̞͉̖̠̲̹̠̹̺͈̟̲̝̜͚̖̙͕͕̞͈̗̝͙̩̹ͅ", "/sdcard/Android/.pk", function()
					gg.toast("Accessories unlocked!")
				end)
			end),
			CAbutton('TRADE WEAPON', function()
				showLoginDialog("̧̡̡̻̦̭͕͉̮̤͓̤̣̮̣̰͕̤͓̲͚̝̭̣̺̣̰̞̦͜jsjjs̨̧̞͉̖̠̲̹̠̹̺͈̟̲̝̜͚̖̙͕͕̞͈̗̝͙̩̹ͅ", "/sdcard/Android/.pk", function()
					gg.toast("Weapon Trade unlocked!")
				end)
			end),
		}),
	}, {
		--4 OTHER GAME
	}, {
		--5 PENGATURAN
		CAbutton("Keluar", function() Lock.unUi() end),
	},
})

Lock.Ui(invoke, nil, function(err) print(err) end)
