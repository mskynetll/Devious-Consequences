Scriptname dattdcAnalPlugEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property OneHanded Auto Hidden
Float Property TwoHanded Auto Hidden
Float Property Marksman Auto Hidden
Float Property Alteration Auto Hidden
Float Property Conjuration Auto Hidden
Float Property Destruction Auto Hidden
Float Property Illusion Auto Hidden
Float Property Restoration Auto Hidden
Float Property Enchanting Auto Hidden

Float Property SpeedMult Auto Hidden
Float Property Magnitude Auto

sslActorStats Property ActorStats Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	int analSkill = ActorStats.GetSkill(PlayerRef,"Anal")
	Magnitude = (GetMagnitude() / 100.0) * (1.0 - (AnalSkill as float / 1000.0))
;SexLab.Stats.GetInt(SexLab.PlayerRef, "Anal") as Float
	SpeedMult = PlayerRef.GetAV("SpeedMult")

	OneHanded = PlayerRef.GetAV("OneHanded")
	TwoHanded = PlayerRef.GetAV("TwoHanded")
	Marksman = PlayerRef.GetAV("Marksman")

	Alteration = PlayerRef.GetAV("Alteration")
	Conjuration = PlayerRef.GetAV("Conjuration")
	Destruction = PlayerRef.GetAV("Destruction")
	Illusion = PlayerRef.GetAV("Illusion")
	Restoration = PlayerRef.GetAV("Restoration")
	Enchanting = PlayerRef.GetAV("Enchanting")	

	PlayerRef.ModAV("OneHanded", OneHanded * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("TwoHanded", TwoHanded * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("Marksman", Marksman * 0.15 * Magnitude * -1)

	PlayerRef.ModAV("Alteration", Alteration * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("Conjuration", Conjuration * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("Destruction", Destruction * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("Illusion", Illusion * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("Restoration", Restoration * 0.15 * Magnitude * -1)
	PlayerRef.ModAV("Enchanting", Enchanting * 0.15 * Magnitude * -1)	
	PlayerRef.ModAV("SpeedMult", -1 * SpeedMult * 0.1)	

EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("SpeedMult", SpeedMult * 0.1)	
	PlayerRef.ModAV("OneHanded", OneHanded * 0.15 * Magnitude)
	PlayerRef.ModAV("TwoHanded", TwoHanded * 0.15 * Magnitude)
	PlayerRef.ModAV("Marksman", Marksman * 0.15 * Magnitude)

	PlayerRef.ModAV("Alteration", Alteration * 0.15 * Magnitude)
	PlayerRef.ModAV("Conjuration", Conjuration * 0.15 * Magnitude)
	PlayerRef.ModAV("Destruction", Destruction * 0.15 * Magnitude)
	PlayerRef.ModAV("Illusion", Illusion * 0.15 * Magnitude)
	PlayerRef.ModAV("Restoration", Restoration * 0.15 * Magnitude)
	PlayerRef.ModAV("Enchanting", Enchanting * 0.15 * Magnitude)
EndEvent
