#define STATE_STANDARD 0
#define STATE_CIRCUIT 1
#define STATE_WIRES 2
#define STATE_SCREWDRIVER 3

#define AIRLOCK_MATERIAL_COST 5

#define AIRLOCK_NOGLASS 0
#define AIRLOCK_GLASSIN 1
#define AIRLOCK_CANTGLASS 2

/obj/structure/airlock_assembly
	name = "气闸门框架"
	icon = 'icons/obj/structures/doors/airlock_assembly.dmi'
	icon_state = "door_as_0"
	anchored = TRUE
	density = TRUE
	var/state = STATE_STANDARD
	var/base_icon_state = ""
	var/base_name = "气闸门"
	var/obj/item/circuitboard/airlock/electronics = null
	var/airlock_type = "generic" //the type path of the airlock once completed
	var/glass = AIRLOCK_NOGLASS // see defines
	var/created_name = null

	var/damage = 0 //This should let marines destroy Assemblies spawned by destroyed airlocks now
	var/damage_cap = HEALTH_ASSEMBLY // Assembly gets destroyed
	/// Used for multitile assemblies
	var/width = 1

/obj/structure/airlock_assembly/proc/take_damage(dam, mob/M)
	if(!dam || unacidable)
		return FALSE

	damage = max(0, damage + dam)

	if(damage >= damage_cap)
		if(M && istype(M))
			SEND_SIGNAL(M, COMSIG_MOB_DESTROY_AIRLOCK, src)
		to_chat(loc, SPAN_DANGER("[src]炸得四分五裂！"))
		deconstruct(FALSE)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
		return TRUE

