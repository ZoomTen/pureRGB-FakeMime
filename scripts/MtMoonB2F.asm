; PureRGBnote: CHANGED: ADDED: the super nerd who you both get fossils on this floor will now ask to take your fossil right away
; and then meet him in saffron city to receive the revived pokemon. Frees up some space in your items.
MtMoonB2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoon3TrainerHeaders
	ld de, MtMoonB2F_ScriptPointers
	ld a, [wMtMoonB2FCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonB2FCurScript], a
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	ret z
	ld hl, CoordsData_49d37
	call ArePlayerCoordsInArray
	jr nc, .asm_49d31
	ld hl, wd72e
	set 4, [hl]
	ret
.asm_49d31
	ld hl, wd72e
	res 4, [hl]
	ret

CoordsData_49d37:
	dbmapcoord 11,  5
	dbmapcoord 12,  5
	dbmapcoord 13,  5
	dbmapcoord 14,  5
	dbmapcoord 11,  6
	dbmapcoord 12,  6
	dbmapcoord 13,  6
	dbmapcoord 14,  6
	dbmapcoord 11,  7
	dbmapcoord 12,  7
	dbmapcoord 13,  7
	dbmapcoord 14,  7
	dbmapcoord 11,  8
	dbmapcoord 12,  8
	dbmapcoord 13,  8
	dbmapcoord 14,  8
	db -1 ; end

MtMoon3Script_49d58:
	xor a
	ld [wJoyIgnore], a
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB2F_ScriptPointers:
	dw MtMoon3Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw MtMoon3Script3
	dw MtMoon3Script4
	dw MtMoon3Script5

MtMoon3Script0:
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jp nz, MtMoon3Script_49d91
	ld a, [wYCoord]
	cp 8
	jp nz, MtMoon3Script_49d91
	ld a, [wXCoord]
	cp 13
	jp nz, MtMoon3Script_49d91
	xor a
	ldh [hJoyHeld], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	jp DisplayTextID

MtMoon3Script_49d91:
	CheckEitherEventSet EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	jp z, CheckFightingMapTrainers
	ret

MtMoon3Script3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, MtMoon3Script_49d58
	call UpdateSprites
	call Delay3
	SetEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoon3Script4:
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld hl, CoordsData_49dea
	call ArePlayerCoordsInArray
	jr c, .asm_49dd7
	ld hl, CoordsData_49df1
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	ld de, MovementData_49df9
	jr .asm_49dda
.asm_49dd7
	ld de, MovementData_49df8
.asm_49dda
	ld a, $1
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, $5
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

CoordsData_49dea:
	dbmapcoord 12,  7
	dbmapcoord 11,  6
	dbmapcoord 12,  5
	db -1 ; end

CoordsData_49df1:
	dbmapcoord 13,  7
	dbmapcoord 14,  6
	dbmapcoord 14,  5
	db -1 ; end

MovementData_49df8:
	db NPC_MOVEMENT_RIGHT
MovementData_49df9:
	db NPC_MOVEMENT_UP
	db -1 ; end

MtMoon3Script5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld a, $a
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr z, .asm_49e1d
	ld a, HS_MT_MOON_B2F_FOSSIL_2
	jr .asm_49e1f
.asm_49e1d
	ld a, HS_MT_MOON_B2F_FOSSIL_1
.asm_49e1f
	ld [wMissableObjectIndex], a
	predef HideObject
	; ask the player if they want to give the nerd their fossil right away, and can collect their fossil pokemon in saffron later
	ld a, 1
	ldh [hSpriteIndex], a
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr z, .right
	; make player face super nerd
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	; make super nerd face player
	ld a, SPRITE_FACING_LEFT
	jr .doFacing
.right
	; make player face super nerd
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	; make super nerd face player
	ld a, SPRITE_FACING_RIGHT
.doFacing
  	ldh [hSpriteFacingDirection], a
  	call SetSpriteFacingDirection
	xor a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld [wJoyIgnore], a
	ld a, 11
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	; done
	ld a, $0
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	ret

MtMoonB2F_TextPointers:
	dw MtMoon3Text1
	dw MtMoon3Text2
	dw MtMoon3Text3
	dw MtMoon3Text4
	dw MtMoon3Text5
	dw MtMoon3Text6
	dw MtMoon3Text7
	dw PickUpItemText
	dw PickUpItemText
	dw MtMoon3Text_49f99
	dw MtMoonSuperNerdTakeFossilQuestionText

