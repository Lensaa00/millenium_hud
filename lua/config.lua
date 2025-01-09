mi_hud.config = {}

mi_hud.config.playerFOV = 75

mi_hud.config.hideHudElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudDeathNotice"] = true,
    ["CHudDamageIndicator"] = true,
    ["CHudCrosshairInfo"] = true
}

mi_hud.icons = {}
mi_hud.icons.interface = {
    hunger = Material("resource/icons/food.png", "smooth mips"),
    job = Material("resource/icons/case.png", "smooth mips"),
    money = Material("resource/icons/money.png", "smooth mips"),
    license = Material("resource/icons/license.png", "smooth mips"),
    warning = Material("resource/icons/warning.png", "smooth mips"),
    arrested = Material("resource/icons/arrested.png", "smooth mips"),
    wanted = Material("resource/icons/wanted.png", "smooth mips"),
}

mi_hud.theme = {
    base = Color(35, 45, 80),
    baseOutline = Color(56, 72, 129),
    header = Color(51, 69, 96)
}

if CLIENT then
    mi_hud.notifTypes = {
        [NOTIFY_CLEANUP] = Color(72,161,255),
        [NOTIFY_ERROR] = Color(255,60,60),
        [NOTIFY_GENERIC] = Color(255,170,60),
        [NOTIFY_HINT] = Color(72,161,255),
        [NOTIFY_UNDO] = Color(72,161,255)
    }
end

