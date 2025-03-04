; PureRGBnote: ADDED: code was added to make doors appear at the back of Bills House once you become champ.
; Bill will also talk about his new beach garden.

BillsHouse_Script:
	call BillsHouseAddDoors
	call EnableAutoTextBoxDrawing
	ld a, [wBillsHouseCurScript]
	ld hl, BillsHouse_ScriptPointers
	jp CallFunctionInTable

BillsHouseAddDoors:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ResetEvent EVENT_IN_BILLS_GARDEN
	CheckEvent EVENT_BECAME_CHAMP
	ret z
	ld de, BillsHouseTileBlockReplacements
	callfar ReplaceMultipleTileBlocks
	; if the player's standing on y-coordinate 0 on loading the map, it means they entered from the top. 
	; They need to be forced to walk out from the doorway. It doesn't work the normal way because of the tile blocks still needing to be replaced.
	ld a, [wYCoord] 
	and a
	ret nz
	jpfar ForceStepOutFromDoor

BillsHouse_ScriptPointers:
	dw BillsHouseScript0
	dw BillsHouseScript1
	dw BillsHouseScript2
	dw BillsHouseScript3
	dw BillsHouseScript4
	dw BillsHouseScript5

BillsHouseScript0:
	ret

BillsHouseScript1:
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a ; cp SPRITE_FACING_DOWN
	ld de, MovementData_1e79c
	jr nz, .notDown
	ld de, MovementData_1e7a0
.notDown
	ld a, $1
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, $2
	ld [wBillsHouseCurScript], a
	ret

MovementData_1e79c:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

; make Bill walk around the player
MovementData_1e7a0:
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db -1 ; end

BillsHouseScript2:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_BILL_POKEMON
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_BILL_SAID_USE_CELL_SEPARATOR
	xor a
	ld [wJoyIgnore], a
	ld a, $3
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript3:
	CheckEvent EVENT_USED_CELL_SEPARATOR_ON_BILL
	ret z
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $2
	ld [wSpriteIndex], a
	ld a, $c
	ldh [hSpriteScreenYCoord], a
	ld a, $40
	ldh [hSpriteScreenXCoord], a
	ld a, 6
	ldh [hSpriteMapYCoord], a
	ld a, 5
	ldh [hSpriteMapXCoord], a
	call SetSpritePosition1
	ld a, HS_BILL_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld c, 8
	rst _DelayFrames
	ld a, $2
	ldh [hSpriteIndex], a
	ld de, MovementData_1e807
	call MoveSprite
	ld a, $4
	ld [wBillsHouseCurScript], a
	ret

MovementData_1e807:
	db NPC_MOVEMENT_DOWN
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_RIGHT
	db NPC_MOVEMENT_DOWN
	db -1 ; end

BillsHouseScript4:
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	SetEvent EVENT_MET_BILL_2 ; this event seems redundant
	SetEvent EVENT_MET_BILL
	ld a, $0
	ld [wBillsHouseCurScript], a
	ret

BillsHouseScript5:
	ld a, $4
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $0
	ld [wBillsHouseCurScript], a
	ret

BillsHouse_TextPointers:
	dw BillsHouseText1
	dw BillsHouseText2
	dw BillsHouseText3
	dw BillsHouseText4

BillsHouseText4:
	script_bills_pc

BillsHouseText1:
	text_asm
	ld hl, BillsHouseText_1e865
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_1e85a
.asm_1e84d
	ld hl, BillsHouseText_1e86a
	rst _PrintText
	ld a, $1
	ld [wBillsHouseCurScript], a
	jr .asm_1e862
.asm_1e85a
	ld hl, BillsHouseText_1e86f
	rst _PrintText
	jr .asm_1e84d
.asm_1e862
	rst TextScriptEnd

BillsHouseText_1e865:
	text_far _BillsHouseText_1e865
	text_end

BillsHouseText_1e86a:
	text_far _BillsHouseText_1e86a
	text_end

BillsHouseText_1e86f:
	text_far _BillsHouseText_1e86f
	text_end

BillsHouseText2:
	text_asm
	CheckEvent EVENT_GOT_SS_TICKET
	jr nz, .asm_1e8a9
	ld hl, BillThankYouText
	rst _PrintText
	lb bc, S_S_TICKET, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, SSTicketReceivedText
	rst _PrintText
	SetEvent EVENT_GOT_SS_TICKET
	ld a, HS_CERULEAN_GUARD_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_CERULEAN_GUARD_2
	ld [wMissableObjectIndex], a
	predef HideObject
.asm_1e8a9
	ld hl, BillsHouseText_1e8cb
	rst _PrintText
	jr .asm_1e8b7
.BagFull
	ld hl, SSTicketNoRoomText
	rst _PrintText
.asm_1e8b7
	rst TextScriptEnd

BillThankYouText:
	text_far _BillThankYouText
	text_end

SSTicketReceivedText:
	text_far _SSTicketReceivedText
	sound_get_key_item
	text_promptbutton
	text_end

SSTicketNoRoomText:
	text_far _SSTicketNoRoomText
	text_end

BillsHouseText_1e8cb:
	text_far _BillsHouseText_1e8cb
	text_end

BillsHouseText3:
	text_asm
	CheckEvent EVENT_BECAME_CHAMP
	ld hl, BillsHouseText_1e8da
	jr z, .done
	ld hl, BillsHouseGardenInfo
.done
	rst _PrintText
	rst TextScriptEnd

BillsHouseText_1e8da:
	text_far _BillsHouseText_1e8da
	text_end

BillsHouseGardenInfo:
	text_far _BillsHouseGardenInfo
	text_end
