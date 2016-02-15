Scriptname dattdcSlaveGlovesEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property Multiplier Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Multiplier = (GetMagnitude() / 100.0) * 0.75

	PlayerRef.ModAV("OneHanded", -1 * Multiplier)
	PlayerRef.ModAV("TwoHanded", -1 * Multiplier)
	PlayerRef.ModAV("Marksman", -1 * Multiplier)

EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)

	PlayerRef.ModAV("OneHanded", Multiplier)
	PlayerRef.ModAV("TwoHanded", Multiplier)
	PlayerRef.ModAV("Marksman", Multiplier)	
EndEvent
