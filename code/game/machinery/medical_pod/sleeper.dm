/////////////////////////////////////////
// SLEEPER CONSOLE
/////////////////////////////////////////

/obj/structure/machinery/sleep_console
	name = "医疗休眠舱控制台"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeperconsole"
	var/obj/structure/machinery/medical_pod/sleeper/connected = null
	anchored = TRUE //About time someone fixed this.
	density = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	unslashable = TRUE


/obj/structure/machinery/sleep_console/Initialize()
	. = ..()
	connect_sleeper()
	flags_atom |= USES_HEARING

/obj/structure/machinery/sleep_console/proc/connect_sleeper()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/medical_pod/sleeper,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/medical_pod/sleeper,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/sleep_console/Destroy()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		QDEL_NULL(connected)
	. = ..()


/obj/structure/machinery/sleep_console/process()
	if(inoperable())
		return
	updateUsrDialog()


/obj/structure/machinery/sleep_console/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/machinery/sleep_console/attack_remote(mob/living/user)
	return attack_hand(user)

// tgui \\

/obj/structure/machinery/sleep_console/attackby(obj/item/with, mob/user)
	if(!istype(with, /obj/item/research_upgrades/sleeper))
		return
	if(connected.upgraded)
		return
	if(!user.drop_inv_item_to_loc(with, src))
		return
	to_chat(user, SPAN_NOTICE("你将[with]插入控制台，[src]随即发出运转声，开始读取数据。"))
	connected.upgraded = TRUE
	connected.available_chemicals = connected.upgraded_chemicals
	connected.emergency_chems = connected.upgraded_emergency_chems
	connected.reagent_removed_per_second = connected.reagent_removed_per_second_upgraded


/obj/structure/machinery/sleep_console/attack_hand(mob/living/user)
	if(..())
		return
	if(inoperable())
		return

	tgui_interact(user)

/obj/structure/machinery/sleep_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", "医疗休眠舱", 550, 775)
		ui.open()

/obj/structure/machinery/sleep_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/sleep_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/sleep_console/ui_data(mob/user)
	var/list/data = list()

	if(!connected)
		data["connected"] = null
		return data
	else
		data["connected"] = connected
		data["connected_operable"] = connected.inoperable()

	var/mob/living/occupant = connected.occupant

	data["amounts"] = connected.amounts
	data["hasOccupant"] = occupant ? 1 : 0
	var/occupantData[0]
	var/crisis = 0
	if(occupant)
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.maxHealth
		occupantData["minHealth"] = HEALTH_THRESHOLD_DEAD
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["paralysis"] = occupant.getHalLoss()
		occupantData["hasBlood"] = 0
		occupantData["bodyTemperature"] = occupant.bodytemperature
		occupantData["maxTemp"] = 1000 // If you get a burning vox armalis into the sleeper, congratulations
		// Because we can put simple_animals in here, we need to do something tricky to get things working nice
		occupantData["temperatureSuitability"] = 0 // 0 is the baseline
		if(ishuman(occupant))
			var/mob/living/carbon/human/human_occupant = occupant
			if(human_occupant.species)
				// I wanna do something where the bar gets bluer as the temperature gets lower
				// For now, I'll just use the standard format for the temperature status
				var/datum/species/sp = human_occupant.species
				if(occupant.bodytemperature < sp.cold_level_3)
					occupantData["temperatureSuitability"] = -3
				else if(occupant.bodytemperature < sp.cold_level_2)
					occupantData["temperatureSuitability"] = -2
				else if(occupant.bodytemperature < sp.cold_level_1)
					occupantData["temperatureSuitability"] = -1
				else if(occupant.bodytemperature > sp.heat_level_3)
					occupantData["temperatureSuitability"] = 3
				else if(occupant.bodytemperature > sp.heat_level_2)
					occupantData["temperatureSuitability"] = 2
				else if(occupant.bodytemperature > sp.heat_level_1)
					occupantData["temperatureSuitability"] = 1
		else if(istype(occupant, /mob/living/simple_animal))
			var/mob/living/simple_animal/silly = occupant
			if(silly.bodytemperature < silly.minbodytemp)
				occupantData["temperatureSuitability"] = -3
			else if(silly.bodytemperature > silly.maxbodytemp)
				occupantData["temperatureSuitability"] = 3
		// Blast you, imperial measurement system
		occupantData["btCelsius"] = occupant.bodytemperature - T0C
		occupantData["btFaren"] = ((occupant.bodytemperature - T0C) * (9.0/5.0))+ 32

		occupantData["totalreagents"] = occupant.reagents.total_volume
		occupantData["reagentswhenstarted"] = connected.dialysis_started_reagent_vol

		crisis = (occupant.health < connected.min_health)
		// I'm not sure WHY you'd want to put a simple_animal in a sleeper, but precedent is precedent
		// Runtime is aptly named, isn't she?
		if(ishuman(occupant))
			var/mob/living/carbon/human/human_occupant = occupant
			if(!(NO_BLOOD in human_occupant.species.flags))
				occupantData["pulse"] = human_occupant.get_pulse(GETPULSE_TOOL)
				occupantData["hasBlood"] = 1
				occupantData["bloodLevel"] = floor(occupant.blood_volume)
				occupantData["bloodMax"] = occupant.max_blood
				occupantData["bloodPercent"] = round(100*(occupant.blood_volume/occupant.max_blood), 0.01)

	data["occupant"] = occupantData
	data["maxchem"] = connected.max_chem
	data["minhealth"] = connected.min_health
	data["dialysis"] = connected.filtering
	data["auto_eject_dead"] = connected.auto_eject_dead

	var/chemicals[0]
	for(var/re in connected.available_chemicals)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
		if(temp)
			var/reagent_amount = 0
			var/pretty_amount
			var/injectable = occupant ? 1 : 0
			var/overdosing = 0
			var/caution = 0 // To make things clear that you're coming close to an overdose
			if(crisis && !(temp.id in connected.emergency_chems))
				injectable = 0

			if(occupant && occupant.reagents)
				reagent_amount = occupant.reagents.get_reagent_amount(temp.id)
				// If they're mashing the highest concentration, they get one warning
				if(temp.overdose && reagent_amount + 10 > temp.overdose)
					caution = 1
				if(temp.overdose && reagent_amount >= temp.overdose)
					overdosing = 1

			pretty_amount = round(reagent_amount, 0.05)

			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("chemical" = temp.id), "occ_amount" = reagent_amount, "pretty_amount" = pretty_amount, "injectable" = injectable, "overdosing" = overdosing, "od_warning" = caution)))
	data["chemicals"] = chemicals
	return data

