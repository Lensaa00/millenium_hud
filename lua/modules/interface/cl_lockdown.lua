surface.CreateFont("mi.hud.lockdown", {font = "Montserrat", extended = true, size = ScreenScale(7), antialias = true})
surface.CreateFont("mi.hud.lockdown.shadow", {font = "Montserrat", extended = true, blursize = 2, size = ScreenScale(7), antialias = true})

function mi_hud.elements:Lockdown()
    local scrw, scrh = ScrW(), ScrH()
    if GetGlobalBool("DarkRP_LockDown", false) then
        local lines = {
            "Мэр ввел комендантский час.",
            "Пожалуйста, возвращайтесь по домам"
        }

        draw.SimpleText(lines[1], "mi.hud.lockdown.shadow", scrw / 2, scrh * .02 + 1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(lines[2], "mi.hud.lockdown.shadow", scrw / 2, scrh * .035 + 1, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(lines[1], "mi.hud.lockdown", scrw / 2, scrh * .02, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(lines[2], "mi.hud.lockdown", scrw / 2, scrh * .035, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end
