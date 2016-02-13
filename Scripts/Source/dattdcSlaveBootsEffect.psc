Scriptname dattdcSlaveBootsEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property Sneak Auto Hidden
Float Property Magnitude Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0) * 0.50 ;take only 50% of mag percentage
	
	Sneak = PlayerRef.GetAV("Sneak")
	PlayerRef.ModAV("Sneak", -1 * Sneak * Magnitude)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("Sneak", Sneak * Magnitude)
EndEvent