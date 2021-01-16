ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local textstatus = true

menu = function()
            ESX.UI.Menu.CloseAll()
			local elements = {}
            textstatus = false
            for k,v in pairs(KCDD) do
                table.insert(elements, {
                    label  = v.inform.label,
                    kcdd     = v.inform.value,
                    craft = v.inform.Craft,
                    craftedItem = v.inform.CraftedItem,
                    count =  v.inform.count
                })
            end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
				title    = ('KCDD-Crafting'),
				align    = 'top-right',
				elements = elements
			}, function(data, menu)
                menu.close()
                    TriggerEvent("mythic_progbar:client:progress", {
                    name = "kcdd-crafting",
                    duration = 4000,
                    label = "Parçaları takaslıyorsun...",
                    useWhileDead = false,
                    canCancel = false,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "amb@prop_human_bum_bin@base",
                        anim = "base",
                    },
                    prop = {
                        model = "",
                    }
                     }, function(status)
                        if not status then
                            TriggerServerEvent('kcdd-crafting:craft', #data.current.craft, data.current.craft, data.current.craftedItem, data.current.count)
                            textstatus = true
                            menu.close()
                            ClearPedTasks(PlayerPedId())
                        end
                    end)
                end, function(data, menu)
                menu.close()
                textstatus = true
			end)
end

local sleep = 2000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
        perform = true
        local ped = PlayerPedId()
        local pedcoords = GetEntityCoords(ped)
        local dst = GetDistanceBetweenCoords(pedcoords, Cfg.pos.x, Cfg.pos.y, Cfg.pos.z, true)
    if textstatus == true then
        if dst <= 8 then
            perform = false
            DrawText3DMX(Cfg.pos.x, Cfg.pos.y, Cfg.pos.z, "Parça takaslamak için ~r~[E]~s~ bas")
        end
        if dst <= 2 and IsControlJustPressed(0, 38) then
            menu()
        end
    end

        if perform then
            sleep = 2000
        end

        if not perform then
            sleep = 7
        end
    end    
end)

if Cfg.ped then
    Citizen.CreateThreadNow(function()
           RequestModel(0x867639D1)
           while not HasModelLoaded(0x867639D1) do
               Wait(7)
           end

           local crafter = CreatePed(1, 0x867639D1, Cfg.pos.x, Cfg.pos.y, Cfg.pos.z - 1, Cfg.pos.h, false, true)
           SetBlockingOfNonTemporaryEvents(crafter, true)
           SetPedDiesWhenInjured(crafter, false)
           SetPedCanPlayAmbientAnims(crafter, true)
           SetPedCanRagdollFromPlayerImpact(crafter, false)
           SetEntityInvincible(crafter, true)
           FreezeEntityPosition(crafter, true)
    end)
end

