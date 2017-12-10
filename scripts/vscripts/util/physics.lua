
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
	if IsServer() then
		local travelTime = (distance/speed)
		local params = {["direction"] = direction, ["distance"] = distance, ["speed"] = speed}
		self:Move(unit, ability, travelTime, params, 
			function(params)
				return Physics:ConstantVelocity(params["direction"], params["distance"], params["speed"]) 
			end,
			callback)
	end
end

--moves a unit each tick with a function and its params
function Physics:Move(unit, ability, travelTime, params, func, callback)
	if IsServer() then
		ability:SetContextThink("Tick", 
		function() 
			travelTime = travelTime - TICK_RATE
			if travelTime > 0 then
				local nextOrigin = GetGroundPosition(unit:GetOrigin() + func(params), unit)
				unit:SetOrigin(nextOrigin)
			end
			if travelTime > -0.05 then
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
end

--interpolates a unit along an arc from their current position to the destination
--the apex height with be reached at the apexPercent [0-1] value 
function Physics:MoveToWithArc(unit, ability, destination, height, apexPercent, travelTime, callback)
	if IsServer() then
		destination = GetGroundPosition(destination, unit)
		local startPt = unit:GetAbsOrigin()
		local vDiff = destination - startPt
		local dist = vDiff:Length2D()
		local startTime = Time()
		local startGroundHeight = GetGroundHeight(startPt, unit)
		local heightDiff = GetGroundHeight(destination, unit) - startGroundHeight
		
		local endFlag = false
		
		if apexPercent > 1 then 
			apexPercent = 0.5
		end
		
		ability:SetContextThink("Tick", 
		function() 
			local percent = (Time() - startTime) / travelTime
			
			local inc = Vector(vDiff.x, vDiff.y,0)
			local nextPos = unit:GetAbsOrigin() + ((inc / travelTime) *TICK_RATE)
			nextPos.z = startGroundHeight
			unit:SetAbsOrigin(nextPos)
			
			--end of thinker
				
				
			--calculate and set the z-axis
			if percent < 1.15 then
			
				--zWeight will be between 0 and apexPercent
				local zWeight = 0 
				
				--moving up on the z-axis before reaching apex
				if percent < apexPercent then
					zWeight = percent/apexPercent
				else 
					--zWeight = downIncrementSpeed
					zWeight = 1-((percent-apexPercent)/(1-apexPercent))
				end
				
				--slope between start and end point
				local naturalSlope = heightDiff*percent
				local curveH = (math.sin(zWeight* 0.5 * math.pi))*height
				local finalZ = curveH + naturalSlope
				unit:SetOrigin(unit:GetOrigin() + Vector(0,0,finalZ))
			end
			
			if percent < 1.19 then
				return TICK_RATE
			else
				FindClearSpaceForUnit(unit, destination, true)
				if callback ~= nil then
					callback()
				end
			end
			
		end, TICK_RATE)
	end
end