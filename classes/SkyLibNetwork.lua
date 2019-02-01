SkyLib.Network = SkyLib.Network or class()

function SkyLib.Network:_my_peer_id()
    return Global.game_settings.single_player and 1 or managers.network:session() and managers.network:session():local_peer():id() or 1
end

function SkyLib.Network:_number_of_players()
    return managers.network:session() and managers.network:session():amount_of_players() or 1
end

function SkyLib.Network:_is_solo()
    if Global.game_settings.single_player then
        return true
    end

    local nb_players = self:_number_of_players()
    
    if nb_players == 1 then
        return true
    end

    return false
end

function SkyLib.Network:_init_codz_network()
    Hooks:Add("NetworkReceivedData", "NetworkReceivedData_SkyLibNetwork", function(sender, id, data)
        if id == "UpdPts" then
            local tbl_data = LuaNetworking:StringToTable(data)
            SkyLib.CODZ._players[sender].codz_points = tonumber(tbl_data.cm)
            local positive = tonumber(tbl_data.pg) > 0 and true or false

            if managers.hud then
                SkyLib.CODZ:_update_hud_element()
                --managers.hud._hud_zm_points:_animate_points_gained_v2(sender, tonumber(tbl_data.pg), positive)
            end

            SkyLib.CODZ:_update_total_score(sender, tonumber(tbl_data.pg))
        end
    end)
end