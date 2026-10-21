/turf/open/auto_turf
	name = "沙地"
	icon = 'icons/turf/floors/auto_sand.dmi'
	icon_state = "sand_1"//editor icon
	is_groundmap_turf = TRUE
	var/icon_prefix = "sand"
	var/layer_name = list("第一层", "第二层", "第三层", "第四层", "第五层")
	var/variant = 0
	var/variant_prefix_name = ""

/turf/open/auto_turf/insert_self_into_baseturfs()
	baseturfs += type

/turf/open/auto_turf/is_weedable()//for da xenos
	return FULLY_WEEDABLE

/turf/open/auto_turf/get_dirt_type()
	return DIRT_TYPE_GROUND //automatically diggable I guess

/turf/open/auto_turf/can_dig_xeno_tunnel()
	return TRUE //xenos can tunnel

//Update icon
/turf/open/auto_turf/update_icon()
	if(variant && (bleed_layer == initial(bleed_layer)))
		icon_state = "[icon_prefix]_[bleed_layer]_[variant]"
	else
		icon_state = "[icon_prefix]_[bleed_layer]"
	setDir(pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))

	var/name_to_set
	switch(bleed_layer)
		if(0)
			name_to_set = layer_name[1]
		if(1)
			name_to_set = layer_name[2]
		if(2)
			name_to_set = layer_name[3]
		if(3)
			name_to_set = layer_name[4]
		if(4)
			name_to_set= layer_name[5]

	if(bleed_layer == initial(bleed_layer))
		name = variant_prefix_name + " " + name_to_set
	else
		name = name_to_set

	..()

/turf/open/auto_turf/proc/changing_layer(new_layer)
	if(isnull(new_layer) || new_layer == bleed_layer)
		return

	bleed_layer = max(0, new_layer)
	for(var/direction in GLOB.alldirs)
		var/turf/open/T = get_step(src, direction)
		if(istype(T))
			T.update_icon()

	update_icon()

//Explosion act
/turf/open/auto_turf/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(20) && bleed_layer)
				var/new_bleed_layer = min(0, bleed_layer - 1)
				addtimer(CALLBACK(src, PROC_REF(changing_layer), new_bleed_layer), 1)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(60) && bleed_layer)
				var/new_bleed_layer = max(bleed_layer - 2, 0)
				addtimer(CALLBACK(src, PROC_REF(changing_layer), new_bleed_layer), 1)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(bleed_layer)
				addtimer(CALLBACK(src, PROC_REF(changing_layer), 0), 1)

/turf/open/auto_turf/scorch(heat_level)
	if(bleed_layer <= 0)
		return
	switch(heat_level)
		if(1 to 19)
			var/new_bleed_layer = min(0, bleed_layer - 1)
			addtimer(CALLBACK(src, PROC_REF(changing_layer), new_bleed_layer), 1)
		if(20 to 39)
			var/new_bleed_layer = max(bleed_layer - 2, 0)
			addtimer(CALLBACK(src, PROC_REF(changing_layer), new_bleed_layer), 1)
		if(40 to INFINITY)
			addtimer(CALLBACK(src, PROC_REF(changing_layer), 0), 1)


//Actual auto-turfs now


//Kutjevo & Trijent sand
/turf/open/auto_turf/sand
	layer_name = list("红土", "沙地", "碎石沙地", "不存在的地层", "请联系开发者")

/turf/open/auto_turf/sand/insert_self_into_baseturfs()
	baseturfs += /turf/open/auto_turf/sand/layer0

/turf/open/auto_turf/sand/get_dirt_type()
	return DIRT_TYPE_SAND

/turf/open/auto_turf/sand/layer0 //still have to manually define the layers for the editor
	icon_state = "sand_0"
	bleed_layer = 0

/turf/open/auto_turf/sand/layer1
	icon_state = "sand_1"
	bleed_layer = 1

/turf/open/auto_turf/sand/layer2
	icon_state = "sand_1_1"
	bleed_layer = 1
	variant = 1
	variant_prefix_name = "多岩石的"

