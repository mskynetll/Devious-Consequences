Scriptname dattdcCollarWearEffect extends ActiveMagicEffect  

Actor Property PlayerRef Auto
Keyword Property ActorTypeNPC Auto

Float Property CollarSelfEsteemChangeTick Auto Hidden
Float Property SlutCollarPrideHitTick Auto Hidden
Bool Property IsSlutCollar Auto Hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	CollarSelfEsteemChangeTick = StorageUtil.GetFloatValue(PlayerRef, "Datt_CollarSelfEsteemChangeTick")
	SlutCollarPrideHitTick = StorageUtil.GetFloatValue(PlayerRef, "Datt_SlutCollarPrideHitTick")
	int slutCollarFlag = StorageUtil.GetIntValue(PlayerRef, "_Datt_SlutCollar")
	If(slutCollarFlag == 1)
		IsSlutCollar = true
	Else
		IsSlutCollar = false
	EndIf

	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
EndEvent

Event OnUpdateGameTime()
	int soulState = StorageUtil.GetIntValue(PlayerRef, "_Datt_Soul_State")
	If(soulState != 1) ;if not willing slave
		ModSelfEsteem(-1 * CollarSelfEsteemChangeTick)
	Else
		ModSelfEsteem(CollarSelfEsteemChangeTick)
	EndIf
	
	float nympho = StorageUtil.GetFloatValue(PlayerRef, "_Datt_Nymphomaniac")

	;if PC likes sex too much, it won't hurt pride to be considered a slut
	If(nympho < 66) 
		Actor randomActor = Game.FindRandomActor(0.0, 0.0, 0.0, 50.0)
		;hurt pride if *not* an enemy is close
		If(randomActor != None && randomActor.HasKeyword(ActorTypeNPC) && randomActor.GetRelationshipRank(PlayerRef) >= 0) 
			float multiplier = 1.0
			If(nympho >= 33)
				multiplier = 0.5
			EndIf
			ModPride(SlutCollarPrideHitTick * multiplier)
		EndIf
	EndIf

	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Function ModPride(float value)	
	int modAttributeEventId = ModEvent.Create("Datt_ModAttribute")
	If(modAttributeEventId)
		ModEvent.PushString(modAttributeEventId, "_Datt_Pride")
		ModEvent.PushFloat(modAttributeEventId, value)
		ModEvent.Send(modAttributeEventId)
	EndIf
EndFunction

Function ModSelfEsteem(float value)
	int modAttributeEventId = ModEvent.Create("Datt_ModAttribute")
	If(modAttributeEventId)
		ModEvent.PushString(modAttributeEventId, "_Datt_SelfEsteem")
		ModEvent.PushFloat(modAttributeEventId, value)
		ModEvent.Send(modAttributeEventId)
	EndIf
EndFunction
