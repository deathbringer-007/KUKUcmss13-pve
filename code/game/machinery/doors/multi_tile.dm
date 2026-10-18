//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/structure/machinery/door/airlock/multi_tile
	width = 2
	damage_cap = 2600 // Bigger = more endurable
	assembly_type = /obj/structure/airlock_assembly/multi_tile

/obj/structure/machinery/door/airlock/multi_tile/close(forced = FALSE) //Nasty as hell O(n^2) code but unfortunately necessary
	for(var/turf/turf_tile in locs)
		for(var/obj/vehicle/multitile/vehicle_tile in turf_tile)
			addtimer(CALLBACK(src, PROC_REF(close), forced), 6 SECONDS + openspeed, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
			return FALSE

	return ..()

/obj/structure/machinery/door/airlock/multi_tile/Initialize()
	. = ..()
	update_icon()

/obj/structure/machinery/door/airlock/multi_tile/glass
	name = "玻璃气闸门"
	icon = 'icons/obj/structures/doors/Door2x1glass.dmi'
	opacity = FALSE
	glass = TRUE
	assembly_type = /obj/structure/airlock_assembly/multi_tile

/obj/structure/machinery/door/airlock/multi_tile/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/security
	name = "安保气闸门"
	icon = 'icons/obj/structures/doors/Door2x1security.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/security/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/command
	name = "指挥区气闸门"
	icon = 'icons/obj/structures/doors/Door2x1command.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/command/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/medical
	name = "医疗区气闸门"
	icon = 'icons/obj/structures/doors/Door2x1medbay.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/medical/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/engineering
	name = "工程区气闸门"
	icon = 'icons/obj/structures/doors/Door2x1engine.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/engineering/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/research
	name = "研究区气闸门"
	icon = 'icons/obj/structures/doors/Door2x1research.dmi'
	opacity = FALSE
	glass = TRUE
	req_one_access = list(ACCESS_MARINE_RESEARCH, ACCESS_WY_RESEARCH, ACCESS_WY_EXEC)

/obj/structure/machinery/door/airlock/multi_tile/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/research/reinforced
	name = "加固研究区气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/research/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/secure
	name = "安全气闸门"
	icon = 'icons/obj/structures/doors/Door2x1_secure.dmi'
	openspeed = 34
/obj/structure/machinery/door/airlock/multi_tile/secure/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/secure2
	name = "安全气闸门"
	icon = 'icons/obj/structures/doors/Door2x1_secure2.dmi'
	openspeed = 31
	req_access = null

/obj/structure/machinery/door/airlock/multi_tile/secure2/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)


/obj/structure/machinery/door/airlock/multi_tile/secure2_glass
	name = "安全气闸门"
	icon = 'icons/obj/structures/doors/Door2x1_secure2_glass.dmi'
	opacity = FALSE
	glass = TRUE
	openspeed = 31
	req_access = null

/obj/structure/machinery/door/airlock/multi_tile/secure2_glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/shuttle
	name = "穿梭舱门"
	icon = 'icons/obj/structures/doors/1x2blast_vert.dmi'
	icon_state = "pdoor1"
	opacity = TRUE
	openspeed = 12
	req_access = null
	not_weldable = 1


// ALMAYER

/obj/structure/machinery/door/airlock/multi_tile/almayer
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/comdoor.dmi' //Tiles with is here FOR SAFETY PURPOSES
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/multi_tile/almayer/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/multi_tile/almayer/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/multi_tile/almayer/take_damage(taken_damage, mob/damaging_mob)
	var/damage_check = max(0, damage + taken_damage)
	if(damage_check >= damage_cap && damaging_mob && is_mainship_level(z))
		SSclues.create_print(get_turf(damaging_mob), damaging_mob, "The fingerprint contains bits of wire and metal specks.")
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/2x1generic.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic/solid
	icon = 'icons/obj/structures/doors/2x1generic_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor
	name = "\improper 医疗区气闸门"
	icon = 'icons/obj/structures/doors/2x1medidoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/solid
	icon = 'icons/obj/structures/doors/2x1medidoor_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/solid/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/research
	name = "\improper 研究区气闸门"
	req_one_access = list(ACCESS_MARINE_RESEARCH, ACCESS_WY_RESEARCH, ACCESS_WY_EXEC)
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/medidoor/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor
	name = "\improper 指挥区气闸门"
	icon = 'icons/obj/structures/doors/2x1comdoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/reinforced
	name = "\improper 加固指挥区气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid
	icon = 'icons/obj/structures/doors/2x1comdoor_solid.dmi'
	opacity = TRUE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/reinforced
	name = "\improper 加固指挥区气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/comdoor/solid/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

