/* Glass stack types
 * Contains:
 * Glass sheets
 * Reinforced glass sheets
 * Phoron Glass Sheets
 * Reinforced Phoron Glass Sheets (AKA Holy fuck strong windows)
 * Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/sheet/glass
	name = "玻璃"
	desc = "玻璃是由沙子的主要成分硅酸盐制成的非晶态固体。它因透明性而广受应用，但不太耐冲击。"
	singular_name = "玻璃板"
	icon_state = "sheet-glass"
	matter = list("glass" = 3750)

	stack_id = "glass sheet"
	var/created_window = /obj/structure/window
	var/created_full_window = /obj/structure/window/full
	var/is_reinforced = 0
	var/list/construction_options = list("One Direction", "Full Window")

/obj/item/stack/sheet/glass/small_stack
	amount = STACK_10

/obj/item/stack/sheet/glass/medium_stack
	amount = STACK_25

/obj/item/stack/sheet/glass/large_stack
	amount = STACK_50

/obj/item/stack/sheet/glass/cyborg
	matter = null

/obj/item/stack/sheet/glass/attack_self(mob/user)
	..()
	construct_window(user)

/obj/item/stack/sheet/glass/attackby(obj/item/W, mob/user)
	..()
	if(!is_reinforced)
		if(istype(W,/obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/CC = W
			if (get_amount() < 1 || CC.get_amount() < 5)
				to_chat(user, SPAN_WARNING("制作布线玻璃需要5段线缆和1块玻璃板。"))
				return

			CC.use(5)
			new /obj/item/stack/light_w(user.loc, 1)
			use(1)
			to_chat(user, SPAN_NOTICE("你在[name]上接上了电线。"))
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/V  = W
			if (V.get_amount() < 1 || get_amount() < 1)
				to_chat(user, SPAN_WARNING("制作强化玻璃需要1根金属杆和1块玻璃板。"))
				return

			var/obj/item/stack/sheet/glass/reinforced/RG = new (user.loc)
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			var/obj/item/stack/sheet/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			V.use(1)
			G.use(1)
			if (!G && replace)
				user.put_in_hands(RG)

/obj/item/stack/sheet/glass/proc/construct_window(mob/user)
	if(!user || !src) return FALSE
	if(!istype(user.loc,/turf)) return FALSE
	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_DANGER("你的肢体不够灵巧，无法进行这项操作！"))
		return FALSE
	if(ishuman(user) && !skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_ENGI))
		to_chat(user, SPAN_WARNING("你没有接受过使用[src]建造所需的训练……"))
		return FALSE
	var/title = "板材：[name]"
	title += "（剩余[src.amount]块）"
	var/static/list/construction_labels = list("One Direction" = "单面窗", "Full Window" = "整格窗", "Windoor" = "玻璃门")
	var/list/localized_options = list()
	for(var/option in construction_options)
		localized_options[construction_labels[option] ? construction_labels[option] : option] = option
	var/to_build = localized_options[tgui_input_list(user, title, "你想建造什么？", localized_options)]
	if(!to_build)
		return
	var/turf/open/T = user.loc
	if(!(istype(T) && T.allow_construction))
		to_chat(user, SPAN_WARNING("必须在合适的地面上建造窗户！"))
		return
	var/fail = FALSE
	for(var/obj/X in T.contents - src)
		if(istype(X, /obj/structure/machinery/defenses))
			fail = TRUE
			break
		else if(istype(X, /obj/structure/machinery/m56d_hmg))
			fail = TRUE
			break
	if(fail)
		to_chat(user, SPAN_WARNING("有东西挡住了位置，你无法在这里建造窗户。"))
		return
	switch(to_build)
		if("One Direction")
			if(!src) return TRUE
			if(src.loc != user) return TRUE
			var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in T // for M2C HMG, look at smartgun_mount.dm
			if(AC)
				to_chat(usr, SPAN_WARNING("这里无法使用[src]建造！"))
				return TRUE
			var/list/directions = GLOB.cardinals.Copy()
			var/i = 0
			for (var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					to_chat(user, SPAN_DANGER("这个位置的窗户太多了。"))
					return TRUE
				directions-=win.dir
				if(!(win.dir in GLOB.cardinals))
					to_chat(user, SPAN_DANGER("不能这样做。"))
					return TRUE

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list( user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break
			var/obj/structure/window/WD = new created_window(user.loc)
			WD.set_constructed_window(dir_to_set)
			src.use(1)
		if("Full Window")
			if(!src) return TRUE
			if(src.loc != user) return TRUE
			if(src.amount < 4)
				to_chat(user, SPAN_DANGER("你需要更多玻璃才能这样做。"))
				return TRUE
			if(locate(/obj/structure/window) in user.loc)
				to_chat(user, SPAN_DANGER("有一扇窗户挡住了位置。"))
				return TRUE
			var/obj/structure/window/WD = new created_full_window(user.loc)
			WD.set_constructed_window()
			src.use(4)
		if("Windoor")
			if(!is_reinforced) return TRUE

			if(!src || src.loc != user) return TRUE

			var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in T // for M2C HMG, look at smartgun_mount.dm
			if(AC)
				to_chat(usr, SPAN_WARNING("这里无法使用[src]建造！"))
				return TRUE

			if(isturf(T) && locate(/obj/structure/windoor_assembly/, T))
				to_chat(user, SPAN_DANGER("那个位置已经有玻璃门组件了。"))
				return TRUE

			if(isturf(T) && locate(/obj/structure/machinery/door/window/, T))
				to_chat(user, SPAN_DANGER("那个位置已经有玻璃门了。"))
				return TRUE

			if(src.amount < 5)
				to_chat(user, SPAN_DANGER("你需要更多玻璃才能这样做。"))
				return TRUE

			new /obj/structure/windoor_assembly(T, user.dir, 1)
			src.use(5)

	return FALSE


/*
 * Reinforced glass sheets
 */
