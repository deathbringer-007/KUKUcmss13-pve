/datum/weather_event/light_rain
	name = "Light Rain"
	display_name = "小雨"
	length = 8 MINUTES

	turf_overlay_icon_state = "strata_storm"
	turf_overlay_alpha = 50

	effect_message = null
	damage_per_tick = 0

	ambience = 'sound/ambience/rainforest.ogg'

	fire_smothering_strength = 1

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
