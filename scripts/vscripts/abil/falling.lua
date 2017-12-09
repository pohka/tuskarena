--if the unit is still over the hole then activate fall physics
function enter(trigger)
	local unit = trigger.activator
	if trigger.caller:IsTouching(unit) then
		local maxIndex = unit:GetAbilityCount()-1
		for i=0, maxIndex do
			local abil = unit:GetAbilityByIndex(i)
			
			if abil ~= nil then
				if abil:GetAbilityName() == "fall_lua" then
					abil:CastAbility()
				end
			end
		end
	end
end