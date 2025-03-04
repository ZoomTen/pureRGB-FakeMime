; PureRGBnote: ADDED: new trainers in this location

SafariZoneNorth_Script:
	call EnableAutoTextBoxDrawing
	ld hl, SafariZoneNorthTrainerHeaders
	ld de, SafariZoneNorth_ScriptPointers
	ld a, [wSafariZoneNorthCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSafariZoneNorthCurScript], a
	ret

SafariZoneNorth_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw RangerPostBattleNorth

SafariZoneNorth_TextPointers:
	dw SafariZoneNorthRangerText0
	dw SafariZoneNorthTrainerText0
	dw SafariZoneNorthTrainerText1
	dw SafariZoneNorthTrainerText2
	dw SafariZoneNorthTrainerText3
	dw SafariZoneNorthTrainerText4
	dw PickUpItemText
	dw PickUpItemText
	dw SafariZoneNorthText3
	dw SafariZoneNorthText4
	dw SafariZoneNorthText5
	dw SafariZoneNorthText6
	dw SafariZoneNorthText7

RangerPostBattleNorth:
	SetEvent EVENT_BEAT_SAFARI_ZONE_NORTH_RANGER_0
	jpfar RangerPostBattle

SafariZoneNorthText3:
	text_far _SafariZoneNorthText3
	text_end

SafariZoneNorthText4:
	text_far _SafariZoneNorthText4
	text_end

SafariZoneNorthText5:
	text_far _SafariZoneNorthText5
	text_end

SafariZoneNorthText6:
	text_far _SafariZoneNorthText6
	text_end

SafariZoneNorthText7:
	text_far _SafariZoneNorthText7
	text_end

SafariZoneNorthTrainerHeaders:
	def_trainers
SafariZoneNorthRangerHeader:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_RANGER_0, 0, SafariZoneNorthRangerBattleText0, SafariZoneNorthRangerEndBattleText0, SafariZoneNorthRangerAfterBattleText0
SafariZoneNorthTrainerHeader0:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_0, 4, SafariZoneNorthTrainerBattleText0, SafariZoneNorthTrainerEndBattleText0, SafariZoneNorthTrainerAfterBattleText0
SafariZoneNorthTrainerHeader1:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_1, 4, SafariZoneNorthTrainerBattleText1, SafariZoneNorthTrainerEndBattleText1, SafariZoneNorthTrainerAfterBattleText1
SafariZoneNorthTrainerHeader2:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_2, 1, SafariZoneNorthTrainerBattleText2, SafariZoneNorthTrainerEndBattleText2, SafariZoneNorthTrainerAfterBattleText2
SafariZoneNorthTrainerHeader3:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_3, 0, SafariZoneNorthTrainerBattleText3, SafariZoneNorthTrainerEndBattleText3, SafariZoneNorthTrainerAfterBattleText3
SafariZoneNorthTrainerHeader4:
	trainer EVENT_BEAT_SAFARI_ZONE_NORTH_TRAINER_4, 4, SafariZoneNorthTrainerBattleText4, SafariZoneNorthTrainerEndBattleText4, SafariZoneNorthTrainerAfterBattleText4
	db -1 ; end

SafariZoneNorthRangerText0:
	text_asm
	ld hl, SafariZoneNorthRangerHeader
	call TalkToTrainer
	ld a, 3
	ld [wCurMapScript], a 
	rst TextScriptEnd

SafariZoneNorthTrainerText0:
	text_asm
	ld hl, SafariZoneNorthTrainerHeader0
	jr SafariZoneNorthTrainerTalk

SafariZoneNorthTrainerText1:
	text_asm
	ld hl, SafariZoneNorthTrainerHeader1
	jr SafariZoneNorthTrainerTalk

SafariZoneNorthTrainerText2:
	text_asm
	ld hl, SafariZoneNorthTrainerHeader2
	jr SafariZoneNorthTrainerTalk

SafariZoneNorthTrainerText3:
	text_asm
	ld hl, SafariZoneNorthTrainerHeader3
	jr SafariZoneNorthTrainerTalk

SafariZoneNorthTrainerText4:
	text_asm
	ld hl, SafariZoneNorthTrainerHeader4
SafariZoneNorthTrainerTalk:
	call TalkToTrainer
	rst TextScriptEnd

SafariZoneNorthRangerBattleText0:
	text_far _SafariZoneNorthRangerText
	text_end

SafariZoneNorthRangerEndBattleText0:
	text_far _SafariZoneNorthRangerEndBattleText
	text_end

SafariZoneNorthRangerAfterBattleText0:
	text_far _SafariZoneNorthRangerAfterBattleText
	text_end

SafariZoneNorthTrainerBattleText0:
	text_far _SafariZoneNorthJugglerText
	text_end

SafariZoneNorthTrainerEndBattleText0:
	text_far _SafariZoneNorthJugglerEndBattleText
	text_end

SafariZoneNorthTrainerAfterBattleText0:
	text_far _SafariZoneNorthJugglerAfterBattleText
	text_end

SafariZoneNorthTrainerBattleText1:
	text_far _SafariZoneNorthCooltrainerMText
	text_end

SafariZoneNorthTrainerEndBattleText1:
	text_far _SafariZoneNorthCooltrainerMEndBattleText
	text_end

SafariZoneNorthTrainerAfterBattleText1:
	text_far _SafariZoneNorthCooltrainerMAfterBattleText
	text_end

SafariZoneNorthTrainerBattleText2:
	text_far _SafariZoneNorthSuperNerdText
	text_end

SafariZoneNorthTrainerEndBattleText2:
	text_far _SafariZoneNorthSuperNerdEndBattleText
	text_end

SafariZoneNorthTrainerAfterBattleText2:
	text_far _SafariZoneNorthSuperNerdAfterBattleText
	text_end

SafariZoneNorthTrainerBattleText3:
	text_far _SafariZoneNorthEngineerText
	text_end

SafariZoneNorthTrainerEndBattleText3:
	text_far _SafariZoneNorthEngineerEndBattleText
	text_end

SafariZoneNorthTrainerAfterBattleText3:
	text_far _SafariZoneNorthEngineerAfterBattleText
	text_end

SafariZoneNorthTrainerBattleText4:
	text_far _SafariZoneNorthManiacText
	text_end

SafariZoneNorthTrainerEndBattleText4:
	text_far _SafariZoneNorthManiacEndBattleText
	text_end

SafariZoneNorthTrainerAfterBattleText4:
	text_far _SafariZoneNorthManiacAfterBattleText
	text_end