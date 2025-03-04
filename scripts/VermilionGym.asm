VermilionGym_Script:
	ld hl, wCurrentMapScriptFlags
	res 5, [hl]
	bit 6, [hl]
	res 6, [hl]
	call nz, VermilionGymSetDoorTile
	call EnableAutoTextBoxDrawing
	ld hl, VermilionGymTrainerHeaders
	ld de, VermilionGym_ScriptPointers
	ld a, [wVermilionGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVermilionGymCurScript], a
	ret

VermilionGymSetDoorTile:
	CheckEvent EVENT_2ND_LOCK_OPENED
	jr nz, .doorsOpen
	ld a, $24 ; double door tile ID
	jr .replaceTile
.doorsOpen
	ld a, SFX_GO_INSIDE
	rst _PlaySound
	ld a, $5 ; clear floor tile ID
.replaceTile
	ld [wNewTileBlockID], a
	lb bc, 2, 2
	predef ReplaceTileBlock
	ld hl, wCurrentMapScriptFlags
	bit 3, [hl]
	res 3, [hl]
	ret z
	jp GBFadeInFromWhite ; PureRGBnote: ADDED: since trainer instantly talks to us after battle we need to fade back in here

VermilionGymResetScripts:
	xor a
	ld [wJoyIgnore], a
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
	ret

VermilionGym_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw VermilionGymLTSurgePostBattle

VermilionGymLTSurgePostBattle:
	ld a, [wIsInBattle]
	cp $ff ; did we lose?
	jp z, VermilionGymResetScripts
	ld a, D_RIGHT | D_LEFT | D_UP | D_DOWN
	ld [wJoyIgnore], a

VermilionGymReceiveTM24:
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_LT_SURGE
	lb bc, TM_SURGE, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $7
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM24
	jr .gymVictory
.BagFull
	ld a, $8
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_THUNDERBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_THUNDERBADGE, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VERMILION_GYM_TRAINER_0, EVENT_BEAT_VERMILION_GYM_TRAINER_2

	jp VermilionGymResetScripts

VermilionGym_TextPointers:
	dw LTSurgeText
	dw VermilionGymTrainerText1
	dw VermilionGymTrainerText2
	dw VermilionGymTrainerText3
	dw VermilionGymGuideText
	dw LTSurgeThunderBadgeInfoText
	dw ReceivedTM24Text
	dw TM24NoRoomText

VermilionGymTrainerHeaders:
	def_trainers 2
VermilionGymTrainerHeader0:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_0, 3, VermilionGymBattleText1, VermilionGymEndBattleText1, VermilionGymAfterBattleText1
VermilionGymTrainerHeader1:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_1, 2, VermilionGymBattleText2, VermilionGymEndBattleText2, VermilionGymAfterBattleText2
VermilionGymTrainerHeader2:
	trainer EVENT_BEAT_VERMILION_GYM_TRAINER_2, 3, VermilionGymBattleText3, VermilionGymEndBattleText3, VermilionGymAfterBattleText3
	db -1 ; end

LTSurgeText:
	text_asm
	CheckEvent EVENT_BEAT_LT_SURGE
	jr z, .beforeBeat
	CheckEventReuseA EVENT_GOT_TM24
	jr nz, .afterBeat
	call z, VermilionGymReceiveTM24
	call DisableWaitingAfterTextDisplay
	jr .done
.afterBeat
	ld hl, LTSurgePostBattleAdviceText
	rst _PrintText
	jr .done
.beforeBeat
	ld hl, LTSurgePreBattleText
	rst _PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ReceivedThunderBadgeText
	ld de, ReceivedThunderBadgeText
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, $3 ; set script index to LT Surge post-battle script
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
.done
	rst TextScriptEnd

LTSurgePreBattleText:
	text_far _LTSurgePreBattleText
	text_end

LTSurgePostBattleAdviceText:
	text_far _LTSurgePostBattleAdviceText
	text_end

LTSurgeThunderBadgeInfoText:
	text_far _LTSurgeThunderBadgeInfoText
	text_end

