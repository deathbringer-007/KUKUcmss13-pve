


/// Dropship weaponry ammunition
/obj/structure/ship_ammo
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	density = TRUE
	anchored = TRUE
	throwpass = TRUE
	climbable = TRUE
	/// Delay between firing steps
	var/fire_mission_delay = 4
	/// Time to impact in deciseconds
	var/travelling_time = 100
	/// Type of dropship equipment that accepts this type of ammo.
	var/obj/structure/dropship_equipment/equipment_type
	/// Ammunition count remaining
	var/ammo_count
	/// Maximal ammunition count
	var/max_ammo_count
	/// What to call the ammo in the ammo transferring message
	var/ammo_name = "round"
	var/ammo_id
	/// Whether the ammo inside this magazine can be transferred to another magazine.
	var/transferable_ammo = FALSE
	/// How many tiles the ammo can deviate from the laser target
	var/accuracy_range = 3
	/// Sound played mere seconds before impact
	var/warning_sound = 'sound/effects/rocketpod_fire.ogg'
	/// Volume of the sound played before impact
	var/warning_sound_volume = 70
	/// Ammunition expended each time this is fired
	var/ammo_used_per_firing = 1
	/// Maximum deviation allowed when the ammo is not longer guided by a laser
	var/max_inaccuracy = 6
	/// Cost to build in the fabricator, zero means unbuildable
	var/point_cost
	/// Mob that fired this ammunition (the pilot pressing the trigger)
	var/mob/source_mob
	var/combat_equipment = TRUE

/obj/structure/ship_ammo/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph]用爪子猛抓[src]！"),
	SPAN_DANGER("你用爪子猛抓[src]！"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/ship_ammo/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return FALSE
		if(PC.loaded)
			if(istype(PC.loaded, /obj/structure/ship_ammo))
				var/obj/structure/ship_ammo/SA = PC.loaded
				SA.transfer_ammo(src, user)
				return FALSE
		else
			if(ammo_count < 1)
				to_chat(user, SPAN_WARNING("[src]的弹药用尽了，你将它丢弃！"))
				qdel(src)
				return FALSE

			if(ammo_name == "rocket")
				PC.grab_object(user, src, "ds_rocket", 'sound/machines/hydraulics_1.ogg')
			else
				PC.grab_object(user, src, "ds_ammo", 'sound/machines/hydraulics_1.ogg')
			update_icon()
			return FALSE
	else
		. = ..()


/obj/structure/ship_ammo/get_examine_text(mob/user)
	. = ..()
	. += "移动它需要某种起重设备。"

//what to show to the user that examines the weapon we're loaded on.
/obj/structure/ship_ammo/proc/show_loaded_desc(mob/user)
	return "It's loaded with \a [src]."

/obj/structure/ship_ammo/proc/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	return

/obj/structure/ship_ammo/proc/can_fire_at(turf/impact, mob/user)
	return TRUE

/obj/structure/ship_ammo/proc/transfer_ammo(obj/structure/ship_ammo/target, mob/user)
	if(type != target.type)
		to_chat(user, SPAN_NOTICE("[src]与[target]使用的弹药类型不兼容！"))
		return
	if(!transferable_ammo)
		to_chat(user, SPAN_NOTICE("[src]不支持转移[ammo_name]！"))
		return
	var/obj/item/powerloader_clamp/PC
	if(istype(loc, /obj/item/powerloader_clamp))
		PC = loc
	if(ammo_count < 1)
		if(PC)
			PC.loaded = null
			PC.update_icon()
		to_chat(user, SPAN_WARNING("[src]的弹药用尽了，你将它丢弃！"))
		forceMove(get_turf(loc))
		qdel(src)
	if(target.ammo_count >= target.max_ammo_count)
		to_chat(user, SPAN_WARNING("[target]已装满！"))
		return

	var/transf_amt = min(target.max_ammo_count - target.ammo_count, ammo_count)
	target.ammo_count += transf_amt
	ammo_count -= transf_amt
	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	to_chat(user, SPAN_NOTICE("你将[transf_amt]份[ammo_name]转移至[target]。"))
	if(ammo_count < 1)
		if(PC)
			PC.loaded = null
			PC.update_icon()
		to_chat(user, SPAN_WARNING("[src]的弹药用尽了，你将它丢弃！"))
		forceMove(get_turf(loc))
		qdel(src)
	else
		if(PC)
			if(ammo_name == "rocket")
				PC.update_icon("ds_rocket")
			else
				PC.update_icon("ds_ammo")


//30mm gun

/obj/structure/ship_ammo/heavygun
	name = "\improper 25毫米多用途弹药箱"
	icon_state = "30mm_crate"
	desc = "加固弹药箱，内装400发供GAU-113转管机炮使用的25毫米穿甲高爆燃烧弹。适合攻击轻型建筑、暴露人员和薄皮车辆，对重型装甲完全无效。"
	travelling_time = 50
	equipment_type = /obj/structure/dropship_equipment/weapon/heavygun
	ammo_count = 400
	max_ammo_count = 400
	transferable_ammo = TRUE
	ammo_used_per_firing = 40
	point_cost = 275
	fire_mission_delay = 2
	var/bullet_spread_range = 2 //how far from the real impact turf can bullets land
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/gau //For siming 30mm bullet impacts.
	var/directhit_damage = 150 //how much damage is to be inflicted to a mob, this is here so that we can hit resting mobs.
	var/penetration = 15 //AP value pretty much

/obj/structure/ship_ammo/heavygun/get_examine_text(mob/user)
	. = ..()
	. += "它还装有[ammo_count]发弹药。"

/obj/structure/ship_ammo/heavygun/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] containing [ammo_count] round\s."
	else
		return "It's loaded with an empty [name]."

