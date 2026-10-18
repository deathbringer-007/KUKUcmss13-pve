/*
* Health scanning of living mobs
* Uses a datum like player panels
* Tgui mostly
* can be done by a variety of sources - health scanners, body scanners, ghost verb
*/

GLOBAL_LIST_INIT(known_implants, subtypesof(/obj/item/implant))

/// vars reffing this on /mob/dead/observer, /obj/item/device/healthanalyzer, /obj/structure/machinery/cm_vending/sorted/medical, /obj/structure/machinery/body_scanconsole are called last_health_display
/datum/health_scan
	var/mob/living/target_mob
	var/detail_level = DETAIL_LEVEL_FULL
	var/ui_mode = UI_MODE_CLASSIC
	var/atom/scanner_device = FALSE

/datum/health_scan/New(mob/target)
	. = ..()
	target_mob = target

/datum/health_scan/Destroy(force, ...)
	target_mob = null
	SStgui.close_uis(src)
	return ..()

/// This is the proc for interacting with, or looking at, a mob's health display. Also contains skillchecks and the like. You may NOT call tgui interact directly, and you MUST set the detail level.
/datum/health_scan/proc/look_at(mob/user, detail = DETAIL_LEVEL_FULL, bypass_checks = FALSE, ignore_delay = TRUE, alien = FALSE, datum/tgui/ui = null, associated_equipment = FALSE)
	if(!bypass_checks)
		if(HAS_TRAIT(target_mob, TRAIT_FOREIGN_BIO) && !alien)
			to_chat(user, SPAN_WARNING("错误：检测到未知生理结构。"))
			return
		if(!(ishuman(user) || SSticker?.mode.name == "monkey"))
			to_chat(usr, SPAN_WARNING("你的动作不够灵巧，无法进行此操作！"))
			return
		if(!ignore_delay && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("你开始笨拙地尝试检查[target_mob]……"))
			var/fduration = 60
			if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DEFAULT))
				fduration = 30
			if(!do_after(user, fduration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY) || !user.Adjacent(target_mob))
				return
		if(!istype(target_mob, /mob/living/carbon) || isxeno(target_mob))
			to_chat(user, SPAN_WARNING("扫描仪无法识别这种生物的生理结构。"))
			return

	detail_level = detail
	scanner_device = associated_equipment
	tgui_interact(user, ui)

/datum/health_scan/ui_state(mob/user)
	if(isobserver(user))
		return GLOB.always_state
	else
		return GLOB.not_incapacitated_state

/datum/health_scan/tgui_interact(mob/user, datum/tgui/ui)
	if(!target_mob)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HealthScan", "健康扫描")
		ui.open()
		ui.set_autoupdate(FALSE)

/**
 * Returns TRUE if the target is either dead or appears to be dead.
 */
/datum/health_scan/proc/get_death_value(mob/target_mob)
	if(target_mob.stat == DEAD || target_mob.status_flags & FAKEDEATH)
		return TRUE
	return FALSE
/**
 * Returns the oxygen value, unless they have FAKEDEATH - in which case it will instead make up a number to return.
 */
/datum/health_scan/proc/get_oxy_value(mob/target_mob)
	if(!(target_mob.status_flags & FAKEDEATH))
		return target_mob.getOxyLoss()

	var/total_mob_damage = target_mob.getBruteLoss() + target_mob.getFireLoss() + target_mob.getToxLoss() + target_mob.getCloneLoss()

	// Fake death will make the scanner think they died of oxygen damage, thus it returns enough damage to kill minus already received damage.
	return floor(POSITIVE(200 - total_mob_damage))

/datum/health_scan/proc/get_holo_card_color(mob/living/target_mob)
	if(!ishuman(target_mob))
		return
	var/mob/living/carbon/human/human_mob = target_mob
	return human_mob.holo_card_color

/datum/health_scan/proc/get_health_value(mob/living/target_mob)
	if(!(target_mob.status_flags & FAKEDEATH))
		return target_mob.health

	return min(-100, target_mob.health)

