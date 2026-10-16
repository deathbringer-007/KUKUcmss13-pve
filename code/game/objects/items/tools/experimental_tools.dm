/obj/item/tool/crew_monitor
	name = "人员监测仪"
	desc = "用于获取已部署人员坐标的工具。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "crew_monitor"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	var/datum/radar/lifeline/radar
	var/faction = FACTION_MARINE

/obj/item/tool/crew_monitor/Initialize(mapload, ...)
	. = ..()
	radar = new /datum/radar/lifeline(src, faction)

/obj/item/tool/crew_monitor/Destroy()
	QDEL_NULL(radar)
	. = ..()

/obj/item/tool/crew_monitor/attack_self(mob/user)
	. = ..()
	radar.tgui_interact(user)

/obj/item/tool/crew_monitor/dropped(mob/user)
	. = ..()
	SStgui.close_uis(src)

/obj/item/tool/crew_monitor/upp
	name = "“守护灵”生命体征监测仪"
	faction = FACTION_UPP

/obj/item/tool/crew_monitor/pmc
	name = "行动人员健康监测仪"
	faction = FACTION_PMC

/obj/item/tool/signal_tracker
	name = "信号追踪器"
	desc = "用于追踪信号及测量使用者与信号源距离的工具。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "crew_monitor"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_SMALL
	var/datum/radar/signal_tracker/radar

/obj/item/tool/signal_tracker/Initialize(mapload, ...)
	. = ..()
	radar = new /datum/radar/signal_tracker(src)

/obj/item/tool/signal_tracker/Destroy()
	QDEL_NULL(radar)
	. = ..()

/obj/item/tool/signal_tracker/proc/handle_signal_deletion()
	SStgui.close_uis(radar)

/obj/item/tool/signal_tracker/attack_self(mob/user)
	. = ..()
	radar.tgui_interact(user)

/obj/item/clothing/suit/auto_cpr
	name = "自动胸外按压器" //autocompressor
	desc = "对患者胸廓进行规律按压的装置，用于处理紧急心脏问题。\n拿着它点击目标，即可给对方安装。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "autocomp"
	item_state = "autocomp"
	item_state_slots = list(WEAR_JACKET = "autocomp")
	w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_OCLOTHING
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	force = 5
	throwforce = 5
	var/last_pump
	var/doing_cpr = FALSE
	var/pump_cost = 20
	var/obj/item/cell/pdcell = null
	movement_compensation = 0

/obj/item/clothing/suit/auto_cpr/Initialize(mapload, ...)
	. = ..()
	pdcell = new/obj/item/cell(src) //has 1000 charge
	update_icon()

/obj/item/clothing/suit/auto_cpr/mob_can_equip(mob/living/carbon/human/H, slot, disable_warning = 0, force = 0)
	. = ..()
	if(!ishuman_strict(H))
		return FALSE

/obj/item/clothing/suit/auto_cpr/attack(mob/living/carbon/human/M, mob/living/user)
	if(M == user)
		return ..()
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("你完全不知道怎么使用[src]……"))
		return
	if(M.stat == CONSCIOUS)
		to_chat(user, SPAN_WARNING("对方没事，不需要<b>心肺复苏</b>！"))
		return
	if(!M.is_revivable() || !M.check_tod())
		to_chat(user, SPAN_WARNING("已经无力回天了，这么做没有用！"))
		return
	if(istype(M) && user.a_intent == INTENT_HELP)
		if(M.wear_suit)
			to_chat(user, SPAN_WARNING("对方身上的[M.wear_suit]挡住了，先脱下来！"))
			return
		if(!mob_can_equip(M, WEAR_JACKET))
			to_chat(user, SPAN_WARNING("[src]只能安装在人类身上！"))
			return
		user.affected_message(M,
							SPAN_NOTICE("你开始把[src]安装到[M]的胸前。"),
							SPAN_WARNING("[user]开始把[src]安装到你的胸前！"),
							SPAN_NOTICE("[user]开始把[src]安装到[M]的胸前。"))
		if(!(do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(SKILL_MEDICAL), INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)))
			return
		if(!mob_can_equip(M, WEAR_JACKET))
			return
		user.drop_inv_item_on_ground(src)
		if(!M.equip_to_slot_if_possible(src, WEAR_JACKET))
			user.put_in_active_hand(src)
			return
		M.update_inv_wear_suit()
	else
		return ..()

/obj/item/clothing/suit/auto_cpr/equipped(mob/user, slot)
	..()
	if(slot == WEAR_JACKET)
		start_cpr()

/obj/item/clothing/suit/auto_cpr/unequipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_JACKET)
		end_cpr()


