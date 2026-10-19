/obj/item/defenses/handheld
	name = "你不该看到这个。"
	desc = "USCM 防御设施的紧凑版，便于在战场上快速部署对应设施。"
	icon = 'icons/obj/structures/machinery/defenses/sentry.dmi'
	icon_state = "DMR uac_sentry_handheld"

	force = 5
	throwforce = 5
	throw_speed = SPEED_SLOW
	throw_range = 5
	w_class = SIZE_MEDIUM

	indestructible = TRUE
	var/defense_type = /obj/structure/machinery/defenses
	var/deployment_time = (0.5 SECONDS)

	var/dropped = 1
	var/obj/structure/machinery/defenses/TR

/obj/item/defenses/handheld/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("它已准备好部署。")
	. += SPAN_INFO("耐久为[SPAN_HELPFUL("[TR.health]/[TR.health_max]")]。")

/obj/item/defenses/handheld/Initialize()
	. = ..()
	connect()

/obj/item/defenses/handheld/Destroy()
	if(!QDESTROYING(TR))
		QDEL_NULL(TR)
	return ..()

/obj/item/defenses/handheld/proc/connect()
	if(dropped && !TR)
		TR = new defense_type
		if(!TR.HD)
			TR.HD = src
			return TRUE
		return TRUE
	return FALSE

/obj/item/defenses/handheld/attack_self(mob/living/carbon/human/user)
	..()

	if(!istype(user))
		return

	deploy_handheld(user)

/obj/item/defenses/handheld/proc/deploy_handheld(mob/living/carbon/human/user)
	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("这里太拥挤，无法部署[src]。"))
		return

	var/turf/T = get_step(user, user.dir)
	var/direction = user.dir

	var/blocked = FALSE
	for(var/obj/O in T)
		if(O.density)
			blocked = TRUE
			break

	for(var/mob/M in T)
		blocked = TRUE
		break

	if(istype(T, /turf/open))
		var/turf/open/floor = T
		if(!floor.allow_construction)
			to_chat(user, SPAN_WARNING("这里无法部署[src]，请找更稳固的地面！"))
			return FALSE
	else
		blocked = TRUE

	if(blocked)
		to_chat(usr, SPAN_WARNING("部署[src]需要一片开阔区域，你前方有东西挡住了！"))
		return

	if(!do_after(user, deployment_time * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return

	playsound(T, 'sound/mecha/mechmove01.ogg', 30, 1)

	if(!TR.faction_group) //Littly trolling for stealing marines turrets, bad boys!
		for(var/i in user.faction_group)
			LAZYADD(TR.faction_group, i)
	TR.forceMove(get_turf(T))
	TR.placed = 1
	TR.update_icon()
	TR.setDir(direction)
	transfer_label_component(TR)
	TR.owner_mob = user
	dropped = 0
	user.drop_inv_item_to_loc(src, TR)

/obj/item/defenses/handheld/proc/get_upgrade_list()
	return null

/obj/item/defenses/handheld/proc/upgrade_string_to_type()
	return null

// SENTRY BASE AND UPGRADES
/obj/item/defenses/handheld/sentry
	name = "手提式 UA 571-C 哨戒机枪"
	icon = 'icons/obj/structures/machinery/defenses/sentry.dmi'
	icon_state = "Normal uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry

/obj/item/defenses/handheld/sentry/get_upgrade_list()
	. = list(
		"Shotgun Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/sentry.dmi', icon_state = "Shotgun uac_sentry_handheld"),
		"Mini-Sentry Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/sentry.dmi', icon_state = "Mini uac_sentry_handheld"),
		"Omni-Sentry Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/sentry.dmi', icon_state="Normal uac_sentry_handheld")
	)

/obj/item/defenses/handheld/sentry/upgrade_string_to_type(upgrade_string)
	switch(upgrade_string)
		if("Shotgun Upgrade")
			return /obj/item/defenses/handheld/sentry/shotgun
		if("Mini-Sentry Upgrade")
			return /obj/item/defenses/handheld/sentry/mini

/obj/item/defenses/handheld/sentry/dmr
	name = "便携式 UA 725-D 狙击哨戒炮"
	icon_state = "DMR uac_sentry_handheld"
	deployment_time = 2 SECONDS
	defense_type = /obj/structure/machinery/defenses/sentry/dmr

/obj/item/defenses/handheld/sentry/shotgun
	name = "便携式 UA 12-G 霰弹哨戒炮"
	icon_state = "Shotgun uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/shotgun

/obj/item/defenses/handheld/sentry/mini
	name = "便携式 UA 512-M 迷你哨戒炮"
	icon_state = "Mini uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/mini
	deployment_time = 0.75 SECONDS

/obj/item/defenses/handheld/sentry/wy
	name = "便携式 WY 202-GMA1 智能哨戒炮"
	desc = "维兰德-汤谷防御装置的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/wy_defenses.dmi'
	icon_state = "Normal wy_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/wy
	deployment_time = 5 SECONDS

/obj/item/defenses/handheld/sentry/wy/mini
	name = "便携式 WY 14-GRA2 迷你哨戒炮"
	icon_state = "Mini wy_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/mini/wy
	deployment_time = 2 SECONDS

/obj/item/defenses/handheld/sentry/wy/heavy
	name = "便携式 WY 2-ADT-A3 重型哨戒炮"
	icon = 'icons/obj/structures/machinery/defenses/wy_heavy.dmi'
	icon_state = "Heavy wy_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/dmr/wy
	deployment_time = 10 SECONDS

/obj/item/defenses/handheld/sentry/pmc_platoon
	name = "便携式 UA 571-C-WY 哨戒炮"
	desc = "维兰德-汤谷防御装置的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/wy_defenses.dmi'
	icon_state = "Normal wy_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/platoon_pmc
	deployment_time = 5 SECONDS

/obj/item/defenses/handheld/sentry/upp
	name = "便携式 UPPA 32-H 哨戒炮"
	desc = "进步人民联盟陆军防御装置的紧凑型号，便于在野外快速部署对应型号。"
	icon_state = "UPP uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/upp

/obj/item/defenses/handheld/sentry/upp/light
	name = "便携式 UPP SDS-R8 轻型哨戒炮"
	desc = "进步人民联盟 SDS-R7 哨戒炮的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/upp_defenses.dmi'
	icon_state = "Light upp_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/upp/light
	deployment_time = 2 SECONDS

// FLAMER BASE AND UPGRADES
/obj/item/defenses/handheld/sentry/flamer
	name = "手提式 UA 42-F 哨戒喷火器"
	icon = 'icons/obj/structures/machinery/defenses/flamer.dmi'
	icon_state = "Normal uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer
	var/ammo_convert

/obj/item/defenses/handheld/sentry/flamer/get_upgrade_list()
	. = list()
	. += list(
		"Mini-Flamer Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/flamer.dmi', icon_state = "Mini uac_flamer_handheld")
	)

/obj/item/defenses/handheld/sentry/flamer/upgrade_string_to_type(upgrade_string)
	switch(upgrade_string)
		if("Mini-Flamer Upgrade")
			return /obj/item/defenses/handheld/sentry/flamer/mini

/obj/item/defenses/handheld/sentry/flamer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ammo_convert) return

	if(!istype(target, /obj/item/ammo_magazine/sentry_flamer))
		return .

	user.visible_message(SPAN_NOTICE("[user]开始调整[target]的弹药。"), SPAN_NOTICE("你开始调整[target]的弹药。"))

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target))
		to_chat(user, SPAN_WARNING("你停止调整[target]的弹药。"))
		return

	var/obj/item/ammo_magazine/sentry_flamer/mag = new ammo_convert(get_turf(user))

	user.visible_message(SPAN_NOTICE("[user]将[target]的弹药改为[mag]。"), SPAN_NOTICE("你将[target]的弹药改为[mag]。"))

	qdel(target)
	user.put_in_any_hand_if_possible(mag)


