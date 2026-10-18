/datum/weather_event/dust
	name = "Duststorm"
	display_name = "尘暴"
	length = 6 MINUTES
	turf_overlay_icon_state = "bigred_dust"

	effect_message = "灰尘吹进了你身上的每一道缝隙，令人烦躁。"
	damage_per_tick = 0
	damage_type = BRUTE

	ambience = 'sound/ambience/strata/strata_snow.ogg'

	fire_smothering_strength = 1

/datum/weather_event/rock
	name = "Rockstorm"
	display_name = "飞石风暴"
	length = 2 MINUTES
	turf_overlay_icon_state = "bigred_rocks"

	effect_message = "你感到许多小石块击打着全身！"
	damage_per_tick = 3
	damage_type = BRUTE

	ambience = 'sound/ambience/strata/strata_blizzard.ogg'

	fire_smothering_strength = 3