/obj/structure/machinery/sleep_console/ui_act(action, params)
	if(..())
		return
	if(usr == connected.occupant)
		return
	if(stat & (NOPOWER|BROKEN))
		return

	. = TRUE
	switch(action)
		if("chemical")
			if(!connected.occupant)
				return
			if(connected.occupant.stat == DEAD)
				to_chat(usr, SPAN_DANGER("这位患者已经死亡，请将其送往能够进行复苏的科室。"))
				return
			var/chemical = params["chemid"]
			var/amount = text2num(params["amount"])
			if(!length(chemical) || amount <= 0)
				return
			if(!(amount in connected.amounts))
				log_debug("[amount] is an invalid amount to inject in [src]!")
				return
			if(!(chemical in connected.available_chemicals))
				log_debug("[chemical] is not available to inject in [src]!")
				return
			if(connected.occupant.reagents && connected.occupant.reagents.get_reagent_amount(chemical) + amount > connected.max_chem)
				return
			if(connected.occupant.health > connected.min_health || (chemical in connected.emergency_chems))
				connected.inject_chemical(usr, chemical, amount)
			else
				to_chat(usr, SPAN_DANGER("患者伤势过重，医疗休眠舱已无法有效治疗！请采用冷冻治疗等其他方法！"))
		if("togglefilter")
			connected.toggle_filter()
		if("ejectify")
			connected.eject()
		if("auto_eject_dead_on")
			connected.auto_eject_dead = TRUE
		if("auto_eject_dead_off")
			connected.auto_eject_dead = FALSE
		else
			return FALSE
	add_fingerprint(usr)

/////////////////////////////////////////
// THE SLEEPER ITSELF
/////////////////////////////////////////

/obj/structure/machinery/medical_pod/sleeper
	name = "医疗休眠舱"
	icon_state = "sleeper"
	desc = "一张配有内置注射器、透析机和基础健康扫描仪的高级医疗床。"

	entry_timer = 2 SECONDS

	var/list/available_chemicals = list("inaprovaline", "paracetamol", "anti_toxin", "dexalin", "tricordrazine")
	var/list/upgraded_chemicals = list("inaprovaline", "tramadol", "anti_toxin", "dexalinp", "tricordrazine", "alkysine", "imidazoline")
	var/list/emergency_chems = list("inaprovaline", "paracetamol", "anti_toxin", "dexalin", "tricordrazine", "oxycodone", "bicaridine", "kelotane")
	var/list/upgraded_emergency_chems = list("inaprovaline", "tramadol", "anti_toxin", "dexalinp", "tricordrazine", "oxycodone", "bicaridine", "kelotane", "meralyne", "dermaline", "alkysine", "imidazoline")
	var/list/amounts = list(5, 10)
	var/filtering = FALSE
	var/obj/structure/machinery/sleep_console/connected
	var/min_health = 10
	var/max_chem = 40
	var/auto_eject_dead = FALSE
	var/reagent_removed_per_second = AMOUNT_PER_TIME(3, 1 SECONDS)
	var/reagent_removed_per_second_upgraded = AMOUNT_PER_TIME(8, 1 SECONDS)
	var/dialysis_started_reagent_vol = null // how many reagents the occupant had in them when we STARTED dialysis
	///is it already upgraded by research disc and do we have upgraded chemicals?
	var/upgraded = FALSE

	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.


