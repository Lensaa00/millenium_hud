util.AddNetworkString("ShowDarkRPMessage")

-- Функция отправки сообщения на клиент
local function SendDarkRPMessage(text)
    net.Start("ShowDarkRPMessage")
    net.WriteString(text)
    net.Broadcast()
end

-- Функция получения имени игрока
local function GetRPName(player)
    return player:getDarkRPVar("rpname") or "Неизвестный игрок"
end

-- Хук розыска
hook.Add("playerWanted", "WantedHook", function(criminal, actor, reason)
    local text = string.format("%s розыскивается полицией!", GetRPName(criminal))
    SendDarkRPMessage(text)
end)

-- Хук отмены розыска
hook.Add("playerUnWanted", "UnWantedHook", function(criminal, actor)
    local text = string.format("%s больше не розыскивается полицией.", GetRPName(criminal))
    SendDarkRPMessage(text)
end)

-- Хук ареста
hook.Add("playerArrested", "ArrestedHook", function(criminal, time, actor)
    if criminal:GetNWInt("ArrestTime") ~= 0 then return end
    local arrestMonths = time / Realistic_Police.DayEqual
    -- local text = string.format("\"%s\" был арестован! Месяцев: %d.", GetRPName(criminal), arrestMonths)
    local text = string.format("%s был арестован!", GetRPName(criminal))
    SendDarkRPMessage(text)
end)

-- Хук отмены ареста
hook.Add("playerUnArrested", "UnArrestedHook", function(criminal, actor)
    local text = string.format("%s был выпущен из тюрьмы.", GetRPName(criminal))
    SendDarkRPMessage(text)
end)

-- Хук выдачи ордера
hook.Add("playerWarranted", "WarrantHook", function(criminal, actor)
    local text = string.format("Полиция получила ордер на обыск %s.", GetRPName(criminal))
    SendDarkRPMessage(text)
end)

-- Хук отмены ордера
hook.Add("playerUnWarranted", "UnWarrantHook", function(criminal, actor)
    local text = string.format("Ордер на обыск %s был аннулирован.", GetRPName(criminal))
    SendDarkRPMessage(text)
end)