/obj/item/clothing/suit/auto_cpr/update_icon()
	. = ..()
	if(doing_cpr)
		icon_state = "autocomp_active"
	else
		icon_state = "autocomp"
	if(pdcell && pdcell.charge)
		overlays.Cut()
	switch(floor(pdcell.charge * 100 / pdcell.maxcharge))
		if(1 to 32)
			overlays += "cpr_batt_lo"
		if(33 to 65)
			overlays += "cpr_batt_mid"
		if(66 to INFINITY)
			overlays += "cpr_batt_hi"


/obj/item/clothing/suit/auto_cpr/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("剩余电量为[floor(pdcell.charge * 100 / pdcell.maxcharge)]%。")



/obj/item/clothing/suit/auto_cpr/proc/start_cpr()
	if(doing_cpr)
		return
	src.visible_message(SPAN_NOTICE("[src]嗡嗡启动，开始按压。"))
	START_PROCESSING(SSobj,src)
	doing_cpr = TRUE
	update_icon()

/obj/item/clothing/suit/auto_cpr/proc/end_cpr()
	if(!doing_cpr)
		return
	doing_cpr = FALSE
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.drop_inv_item_on_ground(src)
		src.visible_message(SPAN_NOTICE("[src]自动从[H]身上脱离了！"))
	src.visible_message(SPAN_NOTICE("[src]关闭电源，停止了按压。"))
	STOP_PROCESSING(SSobj,src)
	update_icon()

/obj/item/clothing/suit/auto_cpr/process()
	if(!ishuman(loc))
		end_cpr()
		return PROCESS_KILL

	var/mob/living/carbon/human/H = loc
	if(H.wear_suit != src)
		end_cpr()
		return PROCESS_KILL

	if(pdcell.charge <= 49)
		src.visible_message(SPAN_NOTICE("[src]发出了电量不足警报。"))
		end_cpr()
		return PROCESS_KILL

	if(world.time > last_pump + 7.5 SECONDS)
		last_pump = world.time
		if(H.stat == UNCONSCIOUS)
			var/suff = min(H.getOxyLoss(), 10) //Pre-merge level, less healing, more prevention of dying.
			H.apply_damage(-suff, OXY)
			H.updatehealth()
			H.affected_message(H,
				SPAN_HELPFUL("你感到<b>一口新鲜空气</b>进入肺中。舒服多了。"),
				message_viewer = SPAN_NOTICE("<b>[src]</b>自动为<b>[H]</b>进行<b>心肺复苏</b>。")
				)
			pdcell.use(pump_cost)
			update_icon()
			return

/obj/item/tool/portadialysis
	name = "便携式透析机"
	desc = "单人即可携带的透析机，内置小型充电电池。连接患者后，可滤除其血液中的所有外来化合物，但通常也会带走一些血液。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "portadialysis"
	item_state = "syringe_0"
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	var/attaching = FALSE
	var/filtering = FALSE
	var/mob/living/carbon/human/attached = null
	var/reagent_removed_per_second = AMOUNT_PER_TIME(3, 2 SECONDS)
	var/obj/item/cell/pdcell = null
	var/filter_cost = AMOUNT_PER_TIME(20, 2 SECONDS)
	var/blood_cost = AMOUNT_PER_TIME(12, 2 SECONDS)
	var/attach_time = 1.2 SECONDS

/obj/item/tool/portadialysis/Initialize(mapload, ...)
	. = ..()

	pdcell = new/obj/item/cell(src) //has 1000 charge
	update_icon()

/obj/item/tool/portadialysis/update_icon(detaching = FALSE)
	overlays.Cut()
	if(attached)
		overlays += "+hooked"
	else
		overlays += "+unhooked"

	if(detaching)
		overlays += "+draining"
		addtimer(CALLBACK(src, PROC_REF(update_icon)), attach_time)

	else if(attaching)
		overlays += "+filling"
		overlays += "+running"

	else if(filtering)
		overlays += "+running"
		overlays += "+filtering"

	if(pdcell && pdcell.charge)
		switch(floor(pdcell.charge * 100 / pdcell.maxcharge))
			if(85 to INFINITY)
				overlays += "dialysis_battery_100"
			if(60 to 84)
				overlays += "dialysis_battery_85"
			if(45 to 59)
				overlays += "dialysis_battery_60"
			if(30 to 44)
				overlays += "dialysis_battery_45"
			if(15 to 29)
				overlays += "dialysis_battery_30"
			if(1 to 14)
				overlays += "dialysis_battery_15"
			else
				overlays += "dialysis_battery_0"

/obj/item/tool/portadialysis/get_examine_text(mob/user)
	. = ..()
	var/currentpercent = 0
	currentpercent = floor(pdcell.charge * 100 / pdcell.maxcharge)
	. += SPAN_INFO("内置电池剩余电量为[currentpercent]%。")

