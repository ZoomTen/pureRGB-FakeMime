PewterGym_Script:
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeaders
	ld de, PewterGym_ScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

PewterGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGym_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PewterGymBrockPostBattle

PewterGymBrockPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymResetScripts
	ld a, $f0
	ld [wJoyIgnore], a
; fallthrough
PewterGymScriptReceiveTM34:
	ld a, $4
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb bc, TM_BROCK, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr .gymVictory
.BagFull
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_BOULDERBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_BOULDERBADGE, [hl]

	ld a, HS_GYM_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymResetScripts

PewterGym_TextPointers:
	dw BrockText
	dw PewterGymTrainerText1
	dw PewterGymGuideText
	dw BeforeReceivedTM34Text
	dw ReceivedTM34Text
	dw TM34NoRoomText

PewterGymTrainerHeaders:
	def_trainers 2
PewterGymTrainerHeader0:
	trainer EVENT_BEAT_PEWTER_GYM_TRAINER_0, 5, PewterGymBattleText1, PewterGymEndBattleText1, PewterGymAfterBattleText1
	db -1 ; end

BrockText:
	text_asm
	CheckEvent EVENT_BEAT_BROCK
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .afterBeat
	call z, PewterGymScriptReceiveTM34
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld hl, BrockPostBattleAdviceText
	rst _PrintText
	jr .done
.beforeBeat
	ld hl, BrockPreBattleText
	rst _PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ReceivedBoulderBadgeText
	ld de, ReceivedBoulderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, $3
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
.done
	rst TextScriptEnd

BrockPreBattleText:
	text_far _BrockPreBattleText
	text_end

BrockPostBattleAdviceText:
	text_far _BrockPostBattleAdviceText
	text_end

BeforeReceivedTM34Text:
	text_far _BeforeReceivedTM34Text
	text_end

ReceivedTM34Text:
	text_far _ReceivedTM34Text
	sound_get_item_1
	text_far _TM34ExplanationText
	text_end

TM34NoRoomText:
	text_far _TM34NoRoomText
	text_end

ReceivedBoulderBadgeText:
	text_far _ReceivedBoulderBadgeText
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_far _BrockBoulerBadgeInfoText ; Text to tell that the flash technique can be used
	text_end

PewterGymTrainerText1:
	text_asm
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

PewterGymBattleText1:
	text_far _PewterGymBattleText1
	text_end

PewterGymEndBattleText1:
	text_far _PewterGymEndBattleText1
	text_end

PewterGymAfterBattleText1:
	text_far _PewterGymAfterBattleText1
	text_end

PewterGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	ld a, [wBeatGymFlags]
	bit BIT_BOULDERBADGE, a
	jr nz, .afterBeat
	ld hl, PewterGymGuidePreAdviceText
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .PewterGymGuideBeginAdviceText
	ld hl, PewterGymGuideBeginAdviceText
	rst _PrintText
	jr .PewterGymGuideAdviceText
.PewterGymGuideBeginAdviceText
	ld hl, PewterGymText_5c524
	rst _PrintText
.PewterGymGuideAdviceText
	ld hl, PewterGymGuideAdviceText
	rst _PrintText
	jr .done
.afterBeat
	ld hl, PewterGymGuidePostBattleText
	rst _PrintText
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, PewterGymGuideApexChipText
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedApexChipsTextPewter
	rst _PrintText
	SetEvent EVENT_GOT_PEWTER_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText
	rst _PrintText
	jr .done
.BagFull
	ld hl, TM34NoRoomText
	rst _PrintText
.done
	rst TextScriptEnd

PewterGymGuidePreAdviceText:
	text_far _PewterGymGuidePreAdviceText
	text_end

PewterGymGuideBeginAdviceText:
	text_far _PewterGymGuideBeginAdviceText
	text_end

PewterGymGuideAdviceText:
	text_far _PewterGymGuideAdviceText
	text_end

PewterGymText_5c524:
	text_far _PewterGymText_5c524
	text_end

PewterGymGuidePostBattleText:
	text_far _PewterGymGuidePostBattleText
	text_end

PewterGymGuideApexChipText:
	text_far _PewterGymGuideApexChipText
	text_end

ReceivedApexChipsTextPewter:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_far _ApexChipExplanationText
	text_end

AlreadyReceivedApexChipsText:
	text_far _AlreadyReceivedApexChipsText
	text_end