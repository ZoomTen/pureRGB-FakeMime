; PureRGBnote: ADDED: code that plays Giovanni's theme if we have the option turned on

ViridianGym_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianGymTrainerHeaders
	ld de, ViridianGym_ScriptPointers
	ld a, [wViridianGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianGymCurScript], a
	ret

ViridianGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wViridianGymCurScript], a
	ld [wCurMapScript], a
	ret

ViridianGym_ScriptPointers:
	dw ViridianGymScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw ViridianGymGiovanniPostBattle
	dw ViridianGymScript4

ViridianGymScript0:
	ld a, [wYCoord]
	ld b, a
	ld a, [wXCoord]
	ld c, a
	ld hl, ViridianGymArrowTilePlayerMovement
	call DecodeArrowMovementRLE
	cp $ff
	jp z, CheckFightingMapTrainers
	call StartSimulatingJoypadStates
	ld hl, wd736
	set 7, [hl]
	ld a, SFX_ARROW_TILES
	rst _PlaySound
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, $4
	ld [wCurMapScript], a
	ret

ViridianGymArrowTilePlayerMovement:
	map_coord_movement 19, 11, ViridianGymArrowMovement1
	map_coord_movement 19,  1, ViridianGymArrowMovement2
	map_coord_movement 18,  2, ViridianGymArrowMovement3
	map_coord_movement 11,  2, ViridianGymArrowMovement4
	map_coord_movement 16, 10, ViridianGymArrowMovement5
	map_coord_movement  4,  6, ViridianGymArrowMovement6
	map_coord_movement  5, 13, ViridianGymArrowMovement7
	map_coord_movement  4, 14, ViridianGymArrowMovement8
	map_coord_movement  0, 15, ViridianGymArrowMovement9
	map_coord_movement  1, 15, ViridianGymArrowMovement10
	map_coord_movement 13, 16, ViridianGymArrowMovement11
	map_coord_movement 13, 17, ViridianGymArrowMovement12
	db -1 ; end

ViridianGymArrowMovement1:
	db D_UP, 9
	db -1 ; end

ViridianGymArrowMovement2:
	db D_LEFT, 8
	db -1 ; end

ViridianGymArrowMovement3:
	db D_DOWN, 9
	db -1 ; end

ViridianGymArrowMovement4:
	db D_RIGHT, 6
	db -1 ; end

ViridianGymArrowMovement5:
	db D_DOWN, 2
	db -1 ; end

ViridianGymArrowMovement6:
	db D_DOWN, 7
	db -1 ; end

ViridianGymArrowMovement7:
	db D_RIGHT, 8
	db -1 ; end

ViridianGymArrowMovement8:
	db D_RIGHT, 9
	db -1 ; end

ViridianGymArrowMovement9:
	db D_UP, 8
	db -1 ; end

ViridianGymArrowMovement10:
	db D_UP, 6
	db -1 ; end

ViridianGymArrowMovement11:
	db D_LEFT, 6
	db -1 ; end

ViridianGymArrowMovement12:
	db D_LEFT, 12
	db -1 ; end

ViridianGymScript4:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	jr nz, .ViridianGymLoadSpinnerArrow
	xor a
	ld [wJoyIgnore], a
	ld hl, wd736
	res 7, [hl]
	ld a, $0
	ld [wCurMapScript], a
	ret
.ViridianGymLoadSpinnerArrow
	farjp LoadSpinnerArrowTiles

ViridianGymGiovanniPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ViridianGymResetScripts
	ld a, $f0
	ld [wJoyIgnore], a
; fallthrough
ViridianGymReceiveTM27:
	callfar PlayGiovanniMusic
	ld a, $c
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	lb bc, TM_GIOVANNI, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $d
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM27
	jr .gymVictory
.BagFull
	ld a, $e
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_EARTHBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_EARTHBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7

	ld a, HS_ROUTE_22_RIVAL_2
	ld [wMissableObjectIndex], a
	predef ShowObject
	SetEvents EVENT_2ND_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	callfar PlayDefaultMusicIfMusicBitSet
	jp ViridianGymResetScripts