/turf/open/auto_turf/sand_white
	layer_name = list("古老火成岩", "风蚀沙丘", "请通知开发者", "请通知开发者", "请通知开发者")
	icon_state = "varadero_1"
	icon_prefix = "varadero"

/turf/open/auto_turf/sand_white/get_dirt_type()
	return DIRT_TYPE_SAND

/turf/open/auto_turf/sand_white/layer0
	icon_state = "varadero_0"
	bleed_layer = 0

/turf/open/auto_turf/sand_white/layer1
	icon_state = "varadero_1"
	bleed_layer = 1

//Ice Colony permafrost
/turf/open/auto_turf/ice
	name = "冰面"
	icon = 'icons/turf/floors/auto_ice.dmi'
	icon_state = "ice_0"
	icon_prefix = "ice"
	layer_name = list("开裂冻土", "永久冻土", "冰川冻土", "请通知开发者", "请通知开发者")

/turf/open/auto_turf/ice/insert_self_into_baseturfs()
	baseturfs += /turf/open/auto_turf/ice/layer0

/turf/open/auto_turf/ice/get_dirt_type()
	return NO_DIRT
/turf/open/auto_turf/ice/layer0 //still have to manually define the layers for the editor
	icon_state = "ice_0"
	bleed_layer = 0

/turf/open/auto_turf/ice/layer1
	icon_state = "ice_1"
	bleed_layer = 1

/turf/open/auto_turf/ice/layer2
	icon_state = "ice_2"
	bleed_layer = 2

//Ice colony snow
/turf/open/auto_turf/snow
	scorchable = TRUE
	name = "雪地"
	icon = 'icons/turf/floors/snow2.dmi'
	icon_state = "snow_0"
	icon_prefix = "snow"
	layer_name = list("冰冻泥土", "浅积雪", "深积雪", "极深积雪", "夹杂岩石的积雪")

/turf/open/auto_turf/snow/insert_self_into_baseturfs()
	baseturfs += /turf/open/auto_turf/snow/layer0

/turf/open/auto_turf/snow/get_dirt_type()
	if(bleed_layer)
		return DIRT_TYPE_SNOW
	else
		return DIRT_TYPE_GROUND

/turf/open/auto_turf/snow/is_weedable()
	return bleed_layer ? NOT_WEEDABLE : FULLY_WEEDABLE

/turf/open/auto_turf/snow/attackby(obj/item/I, mob/user)
	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "这里已经有[L]了！")
			return

		to_chat(user, "现在开始种植[L]。")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name]将[L]种在了[src]里。")
		L.anchored = TRUE
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.forceMove(src)
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.set_light(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)

