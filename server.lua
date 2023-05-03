local VorpCore  = {}
local VorpInv

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local listHandsUp = {}

RegisterServerEvent("nolosha:lookup_player")
AddEventHandler("nolosha:lookup_player", function(target)
    local _source = source
    local user = nil
    local Character = nil
    if target ~= nil then
        user = VorpCore.getUser(target)
        if user ~= nil then
            Character = user.getUsedCharacter
        end
    end

    local money = 0
    local gold = 0

    if Character ~= nil then
        if Character.money ~= nil then
            money = Character.money
        end
        if Character.gold ~= nil then
            gold = Character.gold
        end
    end

    local message = ""

    if money > 100.0 then
        message = " Des billets débordent de partout"
    elseif money > 50.0 then
        message = " La personne possède plusieurs liasses"
    elseif money > 20.0 then
        message = " La personne possède plusieurs billets"
    elseif money > 5.0 then
        message = " La personne possède quelques billets"
    elseif money > 1.0 then
        message = " La personne possède quelques pièces"
    else
        message = " La personne ne possède que peu d'argent"
    end

    local message2 = ""

    if gold >= 10.0 then
        message2 = ", une bourse d'or"
    elseif gold >= 5.0 then
        message2 = ", des pièces d'or"
    elseif gold >= 1.0 then
        message2 = ", quelques piécettes d'or"
    end

    local ingotNb = VorpInv.getItemCount(target, "lingot_or")
    local nuggetNb = VorpInv.getItemCount(target, "golden_nugget")
    local bibleNb = VorpInv.getItemCount(target, "protestant_bible")
    bibleNb = bibleNb + VorpInv.getItemCount(target, "catholic_bible")
    local torahNb = VorpInv.getItemCount(target, "hebraic_bible")
    local mormonNb = VorpInv.getItemCount(target, "mormon_book")

    local message3 = ""

    if ingotNb > 5 then
        message3 = ", plusieurs lingots d'or"
    elseif ingotNb > 0 then
        message3 = ", un beau lingot d'or"
    end

    local message4 = ""

    if nuggetNb > 4 then
        message4 = ", quelques pépites"
    end

    local message5 = ""

    if bibleNb > 0 then
        message5 = ", une Bible"
    end

    local message6 = ""

    if torahNb > 0 then
        message6 = ", une Torah"
    end

    local message7 = ""

    if mormonNb > 0 then
        message7 = ", un livre de Mormon"
    end

    if listHandsUp[target] ~= nil then
        TriggerClientEvent("vorp:TipRight", target, "Vous êtes fouillé", 3000)
        TriggerClientEvent("vorp:TipRight", _source, message .. message2 .. message3 .. message4 .. message5 .. message6 .. message7, 3000)
    end
end)

RegisterServerEvent("nolosha:handsdown")
AddEventHandler("nolosha:handsdown", function()
    local _source = source
    if listHandsUp[_source] then
        listHandsUp[_source] = nil
    end
    TriggerClientEvent("nolosha:ackhands", _source, false)
end)

RegisterServerEvent("nolosha:handsup")
AddEventHandler("nolosha:handsup", function()
    local _source = source
    listHandsUp[_source] = 1
    TriggerClientEvent("nolosha:ackhands", _source, true)
end)