surface.CreateFont("Notification", {font = 'Nunito Bold', extended = true, size = ScreenScale(7)})

local notifications = notifications or {}
local maxMessages = 4

local function CopyColor(color)
    return Color(color.r, color.g, color.b, color.a)
end

function Notification(text, type, length)
    surface.SetFont("Notification")
    if length < 5 then length = 5 end
    local scrw, scrh = ScrW(), ScrH()
    local tw, th = surface.GetTextSize(text)
    local padding = ScreenScale(3)

    local panel = vgui.Create("DPanel")
    panel:SetSize(tw + padding * 4, ScreenScale(12))
    panel:SetPos(scrw - panel:GetWide() - 10, scrh)
    panel:SetAlpha(0)
    panel.Paint = function(me, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, mi_hud.theme.baseOutline, false, false, false, false)
        draw.RoundedBoxEx(8, 1, 1, w - 2, h - 2, mi_hud.theme.base, false, false, false, false)
        draw.RoundedBoxEx(8, 0, 0, scrw * .002, h, mi_hud.notifTypes[type] or Color(255, 255, 255), false, false, false, false)
        draw.SimpleText(text, "Notification", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    table.insert(notifications, panel)

    while #notifications > maxMessages do
        local oldPanel = table.remove(notifications, 1)
        if IsValid(oldPanel) then
            local x, y = oldPanel:GetPos()
            oldPanel:AlphaTo(0, 0.25, 0)
            oldPanel:MoveTo(x, y - oldPanel:GetTall() - 20, 1.5, 0, .1, function ()
                if IsValid(oldPanel) then
                    oldPanel:Remove()
                end
            end)
        end
    end

    local function UpdatePositions()
        local currentY = scrh - 10
        for i = #notifications, 1, -1 do
            local notif = notifications[i]
            if IsValid(notif) then
                notif:AlphaTo(255, .25, 0)
                notif:MoveTo(scrw - notif:GetWide() - 10, currentY - notif:GetTall(), 1.5, 0, 0.1)
                currentY = currentY - notif:GetTall() - scrh * .005
            end
        end
    end

    UpdatePositions()

    timer.Simple(length, function()
        if IsValid(panel) then
            panel:AlphaTo(0, 0.25, 0, function()
                if IsValid(panel) then
                    panel:Remove()
                end
                table.RemoveByValue(notifications, panel)
                UpdatePositions()
            end)
        end
    end)
end

usermessage.Hook("_Notify", function (msg)
    local text = msg:ReadString()
    Notification( text , NOTIFY_GENERIC, 7)
end)

function notification.AddLegacy(text, type, length)
    Notification(text, type, length)
end
