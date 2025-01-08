util.AddNetworkString("ShowDarkRPMessage")

hook.Add("playerWanted", "WantedHook", function (criminal, actor, reason)
    local text = "\"" .. criminal:getDarkRPVar("rpname") .. "\" розыскивается полицией!"
    net.Start("ShowDarkRPMessage")
        net.WriteString(text)
    net.Broadcast()
    return
end)

hook.Add("playerUnWanted", "UnWantedHook", function (criminal, actor)
    local text = "\"" .. criminal:getDarkRPVar("rpname") .. "\" больше не розыскивается полицией."
    net.Start("ShowDarkRPMessage")
        net.WriteString(text)
    net.Broadcast()
    return
end)

hook.Add("playerArrested", "ArrestedHook", function (criminal, time, actor)
    local text = "\"" .. criminal:getDarkRPVar("rpname") .. "\" был арестован на " .. time .. " секунд."
    net.Start("ShowDarkRPMessage")
        net.WriteString(text)
    net.Broadcast()
    return
end)

hook.Add("playerUnArrested", "UnArrestedHook", function (criminal, actor)
    local text = "\"" .. criminal:getDarkRPVar("rpname") .. "\" был выпущен из тюрьмы."
    net.Start("ShowDarkRPMessage")
        net.WriteString(text)
    net.Broadcast()
    return
end)
