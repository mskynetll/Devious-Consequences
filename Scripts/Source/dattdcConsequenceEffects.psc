Scriptname dattdcConsequenceEffects extends Quest

Bool Property ShowDebugMessages
	Bool Function Get()
		int value = StorageUtil.GetIntValue(Libs.PlayerRef,"Datt_ShowDebugMessages")
		If(value == 0)
			return false
		ElseIf(value == 1)
			return true
		Else
			Debug.MessageBox("Invalid value in papyrusUtil key Datt_ShowDebugMessages -> " + value)
		EndIf		
	EndFunction
EndProperty

dattdcMonitorQuest Property MonitorQuest Auto 
dattdcLibraries Property Libs Auto

Spell Property SlaveBootsSpell Auto
Spell Property PonyBootsSpell Auto

Spell Property SlaveGlovesSpell Auto
Spell Property RubberGlovesSpell Auto

Spell Property ArmbinderRemoveSpell Auto

Spell Property CorsetSpell Auto
Spell Property RigidCorsetSpell Auto

Spell Property GagWearSpell Auto
Spell Property GagWearWithBlockedMouthSpell Auto
Spell Property GagRemovedSpell Auto

Spell Property BalletBootsRemovedSpell Auto
Spell Property BalletBootsWearSpell Auto

Spell Property ButtPlugWearSpell Auto

Spell Property CollarWearSpell Auto

Spell Property HarnessWearSpell Auto

Bool Property IsArmbinderEquipped Auto Hidden

Bool Property IsSlaveBootsEquipped Auto Hidden
Bool Property IsPonyBootsEquipped Auto Hidden

Bool Property IsSlaveGlovesEquipped Auto Hidden
Bool Property IsRubberGlovesEquipped Auto Hidden

Bool Property IsCorsetEquipped Auto Hidden
Bool Property IsRigidCorsetEquipped Auto Hidden

Bool Property IsGagEquipped Auto Hidden
Bool Property IsBlindfoldEquipped Auto Hidden
Bool Property IsShacklesEquipped Auto Hidden
Bool Property IsArmCuffsEquipped Auto Hidden
Bool Property IsLegCuffsEquipped Auto Hidden
Bool Property IsCollarEquipped Auto Hidden
Bool Property IsClitPiercingEquipped Auto Hidden
Bool Property IsNipplePiercingEquipped Auto Hidden
Bool Property IsChastityBraEquipped Auto Hidden
Bool Property IsBeltEquipped Auto Hidden
Bool Property IsVaginalPlugEquipped Auto Hidden
Bool Property IsAnalPlugEquipped Auto Hidden
Bool Property IsBalletBootsEquipped Auto Hidden
Bool Property IsRubberSuitEquipped Auto Hidden
Bool Property IsHarnessEquipped Auto Hidden
Bool Property IsRubberHoodEquipped Auto Hidden

Keyword Property SlutCollarKeyword Auto Hidden
Keyword Property RubberSuitKeyword Auto Hidden
Keyword Property FakeCatsuitKeyword Auto Hidden
Keyword Property DollmakerCatsuitKeyword Auto Hidden
Keyword Property ShacklesKeyword Auto Hidden
Keyword Property WristShacklesKeyword Auto Hidden

Keyword Property OpenRubberGlovesKeyword Auto Hidden
Keyword Property SimpleRubberGlovesKeyword Auto Hidden

