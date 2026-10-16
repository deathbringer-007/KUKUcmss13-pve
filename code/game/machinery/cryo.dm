#define HEAT_CAPACITY_HUMAN 100 //249840 J/K, for a 72 kg person.
#define DEATH_STAGE_NONE 0
#define DEATH_STAGE_EARLY 1
#define DEATH_STAGE_WARNING 2
#define DEATH_STAGE_CRITICAL 3

/obj/structure/machinery/cryo_cell
	name = "冷冻舱"
	desc = "由旧 A.W. 项目捐赠的低温医疗设备，可缓慢治疗舱内患者。"
	icon = 'icons/obj/structures/machinery/cryogenics2.dmi'
	icon_state = "cell"
	density = FALSE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/temperature = 0
	var/autoeject = FALSE
	var/release_notice = FALSE
	var/on = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 200

	var/mob/living/carbon/occupant = null
	var/obj/item/reagent_container/glass/beaker = null
	var/occupant_death_stage = DEATH_STAGE_NONE

/obj/structure/machinery/cryo_cell/Initialize()
	. = ..()
	start_processing()

/obj/structure/machinery/cryo_cell/Destroy()
	if(occupant)
		go_out()
	QDEL_NULL(beaker)
	. = ..()

/obj/structure/machinery/cryo_cell/process()
	if(!on)
		updateUsrDialog()
		return

	if(occupant)
		var/mob/living/carbon/human/human_occupant = occupant
		if(occupant.stat == DEAD && (!istype(human_occupant) || human_occupant.undefibbable))
			go_out(TRUE, TRUE) //Whether auto-eject is on or not, we don't permit literal deadbeats to hang around.
			display_message("患者已死亡！", warning = TRUE)
		else
			process_occupant()

	updateUsrDialog()
	return TRUE

/obj/structure/machinery/cryo_cell/allow_drop()
	return FALSE

/obj/structure/machinery/cryo_cell/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	go_out()

/obj/structure/machinery/cryo_cell/attack_hand(mob/user)
	tgui_interact(user)

/obj/structure/machinery/cryo_cell/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_DISABLED
	if(user == occupant)
		return UI_CLOSE //can't use it from inside!


/obj/structure/machinery/cryo_cell/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cryo", name)
		ui.open()

/obj/structure/machinery/cryo_cell/ui_data(mob/user)
	var/list/data = list()
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? TRUE : FALSE
	data["autoEject"] = autoeject
	data["notify"] = release_notice

	data["occupant"] = list()
	if(occupant)
		var/mob/living/mob_occupant = occupant
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "清醒"
				data["occupant"]["statstate"] = "good"
			if(UNCONSCIOUS)
				data["occupant"]["stat"] = "昏迷"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "死亡"
				data["occupant"]["statstate"] = "bad"
		data["occupant"]["health"] = round(mob_occupant.health, 1)
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = round(mob_occupant.getBruteLoss(), 1)
		data["occupant"]["oxyLoss"] = round(mob_occupant.getOxyLoss(), 1)
		data["occupant"]["toxLoss"] = round(mob_occupant.getToxLoss(), 1)
		data["occupant"]["fireLoss"] = round(mob_occupant.getFireLoss(), 1)
		data["occupant"]["bodyTemperature"] = round(mob_occupant.bodytemperature, 1)
		if(mob_occupant.bodytemperature < 255)
			data["occupant"]["temperaturestatus"] = "good"
		else if(mob_occupant.bodytemperature < T0C)
			data["occupant"]["temperaturestatus"] = "average"
		else
			data["occupant"]["temperaturestatus"] = "bad"

	data["cellTemperature"] = floor(temperature)

	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	var/beakerContents = list()
	if(beaker && beaker.reagents && length(beaker.reagents.reagent_list))
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = R.name, "volume" = R.volume))
	data["beakerContents"] = beakerContents
	return data

/obj/structure/machinery/cryo_cell/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			update_use_power(on ? USE_POWER_ACTIVE : USE_POWER_IDLE)
			update_icon()
			. = TRUE
		if("eject")
			if(!occupant)
				return
			go_out()
			. = TRUE
		if("autoeject")
			autoeject = !autoeject
			. = TRUE
		if("ejectbeaker")
			if(beaker)
				beaker.forceMove(get_step(loc, dir))
				if(Adjacent(usr))
					usr.put_in_hands(beaker)
				beaker = null
				. = TRUE
		if("notice")
			release_notice = !release_notice
			. = TRUE

	updateUsrDialog(ui.user)

