/*
 * Platforms
 */
/obj/structure/platform
	name = "平台"
	desc = "四条腿支撑着方形金属台面。"
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "platform"
	climbable = TRUE
	anchored = TRUE
	density = TRUE
	throwpass = TRUE //You can throw objects over this, despite its density.
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE
	unslashable = TRUE
	climb_delay = CLIMB_DELAY_SHORT
	projectile_coverage = PROJECTILE_COVERAGE_NONE

/obj/structure/platform/stair_cut
	icon_state = "platform_stair"//icon will be honked in all dirs except (1), that's because the behavior breaks if it ain't (1)
	dir = 1
/obj/structure/platform/stair_cut/alt
	icon_state = "platform_stair_alt"
	dir = 1


/obj/structure/platform/Initialize()
	. = ..()
	var/image/I = image(icon, src, "platform_overlay", LADDER_LAYER, dir)//ladder layer puts us just above weeds.
	switch(dir)
		if(SOUTH)
			layer = ABOVE_MOB_LAYER+0.1
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
			layer = ABOVE_MOB_LAYER+0.1
		if(WEST)
			I.pixel_x = -16
			layer = ABOVE_MOB_LAYER+0.1
	overlays += I

/obj/structure/platform/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform/Collided(atom/movable/AM)
	if(ismob(AM))
		do_climb(AM)
	..()

/obj/structure/platform/BlockedPassDirs(atom/movable/mover, target_dir)
	var/obj/structure/S = locate(/obj/structure) in get_turf(mover)
	if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable objects allow you to universally climb over others
		return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/platform/ex_act()
	return

/obj/structure/platform/attackby(obj/item/W, mob/user)
	. = ..()
	if(user.pulling)
		if(!can_climb(user))
			return
		user.visible_message(SPAN_WARNING("[user]开始将\the [user.pulling]拖上\the [src]。"),\
		SPAN_WARNING("你开始将\the [user.pulling]拖上\the [src]。"))
		if(!do_after(user, 3 SECONDS * user.get_skill_duration_multiplier(SKILL_FIREMAN), INTERRUPT_ALL, BUSY_ICON_HOSTILE, user.pulling, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(user.pulling)
			if(!can_climb(user))
				return
			var/turf/move_to_turf = get_step(get_turf(src), dir)
			user.visible_message(SPAN_WARNING("[user]将\the [user.pulling]拖上了\the [src]。"),\
			SPAN_WARNING("你将\the [user.pulling]拖上了\the [src]。"))
			user.pulling.forceMove(move_to_turf)

/obj/structure/platform_decoration
	name = "平台"
	desc = "四条腿支撑着方形金属台面。"
	icon = 'icons/obj/structures/props/platforms.dmi'
	icon_state = "platform_deco"
	anchored = TRUE
	density = FALSE
	throwpass = TRUE
	layer = OBJ_LAYER
	breakable = FALSE
	flags_atom = ON_BORDER
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/platform_decoration/Initialize()
	. = ..()
	switch(dir)
		if (NORTH)
			layer = ABOVE_MOB_LAYER+0.2
		if (SOUTH)
			layer = ABOVE_MOB_LAYER+0.2
		if (SOUTHEAST)
			layer = ABOVE_MOB_LAYER+0.2
		if (SOUTHWEST)
			layer = ABOVE_MOB_LAYER+0.2

/obj/structure/platform_decoration/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER

/obj/structure/platform_decoration/ex_act()
	return

//Map variants//

//Strata purple ice//
/obj/structure/platform_decoration/strata
	name = "冰岩拐角"
	desc = "一大块荒凉而坚硬的岩石与冰。"
	icon_state = "strata_platform_deco"

/obj/structure/platform/strata
	name = "冰岩边沿"
	desc = "一大块荒凉而坚硬的岩石与冰，看起来费点劲就能爬上去。"
	icon_state = "strata_platform"

//Strata wall metal platforms
/obj/structure/platform_decoration/strata/metal
	name = "高架金属拐角"
	desc = "抬高的金属平台，常用于使某些区域高于周围。这里是拐角。"
	icon_state = "strata_metalplatform_deco"

/obj/structure/platform/strata/metal
	name = "高架金属边沿"
	desc = "抬高的金属平台，常用于使某些区域高于周围。你大概能爬上去。"
	icon_state = "strata_metalplatform"

//Kutjevo metal platforms

/obj/structure/platform/kutjevo
	icon_state = "kutjevo_platform"
	name = "高架金属边沿"
	desc =  "抬高的金属平台，常用于垫高区域或搭建桥梁。你大概能爬上去。"

/obj/structure/platform_decoration/kutjevo
	name = "高架金属拐角"
	desc = "看起来是一块高架金属的拐角，常用于在非欧几里得二维空间中营造高低差的错觉。但你不知道这些，你只是个扛着步枪的太空人。"
	icon_state = "kutjevo_platform_deco"


/obj/structure/platform/kutjevo/smooth
	icon_state = "kutjevo_platform_sm"
	name = "高架金属边沿"
	desc =  "抬高的金属平台，常用于垫高区域或搭建桥梁。你大概能爬上去。"

/obj/structure/platform/kutjevo/smooth/stair_plate
	icon_state = "kutjevo_stair_plate"

/obj/structure/platform_decoration/kutjevo/smooth
	name = "高架金属拐角"
	desc = "看起来是一块高架金属的拐角，常用于在非欧几里得二维空间中营造高低差的错觉。但你不知道这些，你只是个扛着步枪的太空人。"
	icon_state = "kutjevo_platform_sm_deco"

/obj/structure/platform/kutjevo/rock
	icon_state = "kutjevo_rock"
	name = "高架岩石边沿"
	desc = "一堆石块和岩石，提供了充足的抓握和翻越位置，表明这里存在高低差。你大概能爬上去。"

/obj/structure/platform_decoration/kutjevo/rock
	name = "高架岩石拐角"
	desc = "一堆封在矮墙边缘的石块。这些齐胸高的墙段恰好长一米，非常适合攀爬。"
	icon_state = "kutjevo_rock_deco"


/obj/structure/platform/mineral
	icon_state = "stone"
/obj/structure/platform_decoration/mineral
	icon_state = "stone_deco"

/obj/structure/platform/mineral/sandstone
	name = "砂岩平台"
	desc = "支撑高地的砂岩平台，侧面刻着疑似古代象形文字的符号。"
	color = "#c6a480"

/obj/structure/platform/mineral/sandstone/runed
	name = "砂岩神庙平台"
	color = "#b29082"



/obj/structure/platform_decoration/mineral/sandstone
	name = "砂岩平台拐角"
	desc = "支撑高地的砂岩平台拐角，侧面刻着疑似古代象形文字的符号。"
	color = "#c6a480"

/obj/structure/platform/shiva/catwalk
	icon_state = "shiva"
	name = "高架橡胶绳索平台"
	desc = "由可靠的钢材和聚合物橡胶替代品制成，寒冷天气也不会开裂。"

/obj/structure/platform_decoration/shiva/catwalk
	icon_state = "shiva_deco"
	name = "高架橡胶绳索平台"
	desc = "由可靠的钢材和聚合物橡胶替代品制成，寒冷天气也不会开裂。"

/obj/structure/platform_decoration/mineral/sandstone/runed
	name = "砂岩神庙平台拐角"
	color = "#b29082"