Function OnPeriodicUpdate(float hoursPassed)
	float selfEsteemHit = 0.0
	float prideHit = 0.0
	int soulState = StorageUtil.GetIntValue(Libs.PlayerRef, "_Datt_Soul_State")
	float baseTick = StorageUtil.GetFloatValue(Libs.PlayerRef, "Datt_BaseDDTick")
	float masochist = StorageUtil.GetFloatValue(Libs.PlayerRef, "_Datt_Masochist")
	float humiliationLover = StorageUtil.GetFloatValue(Libs.PlayerRef, "_Datt_HumiliationLover")

	float prideHitReduce = 1.0 - (((0.5 * masochist) + (0.5 * humiliationLover)) / 100.0)

	If(IsGagEquipped)
		prideHit += (baseTick * 0.1)
	EndIf

	If(IsCorsetEquipped)
		prideHit += (baseTick * 0.2)
	EndIf

	If(IsRigidCorsetEquipped)
		prideHit += (baseTick * 0.3)
	EndIf

	If(IsSlaveGlovesEquipped)
		prideHit += (baseTick * 0.05)
	EndIf

	If(IsRubberGlovesEquipped)
		prideHit += (baseTick * 0.05)
	EndIf

	If(IsSlaveBootsEquipped)
		prideHit += (baseTick * 0.1)
	EndIf

	If(IsPonyBootsEquipped)
		prideHit += baseTick
	EndIf

	If(IsArmbinderEquipped)
		prideHit += (baseTick * 2.0)
	EndIf

	If(IsSlaveBootsEquipped || IsPonyBootsEquipped)
		prideHit += (baseTick * 0.7)
	EndIf
	
	If(IsSlaveGlovesEquipped)
		prideHit += (baseTick * 0.05)
	EndIf

	If(IsRubberGlovesEquipped)
		prideHit += (baseTick * 0.08)
	EndIf	

	If(IsCorsetEquipped)
		prideHit += (baseTick * 0.05)
	EndIf	

	If(IsRigidCorsetEquipped)
		prideHit += (baseTick * 0.1)
	EndIf
	
	If(IsGagEquipped)
		prideHit += (baseTick * 0.5)
	EndIf

	If(IsShacklesEquipped)
		prideHit += (baseTick * 0.3)
	EndIf

	If(IsArmCuffsEquipped || IsLegCuffsEquipped)
		prideHit += (baseTick * 0.05)
	EndIf

	If(IsCollarEquipped)
		prideHit += (baseTick)
	EndIf	

	If(IsClitPiercingEquipped)
		prideHit += (baseTick * 0.5)
	EndIf	

	If(IsNipplePiercingEquipped)
		prideHit += (baseTick * 0.1)
	EndIf

	If(IsChastityBraEquipped)
		prideHit += (baseTick * 0.5)
	EndIf	

	If(IsBeltEquipped)
		prideHit += baseTick
	EndIf	

	If(IsVaginalPlugEquipped)
		prideHit += (baseTick * 0.3)
	EndIf

	If(IsAnalPlugEquipped)
		prideHit += baseTick
	EndIf

	If(IsBalletBootsEquipped)
		prideHit += baseTick
	EndIf	

	If(IsRubberSuitEquipped)
		prideHit += (baseTick * 0.6)
	EndIf

	If(IsHarnessEquipped)
		prideHit += (baseTick * 0.1)
	EndIf

	If(IsRubberHoodEquipped)
		prideHit += (baseTick * 0.5)
	EndIf

	If(ShowDebugMessages)
		Debug.Notification("Devious Consequences -> OnPeriodicUpdate, mod pride by " + (prideHit * prideHitReduce * hoursPassed))
	EndIf

	float totalPrideHit = -1 * prideHit * prideHitReduce * hoursPassed
	float totalWillpowerHit = 0.3 * totalPrideHit
	ModAttribute("_Datt_Pride",totalPrideHit)
	ModAttribute("_Datt_Willpower",totalWillpowerHit)
EndFunction

