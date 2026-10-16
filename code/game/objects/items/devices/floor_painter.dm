/obj/item/device/floor_painter
	name = "地板喷漆器"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "labeler1"
	item_state = "flight"

	var/mode_nice = "standard"
	var/mode = "floor"
	var/tile_dir_mode = 0

	// mode 0  ignore direction; sets dir=0
	// mode 1  all-direction
	// mode 2  corner selecting the side CW from the selected corner
	// mode 3  cardinal
	// mode 4  warningcorner and warnwhitecorner direction fix
	// mode 5  Opposite corner tiles where the second icon_state is "[mode]_inv"
/obj/item/device/floor_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if(istype(A, /turf/open/floor))
		var/turf/open/floor/F = A

		if(F.is_plasteel_floor()) // only tiled floors
			if(tile_dir_mode)
				var/D = get_dir(usr, F)
				if(usr.loc == F)
					D = usr.dir

				switch(tile_dir_mode)
					if(1) // All directions accepted
						F.setDir(D)
						F.icon_state = mode
					if(2) // Corner mode - diagonal directions converted CW around.
						switch(D)
							if(NORTHEAST)
								D = EAST
							if(SOUTHEAST)
								D = SOUTH
							if(SOUTHWEST)
								D = WEST
							if(NORTHWEST)
								D = NORTH
						F.setDir(D)
						F.icon_state = mode
					if(3) // cardinal directions only. I've adjusted diagonals the same way the facing code does.
						switch(D)
							if(NORTHEAST)
								D = EAST
							if(SOUTHEAST)
								D = EAST
							if(SOUTHWEST)
								D = WEST
							if(NORTHWEST)
								D = WEST
						F.setDir(D)
						F.icon_state = mode
					if(4) // floors.dmi icon_states "warningcorner" and "warnwhitecorner" are incorrect, this fixes it
						var/D2
						switch(D)
							if(NORTHEAST)
								D2 = WEST
							if(SOUTHEAST)
								D2 = SOUTH
							if(SOUTHWEST)
								D2 = NORTH
							if(NORTHWEST)
								D2 = EAST
						F.setDir(D2)
						F.icon_state = mode
					if(5)
						F.setDir(0)
						if(D == NORTH || D == SOUTH || D == NORTHEAST || D == SOUTHWEST)
							F.icon_state = mode
						else
							F.icon_state = "[mode]_inv"
			else
				F.setDir(0)
				F.icon_state = mode
		else
			to_chat(usr, "无法给它喷漆！")

/obj/item/device/floor_painter/proc/pattern_label(pattern)
	if(isnull(pattern))
		return null
	var/is_corner = copytext(pattern, -7) == " corner"
	if(is_corner)
		pattern = copytext(pattern, 1, -7)
	var/static/list/pattern_labels = list(
		"solid" = "纯色",
		"corner" = "边角",
		"opposite corners" = "对角",
		"side/three corners" = "侧边／三个角",
		"special" = "特殊",
		"letters" = "字母",
		"standard" = "标准",
		"dark" = "深色",
		"red" = "红色",
		"blue" = "蓝色",
		"green" = "绿色",
		"yellow" = "黄色",
		"purple" = "紫色",
		"neutral" = "中性色",
		"white" = "白色",
		"black" = "黑色",
		"white-red" = "白红",
		"white-blue" = "白蓝",
		"white-green" = "白绿",
		"white-yellow" = "白黄",
		"white-purple" = "白紫",
		"white-grey" = "白灰",
		"freezer" = "冷库",
		"hydro" = "水培室",
		"showroom" = "展示厅",
		"bar" = "酒吧",
		"cmo" = "首席医疗官办公室",
		"yellowpatch" = "黄色色块",
		"cafeteria" = "食堂",
		"red-yellow" = "红黄",
		"red-blue" = "红蓝",
		"red-green" = "红绿",
		"green-yellow" = "绿黄",
		"green-blue" = "绿蓝",
		"blue-yellow" = "蓝黄",
		"blue-red" = "蓝红",
		"white side" = "白色侧边",
		"arrival" = "抵达区",
		"escape" = "逃生区",
		"caution" = "注意",
		"warning" = "警告",
		"white-warning" = "白色警告",
		"warnwhite" = "白色警告",
		"white-blue-green" = "白蓝绿",
		"loadingarea" = "装卸区",
		"delivery" = "配送区",
		"bot" = "机器人区",
		"white-delivery" = "白色配送区",
		"white-bot" = "白色机器人区",
		"SA (red)" = "SA（红色）",
		"SB (red)" = "SB（红色）",
		"SC (red)" = "SC（红色）",
		"W (red)" = "W（红色）",
		"V (green)" = "V（绿色）",
		"Ex (blue)" = "Ex（蓝色）",
	)
	var/label = pattern_labels[pattern] || pattern
	return is_corner ? "[label]边角" : label

/obj/item/device/floor_painter/proc/select_pattern(mob/user, prompt, list/patterns)
	var/list/display_options = list()
	for(var/pattern in patterns)
		display_options[pattern_label(pattern)] = pattern
	var/selection = tgui_input_list(user, prompt, "地板喷漆器", display_options)
	if(isnull(selection))
		return null
	return display_options[selection]

