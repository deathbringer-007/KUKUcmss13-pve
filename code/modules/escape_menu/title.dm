// This doesn't instantiate right away, since we rely on other GLOBs
GLOBAL_DATUM(escape_menu_title, /atom/movable/screen/escape_menu/title)

/// Provides a singleton for the escape menu details screen.
/proc/give_escape_menu_title()
	if (isnull(GLOB.escape_menu_title))
		GLOB.escape_menu_title = new

	return GLOB.escape_menu_title

/atom/movable/screen/escape_menu/title
	screen_loc = "NORTH:-100,WEST:32"
	maptext_height = 100
	maptext_width = 500

/atom/movable/screen/escape_menu/title/Initialize(mapload)
	. = ..()

	update_text()

/atom/movable/screen/escape_menu/title/Destroy()
	if (GLOB.escape_menu_title == src)
		stack_trace("Something tried to delete the escape menu details screen")
		return QDEL_HINT_LETMELIVE

	return ..()

/atom/movable/screen/escape_menu/title/proc/update_text()
	var/subtitle_text = MAPTEXT("<span style='font-size: 8px'>[SSmapping.configs[GROUND_MAP].disable_ship_map ? "正在此地作战……" : "身处[get_statistic_display_label(SSmapping.configs[SHIP_MAP].map_name)]，正绕行于……"]</span>")
	var/short_name = SSmapping.configs[GROUND_MAP].short_name
	var/static/list/map_short_labels = list(
		"Binhai" = "滨海",
		"Otogi Egress" = "御伽撤离点",
		"Bosenmori" = "博森莫里",
		"Route 44" = "44号公路",
		"Highway" = "公路",
		"Kleschers" = "克莱舍",
		"Chance's Claim" = "机遇矿区",
		"Oread Garrison" = "奥瑞亚德驻军基地",
		"Valley" = "山谷",
		"Sekhmet" = "塞赫迈特",
		"Taipei Station" = "台北中转站",
	)
	short_name = map_short_labels[short_name] || short_name
	var/title_text = {"
		<span style='font-weight: bolder; font-size: 24px'>
			[get_statistic_display_label(short_name ? short_name : SSmapping.configs[GROUND_MAP].map_name)]
		</span>
	"}

	maptext = "<font align='top'>" + subtitle_text + MAPTEXT_VCR_OSD_MONO(title_text) + "</font>"
