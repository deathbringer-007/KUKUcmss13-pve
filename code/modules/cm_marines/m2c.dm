#define M2C_SETUP_TIME (0.2 SECONDS)
#define M2C_OVERHEAT_DAMAGE 30
#define M2C_LOW_COOLDOWN_ROLL 0.3
#define M2C_HIGH_COOLDOWN_ROLL 0.45
#define M2C_PASSIVE_COOLDOWN_AMOUNT 4
#define M2C_CRUSHER_STUN 3 //amount in ticks (roughly 3 seconds)

/*M2C HEAVY MACHINEGUN AND ITS COMPONENTS */
// AMMO
/obj/item/ammo_magazine/m2c
	name = "M2C 弹药箱 (.50 BMG 弹药)"
	desc = "装有 150 发 .50 BMG 弹药的弹箱，供 M2 重机枪系统使用。在 M2C 未装弹箱时，用它点击机枪即可装填。"
	caliber = ".50"
	w_class = SIZE_LARGE
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m56de"
	item_state = "m56de"
	max_rounds = 150
	default_ammo = /datum/ammo/bullet/machinegun/auto
	gun_type = null

//STORAGE BOX FOR THE MACHINEGUN
/obj/item/storage/box/m56d/m2c
	name = "\improper M2C 组装补给箱"
	desc = "一个标有“M2C，.50 BMG 口径重机枪”的大箱子，拿起来相当沉。内装致命的 M2C 重机枪系统及弹药。"
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56D_case"
	w_class = SIZE_HUGE
	storage_slots = 5

/obj/item/storage/box/m56d/m2c/fill_preset_inventory()
	new /obj/item/device/m2c_gun(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)
	new /obj/item/ammo_magazine/m2c(src)

// THE GUN ITSELF

/obj/item/device/m2c_gun
	name = "M2C 重机枪"
	desc = "拆卸状态的 M2C 重机枪，伸缩三脚架已折叠，无法开火。"
	desc_lore = "国防部最初希望用廉价的大口径武器显著增强殖民地卫队的火力，才订购了这台凶悍的杀戮机器。随后，雇佣兵、殖民者和叛军通过劫掠仓库或老套的贪污手段，也得到了它。如果你是一名陆战队员，偶然找到它，还莫名其妙地决定使用它……最好再想想，这东西在现代战场上根本没有位置。它要求固定部署，挤占宝贵的装备空间，性能也没比现代 10x28 口径机枪强多少。说真的，已经 2182 年了，用智能机枪吧。"
	w_class = SIZE_HUGE
	flags_equip_slot = SLOT_BACK
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56DE_gun_mount"
	item_state = "M56DE_gun_mount"
	var/rounds = 0
	var/overheat_value = 0
	var/anti_cadehugger_range = 1
	var/broken_gun = FALSE
	var/field_recovery = 130
	health = 230

/obj/item/device/m2c_gun/Initialize()
	. = ..()
	update_icon()

/obj/item/device/m2c_gun/update_icon() //Lets generate the icon based on how much ammo it has.
	var/icon_name = initial(icon_state)
	if(broken_gun)
		icon_name += "_broken"
		if(!rounds)
			icon_name += "_e"

	else if(!broken_gun && !rounds)
		icon_name += "_e"

	icon_state = icon_name

/obj/item/device/m2c_gun/proc/check_can_setup(mob/user, turf/rotate_check, turf/open/OT)
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return FALSE
	if(broken_gun)
		to_chat(user, SPAN_WARNING("[src]已经彻底损坏，无法架设！"))
		return FALSE
	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("这里太拥挤，无法部署[src]。"))
		return FALSE
	if(OT.density || !isturf(OT) || !OT.allow_construction)
		to_chat(user, SPAN_WARNING("你无法在这里架设[src]。"))
		return FALSE
	if(rotate_check.density)
		to_chat(user, SPAN_WARNING("你无法朝这个方向架设[src]，身后有墙！"))
		return FALSE
	for(var/obj/structure/potential_blocker in rotate_check)
		if(potential_blocker.density)
			to_chat(user, SPAN_WARNING("你无法朝这个方向架设[src]，身后有[potential_blocker]！"))
			return FALSE

	var/fail = FALSE
	for(var/obj/X in OT.contents - src)
		if(istype(X, /obj/structure/machinery/defenses))
			fail = TRUE
			break
		else if(istype(X, /obj/structure/machinery/door))
			fail = TRUE
			break
		else if(istype(X, /obj/structure/machinery/m56d_hmg))
			fail = TRUE
			break
	if(fail)
		to_chat(user, SPAN_WARNING("你无法在这里安装[src]，有东西挡住了。"))
		return FALSE

	return TRUE


