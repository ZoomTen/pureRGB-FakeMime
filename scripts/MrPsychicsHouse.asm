MrPsychicsHouse_Script:
	jp EnableAutoTextBoxDrawing

MrPsychicsHouse_TextPointers:
	dw SaffronHouse2Text1

SaffronHouse2Text1:
	text_asm
	CheckEvent EVENT_GOT_TM29
	jr nz, .got_item
	ld hl, TM29PreReceiveText
	rst _PrintText
	lb bc, TM_SAFFRON_CITY_MR_PSYCHIC, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ReceivedTM29Text
	rst _PrintText
	SetEvent EVENT_GOT_TM29
	jr .done
.bag_full
	ld hl, TM29NoRoomText
	rst _PrintText
	jr .done
.got_item
	ld hl, TM29ExplanationText
	rst _PrintText
.done
	rst TextScriptEnd

TM29PreReceiveText:
	text_far _TM29PreReceiveText
	text_end

ReceivedTM29Text:
	text_far _ReceivedTM29Text
	sound_get_item_1
	text_end

TM29ExplanationText:
	text_far _TM29ExplanationText
	text_end

TM29NoRoomText:
	text_far _TM29NoRoomText
	text_end
