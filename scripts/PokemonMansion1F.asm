; PureRGBnote: ADDED: new trainers were added to this location

PokemonMansion1F_Script:
	call Mansion1Subscript1
	call EnableAutoTextBoxDrawing
	ld hl, Mansion1TrainerHeaders
	ld de, PokemonMansion1F_ScriptPointers
	ld a, [wPokemonMansion1FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPokemonMansion1FCurScript], a
	ret

Mansion1Subscript1:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_MANSION_SWITCH_ON
	jr nz, .asm_442ec
	lb bc, 6, 12
	call Mansion1Script_4430b
	lb bc, 3, 8
	call Mansion1Script_44304
	lb bc, 8, 10
	call Mansion1Script_44304
	lb bc, 13, 13
	jp Mansion1Script_44304
.asm_442ec
	lb bc, 6, 12
	call Mansion1Script_44304
	lb bc, 3, 8
	call Mansion1Script_4430b
	lb bc, 8, 10
	call Mansion1Script_4430b
	lb bc, 13, 13
	jp Mansion1Script_4430b

Mansion1Script_44304:
	ld a, $2d
	ld [wNewTileBlockID], a
	jr Mansion1ReplaceBlock

Mansion1Script_4430b:
	ld a, $e
	ld [wNewTileBlockID], a
Mansion1ReplaceBlock:
	predef ReplaceTileBlock
	ret

Mansion1Script_Switches::
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_UP
	ret nz
	xor a
	ldh [hJoyHeld], a
	ld a, $7
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

PokemonMansion1F_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

PokemonMansion1F_TextPointers:
	dw Mansion1Text1
	dw Mansion1Text2
	dw Mansion1Text3
	dw Mansion1Text4
	dw PickUpItemText
	dw PickUpItemText
	dw Mansion1Text5

Mansion1TrainerHeaders:
	def_trainers
Mansion1TrainerHeader0:
	trainer EVENT_BEAT_MANSION_1_TRAINER_0, 3, Mansion1BattleText1, Mansion1EndBattleText1, Mansion1AfterBattleText1
Mansion1TrainerHeader1:
	trainer EVENT_BEAT_MANSION_1_TRAINER_1, 3, Mansion1BattleText2, Mansion1EndBattleText2, Mansion1AfterBattleText2
Mansion1TrainerHeader2:
	trainer EVENT_BEAT_MANSION_1_TRAINER_2, 3, Mansion1BattleText3, Mansion1EndBattleText3, Mansion1AfterBattleText3
Mansion1TrainerHeader3:
	trainer EVENT_BEAT_MANSION_1_TRAINER_3, 3, Mansion1BattleText4, Mansion1EndBattleText4, Mansion1AfterBattleText4
	db -1 ; end

Mansion1Text1:
	text_asm
	ld hl, Mansion1TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

Mansion1BattleText1:
	text_far _Mansion1BattleText1
	text_end

Mansion1EndBattleText1:
	text_far _Mansion1EndBattleText1
	text_end

Mansion1AfterBattleText1:
	text_far _Mansion1AfterBattleText1
	text_end

Mansion1Text2:
	text_asm
	ld hl, Mansion1TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

Mansion1BattleText2:
	text_far _Mansion1BattleText2
	text_end

Mansion1EndBattleText2:
	text_far _Mansion1EndBattleText2
	text_end

Mansion1AfterBattleText2:
	text_far _Mansion1AfterBattleText2
	text_end

Mansion1Text3:
	text_asm
	ld hl, Mansion1TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

Mansion1BattleText3:
	text_far _Mansion1BattleText3
	text_end

Mansion1EndBattleText3:
	text_far _Mansion1EndBattleText3
	text_end

Mansion1AfterBattleText3:
	text_far _Mansion1AfterBattleText3
	text_end

Mansion1Text4:
	text_asm
	ld hl, Mansion1TrainerHeader3
	call TalkToTrainer
	rst TextScriptEnd

Mansion1BattleText4:
	text_far _Mansion1BattleText4
	text_end

Mansion1EndBattleText4:
	text_far _Mansion1EndBattleText4
	text_end

Mansion1AfterBattleText4:
	text_far _Mansion1AfterBattleText4
	text_end

Mansion1Text5:
	text_asm
	ld hl, MansionSwitchText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_4438c
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ld hl, MansionSwitchPressedText
	rst _PrintText
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	CheckAndSetEvent EVENT_MANSION_SWITCH_ON
	jr z, .asm_44392
	ResetEventReuseHL EVENT_MANSION_SWITCH_ON
	jr .asm_44392
.asm_4438c
	ld hl, MansionSwitchNotPressedText
	rst _PrintText
.asm_44392
	rst TextScriptEnd

MansionSwitchText:
	text_far _MansionSwitchText
	text_end

MansionSwitchPressedText:
	text_far _MansionSwitchPressedText
	text_end

MansionSwitchNotPressedText:
	text_far _MansionSwitchNotPressedText
	text_end
