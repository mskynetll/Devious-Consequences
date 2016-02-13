Scriptname dattdcCorsetEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property OneHanded Auto Hidden
Float Property TwoHanded Auto Hidden
Float Property Marksman Auto Hidden
Float Property StaminaMult Auto Hidden
Float Property Magnitude Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)

	StaminaMult = PlayerRef.GetAV("StaminaRateMult")

	OneHanded = PlayerRef.GetAV("OneHanded")
	TwoHanded = PlayerRef.GetAV("TwoHanded")
	Marksman = PlayerRef.GetAV("Marksman")

	PlayerRef.ModAV("OneHanded", -1 * OneHanded * 0.3)
	PlayerRef.ModAV("TwoHanded", -1 * TwoHanded * 0.3)
	PlayerRef.ModAV("Marksman", -1 * Marksman * 0.3)
	PlayerRef.ModAV("StaminaRateMult", -1 * StaminaMult * Magnitude)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("StaminaRateMult", StaminaMult * Magnitude)	
	PlayerRef.ModAV("OneHanded", OneHanded * 0.3)
	PlayerRef.ModAV("TwoHanded", TwoHanded * 0.3)
	PlayerRef.ModAV("Marksman", Marksman * 0.3)
EndEvent
