Scriptname dattdcMonitorQuest extends Quest

dattdcLibraries Property Libs Auto
dattdcConsequenceEffects Property ConsequenceEffects Auto

GlobalVariable Property dattArmbinderWearDuration Auto
GlobalVariable Property dattGagWearDuration Auto
GlobalVariable Property dattBalletBootsWearDuration Auto
GlobalVariable Property dattBalletBootsWearCumulativeDuration Auto

Float Property armbinderWearTime Auto Hidden
Float Property gagWearTime Auto Hidden
Float Property balletBootsWearTime Auto Hidden
Float Property LastPeriodicUpdate Auto Hidden

bool ShouldIgnoreEquippedFlag

Event OnInit()
	Maintenance()
EndEvent

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

Bool Property DeviceBuffsEnabled
	Bool Function Get()
		int value = StorageUtil.GetIntValue(Libs.PlayerRef,"Datt_DeviceBuffsEnabled")
		If(value == 0)
			return false
		ElseIf(value == 1)
			return true
		Else
			Debug.MessageBox("Invalid value in papyrusUtil key Datt_DeviceBuffsEnabled -> " + value)
		EndIf		
	EndFunction
EndProperty

Bool Property IsRunningRefresh
	Bool Function Get()
		int value = StorageUtil.GetIntValue(Libs.PlayerRef,"Datt_IsRunningRefresh")
		If(value == 0)
			return false
		ElseIf(value == 1)
			return true
		Else
			Debug.MessageBox("Invalid value in papyrusUtil key Datt_IsRunningRefresh -> " + value)
		EndIf
	EndFunction
EndProperty

Function Maintenance()
	RegisterForModEvent("Datt_RemoveArmbinderRemovedDebuffEventName", "OnDebugDispelArmbinderRemovedSpell")
	RegisterForModEvent("GagPanelStateChange", "OnGagPanelStateChange")

	RegisterForModEvent("Datt_PeriodicRefreshStarted", "OnPeriodicRefreshStarted")
	RegisterForModEvent("DeviceVibrateEffectStart", "OnDeviceVibrateEffectStart")

	RegisterForModEvent("Datt_EnableAllBuffsEventName", "OnEnableBuffs")
	RegisterForModEvent("Datt_DisableAllBuffsEventName", "OnDisableBuffs")

	RegisterForModEvent("Datt_EnableDeviceBuffs","OnEnableDeviceBuffs")
	RegisterForModEvent("Datt_DisableDeviceBuffs","OnDisableDeviceBuffs")

	RegisterForModEvent("Datt_FixDeviceBuffs","OnFixDeviceBuffs")	

	LastPeriodicUpdate = Utility.GetCurrentGameTime()
	RegisterForSingleUpdateGameTime(1.0)
	ShouldIgnoreEquippedFlag = false

	If(ConsequenceEffects.SlutCollarKeyword == None)
		ConsequenceEffects.SlutCollarKeyword = Keyword.GetKeyword("dcur_kw_slutcollar")
	EndIf

	If(ConsequenceEffects.RubberSuitKeyword == None)
		ConsequenceEffects.RubberSuitKeyword = Keyword.GetKeyword("dcur_kw_isrubbersuit")
	EndIf

	If(ConsequenceEffects.FakeCatsuitKeyword == None)
		ConsequenceEffects.FakeCatsuitKeyword = Keyword.GetKeyword("dcur_kw_lb_fakecatsuit")
	EndIf

	If(ConsequenceEffects.DollmakerCatsuitKeyword == None)
		ConsequenceEffects.DollmakerCatsuitKeyword = Keyword.GetKeyword("dcur_kw_dollmaker_rubber")
	EndIf

	If(ConsequenceEffects.ShacklesKeyword == None)
		ConsequenceEffects.ShacklesKeyword = Keyword.GetKeyword("dcur_kw_lb_shackles")
	EndIf	

	If(ConsequenceEffects.WristShacklesKeyword == None)
		ConsequenceEffects.WristShacklesKeyword = Keyword.GetKeyword("dcur_kw_wristshackles")
	EndIf

	If(ConsequenceEffects.OpenRubberGlovesKeyword == None)
		ConsequenceEffects.OpenRubberGlovesKeyword = Keyword.GetKeyword("dcur_kw_openrubbergloves")
	EndIf

	If(ConsequenceEffects.SimpleRubberGlovesKeyword == None)
		ConsequenceEffects.SimpleRubberGlovesKeyword = Keyword.GetKeyword("dcur_kw_simplerubbergloves")
	EndIf
