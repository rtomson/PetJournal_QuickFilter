-- Move the pet list down
PetJournalListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -55)
-- PetJournalEnhanced draws their own ScrollFrame
if PetJournalEnhancedListScrollFrame then
    PetJournalEnhancedListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -55)
end

local QuickFilter_Function = function(self, button)
    local activeCount = 0
    for petType, _ in ipairs(PET_TYPE_SUFFIX) do
        local btn = _G["PetJournalQuickFilterButton"..petType]
        if "LeftButton" == button then
            if self == btn and (not btn.isActive) then
                btn.isActive = true
            else
                btn.isActive = false
            end
        elseif "RightButton" == button and (self == btn) then
            btn.isActive = not btn.isActive
        end
        
        if btn.isActive then
            btn:LockHighlight()
            activeCount = activeCount + 1
        else
            btn:UnlockHighlight()
        end
        C_PetJournal.SetPetTypeFilter(btn.petType, btn.isActive)
    end
    
    if 0 == activeCount then
        C_PetJournal.AddAllPetTypesFilter()
    end
    
    -- PetJournalEnhanced support
    if PetJournalEnhanced then
        local PJE = PetJournalEnhanced
        if PJE.modules and PJE.modules.Sorting then
            PJE.modules.Sorting:UpdatePets()
        elseif PJE.UpdatePets then
            PJE:UpdatePets()
        end
    end
end

local Favorites_Function = function(self, button)
	if C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_FAVORITES) == false then
		C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_FAVORITES, false)
		self:UnlockHighlight()
	else
		C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_FAVORITES, true)
		self:LockHighlight()
	end
	
	-- PetJournalEnhanced support
    if PetJournalEnhanced then
        local PJE = PetJournalEnhanced
        if PJE.modules and PJE.modules.Sorting then
            PJE.modules.Sorting:UpdatePets()
        elseif PJE.UpdatePets then
            PJE:UpdatePets()
        end
    end
end

local maxPetType = 0

-- Create the pet type buttons
for petType, suffix in ipairs(PET_TYPE_SUFFIX) do
    local btn = CreateFrame("Button", "PetJournalQuickFilterButton"..petType, PetJournalLeftInset)
    btn:SetSize(21, 21)
    btn:SetPoint("TOPLEFT", PetJournalLeftInset, 6 + 22 * (petType-1), -33)
	maxPetType = petType;
    
    local background = btn:CreateTexture(nil, "BACKGROUND")
    background:SetTexture("Interface\\PetBattles\\PetBattleHud")
    background:SetTexCoord(0.92089844, 0.95410156, 0.34960938, 0.41601563)
    background:SetSize(22, 22)
    background:SetAllPoints()
    btn.Background = background
    
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\PetBattles\\PetIcon-"..suffix)
    icon:SetTexCoord(0.79687500, 0.49218750, 0.50390625, 0.65625000)
    icon:SetSize(21, 21)
    icon:SetPoint("CENTER")
    btn.Icon = icon
    
    local highlight = btn:CreateTexture("Highlight", "OVERLAY")
    highlight:SetTexture("Interface\\PetBattles\\PetBattleHud")
    highlight:SetTexCoord(0.94921875, 0.99414063, 0.67382813, 0.76367188)
    highlight:SetSize(27, 27)
    highlight:SetPoint("CENTER")
    btn:SetHighlightTexture(highlight, "BLEND")
    
    btn.isActive = false
    btn.petType = petType
    
    btn:SetScript("OnMouseUp", QuickFilter_Function)
end

local btn = CreateFrame("Button", "PetJournalQuickFilterButtonFavorites", PetJournalLeftInset)

btn:SetSize(21, 21)
btn:SetPoint("TOPLEFT", PetJournalLeftInset, 6 + 22 * (maxPetType), -33)

local background = btn:CreateTexture(nil, "BACKGROUND")
background:SetTexture("Interface\\PetBattles\\PetBattleHud")
background:SetTexCoord(0.92089844, 0.95410156, 0.34960938, 0.41601563)
background:SetSize(22, 22)
background:SetAllPoints()
btn.Background = background

local icon = btn:CreateTexture(nil, "ARTWORK")
icon:SetTexture("Interface\\PetBattles\\PetJournal")
icon:SetTexCoord(0.11328125,0.16210938,0.02246094,0.04687500)
icon:SetSize(21, 21)
icon:SetPoint("CENTER")
btn.Icon = icon

local highlight = btn:CreateTexture("Highlight", "OVERLAY")
highlight:SetTexture("Interface\\PetBattles\\PetBattleHud")
highlight:SetTexCoord(0.94921875, 0.99414063, 0.67382813, 0.76367188)
highlight:SetSize(27, 27)
highlight:SetPoint("CENTER")
btn:SetHighlightTexture(highlight, "BLEND")	


btn:SetScript("OnMouseUp", Favorites_Function)

if C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_FAVORITES) == false then
	btn:LockHighlight()
else
	btn:UnlockHighlight()
end