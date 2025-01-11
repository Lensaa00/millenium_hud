surface.CreateFont("Notification", {font = "Nunito", extended = true, size = ScreenScale(6)})

local notifications = notifications or {}
local maxMessages = 5
local scrw, scrh = ScrW(), ScrH()
local padding = ScreenScale(5)

local function CreateNotificationPanel(text, type, length)
    surface.SetFont("Notification")
    local tw, th = surface.GetTextSize(text)

    local panel = vgui.Create("DPanel")
    panel:SetSize(tw + padding * 2, th + padding)
    panel:SetPos(scrw - panel:GetWide() - 10, scrh + panel:GetTall())
    panel.NotifTime = CurTime()

    panel.Paint = function(self, w, h)
        local notifType = mi_hud.notifTypes[type]
        local progress = math.Clamp((CurTime() - self.NotifTime) / length, 0, 1)

        draw.RoundedBox(0, 0, 0, w, h, notifType.back)
        draw.RoundedBox(0, 0, h - h * 0.07, w, h * 0.15, Color(0, 0, 0, 100))
        draw.RoundedBox(0, 0, h - h * 0.07, w * (1 - progress), h * 0.15, notifType.accent)
        draw.SimpleText(text, "Notification", w / 2, h / 2 - h * 0.07, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    return panel
end

local function UpdateNotificationPositions()
    local currentY = scrh - scrh * 0.02

    for i = #notifications, 1, -1 do
        local notif = notifications[i]
        if IsValid(notif) then
            notif:MoveTo(scrw - notif:GetWide() - 10, currentY - notif:GetTall(), 0.8, 0, 0.1)
            currentY = currentY - notif:GetTall() - scrh * 0.003
        end
    end
end

local function RemoveOldNotifications()
    while #notifications > maxMessages do
        local oldPanel = table.remove(notifications, 1)
        if IsValid(oldPanel) then
            oldPanel:AlphaTo(0, 0.2, 0)
            oldPanel:MoveTo(oldPanel.x, oldPanel.y - oldPanel:GetTall() - 10, 1, 0, 0.1, function()
                if IsValid(oldPanel) then
                    oldPanel:Remove()
                end
            end)
        end
    end
end

function Notification(text, type, length)
    local panel = CreateNotificationPanel(text, type, length)
    table.insert(notifications, panel)

    RemoveOldNotifications()
    UpdateNotificationPositions()

    timer.Simple(length, function()
        if IsValid(panel) then
            local panelX, panelY = panel:GetPos()
            table.RemoveByValue(notifications, panel)
            UpdateNotificationPositions()
            panel:MoveTo(scrw + panel:GetWide(), panelY, 0.5, 0, 4, function()
                if IsValid(panel) then
                    panel:Remove()
                end
            end)
        end
    end)
end

usermessage.Hook("_Notify", function(msg)
    Notification(msg:ReadString(), "NOTIFY_DARKRP", 7)
end)

function notification.AddLegacy(text, type, length)
    Notification(text, type, length)
end
