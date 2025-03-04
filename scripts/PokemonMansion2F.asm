; PureRGBnote: ADDED: new trainers were added to this location

PokemonMansion2F_Script:
	call Mansion2Script_51fee
	call EnableAutoTextBoxDrawing
	ld hl, Mansion2TrainerHeaders
	ld de, PokemonMansion2F_ScriptPointers
	ld a, [wPokemonMansion2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion2FCurScript], a
	ret

Mansion2Script_51fee:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .asm_52016
	ld a, $e
	lb bc, 2, 4
	call Mansion2Script_5202f
	ld a, $54
	lb bc, 4, 9
	call Mansion2Script_5202f
	ld a, $5f
	lb bc, 11, 3
	call Mansion2Script_5202f
	ret
.asm_52016
	ld a, $5f
	lb bc, 2, 4
	call Mansion2Script_5202f
	ld a, $e
	lb bc, 4, 9
	call Mansion2Script_5202f
	ld a, $e
	lb bc, 11, 3
	call Mansion2Script_5202f
	ret

Mansion2Script_5202f:
	ld [wNewTileBlockID], a
	predef_jump ReplaceTileBlock

Mansion2Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, $9
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

PokemonMansion2F_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PokemonMansion2F_TextPointers:
	dw Mansion2Text1
	dw Mansion2Trainer2
	dw Mansion2Trainer3
	dw Mansion2Trainer4
	dw Mansion2Trainer5
	dw PickUpItemText
	dw Mansion2Text3
	dw Mansion2Text4
	dw Mansion2Text5

Mansion2TrainerHeaders:
	def_trainers
Mansion2TrainerHeader0:
	trainer EVENT_BEAT_MANSION_2_TRAINER_0, 0, Mansion2BattleText1, Mansion2EndBattleText1, Mansion2AfterBattleText1
Mansion2TrainerHeader1:
	trainer EVENT_BEAT_MANSION_2_TRAINER_1, 0, Mansion2BattleText2, Mansion2EndBattleText2, Mansion2AfterBattleText2
Mansion2TrainerHeader2:
	trainer EVENT_BEAT_MANSION_2_TRAINER_2, 0, Mansion2BattleText3, Mansion2EndBattleText3, Mansion2AfterBattleText3
Mansion2TrainerHeader3:
	trainer EVENT_BEAT_MANSION_2_TRAINER_3, 3, Mansion2BattleText4, Mansion2EndBattleText4, Mansion2AfterBattleText4
Mansion2TrainerHeader4:
	trainer EVENT_BEAT_MANSION_2_TRAINER_4, 0, Mansion2BattleText5, Mansion2EndBattleText5, Mansion2AfterBattleText5
	db -1 ; end

Mansion2Text1:
	text_asm
	ld hl, Mansion2TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

Mansion2BattleText1:
	text_far _Mansion2BattleText1
	text_end

Mansion2EndBattleText1:
	text_far _Mansion2EndBattleText1
	text_end

Mansion2AfterBattleText1:
	text_far _Mansion2AfterBattleText1
	text_end

Mansion2Trainer2:
	text_asm
	ld hl, Mansion2TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

Mansion2BattleText2:
	text_far _Mansion2BattleText2
	text_end

Mansion2EndBattleText2:
	text_far _Mansion2EndBattleText2
	text_end

Mansion2AfterBattleText2:
	text_far _Mansion2AfterBattleText2
	text_end

Mansion2Trainer3:
	text_asm
	ld hl, Mansion2TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

Mansion2BattleText3:
	text_far _Mansion2BattleText3
	text_end

Mansion2EndBattleText3:
	text_far _Mansion2EndBattleText3
	text_end

Mansion2AfterBattleText3:
	text_far _Mansion2AfterBattleText3
	text_end

Mansion2Trainer4:
	text_asm
	ld hl, Mansion2TrainerHeader3
	call TalkToTrainer
	rst TextScriptEnd

Mansion2BattleText4:
	text_far _Mansion2BattleText4
	text_end

Mansion2EndBattleText4:
	text_far _Mansion2EndBattleText4
	text_end

Mansion2AfterBattleText4:
	text_far _Mansion2AfterBattleText4
	text_end

Mansion2Trainer5:
	text_asm
	ld hl, Mansion2TrainerHeader4
	call TalkToTrainer
	rst TextScriptEnd

Mansion2BattleText5:
	text_far _Mansion2BattleText5
	text_end

Mansion2EndBattleText5:
	text_far _Mansion2EndBattleText5
	text_end

Mansion2AfterBattleText5:
	text_far _Mansion2AfterBattleText5
	text_end

Mansion2Text3:
	text_far _Mansion2Text3
	text_end

Mansion2Text4:
	text_far _Mansion2Text4
	text_end

Mansion3Text6:
Mansion2Text5:
	text_asm
	ld hl, Mansion2Text_520c2
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_520b9
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ld hl, Mansion2Text_520c7
	rst _PrintText
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	CheckAndSetEvent EVENT_MANSION_SWITCH_ON
	jr z, .asm_520bf
	ResetEventReuseHL EVENT_MANSION_SWITCH_ON
	jr .asm_520bf
.asm_520b9
	ld hl, Mansion2Text_520cc
	rst _PrintText
.asm_520bf
	rst TextScriptEnd

Mansion2Text_520c2:
	text_far _Mansion2Text_520c2
	text_end

Mansion2Text_520c7:
	text_far _Mansion2Text_520c7
	text_end

Mansion2Text_520cc:
	text_far _Mansion2Text_520cc
	text_end