/obj/item/device/m2c_gun/attack_self(mob/user)
	..()
	var/turf/rotate_check = get_step(user.loc, turn(user.dir, 180))
	var/turf/open/OT = usr.loc

	if(!check_can_setup(user, rotate_check, OT))
		return

	if(!do_after(user, M2C_SETUP_TIME, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	if(!check_can_setup(user, rotate_check, OT))
		return

	var/obj/structure/machinery/m56d_hmg/auto/HMG = new(user.loc)
	transfer_label_component(HMG)
	HMG.setDir(user.dir) // Make sure we face the right direction
	HMG.anchored = TRUE
	playsound(HMG, 'sound/items/m56dauto_setup.ogg', 75, TRUE)
	to_chat(user, SPAN_NOTICE("你部署了[HMG]。"))
	HMG.rounds = rounds
	HMG.overheat_value = overheat_value
	HMG.health = health
	HMG.update_damage_state()
	HMG.update_icon()
	qdel(src)

	if(HMG.rounds > 0)
		HMG.try_mount_gun(user)

/obj/item/device/m2c_gun/attackby(obj/item/O as obj, mob/user as mob)
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return

	if(!iswelder(O) || user.action_busy)
		return

	if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
		to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
		return

	if(!broken_gun)
		to_chat(user, SPAN_WARNING("[src]尚未严重损毁，无需进行战地抢修。"))
		return

	var/obj/item/tool/weldingtool/WT = O

	if(WT.remove_fuel(2, user))
		user.visible_message(SPAN_NOTICE("[user]开始对[src]进行战地抢修。"), \
			SPAN_NOTICE("你开始修复[src]的严重损伤，试图恢复它的功能。"))
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		if(!do_after(user, field_recovery * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			return
		user.visible_message(SPAN_NOTICE("[user]对[src]进行了战地抢修，使其恢复原状。"), \
			SPAN_NOTICE("你修好了[src]，使其恢复正常运行。"))
		broken_gun = FALSE
		health = 110
		update_icon()
		return
	else
		to_chat(user, SPAN_WARNING("[WT]的燃料不足，无法开始对[src]进行战地抢修。"))

// MACHINEGUN, AUTOMATIC
/obj/structure/machinery/m56d_hmg/auto
	name = "\improper M2C 重机枪"
	desc = "可部署的重机枪，采用现代材料改进自 M2 HB，能够无后坐力射击并快速转向。<B>空手站在后方，点击机枪即可操作。非抓取意图下点击并拖动可拆卸机枪，抓取意图下则可取下弹药箱。</B>"
	desc_lore = "国防部原本希望以低价用大口径武器大幅增强殖民地卫队的火力，却没过多久，这种凶狠的杀戮机器就通过仓库劫掠和老掉牙的腐败手段，流入雇佣兵、殖民者和叛军手中。如果你是陆战队员，碰巧找到了它，又莫名决定用它……最好再想想。这东西必须固定架设，占用宝贵的装备空间，性能也不见得比现代 10×28 毫米机枪好多少，在现代战场上毫无用武之地。拜托，现在都 2182 年了，放过它吧。"
	icon = 'icons/turf/whiskeyoutpost.dmi'
	icon_state = "M56DE"
	icon_full = "M56DE"
	icon_empty = "M56DE_e"
	rounds_max = 150
	ammo = /datum/ammo/bullet/machinegun/auto
	fire_delay = 2.5
	var/grip_dir = null
	var/fold_time = 1.5 SECONDS
	var/repair_time = 5 SECONDS
	density = TRUE
	health = 230
	health_max = 230
	display_ammo = FALSE
	iff_allowed = FALSE

	var/static/image/barrel_overheat_image
	var/has_barrel_overlay = FALSE

	gun_noise = 'sound/weapons/gun_m56d_auto.ogg'
	empty_alarm = 'sound/weapons/hmg_eject_mag.ogg'

	// OVERHEAT MECHANIC VARIABLES
	var/overheat_value = 0
	var/overheat_threshold = 200
	var/emergency_cooling = FALSE
	var/overheat_text_cooldown = 0
	var/force_cooldown_timer = 10
	var/rotate_timer = 0
	var/fire_stopper = FALSE

	// Muzzle Flash Offsets
	north_x_offset = 0
	north_y_offset = 10
	east_x_offset = 0
	east_y_offset = 12
	south_x_offset = 0
	south_y_offset = 10
	west_x_offset = 0
	west_y_offset = 12

// ANTI-CADE EFFECT, CREDIT TO WALTERMELDRON //your services are no longer needed

/obj/structure/machinery/m56d_hmg/auto/Initialize()
	. = ..()
	if(!barrel_overheat_image)
		barrel_overheat_image = image('icons/turf/whiskeyoutpost.dmi', "+m56de_overheat")

/obj/structure/machinery/m56d_hmg/auto/process()
	overheat_value -= M2C_PASSIVE_COOLDOWN_AMOUNT
	if(overheat_value <= 0)
		overheat_value = 0
		STOP_PROCESSING(SSobj, src)

	update_icon()

// ANTI-CADE EFFECT, CREDIT TO WALTERMELDRON
/obj/structure/blocker/anti_cade
	health = INFINITY
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	indestructible = TRUE
	invisibility = 101 // no looking at it with alt click

	var/obj/structure/machinery/m56d_hmg/auto/hmg

	alpha = 0

/obj/structure/blocker/anti_cade/BlockedPassDirs(atom/movable/AM, target_dir)
	if(istype(AM, /obj/structure/barricade))
		return BLOCKED_MOVEMENT
	else if(istype(AM, /obj/structure/window))
		return BLOCKED_MOVEMENT
	else if(istype(AM, /obj/structure/windoor_assembly))
		return BLOCKED_MOVEMENT
	else if(istype(AM, /obj/structure/machinery/door))
		return BLOCKED_MOVEMENT
	return ..()

/obj/structure/blocker/anti_cade/Destroy()
	if(hmg)
		hmg = null

	return ..()

/obj/structure/machinery/m56d_hmg/auto/update_icon() //Lets generate the icon based on how much ammo it has.
	if(!rounds)
		icon_state = "[icon_empty]"
	else
		icon_state = "[icon_full]"

	if(overheat_value >= (overheat_threshold / 2))
		if(has_barrel_overlay)
			return
		overlays += barrel_overheat_image
		has_barrel_overlay = TRUE
	else if(has_barrel_overlay)
		overlays -= barrel_overheat_image
		has_barrel_overlay = FALSE

// DED

/obj/structure/machinery/m56d_hmg/auto/update_health(amount) //Negative values restores health.
	health -= amount
	if(health <= 0)
		playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		visible_message(SPAN_WARNING("[src]已经彻底损坏！"))
		var/obj/item/device/m2c_gun/HMG = new(loc)
		HMG.rounds = rounds
		HMG.broken_gun = TRUE
		HMG.unacidable = FALSE
		HMG.health = 0
		HMG.update_icon()
		transfer_label_component(HMG)
		qdel(src)
		return

	if(health > health_max)
		health = health_max
	update_damage_state()
	update_icon()

/obj/structure/machinery/m56d_hmg/auto/attackby(obj/item/O as obj, mob/user as mob)
	if(!ishuman(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return
	// RELOADING
	if(istype(O, /obj/item/ammo_magazine/m2c))
		var/obj/item/ammo_magazine/m2c/M = O
		if(rounds)
			to_chat(user, SPAN_WARNING("[src]里面已经有一个弹药箱，先将它取出！"))
			return
		if(user.action_busy) return
		user.visible_message(SPAN_NOTICE("[user]为[src]装入了弹药箱！"), SPAN_NOTICE("你为[src]装入了弹药箱！"))
		playsound(src.loc, 'sound/items/m56dauto_load.ogg', 75, 1)
		rounds = min(rounds + M.current_rounds, rounds_max)
		update_icon()
		user.temp_drop_inv_item(O)
		qdel(O)
		return

	// WELDER REPAIR
	if(iswelder(O))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
			return
		if(user.action_busy)
			return

		var/obj/item/tool/weldingtool/WT = O

		if(health == health_max)
			to_chat(user, SPAN_WARNING("[src]保养良好，无需修理。"))
			return

		if(WT.remove_fuel(2, user))
			user.visible_message(SPAN_NOTICE("[user]开始修理[src]的损伤。"), \
				SPAN_NOTICE("你开始修理[src]的损伤。"))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			if(!do_after(user, repair_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				return
			user.visible_message(SPAN_NOTICE("[user]修复了[src]的部分损伤。"), \
					SPAN_NOTICE("你修复了[src]。"))
			update_health(-floor(health_max*0.2))
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("[WT]需要更多燃料才能修理[src]。"))
		return
	return

// AUTOMATIC FIRING

/obj/structure/machinery/m56d_hmg/auto/try_fire()
	if(fire_stopper)
		return

	if(overheat_value >= overheat_threshold)
		if(world.time > overheat_text_cooldown)
			operator.visible_message(SPAN_HIGHDANGER("[src]已经过热，暂时无法使用！"), SPAN_HIGHDANGER("[src]已经过热！你必须等待它冷却！"))
			overheat_text_cooldown = world.time + 3 SECONDS

		if(!emergency_cooling)
			emergency_cooling = TRUE
			to_chat(operator, SPAN_DANGER("你等待[src]的枪管冷却，以便继续持续射击。"))
			fire_stopper = TRUE
			STOP_PROCESSING(SSobj, src)
			addtimer(CALLBACK(src, PROC_REF(force_cooldown)), force_cooldown_timer)
		return

	return ..()


/obj/structure/machinery/m56d_hmg/auto/fire_shot()
	. = ..()

	handle_rotating_gun(operator)
	if((. & AUTOFIRE_CONTINUE) && rounds)
		overheat_value += 1
		START_PROCESSING(SSobj, src)

/obj/structure/machinery/m56d_hmg/auto/handle_ammo_out(mob/user)
	visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))][src]的弹药箱掉到地上，里面已经彻底空了。"))
	playsound(loc, empty_alarm, 70, 1)
	update_icon() //final safeguard.
	var/obj/item/ammo_magazine/m2c/AM = new /obj/item/ammo_magazine/m2c(src.loc)
	AM.current_rounds = 0
	AM.update_icon()

/obj/structure/machinery/m56d_hmg/auto/get_scatter()
	return 0

// ACTIVE COOLING

/obj/structure/machinery/m56d_hmg/auto/proc/force_cooldown(mob/user)
	user = operator

	overheat_value = floor((rand(M2C_LOW_COOLDOWN_ROLL, M2C_HIGH_COOLDOWN_ROLL) * overheat_threshold))
	playsound(src.loc, 'sound/weapons/hmg_cooling.ogg', 75, 1)
	to_chat(user, SPAN_NOTICE("[src]的枪管已经冷却到可以继续射击。"))
	emergency_cooling = FALSE
	fire_stopper = FALSE
	fire_delay = initial(fire_delay)
	update_health(M2C_OVERHEAT_DAMAGE)
	START_PROCESSING(SSobj, src)
	update_icon()

// TOGGLE MODE

/obj/structure/machinery/m56d_hmg/auto/clicked(mob/user, list/mods, atom/A)
	if (mods[CTRL_CLICK])
		if(operator != user)
			return ..()
		if(!CAN_PICKUP(user, src))
			return ..()
		to_chat(user, SPAN_NOTICE("你试图切换[src]的点射模式，却发现它根本没有这个功能。"))
		return TRUE

	return ..()

//ATTACK WITH BOTH HANDS COMBO

/obj/structure/machinery/m56d_hmg/auto/attack_hand(mob/living/user)
	if(..())
		return TRUE

	try_mount_gun(user)

// DISASSEMBLY

/obj/structure/machinery/m56d_hmg/auto/MouseDrop(over_object, src_location, over_location)
	var/mob/living/carbon/user = usr
	// If the user is unconscious or dead.
	if(user.stat)
		return
	if(!ishuman(user)  && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		return
	if(over_object == user && in_range(src, user))
		if((rounds > 0) && (user.a_intent & (INTENT_GRAB)))
			playsound(src.loc, 'sound/items/m56dauto_load.ogg', 75, 1)
			user.visible_message(SPAN_NOTICE("[user]取下了[src]的弹药箱。"),SPAN_NOTICE("你取下了[src]的弹药箱，为拆卸机枪做准备。"))
			var/obj/item/ammo_magazine/m2c/used_ammo = new(user.loc)
			used_ammo.current_rounds = rounds
			user.put_in_active_hand(used_ammo)
			rounds = 0

		else
			if(!do_after(user, fold_time* user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src)) // disassembly time reduced
				return
			user.visible_message(SPAN_NOTICE("[user]拆解了[src]。"),SPAN_NOTICE("你收起[src]的三脚架，将其拆卸。"))
			playsound(src.loc, 'sound/items/m56dauto_setup.ogg', 75, 1)
			var/obj/item/device/m2c_gun/HMG = new(loc)
			transfer_label_component(HMG)
			HMG.rounds = rounds
			HMG.overheat_value = floor(0.5 * overheat_value)
			if (HMG.overheat_value <= 10)
				HMG.overheat_value = 0
			HMG.update_icon()
			HMG.health = health
			user.put_in_active_hand(HMG)
			if(user.equip_to_slot_if_possible(HMG, WEAR_BACK, disable_warning = TRUE))
				to_chat(user, SPAN_NOTICE("你迅速将机枪扛到背上！"))
			qdel(src)

	update_icon()

// MOUNT THE MG

/obj/structure/machinery/m56d_hmg/auto/on_set_interaction(mob/user)
	..()
	ADD_TRAIT(user, TRAIT_OVERRIDE_CLICKDRAG, TRAIT_SOURCE_WEAPON)
	RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(disable_interaction))

// DISMOUNT THE MG

/obj/structure/machinery/m56d_hmg/auto/on_unset_interaction(mob/user)
	REMOVE_TRAIT(user, TRAIT_OVERRIDE_CLICKDRAG, TRAIT_SOURCE_WEAPON)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
	..()

// GET ANIMATED

/obj/structure/machinery/m56d_hmg/auto/update_pixels(mob/user, mounting = TRUE)
	if(mounting)
		var/diff_x = 0
		var/diff_y = 0
		var/tilesize = 32
		var/viewoffset = tilesize * 1

		user.reset_view(src)
		if(dir == EAST)
			diff_x = -16 + user_old_x
			user.client.pixel_x = viewoffset
			user.client.pixel_y = 0
		if(dir == WEST)
			diff_x = 16 + user_old_x
			user.client.pixel_x = -viewoffset
			user.client.pixel_y = 0
		if(dir == NORTH)
			diff_y = -16 + user_old_y
			user.client.pixel_x = 0
			user.client.pixel_y = viewoffset
		if(dir == SOUTH)
			diff_y = 16 + user_old_y
			user.client.pixel_x = 0
			user.client.pixel_y = -viewoffset

		animate(user, pixel_x=diff_x, pixel_y=diff_y, 0.4 SECONDS)
	else
		if(user.client)
			user.client.change_view(GLOB.world_view_size)
			user.client.pixel_x = 0
			user.client.pixel_y = 0

		animate(user, pixel_x=user_old_x, pixel_y=user_old_y, 4, 1)


//ROTATE THE MACHINEGUN

/obj/structure/machinery/m56d_hmg/auto/proc/rotate_to(mob/user, atom/A)
	if(!A || !user.x || !user.y || !A.x || !A.y)
		return
	var/dx = A.x - user.x
	var/dy = A.y - user.y
	if(!dx && !dy)
		return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)
			direction = NORTH
		else
			direction = SOUTH
	else
		if(dx > 0)
			direction = EAST
		else
			direction = WEST

	var/turf/rotate_check = get_step(src.loc, turn(direction,180))
	if(rotate_check.density)
		to_chat(user, SPAN_WARNING("你不能朝那个方向转动它。"))
		return

	src.setDir(direction)
	user.setDir(direction)
	update_pixels(user)
	playsound(src.loc, 'sound/items/m56dauto_rotate.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE("你以三脚架为支点，转动了[src]。"))


/obj/structure/machinery/m56d_hmg/auto/proc/disable_interaction(mob/living/user, NewLoc, direction)
	SIGNAL_HANDLER

	if(user.body_position != STANDING_UP || get_dist(user,src) > 0 || user.is_mob_incapacitated() || !user.client)
		user.unset_interaction()

/obj/structure/machinery/m56d_hmg/auto/proc/handle_rotating_gun(mob/user)
	var/angle = get_dir(src, target)
	if(world.time > rotate_timer && !((dir & angle) && target.loc != src.loc && target.loc != operator.loc))
		rotate_timer = world.time + 0.4 SECONDS
		rotate_to(user, target)
		return TRUE

#undef M2C_SETUP_TIME
#undef M2C_OVERHEAT_DAMAGE
#undef M2C_LOW_COOLDOWN_ROLL
#undef M2C_HIGH_COOLDOWN_ROLL
#undef M2C_PASSIVE_COOLDOWN_AMOUNT
#undef M2C_CRUSHER_STUN
