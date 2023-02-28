



ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(10)
	  end
	  
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

--language
local localmessage2 = "~w~[~b~E~w~] - Open Box"
local distancemessage2 = "Open Box"
local localmessage = "~w~[~b~E~w~] - Start Mission (~b~€50,000~w~)"
local distancemessage = "~w~Start Mission"
local missionActive = "~w~You already have a mission active"
local missionStarted = "~g~You've started a mission. Go to the location"
local missionEnded = "~g~Mission ended, Thank for doing bussines"
--
      
local spawnedPeds = {}
local inMission = false

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		Wait(0)
		local coords = GetEntityCoords(ped)
		local v = Config.NPCStart
		local dist = GetDistanceBetweenCoords(coords, v, true)

		debounce = true

		if dist <3 then
			if inMission then
				DrawScriptText(vector3(v.x, v.y, v.z +1), missionActive)
			else
				if dist <1.5 then
					debounce = false
					DrawScriptText(vector3(v.x, v.y, v.z +1), localmessage)
					if IsControlJustReleased(0, Config.InteractionButton) then
						debounce = true
						TriggerServerEvent("esx_mission:startmission", ped)
						RegisterNetEvent("esx_mission:return2")
						AddEventHandler("esx_mission:return2", function(status)
							if status == true then
								inMission = true
								StartMission()
							end
						end)
					end
				else
					DrawScriptText(vector3(v.x, v.y, v.z +1), distancemessage)
				end
			end
		end
	end
end)




if Config.Developer then
	RegisterCommand('DebugMission', function()
		if inMission then
			ESX.ShowNotification(missionActive)
		else
			inMission = true
			StartMission()
		end
	end)
	RegisterCommand('printmission', function()
		print(inMission)
	end)
end


local prop = nil
local propExist = false

