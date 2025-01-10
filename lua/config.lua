mi_hud.config = {}
mi_hud.icons = {}
mi_hud.rounding = 0
mi_hud.config.playerFOV = 70
mi_hud.config.hideHudElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudDeathNotice"] = true,
    ["CHudDamageIndicator"] = true,
    ["CHudCrosshairInfo"] = true
}
mi_hud.icons.interface = {
    hunger = Material("resource/icons/food.png", "smooth mips"),
    job = Material("resource/icons/case.png", "smooth mips"),
    money = Material("resource/icons/money.png", "smooth mips"),
    license = Material("resource/icons/license.png", "smooth mips"),
    warning = Material("resource/icons/warning.png", "smooth mips"),
    arrested = Material("resource/icons/arrested.png", "smooth mips"),
    wanted = Material("resource/icons/wanted.png", "smooth mips"),
    voice = Material("resource/icons/voice.png", "smooth mips"),
}
mi_hud.icons.scoreboard = {
    network = Material("resource/icons/network.png", "smooth mips"),
}
mi_hud.theme = {
    base = Color(46, 53, 80),
    baseOutline = Color(70, 80, 122),
    header = Color(51, 69, 96),
}
if CLIENT then
    mi_hud.notifTypes = {
        [NOTIFY_CLEANUP] = {
            accent = Color(72,161,255),
            back = Color(29,56,85),
        },
        [NOTIFY_ERROR] = {
            accent = Color(255,60,60),
            back = Color(84,43,43)
        },
        [NOTIFY_GENERIC] = {
            accent = Color(255,222,60),
            back = Color(106,88,30, 210)
        },
        [NOTIFY_HINT] = {
            accent = Color(72,161,255),
            back = Color(29,56,85),
        },
        [NOTIFY_UNDO] = {
            accent = Color(195,195,195),
            back = Color(51,51,51),
        },
        ["NOTIFY_DARKRP"] = {
            accent = Color(195,195,195),
            back = Color(51,51,51),
        }
    }
end