/obj/structure/machinery/cryo_cell/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/reagent_container/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("设备内已装有烧杯。"))
			return

		if(istype(W, /obj/item/reagent_container/glass/bucket))
			to_chat(user, SPAN_WARNING("太大了，放不进去！"))
			return

		beaker =  W

		var/reagentnames = ""
		for(var/datum/reagent/cur_reagent in beaker.reagents.reagent_list)
			reagentnames += ";[cur_reagent.name]"

		msg_admin_niche("[key_name(user)] put \a [beaker] into [src], containing [reagentnames] at ([src.loc.x],[src.loc.y],[src.loc.z]) [ADMIN_JMP(src.loc)].", 1)

		if(user.drop_inv_item_to_loc(W, src))
			user.visible_message("[user]将[W]装入[src]！", "你将[W]装入[src]！")
	else if(istype(W, /obj/item/grab))
		if(isxeno(user))
			return
		var/obj/item/grab/grabber = W
		if(!ismob(grabber.grabbed_thing))
			return
		var/mob/grabbed_mob = grabber.grabbed_thing
		put_mob(grabbed_mob)

	updateUsrDialog(user)

/obj/structure/machinery/cryo_cell/power_change(area/master_area)
	. = ..()
	if((occupant || on) && operable())
		update_use_power(USE_POWER_ACTIVE)

/obj/structure/machinery/cryo_cell/update_icon()
	icon_state = initial(icon_state)
	var/is_on = on && operable()
	icon_state = "[icon_state]-[is_on ? "on" : "off"]-[occupant ? "occupied" : "empty"]"

/obj/structure/machinery/cryo_cell/proc/process_occupant()
	if(!occupant)
		return
	if(!operable())
		return

	occupant.bodytemperature += 2*(temperature - occupant.bodytemperature)
	occupant.bodytemperature = max(occupant.bodytemperature, temperature) // this is so ugly i'm sorry for doing it i'll fix it later i promise

	// Warnings if dead
	if(occupant.stat == DEAD && ishuman(occupant))
		var/mob/living/carbon/human/human_occupant = occupant
		var/old_state = occupant_death_stage
		if(world.time > occupant.timeofdeath + human_occupant.revive_grace_period - 1 MINUTES)
			occupant_death_stage = DEATH_STAGE_CRITICAL
		else if(world.time > occupant.timeofdeath + human_occupant.revive_grace_period - 2.5 MINUTES)
			occupant_death_stage = DEATH_STAGE_WARNING
		else
			occupant_death_stage = DEATH_STAGE_EARLY
		if(old_state != occupant_death_stage)
			display_message("患者情况危急！", warning = TRUE)

	// Passive healing if alive and cold enough
	if(occupant.stat != DEAD)
		occupant.recalculate_move_delay = TRUE
		occupant.set_stat(UNCONSCIOUS)
		if(occupant.bodytemperature < T0C)
			occupant.Sleeping(10)
			occupant.apply_effect(10, PARALYZE)

			if(occupant.getOxyLoss())
				occupant.apply_damage(-1, OXY)

			//severe damage should heal waaay slower without proper chemicals
			if(occupant.bodytemperature < 225)
				if(occupant.getToxLoss())
					occupant.apply_damage(max(-1, -20/occupant.getToxLoss()), TOX)
				var/heal_brute = occupant.getBruteLoss() ? min(1, 20/occupant.getBruteLoss()) : 0
				var/heal_fire = occupant.getFireLoss() ? min(1, 20/occupant.getFireLoss()) : 0
				occupant.heal_limb_damage(heal_brute,heal_fire)

	// Chemical healing if cryo meds are involved
	if(beaker && occupant.reagents && beaker.reagents)
		var/occupant_has_cryo_meds = occupant.reagents.get_reagent_amount("cryoxadone") >= 1 || occupant.reagents.get_reagent_amount("clonexadone") >= 1
		var/beaker_has_cryo_meds = beaker.reagents.get_reagent_amount("cryoxadone") >= 1 || beaker.reagents.get_reagent_amount("clonexadone") >= 1

		// To administer, either the occupant has cryo meds and the beaker doesn't or vice versa (not both)
		var/can_administer = (occupant_has_cryo_meds ^ beaker_has_cryo_meds) && length(beaker.reagents.reagent_list)
		if(can_administer && occupant_has_cryo_meds)
			// If its the case of the occupant has cryo meds and not the beaker, we need to pace out the dosage
			// So lets make sure they don't already have some of the beaker drugs
			for(var/datum/reagent/cur_beaker_reagent in beaker.reagents.reagent_list)
				for(var/datum/reagent/cur_occupant_reagent in occupant.reagents.reagent_list)
					if(cur_beaker_reagent.id == cur_occupant_reagent.id)
						can_administer = FALSE
						break

		if(can_administer)
			beaker.reagents.trans_to(occupant, 5)
			beaker.reagents.reaction(occupant, permeable_in_mobs = FALSE)

	if(autoeject)
		//release the patient automatically when brute and burn are handled on non-robotic limbs
		if(!occupant.getBruteLoss(TRUE) && !occupant.getFireLoss(TRUE) && !occupant.getCloneLoss())
			display_message("患者的外伤已治愈。")
			go_out(TRUE)
			return
		if(occupant.health >= occupant.maxHealth)
			display_message("患者的外伤已治愈。")
			go_out(TRUE)
			return

