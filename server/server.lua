ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

local item = Config.OpenItem
local rewards = Config.Reward

RegisterServerEvent("esx_mission:openbox")
AddEventHandler("esx_mission:openbox", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventoryItem(item)
    if inventory.count >=1 then
        TriggerClientEvent('esx:showNotification', source, "~g~You've succesfully opened the box")
        TriggerClientEvent("esx_mission:return", source, true)
        xPlayer.removeInventoryItem(item, 1)
    else
        TriggerClientEvent("esx_misison:return", source, false)
        TriggerClientEvent('esx:showNotification', source, "~r~You do not have a lockpick")
    end
end)

RegisterServerEvent("esx_mission:startmission")
AddEventHandler("esx_mission:startmission", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getMoney()
    if inventory >= Config.StartAmount then
        TriggerClientEvent("esx_mission:return2", source, true)
    else
        TriggerClientEvent("esx_mission:return2", source, false)
        TriggerClientEvent('esx:showNotification', source, "~r~You do not have the required amount of money")
    end
end)



RegisterServerEvent("esx_mission:giveRewards")
AddEventHandler("esx_mission:giveRewards", function()    
    local numItems = math.random(1, 3)
    local selectedItems = {}
    local i = 1
    local xPlayer = ESX.GetPlayerFromId(source)

    for i = 1, numItems do
        local item = Config.Items[math.random(1, #Config.Items)]
        table.insert(selectedItems, item) 
    end

    for i, item in ipairs(selectedItems) do
        local rewardAmount = math.random(item.minReward, item.maxReward) 
        local name = item.name
        local limit = name.count
        local amount = xPlayer.getInventoryItem(name)
        xPlayer.addInventoryItem(name, rewardAmount)
    end
end)