//------Dropship Cargo Doors -----//

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear
	opacity = TRUE
	width = 3
	unslashable = TRUE
	unacidable = TRUE
	no_panel = 1
	not_weldable = 1
	var/queen_pryable = TRUE
	var/obj/docking_port/mobile/marine_dropship/linked_dropship


/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ex_act(severity)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/direction
		switch(id)
			if("starboard_door")
				direction = "starboard"
			if("port_door")
				direction = "port"
			if("aft_door")
				direction = "aft"
		if(!linked_dropship || !linked_dropship.door_control.door_controllers[direction])
			return ..()
		var/datum/door_controller/single/control = linked_dropship.door_control.door_controllers[direction]
		if (control.status != SHUTTLE_DOOR_BROKEN)
			return ..()
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && !skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
			to_chat(user, SPAN_WARNING("你似乎不知道如何恢复[src]的远程连接。"))
			return
		if(user.action_busy)
			return

		to_chat(user, SPAN_WARNING("你开始恢复[src]的远程连接。"))
		if(!do_after(user, (skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) ? 5 SECONDS : 8 SECONDS), INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_WARNING("你未能恢复[src]的远程连接。"))
			return
		unlock(TRUE)
		close(FALSE)
		control.status = SHUTTLE_DOOR_UNLOCKED
		to_chat(user, SPAN_WARNING("你成功恢复了[src]的远程连接。"))
		return
	..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/unlock(forced = FALSE)
	if(is_reserved_level(z) && !forced)
		return // in orbit
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.hive_pos != XENO_QUEEN)
		return ..()

	if(!queen_pryable)
		return ..()

	if(xeno.action_busy)
		return

	if(is_reserved_level(z)) //no prying in space even though it's funny
		return

	var/direction
	switch(id)
		if("starboard_door")
			direction = "starboard"
		if("port_door")
			direction = "port"
		if("aft_door")
			direction = "aft"
	var/datum/door_controller/single/control
	if(linked_dropship && linked_dropship.door_control.door_controllers[direction])
		control = linked_dropship.door_control.door_controllers[direction]

	if(control && control.status == SHUTTLE_DOOR_BROKEN)
		to_chat(xeno, SPAN_NOTICE("这扇门已经被禁用了。"))
		return

	to_chat(xeno, SPAN_WARNING("你试图强行打开舱门！"))
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		if(control)
			control.status = SHUTTLE_DOOR_BROKEN
		unlock(TRUE)
		open(TRUE)
		lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds1
	name = "\improper 阿拉莫号货舱门"
	icon = 'icons/obj/structures/doors/dropship1_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds2
	name = "\improper 诺曼底号货舱门"
	icon = 'icons/obj/structures/doors/dropship2_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds3
	name = "\improper 塞班号货舱门"
	icon = 'icons/obj/structures/doors/dropship3_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside
	width = 2

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/ds1
	name = "\improper 阿拉莫号乘员舱门"
	icon = 'icons/obj/structures/doors/dropship1_side2.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/ds2
	name = "\improper 诺曼底号乘员舱门"
	icon = 'icons/obj/structures/doors/dropship2_side2.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/ds3
	name = "\improper 塞班号乘员舱门"
	icon = 'icons/obj/structures/doors/dropship3_side2.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/ds4
	name = "\improper 中途岛号货舱门"
	icon = 'icons/obj/structures/doors/dropship4_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/ds1/midway
	name = "\improper 中途岛号乘员舱门"

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/ds2/cyclone
	name = "\improper 旋风号乘员舱门"

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/pmc
	name = "\improper 现金流号乘员舱门"
	icon = 'icons/obj/structures/doors/dropshippmc_side2.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/dropshipside/rmc
	name = "\improper 直布罗陀号乘员舱门"
	icon = 'icons/obj/structures/doors/dropship_rmc_side2.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/upp
	name = "\improper 科学院号货舱门"
	icon = 'icons/obj/structures/doors/dropshipupp_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/pmc
	name = "\improper 现金流号货舱门"
	icon = 'icons/obj/structures/doors/dropshippmc_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/rmc
	name = "\improper 直布罗陀号货舱门"
	icon = 'icons/obj/structures/doors/dropship_rmc_cargo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/blastdoor
	name = "舱壁防爆门"
	icon = 'icons/obj/structures/doors/almayerblastdoor.dmi'
	desc = "一扇厚重的舱壁门，能够承受爆炸、枪击与极端气压。你大概闯不过去。"

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat
	name = "救生艇对接舱门"
	icon = 'icons/obj/structures/doors/lifeboatdoors.dmi'
	desc = "救生艇使用的厚重舱壁门。"
	safe = FALSE
	autoclose = FALSE
	locked = TRUE
	opacity = FALSE
	glass = TRUE
	queen_pryable = FALSE
	var/throw_dir = EAST

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/try_to_activate_door(mob/user)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/bumpopen(mob/user as mob)
	return

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/proc/close_and_lock()
	unlock(TRUE)
	close(TRUE)
	lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/proc/unlock_and_open()
	unlock(TRUE)
	open(TRUE)
	lock(TRUE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/close(forced = FALSE)
	. = ..()
	for(var/turf/self_turf as anything in locs)
		var/turf/projected = get_ranged_target_turf(self_turf, throw_dir, 1)
		for(var/atom/movable/atom_movable in self_turf)
			if(ismob(atom_movable) && !isobserver(atom_movable))
				var/mob/mob = atom_movable
				mob.apply_effect(5, WEAKEN)
				to_chat(mob, SPAN_HIGHDANGER("[src]将你推了出去！"))
			else if(isobj(atom_movable))
				var/obj/object = atom_movable
				if(object.anchored)
					continue
			else
				continue
			INVOKE_ASYNC(atom_movable, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 1, SPEED_FAST, null, FALSE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	if(istype(port, /obj/docking_port/mobile/crashable/lifeboat))
		var/obj/docking_port/mobile/crashable/lifeboat/lifeboat = port
		lifeboat.doors += src

/// External airlock that is part of the lifeboat dock
/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor
	name = "舱壁防爆门"
	desc = "一扇厚重的舱壁门，能够承受爆炸、枪击与极端气压。你大概闯不过去。"
	icon = 'icons/obj/structures/doors/almayerblastdoor.dmi'
	safe = FALSE
	/// ID of the related stationary docking port operating this
	var/linked_dock

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/Initialize(mapload, ...)
	GLOB.lifeboat_doors += src
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/Destroy()
	GLOB.lifeboat_doors -= src
	return ..()

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/proc/vacate_premises()
	for(var/turf/self_turf as anything in locs)
		var/turf/near_turf = get_step(self_turf, throw_dir)
		var/turf/space_turf = get_step(near_turf, throw_dir)
		var/turf/projected = get_ranged_target_turf(space_turf, EAST, 50)
		for(var/atom/movable/atom_movable in near_turf)
			if(ismob(atom_movable) && !isobserver(atom_movable))
				var/mob/mob = atom_movable
				mob.apply_effect(10, STUN)
				to_chat(mob, SPAN_HIGHDANGER("你被吸入太空！"))
			else if(isobj(atom_movable))
				var/obj/object = atom_movable
				if(object.anchored)
					continue
			else
				continue
			atom_movable.forceMove(space_turf)
			INVOKE_ASYNC(atom_movable, TYPE_PROC_REF(/atom/movable, throw_atom), projected, 50, SPEED_FAST, null, TRUE, HIGH_LAUNCH)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), atom_movable), 3 SECONDS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/proc/bolt_explosion()
	var/turf/turf = get_step(src, throw_dir|dir)
	cell_explosion(turf, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("lifeboat explosive bolt"))

