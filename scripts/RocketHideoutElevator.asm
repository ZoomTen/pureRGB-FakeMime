RocketHideoutElevator_Script:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	push hl
	call nz, RocketHideoutElevatorScript_4572c
	pop hl
	bit 7, [hl]
	res 7, [hl]
	call nz, RocketHideoutElevatorScript_4575f
	xor a
	ld [wAutoTextBoxDrawingControl], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ret

RocketHideoutElevatorScript_4572c:
	ld hl, wWarpEntries
	ld a, [wWarpedFromWhichWarp]
	ld b, a
	ld a, [wWarpedFromWhichMap]
	ld c, a
	call RocketHideoutElevatorScript_4573a

RocketHideoutElevatorScript_4573a:
	inc hl
	inc hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ret

RocketHideoutElevatorScript_45741:
	ld hl, RocketHideoutElavatorFloors
	call LoadItemList
	ld hl, RocketHideoutElevatorWarpMaps
	ld de, wElevatorWarpMaps
	ld bc, RocketHideoutElevatorWarpMapsEnd - RocketHideoutElevatorWarpMaps
	rst _CopyData
	ret

RocketHideoutElavatorFloors:
	db 3 ; #
	db FLOOR_B1F
	db FLOOR_B2F
	db FLOOR_B4F
	db -1 ; end

; These specify where the player goes after getting out of the elevator.
RocketHideoutElevatorWarpMaps:
	; warp number, map id
	db 4, ROCKET_HIDEOUT_B1F
	db 4, ROCKET_HIDEOUT_B2F
	db 2, ROCKET_HIDEOUT_B4F
RocketHideoutElevatorWarpMapsEnd:

RocketHideoutElevatorScript_4575f:
	call Delay3
	farcall ShakeElevator
	ret

RocketHideoutElevator_TextPointers:
	dw RocketHideoutElevatorText1

RocketHideoutElevatorText1:
	text_asm
;;;;;;;;;; PureRGBnote: CHANGED: lift key is consumed upon unlocking the elevator, making it usable permanently 
	CheckEvent EVENT_USED_LIFT_KEY 
	jr nz, .startLift
	ld b, LIFT_KEY
	predef GetIndexOfItemInBag
	ld a, b
	cp $FF ; not in bag
	jr z, .asm_45782
	; if we have the LIFT_KEY, remove it from bag and unlock the elevator forever
	ld [wWhichPokemon], a ; load item index to be removed
	ld hl, wNumBagItems
	ld a, 1 ; one item
	ld [wItemQuantity], a
	call RemoveItemFromInventory
	SetEvent EVENT_USED_LIFT_KEY
    ld a, SFX_SWITCH
    rst _PlaySound
    call WaitForSoundToFinish
	ld hl, UnlockedElevatorText
	rst _PrintText
.startLift
;;;;;;;;;;
	call RocketHideoutElevatorScript_45741
	ld hl, RocketHideoutElevatorWarpMaps
	predef DisplayElevatorFloorMenu
	jr .asm_45788
.asm_45782
	ld hl, RocketHideoutElevatorText_4578b
	rst _PrintText
.asm_45788
	rst TextScriptEnd

UnlockedElevatorText:
	text_far _UnlockedElevatorText
	text_end

RocketHideoutElevatorText_4578b:
	text_far _RocketElevatorText_4578b
	text_waitbutton
	text_end
