BillsHouse_Object:
	db $d ; border block

	def_warp_events
	warp_event  2,  7, ROUTE_25, 1
	warp_event  3,  7, ROUTE_25, 1
	warp_event  3,  0, BILLS_GARDEN, 1
	warp_event  4,  0, BILLS_GARDEN, 2

	def_bg_events

	def_object_events
	object_event  6,  5, SPRITE_MONSTER, STAY, NONE, 1 ; person
	object_event  4,  4, SPRITE_SUPER_NERD, STAY, NONE, 2 ; person
	object_event  6,  5, SPRITE_SUPER_NERD, STAY, NONE, 3 ; person

	def_warps_to BILLS_HOUSE
