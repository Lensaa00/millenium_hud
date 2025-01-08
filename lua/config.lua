mi_hud.config = {}

mi_hud.config.hideHudElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudDeathNotice"] = true,
    ["CHudDamageIndicator"] = true
}

mi_hud.icons = {}
mi_hud.icons.interface = {
    hunger = Material("resource/icons/food.png", "smooth mips"),
    job = Material("resource/icons/case.png", "smooth mips"),
    money = Material("resource/icons/money.png", "smooth mips"),
    license = Material("resource/icons/license.png", "smooth mips"),
}

if CLIENT then
    mi_hud.notifTypes = {
        [NOTIFY_CLEANUP] = Color(72,161,255),
        [NOTIFY_ERROR] = Color(255,60,60),
        [NOTIFY_GENERIC] = Color(255,138,60),
        [NOTIFY_HINT] = Color(72,161,255),
        [NOTIFY_UNDO] = Color(72,161,255)
    }
end
