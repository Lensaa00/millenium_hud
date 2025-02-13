hook.Add("PlayerSpawn", "FOVChange", function ( ply )
    if ply:GetFOV() ~= mi_hud.config.playerFOV then
        ply:SetFOV(mi_hud.config.playerFOV)
    end
end)

hook.Add("Think", "millenium.fov", function()

end)

hook.Add("playerArrested", "SyncArrestTimeToClient", function(criminal, time, actor)
    if IsValid(criminal) && criminal:GetNWInt("ArrestTime") == 0 then
        criminal:SetNWInt("ArrestTime", CurTime() + time) -- Сохраняем время окончания ареста
    end
end)

hook.Add("playerUnArrested", "ClearArrestTimeFromClient", function(criminal)
    if IsValid(criminal) then
        criminal:SetNWInt("ArrestTime", 0) -- Сбрасываем время
    end
end)
