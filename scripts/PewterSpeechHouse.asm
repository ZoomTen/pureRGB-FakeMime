PewterSpeechHouse_Script:
	jp EnableAutoTextBoxDrawing

PewterSpeechHouse_TextPointers:
	dw PewterHouse2Text1
	dw PewterHouse2Text2
	dw PewterHouse2Text3

PewterHouse2Text1:
	text_far _PewterHouse2Text1
	text_end

PewterHouse2Text2:
	text_far _PewterHouse2Text2
	text_end

; PureRGBnote: ADDED: new NPC who will give you POCKET ABRA once you return their LOST WALLET
PewterHouse2Text3: 
	text_asm
		CheckEvent EVENT_RETURNED_LOST_WALLET
		jr nz, .howsAbra
		ld b, LOST_WALLET
		call IsItemInBag
		jr nz, .have_lost_wallet
		ld hl, PewterHouse2Text3Intro
		rst _PrintText
		SetEvent EVENT_MET_POCKET_ABRA_LADY
		jr .done
	.have_lost_wallet
		ld hl, PewterHouse2Text3Found
		rst _PrintText
		ld a, LOST_WALLET
		ldh [hItemToRemoveID], a
		farcall RemoveItemByID
		lb bc, POCKET_ABRA, 1
		call GiveItem ; not possible to have no room for this item because you just gave the LOST WALLET away
		ld hl, ReceivedPocketAbraText
		rst _PrintText
		SetEvent EVENT_RETURNED_LOST_WALLET
		ld a, ABRA
		ld [wcf91], a
		ld [wd11e], a
		call PlayCry
		ld a, SFX_GET_ITEM_2
		call PlaySoundWaitForCurrent
		call WaitForSoundToFinish
		ld a, NAME_MON_SCREEN
		ld [wNamingScreenType], a
		ld hl, wPocketAbraNick
		predef AskName
		call DisableWaitingAfterTextDisplay
		call CloseTextDisplay
		jr .done
	.howsAbra
		ld hl, PewterHouse2Text3HowsAbra
		rst _PrintText
	.done
		rst TextScriptEnd

PewterHouse2Text3Intro:
	text_far _PewterHouse2Text3Intro
	text_end

PewterHouse2Text3Found:
	text_far _PewterHouse2Text3Found
	text_end

PewterHouse2Text3HowsAbra:
	text_far _PewterHouse2Text3After
	text_end

ReceivedPocketAbraText:
	text_far _ReceivedPocketAbraText
	text_end