MtMoon3TrainerHeaders:
	def_trainers 2
MtMoon3TrainerHeader0:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_0, 4, MtMoon3BattleText2, MtMoon3EndBattleText2, MtMoon3AfterBattleText2
MtMoon3TrainerHeader1:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_1, 4, MtMoon3BattleText3, MtMoon3EndBattleText3, MtMoon3AfterBattleText3
MtMoon3TrainerHeader2:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_2, 4, MtMoon3BattleText4, MtMoon3EndBattleText4, MtMoon3AfterBattleText4
MtMoon3TrainerHeader3:
	trainer EVENT_BEAT_MT_MOON_3_TRAINER_3, 4, MtMoon3BattleText5, MtMoon3EndBattleText5, MtMoon3AfterBattleText5
	db -1 ; end

MtMoon3Text1:
	text_asm
	CheckEvent EVENT_BEAT_MT_MOON_EXIT_SUPER_NERD
	jr z, .asm_49e8d
	; CheckEitherEventSetReuseA EVENT_GOT_DOME_FOSSIL, EVENT_GOT_HELIX_FOSSIL
	and (1 << (EVENT_GOT_DOME_FOSSIL % 8)) | (1 << (EVENT_GOT_HELIX_FOSSIL % 8))
	jr nz, .asm_49eb8
	ld hl, MtMoon3Text_49f8f
	rst _PrintText
	jr .asm_49ebe
.asm_49e8d
	ld hl, MtMoon3Text_49f85
	rst _PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, MtMoon3Text_49f8a
	ld de, MtMoon3Text_49f8a
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
	jr .asm_49ebe
.asm_49eb8
	call MtMoonSuperNerdTakeFossilQuestion
.asm_49ebe
	rst TextScriptEnd

MtMoon3Text2:
	text_asm
	ld hl, MtMoon3TrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

MtMoon3Text3:
	text_asm
	ld hl, MtMoon3TrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

MtMoon3Text4:
	text_asm
	ld hl, MtMoon3TrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

MtMoon3Text5:
	text_asm
	ld hl, MtMoon3TrainerHeader3
	call TalkToTrainer
	rst TextScriptEnd

MtMoon3Text6:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MtMoon3Text_49f24
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_49f21
	lb bc, DOME_FOSSIL, 1
	call GiveItem
	jp nc, MtMoon3Script_49f76
	call MtMoon3Script_49f69
	ld a, HS_MT_MOON_B2F_FOSSIL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_DOME_FOSSIL
	ld a, $4
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
.asm_49f21
	rst TextScriptEnd

MtMoon3Text_49f24:
	text_far _MtMoon3Text_49f24
	text_end

MtMoon3Text7:
	text_asm
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, MtMoon3Text_49f64
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_49f61
	lb bc, HELIX_FOSSIL, 1
	call GiveItem
	jp nc, MtMoon3Script_49f76
	call MtMoon3Script_49f69
	ld a, HS_MT_MOON_B2F_FOSSIL_2
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_GOT_HELIX_FOSSIL
	ld a, $4
	ld [wMtMoonB2FCurScript], a
	ld [wCurMapScript], a
.asm_49f61
	rst TextScriptEnd

MtMoon3Text_49f64:
	text_far _MtMoon3Text_49f64
	text_end

MtMoon3Script_49f69:
	ld hl, MtMoon3Text_49f6f
	jp PrintText

MtMoon3Text_49f6f:
	text_far _MtMoon3Text_49f6f
	sound_get_key_item
	text_waitbutton
	text_end

MtMoon3Script_49f76:
	ld hl, MtMoon3Text_49f7f
	rst _PrintText
	rst TextScriptEnd

MtMoon3Text_49f7f:
	text_far _MtMoon3Text_49f7f
	text_waitbutton
	text_end

MtMoon3Text_49f85:
	text_far _MtMoon3Text_49f85
	text_end

MtMoon3Text_49f8a:
	text_far _MtMoon3Text_49f8a
	text_end

MtMoon3Text_49f8f:
	text_far _MtMoon3Text_49f8f
	text_end

MtMoon3Text_49f94:
	text_far _MtMoon3Text_49f94
	text_end

MtMoon3Text_49f99:
	text_far _MtMoon3Text_49f99
	sound_get_key_item
	text_end

