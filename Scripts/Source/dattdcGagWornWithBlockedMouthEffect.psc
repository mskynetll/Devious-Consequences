Scriptname dattdcGagWornWithBlockedMouthEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property StaminaRateMult Auto Hidden
Float Property Magnitude Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)
	
	StaminaRateMult = PlayerRef.GetAV("StaminaRateMult")
	PlayerRef.ModAV("StaminaRateMult", -1 * StaminaRateMult * Magnitude)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("StaminaRateMult", StaminaRateMult * Magnitude)
EndEvent