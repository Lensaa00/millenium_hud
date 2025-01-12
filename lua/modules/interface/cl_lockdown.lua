function mi_hud.elements:Lockdown()
    if GetGlobalBool("DarkRP_LockDown", false) then
        local lines = {
            "Мэр ввел комендантский час.",
            "Пожалуйста, возвращайтесь по домам"
        }

        draw.SimpleText(lines[1], "Mi6Shadow", scrw / 2, scrh * .02 + 2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(lines[2], "Mi6Shadow", scrw / 2, scrh * .035 + 2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(lines[1], "Mi6", scrw / 2, scrh * .02, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(lines[2], "Mi6", scrw / 2, scrh * .035, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end