MtMoonSuperNerdTakeFossilQuestionText:
	text_asm
	call MtMoonSuperNerdTakeFossilQuestion
	rst TextScriptEnd

MtMoonSuperNerdTakeFossilQuestion:
	CheckEvent EVENT_RECEIVED_FOSSIL_PKMN_FROM_SUPER_NERD
	jr nz, .lookingForMoreFossils
	CheckEvent EVENT_GAVE_FOSSIL_TO_SUPER_NERD
	jr nz, .end
	ld hl, MtMoon3Text_49f94
	rst _PrintText
	ld hl, MtMoon3TextSuperNerdGiveFossil
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no
.yes
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr z, .checkHelix
	ld b, DOME_FOSSIL
	jr .isInBag
.checkHelix
	ld b, HELIX_FOSSIL
.isInBag
	call IsItemInBag
	jr z, .noFossil
	jr .haveFossil
.noFossil
	ld hl, MtMoon3TextSuperNerdNoFossil
	rst _PrintText
	jr .done
.haveFossil
	SetEvent EVENT_GAVE_FOSSIL_TO_SUPER_NERD
	CheckEvent EVENT_GOT_DOME_FOSSIL
	jr nz, .domeRemove
	ld hl, MtMoon3TextSuperNerdGaveHelix
	rst _PrintText
	ld a, HELIX_FOSSIL
	jr .removeItem
.domeRemove
	ld hl, MtMoon3TextSuperNerdGaveDome
	rst _PrintText
	ld a, DOME_FOSSIL
.removeItem
	ldh [hItemToRemoveID], a
	farcall RemoveItemByID
	ld hl, MtMoon3TextSuperNerdGaveFossil
	rst _PrintText
.end
	ld hl, MtMoon3TextSuperNerdGaveFossilEnd
	rst _PrintText
	jr .done
.lookingForMoreFossils
	ld hl, MtMoon3TextSuperNerdLookingForMoreFossils
	rst _PrintText
	jr .done
.no
	ld hl, MtMoon3TextSuperNerdKeptFossil
	rst _PrintText
.done
	ret
	
MtMoon3TextSuperNerdNoFossil:
	text_far _MtMoon3TextSuperNerdNoFossil
	text_end

MtMoon3TextSuperNerdGiveFossil:
	text_far _MtMoon3TextSuperNerdGiveFossil
	text_end

MtMoon3TextSuperNerdGaveFossil:
	text_far _MtMoon3TextSuperNerdGaveFossil
	text_end

MtMoon3TextSuperNerdGaveHelix:
	text_far _MtMoon3TextSuperNerdGaveHelix
	sound_get_item_1
	text_end

MtMoon3TextSuperNerdGaveDome:
	text_far _MtMoon3TextSuperNerdGaveDome
	sound_get_item_1
	text_end

MtMoon3TextSuperNerdGaveFossilEnd:
	text_far _MtMoon3TextSuperNerdGaveFossilEnd
	text_end

MtMoon3TextSuperNerdKeptFossil:
	text_far _MtMoon3TextSuperNerdKeptFossil
	text_end

MtMoon3TextSuperNerdLookingForMoreFossils:
	text_far _MtMoon3TextSuperNerdLookingForMoreFossils
	text_end
	
MtMoon3BattleText2:
	text_far _MtMoon3BattleText2
	text_end

MtMoon3EndBattleText2:
	text_far _MtMoon3EndBattleText2
	text_end

MtMoon3AfterBattleText2:
	text_far _MtMoon3AfterBattleText2
	text_end

MtMoon3BattleText3:
	text_far _MtMoon3BattleText3
	text_end

MtMoon3EndBattleText3:
	text_far _MtMoon3EndBattleText3
	text_end

MtMoon3AfterBattleText3:
	text_far _MtMoon3AfterBattleText3
	text_end

MtMoon3BattleText4:
	text_far _MtMoon3BattleText4
	text_end

MtMoon3EndBattleText4:
	text_far _MtMoon3EndBattleText4
	text_end

MtMoon3AfterBattleText4:
	text_far _MtMoon3AfterBattleText4
	text_end

MtMoon3BattleText5:
	text_far _MtMoon3BattleText5
	text_end

MtMoon3EndBattleText5:
	text_far _MtMoon3EndBattleText5
	text_end

MtMoon3AfterBattleText5:
	text_far _MtMoon3AfterBattleText5
	text_end
