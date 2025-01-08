surface.CreateFont("Overhead", {font = "Nunito Bold", extended = true, size = ScreenScale(14)})

hook.Add("PostDrawTranslucentRenderables", "DrawPlayerInfo", function()
    local localPlayer = LocalPlayer()
    local players = player.GetAll()

    for _, ply in ipairs(players) do
        if ply == localPlayer or not ply:Alive() or not ply:IsValid() then continue end

        local distance = localPlayer:GetPos():Distance(ply:GetPos())
        if distance > 150 then continue end -- Ограничение видимости по расстоянию

        local playerName = ply:getDarkRPVar("rpname") or ply:Nick()

        local boneIndex = ply:LookupBone("ValveBiped.Bip01_Head1")
        if not boneIndex then continue end

        local headPos = ply:GetBonePosition(boneIndex) or ply:GetPos()
        local displayPos = headPos + Vector(0, 0, 2.5)

        local angle = localPlayer:EyeAngles()
        angle:RotateAroundAxis(angle:Forward(), 90)
        angle:RotateAroundAxis(angle:Right(), 90)

        cam.Start3D2D(displayPos, Angle(0, angle.y, 90), 0.05)
            local PlayerName = ply:getDarkRPVar("rpname") or "Неизвестный"
            surface.SetFont("Overhead")
            local tw, th = surface.GetTextSize(PlayerName)

            local startX, startY = 100, 0

            draw.RoundedBox(8, startX, startY, tw + 50, th + 15, mi_hud.theme.base)
            draw.SimpleText(PlayerName, "Overhead", startX + 25, startY + th / 2 + 7.5, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end)
