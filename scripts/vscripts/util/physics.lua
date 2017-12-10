
if Physics == nil then
	print("[Physics] Creating Physics")
	Physics = class ({})
end

TICK_RATE = 0.03

--returns a Vector of the change in position for 1 tick at constant velocity
function Physics:ConstantVelocity(direction, distance, speed)
	local vDiff = direction:Normalized() * distance
	local travelTime = distance/speed
	local tickCount = travelTime/TICK_RATE
	local vTickDiff = vDiff/tickCount
	return vTickDiff
end

--BaseNPC unit, Vector direction, float distance, float speed
--direction Vector doesn't have to be normalized 
--distance is the total travel distance along the direction vector
--speed is in units per second 
function Physics:MoveWithContantVelocity(unit, ability, direction, distance, speed)
	local travelTime = distance/speed
	ability:SetContextThink("Tick", 
	function() 
		FindClearSpaceForUnit(
			unit, 
			unit:GetAbsOrigin() + self:ConstantVelocity(direction, distance, speed),
			false)
		travelTime = travelTime - TICK_RATE
		if travelTime > 0 then
			return TICK_RATE
		else
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end, TICK_RATE)
end