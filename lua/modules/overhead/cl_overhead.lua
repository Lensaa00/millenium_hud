surface.CreateFont("Overhead", {font = "Nunito Bold", extended = true, size = ScreenScale(14)})

hook.Add("PostDrawTranslucentRenderables", "DrawPlayerInfo", function()
    local localPlayer = LocalPlayer()
    local players = player.GetAll()

    for _, ply in ipairs(players) do
        if ply == localPlayer or not ply:Alive() or not ply:IsValid() then continue end
        if localPlayer:GetEyeTrace().Entity ~= ply then continue end

        local distance = localPlayer:GetPos():Distance(ply:GetPos())
        if distance > 150 then continue end

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

            draw.RoundedBox(mi_hud.rounding, startX - 1, startY - 1, panelW + 2, panelH + 2, mi_hud.theme.baseOutline)
            draw.RoundedBox(mi_hud.rounding, startX, startY, panelW, panelH, mi_hud.theme.base)

            local textX = startX + ScreenScale(5)
            local textY = startY + (panelH / 2)
            draw.SimpleText(playerName, "Overhead", textX, textY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local iconX = textX + tw + 10
            local iconY = startY + (panelH - iconSize) / 2

            if speaking then
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mi_hud.icons.interface.voice)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                iconX = iconX + iconSize + iconPadding
            end

            if hasLicense then
                surface.SetDrawColor(118, 184, 255)
                surface.SetMaterial(mi_hud.icons.interface.license)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                iconX = iconX + iconSize + iconPadding
            end

            if arrested then
                surface.SetDrawColor(255, 148, 99)
                surface.SetMaterial(mi_hud.icons.interface.arrested)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                iconX = iconX + iconSize + iconPadding
            end

            if wanted then
                surface.SetDrawColor(255, 81, 81)
                surface.SetMaterial(mi_hud.icons.interface.wanted)
                surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
            end
        cam.End3D2D()
    end
end)
