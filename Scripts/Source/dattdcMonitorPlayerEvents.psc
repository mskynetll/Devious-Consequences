Scriptname dattdcMonitorPlayerEvents extends ReferenceAlias

dattdcMonitorQuest Property MonitorQuest Auto 
dattdcConsequenceEffects Property ConsequenceEffects Auto

Event OnPlayerLoadGame()
	MonitorQuest.Maintenance()
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Armor akArmor = akBaseObject as Armor
  	If (akArmor)
    	ConsequenceEffects.CheckAndEquipArmorEffects(akArmor)    	  
  	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Armor akArmor = akBaseObject as Armor
  	If (akArmor)
   		ConsequenceEffects.CheckAndUnequipArmorEffects(akArmor)    	  
  	EndIf
EndEvent