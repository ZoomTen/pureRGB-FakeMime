SilphCo10F_Object:
	db $2e ; border block

	def_warp_events
	warp_event  8,  0, SILPH_CO_9F, 1
	warp_event 10,  0, SILPH_CO_11F, 1
	warp_event 12,  0, SILPH_CO_ELEVATOR, 1
	warp_event  9, 11, SILPH_CO_4F, 4
	warp_event 13, 15, SILPH_CO_4F, 6
	warp_event 13,  7, SILPH_CO_4F, 7

	def_bg_events

	def_object_events
	object_event  1,  9, SPRITE_ROCKET, STAY, RIGHT, 1, OPP_ROCKET, 39
	object_event 10,  2, SPRITE_SCIENTIST, STAY, LEFT, 2, OPP_SCIENTIST, 11
	object_event  9, 15, SPRITE_SILPH_WORKER_WOMAN, WALK, ANY_DIR, 3 ; person
	object_event  2, 12, SPRITE_POKE_BALL, STAY, NONE, 4, TM_SILPH_CO_10F_BOXES_LEFT
	object_event  4, 14, SPRITE_POKE_BALL, STAY, NONE, 5, ITEM_SILPH_CO_10F_BOXES_BOTTOM
	object_event  5, 11, SPRITE_POKE_BALL, STAY, NONE, 6, ITEM_SILPH_CO_10F_BOXES_RIGHT

	def_warps_to SILPH_CO_10F