EndFunction

Event OnFixDeviceBuffs()
	NotifyEventIfNeeded("OnFixDeviceBuffs")
	ConsequenceEffects.ApplyDeviceEffectsAsNeeded()
	Debug.Notification("Fixing device effects...")
EndEvent

Event OnEnableDeviceBuffs()
	NotifyEventIfNeeded("OnEnableDeviceBuffs")
	ApplyDeviceEffects(true)
	Debug.Notification("Enabled device effects...")
EndEvent

Event OnDisableDeviceBuffs()
	NotifyEventIfNeeded("OnDisableDeviceBuffs")
	RemoveDeviceEffects(true)
	Debug.Notification("Disabled device effects...")
EndEvent

Event OnDeviceVibrateEffectStart(string eventName, string argString, float argNum, form sender)
	NotifyEventIfNeeded(eventName)
	ConsequenceEffects.OnPlugVibration(argNum)
EndEvent

Event OnPeriodicRefreshStarted()
	RegisterForSingleUpdateGameTime(1.0)
EndEvent

Event OnUpdateGameTime()
	float currentTime = Utility.GetCurrentGameTime()
	float hoursPassed = Math.abs(LastPeriodicUpdate - currentTime) * 24.0
	ConsequenceEffects.OnPeriodicUpdate(hoursPassed)
	LastPeriodicUpdate = currentTime

	If(IsRunningRefresh)
		RegisterForSingleUpdateGameTime(1.0)
	EndIf
EndEvent

;check for strict collar -> (akActor.WornHasKeyword(libs.zad_DeviousCollar) && akActor.IsEquipped(libs.collarRestrictive) )

Event OnGagPanelStateChange(string eventName, string argString, float argNum, form sender)
	;if it is the player
	If(DeviceBuffsEnabled && Libs.PlayerRef.GetLeveledActorBase().GetName() == argString && ConsequenceEffects.IsGagEquipped == true)
		If (argNum == 0) ; Open
			If(Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell))
				Libs.PlayerRef.RemoveSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
				Libs.PlayerRef.DispelSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
			EndIf			
		ElseIf (argNum == 1) ;Closed
			If(!Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell))
				Libs.PlayerRef.AddSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
			EndIf			
		Else
			;if this happens, something is definitely wrong
			Debug.MessageBox("Devious Attributes - Devious Consequences -> OnGagPanelStateChange() received invalid state:"+argNum)
		EndIf		
	EndIf
EndEvent

Function NotifyEventIfNeeded(string eventName)
	If(ShowDebugMessages)
		Debug.Trace("Devious Consequences -> " + eventName)
	EndIf
EndFunction

Event OnRubberHoodEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsRubberHoodEquipped = true
			IncrementDeviceCount()
		EndIf
		NotifyEventIfNeeded(eventName)
	EndIf	
EndEvent

Event OnRubberHoodUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsRubberHoodEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)		
	EndIf
EndEvent

Event OnHarnessEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsHarnessEquipped = true
			IncrementDeviceCount()
		EndIf

		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.HarnessWearSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.HarnessWearSpell, false)
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf	
EndEvent

Event OnHarnessUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsHarnessEquipped = false
			DecrementDeviceCount()
		EndIf

		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.HarnessWearSpell))
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.HarnessWearSpell)
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.HarnessWearSpell)
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnRubberSuitEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsRubberSuitEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf	
EndEvent

Event OnRubberSuitUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsRubberSuitEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)		
	EndIf
EndEvent

Event OnBalletBootsEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsBalletBootsEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag))
			balletBootsWearTime = Utility.GetCurrentGameTime()
			If(!Libs.PlayerRef.HasSpell(ConsequenceEffects.BalletBootsWearSpell))
				Libs.PlayerRef.AddSpell(ConsequenceEffects.BalletBootsWearSpell,false)	
			EndIf
		EndIf		

		NotifyEventIfNeeded(eventName)
	EndIf	
EndEvent