// Elevator door
/obj/structure/machinery/door/airlock/multi_tile/elevator
	icon = 'icons/obj/structures/doors/4x1_elevator.dmi'
	icon_state = "door_closed"
	width = 4
	openspeed = 22

/obj/structure/machinery/door/airlock/multi_tile/elevator/research
	name = "\improper 研究区电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/elevator/arrivals
	name = "\improper 抵达区电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/elevator/dormatory
	name = "\improper 宿舍区电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/elevator/freight
	name = "\improper 货运电梯舱门"


/obj/structure/machinery/door/airlock/multi_tile/elevator/access
	icon = 'icons/obj/structures/doors/4x1_elevator_access.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/research
	name = "\improper 研究区电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/arrivals
	name = "\improper 抵达区电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/dormatory
	name = "\improper 宿舍区电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/elevator/access/freight
	name = "\improper 货运电梯舱门"

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor
	name = "\improper 安保气闸门"
	icon = 'icons/obj/structures/doors/2x1secdoor.dmi'
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/reinforced/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass
	icon = 'icons/obj/structures/doors/2x1secdoor_glass.dmi'
	opacity = FALSE
	glass = TRUE
/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/multi_tile/almayer/secdoor/glass/reinforced/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor
	name = "\improper 工程区气闸门"
	icon = 'icons/obj/structures/doors/2x1engidoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_ENGINEERING)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass
	icon = 'icons/obj/structures/doors/2x1engidoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/multi_tile/almayer/engidoor/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine
	icon = 'icons/obj/structures/doors/2x1prepdoor.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/alpha
	name = "\improper 阿尔法小队整备室"
	icon = 'icons/obj/structures/doors/2x1prepdoor_alpha.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/bravo
	name = "\improper 布拉沃小队整备室"
	icon = 'icons/obj/structures/doors/2x1prepdoor_bravo.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/charlie
	name = "\improper 查理小队整备室"
	icon = 'icons/obj/structures/doors/2x1prepdoor_charlie.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/delta
	name = "\improper 德尔塔小队整备室"
	icon = 'icons/obj/structures/doors/2x1prepdoor_delta.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared
	name = "\improper 小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/alpha_bravo
	name = "\improper 阿尔法与布拉沃小队整备室"
	icon = 'icons/obj/structures/doors/2x1prepdoor_alpha.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/alpha_bravo/yellow
	icon = 'icons/obj/structures/doors/2x1prepdoor_bravo.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/charlie_delta
	name = "\improper 查理与德尔塔小队整备室"
	icon = 'icons/obj/structures/doors/2x1prepdoor_charlie.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/multi_tile/almayer/marine/shared/charlie_delta/blue
	icon = 'icons/obj/structures/doors/2x1prepdoor_delta.dmi'