/obj/item/stack/sheet/glass/reinforced
	name = "强化玻璃"
	desc = "强化玻璃由普通硅酸盐玻璃与金属杆网架层叠而成。虽然仍可能开裂，但能承受更强的直接冲击。"
	singular_name = "强化玻璃板"
	icon_state = "sheet-rglass"
	stack_id = "reinf glass sheet"

	matter = list("metal" = 1875,"glass" = 3750)


	created_window = /obj/structure/window/reinforced
	created_full_window = /obj/structure/window/reinforced/full
	is_reinforced = 1
	construction_options = list("One Direction", "Full Window", "Windoor")

/obj/item/stack/sheet/glass/reinforced/medium_stack
	amount = 25

/obj/item/stack/sheet/glass/reinforced/large_stack
	amount = 50


/obj/item/stack/sheet/glass/reinforced/cyborg
	matter = null

/*
 * Phoron Glass sheets
 */
/obj/item/stack/sheet/glass/phoronglass
	name = "弗燃玻璃"
	desc = "弗燃玻璃是由硅酸盐与弗燃素的混合材料制成的非晶态固体。虽然明显泛着粉色，但仍像普通玻璃一样透明，并且十分耐损伤和高温。"
	singular_name = "弗燃玻璃板"
	icon_state = "sheet-phoronglass"
	matter = list("glass" = 7500)

	created_window = /obj/structure/window/phoronbasic
	created_full_window = /obj/structure/window/phoronbasic/full

/obj/item/stack/sheet/glass/phoronglass/attackby(obj/item/W, mob/user)
	..()
	if( istype(W, /obj/item/stack/rods) )
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/sheet/glass/phoronrglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/sheet/glass/G = src
		src = null
		var/replace = (user.get_inactive_hand()==G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/*
 * Reinforced phoron glass sheets
 */
/obj/item/stack/sheet/glass/phoronrglass
	name = "强化弗燃玻璃"
	desc = "强化弗燃玻璃由硅酸盐与弗燃素制成的玻璃片和金属杆网架层叠而成，具有惊人的抗冲击性和耐热性。"
	singular_name = "强化弗燃玻璃板"
	icon_state = "sheet-phoronrglass"
	matter = list("glass" = 7500,"metal" = 1875)


	created_window = /obj/structure/window/phoronreinforced
	created_full_window = /obj/structure/window/phoronreinforced/full
	is_reinforced = 1
