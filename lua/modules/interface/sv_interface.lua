hook.Add("PlayerSpawn", "FOVChange", function ( ply )
    ply:SetFOV(mi_hud.config.playerFOV, 0)
end)