/obj/structure/ship_ammo/heavygun/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	set waitfor = 0
	var/list/turf_list = RANGE_TURFS(bullet_spread_range, impact)
	var/soundplaycooldown = 0
	var/debriscooldown = 0

	for(var/i = 1 to ammo_used_per_firing)
		sleep(1)
		var/turf/impact_tile = pick(turf_list)
		var/datum/cause_data/cause_data = create_cause_data(fired_from?.name, source_mob)
		impact_tile.ex_act(EXPLOSION_THRESHOLD_VLOW, pick(GLOB.alldirs), cause_data)
		create_shrapnel(impact_tile,1,0,0,shrapnel_type,cause_data,FALSE,100) //simulates a bullet
		for(var/atom/movable/explosion_effect in impact_tile)
			if(iscarbon(explosion_effect))
				var/mob/living/carbon/bullet_effect = explosion_effect
				explosion_effect.ex_act(EXPLOSION_THRESHOLD_VLOW, null, cause_data)
				bullet_effect.apply_armoured_damage(directhit_damage,ARMOR_BULLET,BRUTE,null,penetration)
			else
				explosion_effect.ex_act(EXPLOSION_THRESHOLD_VLOW)
		new /obj/effect/particle_effect/expl_particles(impact_tile)
		if(!soundplaycooldown) //so we don't play the same sound 20 times very fast.
			playsound(impact_tile, 'sound/effects/gauimpact.ogg',40,1,20)
			soundplaycooldown = 3
		soundplaycooldown--
		if(!debriscooldown)
			impact_tile.ceiling_debris_check(1)
			debriscooldown = 6
		debriscooldown--
	sleep(11) //speed of sound simulation
	playsound(impact, 'sound/effects/gau.ogg',100,1,60)


/obj/structure/ship_ammo/heavygun/antitank
	name = "\improper 25毫米穿甲弹药箱"
	icon_state = "30mm_crate_hv"
	desc = "加固弹药箱，内装400发25毫米次口径脱壳穿甲弹。对建筑和暴露人员的效果较差，但擅长打击装甲、掩体内人员和其他坚固目标。"
	travelling_time = 60
	ammo_count = 400
	max_ammo_count = 400
	ammo_used_per_firing = 40
	bullet_spread_range = 3
	point_cost = 325
	fire_mission_delay = 2
	shrapnel_type = /datum/ammo/bullet/shrapnel/gau/at
	directhit_damage = 100 //how much damage is to be inflicted to a mob, this is here so that we can hit resting mobs.
	penetration = 40 //AP value pretty much

