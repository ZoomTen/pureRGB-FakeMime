RockTunnelB1F_Object:
	db $3 ; border block

	def_warp_events
	warp_event 33, 25, ROCK_TUNNEL_1F, 5
	warp_event 27,  3, ROCK_TUNNEL_1F, 6
	warp_event 23, 11, ROCK_TUNNEL_1F, 7
	warp_event  3,  3, ROCK_TUNNEL_1F, 8

	def_bg_events

	def_object_events
	object_event 11, 13, SPRITE_COOLTRAINER_F, STAY, DOWN, 1, OPP_JR_TRAINER_F, 9
	object_event  6, 10, SPRITE_HIKER, STAY, DOWN, 2, OPP_HIKER, 9
	object_event  3,  5, SPRITE_SUPER_NERD, STAY, DOWN, 3, OPP_POKEMANIAC, 3
	object_event 20, 21, SPRITE_SUPER_NERD, STAY, RIGHT, 4, OPP_POKEMANIAC, 4
	object_event 30, 10, SPRITE_HIKER, STAY, DOWN, 5, OPP_HIKER, 10
	object_event 14, 28, SPRITE_COOLTRAINER_F, STAY, RIGHT, 6, OPP_JR_TRAINER_F, 10
	object_event 33,  5, SPRITE_HIKER, STAY, RIGHT, 7, OPP_HIKER, 15
	object_event 26, 30, SPRITE_SUPER_NERD, STAY, DOWN, 8, OPP_POKEMANIAC, 5
	object_event 4,  31, SPRITE_POKE_BALL, STAY, NONE, 9, TM_ROCK_TUNNEL_B1F_SOUTHWEST_CORNER_NEW
	object_event 4,  25, SPRITE_POKE_BALL, STAY, NONE, 10, ITEM_ROCK_TUNNEL_B1F_WEST_NEW


	def_warps_to ROCK_TUNNEL_B1F
