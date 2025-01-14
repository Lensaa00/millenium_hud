surface.CreateFont("Overhead", {font = "Montserrat", extended = true, size = ScreenScale(15)})

local playerAlpha = {} -- Таблица для хранения прозрачности для каждого игрока

hook.Add("PostDrawTranslucentRenderables", "millenium.overhead.draw", function()
    local localPlayer = LocalPlayer()
    local players = player.GetAll()

    for _, ply in ipairs(players) do
        if ply == localPlayer or not ply:Alive() or not ply:IsValid() then continue end

        local distance = localPlayer:GetPos():Distance(ply:GetPos())

        -- Порог видимости
        local maxDistance = 150
        local fadeDistance = 120 -- Дистанция, на которой начнётся уменьшение прозрачности

        -- Если игрок не в зоне видимости, задаём прозрачность как 0
        if distance > maxDistance then
            playerAlpha[ply] = Lerp(FrameTime() * 10, playerAlpha[ply] or 0, 0)
            continue
        end

        -- Вычисление прозрачности
        local alpha = 255
        if distance > fadeDistance then
            alpha = math.Clamp(255 - ((distance - fadeDistance) / (maxDistance - fadeDistance)) * 255, 0, 255)
        end

        -- Плавный переход прозрачности
        playerAlpha[ply] = Lerp(FrameTime() * 10, playerAlpha[ply] or 0, alpha)

        -- Игнорируем полностью прозрачные панели
        if playerAlpha[ply] <= 0 then continue end

        local playerName = ply:getDarkRPVar("rpname") or ply:Nick()

        local boneIndex = ply:LookupBone("ValveBiped.Bip01_Head1")
        if not boneIndex then continue end

        local headPos = ply:GetBonePosition(boneIndex) or ply:GetPos()
        local displayPos = headPos + Vector(0, 0, 2)

        local angle = localPlayer:EyeAngles()
        angle:RotateAroundAxis(angle:Forward(), 90)
        angle:RotateAroundAxis(angle:Right(), 90)

        cam.Start3D2D(displayPos, Angle(0, angle.y, 90), 0.06)
            local hasLicense = ply:getDarkRPVar("HasGunlicense")
            local arrested = ply:getDarkRPVar("Arrested")
            local wanted = ply:getDarkRPVar("wanted")
            local speaking = ply:IsSpeaking()

            surface.SetFont("Overhead")
            local tw, th = surface.GetTextSize(playerName)

            local iconSize = 30
            local iconPadding = 7
            local numIcons = (speaking and 1 or 0) + (hasLicense and 1 or 0) + (arrested and 1 or 0) + (wanted and 1 or 0)
            local panelW = tw + ScreenScale(13) + (numIcons * iconSize) + ((numIcons - 1) * iconPadding)
            local panelH = math.max(th + 15, iconSize)

            local startX, startY =  125, - panelH / 2

            -- Применяем прозрачность
            local panelColor = Color(mi_hud.theme.base.r, mi_hud.theme.base.g, mi_hud.theme.base.b, playerAlpha[ply])
            local outlineColor = Color(mi_hud.theme.baseOutline.r, mi_hud.theme.baseOutline.g, mi_hud.theme.baseOutline.b, playerAlpha[ply])
            local textColor = Color(255, 255, 255, playerAlpha[ply])

            draw.RoundedBox(mi_hud.rounding, startX - 1, startY - 1, panelW + 2, panelH + 2, outlineColor)
            draw.RoundedBox(mi_hud.rounding, startX, startY, panelW, panelH, panelColor)

            local textX = startX + ScreenScale(5)
            local textY = startY + (panelH / 2)
            draw.SimpleText(playerName, "Overhead", textX, textY, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local iconX = textX + tw + 10
            local iconY = startY + (panelH - iconSize) / 2

            if speaking then
                surface.SetDrawColor(255, 255, 255, playerAlpha[ply])
                surface.SetMaterial(mi_hud.icons.interface.voice)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                iconX = iconX + iconSize + iconPadding
            end

            if hasLicense then
                surface.SetDrawColor(118, 184, 255, playerAlpha[ply])
                surface.SetMaterial(mi_hud.icons.interface.license)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                iconX = iconX + iconSize + iconPadding
            end

            if arrested then
                surface.SetDrawColor(255, 148, 99, playerAlpha[ply])
                surface.SetMaterial(mi_hud.icons.interface.arrested)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                iconX = iconX + iconSize + iconPadding
            end

            if wanted then
                surface.SetDrawColor(255, 81, 81, playerAlpha[ply])
                surface.SetMaterial(mi_hud.icons.interface.wanted)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
            end
        cam.End3D2D()
    end
end)

mi_hud:Log("[Overhead] Загружен")
