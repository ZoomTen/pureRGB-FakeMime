NameRatersHouse_Script:
	jp EnableAutoTextBoxDrawing

NameRaterScript_1da15:
	rst _PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ret

;NameRaterScript_1da20: ; PureRGBnote: CHANGED: Name Rater will always allow you to rename pokemon regardless of their OT.
;	ld hl, wPartyMonOT
;	ld bc, NAME_LENGTH
;	ld a, [wWhichPokemon]
;	call AddNTimes
;	ld de, wPlayerName
;	ld c, NAME_LENGTH
;	call .asm_1da47
;	jr c, .asm_1da52
;	ld hl, wPartyMon1OTID
;	ld bc, wPartyMon2 - wPartyMon1
;	ld a, [wWhichPokemon]
;	call AddNTimes
;	ld de, wPlayerID
;	ld c, $2
;.asm_1da47
;	ld a, [de]
;	cp [hl]
;	jr nz, .asm_1da52
;	inc hl
;	inc de
;	dec c
;	jr nz, .asm_1da47
;	and a
;	ret
;.asm_1da52
;	scf
;	ret

NameRatersHouse_TextPointers:
	dw NameRaterText1

NameRaterText1:
	text_asm
	call SaveScreenTilesToBuffer2
	ld hl, NameRaterText_1dab3
	call NameRaterScript_1da15
	jr nz, .asm_1daae
	ld hl, NameRaterText_1dab8
	rst _PrintText
	xor a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wUpdateSpritesEnabled], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	jr c, .asm_1daae
	call GetPartyMonName2
	; call NameRaterScript_1da20
	; ld hl, NameRaterText_1dad1
	; jr c, .asm_1daa8
	ld hl, NameRaterText_1dabd
	call NameRaterScript_1da15
	jr nz, .asm_1daae
	ld hl, NameRaterText_1dac2
	rst _PrintText
	farcall DisplayNameRaterScreen
	jr c, .asm_1daae
	ld hl, NameRaterText_1dac7
.asm_1daa8
	rst _PrintText
	rst TextScriptEnd
.asm_1daae
	ld hl, NameRaterText_1dacc
	jr .asm_1daa8

NameRaterText_1dab3:
	text_far _NameRaterText_1dab3
	text_end

NameRaterText_1dab8:
	text_far _NameRaterText_1dab8
	text_end

NameRaterText_1dabd:
	text_far _NameRaterText_1dabd
	text_end

NameRaterText_1dac2:
	text_far _NameRaterText_1dac2
	text_end

NameRaterText_1dac7:
	text_far _NameRaterText_1dac7
	text_end

NameRaterText_1dacc:
	text_far _NameRaterText_1dacc
	text_end

NameRaterText_1dad1:
	text_far _NameRaterText_1dad1
	text_end
