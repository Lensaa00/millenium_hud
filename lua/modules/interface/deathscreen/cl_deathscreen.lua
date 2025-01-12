local function SetupFonts()
    surface.CreateFont("DeathScreen.Main", {font = "Montserrat Bold", extended = true, size = ScreenScale(15)})
    surface.CreateFont("DeathScreen.Main.Shadow", {font = "Montserrat Bold", extended = true, blursize = 10, size = ScreenScale(15)})
    surface.CreateFont("DeathScreen.Second", {font = "Montserrat", extended = true, size = ScreenScale(8)})
    surface.CreateFont("DeathScreen.Second.Shadow", {font = "Montserrat", extended = true, blursize = 5, size = ScreenScale(8)})
end

SetupFonts()

local function DrawBlur( amount )
    local blurMaterial = Material("pp/blurscreen")
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(blurMaterial)

    for i = 1, 5 do
        blurMaterial:SetFloat("$blur", i * amount) -- Интенсивность размытия
        blurMaterial:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end
end

function mi_hud.DeathScreen()
    if LocalPlayer():Alive() then return end
    local scrw, scrh = ScrW(), ScrH()

    local Player = LocalPlayer()
    local PDeathTime = Player:GetNWInt("DeathTime")

    surface.SetFont("DeathScreen.Main")
    local tw, th = surface.GetTextSize("Вы мертвы")

    local panelW = tw
    local panelH = th

    local panelX, panelY = scrw / 2, scrh * .8

    DrawBlur( 1.2 )

    draw.RoundedBox(0, 0, 0, scrw, scrh, Color(0,0,0,200))

    local timeLeft = math.Round(GAMEMODE.Config.respawntime - (CurTime() - PDeathTime))

    draw.SimpleText("Вы мертвы!", "DeathScreen.Main.Shadow", panelX, panelY, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Вы мертвы!", "DeathScreen.Main", panelX, panelY, Color(255,162,162), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


    if timeLeft >= 0 then
        draw.SimpleText("До возрождения: " .. timeLeft, "DeathScreen.Second.Shadow", panelX, panelY + scrh * .025, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("До возрождения: " .. timeLeft, "DeathScreen.Second", panelX, panelY + scrh * .025, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("Нажмите ЛКМ, чтобы возродиться", "DeathScreen.Second.Shadow", panelX, panelY + scrh * .025, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Нажмите ЛКМ, чтобы возродиться", "DeathScreen.Second", panelX, panelY + scrh * .025, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end
