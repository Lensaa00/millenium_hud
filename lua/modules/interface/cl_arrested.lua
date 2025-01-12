function mi_hud.elements:Arrested()
    local scrw, scrh = ScrW(), ScrH()

    local Player = LocalPlayer()
    local PArrested = Player:getDarkRPVar("Arrested") -- Флаг ареста

    if PArrested then
        local arrestTime = Player:GetNWInt("ArrestTime") or 0 -- Время ареста
        local timeLeft = math.max(0, math.floor(arrestTime - CurTime())) -- Счетчик времени

        -- Размеры текста
        surface.SetFont("Mi6")
        local tw, th = surface.GetTextSize("Вы арестованы! Осталось: " .. timeLeft .. " сек.")

        -- Размеры панели
        local panelW = tw + scrw * .02
        local panelH = th + 7

        -- Размер иконки
        local iconSize = panelH * .6

        -- Позиция панели
        local panelX = scrw / 2 - panelW / 2
        local panelY = scrh * .90 - panelH / 2

        -- Панель
        draw.RoundedBox(mi_hud.rounding, panelX, panelY + 2, panelW, panelH, Color(255, 148, 99))
        draw.RoundedBox(mi_hud.rounding, panelX, panelY, panelW, panelH, mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, panelX + 1, panelY + 1, panelW - 2, panelH - 2, mi_hud.theme.base)

        -- Иконка
        surface.SetDrawColor(255, 148, 99)
        surface.SetMaterial(mi_hud.icons.interface.arrested)
        surface.DrawTexturedRect(panelX + 7, panelY + panelH / 2 - iconSize / 2, iconSize, iconSize)

        -- Текст
        draw.SimpleText("Вы арестованы! Осталось: " .. timeLeft .. " сек.", "Mi6", panelX + 7 + iconSize + 7, panelY + panelH / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end
