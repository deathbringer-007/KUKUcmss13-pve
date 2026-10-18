/* Tables and Racks
 * Contains:
 * Tables
 * Wooden tables
 * Reinforced tables
 * Racks
 */

/*
 * Tables
 */
/obj/structure/surface/table
	name = "桌子"
	desc = "四条腿支撑的方形金属桌面，可供放置物品。紧急时可以掀翻作为掩体。"
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "table"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	throwpass = 1 //You can throw objects over this, despite it's density.")
	climbable = 1
	breakable = 1
	var/parts = /obj/item/frame/table
	debris = list(/obj/item/frame/table)

	var/sheet_type = /obj/item/stack/sheet/metal
	var/table_prefix = "" //used in update_icon()
	var/reinforced = FALSE
	var/flipped = 0
	var/flip_cooldown = 0 //If flip cooldown exists, don't allow flipping or putting back. This carries a WORLD.TIME value
	health = 100
	projectile_coverage = 20 //maximum chance of blocking a projectile
	var/flipped_projectile_coverage = PROJECTILE_COVERAGE_HIGH
	var/upright_projectile_coverage = PROJECTILE_COVERAGE_LOW
	surgery_duration_multiplier = SURGERY_SURFACE_MULT_UNSUITED

/obj/structure/surface/table/Initialize()
	. = ..()

	for(var/obj/structure/surface/table/T in src.loc)
		if(T != src)
			qdel(T)
	if(flipped)
		projectile_coverage = flipped_projectile_coverage
	else
		projectile_coverage = upright_projectile_coverage

	update_adjacent()
	update_icon()

/obj/structure/surface/table/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_TYPE_CRAWLER|PASS_CRUSHER_CHARGE
	flags_can_pass_all_temp = PASS_UNDER

/obj/structure/surface/table/deconstruct(disassembled = TRUE)
	if(disassembled)
		if(parts)
			new parts(loc)
	else
		if(reinforced)
			if(prob(50))
				new /obj/item/stack/rods(loc)
		new sheet_type(src)
	return ..()

/obj/structure/surface/table/proc/update_adjacent(location)
	if(!location)
		location = src //location arg is used to correctly update neighbour tables when deleting a table.

	for(var/direction in CARDINAL_ALL_DIRS)
		var/obj/structure/surface/table/T = locate(/obj/structure/surface/table, get_step(location,direction))
		if(T && !HAS_TRAIT(T, TRAIT_TABLE_FLIPPING))
			T.update_icon()

/obj/structure/surface/table/Crossed(atom/movable/O)
	..()
	if(istype(O,/mob/living/carbon/xenomorph/ravager) || istype(O,/mob/living/carbon/xenomorph/crusher))
		var/mob/living/carbon/xenomorph/M = O
		if(!M.stat) //No dead xenos jumpin on the bed~
			visible_message(SPAN_DANGER("[O]径直撞穿了[src]！"))
			deconstruct(FALSE)

/obj/structure/surface/table/Destroy()
	var/tableloc = loc
	. = ..()
	update_adjacent(tableloc) //so neighbouring tables get updated correctly

/obj/structure/surface/table/get_explosion_resistance(direction)
	if(flags_atom & ON_BORDER)
		if( direction == turn(dir, 90) || direction == turn(dir, -90) )
			return 0
		else
			return min(health, 40)
	return 0