Function OnPlugVibration(float vibrationStrength)
	float willpower = GetAttribute("_Datt_Willpower")
	float nympho = GetAttribute("_Datt_Nymphomaniac")
	float playerArousal = Libs.SexLabAroused.GetActorArousal(Libs.PlayerRef) as float
	float howMuchChange = ((0.1 * willpower) + (vibrationStrength * 0.05) + (playerArousal / 50.0)) * (1.0 - (nympho / 100.0))
	ModAttribute("_Datt_Willpower", -1 * howMuchChange)

	;PC is distracted by the vibrations, so some magicka is lost
	Libs.PlayerRef.DamageAV("Magicka", ((vibrationStrength * 0.5) + (playerArousal / 50.0)) * (1.0 - (nympho / 100.0)))

	If(playerArousal >= 50 && Utility.RandomFloat(0.0, playerArousal) >= 25) ;make configurable? not sure..
		ModFetishAttribute("_Datt_Nymphomaniac",0.1 * (playerArousal / 5.0))
	EndIf

EndFunction

float Function GetAttribute(string attributeId)
	return StorageUtil.GetFloatValue(Libs.PlayerRef, attributeId)	
EndFunction



Function ModFetishAttribute(string attributeId, float value)
	int modAttributeEventId = ModEvent.Create("Datt_ModFetishAttribute")
	If(modAttributeEventId)
		ModEvent.PushString(modAttributeEventId, attributeId)
		ModEvent.PushFloat(modAttributeEventId, value)
		ModEvent.Send(modAttributeEventId)
	EndIf
EndFunction


Function ModAttribute(string attributeId, float value)
	int modAttributeEventId = ModEvent.Create("Datt_ModAttribute")
	If(modAttributeEventId)
		ModEvent.PushString(modAttributeEventId, attributeId)
		ModEvent.PushFloat(modAttributeEventId, value)
		ModEvent.Send(modAttributeEventId)
	EndIf
EndFunction

Function SetAttribute(string attributeId, float value)
	int setAttributeEventId = ModEvent.Create("Datt_SetAttribute")
	If(setAttributeEventId)
		ModEvent.PushString(setAttributeEventId, attributeId)
		ModEvent.PushFloat(setAttributeEventId, value)
		ModEvent.Send(setAttributeEventId)
	EndIf
EndFunction

Function CheckAndEquipArmorEffects(Armor akArmor)
    If (akArmor.HasKeywordString("dcur_kw_slutcollar"))
    	MonitorQuest.OnSlutCollarEquipped()    	
    EndIf

  	If (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCollar))
    	MonitorQuest.OnCollarEquipped("zad_DeviousCollar","",1.0,None)

    ElseIf(akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugAnal))
    	MonitorQuest.OnAnalPlugEquipped("zad_DeviousPlugAnal","",1.0,None)
    
    ElseIf(akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugVaginal))
    	MonitorQuest.OnVaginalPlugEquipped("zad_DeviousPlugVaginal","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsNipple))
    	MonitorQuest.OnNipplePiercingEquipped("zad_DeviousPiercingsNipple","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsVaginal))
    	MonitorQuest.OnClitPiercingEquipped("zad_DeviousPiercingsVaginal","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmCuffs))
    	MonitorQuest.OnArmCuffsEquipped("zad_DeviousArmCuffs","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousLegCuffs))
    	MonitorQuest.OnLegCuffsEquipped("zad_DeviousLegCuffs","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmbinder))
    	MonitorQuest.OnArmbinderEquipped("zad_DeviousArmbinder","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBoots))
    		MonitorQuest.OnSlaveBootsEquipped("zad_DeviousBoots","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousGag))
    	MonitorQuest.OnGagEquipped("zad_DeviousGag","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHarness))
    	MonitorQuest.OnHarnessEquipped("zad_DeviousHarness","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBlindfold))
    	MonitorQuest.OnBlindfoldEquipped("zad_DeviousBlindfold","",1.0,None)  

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHood))
    	MonitorQuest.OnRubberHoodEquipped("zad_DeviousHood","",1.0,None)    	

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCorset))
    	MonitorQuest.OnCorsetEquipped("zad_DeviousCorset","",1.0,None)    	

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBelt))
    	MonitorQuest.OnBeltEquipped("zad_DeviousBelt","",1.0,None)   

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBra))
    	MonitorQuest.OnChastityBraEquipped("zad_DeviousBra","",1.0,None)  

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousSuit) || akArmor.HasKeywordString("dcur_lb_rubbersuitquest") || akArmor.HasKeywordString("dcur_kw_isrubbersuit") || akArmor.HasKeywordString("dcur_kw_lb_fakecatsuit") || akArmor.HasKeywordString("dcur_kw_dollmaker_rubber"))
    	MonitorQuest.OnRubberSuitEquipped("zad_DeviousSuit","",1.0,None)     

    ElseIf (akArmor.HasKeywordString("dcur_kw_lb_shackles") || akArmor.HasKeywordString("dcur_kw_wristshackles"))
    	MonitorQuest.OnShacklesEquipped("Shackles","",1.0,None)

    ElseIf (akArmor.HasKeywordString("dcur_kw_openrubbergloves") || akArmor.HasKeywordString("dcur_kw_simplerubbergloves"))
    	MonitorQuest.OnRubberEquipped("dcur_kw_openrubbergloves","",1.0,None)
    EndIf	
