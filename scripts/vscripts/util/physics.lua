
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
function Physics:MoveWithContantVelocity(unit, ability, direction, distance, speed, callback)
	local travelTime = distance/speed
	
	local params = {["direction"] = direction, ["distance"] = distance, ["speed"] = speed}
	self:Move(unit, ability, travelTime, params, 
		function(params)
			return Physics:ConstantVelocity(params["direction"], params["distance"], params["speed"]) 
		end,
		callback)
end

--moves a unit each tick with a function and its params
function Physics:Move(unit, ability, travelTime, params, func, callback)
	ability:SetContextThink("Tick", 
	function() 
		FindClearSpaceForUnit(
			unit, 
			unit:GetAbsOrigin() + 
			func(params),
			false)
		
		travelTime = travelTime - TICK_RATE
		if travelTime > 0 then
			return TICK_RATE
			
		--end of thinker
		else
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			if callback ~= nil then
				callback()
			end
		end
	end, TICK_RATE)
end