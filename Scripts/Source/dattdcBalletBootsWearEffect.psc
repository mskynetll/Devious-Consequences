Scriptname dattdcBalletBootsWearEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto
GlobalVariable Property dattBalletBootsWearCumulativeDuration Auto
Spell Property PlayerStaggerSpell Auto

Float Property EffectStartTime Auto Hidden


Float Property SpeedMult Auto Hidden
Float Property CarryWeight Auto Hidden
Float Property Magnitude Auto Hidden

Float Property DebuffDecreaseMultiplier Auto Hidden

Float Property OneHanded Auto Hidden
Float Property TwoHanded Auto Hidden
Float Property Marksman Auto Hidden
Float Property Alteration Auto Hidden
Float Property Conjuration Auto Hidden
Float Property Destruction Auto Hidden
Float Property Illusion Auto Hidden
Float Property Restoration Auto Hidden
Float Property Enchanting Auto Hidden

Float Property WearCumulativeDuration Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)
	EffectStartTime = Utility.GetCurrentGameTime()

	WearCumulativeDuration = dattBalletBootsWearCumulativeDuration.GetValue()
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
	PlayerRef.ModAV("SpeedMult", -1 * SpeedMult * Magnitude * 0.5 * DebuffDecreaseMultiplier)

	CarryWeight = PlayerRef.GetAV("CarryWeight")
	PlayerRef.ModAV("CarryWeight", -1 * CarryWeight * Magnitude * 0.25 * DebuffDecreaseMultiplier)

 	OneHanded = PlayerRef.GetAV("OneHanded")
	TwoHanded = PlayerRef.GetAV("TwoHanded")
	Marksman = PlayerRef.GetAV("Marksman")

	Alteration = PlayerRef.GetAV("Alteration")
	Conjuration = PlayerRef.GetAV("Conjuration")
	Destruction = PlayerRef.GetAV("Destruction")
	Illusion = PlayerRef.GetAV("Illusion")
	Restoration = PlayerRef.GetAV("Restoration")
	Enchanting = PlayerRef.GetAV("Enchanting")	

 	PlayerRef.ModAV("OneHanded", OneHanded * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("TwoHanded", TwoHanded * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("Marksman", Marksman * DebuffDecreaseMultiplier * Magnitude * -1)

	PlayerRef.ModAV("Alteration", Alteration * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("Conjuration", Conjuration * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("Destruction", Destruction * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("Illusion", Illusion * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("Restoration", Restoration * DebuffDecreaseMultiplier * Magnitude * -1)
	PlayerRef.ModAV("Enchanting", Enchanting * DebuffDecreaseMultiplier * Magnitude * -1)	

	RegisterForSingleUpdateGameTime(Utility.RandomFloat(0.5, 6.0))
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("SpeedMult", SpeedMult * Magnitude * 0.5 * DebuffDecreaseMultiplier)
	PlayerRef.ModAV("CarryWeight", CarryWeight * Magnitude * 0.25 * DebuffDecreaseMultiplier)

	PlayerRef.ModAV("OneHanded", OneHanded * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("TwoHanded", TwoHanded * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("Marksman", Marksman * DebuffDecreaseMultiplier * Magnitude)

	PlayerRef.ModAV("Alteration", Alteration * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("Conjuration", Conjuration * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("Destruction", Destruction * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("Illusion", Illusion * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("Restoration", Restoration * DebuffDecreaseMultiplier * Magnitude)
	PlayerRef.ModAV("Enchanting", Enchanting * DebuffDecreaseMultiplier * Magnitude)	
EndEvent

Event OnUpdateGameTime()
	;now decide whether to stagger or not
	If(WearCumulativeDuration >= Utility.RandomFloat(0, WearCumulativeDuration * 2))
		PlayerStaggerSpell.Cast(PlayerRef, None)
	EndIf
	float maxTime = 6.0
	If(maxTime > WearCumulativeDuration)
		maxTime = WearCumulativeDuration
	EndIf
	RegisterForSingleUpdateGameTime(Utility.RandomFloat(0.5, maxTime))
EndEvent