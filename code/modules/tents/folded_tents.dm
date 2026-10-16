/obj/item/folded_tent
	name = "折叠的通用帐篷"
	icon = 'icons/obj/structures/tents_folded.dmi'
	icon_state = "tent"
	w_class = SIZE_LARGE
	/// Required cleared area along X axis
	var/dim_x = 1
	/// Required cleared area along Y axis
	var/dim_y = 1
	/// Tents map template typepath
	var/template_preset = "abstract"
	///Map template datum used for tent
	var/datum/map_template/template
	/// If this tent can be deployed anywhere
	var/unrestricted_deployment = FALSE

/obj/item/folded_tent/Initialize(mapload, ...)
	. = ..()
	if(template_preset == "abstract") //So spawning an abstract tent wont fail create and destroy
		return
	set_template(SSmapping.tent_type_templates[template_preset])
	if(!template)
		CRASH("[src] initialized with template preset, \"[template_preset]\", that does not exist.")

/obj/item/folded_tent/proc/set_template(datum/map_template/new_template)
	if(!istype(new_template))
		return
	template = new_template
	dim_x = template.width
	dim_y = template.height

/// Check an area is clear for deployment of the tent
/obj/item/folded_tent/proc/check_area(turf/ref_turf, mob/message_receiver, display_error = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	. = TRUE
	var/list/turf_block = get_deployment_area(ref_turf)
	for(var/turf/turf as anything in turf_block)
		var/area/area = get_area(turf)
		if(!area.can_build_special && !unrestricted_deployment)
			if(message_receiver)
				to_chat(message_receiver, SPAN_WARNING("你不能在限制区域部署帐篷。"))
			if(display_error)
				new /obj/effect/overlay/temp/tent_deployment_area/error(turf)
			return FALSE
		if(istype(turf, /turf/open/shuttle))
			if(message_receiver)
				to_chat(message_receiver, SPAN_BOLDWARNING("你在做什么？！别在穿梭机上搭帐篷！"))
			return FALSE
		if(turf.density)
			if(message_receiver)
				to_chat(message_receiver, SPAN_WARNING("你无法在这里部署[src]，有东西（[turf]）挡住了。"))
			if(display_error)
				new /obj/effect/overlay/temp/tent_deployment_area/error(turf)
			return FALSE
		for(var/atom/movable/atom as anything in turf)
			if(isliving(atom) || (atom.density && atom.can_block_movement) || istype(atom, /obj/structure/tent))
				if(message_receiver)
					to_chat(message_receiver, SPAN_WARNING("你无法在这里部署[src]，有东西（[atom.name]）挡住了。"))
				if(display_error)
					new /obj/effect/overlay/temp/tent_deployment_area/error(turf)
				return FALSE
	return TRUE

/obj/item/folded_tent/proc/unfold(mob/user, turf/ref_turf)
	if(!istype(template))
		to_chat(user, SPAN_BOLDWARNING("[src]里面没有帐篷！它坏了！"))
		CRASH("[src] attempted to unfold \"[template]\" as a tent.")
	template.load(ref_turf, FALSE, FALSE)

/obj/item/folded_tent/proc/get_deployment_area(turf/ref_turf)
	RETURN_TYPE(/list/turf)
	return CORNER_BLOCK(ref_turf, dim_x, dim_y)

/obj/item/folded_tent/attack_self(mob/living/user)
	. = ..()
	var/off_x = -(tgui_input_number(user, "面向北或南时使用", "设置X轴偏移", 0, dim_x, 0, 30 SECONDS, TRUE))
	var/off_y = -(tgui_input_number(user, "面向东或西时使用", "设置Y轴偏移", 0, dim_y, 0, 30 SECONDS, TRUE))
	var/turf/deploy_turf = user.loc
	if(!istype(deploy_turf))
		return // In a locker or something. Get lost you already have a home.

	switch(user.dir) //Handles offsets when deploying
		if(NORTH)
			deploy_turf = locate(deploy_turf.x + off_x, deploy_turf.y + 1, deploy_turf.z)
		if(SOUTH)
			deploy_turf = locate(deploy_turf.x + off_x, deploy_turf.y - dim_y, deploy_turf.z)
		if(EAST)
			deploy_turf = locate(deploy_turf.x + 1, deploy_turf.y + off_y, deploy_turf.z)
		if(WEST)
			deploy_turf = locate(deploy_turf.x - dim_x, deploy_turf.y + off_y, deploy_turf.z)

	if(!istype(deploy_turf) || (deploy_turf.x + dim_x > world.maxx) || (deploy_turf.y + dim_y > world.maxy)) // Map border basically
		return

	if(!is_ground_level(deploy_turf.z) && !unrestricted_deployment)
		to_chat(user, SPAN_WARNING("殖民地陆战队作战帐篷是供执行任务使用的，不是用来在舰上或太空里娱乐的。"))
		return

	var/list/obj/effect/overlay/temp/tent_deployment_area/turf_overlay = list()
	var/list/turf/deployment_area = get_deployment_area(deploy_turf)

	if(!check_area(deploy_turf, user, TRUE))
		for(var/turf/turf in deployment_area)
			new /obj/effect/overlay/temp/tent_deployment_area(turf) // plus error in check_area
		return

	for(var/turf/turf in deployment_area)
		turf_overlay += new /obj/effect/overlay/temp/tent_deployment_area/casting(turf)

	user.visible_message(SPAN_INFO("[user]开始部署[src]……"), \
		SPAN_WARNING("你开始组装[src]……保持不动，弄明白怎么装可能需要一点时间……"))
	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("你被打断了！"))
		for(var/gfx in turf_overlay)
			qdel(gfx)
		return

	if(!check_area(deploy_turf, user, TRUE))
		for(var/gfx in turf_overlay)
			QDEL_IN(gfx, 1.5 SECONDS)
		return

	unfold(user, deploy_turf)
	user.visible_message(SPAN_INFO("[user]完成了[src]的部署！"), SPAN_INFO("你完成了[src]的部署！"))
	for(var/gfx in turf_overlay)
		qdel(gfx)
	qdel(src) // Success!