//laser battery

/obj/structure/ship_ammo/laser_battery
	name = "\improper BTU-17/LW大容量激光电池"
	icon_state = "laser_battery"
	desc = "为激光束武器供能的大容量电池，可装入AN/AEQ-22激光系统。"
	travelling_time = 10
	ammo_count = 100
	max_ammo_count = 100
	ammo_used_per_firing = 40
	equipment_type = /obj/structure/dropship_equipment/weapon/laser_beam_gun
	ammo_name = "charge"
	transferable_ammo = TRUE
	accuracy_range = 1
	ammo_used_per_firing = 10
	max_inaccuracy = 1
	warning_sound = 'sound/effects/nightvision.ogg'
	point_cost = 200
	fire_mission_delay = 4 //very good but long cooldown


/obj/structure/ship_ammo/laser_battery/get_examine_text(mob/user)
	. = ..()
	. += "It's at [floor(100*ammo_count/max_ammo_count)]% charge."


/obj/structure/ship_ammo/laser_battery/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] at [floor(100*ammo_count/max_ammo_count)]% charge."
	else
		return "It's loaded with an empty [name]."


/obj/structure/ship_ammo/laser_battery/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	set waitfor = 0
	var/list/turf_list = RANGE_TURFS(3, impact) //This is its area of effect
	playsound(impact, 'sound/effects/pred_vision.ogg', 20, 1)
	for(var/i=1 to 16) //This is how many tiles within that area of effect will be randomly ignited
		var/turf/U = pick(turf_list)
		turf_list -= U
		fire_spread_recur(U, create_cause_data(fired_from?.name, source_mob), 1, null, 5, 75, "#EE6515")//Very, very intense, but goes out very quick

	if(!ammo_count && !QDELETED(src))
		qdel(src) //deleted after last laser beam is fired and impact the ground.


//Rockets

/obj/structure/ship_ammo/rocket
	name = "abstract rocket"
	icon_state = "single"
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	equipment_type = /obj/structure/dropship_equipment/weapon/rocket_pod
	ammo_count = 1
	max_ammo_count = 1
	ammo_name = "rocket"
	ammo_id = ""
	bound_width = 64
	bound_height = 32
	travelling_time = 60 //faster than 30mm rounds
	max_inaccuracy = 5
	point_cost = 0

/obj/structure/ship_ammo/rocket/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	qdel(src)


//this one is air-to-air only
/obj/structure/ship_ammo/rocket/widowmaker
	name = "\improper AIM-90E“锁喉”空对空导弹"
	desc = "AIM-90E是一种全向、多模制导导弹，智能引信控制的34枚爆炸镖载荷使其特别适合打击空中目标；光学／雷达导引头也能攻击防护较弱的地面目标。E型改进了对抗干扰的能力与高空拦截性能。"
	icon_state = "single"
	travelling_time = 30 //not powerful, but reaches target fast
	ammo_id = ""
	point_cost = 300
	fire_mission_delay = 4 //We don't care because our ammo has just 1 rocket

/obj/structure/ship_ammo/rocket/widowmaker/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 300, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)), source_mob), 0.5 SECONDS) //Your standard HE splash damage rocket. Good damage, good range, good speed, it's an all rounder
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/banshee
	name = "\improper AGM-220C“地狱猎犬Ⅱ”战术导弹"
	desc = "AGM-220C是一种用于点目标的多用途空对地导弹，采用红外／主动雷达复合导引头进行末段制导，智能引信决定最佳起爆方式。C型改进了雷达和抗干扰逻辑。"
	icon_state = "banshee"
	ammo_id = "b"
	point_cost = 300
	fire_mission_delay = 4 //We don't care because our ammo has just 1 rocket