ViridianGym_TextPointers:
	dw GiovanniText
	dw ViridianGymTrainerText1
	dw ViridianGymTrainerText2
	dw ViridianGymTrainerText3
	dw ViridianGymTrainerText4
	dw ViridianGymTrainerText5
	dw ViridianGymTrainerText6
	dw ViridianGymTrainerText7
	dw ViridianGymTrainerText8
	dw ViridianGymGuideText
	dw PickUpItemText
	dw GiovanniEarthBadgeInfoText
	dw ReceivedTM27Text
	dw TM27NoRoomText

ViridianGymTrainerHeaders:
	def_trainers 2
ViridianGymTrainerHeader0:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_0, 4, ViridianGymBattleText1, ViridianGymEndBattleText1, ViridianGymAfterBattleText1
ViridianGymTrainerHeader1:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_1, 4, ViridianGymBattleText2, ViridianGymEndBattleText2, ViridianGymAfterBattleText2
ViridianGymTrainerHeader2:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_2, 4, ViridianGymBattleText3, ViridianGymEndBattleText3, ViridianGymAfterBattleText3
ViridianGymTrainerHeader3:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_3, 2, ViridianGymBattleText4, ViridianGymEndBattleText4, ViridianGymAfterBattleText4
ViridianGymTrainerHeader4:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_4, 3, ViridianGymBattleText5, ViridianGymEndBattleText5, ViridianGymAfterBattleText5
ViridianGymTrainerHeader5:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_5, 4, ViridianGymBattleText6, ViridianGymEndBattleText6, ViridianGymAfterBattleText6
ViridianGymTrainerHeader6:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_6, 3, ViridianGymBattleText7, ViridianGymEndBattleText7, ViridianGymAfterBattleText7
ViridianGymTrainerHeader7:
	trainer EVENT_BEAT_VIRIDIAN_GYM_TRAINER_7, 4, ViridianGymBattleText8, ViridianGymEndBattleText8, ViridianGymAfterBattleText8
	db -1 ; end

GiovanniText:
	text_asm
	callfar PlayGiovanniMusic
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM27
	jr nz, .afterBeat
	call z, ViridianGymReceiveTM27
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, GiovanniPostBattleAdviceText
	rst _PrintText
	call GBFadeOutToBlack
	ld a, HS_VIRIDIAN_GYM_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	call Delay3
	call GBFadeInFromBlack
	callfar PlayDefaultMusicIfMusicBitSet
	jr .done
.beforeBeat
	ld hl, GiovanniPreBattleText
	rst _PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ReceivedEarthBadgeText
	ld de, ReceivedEarthBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $8
	ld [wGymLeaderNo], a
	ld a, $3
	ld [wViridianGymCurScript], a
.done
	rst TextScriptEnd

GiovanniPreBattleText:
	text_far _GiovanniPreBattleText
	text_end

ReceivedEarthBadgeText:
	text_far _ReceivedEarthBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_end

GiovanniPostBattleAdviceText:
	text_far _GiovanniPostBattleAdviceText
	text_waitbutton
	text_end

GiovanniEarthBadgeInfoText:
	text_far _GiovanniEarthBadgeInfoText
	text_end

ReceivedTM27Text:
	text_far _ReceivedTM27Text
	sound_get_item_1

TM27ExplanationText:
	text_far _TM27ExplanationText
	text_end

TM27NoRoomText:
	text_far _TM27NoRoomText
	text_end

ViridianGymTrainerText1:
	text_asm
	ld hl, ViridianGymTrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText1:
	text_far _ViridianGymBattleText1
	text_end

ViridianGymEndBattleText1:
	text_far _ViridianGymEndBattleText1
	text_end

ViridianGymAfterBattleText1:
	text_far _ViridianGymAfterBattleText1
	text_end

ViridianGymTrainerText2:
	text_asm
	ld hl, ViridianGymTrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText2:
	text_far _ViridianGymBattleText2
	text_end

ViridianGymEndBattleText2:
	text_far _ViridianGymEndBattleText2
	text_end

