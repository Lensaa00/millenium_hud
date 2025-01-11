hook.Add("PlayerDeath", "PlayerDeathHook", function ( ply )
    ply:SetNWInt("DeathTime", CurTime())
end)
