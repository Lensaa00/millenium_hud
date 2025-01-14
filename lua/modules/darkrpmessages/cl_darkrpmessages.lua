local messages = messages or {}
local isDisplaying = false

surface.CreateFont("MessageText", {font = "Montserrat", extended = true, size = ScreenScale(6)})

local function displayNextMessage()
    if isDisplaying or #messages == 0 then return end

    isDisplaying = true
    local text = table.remove(messages, 1)

    local scrw, scrh = ScrW(), ScrH()

    surface.SetFont("MessageText")
    local tw, th = surface.GetTextSize(text)
    panelW = tw + ScreenScale(13)
    panelH = th + 10

    local iconSize = panelH * .6

    local panelX, panelY = scrw / 2 - panelW / 2, scrh * 0.1

    local panel = vgui.Create("DPanel")
    panel:SetSize(panelW, panelH)
    panel:SetPos(panelX, panelY)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.25, 0)
    panel.Paint = function(me, w, h)
        -- Панель
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, 1, 1, w - 2, h -2, mi_hud.theme.base)
        -- Иконка
        surface.SetDrawColor(255,111,111)
        surface.SetMaterial(mi_hud.icons.interface.warning)
        surface.DrawTexturedRect(iconSize / 2, h / 2 - iconSize / 2 + 1, iconSize, iconSize)
        -- Текст
        draw.SimpleText(text, "MessageText", iconSize + ScreenScale(4), h / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    timer.Simple(5, function()
        if IsValid(panel) then
            panel:AlphaTo(0, 0.25, 0, function()
                panel:Remove()
                isDisplaying = false
                displayNextMessage()
            end)
        else
            isDisplaying = false
            displayNextMessage()
        end
    end)
end

function addMessageToQueue(text)
    table.insert(messages, text)
    displayNextMessage()
end

net.Receive("ShowDarkRPMessage", function()
    local text = net.ReadString()
    addMessageToQueue(text)
end)

mi_hud:Log("[DarkRP Messages] Загружен")