/obj/structure/ship_ammo/rocket/banshee/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 175, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)), source_mob), 0.5 SECONDS) //Small explosive power with a small fall off for a big explosion range
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 4, 15, 50, "#00b8ff"), 0.5 SECONDS) //Very intense but the fire doesn't last very long
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/banshee/nerve
	name = "\improper AGM-220H空对地导弹"
	desc = "AGM-220系列可搭载多种战斗部。H型经过专门改装，能安全容纳用于饱和攻击的CN-20神经毒剂载荷。"
	icon_state = "banshee"
	ammo_id = "b"
	point_cost = 500 //changed from regular banshee even if in 99.99999% of cases PvE will never need this but I was too scared to remove it for fear of something exploding
	fire_mission_delay = 4 //We don't care because our ammo has just 1 rocket

/obj/structure/ship_ammo/rocket/banshee/nerve/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	spawn(5)
		cell_explosion(impact, 25, 44, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob))
		spawn(5)
			var/datum/effect_system/smoke_spread/cn20/cn20 = new()
			cn20.set_up(8, 0, impact, null)
			cn20.start()
	QDEL_IN(src, 0.5 SECONDS)


/obj/structure/ship_ammo/rocket/keeper
	name = "\improper Mk.89 SGW智能炸弹"
	desc = "Mk.89 SGW是在Mk.88基础上改进的低成本武器，可替代AGM-220C，配有红外导引头、120毫米聚能装药、折叠尾翼和火箭发动机。89型延长了发动机燃烧时间，并增加基本的箔条诱饵装置。"
	icon_state = "paveway"
	travelling_time = 20 //A fast payload due to its very tight blast zone
	ammo_id = "k"
	point_cost = 300
	fire_mission_delay = 4 //We don't care because our ammo has just 1 rocket

/obj/structure/ship_ammo/rocket/keeper/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 450, 100, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data(initial(name)), source_mob), 0.5 SECONDS) //Insane fall off combined with insane damage makes the Keeper useful for single targets, but very bad against multiple.
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/harpoon
	name = "\improper AGM-220M“地狱猎犬Ⅱ”破片战术导弹"
	desc = "AGM-220M搭载爆破破片战斗部，运输艇发射时会设定智能引信；对软目标采用可调空爆，对坚固目标采用碰炸。对加固建筑和中重型装甲无效。"
	icon_state = "harpoon"
	ammo_id = "s"
	travelling_time = 50
	point_cost = 200
	fire_mission_delay = 4

/obj/structure/ship_ammo/rocket/harpoon/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 150, 16, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)), source_mob), 0.5 SECONDS)
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/napalm
	name = "\improper AGM-220M“地狱猎犬Ⅱ”燃烧战术导弹"
	desc = "配有燃烧载荷的AGM-220系列导弹，适合清除植被和杀伤人员，但对装甲毫无作用。"
	icon_state = "napalm" //maybe i should just change the goddamn thing to be the same sprite and recolor them or something.
	ammo_id = "n"
	point_cost = 500
	fire_mission_delay = 0 //0 means unusable

/obj/structure/ship_ammo/rocket/napalm/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 200, 25, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name)), source_mob), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 6, 60, 30, "#EE6515"), 0.5 SECONDS) //Color changed into napalm's color to better convey how intense the fire actually is.
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/thermobaric
	name = "\improper AGM-220N“地狱猎犬Ⅱ”温压战术导弹"
	desc = "AGM-220N是该系列中真正的怪物。金属增强装药产生温压爆炸，无论目标是否躲在掩体中，都能有效摧毁人员、轻型车辆和建筑；对装甲的效果则不那么出色。"
	icon_state = "napalm" //screw it, this one i AM changing.
	ammo_id = "f"
	travelling_time = 50
	point_cost = 300
	fire_mission_delay = 4

