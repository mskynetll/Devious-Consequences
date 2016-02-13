Scriptname dattdcBalletBootsRemovedEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto
GlobalVariable Property dattBalletBootsWearCumulativeDuration Auto

Float Property SpeedMult Auto Hidden
Float Property CarryWeight Auto Hidden
Float Property Magnitude Auto Hidden

Float Property DebuffDecreaseMultiplier Auto Hidden
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)

	float wearCumulativeDuration = dattBalletBootsWearCumulativeDuration.GetValue()
	;assume that 30 days period walking in ballet boots is enough to be more comfortable about 
	;walking in them
	;what I mean here is 24 hours x 30 days
	DebuffDecreaseMultiplier = wearCumulativeDuration / (24.0 * 30.0)
	DebuffDecreaseMultiplier = 1.0 - DebuffDecreaseMultiplier
	;have an upper limit to debuff magnitude decrease -> do not decrease more than 90%
	If(DebuffDecreaseMultiplier < 0.1) 
		DebuffDecreaseMultiplier = 0.1
	EndIf

	SpeedMult = PlayerRef.GetAV("SpeedMult")
	PlayerRef.ModAV("SpeedMult", -1 * SpeedMult * Magnitude * DebuffDecreaseMultiplier)

	CarryWeight = PlayerRef.GetAV("CarryWeight")
	PlayerRef.ModAV("CarryWeight", -1 * CarryWeight * Magnitude * 0.5 * DebuffDecreaseMultiplier)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("SpeedMult", SpeedMult * Magnitude * DebuffDecreaseMultiplier)
	PlayerRef.ModAV("CarryWeight", CarryWeight * Magnitude * 0.5 * DebuffDecreaseMultiplier)
EndEvent
