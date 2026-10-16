/datum/tier
	var/name = "Placeholder Name"
	var/tier = 0

	var/flags = NO_FLAGS

	var/disabled_color = COLOR_WHITE
	var/color = COLOR_WHITE
	var/max_techs = INFINITE_TECHS // Infinite

	var/list/turf/tier_turfs

	var/datum/techtree/holder

/datum/tier/New(datum/techtree/tree)
	. = ..()
	holder = tree

/datum/tier/free
	name = "初始等级"
	tier = 0
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY

/datum/tier/one
	name = "一级"
	tier = 1
	color = COLOR_GREEN
	disabled_color = "#007d00"

/datum/tier/one_transition_two
	name = "一级至二级过渡"
	tier = 1
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY
/datum/tier/two
	name = "二级"
	tier = 2
	color = "#FFAA00"
	disabled_color = "#7d5300"


/datum/tier/two_transition_three
	name = "二级至三级过渡"
	tier = 2
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY
/datum/tier/three
	name = "三级"
	tier = 3
	color = COLOR_RED
	disabled_color = "#7d0000"

/datum/tier/three_transition_four
	name = "三级至四级过渡"
	tier = 3
	color = COLOR_BLACK
	disabled_color = COLOR_BLACK

	flags = TIER_FLAG_TRANSITORY
/datum/tier/four
	name = "四级"
	tier = 4
	color = COLOR_MAGENTA
	disabled_color = "#7d007d"

	max_techs = 1