/obj/structure/ship_ammo/rocket/thermobaric/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 4, 25, 50, "#c96500"), 0.5 SECONDS) //Very intense but the fire doesn't last very long
	for(var/mob/living/carbon/victim in orange(5, impact))
		victim.throw_atom(impact, 3, 15, src, TRUE) // Implosion throws affected towards center of vacuum
	QDEL_IN(src, 0.5 SECONDS)


//minirockets

/obj/structure/ship_ammo/minirocket
	name = "\improper M362 70毫米爆破破片火箭弹"
	desc = "Mk.10“宙斯”无制导火箭系统使用的M362爆破破片战斗部，适合杀伤人员和摧毁轻型建筑。较大规模的齐射也能在一定程度上压制防空系统。"
	icon_state = "minirocket"
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	equipment_type = /obj/structure/dropship_equipment/weapon/minirocket_pod
	ammo_count = 6
	max_ammo_count = 6
	ammo_name = "minirocket"
	travelling_time = 40 //faster than 30mm cannon, slower than real rockets
	transferable_ammo = TRUE
	point_cost = 300
	fire_mission_delay = 3 //high cooldown

/obj/structure/ship_ammo/minirocket/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(2)
	spawn(5)
		cell_explosion(impact, 200, 44, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob))
		var/datum/effect_system/expl_particles/P = new/datum/effect_system/expl_particles()
		P.set_up(4, 0, impact)
		P.start()
		spawn(5)
			var/datum/effect_system/smoke_spread/S = new/datum/effect_system/smoke_spread()
			S.set_up(1,0,impact,null)
			S.start()
		if(!ammo_count && loc)
			qdel(src) //deleted after last minirocket is fired and impact the ground.

/obj/structure/ship_ammo/minirocket/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] containing [ammo_count] minirocket\s."

/obj/structure/ship_ammo/minirocket/get_examine_text(mob/user)
	. = ..()
	. += "它还装有[ammo_count]枚微型火箭弹。"


/obj/structure/ship_ammo/minirocket/incendiary
	name = "\improper M322 70毫米燃烧火箭弹"
	desc = "严格来说，Mk.10“宙斯”使用的M322燃烧战斗部本应退役，但仍有部分库存。适合破坏建筑和清除植被，对坚固目标的效果较差。"
	icon_state = "minirocket_inc"
	point_cost = 500
	fire_mission_delay = 3 //high cooldown

/obj/structure/ship_ammo/minirocket/incendiary/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	..()
	spawn(5)
		fire_spread(impact, create_cause_data(initial(name), source_mob), 3, 25, 20, "#EE6515")

/obj/structure/ship_ammo/sentry
	name = "\improper UA/571-P空投哨戒武器系统"
	desc = "UA/571-P是标准UA/571-C的空投改型，可用于区域封锁、预警和有限的侦察。"
	icon_state = "launchable_sentry"
	equipment_type = /obj/structure/dropship_equipment/weapon/launch_bay
	ammo_count = 1
	max_ammo_count = 1
	ammo_name = "area denial sentry"
	travelling_time = 0 // handled by droppod
	point_cost = 800 //handled by printer
	accuracy_range = 0 // pinpoint
	max_inaccuracy = 0
	/// Special structures it needs to break with drop pod
	var/list/breakeable_structures = list(/obj/structure/barricade, /obj/structure/surface/table)

/obj/structure/ship_ammo/sentry/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	var/obj/structure/droppod/equipment/sentry/droppod = new(impact, /obj/structure/machinery/defenses/sentry/launchable, source_mob)
	droppod.special_structures_to_damage = breakeable_structures
	droppod.special_structure_damage = 500
	droppod.drop_time = 5 SECONDS
	droppod.launch(impact)
	qdel(src)

/obj/structure/ship_ammo/sentry/can_fire_at(turf/impact, mob/user)
	if(istype(impact, /turf/closed))// keeping this as a safety. However, being avble to paradrop the suckers wherever you want is much in line, no? :)
		to_chat(user, SPAN_WARNING("选定的投放地点是一面陡壁！"))
		return FALSE
	return TRUE
