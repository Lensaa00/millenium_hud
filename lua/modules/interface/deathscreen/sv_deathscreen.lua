hook.Add("PlayerDeath", "PlayerDeathHook", function ( ply )
    ply:SetNWInt("DeathTime", CurTime())
    ply:SetNWInt("DeathText", "Вы мертвы!")
end)

hook.Add("OnPlayerChangedTeam", "PlayerChangeTeamHook", function (ply, before, after)
    ply:SetNWInt("DeathTime", CurTime())
    ply:SetNWInt("DeathText", "Смена работы!")
end)