function StartMission()
	inMission = true
    local ML = Config.Locations[math.random(#Config.Locations)]
	ESX.ShowNotification(missionStarted)
	if Config.Zone then
		zone = CreateZoneBlip(ML)
	else
		blip = CreateMissionBlip(ML)
		SetBlipRoute(blip, true)
	end
	local NPCped2 = Config.PedAppearance 

	RequestModel(NPCped2)
	while not HasModelLoaded(NPCped2) do
		Wait(0)
	end
	
	for i=1, ML.diff, 1 do
		local missiongroup = AddRelationshipGroup('MISSIE_PEDS')
		local rand = math.random(1, 3)
		local NPC = CreatePed(4, NPCped2, ML.x +rand, ML.y -rand, ML.z, 180, true, true)
		table.insert(spawnedPeds, NPC)
		FreezeEntityPosition(NPC, false)	
		SetPedDropsWeaponsWhenDead(NPC, false)
		SetEntityInvincible(NPC, false)
		SetBlockingOfNonTemporaryEvents(NPC, true)
		SetPedRelationshipGroupHash(NPC, GetHashKey('MISSIE_PEDS'))
		SetPedAccuracy(NPC, 40)
		SetPedSeeingRange(NPC, 200)
		SetPedHearingRange(NPC, 150)
		SetPedAlertness(NPC, 3)
        TaskCombatPed(NPC, GetPlayerPed(-1), 0, 16)
		SetPedCombatMovement(NPC, 1)
		GiveWeaponToPed(NPC, GetHashKey(ML.weapon), 100, false, true)
		SetPedAsGroupMember(NPC, 1)
		SetRagdollBlockingFlags(NPC, 1)
		Wait(100)
	end

	local hasOpened = false

	
	buildProp(ML)
	

	while true do
		Wait(0)
		local ped = PlayerPedId()
		local coords2 = GetEntityCoords(ped)
		local dist = GetDistanceBetweenCoords(coords2, ML.x, ML.y, ML.z, false)
	

		if dist <3 and not hasOpened and propExist then --if distance is below 3. And if box has not opened. And if box exist then
			if dist <1.5 then
				DrawScriptText(vector3(ML.x, ML.y, ML.z), localmessage2)
				if IsControlJustReleased(0, Config.InteractionButton) then


					TriggerServerEvent("esx_mission:openbox", ped)
					RegisterNetEvent("esx_mission:return")
					AddEventHandler("esx_mission:return", function(status)
   						if status == true then
							hasOpened = true
							FreezeEntityPosition(ped, true)
							GiveWeaponToPed(ped, GetHashKey('WEAPON_UNARMED'), 0, false, true)
							Wait(100)
							exports['Progressbar']:startUI(5000, "Lockpicking")
							TriggerEvent('dp:startEmote', "uncuff")
							
							
		
							Wait(5000)
		
							FreezeEntityPosition(ped, false)
							TriggerEvent('dp:cancelEmote')
		
							deleteProp(ML)
							if Config.Zone then
								RemoveBlip(zone)
							else
								RemoveBlip(blip)
							end
							inMission = false
							TriggerServerEvent("esx_mission:giveRewards")
							ESX.ShowNotification(missionEnded)
							DeleteDeadPeds()
						elseif status == false then
							hasOpened = false
						end
					end)
					
				end
			else
				DrawScriptText(vector3(ML.x, ML.y , ML.z), distancemessage2)
			end
		end
	end
end


function CreateMissionBlip(ML)
	local blip = AddBlipForCoord(ML.x, ML.y, ML.z)
	SetBlipSprite(blip, 630)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.9)
	ShowOutlineIndicatorOnBlip(blip, true)
	SetBlipSecondaryColour(blip, 255, 255, 255)
	SetBlipShrink(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Mission location')
	EndTextCommandSetBlipName(blip)

	return blip
end

function CreateZoneBlip(ML)
	zone = AddBlipForRadius(ML.x, ML.y, ML.z, ML.radius)
	SetBlipSprite(zone, 9)
	SetBlipAlpha(zone, 100)
	SetBlipColour(zone, ML.color)
	return zone
end

DrawScriptText = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end




function buildProp(ML)
	prop = CreateObject(GetHashKey(Config.PropItem), ML.x, ML.y, ML.z -1, true, false, false)
	propExist = true
end

function deleteProp()
	DeleteEntity(prop)
	propExist = false
	prop = nil
end

function DeleteDeadPeds()
	for i = #spawnedPeds, 1, -1 do
		local ped = spawnedPeds[i]
		if IsEntityDead(ped) then
			DeleteEntity(ped)
			table.remove(spawnedPeds, i)
		else
			DeleteEntity(ped)
			table.remove(spawnedPeds, i)
		end
	end
end

CreateThread(function(NPCped)
    local NPCped = Config.StartNPCAppearance 

    RequestModel(NPCped)
    while not HasModelLoaded(NPCped) do
        Wait(0)
    end

    local h = Config.NPCHeading
	local location = Config.NPCStart
    local NewNPC = CreatePed(4, NPCped, location, h, false, true)
    FreezeEntityPosition(NewNPC, true)
    SetBlockingOfNonTemporaryEvents(NewNPC, true)
    SetEntityInvincible(NewNPC, true)
	if Config.NPCAnimation then
    	TaskStartScenarioInPlace(NewNPC, 'WORLD_HUMAN_SMOKING', 0, true)
	end
end)

AddEventHandler("onResourceStop", function(resource)
    if (GetCurrentResourceName() ~= resource) then
        return
    end
	DeleteDeadPeds()
    if (prop ~= nil) then
		deleteProp()
    end
end)

Citizen.CreateThread(function()
      blip2 = AddBlipForCoord(Config.NPCStart)
      SetBlipSprite(blip2, 567)
      SetBlipDisplay(blip2, 4)
      SetBlipScale(blip2, 1.0)
      SetBlipColour(blip2, 5)
      SetBlipAsShortRange(blip2, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Weapon Mission")
      EndTextCommandSetBlipName(blip2)
end)

RegisterCommand('endmission', function()
	if inMission then
		inMission = false
		ESX.ShowNotification('~g~Mission stopped')
		deleteProp()
		if Config.Zone then
			RemoveBlip(zone)
		else
			RemoveBlip(blip)
		end
		DeleteDeadPeds()
		hasOpened = true
	else
		ESX.ShowNotification("~r~No mission active")
	end
end)

