Scriptname dattdcSlaveGlovesEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	float multiplier = (GetMagnitude() / 100.0) * 0.75

	PlayerRef.ModAV("OneHanded", -1 * multiplier)
	PlayerRef.ModAV("TwoHanded", -1 * multiplier)
	PlayerRef.ModAV("Marksman", -1 * multiplier)

EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)
	float multiplier = (GetMagnitude() / 100.0) * 0.75

	PlayerRef.ModAV("OneHanded", multiplier)
	PlayerRef.ModAV("TwoHanded", multiplier)
	PlayerRef.ModAV("Marksman", multiplier)	
EndEvent
