local knockedOut = false

lib.onCache('ped', function(ped)
    if ped then
        knockedOut = false
    end
end)


local function KnockedOut()
    if knockedOut then return end
    knockedOut = true

    SetPedCanRagdoll(cache.ped, true)
    ClearPedTasksImmediately(cache.ped)

    
    lib.requestAnimDict("missarmenian2")
    TaskPlayAnim(cache.ped, "missarmenian2", "drunk_loop", 1.0, 8.0, -1, 33, 0, false, false, false)
    lib.progressBar({
        duration = Config.KnockoutTime,
        label = Config.KnockoutText,
        useWhileDead = true,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true,
        }
    })
    ClearPedTasksImmediately(cache.ped)
    if WasPedKilledByStealth(cache.ped) then
        SetPedConfigFlag(cache.ped, 69, false)
    end
    knockedOut = false
end


CreateThread(function()
    while true do
        Wait(250) 
        if knockedOut or not cache.ped then goto continue end

        local health = GetEntityHealth(cache.ped)

    
        if Config.EnableStealthKnockout and WasPedKilledByStealth(cache.ped) then
            SetEntityHealth(cache.ped, Config.StealthHealth)
            KnockedOut()
        end

        
        if Config.EnableMeleeKnockout and health <= 110 and HasEntityBeenDamagedByWeapon(cache.ped, `WEAPON_UNARMED`, 0) then
            SetEntityHealth(cache.ped, 109)
            ClearEntityLastDamageEntity(cache.ped)
            ClearPedLastWeaponDamage(cache.ped)
            KnockedOut()
        end

        ::continue::
    end
end)