/obj/structure/surface/table/update_icon()
	if(flipped)
		var/ttype = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir, 90), turn(dir, -90)) )
			var/obj/structure/surface/table/T = locate(/obj/structure/surface/table, get_step(src, direction))
			if (T && T.flipped && T.dir == dir)
				ttype++
				tabledirs |= direction

		icon_state = "[table_prefix]flip[ttype]"
		if(ttype == 1)
			if(tabledirs & turn(dir,90))
				icon_state = icon_state+"-"
			if(tabledirs & turn(dir,-90))
				icon_state = icon_state+"+"
		return 1

	var/dir_sum = 0
	for(var/direction in CARDINAL_ALL_DIRS)
		var/skip_sum = 0
		for(var/obj/structure/window/W in src.loc)
			if(W.dir == direction) //So smooth tables don't go smooth through windows
				skip_sum = 1
				continue
		var/inv_direction = turn(dir, 180) //inverse direction
		for(var/obj/structure/window/W in get_step(src, direction))
			if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
				skip_sum = 1
				continue
		if(!skip_sum) //there is no window between the two tiles in this direction
			var/obj/structure/surface/table/T = locate(/obj/structure/surface/table, get_step(src, direction))
			if(T && !T.flipped)
				if(direction < 5)
					dir_sum += direction
				else
					if(direction == 5) //This permits the use of all table directions. (Set up so clockwise around the central table is a higher value, from north)
						dir_sum += 16
					if(direction == 6)
						dir_sum += 32
					if(direction == 8) //Aherp and Aderp.  Jezes I am stupid.  -- SkyMarshal
						dir_sum += 8
					if(direction == 10)
						dir_sum += 64
					if(direction == 9)
						dir_sum += 128

	var/table_type = 0 //stand_alone table
	if((dir_sum%16) in GLOB.cardinals)
		table_type = 1 //endtable
		dir_sum %= 16
	if((dir_sum%16) in list(3, 12))
		table_type = 2 //1 tile thick, streight table
		if(dir_sum%16 == 3) //3 doesn't exist as a dir
			dir_sum = 2
		if(dir_sum%16 == 12) //12 doesn't exist as a dir.
			dir_sum = 4
	if((dir_sum%16) in list(5, 6, 9, 10))
		if(locate(/obj/structure/surface/table, get_step(src.loc, dir_sum%16)))
			table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
		else
			table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
		dir_sum %= 16
	if((dir_sum%16) in list(13, 14, 7, 11)) //Three-way intersection
		table_type = 5 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations.  TOO BAD -- SkyMarshal
		switch(dir_sum%16) //Begin computation of the special type tables.  --SkyMarshal
			if(7)
				if(dir_sum == 23)
					table_type = 6
					dir_sum = 8
				else if(dir_sum == 39)
					dir_sum = 4
					table_type = 6
				else if(dir_sum == 55 || dir_sum == 119 || dir_sum == 247 || dir_sum == 183)
					dir_sum = 4
					table_type = 3
				else
					dir_sum = 4
			if(11)
				if(dir_sum == 75)
					dir_sum = 5
					table_type = 6
				else if(dir_sum == 139)
					dir_sum = 9
					table_type = 6
				else if(dir_sum == 203 || dir_sum == 219 || dir_sum == 251 || dir_sum == 235)
					dir_sum = 8
					table_type = 3
				else
					dir_sum = 8
			if(13)
				if(dir_sum == 29)
					dir_sum = 10
					table_type = 6
				else if(dir_sum == 141)
					dir_sum = 6
					table_type = 6
				else if(dir_sum == 189 || dir_sum == 221 || dir_sum == 253 || dir_sum == 157)
					dir_sum = 1
					table_type = 3
				else
					dir_sum = 1
			if(14)
				if(dir_sum == 46)
					dir_sum = 1
					table_type = 6
				else if(dir_sum == 78)
					dir_sum = 2
					table_type = 6
				else if(dir_sum == 110 || dir_sum == 254 || dir_sum == 238 || dir_sum == 126)
					dir_sum = 2
					table_type = 3
				else
					dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
	if(dir_sum%16 == 15)
		table_type = 4 //4-way intersection, the 'middle' table sprites will be used.

	switch(table_type)
		if(0)
			icon_state = "[table_prefix]table"
		if(1)
			icon_state = "[table_prefix]1tileendtable"
		if(2)
			icon_state = "[table_prefix]1tilethick"
		if(3)
			icon_state = "[table_prefix]tabledir"
		if(4)
			icon_state = "[table_prefix]middle"
		if(5)
			icon_state = "[table_prefix]tabledir2"
		if(6)
			icon_state = "[table_prefix]tabledir3"

	if(dir_sum in CARDINAL_ALL_DIRS)
		setDir(dir_sum)
	else
		setDir(SOUTH)

/obj/structure/surface/table/BlockedPassDirs(atom/movable/mover, target_dir)
	for(var/obj/structure/S in get_turf(mover))
		if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
			return NO_BLOCKED_MOVEMENT

	return ..()

//Flipping tables, nothing more, nothing less
/obj/structure/surface/table/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(.)
		return .

	if(flipped)
		do_put()
	else
		do_flip()