ReceivedTM24Text:
	text_far _ReceivedTM24Text
	sound_get_key_item
	text_far _TM24ExplanationText
	text_end

TM24NoRoomText:
	text_far _TM24NoRoomText
	text_end

ReceivedThunderBadgeText:
	text_far _ReceivedThunderBadgeText
	text_end

VermilionGymTrainerText1:
	text_asm
	ld hl, VermilionGymTrainerHeader0
	call TalkToTrainer
	rst TextScriptEnd

VermilionGymBattleText1:
	text_far _VermilionGymBattleText1
	text_end

VermilionGymEndBattleText1:
	text_far _VermilionGymEndBattleText1
	text_end

VermilionGymAfterBattleText1:
	text_far _VermilionGymAfterBattleText1
	text_end

VermilionGymTrainerText2:
	text_asm
	ld hl, VermilionGymTrainerHeader1
	call TalkToTrainer
	rst TextScriptEnd

VermilionGymBattleText2:
	text_far _VermilionGymBattleText2
	text_end

VermilionGymEndBattleText2:
	text_far _VermilionGymEndBattleText2
	text_end

VermilionGymAfterBattleText2:
	text_far _VermilionGymAfterBattleText2
	text_end

VermilionGymTrainerText3:
	text_asm
	ld hl, VermilionGymTrainerHeader2
	call TalkToTrainer
	rst TextScriptEnd

VermilionGymBattleText3:
	text_far _VermilionGymBattleText3
	text_end

VermilionGymEndBattleText3:
	text_far _VermilionGymEndBattleText3
	text_end

VermilionGymAfterBattleText3:
	text_far _VermilionGymAfterBattleText3
	text_end

VermilionGymGuideText: ; PureRGBnote: ADDED: gym guide gives you apex chips after beating the leader
	text_asm
	ld a, [wBeatGymFlags]
	bit BIT_THUNDERBADGE, a
	jr nz, .afterBeat
	ld hl, VermilionGymGuidePreBattleText
	rst _PrintText
	jr .done
.afterBeat
	CheckEvent EVENT_GOT_PEWTER_APEX_CHIPS ; have to hear about apex chips to receive them after that
	jr z, .postNoPrompt
	ld hl, VermilionGymGuidePostBattleTextPrompt
	rst _PrintText
	CheckEvent EVENT_GOT_VERMILION_APEX_CHIPS
	jr nz, .alreadyApexChips
.giveApexChips
	ld hl, GymGuideMoreApexChipText3
	rst _PrintText
	lb bc, APEX_CHIP, 2
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedApexChipsText3
	rst _PrintText
	ld hl, VermilionGymGuideApexChipElectricText
	rst _PrintText
	SetEvent EVENT_GOT_VERMILION_APEX_CHIPS
.alreadyApexChips
	ld hl, AlreadyReceivedApexChipsText3
	rst _PrintText
	jr .done
.BagFull
	ld hl, ApexNoRoomText3
	rst _PrintText
.done
	rst TextScriptEnd
.postNoPrompt
	ld hl, VermilionGymGuidePostBattleText
	rst _PrintText
	jr .done

ReceivedApexChipsText3:
	text_far _ReceivedApexChipsText
	sound_get_item_1
	text_end

ApexNoRoomText3:
	text_far _TM34NoRoomText
	text_end

GymGuideMoreApexChipText3:
	text_far _GymGuideMoreApexChipText
	text_end

AlreadyReceivedApexChipsText3:
	text_far _AlreadyReceivedApexChipsText
	text_end

VermilionGymGuidePreBattleText:
	text_far _VermilionGymGuidePreBattleText
	text_end

VermilionGymGuidePostBattleText:
	text_far _VermilionGymGuidePostBattleText
	text_end

VermilionGymGuidePostBattleTextPrompt:
	text_far _VermilionGymGuidePostBattleText
	text_promptbutton
	text_end

VermilionGymGuideApexChipElectricText:
	text_far _VermilionGymGuideApexChipElectricText
	text_end