//Digging up snow
/turf/open/auto_turf/snow/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.a_intent == INTENT_HARM) //Missed slash.
		return
	if(M.a_intent == INTENT_HELP || !bleed_layer)
		return ..()

	M.visible_message(SPAN_NOTICE("[M]开始清理[src]……"), SPAN_NOTICE("你开始清理[src]……"), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)

	while(bleed_layer > 0)
		xeno_attack_delay(M)
		var/size = max(M.mob_size, 1)
		if(!do_after(M, 12/size, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			return XENO_NO_DELAY_ACTION

		if(!bleed_layer)
			to_chat(M, SPAN_WARNING("没有需要清理的东西！"))
			return XENO_NO_DELAY_ACTION

		var/new_layer = bleed_layer - 1
		changing_layer(new_layer)

	return XENO_NO_DELAY_ACTION

/turf/open/auto_turf/snow/Entered(atom/movable/AM)
	if(bleed_layer > 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			var/slow_amount = 0.35
			var/can_stuck = 1
			if(istype(C, /mob/living/carbon/xenomorph)||isyautja(C))
				slow_amount = 0.15
				can_stuck = 0
			var/new_slowdown = C.next_move_slowdown + (slow_amount * bleed_layer)
			if(prob(2))
				to_chat(C, SPAN_WARNING("穿过[src]会减慢你的速度。")) //Warning only
			else if(can_stuck && bleed_layer == 4 && prob(2))
				to_chat(C, SPAN_WARNING("你在[src]里短暂地陷住了！"))
				new_slowdown += 10
			C.next_move_slowdown = new_slowdown
	..()

/turf/open/auto_turf/snow/layer0 //still have to manually define the layers for the editor
	icon_state = "snow_0"
	bleed_layer = 0

/turf/open/auto_turf/snow/layer1
	icon_state = "snow_1"
	bleed_layer = 1

/turf/open/auto_turf/snow/layer2
	icon_state = "snow_2"
	bleed_layer = 2

/turf/open/auto_turf/snow/layer3
	icon_state = "snow_3"
	bleed_layer = 3

/turf/open/auto_turf/snow/layer4
	icon_state = "snow_4" //Add sorokyne rock decals to this one
	bleed_layer = 4


//new strata turfs

/turf/open/auto_turf/snow/brown_base
	icon_state = "snow_b_0"
	icon_prefix = "snow_b"

/turf/open/auto_turf/snow/brown_base/insert_self_into_baseturfs()
	baseturfs += /turf/open/auto_turf/snow/brown_base/layer0

/turf/open/auto_turf/snow/brown_base/layer0 //still have to manually define the layers for the editor
	icon_state = "snow_b_0"
	bleed_layer = 0

/turf/open/auto_turf/snow/brown_base/layer1
	icon_state = "snow_b_1"
	bleed_layer = 1

/turf/open/auto_turf/snow/brown_base/layer2
	icon_state = "snow_b_2"
	bleed_layer = 2

/turf/open/auto_turf/snow/brown_base/layer3
	icon_state = "snow_b_3"
	bleed_layer = 3

/turf/open/auto_turf/snow/brown_base/layer4
	icon_state = "snow_b_4" //Add sorokyne rock decals to this one
	bleed_layer = 4
/turf/open/auto_turf/strata_grass
	name = "杂乱草地"
	icon = 'icons/turf/floors/auto_strata_grass.dmi'
	icon_state = "grass_0"
	icon_prefix = "grass"
	layer_name = list("地面", "茂密草地")
	desc = "草、泥土、淤泥以及其他含水量很高的洞穴地面。"

/turf/open/auto_turf/strata_grass/insert_self_into_baseturfs()
	baseturfs += /turf/open/auto_turf/strata_grass/layer0

/turf/open/auto_turf/strata_grass/layer0
	icon_state = "grass_0"
	bleed_layer = 0
	variant_prefix_name = "草丛交错的"

/turf/open/auto_turf/strata_grass/layer0_mud
	icon_state = "grass_0_mud"
	bleed_layer = 0
	variant = "mud"
	variant_prefix_name = "泥泞的"

/turf/open/auto_turf/strata_grass/layer0_mud_alt
	icon_state = "grass_0_mud_alt"
	bleed_layer = 0
	variant = "mud_alt"
	variant_prefix_name = "泥泞的"

/turf/open/auto_turf/strata_grass/layer1
	icon_state = "grass_1"
	bleed_layer = 1

//Chance's Claim / Hadley Shale dirt

/turf/open/auto_turf/shale
	layer_name = list("风蚀泥土", "板状火山岩", "火山岩板与岩石", "不存在的地层")
	icon = 'icons/turf/floors/auto_shale.dmi'
	icon_prefix = "shale"

/turf/open/auto_turf/shale/get_dirt_type()
	return DIRT_TYPE_SHALE

/turf/open/auto_turf/shale/layer0
	icon_state = "shale_0"
	bleed_layer = 0
	color = "#6699CC"

/turf/open/auto_turf/shale/layer0_puddle
	icon_state = "shale_0_puddle"
	bleed_layer = 0

/turf/open/auto_turf/shale/layer0_plate //for inner plate shenanigans
	icon_state = "shale_1_alt"
	bleed_layer = 0

/turf/open/auto_turf/shale/layer1
	icon_state = "shale_1"
	bleed_layer = 1

/turf/open/auto_turf/shale/layer2
	icon_state = "shale_2"
	bleed_layer = 2