/obj/structure/surface/table/MouseDrop_T(obj/item/I, mob/user)
	if (!istype(I) || user.get_active_hand() != I)
		return ..()
	user.drop_held_item()
	if(I.loc != loc)
		step(I, get_dir(I, src))

/obj/structure/surface/table/attackby(obj/item/W, mob/user, click_data)
	if(!W) return

	if (W.has_special_table_placement)
		W.set_to_table(src)
		return

	if(istype(W, /obj/item/grab) && get_dist(src, user) <= 1)
		if(isxeno(user)) return
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing, /mob/living))
			var/mob/living/M = G.grabbed_thing
			if(user.a_intent == INTENT_HARM)
				if(user.grab_level > GRAB_AGGRESSIVE)
					if (prob(15))
						M.KnockDown(5)
						M.Stun(5)
					M.apply_damage(8, def_zone = "head")
					user.visible_message(SPAN_DANGER("<B>[user]将[M]的脸猛撞在[src]上！</B>"),
					SPAN_DANGER("<B>你将[M]的脸猛撞在[src]上！</B>"))
					playsound(src.loc, 'sound/weapons/tablehit1.ogg', 25, 1)
				else
					to_chat(user, SPAN_WARNING("你需要抓得更牢才能这样做！"))
					return
			else if(user.grab_level >= GRAB_AGGRESSIVE)
				M.forceMove(loc)
				M.KnockDown(5)
				M.Stun(5)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
				user.visible_message(SPAN_DANGER("<B>[user]将[M]摔在[src]上，使其晕眩！</B>"),
				SPAN_DANGER("<B>你将[M]摔在[src]上，使其晕眩！</B>"))
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && !(user.a_intent == INTENT_HELP))
		user.visible_message(SPAN_NOTICE("[user]开始拆解[src]。"),
		SPAN_NOTICE("你开始拆解[src]。"))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user]拆解了[src]。"),
			SPAN_NOTICE("你拆解了[src]。"))
			deconstruct(TRUE)
		return

	if(W.flags_item & ITEM_ABSTRACT)
		return

	if(istype(W, /obj/item/weapon/wristblades))
		if(rand(0, 2) == 0)
			playsound(src.loc, 'sound/weapons/wristblades_hit.ogg', 25, 1)
			user.visible_message(SPAN_DANGER("[user]将[src]切开！"),
				SPAN_DANGER("你将[src]切开！"))
			deconstruct(FALSE)
		else
			to_chat(user, SPAN_WARNING("你切向桌子，却只留下少许爪痕。"))
		return

	if(istype(W, /obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/detonating_grenade = W
		if(detonating_grenade.active)
			to_chat(user, SPAN_WARNING("已经太迟了！"))
			return

	//clicking the table
	if(flipped)
		return
	..()

/// Checks whether a table is a straight line along a given axis
/obj/structure/surface/table/proc/straight_table_check(direction)
	var/obj/structure/surface/table/table = src
	var/obj/structure/surface/table/side_table
	var/tables_count = 7 // Lazy extra safety against infinite loops. If table big, can't flip, i guess.
	while(--tables_count)
		// Check whether there are connected tables perpendicular to the axis
		for(var/angle in list(-90, 90))
			side_table = locate() in get_step(table, turn(direction, angle))
			if(side_table && !side_table.flipped)
				return FALSE
		table = locate() in get_step(table, direction)
		if(!table || table.flipped)
			return TRUE
		if(istype(table, /obj/structure/surface/table/reinforced))
			var/obj/structure/surface/table/reinforced/reinforced_table = table
			if(reinforced_table.status == RTABLE_NORMAL)
				return FALSE
	if(!tables_count)
		return FALSE
	return TRUE

/obj/structure/surface/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = "Object"
	set src in oview(1)

	if(!can_touch(usr))
		return

	if(usr.mob_size == MOB_SIZE_SMALL)
		to_chat(usr, SPAN_WARNING("[isxeno(usr) ? "我们" : "你"]太小，无法掀翻[src]。"))
		return

	if(usr.a_intent != INTENT_HARM)
		to_chat(usr, SPAN_WARNING("你还不够愤怒，无法掀翻[src]。"))
		return

	if(get_turf(usr) == get_turf(src))
		to_chat(usr, SPAN_WARNING("你需要先从[src]上下来，才能将其掀翻。"))
		return

	if(!flip(get_cardinal_dir(usr, src)))
		return

	usr.visible_message(SPAN_WARNING("[usr]掀翻了[src]！"),
	SPAN_WARNING("你掀翻了[src]！"))
	playsound(loc, "metalbang", 25)

	if(climbable)
		structure_shaken()

	flip_cooldown = world.time + 5 SECONDS

/obj/structure/surface/table/proc/unflipping_check(direction)
	if(world.time < flip_cooldown)
		to_chat(usr, SPAN_WARNING("你刚刚移动过桌子，请稍等。"))
		return FALSE

	FOR_DOVIEW(var/mob/living/mob_behind_table, 0, src, HIDE_INVISIBLE_OBSERVER)
		to_chat(usr, SPAN_WARNING("[mob_behind_table]挡在[src]后面。"))
		FOR_DVIEW_END
		return FALSE
	FOR_DVIEW_END

	var/list/directions = list()
	if(direction)
		directions.Add(direction)
	else
		directions.Add(turn(src.dir,-90))
		directions.Add(turn(src.dir,90))
	for(var/new_dir in directions)
		var/obj/structure/surface/table/adjacent_table = locate() in get_step(loc, new_dir)
		if(!adjacent_table)
			continue
		if(adjacent_table.flipped && adjacent_table.dir == src.dir && !adjacent_table.unflipping_check(new_dir))
			return FALSE
	for(var/obj/structure/structure_behind_table in get_turf(src))
		if((structure_behind_table.flags_atom & ON_BORDER) && structure_behind_table.density && structure_behind_table != src) //We would put back on a structure that wouldn't allow it
			to_chat(usr, SPAN_WARNING("[structure_behind_table]挡在[src]后面。"))
			return FALSE
	return TRUE

/obj/structure/surface/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts flipped table back"
	set category = "Object"
	set src in oview(1)

	if(!can_touch(usr))
		return

	if(!unflipping_check())
		return

	unflip()

	flip_cooldown = world.time + 5 SECONDS

/**
 * Flip a table along a certain direction. By default checks whether table is flippable along axis perpendicular to flip direction.
 */
/obj/structure/surface/table/proc/flip(direction, skip_straight_check=FALSE)
	if(world.time < flip_cooldown)
		to_chat(usr, SPAN_WARNING("你刚刚移动过桌子，请稍等。"))
		return FALSE

	if(!skip_straight_check && !(straight_table_check(turn(direction, 90)) && straight_table_check(turn(direction, -90))))
		to_chat(usr, SPAN_WARNING("[src]太宽了，无法掀翻。"))
		return FALSE

	ADD_TRAIT(src, TRAIT_TABLE_FLIPPING, TRAIT_SOURCE_FLIP_TABLE)

	verbs -= /obj/structure/surface/table/verb/do_flip
	verbs += /obj/structure/surface/table/proc/do_put

	var/list/targets = list(get_step(src, dir), get_step(src, turn(dir, 45)), get_step(src, turn(dir, -45)))
	for(var/atom/movable/movable_on_table in get_turf(src))
		if(!movable_on_table.anchored)
			INVOKE_ASYNC(movable_on_table, TYPE_PROC_REF(/atom/movable, throw_atom), pick(targets), 1, SPEED_FAST)

	projectile_coverage = flipped_projectile_coverage

	setDir(direction)
	if(dir != NORTH)
		layer = FLY_LAYER
	flipped = TRUE
	flags_can_pass_all_temp &= ~PASS_UNDER
	flags_atom |= ON_BORDER

	for(var/adjacent_dir in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/surface/table/adjacent_table = locate() in get_step(src, adjacent_dir)
		if(adjacent_table && !adjacent_table.flipped)
			// Can skip straight check because we already iterated through all the tables that are connected to this table
			adjacent_table.flip(direction, TRUE)

	update_icon()
	update_adjacent()

	REMOVE_TRAIT(src, TRAIT_TABLE_FLIPPING, TRAIT_SOURCE_FLIP_TABLE)

	return TRUE

/obj/structure/surface/table/proc/unflip()
	ADD_TRAIT(src, TRAIT_TABLE_FLIPPING, TRAIT_SOURCE_FLIP_TABLE)
	verbs -= /obj/structure/surface/table/proc/do_put
	verbs += /obj/structure/surface/table/verb/do_flip

	projectile_coverage = upright_projectile_coverage

	layer = initial(layer)
	flipped = FALSE
	climbable = initial(climbable)
	flags_can_pass_all_temp |= PASS_UNDER
	flags_atom &= ~ON_BORDER
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/surface/table/T = locate() in get_step(src.loc,D)
		if(T && T.flipped && T.dir == src.dir)
			T.unflip()
	update_icon()
	update_adjacent()

	REMOVE_TRAIT(src, TRAIT_TABLE_FLIPPING, TRAIT_SOURCE_FLIP_TABLE)

	return TRUE

/*
 * Wooden tables
 */
/obj/structure/surface/table/woodentable
	name = "木桌"
	desc = "四条腿支撑的方形木桌面，可供放置物品。紧急时可以掀翻作为掩体。"
	icon_state = "woodtable"
	sheet_type = /obj/item/stack/sheet/wood
	parts = /obj/item/frame/table/wood
	table_prefix = "wood"
	health = 50

/obj/structure/surface/table/woodentable/poor
	name = "粗制木桌"
	desc = "四条腿支撑的粗制木桌面，可供放置物品。紧急时可以掀翻作为掩体。"
	icon_state = "pwoodtable"
	parts = /obj/item/frame/table/wood/poor
	table_prefix = "pwood"

/obj/structure/surface/table/woodentable/fancy
	name = "精致木桌"
	desc = "四条腿支撑的精制桃花心木桌面，可供放置物品。太重了，无法掀翻。"
	icon_state = "fwoodtable"
	parts = /obj/item/frame/table/wood/fancy
	table_prefix = "fwood"

/obj/structure/surface/table/woodentable/fancy/flip(direction)
	return 0 //That is mahogany!
/*
 * Gambling tables
 */
/obj/structure/surface/table/gamblingtable
	name = "赌桌"
	desc = "四条腿支撑的弧形木桌面，覆有毯布，用于赌博游戏。紧急时可以掀翻作为掩体。"
	icon_state = "gambletable"
	sheet_type = /obj/item/stack/sheet/wood
	parts = /obj/item/frame/table/gambling
	table_prefix = "gamble"
	health = 50
/*
 * Reinforced tables
 */
/obj/structure/surface/table/reinforced
	name = "加固桌"
	desc = "四条腿支撑的方形金属桌面，带有侧板，适合作办公桌，但无法掀翻。"
	icon_state = "reinftable"
	health = 140
	var/status = RTABLE_NORMAL
	reinforced = TRUE
	table_prefix = "reinf"
	parts = /obj/item/frame/table/reinforced

/obj/structure/surface/table/reinforced/flip(direction)
	return 0 //No, just no. It's a full desk, you can't flip that

/obj/structure/surface/table/reinforced/attackby(obj/item/W as obj, mob/user as mob)
	if (iswelder(W))
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要更强力的焊炬！"))
			return
		var/obj/item/tool/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			if(status == RTABLE_NORMAL)
				user.visible_message(SPAN_NOTICE("[user]开始削弱[src]的结构。"),
				SPAN_NOTICE("你开始削弱[src]的结构。"))
				playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
				if (do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src || !WT.isOn()) return
					user.visible_message(SPAN_NOTICE("[user]削弱了[src]的结构。"),
					SPAN_NOTICE("你削弱了[src]的结构。"))
					src.status = RTABLE_WEAKENED
			else
				user.visible_message(SPAN_NOTICE("[user]开始将[src]重新焊接起来。"),
				SPAN_NOTICE("你开始将[src]重新焊接起来。"))
				playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
				if(do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src || !WT.isOn()) return
					user.visible_message(SPAN_NOTICE("[user]将[src]重新焊接了起来。"),
					SPAN_NOTICE("你将[src]重新焊接了起来。"))
					status = RTABLE_NORMAL
			return
		return

	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && !(user.a_intent == INTENT_HELP) && status == RTABLE_NORMAL)
		return

	..()

/obj/structure/surface/table/reinforced/prison
	desc = "四条腿支撑的方形金属桌面，带有侧板，适合作办公桌，但无法掀翻。"
	icon_state = "prisontable"
	table_prefix = "prison"

/obj/structure/surface/table/reinforced/almayer_blend
	desc = "方形金属桌面安装在厚重金属底座上。没有桌腿，也就别想掀翻它了。"
	icon_state = "reqStable" //instance, this is a static table for req.
	table_prefix = "reqS"
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
		/turf/closed/wall,
	)

/obj/structure/surface/table/reinforced/almayer_blend/north
	icon_state = "reqNtable"
	table_prefix = "reqN"

/obj/structure/surface/table/reinforced/almayer_blend/flip(direction)
	return 0

/obj/structure/surface/table/reinforced/almayer_B
	desc = "方形金属桌面安装在厚重金属底座上。没有桌腿，也就别想掀翻它了。"
	icon_state = "req_table" //this one actually auto-tiles, but has no flipped state!
	table_prefix = "req_"

/obj/structure/surface/table/reinforced/almayer_B/flip(direction)
	return 0

/obj/structure/surface/table/reinforced/black
	name = "黑色桌子"
	desc = "一张光滑的黑色金属桌，桌腿已牢牢固定在地面上。"
	icon_state = "blacktable" //this one actually auto-tiles, but has no flipped state!
	table_prefix = "black"

/obj/structure/surface/table/reinforced/black/flip(direction)
	return FALSE

/obj/structure/surface/table/almayer
	icon_state = "almtable"
	table_prefix = "alm"
	parts = /obj/item/frame/table/almayer

/obj/structure/surface/table/reinforced/cloth
	name = "铺布桌"
	desc = "铺着精美桌布的木桌，固定在地面上，适合正式场合。"
	icon_state = "clothtable"
	table_prefix = "cloth"

/obj/structure/surface/table/reinforced/aicore/update_icon()
	return

/obj/structure/surface/table/reinforced/toc
	name = "作业台"
	desc = "方形金属桌面安装在厚重金属底座上。没有桌腿，也就别想掀翻它了。"
	icon_state = "tocWtable"
	table_prefix = "toc"

/obj/structure/surface/table/reinforced/toc/update_icon()
	return

/obj/structure/surface/table/reinforced/toc/west
	desc = "方形金属桌面安装在厚重金属底座上。没有桌腿，也就别想掀翻它了。"
	icon_state = "tocWtable"

/obj/structure/surface/table/reinforced/toc/east
	desc = "方形金属桌面安装在厚重金属底座上。没有桌腿，也就别想掀翻它了。"
	icon_state = "tocEtable"

/*
 * Racks
 */
/obj/structure/surface/rack
	name = "货架"
	desc = "一层层叠放的金属搁板，储物很好用，作掩体就差些。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	density = TRUE
	layer = TABLE_LAYER
	anchored = TRUE
	throwpass = 1 //You can throw objects over this, despite it's density.
	breakable = 1
	climbable = 1
	health = 100
	var/parts = /obj/item/frame/rack
	debris = list(/obj/item/frame/rack)

/obj/structure/surface/rack/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_UNDER|PASS_THROUGH|PASS_CRUSHER_CHARGE

/obj/structure/surface/rack/BlockedPassDirs(atom/movable/mover, target_dir)
	for(var/obj/structure/S in get_turf(mover))
		if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
			return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/surface/rack/MouseDrop_T(obj/item/I, mob/user)
	if (!istype(I) || user.get_active_hand() != I)
		return ..()
	user.drop_held_item()
	if(I.loc != loc)
		step(I, get_dir(I, src))

/obj/structure/surface/rack/attackby(obj/item/W, mob/user, click_data)
	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && !(user.a_intent == INTENT_HELP))
		deconstruct(TRUE)
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		return
	if(W.flags_item & ITEM_ABSTRACT)
		return
	..()

/obj/structure/surface/rack/Crossed(atom/movable/O)
	..()
	if(istype(O,/mob/living/carbon/xenomorph/ravager) || istype(O,/mob/living/carbon/xenomorph/crusher))
		var/mob/living/carbon/xenomorph/M = O
		if(!M.stat) //No dead xenos jumpin on the bed~
			visible_message(SPAN_DANGER("[O]径直撞穿了[src]！"))
			deconstruct(FALSE)

/obj/structure/surface/rack/deconstruct(disassembled = TRUE)
	if(disassembled)
		if(parts)
			new parts(loc)
	else
		new /obj/item/stack/sheet/metal(loc)
	density = FALSE
	return ..()

/obj/structure/surface/rack/ex_act(severity, direction)
	. = ..()
	if(.)
		deconstruct(FALSE)
