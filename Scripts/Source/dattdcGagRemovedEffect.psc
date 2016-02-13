Scriptname dattdcGagRemovedEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property ShoutRecoveryMult Auto Hidden
Float Property Speechcraft Auto Hidden
Float Property Magnitude Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)

	ShoutRecoveryMult = PlayerRef.GetAV("ShoutRecoveryMult")
	PlayerRef.ModAV("ShoutRecoveryMult", -1 * ShoutRecoveryMult * Magnitude)

	Speechcraft = PlayerRef.GetAV("Speechcraft")
	PlayerRef.ModAV("Speechcraft", -1 * Speechcraft * Magnitude)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("ShoutRecoveryMult", ShoutRecoveryMult * Magnitude)
	PlayerRef.ModAV("Speechcraft", Speechcraft * Magnitude)
EndEvent
