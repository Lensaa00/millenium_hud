mi_hud.config = {}
mi_hud.icons = {}
mi_hud.theme = {}
mi_hud.rounding = 0

-- Конфигурация: Общие настройки
mi_hud.config = {
    playerFOV = 70, -- Поле зрения игрока
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
    }
}

-- Иконки: Интерфейсные
mi_hud.icons.interface = {
    hunger = Material("materials/icons/food.png", "smooth mips"),
    job = Material("materials/icons/case.png", "smooth mips"),
    money = Material("materials/icons/money.png", "smooth mips"),
    license = Material("materials/icons/license.png", "smooth mips"),
    warning = Material("materials/icons/warning.png", "smooth mips"),
    arrested = Material("materials/icons/arrested.png", "smooth mips"),
    wanted = Material("materials/icons/wanted.png", "smooth mips"),
    voice = Material("materials/icons/voice.png", "smooth mips"),
}

-- Иконки: Таблица игроков
mi_hud.icons.scoreboard = {
    network = Material("materials/millenium_hud/icons/network.png", "smooth mips"),
}

-- Темы и цвета
mi_hud.theme = {
    base = Color(46, 53, 80, 255), -- Основной цвет
    baseOutline = Color(70, 80, 122, 255), -- Обводка
    header = Color(51, 69, 96, 255), -- Заголовок
}

-- Клиентская часть
if CLIENT then
    -- Типы уведомлений
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
end
