SLASH_SECRET1 = "/secret"

local function playSecretHandler()
    PlaySoundFile("Interface\\AddOns\\Totem_Boi\\Sounds\\secret.mp3");
    print("Smoke the roaches")
end

SlashCmdList["SECRET"] = playSecretHandler

local EventFrame = CreateFrame("frame", "EventFrame")
EventFrame:RegisterEvent("PLAYER_TOTEM_UPDATE");
EventFrame:RegisterEvent("UNIT_AURA");
EventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

local i = 0

f = CreateFrame("Frame", nil, UIParent)

local function displaytext(value)
    f:SetWidth(1) 
    f:SetHeight(1)
    f:SetPoint("CENTER", 0, 0)
    local t = f:CreateFontString(nil, "OVERLAY", "GameTooltipText")
    t:SetPoint("CENTER", 0, 50)
    t:SetText("Recall totems")
    t:SetScale(4)
    if value == 0 then
        --print("attempting to hide")
        f:Hide()
    elseif value == 1 then
        --print("Should show")
        --PlaySoundFile("Interface\\AddOns\\Totem_Boi\\Sounds\\bing.mp3");
        f:Show()
    end
end

EventFrame:SetScript("OnEvent", function(self, event, ...)
	if(event == "UNIT_AURA") then -- if player has Strength of Earth buff then we know totems are down, might need to find a way to only care about this players?
        if AuraUtil.FindAuraByName("Strength of Earth", 'player') == "Strength of Earth" then
            local arg1, totemName, startTime, duration, icon = GetTotemInfo(2)
            if totemName ~= ("") then -- if it finds my earth totem is active
                --print(totemName)
                --print("Event has strength of earth and my totems are active")
                i = i + 1
                --print(i)
            end
        elseif i >= 1 and AuraUtil.FindAuraByName("Strength of Earth", 'player') == nil then
            local first, second, third, fourth, fifth, sixth = GetTotemInfo(2)
            if second ~= ("") then -- if it finds my earth totem is active
                --print("Totems were placed and now im out of range, trigger")
                --print(second)
                displaytext(1)
            end
        end
    
    elseif(event == "UNIT_SPELLCAST_SUCCEEDED") then -- if recall totems cast reset count
        local unitTarget, castGUID, spellID = ...
        if(unitTarget == "player" and spellID == 36936) then
            i = 0
            --print(i)
            print("My totems have been recalled")
            displaytext(0)

        end
    elseif(event == "PLAYER_TOTEM_UPDATE") then -- if totems dropped again reset count
        i = 0
        --print(i)
        displaytext(0)
    end

end)