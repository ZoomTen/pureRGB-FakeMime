VermilionCity_Script:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, .initCityScript
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, .setFirstLockTrashCanIndex
	ld hl, VermilionCity_ScriptPointers
	ld a, [wVermilionCityCurScript]
	jp CallFunctionInTable

.setFirstLockTrashCanIndex
	call Random
	ldh a, [hRandomSub]
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

.initCityScript
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, $2
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_ScriptPointers:
	dw VermilionCityScript0
	dw VermilionCityScript1
	dw VermilionCityScript2
	dw VermilionCityScript3
	dw VermilionCityScript4

VermilionCityScript0:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ldh [hJoyHeld], a
	ld [wcf0d], a
	ld a, $3
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, [wObtainedBadges] ; PureRGBnote: CHANGED: ship returns after obtaining the soul badge so let the player in if they have the ticket
	bit 4, a
	jr nz, .default
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
.default
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.shipHasDeparted
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wVermilionCityCurScript], a
	ret

SSAnneTicketCheckCoords:
	dbmapcoord 18, 30
	db -1 ; end

VermilionCityScript4:
	ld hl, SSAnneTicketCheckCoords
	call ArePlayerCoordsInArray
	ret c
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ldh [hJoyHeld], a
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	rst _DelayFrames
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCity_TextPointers:
	dw VermilionCityText1
	dw VermilionCityText2
	dw VermilionCityText3
	dw VermilionCityText4
	dw VermilionCityText5
	dw VermilionCityText6
	dw VermilionCityDockBeautyText
	dw VermilionCityText7
	dw VermilionCityText8
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText11
	dw VermilionCityText12
	dw VermilionCityText13

VermilionCityText1:
	text_far _VermilionCityText1
	text_end

VermilionCityText2:
	text_asm
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
	ld hl, VermilionCityTextDidYouSee
	rst _PrintText
	jr .end
.shipHasDeparted
	ld hl, VermilionCityTextSSAnneDeparted
	rst _PrintText
.end
	rst TextScriptEnd

VermilionCityTextDidYouSee:
	text_far _VermilionCityTextDidYouSee
	text_end

VermilionCityTextSSAnneDeparted:
	text_far _VermilionCityTextSSAnneDeparted
	text_end

VermilionCityText3:
	text_asm
	ld a, [wObtainedBadges]
	bit 4, a ; PureRGBnote: CHANGED: after obtaining soul badge the ship returns so this NPC will talk about it
	jr nz, .default
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .shipHasDeparted
.default
	ld a, [wSpritePlayerStateData1FacingDirection]
	cp SPRITE_FACING_RIGHT
	jr z, .greetPlayer
	ld hl, .inFrontOfOrBehindGuardCoords
	call ArePlayerCoordsInArray
	jr nc, .greetPlayerAndCheckTicket
.greetPlayer
	ld hl, SSAnneWelcomeText4
	rst _PrintText
	jr .end
.greetPlayerAndCheckTicket
	ld hl, SSAnneWelcomeText9
	rst _PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .playerHasTicket
	ld hl, SSAnneNoTicketText
	rst _PrintText
	jr .end
.playerHasTicket
	ld hl, SSAnneFlashedTicketText
	rst _PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .end
.shipHasDeparted
	ld hl, SSAnneNotHereText
	rst _PrintText
.end
	rst TextScriptEnd

.inFrontOfOrBehindGuardCoords
	dbmapcoord 19, 29 ; in front of guard
	dbmapcoord 19, 31 ; behind guard
	db -1 ; end

SSAnneWelcomeText4:
	text_far _SSAnneWelcomeText4
	text_end

SSAnneWelcomeText9:
	text_far _SSAnneWelcomeText9
	text_end

SSAnneFlashedTicketText:
	text_far _SSAnneFlashedTicketText
	text_end

SSAnneNoTicketText:
	text_far _SSAnneNoTicketText
	text_end

SSAnneNotHereText:
	text_far _SSAnneNotHereText
	text_end

VermilionCityText4:
	text_far _VermilionCityText4
	text_end

VermilionCityText5:
	text_far _VermilionCityText5
	text_asm
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityText14
	ret

VermilionCityText14:
	text_far _VermilionCityText14
	text_end

VermilionCityText6:
	text_asm
	ld a, [wObtainedBadges]
	bit 4, a ; after obtaining the soul badge the ship returns
	jr z, .default
	ld hl, VermilionCityText15
	ret
.default
	ld hl, VermilionCityText6get
	ret

VermilionCityText6get:
	text_far _VermilionCityText6
	text_end

VermilionCityText15:
	text_far _VermilionCityText15
	text_end

VermilionCityText7:
	text_far _VermilionCityText7
	text_end

VermilionCityText8:
	text_far _VermilionCityText8
	text_end

VermilionCityText11:
	text_far _VermilionCityText11
	text_end

VermilionCityText12:
	text_far _VermilionCityText12
	text_end

VermilionCityText13:
	text_far _VermilionCityText13
	text_end

; PureRGBnote: ADDED: new NPC who will give you an item if found. Requires surf to even see this NPC's location.
VermilionCityDockBeautyText: 
	text_asm
	CheckEvent EVENT_GOT_DOCK_BEAUTY_ITEM
	jr nz, .endText
	ld hl, VermilionCityDockBeautyGreeting
	rst _PrintText
	lb bc, ITEM_VERMILION_SECRET_DOCK_BEAUTY_NEW, 1
	call GiveItem
	jr nc, .bagfull
	SetEvent EVENT_GOT_DOCK_BEAUTY_ITEM
	ld hl, VermilionCityDockBeautyReceivedItemText
	rst _PrintText
	jr .done
.bagfull
	ld hl, VermilionCityDockBeautyNoRoomText
	rst _PrintText
	jr .done
.endText
	ld hl, VermilionCityDockBeautyEndText
	rst _PrintText
.done
	rst TextScriptEnd

VermilionCityDockBeautyGreeting:
	text_far _VermilionCityDockBeautyGreeting
	text_end

VermilionCityDockBeautyNoRoomText:
	text_far _TM34NoRoomText
	text_end

VermilionCityDockBeautyReceivedItemText:
	text_far _VermilionCityDockBeautyReceivedItemText
	sound_get_key_item
	text_end

VermilionCityDockBeautyEndText:
	text_far _VermilionCityDockBeautyEndText
	text_end