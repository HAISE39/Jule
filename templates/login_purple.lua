-- Modern Stylish Purple ELGG Login Script
-- Author: Jules (Assistant)

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

context = activity
window = context.getSystemService("window")
if Build.VERSION.SDK_INT >= 26 then
    windowtype = 2038
else
    windowtype = 2003
end

-- Theme Palette
local theme_bg = "#FF0A0A0A"
local theme_card = "#FF1A1A1A"
local theme_accent = "#FFBB86FC"
local theme_accent_light = "#FFD0BCFF"
local theme_text = "#FFFFFFFF"
local theme_input_bg = "#FF2C2C2C"

function threadStart(runnable)
    local newRun = luajava.createProxy("java.lang.Runnable", runnable)
    local subThread = luajava.newInstance("java.lang.Thread", newRun)
    subThread:start()
    return subThread
end

function getShapeBackground(color, radius)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    if type(color) == "string" then
        drawable.setColor(Color.parseColor(color))
    else
        drawable.setColor(color)
    end
    drawable.setCornerRadii({ radius, radius, radius, radius, radius, radius, radius, radius })
    return drawable
end

function miaobian(stroke_width, radius, bg_color, stroke_color)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(Color.parseColor(bg_color))
    drawable.setCornerRadii({ radius, radius, radius, radius, radius, radius, radius, radius })
    drawable.setStroke(stroke_width, Color.parseColor(stroke_color))
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
            layout_width = "200dp",
            layout_height = "320dp",
            Elevation = '20dp',
            radius = '20',
            CardBackgroundColor = theme_card,
            {
                LinearLayout,
                layout_width = -1,
                layout_height = -1,
                gravity = "center",
                orientation = "vertical",
                padding = "10dp",
                {
                    CardView,
                    layout_width = "100dp",
                    layout_height = "100dp",
                    layout_margin = "15dp",
                    CardBackgroundColor = "#00FFFFFF",
                    radius = '50', -- Circular
                    Elevation = "0dp",
                    {
                        ImageView,
                        layout_width = -1,
                        layout_height = -1,
                        scaleType = "centerCrop",
                        id = "pic",
                    },
                },
                {
                    TextView,
                    text = "Welcome Back",
                    textColor = theme_accent,
                    textSize = "18sp",
                    textStyle = "bold",
                    layout_marginBottom = "10dp",
                },
                {
                    EditText,
                    layout_width = -1,
                    layout_margin = "5dp",
                    layout_height = "45dp",
                    background = miaobian(2, 25, theme_input_bg, theme_accent),
                    textColor = Color.parseColor(theme_text),
                    paddingLeft = "15dp",
                    paddingRight = "15dp",
                    inputType = "textPassword",
                    hint = "Password",
                    hintTextColor = 0xFFAAAAAA,
                    id = "edit",
                },
                {
                    TextView,
                    layout_width = -1,
                    layout_marginTop = "15dp",
                    layout_height = "45dp",
                    text = "LOGIN",
                    gravity = "center",
                    textSize = "16sp",
                    textColor = 0xFF000000,
                    textStyle = "bold",
                    background = getShapeBackground(theme_accent, 25),
                    onClick = function()
                        local input = edit.getText().toString()
                        -- Original password verification logic
                        if input == "̧̡̡̨̧̻̦̭͕͉̮̤͓̤̣̮̣̰͕̤͓̲͚̝̭̣̺̣̰̞̦͕̖͇̗͈̞̲̙̘̖̞͉̖̠̲̹̠̹̺͈̟̲̝̜͚̖̙͕͕̞͈̗̝͙̩̹͜ͅ" then
                            dlg_create.dismiss()
                            print("Access Granted")
                            luajava.exit()
                        else
                            print("Access Denied")
                        end
                    end,
                },
            },
        },
    })

    threadStart({
        run = function()
            bit1 = loadbitmap("http://q1.qlogo.cn/g?b=qq&nk=2843833170&s=640")
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
