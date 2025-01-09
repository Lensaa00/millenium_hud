surface.CreateFont("Interact", {font = "Nunito", extended = true, size = ScreenScale(9)})

function InteractPanel()
    local scrw, scrh = ScrW(), ScrH()

    local Player = LocalPlayer()
    local PTarget = Player:GetEyeTrace().Entity

    local PlayerPos = Player:GetPos()
    local TargetPos = PTarget:GetPos()

    local distance = PlayerPos:Distance(TargetPos)

    surface.SetFont("Interact")

    local tw, th = surface.GetTextSize("( E ) Взаимодействие")

    local panelW, panelH = tw + scrw * .025, th + scrh * .01
    local posX = scrw / 2 - panelW / 2
    local posY = scrh / 2 - panelH / 2 + scrh * .2

    if PTarget:IsPlayer() && distance <= 100 then
        draw.RoundedBox(8, posX, posY, panelW, panelH, mi_hud.theme.base)
        draw.SimpleText("( E ) Взаимодействие", "Interact", posX + panelW / 2, posY + panelH / 2, Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end

-- hook.Add("HUDPaint", "millenium.interact.draw", InteractPanel)
