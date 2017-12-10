
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
		local travelTime = distance/speed
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
end

--move a unit along an arc from their current position to the destination
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
		
		ability:SetContextThink("Tick", 
		function() 
			local percent = (Time() - startTime) / travelTime
			
			--move unit on x and y axis
			-- FindClearSpaceForUnit(
				-- unit, 
				-- unit:GetOrigin() + ((vDiff / travelTime) *TICK_RATE),
				-- false)
			local inc = Vector(vDiff.x, vDiff.y,0)
			local nextPos = unit:GetAbsOrigin() + ((inc / travelTime) *TICK_RATE)
			nextPos.z = startGroundHeight
			unit:SetAbsOrigin(nextPos)
				
			
			--calculate and set the z-axis
			if percent < 1 then
				--calculate height z-axis for curve on jump
				local zWeight = 0 
				
				--moving up on the z-axis before reaching apex
				if percent < apexPercent then
					zWeight = height * percent
				else 
					--zWeight = downIncrementSpeed
					zWeight = height - ((percent-apexPercent)/(1-apexPercent))*height
				end
				
				unit:SetOrigin(unit:GetOrigin() + Vector(0,0,(zWeight*2) + (heightDiff*percent)))
				return TICK_RATE
			
			--end of thinker
			else
				FindClearSpaceForUnit(unit, destination, true)
				if callback ~= nil then
					callback()
				end
			end
		end, TICK_RATE)
	end
end