Event OnBalletBootsUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsBalletBootsEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag))
			float hoursPassed = Math.abs(Utility.GetCurrentGameTime() - balletBootsWearTime) * 24.0
			dattBalletBootsWearDuration.SetValue(hoursPassed)
			dattBalletBootsWearCumulativeDuration.Mod(hoursPassed)
			If(DeviceBuffsEnabled)
				ConsequenceEffects.BalletBootsRemovedSpell.Cast(Libs.PlayerRef, None)
			EndIf
			If(Libs.PlayerRef.HasSpell(ConsequenceEffects.BalletBootsWearSpell))			
				Libs.PlayerRef.DispelSpell(ConsequenceEffects.BalletBootsWearSpell)
				Libs.PlayerRef.RemoveSpell(ConsequenceEffects.BalletBootsWearSpell)	
			EndIf
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnAnalPlugEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsAnalPlugEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.ButtPlugWearSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.ButtPlugWearSpell,false)	
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnAnalPlugUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsAnalPlugEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.ButtPlugWearSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.ButtPlugWearSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.ButtPlugWearSpell)
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnVaginalPlugEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsVaginalPlugEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnVaginalPlugUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)
			ConsequenceEffects.IsVaginalPlugEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnBeltEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsBeltEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnBeltUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsBeltEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnChastityBraEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsChastityBraEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnChastityBraUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsChastityBraEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnNipplePiercingEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsNipplePiercingEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnNipplePiercingUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsNipplePiercingEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnClitPiercingEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsClitPiercingEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnClitPiercingUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsClitPiercingEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnCollarEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsCollarEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.CollarWearSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.CollarWearSpell, false)
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnCollarUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsCollarEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.CollarWearSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.CollarWearSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.CollarWearSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnLegCuffsEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsLegCuffsEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnLegCuffsUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsLegCuffsEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnArmCuffsEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsArmCuffsEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnArmCuffsUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsArmCuffsEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnShacklesEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsShacklesEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnShacklesUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsShacklesEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnBlindfoldEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsBlindfoldEquipped = true
			IncrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnBlindfoldUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsBlindfoldEquipped = false
			DecrementDeviceCount()
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnGagEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsGagEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag))
			gagWearTime = Utility.GetCurrentGameTime()
			If(!Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearSpell))
				Libs.PlayerRef.AddSpell(ConsequenceEffects.GagWearSpell,false)
			EndIf
			If(!Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell) && Libs.PlayerRef.WornHasKeyword(Libs.Zad.zad_PermitOral) == false)
				Libs.PlayerRef.AddSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell,false)				
			ElseIf (Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell) && Libs.PlayerRef.WornHasKeyword(Libs.Zad.zad_PermitOral) == true)
				;this code path is precaution and should not happen
				Libs.PlayerRef.DispelSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
				Libs.PlayerRef.RemoveSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
				If(ShowDebugMessages)
					Debug.Notification("gag with zad_PermitOral flag == true, and GagWearWithBlockedMouthSpell was active... should not happen!")
				EndIf
			EndIf
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnGagUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsGagEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag))
			If(Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearSpell))
				Libs.PlayerRef.DispelSpell(ConsequenceEffects.GagWearSpell)
				Libs.PlayerRef.RemoveSpell(ConsequenceEffects.GagWearSpell)
			EndIf
			If(Libs.PlayerRef.HasSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell))
				Libs.PlayerRef.DispelSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
				Libs.PlayerRef.RemoveSpell(ConsequenceEffects.GagWearWithBlockedMouthSpell)
			EndIf
			dattGagWearDuration.SetValue(Math.abs(Utility.GetCurrentGameTime() - gagWearTime) * 24.0)

			If(DeviceBuffsEnabled)
				ConsequenceEffects.GagRemovedSpell.Cast(Libs.PlayerRef, None)
			EndIf
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnDebugDispelArmbinderRemovedSpell()
	Libs.PlayerRef.DispelSpell(ConsequenceEffects.ArmbinderRemoveSpell)