ViridianGymAfterBattleText2:
	text_far _ViridianGymAfterBattleText2
	text_end

ViridianGymTrainerText3:
	text_asm
	ld hl, ViridianGymTrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText3:
	text_far _ViridianGymBattleText3
	text_end

ViridianGymEndBattleText3:
	text_far _ViridianGymEndBattleText3
	text_end

ViridianGymAfterBattleText3:
	text_far _ViridianGymAfterBattleText3
	text_end

ViridianGymTrainerText4:
	text_asm
	ld hl, ViridianGymTrainerHeader3
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText4:
	text_far _ViridianGymBattleText4
	text_end

ViridianGymEndBattleText4:
	text_far _ViridianGymEndBattleText4
	text_end

ViridianGymAfterBattleText4:
	text_far _ViridianGymAfterBattleText4
	text_end

ViridianGymTrainerText5:
	text_asm
	ld hl, ViridianGymTrainerHeader4
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText5:
	text_far _ViridianGymBattleText5
	text_end

ViridianGymEndBattleText5:
	text_far _ViridianGymEndBattleText5
	text_end

ViridianGymAfterBattleText5:
	text_far _ViridianGymAfterBattleText5
	text_end

ViridianGymTrainerText6:
	text_asm
	ld hl, ViridianGymTrainerHeader5
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText6:
	text_far _ViridianGymBattleText6
	text_end

ViridianGymEndBattleText6:
	text_far _ViridianGymEndBattleText6
	text_end

ViridianGymAfterBattleText6:
	text_far _ViridianGymAfterBattleText6
	text_end

ViridianGymTrainerText7:
	text_asm
	ld hl, ViridianGymTrainerHeader6
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText7:
	text_far _ViridianGymBattleText7
	text_end

ViridianGymEndBattleText7:
	text_far _ViridianGymEndBattleText7
	text_end

ViridianGymAfterBattleText7:
	text_far _ViridianGymAfterBattleText7
	text_end

ViridianGymTrainerText8:
	text_asm
	ld hl, ViridianGymTrainerHeader7
	call TalkToTrainer
	rst TextScriptEnd

ViridianGymBattleText8:
	text_far _ViridianGymBattleText8
	text_end

ViridianGymEndBattleText8:
	text_far _ViridianGymEndBattleText8
	text_end

ViridianGymAfterBattleText8:
	text_far _ViridianGymAfterBattleText8
	text_end

ViridianGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .afterBeat
	ld hl, ViridianGymGuidePreBattleText
	rst _PrintText
	jr .done
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	jr z, .donePrompt
	ld hl, ViridianGymGuidePostBattleTextPrompt
	rst _PrintText
	CheckEvent EVENT_GOT_VIRIDIAN_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText8
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedApexChipsText8
	rst _PrintText
	ld hl, ViridianGymGuideApexChipGroundText
	rst _PrintText
	SetEvent EVENT_GOT_VIRIDIAN_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText8
	rst _PrintText
	jr .done
.BagFull
	ld hl, ApexNoRoomText8
	rst _PrintText
.done
	rst TextScriptEnd
.donePrompt
	ld hl, ViridianGymGuidePostBattleText
	rst _PrintText
	jr .done

ReceivedApexChipsText8:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText8:
	text_far _TM34NoRoomText
	text_end

GymGuideMoreApexChipText8:
	text_far _GymGuideMoreApexChipText
	text_end

AlreadyReceivedApexChipsText8:
	text_far _ViridianGymGuideSeeAtPokemonLeagueText
	text_end

ViridianGymGuideApexChipGroundText:
	text_far _ViridianGymGuideApexChipGroundText
	text_end

ViridianGymGuidePreBattleText:
	text_far _ViridianGymGuidePreBattleText
	text_end

ViridianGymGuidePostBattleText:
	text_far _ViridianGymGuidePostBattleText
	text_end

ViridianGymGuidePostBattleTextPrompt:
	text_far _ViridianGymGuidePostBattleText
	text_promptbutton
	text_end
