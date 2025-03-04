CeruleanGym_Script:
	call EnableAutoTextBoxDrawing
	ld hl, CeruleanGymTrainerHeaders
	ld de, CeruleanGym_ScriptPointers
	ld a, [wCeruleanGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeruleanGymCurScript], a
	ret

CeruleanGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wCeruleanGymCurScript], a
	ld [wCurMapScript], a
	ret

CeruleanGym_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw CeruleanGymMistyPostBattle

CeruleanGymMistyPostBattle:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeruleanGymResetScripts
	ld a, $f0
	ld [wJoyIgnore], a

CeruleanGymReceiveTM11:
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_MISTY
	lb bc, TM_MISTY, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM11
	jr .gymVictory
.BagFull
	ld a, $7
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_CASCADEBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_CASCADEBADGE, [hl]

	; deactivate gym trainers
	SetEvents EVENT_BEAT_CERULEAN_GYM_TRAINER_0, EVENT_BEAT_CERULEAN_GYM_TRAINER_1

	jp CeruleanGymResetScripts

CeruleanGym_TextPointers:
	dw MistyText
	dw CeruleanGymTrainerText1
	dw CeruleanGymTrainerText2
	dw CeruleanGymGuideText
	dw MistyCascadeBadgeInfoText
	dw ReceivedTM11Text
	dw TM11NoRoomText

CeruleanGymTrainerHeaders:
	def_trainers 2
CeruleanGymTrainerHeader0:
	trainer EVENT_BEAT_CERULEAN_GYM_TRAINER_0, 3, CeruleanGymBattleText1, CeruleanGymEndBattleText1, CeruleanGymAfterBattleText1
CeruleanGymTrainerHeader1:
	trainer EVENT_BEAT_CERULEAN_GYM_TRAINER_1, 3, CeruleanGymBattleText2, CeruleanGymEndBattleText2, CeruleanGymAfterBattleText2
	db -1 ; end

MistyText:
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM11
	jr nz, .afterBeat
	call z, CeruleanGymReceiveTM11
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld hl, TM11ExplanationText
	rst _PrintText
	jr .done
.beforeBeat
	ld hl, MistyPreBattleText
	rst _PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ReceivedCascadeBadgeText
	ld de, ReceivedCascadeBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $2
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, $3
	ld [wCeruleanGymCurScript], a
.done
	rst TextScriptEnd

MistyPreBattleText:
	text_far _MistyPreBattleText
	text_end

TM11ExplanationText:
	text_far _TM11ExplanationText
	text_end

MistyCascadeBadgeInfoText:
	text_far _MistyCascadeBadgeInfoText
	text_end

ReceivedTM11Text:
	text_far _ReceivedTM11Text
	sound_get_item_1
	text_end

TM11NoRoomText:
	text_far _TM11NoRoomText
	text_end

ReceivedCascadeBadgeText:
	text_far _ReceivedCascadeBadgeText
	sound_get_key_item ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	text_promptbutton
	text_end

CeruleanGymTrainerText1:
	text_asm
	ld hl, CeruleanGymTrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

CeruleanGymBattleText1:
	text_far _CeruleanGymBattleText1
	text_end

CeruleanGymEndBattleText1:
	text_far _CeruleanGymEndBattleText1
	text_end

CeruleanGymAfterBattleText1:
	text_far _CeruleanGymAfterBattleText1
	text_end

CeruleanGymTrainerText2:
	text_asm
	ld hl, CeruleanGymTrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

CeruleanGymBattleText2:
	text_far _CeruleanGymBattleText2
	text_end

CeruleanGymEndBattleText2:
	text_far _CeruleanGymEndBattleText2
	text_end

CeruleanGymAfterBattleText2:
	text_far _CeruleanGymAfterBattleText2
	text_end

CeruleanGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	CheckEvent EVENT_BEAT_MISTY
	jr nz, .afterBeat
	ld hl, CeruleanGymGuidePreBattleText
	rst _PrintText
	jr .done
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	jr z, .donePost
	ld hl, CeruleanGymGuidePostBattleTextPrompt
	rst _PrintText
	CheckEvent EVENT_GOT_CERULEAN_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText2
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedApexChipsText2
	rst _PrintText
	ld hl, CeruleanGymGuideApexChipWaterText
	rst _PrintText
	SetEvent EVENT_GOT_CERULEAN_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText2
	rst _PrintText
	jr .done
.BagFull
	ld hl, ApexNoRoomText2
	rst _PrintText
.done
	rst TextScriptEnd
.donePost
	ld hl, CeruleanGymGuidePostBattleTextDone
	rst _PrintText
	jr .done


ReceivedApexChipsText2:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText2:
	text_far _TM34NoRoomText
	text_end

GymGuideMoreApexChipText2:
	text_far _GymGuideMoreApexChipText
	text_end

AlreadyReceivedApexChipsText2:
	text_far _AlreadyReceivedApexChipsText
	text_end

CeruleanGymGuidePreBattleText:
	text_far _CeruleanGymGuidePreBattleText
	text_end

CeruleanGymGuidePostBattleTextPrompt:
	text_far _CeruleanGymGuidePostBattleText
	text_promptbutton
	text_end

CeruleanGymGuidePostBattleTextDone:
	text_far _CeruleanGymGuidePostBattleText
	text_end

ReceivedApexChipsText::
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

CeruleanGymGuideApexChipWaterText:
	text_far _CeruleanGymGuideApexChipWaterText
	text_end