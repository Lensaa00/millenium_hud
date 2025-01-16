mi_hud.config = {}
mi_hud.icons = {}
mi_hud.theme = {}
mi_hud.ammo = {}
mi_hud.scoreboard = {}
mi_hud.rounding = 0
mi_hud.drawDistance = 150

--[[======================
КОНФИГУРАЦИЯ
==========================]]
mi_hud.config = {
    playerFOV = 75, -- Поле зрения игрока
    hideHudElements = { -- Скрываемые элементы HUD
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["CHudDeathNotice"] = true,
        ["CHudDamageIndicator"] = true,
        ["CHudCrosshairInfo"] = true,
        ["DarkRP_HUD"] = true,
        ["DarkRP_LocalPlayerHUD"] = true,
        ["DarkRP_ArrestedHUD"] = true,
        ["DarkRP_ChatReceivers"] = true,
        ["DarkRP_Hungermod"] = true,
        ["CHudWeaponSelection"] = true,
        ["CHudAmmo"] = true,
    }
}

mi_hud.ammo.blacklist = {
    ["weapon_physgun"] = true,
    ["weapon_physcannon"] = true,
    ["weapon_fists"] = true,
    ["keys"] = true,
    ["itemstore_pickup"] = true,
    ["gmod_tool"] = true,
    ["weapon_rpt_handcuff"] = true,
    ["unarrest_stick"] = true,
    ["weaponchecker"] = true,
    ["door_ram"] = true,
    ["weapon_uni_cracker"] = true,
    ["lockpick"] = true,
    ["med_kit"] = true,

}


--[[======================
ИКОНКИ
==========================]]
-- Худ
mi_hud.icons.interface = {
    hunger = Material("materials/millenium_hud/icons/food.png", "smooth mips"),
    job = Material("materials/millenium_hud/icons/case.png", "smooth mips"),
    money = Material("materials/millenium_hud/icons/money.png", "smooth mips"),
    license = Material("materials/millenium_hud/icons/license.png", "smooth mips"),
    warning = Material("materials/millenium_hud/icons/warning.png", "smooth mips"),
    arrested = Material("materials/millenium_hud/icons/arrested.png", "smooth mips"),
    wanted = Material("materials/millenium_hud/icons/wanted.png", "smooth mips"),
    voice = Material("materials/millenium_hud/icons/voice.png", "smooth mips"),
}

-- Таблица игроков
mi_hud.icons.scoreboard = {
    network = Material("materials/millenium_hud/icons/network.png", "smooth mips"),
}

-- Клиентская часть
if not CLIENT then return end

--[[======================
УВЕДОМЛЕНИЯ
==========================]]

mi_hud.notifTypes = {
    [NOTIFY_CLEANUP] = {
        accent = Color(72, 161, 255), -- Акцентный цвет
        back = Color(29, 56, 85), -- Фон уведомления
    },
    [NOTIFY_ERROR] = {
        accent = Color(255, 60, 60),
        back = Color(84, 43, 43),
    },
    [NOTIFY_GENERIC] = {
        accent = Color(255, 222, 60),
        back = Color(106, 88, 30, 210),
    },
    [NOTIFY_HINT] = {
        accent = Color(72, 161, 255),
        back = Color(29, 56, 85),
    },
    [NOTIFY_UNDO] = {
        accent = Color(195, 195, 195),
        back = Color(51, 51, 51),
    },
    ["NOTIFY_DARKRP"] = {
        accent = Color(195, 195, 195),
        back = Color(51, 51, 51),
    },
}

--[[======================
ТЕМЫ
==========================]]

-- Тема худа
mi_hud.theme = {
    base = Color(46, 53, 80, 255), -- Основной цвет
    accent = Color(24, 116, 255),
    baseOutline = Color(70, 80, 122, 255), -- Обводка
    header = Color(51, 69, 96, 255), -- Заголовок
}

-- Тема таба
mi_hud.scoreboard.theme = {
    base = Color(34, 38, 56, 230), -- Основной цвет
    panel = Color(55, 62, 90, 230), -- Основной цвет
    baseOutline = Color(70, 80, 122, 230), -- Обводка
    outline = Color(70, 80, 122, 255), -- Обводка
    header = Color(70, 80, 122, 230), -- Заголовок
    text = Color(255,255,255), -- Цвет текста
}