EndEvent
;
Event OnRigidCorsetEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsRigidCorsetEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.RigidCorsetSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.RigidCorsetSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnRigidCorsetUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsRigidCorsetEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.RigidCorsetSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.RigidCorsetSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.RigidCorsetSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnCorsetEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsCorsetEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.CorsetSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.CorsetSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnCorsetUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsCorsetEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.CorsetSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.CorsetSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.CorsetSpell)
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnArmbinderEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsArmbinderEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag))
			armbinderWearTime = Utility.GetCurrentGameTime()
		EndIf
				
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnArmbinderUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsArmbinderEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag))
			dattArmbinderWearDuration.SetValue(Math.abs(Utility.GetCurrentGameTime() - armbinderWearTime) * 24.0)
			If(DeviceBuffsEnabled)
				ConsequenceEffects.ArmbinderRemoveSpell.Cast(Libs.PlayerRef, None)
			EndIf		
			armbinderWearTime = 0.0 ;just in case
		EndIf

		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnSlaveBootsEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsSlaveBootsEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.SlaveBootsSpell))		
			Libs.PlayerRef.AddSpell(ConsequenceEffects.SlaveBootsSpell)
		EndIf
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnSlaveBootsUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsSlaveBootsEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.SlaveBootsSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.SlaveBootsSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.SlaveBootsSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnPonyBootsEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsPonyBootsEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.PonyBootsSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.PonyBootsSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnPonyBootsUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsPonyBootsEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.PonyBootsSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.PonyBootsSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.PonyBootsSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnSlaveGlovesEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsSlaveGlovesEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.SlaveGlovesSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.SlaveGlovesSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnSlaveGlovesUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsSlaveGlovesEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.SlaveGlovesSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.SlaveGlovesSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.SlaveGlovesSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnSlutCollarEquipped()	
	NotifyEventIfNeeded("OnSlutCollarEquipped")
	StorageUtil.SetIntValue(Libs.PlayerRef, "_Datt_SlutCollar", 1)
EndEvent

Event OnSlutCollarUnequipped()
	NotifyEventIfNeeded("OnSlutCollarUnequipped")
	StorageUtil.SetIntValue(Libs.PlayerRef, "_Datt_SlutCollar", 0)
EndEvent

Event OnRubberEquipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsRubberGlovesEquipped = true
			IncrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && !Libs.PlayerRef.HasSpell(ConsequenceEffects.RubberGlovesSpell))
			Libs.PlayerRef.AddSpell(ConsequenceEffects.RubberGlovesSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Event OnRubberUnequipped(string eventName, string strArg, float numArg, Form sender)
	If(numArg == 1.0) ;"is player" flag
		If(ShouldIgnoreEquippedFlag == false)	
			ConsequenceEffects.IsRubberGlovesEquipped = false
			DecrementDeviceCount()
		EndIf
		If((DeviceBuffsEnabled || ShouldIgnoreEquippedFlag) && Libs.PlayerRef.HasSpell(ConsequenceEffects.RubberGlovesSpell))
			Libs.PlayerRef.DispelSpell(ConsequenceEffects.RubberGlovesSpell)
			Libs.PlayerRef.RemoveSpell(ConsequenceEffects.RubberGlovesSpell)
		EndIf
		
		NotifyEventIfNeeded(eventName)
	EndIf
EndEvent

Function IncrementDeviceCount()
	int wornDeviceCount = StorageUtil.GetIntValue(Libs.PlayerRef, "_Datt_Device_Count")
	StorageUtil.SetIntValue(Libs.PlayerRef, "_Datt_Device_Count",wornDeviceCount + 1)
EndFunction

Function DecrementDeviceCount()
	int wornDeviceCount = StorageUtil.GetIntValue(Libs.PlayerRef, "_Datt_Device_Count")
	If(wornDeviceCount - 1 >= 0)
		StorageUtil.SetIntValue(Libs.PlayerRef, "_Datt_Device_Count",wornDeviceCount - 1)
	EndIf
EndFunction

Function ApplyDeviceEffects(bool ignoreEquippedFlag)
	bool originalShouldIgnoreEquippedFlag = ShouldIgnoreEquippedFlag
	ShouldIgnoreEquippedFlag = ignoreEquippedFlag
	
	ConsequenceEffects.ApplyDeviceEffectsAsNeeded()

	ShouldIgnoreEquippedFlag = originalShouldIgnoreEquippedFlag
EndFunction 

Function RemoveDeviceEffects(bool ignoreEquippedFlag)
	bool originalShouldIgnoreEquippedFlag = ShouldIgnoreEquippedFlag
	ShouldIgnoreEquippedFlag = ignoreEquippedFlag

	ConsequenceEffects.RemoveDeviceEffectsAsNeeded()

	ShouldIgnoreEquippedFlag = originalShouldIgnoreEquippedFlag
EndFunction 