/obj/structure/machinery/medical_pod/sleeper/Initialize()
	. = ..()
	connect_sleeper_console()

// --- MEDICAL POD PROC OVERRIDES --- \\


/obj/structure/machinery/medical_pod/sleeper/go_in(mob/M)
	. = ..()
	START_PROCESSING(SSobj, src)
	START_PROCESSING(SSobj, connected)



/obj/structure/machinery/medical_pod/sleeper/go_out()
	. = ..()
	if(filtering)
		toggle_filter()
	STOP_PROCESSING(SSobj, src)
	STOP_PROCESSING(SSobj, connected)



/obj/structure/machinery/medical_pod/sleeper/proc/connect_sleeper_console()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/sleep_console,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/sleep_console,get_step(src, WEST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/medical_pod/sleeper/Destroy()
	if(occupant)
		go_out()
	if(connected)
		connected.connected = null
		QDEL_NULL(connected)
	. = ..()

/obj/structure/machinery/medical_pod/sleeper/allow_drop()
	return FALSE

/obj/structure/machinery/medical_pod/sleeper/process(delta_time)
	if (inoperable())
		return

	if(filtering)
		for(var/datum/reagent/x in occupant.reagents.reagent_list)
			occupant.reagents.remove_reagent(x.id, reagent_removed_per_second*delta_time)

		if(!occupant.reagents.total_volume)
			playsound(src.loc, 'sound/machines/ping.ogg', 25, 1)
			visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("[src]发出提示音：透析完成！")]")
			filtering = FALSE

	if(occupant)
		if(auto_eject_dead && occupant.stat == DEAD)
			playsound(loc, 'sound/machines/buzz-sigh.ogg', 40)
			go_out()
			return

	updateUsrDialog()

/obj/structure/machinery/medical_pod/sleeper/ex_act(severity)
	if(filtering)
		toggle_filter()
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)


/obj/structure/machinery/medical_pod/sleeper/emp_act(severity)
	. = ..()
	if(filtering)
		toggle_filter()
	if(inoperable())
		return
	if(occupant)
		go_out()

/obj/structure/machinery/medical_pod/sleeper/proc/toggle_filter()
	if(!occupant)
		filtering = FALSE
		dialysis_started_reagent_vol = 0
		return
	if(filtering)
		filtering = FALSE
		dialysis_started_reagent_vol = 0
	else
		filtering = TRUE
		dialysis_started_reagent_vol = occupant.reagents.total_volume

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/medical_pod/sleeper/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

/obj/structure/machinery/medical_pod/sleeper/proc/inject_chemical(mob/living/user as mob, chemical, amount)
	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= max_chem)
			occupant.reagents.add_reagent(chemical, amount, , , user)
			var/datum/reagent/temp = GLOB.chemical_reagents_list[chemical]
			to_chat(user, SPAN_NOTICE("[occupant]的血液中现有[occupant.reagents.get_reagent_amount(chemical)]单位[temp.name]。"))
			return
	to_chat(user, SPAN_WARNING("医疗休眠舱内没有患者，或患者体内药物已过多！"))
	return


/obj/structure/machinery/medical_pod/sleeper/proc/check(mob/living/user)
	if(occupant)
		var/msg_occupant = "[occupant]"
		to_chat(user, SPAN_NOTICE("<B>患者（[msg_occupant]）状态：</B>"))
		var/t1
		switch(occupant.stat)
			if(0)
				t1 = "清醒"
			if(1)
				t1 = "昏迷"
			if(2)
				t1 = "*死亡*"
		to_chat(user, "[]\t 健康百分比：[]（[]）", (occupant.health > 50 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.health, t1)
		to_chat(user, "[]\t -核心体温：[]&deg;C（[]&deg;F）</FONT><BR>", (occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>"), occupant.bodytemperature-T0C, occupant.bodytemperature*1.8-459.67)
		to_chat(user, "[]\t -物理损伤百分比：[]", (occupant.getBruteLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getBruteLoss())
		to_chat(user, "[]\t -缺氧损伤百分比：[]", (occupant.getOxyLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getOxyLoss())
		to_chat(user, "[]\t -毒素损伤百分比：[]", (occupant.getToxLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getToxLoss())
		to_chat(user, "[]\t -烧伤程度百分比：[]", (occupant.getFireLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getFireLoss())
		to_chat(user, SPAN_NOTICE("预计患者可安全苏醒的剩余时间：（注意：此时间仅供参考）"))
		to_chat(user, SPAN_NOTICE(" \t [occupant.GetKnockOutDuration() * GLOBAL_STATUS_MULTIPLIER / (1 SECONDS)] 秒（若约为 1 至 2 秒，说明休眠舱正在使患者维持睡眠。）"))
	else
		to_chat(user, SPAN_NOTICE("舱内没有人！"))
	return