/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/2x1personaldoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/glass
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/2x1personaldoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/generic2/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/multi_tile/almayer/almayer
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/2x1almayerdoor.dmi'

/obj/structure/machinery/door/airlock/multi_tile/almayer/almayer/glass
	icon = 'icons/obj/structures/doors/2x1almayerdoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/strata
	name = "安全气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_2x1.dmi'
	opacity = TRUE
	glass = FALSE
	openspeed = 4

/obj/structure/machinery/door/airlock/multi_tile/upp_green
	name = "气闸门"
	icon = 'icons/obj/structures/doors/upp/2x1upp_green.dmi'
	opacity = FALSE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/upp_green/glass
	name = "玻璃气闸门"
	icon = 'icons/obj/structures/doors/upp/2x1upp_glass_green.dmi'
	glass = TRUE


/obj/structure/machinery/door/airlock/multi_tile/upp_grey
	name = "气闸门"
	icon = 'icons/obj/structures/doors/upp/2x1upp_grey.dmi'
	opacity = FALSE
	glass = FALSE

/obj/structure/machinery/door/airlock/multi_tile/upp_grey/glass
	name = "玻璃气闸门"
	icon = 'icons/obj/structures/doors/upp/2x1upp_glass_grey.dmi'
	glass = TRUE

/obj/structure/machinery/door/airlock/multi_tile/upp_utility
	name = "气闸门"
	icon = 'icons/obj/structures/doors/upp/2x1upp_utility.dmi'
	openspeed = 6
