CeruleanTrashedHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

CeruleanTrashedHouse_TextPointers:
	dw CeruleanHouseTrashedText1
	dw CeruleanHouseTrashedText2
	dw CeruleanHouseTrashedText3

CeruleanHouseTrashedText1:
	text_asm
	ld b, TM_CERULEAN_ROCKET_TM_THIEF
	predef GetQuantityOfItemInBag
	and b
	jr z, .no_dig_tm
	ld hl, CeruleanHouseTrashedText_1d6b0
	rst _PrintText
	jr .done
.no_dig_tm
	ld hl, CeruleanHouseTrashedText_1d6ab
	rst _PrintText
.done
	rst TextScriptEnd

CeruleanHouseTrashedText_1d6ab:
	text_far _CeruleanTrashedText_1d6ab
	text_end

CeruleanHouseTrashedText_1d6b0:
	text_far _CeruleanTrashedText_1d6b0
	text_end

CeruleanHouseTrashedText2:
	text_far _CeruleanHouseTrashedText2
	text_end

CeruleanHouseTrashedText3:
	text_far _CeruleanHouseTrashedText3
	text_end