/obj/item/tool/portadialysis/proc/painful_detach()
	if(!attached) //sanity
		return
	attached.visible_message(SPAN_WARNING("[src]的针头被从[attached]身上硬扯了出来，看着都疼！"))
	to_chat(attached, SPAN_WARNING("好痛！针头被从你身上硬扯了出来！"))
	damage_arms(attached)
	if(attached.pain.feels_pain)
		attached.emote("scream")
	attached = null
	filtering = FALSE
	attaching = FALSE
	update_icon(TRUE)
	STOP_PROCESSING(SSobj, src)

/obj/item/tool/portadialysis/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!ishuman_strict(target))
		return ..()

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("你似乎不知道怎么使用[src]……"))
		return

	if(!pdcell || pdcell.charge == 0)
		to_chat(user, SPAN_NOTICE("[src]的“电量不足”指示灯闪烁，无法连接。"))
		return

	if(ishuman(user))
		if(user.stat || user.blinded || user.body_position == LYING_DOWN)
			return

		if(attaching)
			return

		if(attached && !(target == attached)) //are we already attached to something that isn't the target?
			to_chat(user, SPAN_WARNING("你已经在给别人使用[src]了！"))
			return

		if(target == attached) //are we attached to the target?
			user.visible_message("[user]从[attached]身上拆下了[src]。", \
			"你从[attached]身上拆下了[src]。")
			attached = null
			filtering = FALSE
			attaching = FALSE
			update_icon(TRUE)
			STOP_PROCESSING(SSobj, src)
			return

		else
			//check for if they actually have arms...
			var/obj/limb/l_arm = target.get_limb("l_arm")
			var/obj/limb/r_arm = target.get_limb("r_arm")
			if((l_arm.status & LIMB_DESTROYED) && (r_arm.status & LIMB_DESTROYED))
				to_chat(user, SPAN_WARNING("[target]没有手臂，无法连接[src]！"))
				return

			attaching = TRUE
			update_icon()
			to_chat(target, SPAN_DANGER("[user]正试图把[src]连接到你身上！"))
			user.visible_message(SPAN_WARNING("[user]开始把[src]的针头插到[target]的手臂上。"), \
				SPAN_WARNING("你开始把[src]的针头插到[target]的手臂上。"))
			if(!do_after(user, attach_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
				user.visible_message(SPAN_WARNING("[user]停止了给[target]的手臂插入[src]针头的操作。"), \
				SPAN_WARNING("你停止了给[target]的手臂插入[src]针头的操作。"))
				visible_message("[src]的软管弹回了机身。")
				attaching = FALSE
				update_icon()
				return

			user.visible_message("[user]把[src]连接到了[target]身上。", \
			"你把[src]连接到了[target]身上。")
			attached = target
			filtering = TRUE
			attaching = FALSE
			update_icon()
			START_PROCESSING(SSobj, src)
			return

/obj/item/tool/portadialysis/dropped(mob/user)
	if(attached)
		painful_detach()
	. = ..()


/obj/item/tool/portadialysis/process(delta_time)
	if(!attached)
		return

	if(get_dist(src, attached) > 1)
		painful_detach()
		return

	if(!pdcell || pdcell.charge == 0)
		attached.visible_message(SPAN_NOTICE("[src]自动从[attached]身上脱离，“电量不足”指示灯闪烁。"))
		attached = null
		filtering = FALSE
		update_icon(TRUE)
		STOP_PROCESSING(SSobj, src)
		return

	var/obj/limb/l_arm = attached.get_limb("l_arm")
	var/obj/limb/r_arm = attached.get_limb("r_arm")
	if((l_arm.status & LIMB_DESTROYED) && (r_arm.status & LIMB_DESTROYED))
		attached.visible_message(SPAN_NOTICE("[src]自动从[attached]身上脱离——对方已经没有可供连接的手臂了！"))
		attached = null
		filtering = FALSE
		update_icon(TRUE)
		STOP_PROCESSING(SSobj, src)
		return

	if(filtering)
		attached.reagents.remove_any_but("blood", reagent_removed_per_second*delta_time)
		attached.take_blood(attached, blood_cost*delta_time)
		if(attached.blood_volume < BLOOD_VOLUME_SAFE) if(prob(5))
			visible_message("[src]发出了响亮的哔哔声。")
		pdcell.use(filter_cost*delta_time)

	updateUsrDialog()
	update_icon()

/obj/item/tool/portadialysis/proc/damage_arms(mob/living/carbon/human/human_to_damage)
	var/obj/limb/l_arm = human_to_damage.get_limb("l_arm")
	var/obj/limb/r_arm = human_to_damage.get_limb("r_arm")
	var/list/arms_to_damage = list(l_arm, r_arm)
	if(l_arm.status & LIMB_DESTROYED)
		arms_to_damage -= l_arm
	if(r_arm.status & LIMB_DESTROYED)
		arms_to_damage -= r_arm
	if(length(arms_to_damage))
		human_to_damage.apply_damage(3, BRUTE, pick(arms_to_damage))