/obj/item/device/floor_painter/attack_self(mob/user)
	..()
	var/type = select_pattern(usr, "请选择地板图案类型。", list("solid", "corner", "opposite corners", "side/three corners", "special", "letters"))
	tile_dir_mode = 0

	switch(type)
		if("solid")
			tile_dir_mode = 0
			var/design = select_pattern(usr, "请选择颜色。", list("standard", "dark", "red", "blue", "green", "yellow", "purple", "neutral", "white", "white-red", "white-blue", "white-green", "white-yellow", "white-purple", "freezer", "hydro", "showroom"))
			if(design == "standard")
				mode = "floor"
				mode_nice = "standard"
				return
			if(design == "white")
				mode = "white"
				mode_nice = "white"
				return
			if(design == "showroom" || design == "hydro" || design == "freezer")
				mode = "[design]floor"
				mode_nice = design
				return
			mode_nice = design
			mode = "[replacetext(design, "-", "")]full"
		if("corner")
			var/design = select_pattern(usr, "请选择图案。", list("black", "red", "blue", "green", "yellow", "purple", "neutral", "white", "white-grey", "white-red", "white-blue", "white-green", "white-yellow", "white-purple"))
			mode_nice = "[design] corner"
			mode = "[replacetext(design, "-", "")]corner"
			tile_dir_mode = 2
		if("opposite corners")
			var/design = select_pattern(usr, "请选择图案。", list("bar", "cmo", "yellowpatch", "cafeteria", "red-yellow", "red-blue", "red-green", "green-yellow", "green-blue", "blue-yellow"))
			mode_nice = design
			if(design == "bar" || design == "cmo" || design == "yellowpatch" || design == "cafeteria")
				mode = design
			else
				mode = "[replacetext(design, "-", "")]full"
			if(design == "yellowpatch")
				tile_dir_mode = 5
			else
				tile_dir_mode = 0
		if("side/three corners")
			var/design = select_pattern(usr, "请选择图案。", list("black", "red", "blue", "green", "yellow", "purple", "neutral", "white", "white-red", "white-blue", "white-green", "white-yellow", "white-purple", "red-yellow", "red-blue", "blue-red", "red-green", "green-yellow", "green-blue", "blue-yellow"))
			if(design == "white")
				mode = "whitehall"
				mode_nice = "white side"
				tile_dir_mode = 1
			else
				mode_nice = design
				mode = replacetext(design, "-", "")
				tile_dir_mode = 1
		if("special")
			var/design = select_pattern(usr, "请选择图案。", list("arrival", "escape", "caution", "warning", "white-warning", "white-blue-green", "loadingarea", "delivery", "bot", "white-delivery", "white-bot"))
			if(design == "white-blue-green")
				mode_nice = design
				mode = "whitebluegreencorners"
				tile_dir_mode = 2
			else if(design == "delivery" || design == "bot")
				mode_nice = design
				mode = design
				tile_dir_mode = 0
			else if(design == "loadingarea")
				mode_nice = design
				mode = design
				tile_dir_mode = 3
			else
				if(design == "white-warning")
					mode_nice = design
					design = "warnwhite"
				var/s_corner = alert("只给地砖的一个角喷漆吗？", "地板喷漆器","是","否") == "是"
				if(s_corner)
					mode_nice = "[design] corner"
					mode = "[design]corner"
					if(design == "warning" || design == "white-warning") // sprites for these are weird, need to fix dirs (icons/turf/floors.dmi, "warningcorner" and "warnwhitecorner")
						tile_dir_mode = 4
					else
						tile_dir_mode = 2
				else
					mode_nice = design
					mode = design
					tile_dir_mode = 1
		if("letters")
			var/which = select_pattern(usr, "请选择字母或图案。", list("A1", "A2", "DI", "SA", "SA (red)", "SB", "SB (red)", "SC", "SC (red)", "W (red)", "V (green)", "Psy", "Ex", "Ex (blue)", "CMO", "O (OP)", "P (OP)"))
			mode_nice = which
			switch(which)
				if("A1")
					mode = "white_1"
				if("A2")
					mode = "white_2"
				if("DI")
					mode = "white_d"
				if("SA")
					mode = "white_a"
				if("SA (red)")
					mode = "whitered_a"
					tile_dir_mode = 3
				if("SB")
					mode = "white_b"
				if("SB (red)")
					mode = "whitered_b"
					tile_dir_mode = 3
				if("SC")
					mode = "white_c"
				if("SC (red)")
					mode = "whitered_c"
					tile_dir_mode = 3
				if("W (red)")
					mode = "whitered_w"
					tile_dir_mode = 3
				if("V (green)")
					mode = "whitegreen_v"
					tile_dir_mode = 3
				if("Psy")
					mode = "white_p"
				if("Ex")
					mode = "white_ex"
				if("Ex (blue)")
					mode = "whiteblue_ex"
					tile_dir_mode = 3
				if("CMO") // yes this is also in "opposite corners" choices, but it's a different icon_state  (!!)
					mode = "white_cmo"
				if("O (OP)")
					mode = "white_halfo"
				if("P (OP)")
					mode = "white_halfp"

/obj/item/device/floor_painter/get_examine_text(mob/user)
	. = ..()
	. += "当前模式：[pattern_label(mode_nice)]。"
