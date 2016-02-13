Scriptname dattdcGagWearEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto

Float Property Speechcraft Auto Hidden
Float Property Magnitude Auto Hidden

Float Property GagPrideReduceTick Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Magnitude = (GetMagnitude() / 100.0)
	
	GagPrideReduceTick = StorageUtil.GetFloatValue(PlayerRef, "Datt_GagPrideReduceTick")

	Speechcraft = PlayerRef.GetAV("Speechcraft")
	PlayerRef.ModAV("Speechcraft", -1 * Speechcraft * Magnitude)
	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	PlayerRef.ModAV("Speechcraft", Speechcraft * Magnitude)
EndEvent

Event OnUpdateGameTime()
	ReducePride(-1 * GagPrideReduceTick)
	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Function ReducePride(float value)
	int modAttributeEventId = ModEvent.Create("Datt_ModAttribute")
	If(modAttributeEventId)
		ModEvent.PushString(modAttributeEventId, "_Datt_Pride")
		ModEvent.PushFloat(modAttributeEventId, value)
		ModEvent.Send(modAttributeEventId)
	EndIf
EndFunction
