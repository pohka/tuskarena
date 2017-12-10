time_lapse = class({})

--keeps track of positions of each entity
time_lapse.positions = {}

--created new table for this entity and starts tinker
function time_lapse:OnUpgrade()
	self.positions[self:GetCaster():entindex()] = {}
	self:StartThink()
end

function time_lapse:OnSpellStart()
	local caster = self:GetCaster()
	FindClearSpaceForUnit(caster, time_lapse.positions[caster:entindex()][1], true)
	caster:Purge(false, true, false, true, true)
end

--manages the positions table for each entity
function time_lapse:StartThink()
	local tickRate = self:GetSpecialValueFor("tick_rate")
	self:SetContextThink("Tick", 
		function() 
			local caster = self:GetCaster()
			if caster:IsAlive() then
				local ent = caster:entindex()
				self.positions[ent][#self.positions[ent] + 1] = caster:GetAbsOrigin()
				
				--remove old positions
				local reverseTime = self:GetSpecialValueFor("reverse_time")
				local maxTicks = reverseTime / tickRate
				if #self.positions[ent] > maxTicks then
					table.remove(self.positions[ent], 1)
				end
			end
			return tickRate
		end, tickRate)
end