function DrawText3DMX(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local playerPosition = GetEntityCoords(GetPlayerPed(-1))
        local playerPed = GetPlayerPed(-1)
        

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.body.x, Cfg.Locations.craft.process.body.y, Cfg.Locations.craft.process.body.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.body.x, Cfg.Locations.craft.process.body.y, Cfg.Locations.craft.process.body.z+0.15, '~g~E~w~ - Gövde Üret (Çelik)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Gövde Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Gövde parçası ürettin.'})
                                TriggerServerEvent('kcdd_craft:body')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'steel')
            end
        end

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.body2.x, Cfg.Locations.craft.process.body2.y, Cfg.Locations.craft.process.body2.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.body2.x, Cfg.Locations.craft.process.body2.y, Cfg.Locations.craft.process.body2.z+0.15, '~g~E~w~ - Gövde Üret (Çelik)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Gövde Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Gövde parçası ürettin.'})
                                TriggerServerEvent('kcdd_craft:body')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'steel')
            end
        end

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.body3.x, Cfg.Locations.craft.process.body3.y, Cfg.Locations.craft.process.body3.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.body3.x, Cfg.Locations.craft.process.body3.y, Cfg.Locations.craft.process.body3.z+0.15, '~g~E~w~ - Gövde Üret (Çelik)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Gövde Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Gövde parçası ürettin.'})
                                TriggerServerEvent('kcdd_craft:body')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'steel')
            end
        end

        --############# Namlu---------------------##############################################--------------------############################
        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.barrel.x, Cfg.Locations.craft.process.barrel.y, Cfg.Locations.craft.process.barrel.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.barrel.x, Cfg.Locations.craft.process.barrel.y, Cfg.Locations.craft.process.barrel.z+0.15, '~g~E~w~ - Namlu Üret (Alüminyum)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Namlu Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Namlu ürettin.'})
                                TriggerServerEvent('kcdd_craft:gunbarrel')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'aluminium')
            end
        end

        --############# KABZA---------------------##############################################--------------------############################
        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.kabza.x, Cfg.Locations.craft.process.kabza.y, Cfg.Locations.craft.process.kabza.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.kabza.x, Cfg.Locations.craft.process.kabza.y, Cfg.Locations.craft.process.kabza.z+0.15, '~g~E~w~ - Kabza Üret (Bakır)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Kabza Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kabza ürettin.'})
                                TriggerServerEvent('kcdd_craft:kabza')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'copper')
            end
        end

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.kabza2.x, Cfg.Locations.craft.process.kabza2.y, Cfg.Locations.craft.process.kabza2.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.kabza2.x, Cfg.Locations.craft.process.kabza2.y, Cfg.Locations.craft.process.kabza2.z+0.15, '~g~E~w~ - Kabza Üret (Bakır)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Kabza Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kabza ürettin.'})
                                TriggerServerEvent('kcdd_craft:kabza')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'copper')
            end
        end

        --############# Yay---------------------##############################################--------------------############################
        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.yay.x, Cfg.Locations.craft.process.yay.y, Cfg.Locations.craft.process.yay.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.yay.x, Cfg.Locations.craft.process.yay.y, Cfg.Locations.craft.process.yay.z+0.15, '~g~E~w~ - Yay Üret (Demir)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Yay Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Yay ürettin.'})
                                TriggerServerEvent('kcdd_craft:yay')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'cevher')
            end
        end

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.yay2.x, Cfg.Locations.craft.process.yay2.y, Cfg.Locations.craft.process.yay2.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.yay2.x, Cfg.Locations.craft.process.yay2.y, Cfg.Locations.craft.process.yay2.z+0.15, '~g~E~w~ - Yay Üret (Demir)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Yay Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Yay ürettin.'})
                                TriggerServerEvent('kcdd_craft:yay')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'cevher')
            end
        end
        --############# Kovan---------------------##############################################--------------------############################
        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.kovan.x, Cfg.Locations.craft.process.kovan.y, Cfg.Locations.craft.process.kovan.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.kovan.x, Cfg.Locations.craft.process.kovan.y, Cfg.Locations.craft.process.kovan.z+0.15, '~g~E~w~ - Kovan Üret (Hurda Metal)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Kovan Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kovan ürettin.'})
                                TriggerServerEvent('kcdd_craft:kovan')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'scrapmetal')
            end
        end
        --############# Şarjör---------------------##############################################--------------------############################
        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.sarjor.x, Cfg.Locations.craft.process.sarjor.y, Cfg.Locations.craft.process.sarjor.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.sarjor.x, Cfg.Locations.craft.process.sarjor.y, Cfg.Locations.craft.process.sarjor.z+0.15, '~g~E~w~ - Sarjör Üret (Kauçuk)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Şarjör Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Şarjör ürettin.'})
                                TriggerServerEvent('kcdd_craft:sarjor')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'rubber')
            end
        end
        --############# Kevlar---------------------##############################################--------------------############################
        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.kevlar.x, Cfg.Locations.craft.process.kevlar.y, Cfg.Locations.craft.process.kevlar.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.kevlar.x, Cfg.Locations.craft.process.kevlar.y, Cfg.Locations.craft.process.kevlar.z+0.15, '~g~E~w~ - Kevlar Üret (Plastik)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Kevlar Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kevlar ürettin.'})
                                TriggerServerEvent('kcdd_craft:kevlar')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'plastic')
            end
        end

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.kevlar2.x, Cfg.Locations.craft.process.kevlar2.y, Cfg.Locations.craft.process.kevlar2.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.kevlar2.x, Cfg.Locations.craft.process.kevlar2.y, Cfg.Locations.craft.process.kevlar2.z+0.15, '~g~E~w~ - Kevlar Üret (Plastik)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Kevlar Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kevlar ürettin.'})
                                TriggerServerEvent('kcdd_craft:kevlar')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'plastic')
            end
        end

        if (GetDistanceBetweenCoords(playerPosition, Cfg.Locations.craft.process.kevlar3.x, Cfg.Locations.craft.process.kevlar3.y, Cfg.Locations.craft.process.kevlar3.z, true) < 1.0) then
            DrawText3DMX(Cfg.Locations.craft.process.kevlar3.x, Cfg.Locations.craft.process.kevlar3.y, Cfg.Locations.craft.process.kevlar3.z+0.15, '~g~E~w~ - Kevlar Üret (Plastik)[15]')
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("kcdd_craft:checkItem", function(output)
                    if output then
                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CLIPBOARD", 0, true)
                        exports['mythic_progbar']:Progress({
                            name = "unique_action_name",
                            duration = Cfg.WaitingTime,
                            label = 'Kevlar Üretiliyor...',
                            useWhileDead = true,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            -- animation = {
                            --     animDict = "mp_arresting",
                            --     anim = "a_uncuff",
                            -- },
                        }, function(cancelled)
                            if not cancelled then
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'success', text = 'Kevlar ürettin.'})
                                TriggerServerEvent('kcdd_craft:kevlar')
                                ClearPedTasksImmediately(playerPed)
                            else    
                                TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = "Üretimi iptal ettin."})
                            end
                        end)
                    else
                        TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Üretim için gerekli parçalara sahip değilsin.'})  
                    end
                end, 'plastic')
            end
        end
    end
end)