/obj/item/defenses/handheld/sentry/flamer/mini
	name = "便携式 UA 45-FM 迷你哨戒炮"
	icon_state = "Mini uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer/mini
	deployment_time = 0.75 SECONDS
	ammo_convert = /obj/item/ammo_magazine/sentry_flamer/mini

/obj/item/defenses/handheld/sentry/flamer/wy
	name = "便携式 WY 406-FE2 智能哨戒炮"
	desc = "维兰德-汤谷防御装置的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/wy_defenses.dmi'
	icon_state = "Normal wy_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer/wy
	deployment_time = 5 SECONDS
	ammo_convert = /obj/item/ammo_magazine/sentry_flamer/wy

/obj/item/defenses/handheld/sentry/flamer/upp
	name = "便携式 UPP SDS-R5 哨戒喷火器"
	desc = "进步人民联盟防御装置的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/upp_defenses.dmi'
	icon_state = "Normal upp_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer/upp
	deployment_time = 5 SECONDS
	ammo_convert = /obj/item/ammo_magazine/sentry_flamer/upp

// TESLA BASE AND UPGRADES
/obj/item/defenses/handheld/tesla_coil
	name = "手提式 21S 特斯拉线圈"
	icon = 'icons/obj/structures/machinery/defenses/tesla.dmi'
	icon_state = "Normal tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil

/obj/item/defenses/handheld/tesla_coil/get_upgrade_list()
	. = list(
		"Overclocked Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/tesla.dmi', icon_state = "Stun tesla_coil_handheld"),
		"Micro-Tesla Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/tesla.dmi', icon_state = "Micro tesla_coil_handheld")
	)

