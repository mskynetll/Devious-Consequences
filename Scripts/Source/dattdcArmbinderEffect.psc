Scriptname dattdcArmbinderEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property OneHanded Auto Hidden
Float Property TwoHanded Auto Hidden
Float Property Marksman Auto Hidden
Float Property Magnitude Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)

	OneHanded = PlayerRef.GetAV("OneHanded")
	TwoHanded = PlayerRef.GetAV("TwoHanded")
	Marksman = PlayerRef.GetAV("Marksman")

	PlayerRef.ModAV("OneHanded", -1 * OneHanded * Magnitude)
	PlayerRef.ModAV("TwoHanded", -1 * TwoHanded * Magnitude)
	PlayerRef.ModAV("Marksman", -1 * Marksman * Magnitude)
EndEvent


Event OnEffectFinish(Actor akTarget, Actor akCaster)	

	PlayerRef.ModAV("OneHanded", OneHanded * Magnitude)
	PlayerRef.ModAV("TwoHanded", TwoHanded * Magnitude)
	PlayerRef.ModAV("Marksman", Marksman * Magnitude)	
EndEvent