/obj/structure/machinery/cryo_cell/proc/go_out(auto_eject = FALSE, dead = FALSE)
	if(!(occupant))
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	switch(dir)
		if(NORTH)
			occupant.forceMove(get_step(loc, NORTH))
		if(EAST)
			occupant.forceMove(get_step(loc, EAST))
		if(WEST)
			occupant.forceMove(get_step(loc, WEST))
		else
			occupant.forceMove(get_step(loc, SOUTH))
	if(occupant.bodytemperature < 261 && occupant.bodytemperature >= 70)
		occupant.bodytemperature = 261
		occupant.recalculate_move_delay = TRUE
	if(auto_eject) //Turn off and announce if auto-ejected because patient is recovered or dead.
		on = FALSE
		if(release_notice) //If auto-release notices are on as it should be, let the doctors know what's up
			var/reason = "移出原因：患者已康复。"
			if(dead)
				reason = "移出原因：患者已死亡。"
			ai_silent_announcement("患者[occupant]已从[src]中自动移出，地点：[sanitize_area((get_area(occupant))?.name)]。[reason]", ":m")
	occupant = null
	update_use_power(USE_POWER_IDLE)
	update_icon()
	return

/obj/structure/machinery/cryo_cell/proc/put_mob(mob/living/carbon/cur_mob)
	if(inoperable())
		to_chat(usr, SPAN_DANGER("冷冻舱无法工作。"))
		return
	if(!istype(cur_mob) || isxeno(cur_mob))
		to_chat(usr, SPAN_DANGER("冷冻舱无法容纳这种生命体！"))
		return
	if(occupant)
		to_chat(usr, SPAN_DANGER("冷冻舱内已经有人了！"))
		return
	if(cur_mob.abiotic())
		to_chat(usr, SPAN_DANGER("患者须先放下手中的物品。"))
		return
	if(do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		visible_message(SPAN_NOTICE("[usr][usr == cur_mob ? "进入" : "将[cur_mob]移入"]冷冻舱。"))
		cur_mob.forceMove(src)
		if(cur_mob.health >= HEALTH_THRESHOLD_DEAD && (cur_mob.health <= 0 || cur_mob.sleeping))
			to_chat(cur_mob, SPAN_NOTICE("你感到冰冷的液体包围了全身，皮肤开始冻结。"))
		occupant = cur_mob
		occupant_death_stage = DEATH_STAGE_NONE
		update_use_power(USE_POWER_ACTIVE)
		update_icon()
		return TRUE

/obj/structure/machinery/cryo_cell/proc/display_message(msg, silent = FALSE, warning = FALSE)
	if(!silent)
		if(warning)
			playsound(loc, 'sound/machines/twobeep.ogg', 40)
		else
			playsound(loc, 'sound/machines/ping.ogg', 25, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("[src] [warning ? "发出蜂鸣声" : "发出提示音"]: [msg]")]")

/obj/structure/machinery/cryo_cell/verb/move_eject()
	set name = "移出患者"
	set category = "物品"
	set src in oview(1)
	if(usr == occupant)//If the user is inside the tube...
		if(usr.stat == DEAD)//and he's not dead....
			return

		if(tgui_alert(usr, "要启动冷冻舱的移出程序吗？治疗可能尚未完成。", "确认", list("是", "否")) == "是")
			to_chat(usr, SPAN_NOTICE("冷冻舱移出程序已启动，需要三十秒。"))
			visible_message(SPAN_WARNING("冷冻舱的移出指示灯亮起，舱内开始排液！"))
			addtimer(CALLBACK(src, PROC_REF(finish_eject), usr), 30 SECONDS, TIMER_UNIQUE|TIMER_NO_HASH_WAIT)
	else
		if(usr.stat != CONSCIOUS)
			return
		go_out()

/obj/structure/machinery/cryo_cell/proc/finish_eject(mob/original)
	//Check if someone's released/replaced/bombed him already
	if(QDELETED(src) || QDELETED(original) || !occupant || occupant != original)
		return
	go_out()//and release him from the eternal prison.

/obj/structure/machinery/cryo_cell/verb/move_inside()
	set name = "进入舱内"
	set category = "物品"
	set src in oview(1)
	if(usr.stat != CONSCIOUS)
		return
	put_mob(usr)
	return


//clickdrag code - "resist to get out" code is in living_verbs.dm
/obj/structure/machinery/cryo_cell/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/living_mob = user
	if(!istype(living_mob) || target != user) //cant make others get in. grab-click for this
		return

	put_mob(target)


/datum/data/function/proc/reset()
	return

/datum/data/function/proc/r_input(href, href_list, mob/user as mob)
	return

/datum/data/function/proc/display()
	return

#undef DEATH_STAGE_NONE
#undef DEATH_STAGE_EARLY
#undef DEATH_STAGE_WARNING
#undef DEATH_STAGE_CRITICAL
