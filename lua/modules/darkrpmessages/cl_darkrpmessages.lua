local messages = messages or {}
local isDisplaying = false

surface.CreateFont("MessageText", {font = "Nunito Bold", extended = true, size = ScreenScale(7), })

-- Функция для отображения одного сообщения
local function displayNextMessage()
    if isDisplaying or #messages == 0 then return end

    isDisplaying = true
    local text = table.remove(messages, 1) -- Берем первое сообщение из очереди

    -- Рассчитываем размеры панели
    surface.SetFont("MessageText")
    local panelW, panelH = surface.GetTextSize(text)
    panelW = panelW + ScreenScale(20)
    panelH = panelH + 20

    local scrw, scrh = ScrW(), ScrH()

    local panel = vgui.Create("DPanel")
    panel:SetSize(panelW, panelH)
    panel:SetPos(scrw / 2 - panelW / 2, scrh * 0.1)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.25, 0)
    panel.Paint = function(me, w, h)
        draw.RoundedBox(8, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.RoundedBox(8, 1, 1, w - 2, h - 2, mi_hud.theme.base)
        surface.SetDrawColor(255, 69, 69)
        surface.SetMaterial(mi_hud.icons.interface.warning)
        surface.DrawTexturedRect(10, 10, h - 20, h - 20)
        draw.SimpleText(text, "MessageText", 45, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Убираем сообщение через 7 секунд
    timer.Simple(5, function()
        if IsValid(panel) then
            panel:AlphaTo(0, 0.25, 0, function()
                panel:Remove()
                isDisplaying = false
                displayNextMessage() -- Переходим к следующему сообщению
            end)
        else
            isDisplaying = false
            displayNextMessage()
        end
    end)
end

-- Добавляем сообщение в очередь
function addMessageToQueue(text)
    table.insert(messages, text)
    displayNextMessage() -- Проверяем, можно ли сразу начать отображение
end

-- Получаем сообщение с сервера
net.Receive("ShowDarkRPMessage", function()
    local text = net.ReadString()
    addMessageToQueue(text)
end)
