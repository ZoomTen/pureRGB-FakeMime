SSAnne2FRooms_Script:
	ld a, TRUE
	ld [wAutoTextBoxDrawingControl], a
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, SSAnne9TrainerHeaders
	ld de, SSAnne2FRooms_ScriptPointers
	ld a, [wSSAnne2FRoomsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSAnne2FRoomsCurScript], a
	ret

SSAnne2FRooms_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SSAnne2FRooms_TextPointers:
	dw SSAnne9Text1
	dw SSAnne9Text2
	dw SSAnne9Text3
	dw SSAnne9Text4
	dw SSAnne9Text5
	dw PickUp2ItemText
	dw SSAnne9Text7
	dw SSAnne9Text8
	dw PickUpItemText
	dw SSAnne9Text10
	dw SSAnne9Text11
	dw SSAnne9Text12
	dw SSAnne9Text13

SSAnne9TrainerHeaders:
	def_trainers
SSAnne9TrainerHeader0:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_0, 2, SSAnne9BattleText1, SSAnne9EndBattleText1, SSAnne9AfterBattleText1
SSAnne9TrainerHeader1:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_1, 3, SSAnne9BattleText2, SSAnne9EndBattleText2, SSAnne9AfterBattleText2
SSAnne9TrainerHeader2:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_2, 3, SSAnne9BattleText3, SSAnne9EndBattleText3, SSAnne9AfterBattleText3
SSAnne9TrainerHeader3:
	trainer EVENT_BEAT_SS_ANNE_9_TRAINER_3, 2, SSAnne9BattleText4, SSAnne9EndBattleText4, SSAnne9AfterBattleText4
	db -1 ; end

SSAnne9Text1:
	text_asm
	ld hl, SSAnne9TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

SSAnne9Text2:
	text_asm
	ld hl, SSAnne9TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

SSAnne9Text3:
	text_asm
	ld hl, SSAnne9TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

SSAnne9Text4:
	text_asm
	ld hl, SSAnne9TrainerHeader3
	call TalkToTrainer
	rst TextScriptEnd

SSAnne9Text5:
	text_asm
	call SaveScreenTilesToBuffer1
	ld hl, SSAnne9Text_61bf2
	rst _PrintText
	call LoadScreenTilesFromBuffer1
	ld a, SNORLAX
	call DisplayPokedex
	rst TextScriptEnd

SSAnne9Text_61bf2:
	text_far _SSAnne9Text_61bf2
	text_end

SSAnne9Text7:
	text_asm
	ld hl, SSAnne9Text_61c01
	rst _PrintText
	rst TextScriptEnd

SSAnne9Text_61c01:
	text_far _SSAnne9Text_61c01
	text_end

SSAnne9Text8:
	text_asm
	ld hl, SSAnne9Text_61c10
	rst _PrintText
	rst TextScriptEnd

SSAnne9Text_61c10:
	text_far _SSAnne9Text_61c10
	text_end

SSAnne9Text10:
	text_asm
	ld hl, SSAnne9Text_61c1f
	rst _PrintText
	rst TextScriptEnd

SSAnne9Text_61c1f:
	text_far _SSAnne9Text_61c1f
	text_end

SSAnne9Text11:
	text_asm
	ld hl, SSAnne9Text_61c2e
	rst _PrintText
	rst TextScriptEnd

SSAnne9Text_61c2e:
	text_far _SSAnne9Text_61c2e
	text_end

SSAnne9Text12:
	text_asm
	ld hl, SSAnne9Text_61c3d
	rst _PrintText
	rst TextScriptEnd

SSAnne9Text_61c3d:
	text_far _SSAnne9Text_61c3d
	text_end

SSAnne9Text13:
	text_asm
	ld hl, SSAnne9Text_61c4c
	rst _PrintText
	rst TextScriptEnd

SSAnne9Text_61c4c:
	text_far _SSAnne9Text_61c4c
	text_end

SSAnne9BattleText1:
	text_far _SSAnne9BattleText1
	text_end

SSAnne9EndBattleText1:
	text_far _SSAnne9EndBattleText1
	text_end

SSAnne9AfterBattleText1:
	text_far _SSAnne9AfterBattleText1
	text_end

SSAnne9BattleText2:
	text_far _SSAnne9BattleText2
	text_end

SSAnne9EndBattleText2:
	text_far _SSAnne9EndBattleText2
	text_end

SSAnne9AfterBattleText2:
	text_far _SSAnne9AfterBattleText2
	text_end

SSAnne9BattleText3:
	text_far _SSAnne9BattleText3
	text_end

SSAnne9EndBattleText3:
	text_far _SSAnne9EndBattleText3
	text_end

SSAnne9AfterBattleText3:
	text_far _SSAnne9AfterBattleText3
	text_end

SSAnne9BattleText4:
	text_far _SSAnne9BattleText4
	text_end

SSAnne9EndBattleText4:
	text_far _SSAnne9EndBattleText4
	text_end

SSAnne9AfterBattleText4:
	text_far _SSAnne9AfterBattleText4
	text_end
