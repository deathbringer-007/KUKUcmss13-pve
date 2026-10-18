// Weather events for Sorokyne
/datum/weather_event/snow
	name = "Snow"
	display_name = "降雪"
	length = 10 MINUTES
	turf_overlay_icon_state = "strata_snowing"

	effect_message = "你感到冰冷的风正带走体温！"
	damage_per_tick = 0

	ambience = 'sound/ambience/strata/strata_snow.ogg'

	fire_smothering_strength = 3

/datum/weather_event/snowstorm
	name = "Snowstorm"
	display_name = "暴雪"
	length = 6 MINUTES
	turf_overlay_icon_state = "strata_storm"

	effect_message = "暴雪中的寒风让你冷彻骨髓！"
	damage_per_tick = 0.125

	ambience = 'sound/ambience/strata/strata_snowstorm.ogg'

	fire_smothering_strength = 4

/datum/weather_event/blizzard
	name = "Blizzard"
	display_name = "暴风雪"
	length = 4 MINUTES
	turf_overlay_icon_state = "strata_blizzard"

	effect_message = "你感到暴风雪中的寒风正在夺走你全身的热量！"
	damage_per_tick = 0.25

	ambience = 'sound/ambience/strata/strata_blizzard.ogg'

	fire_smothering_strength = 6