EndFunction

Function ApplyDeviceEffectsAsNeeded()
 	If (SlutCollarKeyword != None && Libs.PlayerRef.WornHasKeyword(SlutCollarKeyword))
    	MonitorQuest.OnSlutCollarEquipped()    	
    EndIf

  	If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCollar))
  		Debug.MessageBox("Collar add effect!")
      	MonitorQuest.OnCollarEquipped("zad_DeviousCollar","",1.0,None)
	EndIf

    If(Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugAnal))
    	MonitorQuest.OnAnalPlugEquipped("zad_DeviousPlugAnal","",1.0,None)
	EndIf

    If(Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugVaginal))
    	MonitorQuest.OnVaginalPlugEquipped("zad_DeviousPlugVaginal","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsNipple))
    	MonitorQuest.OnNipplePiercingEquipped("zad_DeviousPiercingsNipple","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsVaginal))
    	MonitorQuest.OnClitPiercingEquipped("zad_DeviousPiercingsVaginal","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmCuffs))
    	MonitorQuest.OnArmCuffsEquipped("zad_DeviousArmCuffs","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousLegCuffs))
    	MonitorQuest.OnLegCuffsEquipped("zad_DeviousLegCuffs","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmbinder))
    	MonitorQuest.OnArmbinderEquipped("zad_DeviousArmbinder","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBoots))
    		MonitorQuest.OnSlaveBootsEquipped("zad_DeviousBoots","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousGag))
    	MonitorQuest.OnGagEquipped("zad_DeviousGag","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHarness))
    	MonitorQuest.OnHarnessEquipped("zad_DeviousHarness","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBlindfold))
    	MonitorQuest.OnBlindfoldEquipped("zad_DeviousBlindfold","",1.0,None)  

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHood))
    	MonitorQuest.OnRubberHoodEquipped("zad_DeviousHood","",1.0,None)    	

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCorset))
    	MonitorQuest.OnCorsetEquipped("zad_DeviousCorset","",1.0,None)    	

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBelt))
    	MonitorQuest.OnBeltEquipped("zad_DeviousBelt","",1.0,None)   

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBra))
    	MonitorQuest.OnChastityBraEquipped("zad_DeviousBra","",1.0,None)  

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousSuit) || (RubberSuitKeyword != None && Libs.PlayerRef.WornHasKeyword(RubberSuitKeyword)) || (FakeCatsuitKeyword != None && Libs.PlayerRef.WornHasKeyword(FakeCatsuitKeyword)) || (DollmakerCatsuitKeyword != None && Libs.PlayerRef.WornHasKeyword(DollmakerCatsuitKeyword)))
    	MonitorQuest.OnRubberSuitEquipped("zad_DeviousSuit","",1.0,None)     

	EndIf
    If ((ShacklesKeyword != None && Libs.PlayerRef.WornHasKeyword(ShacklesKeyword)) || (WristShacklesKeyword != None && Libs.PlayerRef.WornHasKeyword(WristShacklesKeyword)))
    	MonitorQuest.OnShacklesEquipped("Shackles","",1.0,None)
	EndIf

    If ((OpenRubberGlovesKeyword != None && Libs.PlayerRef.WornHasKeyword(OpenRubberGlovesKeyword)) || (SimpleRubberGlovesKeyword != None && Libs.PlayerRef.WornHasKeyword(SimpleRubberGlovesKeyword)))
    	MonitorQuest.OnRubberEquipped("dcur_kw_openrubbergloves","",1.0,None)
    EndIf		