/obj/item/folded_tent/cmd
	name = "折叠的殖民地陆战队指挥帐篷"
	icon_state = "cmd"
	desc = "殖民地陆战队标准指挥帐篷，配有自供电战场监控台和电话。在合适的位置展开，才能发挥最大效用。不附送参谋军官。入口朝南。"
	template_preset = "tent_cmd"

/obj/item/folded_tent/med
	name = "折叠的殖民地陆战队医疗帐篷"
	icon_state = "med"
	desc = "殖民地陆战队标准医疗帐篷，配有先进的野战手术设施。在合适的位置展开，才能发挥最佳救治效果。不附送手术托盘。入口朝南。"
	template_preset = "tent_med"

/obj/item/folded_tent/reqs
	name = "折叠的殖民地陆战队军需帐篷"
	icon_state = "req"
	desc = "殖民地陆战队标准军需帐篷。现在走到哪都能排队领物资！在合适的位置展开，才能高效分发资源。不附送自动仓储检索系统。入口朝南。"
	template_preset = "tent_reqs"

/obj/item/folded_tent/big
	name = "折叠的殖民地陆战队大型帐篷"
	icon_state = "big"
	desc = "殖民地陆战队标准帐篷，这是更大的通用版本。在合适的位置展开，前线基地的氛围立刻拉满。不附送伙食勤务员。入口朝南。"
	template_preset = "tent_big"

/obj/effect/overlay/temp/tent_deployment_error
	icon = 'icons/effects/effects.dmi'
	icon_state = "placement_zone"
	color = "#bb0000"
	effect_duration = 1.5 SECONDS
	layer = ABOVE_FLY_LAYER

/obj/effect/overlay/temp/tent_deployment_area
	icon = 'icons/effects/effects.dmi'
	icon_state = "placement_zone"
	color = "#f39e00"
	effect_duration = 1.5 SECONDS
	layer = FLY_LAYER

/obj/effect/overlay/temp/tent_deployment_area/casting
	effect_duration = 10 SECONDS
	color = "#228822"

/obj/effect/overlay/temp/tent_deployment_area/error
	layer = ABOVE_FLY_LAYER
	color = "#bb0000"
