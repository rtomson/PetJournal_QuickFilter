-- Move the pet list down
PetJournalListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -60)
-- PetJournalEnhanced draws their own ScrollFrame
if PetJournalEnhancedListScrollFrame then
    PetJournalEnhancedListScrollFrame:SetPoint("TOPLEFT", PetJournalLeftInset, 3, -60)
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

-- Create the pet type buttons
for petType, suffix in ipairs(PET_TYPE_SUFFIX) do
    local btn = CreateFrame("Button", "PetJournalQuickFilterButton"..petType, PetJournalLeftInset)
    btn:SetSize(24, 24)
    btn:SetPoint("TOPLEFT", PetJournalLeftInset, 6 + 25 * (petType-1), -33)
    
    local background = btn:CreateTexture(nil, "BACKGROUND")
    background:SetTexture("Interface\\PetBattles\\PetBattleHud")
    background:SetTexCoord(0.92089844, 0.95410156, 0.34960938, 0.41601563)
    background:SetSize(23, 23)
    background:SetAllPoints()
    btn.Background = background
    
    local icon = btn:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\PetBattles\\PetIcon-"..suffix)
    icon:SetTexCoord(0.79687500, 0.49218750, 0.50390625, 0.65625000)
    icon:SetSize(22, 22)
    icon:SetPoint("CENTER")
    btn.Icon = icon
    
    local highlight = btn:CreateTexture("Highlight", "OVERLAY")
    highlight:SetTexture("Interface\\PetBattles\\PetBattleHud")
    highlight:SetTexCoord(0.94921875, 0.99414063, 0.67382813, 0.76367188)
    highlight:SetSize(30, 30)
    highlight:SetPoint("CENTER")
    btn:SetHighlightTexture(highlight, "BLEND")
    
    btn.isActive = false
    btn.petType = petType
    
    btn:SetScript("OnMouseUp", QuickFilter_Function)
end