EndFunction

Function RemoveDeviceEffectsAsNeeded()
 	If (SlutCollarKeyword != None && Libs.PlayerRef.WornHasKeyword(SlutCollarKeyword))
    	MonitorQuest.OnSlutCollarUnequipped()    	
    EndIf

  	If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCollar))
  		Debug.MessageBox("Collar remove effect!")
    	MonitorQuest.OnCollarUnequipped("zad_DeviousCollar","",1.0,None)
	EndIf

    If(Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugAnal))
    	MonitorQuest.OnAnalPlugUnequipped("zad_DeviousPlugAnal","",1.0,None)
	EndIf

    If(Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugVaginal))
    	MonitorQuest.OnVaginalPlugUnequipped("zad_DeviousPlugVaginal","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsNipple))
    	MonitorQuest.OnNipplePiercingUnequipped("zad_DeviousPiercingsNipple","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsVaginal))
    	MonitorQuest.OnClitPiercingUnequipped("zad_DeviousPiercingsVaginal","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmCuffs))
    	MonitorQuest.OnArmCuffsUnequipped("zad_DeviousArmCuffs","",1.0,None)
	EndIf

    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousLegCuffs))
    	MonitorQuest.OnLegCuffsUnequipped("zad_DeviousLegCuffs","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmbinder))
    	MonitorQuest.OnArmbinderUnequipped("zad_DeviousArmbinder","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBoots))
    		MonitorQuest.OnSlaveBootsUnequipped("zad_DeviousBoots","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousGag))
    	MonitorQuest.OnGagUnequipped("zad_DeviousGag","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHarness))
    	MonitorQuest.OnHarnessUnequipped("zad_DeviousHarness","",1.0,None)

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBlindfold))
    	MonitorQuest.OnBlindfoldUnequipped("zad_DeviousBlindfold","",1.0,None)  

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHood))
    	MonitorQuest.OnRubberHoodUnequipped("zad_DeviousHood","",1.0,None)    	

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCorset))
    	MonitorQuest.OnCorsetUnequipped("zad_DeviousCorset","",1.0,None)    	

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBelt))
    	MonitorQuest.OnBeltUnequipped("zad_DeviousBelt","",1.0,None)   

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBra))
    	MonitorQuest.OnChastityBraUnequipped("zad_DeviousBra","",1.0,None)  

	EndIf
    If (Libs.PlayerRef.WornHasKeyword(MonitorQuest.Libs.Zad.zad_DeviousSuit) || (RubberSuitKeyword != None && Libs.PlayerRef.WornHasKeyword(RubberSuitKeyword)) || (FakeCatsuitKeyword != None && Libs.PlayerRef.WornHasKeyword(FakeCatsuitKeyword)) || (DollmakerCatsuitKeyword != None && Libs.PlayerRef.WornHasKeyword(DollmakerCatsuitKeyword)))
    	MonitorQuest.OnRubberSuitUnequipped("zad_DeviousSuit","",1.0,None)     

	EndIf
    If ((ShacklesKeyword != None && Libs.PlayerRef.WornHasKeyword(ShacklesKeyword)) || (WristShacklesKeyword != None && Libs.PlayerRef.WornHasKeyword(WristShacklesKeyword)))
    	MonitorQuest.OnShacklesUnequipped("Shackles","",1.0,None)
	EndIf

    If ((OpenRubberGlovesKeyword != None && Libs.PlayerRef.WornHasKeyword(OpenRubberGlovesKeyword)) || (SimpleRubberGlovesKeyword != None && Libs.PlayerRef.WornHasKeyword(SimpleRubberGlovesKeyword)))
    	MonitorQuest.OnRubberUnequipped("dcur_kw_openrubbergloves","",1.0,None)
    EndIf		
