ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

local item = Config.OpenItem

--Language
local OpenedBoxSucces = "~g~You've succesfully opened the box"
local OpenedBoxFail = "~r~You do not have a "..item.."!"
local NotEnoughMoney = "~r~You do not have the required amount of money"
--

--Open box Function
RegisterServerEvent("esx_mission:openbox")
AddEventHandler("esx_mission:openbox", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventoryItem(item)
    if (inventory.count >=1) then
        TriggerClientEvent('esx:showNotification', source, OpenedBoxSucces)
        TriggerClientEvent("esx_mission:return", source, true)
        xPlayer.removeInventoryItem(item, 1)
    else
        TriggerClientEvent("esx_misison:return", source, false)
        TriggerClientEvent('esx:showNotification', source, OpenedBoxFail)
    end
end)
--

--Start mission Function
RegisterServerEvent("esx_mission:startmission")
AddEventHandler("esx_mission:startmission", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getMoney()
    if (inventory >= Config.StartAmount) then
        TriggerClientEvent("esx_mission:return2", source, true)
	xPlayer.removeMoney(Config.StartAmount)
    else
        TriggerClientEvent("esx_mission:return2", source, false)
        TriggerClientEvent('esx:showNotification', source, NotEnoughMoney)
    end
end)

--

--Choose Rewards Function
RegisterServerEvent("esx_mission:giveRewards")
AddEventHandler("esx_mission:giveRewards", function()
    local numItems = math.random(1, 2)
    local selectedItems = {}
    local i = 1
    local xPlayer = ESX.GetPlayerFromId(source)

    while (#selectedItems < numItems) do
        local item = Config.Items[math.random(1, #Config.Items)]
        local found = false
        for _, v in ipairs(selectedItems) do
            if v.name == item.name then
                found = true
                break
            end
        end
        if not found then
            table.insert(selectedItems, item)
        end
    end

    for i, item in ipairs(selectedItems) do
        local rewardAmount = math.random(item.minReward, item.maxReward)
        local name = item.name
        local limit = name.count
        local amount = xPlayer.getInventoryItem(name)
        if (rewardAmount > 0) then
            xPlayer.addInventoryItem(name, rewardAmount)
        end
    end
end)
--
