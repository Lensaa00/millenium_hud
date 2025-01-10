surface.CreateFont("Notification", {font = 'Nunito', extended = true, size = ScreenScale(6.5)})

local notifications = notifications or {}
local maxMessages = 5

local function CopyColor(color)
    return Color(color.r, color.g, color.b, color.a)
end

function Notification(text, type, length)
    surface.SetFont("Notification")
    local scrw, scrh = ScrW(), ScrH()
    local tw, th = surface.GetTextSize(text)
    local padding = ScreenScale(5)

    local panel = vgui.Create("DPanel")
    panel:SetSize(tw + padding * 2, th + padding)
    panel:SetPos(scrw - panel:GetWide() - 10, scrh + panel:GetTall())
    panel.NotifTime = CurTime()
    panel.Paint = function(me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.notifTypes[type].back)
        draw.RoundedBox(0, 0, h - h * .07, w, h * .15, Color(0,0,0,100))
        draw.RoundedBox(0, 0, h - h * .07, w - w / length * (CurTime() - me.NotifTime), h * .15, mi_hud.notifTypes[type].accent)
        draw.SimpleText(text, "Notification", w / 2, h / 2 - h * .07, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    table.insert(notifications, panel)

    local function UpdatePositions()
        local currentY = scrh - scrh * .02
        for i = #notifications, 1, -1 do
            local notif = notifications[i]
            if IsValid(notif) then
                notif:MoveTo(scrw - notif:GetWide() - 10, currentY - notif:GetTall(), .8, 0, .1)
                currentY = currentY - notif:GetTall() - scrh * .003
            end
        end
    end

    while #notifications > maxMessages do
        local oldPanel = table.remove(notifications, 1)
        if IsValid(oldPanel) then
            local x, y = oldPanel:GetPos()
            oldPanel:AlphaTo(0, .2, 0)
            oldPanel:MoveTo(x, y - oldPanel:GetTall() - 10, 1, 0, .1, function ()
                if IsValid(oldPanel) then
                    oldPanel:Remove()
                end
            end)
        end
    end

    UpdatePositions()

    timer.Simple(length, function()
        if IsValid(panel) then
            local panelX, panelY = panel:GetPos()
            table.RemoveByValue(notifications, panel)
            UpdatePositions()
            panel:MoveTo(scrw + panel:GetWide(), panelY, .5, 0, 4, function ()
                panel:Remove()
            end)

        end
    end)
end

usermessage.Hook("_Notify", function (msg)
    local text = msg:ReadString()
    Notification( text , "NOTIFY_DARKRP", 7)
end)

function notification.AddLegacy(text, type, length)
    Notification(text, type, length)
end