/datum/health_scan/ui_data(mob/user, data_detail_level = null)

	//This health scan is tied to a device that can buffer multiple scans, like the HD-E or Body Scanner.
	if(scanner_device)
		if(istype(scanner_device, /obj/item/device/healthanalyzer/soul))
			var/obj/item/device/healthanalyzer/soul/analyzer = scanner_device
			if(analyzer.last_scan && !analyzer.connected_to) //least one scan in the past and the analyzer isn't supposed to fetch new info
				return analyzer.buffer_for_report[analyzer.currently_selected_last_scan]
	var/list/data = list(
		"patient" = target_mob.name,
		"dead" = get_death_value(target_mob),
		"health" = get_health_value(target_mob),
		"total_brute" = floor(target_mob.getBruteLoss()),
		"total_burn" = floor(target_mob.getFireLoss()),
		"toxin" = floor(target_mob.getToxLoss()),
		"oxy" = get_oxy_value(target_mob),
		"clone" = floor(target_mob.getCloneLoss()),
		"blood_type" = target_mob.blood_type,
		"blood_amount" = target_mob.blood_volume,
		"holocard" = get_holo_card_color(target_mob),
		"hugged" = (locate(/obj/item/alien_embryo) in target_mob),
		"ui_mode" = ui_mode,
		"time" = worldtime2text("hh:mm:ss")
	)

	var/internal_bleeding = FALSE //do they have internal bleeding anywhere

	if(!isnull(data_detail_level))
		detail_level = data_detail_level
	data["detail_level"] = detail_level

	// chems data
	data["has_unknown_chemicals"] = FALSE
	data["has_chemicals"] = 0
	var/list/chemicals_lists = list()
	if(target_mob.reagents)
		data["has_chemicals"] = length(target_mob.reagents.reagent_list)
		for(var/datum/reagent/reagent in target_mob.reagents.reagent_list)
			if(!(reagent.flags & REAGENT_SCANNABLE) && detail_level == DETAIL_LEVEL_HEALTHANALYSER)
				data["has_unknown_chemicals"] = TRUE
				continue
			chemicals_lists["[reagent.id]"] = list(
				"name" = reagent.name,
				"amount" = round(reagent.volume, 0.1),
				"od" = reagent.overdose != 0 && reagent.volume > reagent.overdose && !(reagent.flags & REAGENT_CANNOT_OVERDOSE),
				"dangerous" = reagent.overdose != 0 && reagent.volume > reagent.overdose && !(reagent.flags & REAGENT_CANNOT_OVERDOSE) || istype(reagent, /datum/reagent/toxin),
				"color" = reagent.color
			)

	data["chemicals_lists"] = chemicals_lists

	var/list/limb_data_lists = list()
	// human data
	if(ishuman(target_mob))
		var/mob/living/carbon/human/human_target_mob = target_mob

		// blood and species
		var/has_blood = TRUE
		if(human_target_mob.species.flags & NO_BLOOD)
			has_blood = FALSE
		data["has_blood"] = has_blood
		data["species"] = human_target_mob.species.group

		// permadeadness
		var/permadead = FALSE
		if(human_target_mob.is_dead())
			if(!human_target_mob.is_revivable())
				permadead = TRUE
			else if(!human_target_mob.check_tod() && !issynth(human_target_mob))
				permadead = TRUE
			if(issynth(target_mob))
				permadead = FALSE

		data["permadead"] = permadead

		//snowflake :3
		data["lung_ruptured"] = human_target_mob.is_lung_ruptured()
		data["heart_broken"] = human_target_mob.is_heart_broken()

		//shrapnel, limbs, limb damage, limb statflags, cyber limbs
		var/core_fracture_detected = FALSE
		var/unknown_implants = 0
		for(var/obj/limb/limb in human_target_mob.limbs)
			var/internal_bleeding_check = FALSE //do they have internal bleeding in this limb
			var/arterial_bleeding_check = FALSE //this should be the opposite but fix later
			for(var/datum/effects/bleeding/internal/ib in limb.bleeding_effects_list)
				internal_bleeding = TRUE
				internal_bleeding_check = TRUE
				arterial_bleeding_check = ib.has_been_bandaged //this is for showing "[Arterial Bleeding!]" in a pink colour in HealthScan.jsx
				break
			if(limb.hidden)
				unknown_implants++
			var/implant = FALSE
			if(length(limb.implants))
				for(var/I in limb.implants)
					if(is_type_in_list(I, GLOB.known_implants))
						continue
					unknown_implants++
					implant = TRUE

			var/bleeding_check = FALSE
			for(var/datum/effects/bleeding/external/E in limb.bleeding_effects_list)
				bleeding_check = TRUE
				break

			if((!limb.brute_dam && !limb.burn_dam && !(limb.status & LIMB_DESTROYED)) && !bleeding_check && !internal_bleeding_check && !(implant && detail_level >= DETAIL_LEVEL_BODYSCAN ) && !(limb.status & LIMB_UNCALIBRATED_PROSTHETIC) && !(limb.status & LIMB_BROKEN) && !(limb.status & LIMB_SPLINTED) && !(limb.status & LIMB_SPLINTED_INDESTRUCTIBLE) && !(limb.get_incision_depth()))
				continue
			var/list/core_body_parts = list("head", "chest", "groin")
			var/list/current_list = list(
				"name" = limb.display_name,
				"brute" = floor(limb.brute_dam),
				"burn" = floor(limb.burn_dam),
				"bandaged" = limb.is_bandaged(),
				"salved" = limb.is_salved(),
				"missing" = (limb.status & LIMB_DESTROYED),
				"limb_status" = null,
				"bleeding" = bleeding_check,
				"implant" = implant,
				"internal_bleeding" = internal_bleeding_check,
				"arterial_bleeding" = arterial_bleeding_check,
				"time" = worldtime2text("hh:mm:ss")
			)
			//broken-ness and splints
			var/limb_status = null
			if(limb.status & LIMB_BROKEN)
				if(detail_level == DETAIL_LEVEL_HEALTHANALYSER && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
					if(limb.name in core_body_parts) // sigh... le snowflake
						var/showmessage = FALSE
						switch(limb.name)
							if("head")
								core_fracture_detected = TRUE
								if(limb.brute_dam > 40 || human_target_mob.getBrainLoss() >= 20)
									limb_status = "Possible Fracture"
									showmessage = TRUE
							if("chest")
								core_fracture_detected = TRUE
								if(limb.brute_dam > 40 || human_target_mob.getOxyLoss() >= 50)
									limb_status = "Possible Fracture"
									showmessage = TRUE
							if("groin")
								core_fracture_detected = TRUE
								if(limb.brute_dam > 40 || human_target_mob.getToxLoss() >= 50)
									limb_status = "Possible Fracture"
									showmessage = TRUE
						if(!(!limb.brute_dam && !limb.burn_dam && !(limb.status & LIMB_DESTROYED) && !bleeding_check && !(implant && detail_level >= DETAIL_LEVEL_BODYSCAN ) && !(limb.status & LIMB_UNCALIBRATED_PROSTHETIC) && !(limb.status & LIMB_SPLINTED) && !(limb.status & LIMB_SPLINTED_INDESTRUCTIBLE)))
							showmessage = TRUE
						if(!showmessage)
							continue
					else
						limb_status = "Fracture"
				else
					limb_status = "Fracture"
			if(limb_status)
				current_list["limb_status"] = limb_status

			var/limb_splint = null

			if((limb.status & LIMB_SPLINTED))
				limb_splint = "Splinted"
			else if((limb.status & LIMB_SPLINTED_INDESTRUCTIBLE))
				limb_splint = "Nanosplinted"
			if(limb_splint)
				current_list["limb_splint"] = limb_splint

			/// for checking if limbs are robot limbs
			var/limb_type = null
			if(limb.status & LIMB_ROBOT)
				if(limb.status & LIMB_UNCALIBRATED_PROSTHETIC)
					limb_type = "Nonfunctional Cybernetic"
				else
					limb_type = "Cybernetic"
			else if(limb.status & LIMB_SYNTHSKIN)
				limb_type = "Synthskin"
			if(limb_type)
				current_list["limb_type"] = limb_type

			//checking for open incisions, but since eyes and mouths incisions are "head incisions" but not "head surgeries" gotta do some snowflake
			if(limb.name == "head")
				if(human_target_mob.active_surgeries["head"])
					current_list["open_incision"] = TRUE

				var/zone
				if(human_target_mob.active_surgeries["eyes"])
					zone = "eyes"
				if(human_target_mob.active_surgeries["mouth"])
					if(zone)
						zone = "eyes and mouth"
					else
						zone = "mouth"
				current_list["open_zone_incision"] = capitalize(zone)

			else
				current_list["open_incision"] = limb.get_incision_depth()

			limb_data_lists["[limb.name]"] = current_list

		data["limb_data_lists"] = limb_data_lists
		data["limbs_damaged"] = length(limb_data_lists)
		data["internal_bleeding"] = internal_bleeding
		data["body_temperature"] = "[round(human_target_mob.bodytemperature-T0C, 0.1)]℃ ([round(human_target_mob.bodytemperature*1.8-459.67, 0.1)]℉)" // METRIC RULES IMPERIAL DROOLS
		data["pulse"] = "[human_target_mob.get_pulse(GETPULSE_TOOL)] 次/分"
		data["implants"] = unknown_implants
		data["core_fracture"] = core_fracture_detected

		//organs
		var/damaged_organs = list()
		for(var/datum/internal_organ/organ in human_target_mob.internal_organs)
			if(!organ.damage)
				continue
			var/current_organ = list(
				"name" = localized_player_label(organ.name),
				"damage" = organ.damage,
				"status" = organ.organ_status == ORGAN_BROKEN ? "Broken" : "Bruised",
				"robotic" = organ.robotic
			)
			damaged_organs += list(current_organ)
		data["damaged_organs"] = damaged_organs

		//advice!
		var/list/advice = list()
		var/list/temp_advice = list()
		if(!permadead)
			if(human_target_mob.getBruteLoss(robotic_only = TRUE) > 20)
				advice += list(list(
					"advice" = "使用焊枪或纳米修复膏修复受损部位。",
					"icon" = "tools",
					"color" = "red" //BRI'ISH????
					))
			if(human_target_mob.getFireLoss(robotic_only = TRUE) > 20)
				advice += list(list(
					"advice" = "使用电缆卷或纳米修复膏修复烧毁的部位。",
					"icon" = "plug",
					"color" = "orange"
					))
			if(unknown_implants)
				advice += list(list(
					"advice" = "患者体内有嵌入异物，建议保持不动。",
					"icon" = "window-close",
					"color" = "red"
					))
			if(human_target_mob.stat == DEAD)
				if((human_target_mob.health + 20) > HEALTH_THRESHOLD_DEAD)
					advice += list(list(
						"advice" = "使用除颤器进行电击！",
						"icon" = "bolt",
						"color" = "yellow"
						))
				else
					if(human_target_mob.getBruteLoss(organic_only = TRUE) > 30)
						advice += list(list(
							"advice" = "使用创伤治疗包或手术缝合线修复撕裂伤。",
							"icon" = "band-aid",
							"color" = "green" //BRI'ISH????
							))
					if(human_target_mob.getFireLoss(organic_only = TRUE) > 30)
						advice += list(list(
							"advice" = "使用烧伤治疗包或合成皮肤移植剂修复烧伤部位。",
							"icon" = "band-aid",
							"color" = "orange" //BRI'ISH????
							))
					if(((human_target_mob.health + 50) < HEALTH_THRESHOLD_DEAD) && !issynth(human_target_mob))
						advice += list(list(
							"advice" = "给予一剂肾上腺素。",
							"icon" = "syringe",
							"color" = "olive"
							))
			if(!issynth(human_target_mob))
				if(human_target_mob.blood_volume <= 500 && !chemicals_lists["nutriment"])
					advice += list(list(
						"advice" = "给患者喂食，或建议患者进食。",
						"icon" = "pizza-slice",
						"color" = "white"
						))
				if(human_target_mob.getToxLoss() > 10)
					temp_advice = list(list(
						"advice" = "给予一剂迪洛文（抗毒素）。",
						"icon" = "syringe",
						"color" = "green"
						))
					if(chemicals_lists["anti_toxin"])
						if(chemicals_lists["anti_toxin"]["amount"] < 5)
							advice += temp_advice
					else
						advice += temp_advice
				if((human_target_mob.getToxLoss() > 50 || (human_target_mob.getOxyLoss() > 50 && human_target_mob.blood_volume > 400) || human_target_mob.getBrainLoss() >= 10))
					temp_advice = list(list(
						"advice" = "给予一剂佩里达酮。",
						"icon" = "syringe",
						"color" = "grey"
						))
					if(chemicals_lists["peridaxon"])
						if(chemicals_lists["peridaxon"]["amount"] < 5)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.getOxyLoss() > 50)
					temp_advice = list(list(
						"advice" = "给予一剂右氧林。",
						"icon" = "syringe",
						"color" = "blue"
						))
					if(chemicals_lists["dexalin"])
						if(chemicals_lists["dexalin"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.getFireLoss(organic_only = TRUE) > 30)
					temp_advice = list(list(
						"advice" = "给予一剂克洛坦。",
						"icon" = "syringe",
						"color" = "yellow"
						))
					if(chemicals_lists["kelotane"])
						if(chemicals_lists["kelotane"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.getBruteLoss(organic_only = TRUE) > 30)
					temp_advice = list(list(
						"advice" = "给予一剂比卡定。",
						"icon" = "syringe",
						"color" = "red"
						))
					if(chemicals_lists["bicaridine"])
						if(chemicals_lists["bicaridine"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice
				if(human_target_mob.health < 0)
					temp_advice = list(list(
						"advice" = "给予一剂因纳普罗伐林。",
						"icon" = "syringe",
						"color" = "purple"
						))
					if(chemicals_lists["inaprovaline"])
						if(chemicals_lists["inaprovaline"]["amount"] < 5)
							advice += temp_advice
					else
						advice += temp_advice
				var/has_pain = FALSE
				for(var/datum/effects/pain/P in target_mob.effects_list)
					has_pain = TRUE
					break

				if(has_pain && !chemicals_lists["paracetamol"])
					temp_advice = list(list(
						"advice" = "给予一剂曲马多。",
						"icon" = "syringe",
						"color" = "white"
						))
					if(chemicals_lists["tramadol"])
						if(chemicals_lists["tramadol"]["amount"] < 3)
							advice += temp_advice
					else
						advice += temp_advice

				if(chemicals_lists["paracetamol"])
					advice += list(list(
						"advice" = "禁止给予曲马多。",
						"icon" = "window-close",
						"color" = "red"
						))
		if(length(advice))
			data["advice"] = advice
		else
			data["advice"] = null // interstingly even if we don't set data at all, re-using UI that had this data still has it

		//diseases
		var/list/diseases = list()
		for(var/datum/disease/disease in target_mob.viruses)
			if(!disease.hidden[SCANNER] || detail_level >= DETAIL_LEVEL_FULL)
				var/current_disease = list(
					"name" = localized_player_label(disease.name),
					"form" = disease.form,
					"type" = disease.spread,
					"stage" = disease.stage,
					"max_stage" = disease.max_stages,
					"cure" = disease.cure
				)
				diseases += list(current_disease)
		if(length(diseases))
			data["diseases"] = diseases
		else
			data["diseases"] = null // interstingly even if we don't set data at all, re-using UI that had this data still has it

	data["ssd"] = null //clear the data in case we have an old input from a previous scan
	if(target_mob.getBrainLoss() >= 100 || !target_mob.has_brain())
		data["ssd"] = "患者遭受了极其严重的脑损伤。"
	else if(target_mob.has_brain() && target_mob.stat != DEAD && ishuman(target_mob))
		var/mob/living/carbon/human/target_human = target_mob
		if(!target_human.get_ai_brain())
			if(!target_mob.key)
				data["ssd"] = "未检测到灵魂。" // they ghosted
			else if(!target_mob.client)
				data["ssd"] = "检测到 SSD（离线状态）。" // SSD

	return data

/datum/health_scan/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("change_holo_card")
			if(ishuman(target_mob))
				var/mob/living/carbon/human/target_human = target_mob
				target_human.change_holo_card(ui.user)
				return TRUE
		if("change_ui_mode")
			switch(ui_mode)
				if(UI_MODE_CLASSIC)
					ui_mode = UI_MODE_MINIMAL
				if(UI_MODE_MINIMAL)
					ui_mode = UI_MODE_CLASSIC
			if(istype(scanner_device, /obj/item/device/healthanalyzer/soul))
				var/obj/item/device/healthanalyzer/soul/analyzer = scanner_device
				analyzer.last_scan["ui_mode"] = !analyzer.last_scan["ui_mode"]
				analyzer.tgui_interact(ui.user)
			return TRUE
		if("previous_scan")
			if(ishuman(target_mob))
				//var/mob/living/carbon/human/target_human = target_mob
				if(istype(scanner_device, /obj/item/device/healthanalyzer/soul))
					var/obj/item/device/healthanalyzer/soul/analyzer = scanner_device
					analyzer.currently_selected_last_scan = clamp(analyzer.currently_selected_last_scan - 1, 1,analyzer.buffer_for_report.len)
					analyzer.tgui_interact(ui.user)
					return TRUE
				else
					to_chat(ui.user, "此设备不支持此操作。")
		if("next_scan")
			if(istype(scanner_device, /obj/item/device/healthanalyzer/soul))
				var/obj/item/device/healthanalyzer/soul/analyzer = scanner_device
				analyzer.currently_selected_last_scan = clamp(analyzer.currently_selected_last_scan + 1, 1,analyzer.buffer_for_report.len)
				analyzer.tgui_interact(ui.user)
				return TRUE
			else
				to_chat(ui.user, "此设备不支持此操作。")
		if("print_scan")
			if(istype(scanner_device, /obj/item/device/healthanalyzer/soul))
				var/obj/item/device/healthanalyzer/soul/analyzer = scanner_device
				analyzer.print_report(ui.user)
				return TRUE
			else if (istype(scanner_device, /obj/structure/machinery.body_scanconsole))
				var/obj/structure/machinery/body_scanconsole/analyzer = scanner_device
				analyzer.print_report(ui.user)
				return TRUE
			else
				to_chat(ui.user, "此设备不支持此操作。")
		if("clear_scans")
			if(istype(scanner_device, /obj/item/device/healthanalyzer/soul))
				var/obj/item/device/healthanalyzer/soul/analyzer = scanner_device
				analyzer.buffer_for_report.Cut(0,analyzer.buffer_for_report.len-1)
				analyzer.tgui_interact(ui.user)
				playsound(analyzer.loc, 'sound/machines/buzz-sigh.ogg', 5, 0)
				return TRUE
			else
				to_chat(ui.user, "此设备不支持此操作。")

/// legacy proc for to_chat messages on health analysers
/mob/living/proc/health_scan(mob/living/carbon/human/user, ignore_delay = FALSE, show_limb_damage = TRUE, show_browser = TRUE, alien = FALSE, do_checks = TRUE) // ahem. FUCK WHOEVER CODED THIS SHIT AS NUMBERS AND NOT DEFINES.
	if(do_checks)
		if((user.getBrainLoss() >= 60) && prob(50))
			to_chat(user, SPAN_WARNING("你试图分析地板的生命体征！"))
			for(var/mob/O in viewers(src, null))
				O.show_message(SPAN_WARNING("[user]分析了地板的生命体征！"), 1)
			user.show_message(SPAN_NOTICE("地板的健康分析结果：\n\t 总体状态：健康"), 1)
			user.show_message(SPAN_NOTICE("\t 伤害数值：[0]-[0]-[0]-[0]"), 1)
			user.show_message(SPAN_NOTICE("图例：缺氧／毒素／烧伤／物理损伤"), 1)
			user.show_message(SPAN_NOTICE("体温：???"), 1)
			return
		if(HAS_TRAIT(src, TRAIT_FOREIGN_BIO) && !alien)
			to_chat(user, SPAN_WARNING("错误：检测到未知生理结构。"))
			return
		if(!(ishuman(user) || SSticker?.mode.name == "monkey"))
			to_chat(usr, SPAN_WARNING("你的动作不够灵巧，无法进行此操作！"))
			return
		if(!ignore_delay && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("你开始笨拙地尝试检查[src]……"))
			var/fduration = 60
			if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DEFAULT))
				fduration = 30
			if(!do_after(user, fduration, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY) || !user.Adjacent(src))
				return
		if(isxeno(src))
			to_chat(user, SPAN_WARNING("无法识别[src]的生理结构。"))
			return
		// Doesn't work on non-humans
		if(!istype(src, /mob/living/carbon))
			user.show_message("\n健康分析结果：错误\n\t 总体状态：错误")
			user.show_message("\t类型：[SET_CLASS("缺氧", INTERFACE_BLUE)]-[SET_CLASS("毒素", INTERFACE_GREEN)]-[SET_CLASS("烧伤", INTERFACE_ORANGE)]-[SET_CLASS("物理损伤", INTERFACE_RED)]", 1)
			user.show_message("\t伤害：[SET_CLASS("?", INTERFACE_BLUE)] - [SET_CLASS("?", INTERFACE_GREEN)] - [SET_CLASS("?", INTERFACE_ORANGE)] - [SET_CLASS("?", INTERFACE_RED)]")
			user.show_message(SPAN_NOTICE("体温：[src.bodytemperature-T0C]&deg;C（[src.bodytemperature*1.8-459.67]&deg;F）"), 1)
			user.show_message(SPAN_DANGER("<b>警告：血量读取错误：--% --cl。血型：错误"))
			user.show_message(SPAN_NOTICE("患者脉搏：[SET_CLASS("-- 次/分", INTERFACE_RED)]"))
			return

	var/dat = ""
	// Calculate damage amounts
	var/fake_oxy = max(rand(1,40), src.getOxyLoss(), (300 - (src.getToxLoss() + src.getFireLoss() + src.getBruteLoss())))
	var/OX = src.getOxyLoss() > 50 ? "<b>[src.getOxyLoss()]</b>" : src.getOxyLoss()
	var/TX = src.getToxLoss() > 50 ? "<b>[src.getToxLoss()]</b>" : src.getToxLoss()
	var/BU = src.getFireLoss() > 50 ? "<b>[src.getFireLoss()]</b>" : src.getFireLoss()
	var/BR = src.getBruteLoss() > 50 ? "<b>[src.getBruteLoss()]</b>" : src.getBruteLoss()

	// Show overall
	if(src.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? "<b>[fake_oxy]</b>" : fake_oxy
		dat += "\n[src]的健康分析结果：\n\t总体状态：<b>死亡</b>\n"
	else
		dat += "\n[src]的健康分析结果：\n\t总体状态：[src.stat > 1 ? "<b>死亡</b>" : "<b>健康度 [src.health - src.halloss]%"]</b>\n"
	dat += "\t类型：[SET_CLASS("缺氧", INTERFACE_BLUE)]-[SET_CLASS("毒素", INTERFACE_GREEN)]-[SET_CLASS("烧伤", INTERFACE_ORANGE)]-[SET_CLASS("物理损伤", INTERFACE_RED)]\n"
	dat += "\t伤害：\t[SET_CLASS(OX, INTERFACE_BLUE)] - [SET_CLASS(TX, INTERFACE_GREEN)] - [SET_CLASS(BU, INTERFACE_ORANGE)] - [SET_CLASS(BR, INTERFACE_RED)]\n"
	dat += "\t未处理：{B}=烧伤，{T}=创伤，{F}=骨折\n"

	var/unrevivable = 0

	// Show specific limb damage
	if(istype(src, /mob/living/carbon/human) && show_limb_damage)
		var/mob/living/carbon/human/H = src
		for(var/obj/limb/org in H.limbs)
			var/brute_treated = TRUE
			var/burn_treated = TRUE
			var/open_incision = org.get_incision_depth() ? " <span class='scanner'>手术切口未闭合</span>" : ""

			if((org.brute_dam > 0 && !org.is_bandaged()) || open_incision)
				brute_treated = FALSE
			if(org.burn_dam > 0 && !org.is_salved())
				burn_treated = FALSE
			if(org.status & LIMB_DESTROYED)
				dat += "\t\t [capitalize(org.display_name)]：<span class='scannerb'>缺失！</span>\n"
				continue

			var/bleeding_check = FALSE
			for(var/datum/effects/bleeding/external/E in org.bleeding_effects_list)
				bleeding_check = TRUE
				break
			var/show_limb = (org.burn_dam > 0 || org.brute_dam > 0 || (org.status & LIMB_SPLINTED) || open_incision || bleeding_check)

			var/org_name = "[capitalize(org.display_name)]"
			if(org.status & LIMB_ROBOT)
				if(org.status & LIMB_UNCALIBRATED_PROSTHETIC)
					org_name += "（机械义肢失效）]"
					show_limb = TRUE
				else
					org_name += "（机械义肢）"
			else if(org.status & LIMB_SYNTHSKIN)
				org_name += "（合成皮肤）"

			var/burn_info = org.burn_dam > 0 ? "<span class='scannerburnb'> [floor(org.burn_dam)]</span>" : "<span class='scannerburn'>0</span>"
			burn_info += "[burn_treated ? "" : "{B}"]"
			var/brute_info =  org.brute_dam > 0 ? "<span class='scannerb'> [floor(org.brute_dam)]</span>" : "<span class='scanner'>0</span>"
			brute_info += "[brute_treated ? "" : "{T}"]"
			var/fracture_info = ""
			if(org.status & LIMB_BROKEN)
				fracture_info = "{F}"
				show_limb = 1

			var/org_bleed = ""
			if(bleeding_check)
				org_bleed = SPAN_SCANNERB("（出血）")

			var/org_advice = ""
			if(do_checks && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
				switch(org.name)
					if("head")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getBrainLoss() >= 20)
							org_advice = " 疑似颅骨骨折。"
							show_limb = 1
					if("chest")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getOxyLoss() > 50)
							org_advice = " 疑似胸部骨折。"
							show_limb = 1
					if("groin")
						fracture_info = ""
						if(org.brute_dam > 40 || src.getToxLoss() > 50)
							org_advice = " 疑似骨盆骨折。"
							show_limb = 1
			if(show_limb)
				dat += "\t\t [org_name]: \t [burn_info] - [brute_info] [fracture_info][org_bleed][open_incision][org_advice]"
				if(org.status & LIMB_SPLINTED_INDESTRUCTIBLE)
					dat += "（纳米夹板固定）"
				else if(org.status & LIMB_SPLINTED)
					dat += "（夹板固定）"
				dat += "\n"

	// Show red messages - broken bokes, etc
	if (src.getCloneLoss())
		dat += "\t<span class='scanner'> *患者似乎存在克隆缺陷。</span>\n"
	for(var/datum/disease/D in src.viruses)
		if(!D.hidden[SCANNER])
			dat += "\t<span class='scannerb'> *警告：检测到[D.form]</span><span class='scanner'>\n名称：[localized_player_label(D.name)]。\n传播方式：[D.spread]。\n阶段：[D.stage]/[D.max_stages]。\n可能的疗法：[D.cure]</span>\n"
	if (src.getBrainLoss() >= 100 || !src.has_brain())
		dat += "\t<span class='scanner'> *患者遭受了极其严重的<b>脑损伤</b></span>。\n"

	if(src.has_brain() && src.stat != DEAD && ishuman(src))
		if(!src.key)
			dat += SPAN_WARNING("\t未检测到灵魂。\n") // they ghosted
		else if(!src.client)
			dat += SPAN_WARNING("\t检测到 SSD（离线状态）。\n") // SSD

	var/internal_bleed_detected = FALSE
	var/embedded_item_detected = FALSE
	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if(length(H.embedded_items) > 0)
			embedded_item_detected = TRUE

		var/core_fracture = 0
		for(var/X in H.limbs)
			var/obj/limb/e = X
			for(var/datum/effects/bleeding/internal/I in e.bleeding_effects_list)
				internal_bleed_detected = TRUE
				break
			if(e.status & LIMB_BROKEN)
				if(!((e.name == "l_arm") || (e.name == "r_arm") || (e.name == "l_leg") || (e.name == "r_leg") || (e.name == "l_hand") || (e.name == "r_hand") || (e.name == "l_foot") || (e.name == "r_foot")))
					core_fracture = 1
		if(core_fracture)
			dat += "\t[SPAN_SCANNER("*检测到<b>骨折</b>，需要高级扫描仪确定位置。")]\n"
		if(internal_bleed_detected)
			dat += "\t[SPAN_SCANNER("*检测到<b>内出血</b>，需要高级扫描仪确定位置。")]\n"
		if(embedded_item_detected)
			dat += "\t[SPAN_SCANNER("*检测到<b>嵌入异物</b>，需要高级扫描仪确定位置。")]\n"

	var/reagents_in_body[0] // yes i know -spookydonut
	if(istype(src, /mob/living/carbon))
		// Show helpful reagents
		if(src.reagents && (src.reagents.total_volume > 0))
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in src.reagents.reagent_list)
				var/datum/reagent/R = A
				reagents_in_body["[R.id]"] = R.volume
				if(R.flags & REAGENT_SCANNABLE)
					reagentdata["[R.id]"] = "[R.overdose != 0 && R.volume > R.overdose && !(R.flags & REAGENT_CANNOT_OVERDOSE) ? SPAN_WARNING("<b>过量：</b>") : ""] <font color='#9773C4'><b>[round(R.volume, 1)]u [R.name]</b></font>"
				else
					unknown++
			if(length(reagentdata))
				dat += "\n\t有益试剂：\n"
				for(var/d in reagentdata)
					dat += "\t\t [reagentdata[d]]\n"
			if(unknown)
				dat += "\t<span class='scanner'> 警告：患者血液中检测到未知物质。</span>\n"

	// Show body temp
	dat += "\n\t体温：[src.bodytemperature-T0C]&deg;C（[src.bodytemperature*1.8-459.67]&deg;F）\n"

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		// Show blood level
		var/blood_volume = BLOOD_VOLUME_NORMAL
		if(!(H.species && H.species.flags & NO_BLOOD))
			blood_volume = floor(H.blood_volume)

			var/blood_percent =  blood_volume / 560
			var/blood_type = H.blood_type
			blood_percent *= 100
			if(blood_volume <= 500 && blood_volume > 336)
				dat += "\t<span class='scanner'> <b>警告：血量偏低：[blood_percent]% [blood_volume]cl。</span> [SET_CLASS("血型：[blood_type]", INTERFACE_BLUE)]\n"
			else if(blood_volume <= 336)
				dat += "\t<span class='scanner'> <b>警告：血量严重不足：[blood_percent]% [blood_volume]cl。</span> [SET_CLASS("血型：[blood_type]", INTERFACE_BLUE)]\n"
			else
				dat += "\t血量正常：[blood_percent]% [blood_volume]cl。血型：[blood_type]\n"
		// Show pulse
		dat += "\t脉搏：<span class='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? INTERFACE_RED : ""]'>[H.get_pulse(GETPULSE_TOOL)] 次/分。</span>\n"
		if((H.stat == DEAD && !H.client))
			unrevivable = 1
		if(!unrevivable)
			var/advice = ""
			if(blood_volume <= 500 && !reagents_in_body["nutriment"])
				advice += "<span class='scanner'>给患者喂食，或建议患者进食。</span>\n"
			if(H.getToxLoss() > 10 && reagents_in_body["anti_toxin"] < 5)
				advice += "<span class='scanner'>给予一剂迪洛文（抗毒素）。</span>\n"
			if((H.getToxLoss() > 50 || (H.getOxyLoss() > 50 && blood_volume > 400) || H.getBrainLoss() >= 10) && reagents_in_body["peridaxon"] < 5)
				advice += "<span class='scanner'>给予一剂佩里达酮。</span>\n"
			if(H.getOxyLoss() > 50 && reagents_in_body["dexalin"] < 5)
				advice += "<span class='scanner'>给予一剂右氧林。</span>\n"
			if(H.getFireLoss(1) > 30 && reagents_in_body["kelotane"] < 3)
				advice += "<span class='scanner'>给予一剂克洛坦。</span>\n"
			if(H.getBruteLoss(1) > 30 && reagents_in_body["bicaridine"] < 3)
				advice += "<span class='scanner'>给予一剂比卡定。</span>\n"
			if(H.health < 0 && reagents_in_body["inaprovaline"] < 5)
				advice += "<span class='scanner'>给予一剂因纳普罗伐林。</span>\n"

			var/has_pain = FALSE
			for(var/datum/effects/pain/P in H.effects_list)
				has_pain = TRUE
				break

			if(has_pain && reagents_in_body["tramadol"] < 3 && !reagents_in_body["paracetamol"])
				advice += "<span class='scanner'>给予一剂曲马多。</span>\n"
			if(advice != "")
				dat += "\t<span class='scanner'> <b>治疗建议：</b></span>\n"
				dat += advice
			advice = ""
			if(reagents_in_body["paracetamol"])
				advice += "<span class='scanner'>禁止给予曲马多。</span>\n"
			if(advice != "")
				dat += "\t<span class='scanner'> <b>用药禁忌：</b></span>\n"
				dat += advice

	if(show_browser)
		dat = replacetext(dat, "\n", "<br>")
		dat = replacetext(dat, "\t", "&emsp;")
		dat = replacetext(dat, "class='warning'", "class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scanner'", "class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scannerb'", "style='font-weight: bold;' class='[INTERFACE_RED]'")
		dat = replacetext(dat, "class='scannerburn'", "class='[INTERFACE_ORANGE]'")
		dat = replacetext(dat, "class='scannerburnb'", "style='font-weight: bold;' class='[INTERFACE_ORANGE]'")
		show_browser(user, dat, name, "handscanner", width = 500, height = 400)
	else
		user.show_message(dat, 1)

	return dat