/obj/structure/airlock_assembly/ex_act(severity, explosion_direction, datum/cause_data/cause_data)
	var/exp_damage = severity * EXPLOSION_DAMAGE_MULTIPLIER_DOOR
	var/location = get_turf(src)
	if(!density)
		exp_damage *= EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN
	if(take_damage(exp_damage)) // destroyed by explosion, shards go flying
		create_shrapnel(location, rand(2,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light, cause_data)

/obj/structure/airlock_assembly/get_explosion_resistance()
	if(density)
		if(unacidable)
			return 1000000
		else
			return (damage_cap-damage)/EXPLOSION_DAMAGE_MULTIPLIER_DOOR //this should exactly match the amount of damage needed to destroy the door
	else
		return FALSE

/obj/structure/airlock_assembly/bullet_act(obj/projectile/P)
	bullet_ping(P)
	if(P.damage)
		if(P.ammo.flags_ammo_behavior & AMMO_ROCKET)
			take_damage(P.damage * 4, P.firer) // rockets wreck airlocks
			return TRUE
		else
			take_damage(P.damage, P.firer)
			return TRUE
	return FALSE

/obj/structure/airlock_assembly/handle_tail_stab(mob/living/carbon/xenomorph/xeno)

	playsound(src, 'sound/effects/metalhit.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("[xeno]用尾巴猛击[src]！"), SPAN_XENOWARNING("你用尾巴猛击[src]！"))
	xeno.emote("tail")
	var/damage = xeno.melee_damage_upper * TAILSTAB_AIRLOCK_DAMAGE_MULTIPLIER
	take_damage(damage, xeno)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/airlock_assembly/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/airlock_assembly/get_examine_text(mob/user)
	. = ..()

	var/helpmessage
	. += SPAN_NOTICE("可用[SPAN_HELPFUL("撬棍")]拆解它。")
	switch(state)
		if(STATE_STANDARD)
			if(anchored)
				var/temp = ""
				if(width == 1)
					temp += "看起来可用[SPAN_HELPFUL("扳手")]松开它。"
				helpmessage += "[temp]可装入[SPAN_HELPFUL("气闸门电路板")]。"
				if(!glass)
					helpmessage += "加入[SPAN_HELPFUL("玻璃板")]可为其安装窗户。"
				else if(glass == AIRLOCK_GLASSIN)
					helpmessage += "可用[SPAN_HELPFUL("螺丝刀")]拆下窗户。"
			else
				helpmessage += "看起来可用[SPAN_HELPFUL("扳手")]固定它。"
		if(STATE_CIRCUIT)
			helpmessage += "用[SPAN_HELPFUL("电缆卷")]为电路板接线。"
		if(STATE_WIRES)
			helpmessage += "用[SPAN_HELPFUL("螺丝刀")]固定电路板。"
		if(STATE_SCREWDRIVER)
			helpmessage += "通过[SPAN_HELPFUL("焊接")]将全部部件固定到位。"
	helpmessage += "可用[SPAN_HELPFUL("笔")]为其命名。"
	. += SPAN_NOTICE(helpmessage)

/obj/structure/airlock_assembly/attackby(obj/item/attacking_item as obj, mob/user as mob)
	if(user.action_busy)
		return TRUE //no afterattack

	if(!skillcheck(user, SKILL_CONSTRUCTION, SKILL_CONSTRUCTION_TRAINED))
		to_chat(user, SPAN_WARNING("你没有接受过配置[src]的训练……"))
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_PEN))
		var/input_text = copytext(stripped_input(user, "输入气闸门的名称。", name, created_name), 1, MAX_NAME_LEN)
		if(!input_text || !in_range(src, usr) && loc != usr)
			return
		created_name = input_text
		playsound(src, "paper_writing", 15, TRUE)
		return

	if(istype(attacking_item, /obj/item/stack/sheet/glass))
		var/obj/item/stack/sheet/glass/glass_sheet = attacking_item
		if(!anchored)
			to_chat(user, SPAN_NOTICE("气闸门尚未固定！"))
			return
		if(state != STATE_STANDARD)
			to_chat(user, SPAN_NOTICE("电路板已经装好了，无法再加入玻璃！"))
			return
		if(glass == AIRLOCK_GLASSIN)
			to_chat(user, SPAN_NOTICE("无法再向[src]加入玻璃！"))
			return
		if(glass == AIRLOCK_CANTGLASS)
			to_chat(user, SPAN_NOTICE("[src]没有安装玻璃的槽位！"))
			return
		if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		if(glass_sheet.use(5))
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			glass = AIRLOCK_GLASSIN
			to_chat(user, SPAN_NOTICE("你将玻璃装入[src]，为其加上了窗户。"))
			update_icon()
			return
		else
			to_chat(user, SPAN_WARNING("你需要五片玻璃才能给[src]加上窗户！"))
			return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
		to_chat(user, SPAN_NOTICE("你开始拆解[src]。"))
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		to_chat(user, SPAN_NOTICE("你拆解了[src]。"))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		new /obj/item/stack/sheet/metal(loc, 5)
		if(glass == AIRLOCK_GLASSIN)
			new /obj/item/stack/sheet/glass(loc, 5)
		qdel(src)
		return

	for(var/obj/object in loc)
		if(object.density && object != src)
			to_chat(user, SPAN_WARNING("[object]挡住了位置，你无法操作[src]！"))
			return

	switch(state)
		if(STATE_STANDARD)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WRENCH))
				//Moving wide doors is wonky and doesn't work properly, if it's fixed we could make it unwrenchable again
				if(width > 1 && anchored)
					to_chat(user, SPAN_WARNING("[src]无法用扳手松开。"))
					return
				if(!anchored)
					var/turf/open/checked_turf = loc
					if(!(istype(checked_turf) && checked_turf.allow_construction))
						to_chat(user, SPAN_WARNING("无法将[src]固定在这里！"))
						return
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" 你开始[anchored? "松开" : "固定"]气闸门框架！"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE(" 你[anchored? "松开了" : "固定了"]气闸门框架！"))
				anchored = !anchored
				return

			if(!anchored)
				to_chat(user, SPAN_NOTICE("气闸门尚未固定！"))
				return ..()

			if(istype(attacking_item, /obj/item/circuitboard/airlock))
				var/obj/item/circuitboard/airlock/airlock_circuit = attacking_item
				if(airlock_circuit.fried) // guess what this used to check? ICON STATE!!
					to_chat(user, SPAN_WARNING("[airlock_circuit]完全损坏了！"))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你开始安装气闸门电子元件。"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.drop_held_item()
				attacking_item.forceMove(src)
				to_chat(user, SPAN_NOTICE("你装好了气闸门电子元件！"))
				state = STATE_CIRCUIT
				electronics = attacking_item
				update_icon()
				return

			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
				if(!anchored)
					to_chat(user, SPAN_NOTICE("气闸门尚未固定！"))
					return
				if(glass != AIRLOCK_GLASSIN)
					to_chat(user, SPAN_NOTICE("[src]没有可拆除的玻璃！"))
					return
				if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				glass = AIRLOCK_NOGLASS
				new /obj/item/stack/sheet/glass(loc, 5)
				to_chat(user, SPAN_NOTICE("你从[src]上撬下了玻璃板。"))
				update_icon()
				return


		if(STATE_CIRCUIT)
			if(istype(attacking_item, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/airlock_circuit = attacking_item
				if (airlock_circuit.get_amount() < 1)
					to_chat(user, SPAN_WARNING("你需要一段电缆才能为气闸门框架接线。"))
					return
				to_chat(user, SPAN_NOTICE("你开始为电路板接线。"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				if(airlock_circuit.use(1))
					state = STATE_WIRES
					to_chat(user, SPAN_NOTICE("你为电路板接好了线。"))
					update_icon()
				return

		if(STATE_WIRES)
			if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你开始固定电路板。"))
				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你固定好了电路板！"))
				state = STATE_SCREWDRIVER
				update_icon()
				return

		if(STATE_SCREWDRIVER)
			if(iswelder(attacking_item))
				if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("你需要更强力的焊炬！"))
					return
				var/obj/item/tool/weldingtool/welder = attacking_item
				if(!welder.remove_fuel(5, user))
					return
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("开始完成气闸门施工。"))

				if(!do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					welder.remove_fuel(-5)
					return

				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你完成了气闸门施工！"))
				var/path = get_airlock_path()
				var/obj/structure/machinery/door/airlock/door = new path(loc)
				door.assembly_type = type
				door.electronics = electronics
				door.dir = dir
				if(electronics.one_access)
					door.req_access = null
					door.req_one_access = electronics.conf_access
				else
					door.req_access = electronics.conf_access

				if(created_name)
					door.name = created_name
				else
					door.name = base_name
				door.handle_multidoor()
				electronics.forceMove(door)
				qdel(src)
				return
	..()

/obj/structure/airlock_assembly/update_icon()
	icon_state = "door_as_[state]"
	if(glass == AIRLOCK_GLASSIN)
		icon_state = "door_as_g[state]"
	else
		icon_state = "door_as_[base_icon_state][state]"

/obj/structure/airlock_assembly/proc/get_airlock_path()
	//For some reason multi_tile doors have different paths... can't say it isn't annoying
	if (width > 1)
		return "/obj/structure/machinery/door/airlock/multi_tile/almayer/[airlock_type][glass ? "" : "/solid"]"
	return "/obj/structure/machinery/door/airlock/almayer/[airlock_type][glass ? "/glass" : ""]"

/// Used for overloading proc in multi_tile
/obj/structure/airlock_assembly/proc/update_collision_box()
	return

/obj/structure/airlock_assembly/airlock_assembly_com
	base_icon_state = "com"
	base_name = "指挥区气闸门"
	airlock_type = "command"

/obj/structure/airlock_assembly/airlock_assembly_sec
	base_icon_state = "sec"
	base_name = "安保区气闸门"
	airlock_type = "security"

/obj/structure/airlock_assembly/airlock_assembly_eng
	base_icon_state = "eng"
	base_name = "工程区气闸门"
	airlock_type = "engineering"

/obj/structure/airlock_assembly/airlock_assembly_min
	base_icon_state = "min"
	base_name = "采矿区气闸门"
	airlock_type = "mining"

/obj/structure/airlock_assembly/airlock_assembly_atmo
	base_icon_state = "atmo"
	base_name = "大气设备区气闸门"
	airlock_type = "atmos"

/obj/structure/airlock_assembly/airlock_assembly_research
	base_icon_state = "res"
	base_name = "科研区气闸门"
	airlock_type = "research"

/obj/structure/airlock_assembly/airlock_assembly_science
	base_icon_state = "sci"
	base_name = "科学区气闸门"
	airlock_type = "science"

/obj/structure/airlock_assembly/airlock_assembly_med
	base_icon_state = "med"
	base_name = "医疗区气闸门"
	airlock_type = "medical"

/obj/structure/airlock_assembly/airlock_assembly_mai
	base_icon_state = "mai"
	base_name = "维护区气闸门"
	airlock_type = "maintenance"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_ext
	base_icon_state = "ext"
	base_name = "外部气闸门"
	airlock_type = "external"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_fre
	base_icon_state = "fre"
	base_name = "冷库气闸门"
	airlock_type = "freezer"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_hatch
	base_icon_state = "hatch"
	base_name = "气密舱门"
	airlock_type = "hatch"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "维护舱门"
	airlock_type = "maintenance_hatch"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/airlock_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	base_icon_state = "highsec"
	base_name = "高安保气闸门"
	airlock_type = "highsecurity"
	glass = AIRLOCK_CANTGLASS

/obj/structure/airlock_assembly/multi_tile
	icon = 'icons/obj/structures/doors/airlock_assembly2x1.dmi'
	icon_state = "door_as_0"
	width = 2

/obj/structure/airlock_assembly/multi_tile/Initialize(mapload, ...)
	. = ..()
	update_collision_box()
	update_icon()

/obj/structure/airlock_assembly/multi_tile/Move()
	. = ..()
	update_collision_box()

/obj/structure/airlock_assembly/multi_tile/update_collision_box()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size


#undef STATE_STANDARD
#undef STATE_CIRCUIT
#undef STATE_WIRES
#undef STATE_SCREWDRIVER

#undef AIRLOCK_MATERIAL_COST