/obj/item/defenses/handheld/tesla_coil/upgrade_string_to_type(upgrade_string)
	switch(upgrade_string)
		if("Overclocked Upgrade")
			return /obj/item/defenses/handheld/tesla_coil/stun
		if("Micro-Tesla Upgrade")
			return /obj/item/defenses/handheld/tesla_coil/micro

/obj/item/defenses/handheld/tesla_coil/stun
	name = "手提式 21S 超频特斯拉线圈"
	icon_state = "Stun tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil/stun

/obj/item/defenses/handheld/tesla_coil/stun/rmc
	name = "手提式 L33A1 TED 装置"
	defense_type = /obj/structure/machinery/defenses/tesla_coil/stun/rmc

/obj/item/defenses/handheld/tesla_coil/micro
	name = "便携式 25S 微型特斯拉线圈"
	icon_state = "Micro tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil/micro
	deployment_time = 0.75 SECONDS

// BELL TOWER BASE AND UPGRADES
/obj/item/defenses/handheld/bell_tower
	name = "便携式 R-1NG 警铃塔"
	icon = 'icons/obj/structures/machinery/defenses/bell_tower.dmi'
	icon_state = "Normal bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower

/obj/item/defenses/handheld/bell_tower/get_upgrade_list()
	. = list(
		"Motion-Detection Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/bell_tower.dmi', icon_state = "MD bell_tower_handheld"),
		"Cloaking Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/bell_tower.dmi', icon_state = "Cloaker bell_tower_handheld")
	)

/obj/item/defenses/handheld/bell_tower/upgrade_string_to_type(upgrade_string)
	switch(upgrade_string)
		if("Motion-Detection Upgrade" )
			return /obj/item/defenses/handheld/bell_tower/md
		if("Cloaking Upgrade")
			return /obj/item/defenses/handheld/bell_tower/cloaker

/obj/item/defenses/handheld/bell_tower/md
	name = "便携式 R-1NG 动态探测塔"
	icon_state = "MD bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower/md

/obj/item/defenses/handheld/bell_tower/cloaker
	name = "便携式伪装 R-1NG 警铃塔"
	icon_state = "Cloaker bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower/cloaker

// image(icon = 'icons/obj/items/clothing/backpacks.dmi', icon_state = "bell_backpack") = /obj/item/storage/backpack/imp
// bell backpack - disabled for now.

// JIMA TOWER BASE AND UPGRADES
/obj/item/defenses/handheld/planted_flag
	name = "手提式 JIMA 立式旗帜"
	icon = 'icons/obj/structures/machinery/defenses/planted_flag.dmi'
	icon_state = "Normal planted_flag_handheld"
	defense_type = /obj/structure/machinery/defenses/planted_flag
	deployment_time = 1 SECONDS

/obj/item/defenses/handheld/planted_flag/get_upgrade_list()
	. = list(
		"Warbanner Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/planted_flag.dmi', icon_state = "Warbanner planted_flag_handheld"),
		"Extended Upgrade" = image(icon = 'icons/obj/structures/machinery/defenses/planted_flag.dmi', icon_state = "Range planted_flag_handheld")
	)

/obj/item/defenses/handheld/planted_flag/upgrade_string_to_type(upgrade_string)
	switch(upgrade_string)
		if("Warbanner Upgrade")
			return /obj/item/defenses/handheld/planted_flag/warbanner
		if("Extended Upgrade")
			return /obj/item/defenses/handheld/planted_flag/range

/obj/item/defenses/handheld/planted_flag/warbanner
	name = "便携式 JIMA 固定战旗"
	icon_state = "Warbanner planted_flag_handheld"
	deployment_time = 0.5 SECONDS
	defense_type = /obj/structure/machinery/defenses/planted_flag/warbanner

/obj/item/defenses/handheld/planted_flag/range
	name = "便携式加高 JIMA 固定旗帜"
	icon_state = "Range planted_flag_handheld"
	deployment_time = 2 SECONDS
	defense_type = /obj/structure/machinery/defenses/planted_flag/range

/obj/item/defenses/handheld/planted_flag/wy
	name = "便携式维兰德-汤谷固定旗帜"
	desc = "维兰德-汤谷防御装置的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/wy_defenses.dmi'
	icon_state = "WY planted_flag_handheld"
	deployment_time = 3 SECONDS
	defense_type = /obj/structure/machinery/defenses/planted_flag/wy

/obj/item/defenses/handheld/planted_flag/upp
	name = "便携式进步人民联盟固定旗帜"
	desc = "进步人民联盟防御装置的紧凑型号，专为野外部署设计。"
	icon = 'icons/obj/structures/machinery/defenses/upp_defenses.dmi'
	icon_state = "UPP planted_flag_handheld"
	deployment_time = 5 SECONDS
	defense_type = /obj/structure/machinery/defenses/planted_flag/upp

