hook.Add("PlayerSpawn", "FOVChange", function ( ply )
    ply:SetFOV(mi_hud.config.playerFOV)
end)

hook.Add("playerArrested", "SyncArrestTimeToClient", function(criminal, time, actor)
    if IsValid(criminal) then
        criminal:SetNWInt("ArrestTime", CurTime() + time) -- Сохраняем время окончания ареста
    end
end)

hook.Add("playerUnArrested", "ClearArrestTimeFromClient", function(criminal)
    if IsValid(criminal) then
        criminal:SetNWInt("ArrestTime", nil) -- Сбрасываем время
    end
end)
