Scriptname dattdcHarnessEffect extends ActiveMagicEffect  

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
Float Property WeaponSpeedMult Auto Hidden

Float Property Magnitude Auto Hidden


Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)
;SexLab.Stats.GetInt(SexLab.PlayerRef, "Anal") as Float
	SpeedMult = PlayerRef.GetAV("SpeedMult")
	WeaponSpeedMult = PlayerRef.GetAV("WeaponSpeedMult")

	OneHanded = PlayerRef.GetAV("OneHanded")
	TwoHanded = PlayerRef.GetAV("TwoHanded")
	Marksman = PlayerRef.GetAV("Marksman")

	Alteration = PlayerRef.GetAV("Alteration")
	Conjuration = PlayerRef.GetAV("Conjuration")
	Destruction = PlayerRef.GetAV("Destruction")
	Illusion = PlayerRef.GetAV("Illusion")
	Restoration = PlayerRef.GetAV("Restoration")
	Enchanting = PlayerRef.GetAV("Enchanting")	

	PlayerRef.ModAV("OneHanded", OneHanded * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("TwoHanded", TwoHanded * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("Marksman", Marksman * 0.1 * Magnitude * -1)

	PlayerRef.ModAV("Alteration", Alteration * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("Conjuration", Conjuration * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("Destruction", Destruction * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("Illusion", Illusion * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("Restoration", Restoration * 0.1 * Magnitude * -1)
	PlayerRef.ModAV("Enchanting", Enchanting * 0.1 * Magnitude * -1)	
	PlayerRef.ModAV("SpeedMult", -1 * SpeedMult * 0.05)	
	PlayerRef.ModAV("WeaponSpeedMult", -1 * WeaponSpeedMult * 0.1)	
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("SpeedMult", SpeedMult * 0.05)	
	PlayerRef.ModAV("WeaponSpeedMult", WeaponSpeedMult * 0.1)
	
	PlayerRef.ModAV("OneHanded", OneHanded * 0.1 * Magnitude)
	PlayerRef.ModAV("TwoHanded", TwoHanded * 0.1 * Magnitude)
	PlayerRef.ModAV("Marksman", Marksman * 0.1 * Magnitude)

	PlayerRef.ModAV("Alteration", Alteration * 0.1 * Magnitude)
	PlayerRef.ModAV("Conjuration", Conjuration * 0.1 * Magnitude)
	PlayerRef.ModAV("Destruction", Destruction * 0.1 * Magnitude)
	PlayerRef.ModAV("Illusion", Illusion * 0.1 * Magnitude)
	PlayerRef.ModAV("Restoration", Restoration * 0.1 * Magnitude)
	PlayerRef.ModAV("Enchanting", Enchanting * 0.1 * Magnitude)
EndEvent
