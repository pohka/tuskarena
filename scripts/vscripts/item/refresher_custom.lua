item_refresher_custom = class({})

function item_refresher_custom:IsRefreshable()
	return false
end

--refreshes all abilities and items in the casters inventory
function item_refresher_custom:OnSpellStart()
	--abilities
	local index = 0;
	local caster = self:GetCaster()
	local abil = caster:GetAbilityByIndex(index)
	while abil ~= nil do
		if abil:IsRefreshable() then
			abil:EndCooldown()
		end
		index = index+1
		abil = caster:GetAbilityByIndex(index)
	end
	
	--items
	local maxSlots = 9
	for i=0, maxSlots-1 do
		local item = caster:GetItemInSlot(i)
		if item~= nil and item:IsRefreshable() then
			item:EndCooldown()
		end
	end
	
end