EndFunction

Function CheckAndUnequipArmorEffects(Armor akArmor)
 ;special item tags -> extra effects
    If (akArmor.HasKeywordString("dcur_kw_slutcollar"))
    	MonitorQuest.OnSlutCollarUnequipped()    	
    EndIf

  	If (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCollar))
    	MonitorQuest.OnCollarUnequipped("zad_DeviousCollar","",1.0,None)

    ElseIf(akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugAnal))
    	MonitorQuest.OnAnalPlugUnequipped("zad_DeviousPlugAnal","",1.0,None)
    
    ElseIf(akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPlugVaginal))
    	MonitorQuest.OnVaginalPlugUnequipped("zad_DeviousPlugVaginal","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsNipple))
    	MonitorQuest.OnNipplePiercingUnequipped("zad_DeviousPiercingsNipple","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousPiercingsVaginal))
    	MonitorQuest.OnClitPiercingUnequipped("zad_DeviousPiercingsVaginal","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmCuffs))
    	MonitorQuest.OnArmCuffsUnequipped("zad_DeviousArmCuffs","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousLegCuffs))
    	MonitorQuest.OnLegCuffsUnequipped("zad_DeviousLegCuffs","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousArmbinder))
    	MonitorQuest.OnArmbinderUnequipped("zad_DeviousArmbinder","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBoots))
   		MonitorQuest.OnSlaveBootsUnequipped("zad_DeviousBoots","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousGag))
    	MonitorQuest.OnGagUnequipped("zad_DeviousGag","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHarness))
    	MonitorQuest.OnHarnessUnequipped("zad_DeviousHarness","",1.0,None)

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBlindfold))
    	MonitorQuest.OnBlindfoldUnequipped("zad_DeviousBlindfold","",1.0,None)  

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousHood))
    	MonitorQuest.OnRubberHoodUnequipped("zad_DeviousHood","",1.0,None)    	

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousCorset))
    	MonitorQuest.OnCorsetUnequipped("zad_DeviousCorset","",1.0,None)    	

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBelt))
    	MonitorQuest.OnBeltUnequipped("zad_DeviousBelt","",1.0,None)   

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousBra))
    	MonitorQuest.OnChastityBraUnequipped("zad_DeviousBra","",1.0,None)  

    ElseIf (akArmor.HasKeyword(MonitorQuest.Libs.Zad.zad_DeviousSuit) || akArmor.HasKeywordString("dcur_lb_rubbersuitquest") || akArmor.HasKeywordString("dcur_kw_isrubbersuit") || akArmor.HasKeywordString("dcur_kw_lb_fakecatsuit") || akArmor.HasKeywordString("dcur_kw_dollmaker_rubber"))
    	MonitorQuest.OnRubberSuitUnequipped("zad_DeviousSuit","",1.0,None)     

    ElseIf (akArmor.HasKeywordString("dcur_kw_lb_shackles") || akArmor.HasKeywordString("dcur_kw_wristshackles"))
    	MonitorQuest.OnShacklesUnequipped("Shackles","",1.0,None)

    ElseIf (akArmor.HasKeywordString("dcur_kw_openrubbergloves") || akArmor.HasKeywordString("dcur_kw_simplerubbergloves"))
    	MonitorQuest.OnRubberUnequipped("dcur_kw_openrubbergloves","",1.0,None)
    EndIf      	
EndFunction