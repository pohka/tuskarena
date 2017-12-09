crit_dagger_lua = class ({})

function crit_dagger_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("speed"),
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
			bDodgeable = true,                                -- Optional
			bIsAttack = false,                                -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bReplaceExisting = false,                         -- Optional
			flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 100,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	})
end

function crit_dagger_lua:OnProjectileHit( hTarget, vLocation )
	local dam = 322
	ApplyDamage({
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = dam,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self, --Optional.
	})
end