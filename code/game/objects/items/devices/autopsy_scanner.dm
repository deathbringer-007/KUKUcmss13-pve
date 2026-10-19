
//moved these here from code/defines/obj/weapon.dm
//please preference put stuff where it's easy to find - C

/obj/item/device/autopsy_scanner
	name = "尸检扫描仪"
	desc = "用于采集伤口信息。"
	icon_state = "autopsy_scanner"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL

	var/list/datum/autopsy_data_scanner/wdata = list()
	var/list/datum/autopsy_data_scanner/chemtraces = list()
	var/target_name = null
	var/timeofdeath = null

/obj/item/device/autopsy_scanner/Initialize()
	. = ..()

	LAZYADD(GLOB.objects_of_interest, src)

/obj/item/device/autopsy_scanner/Destroy()
	. = ..()

	LAZYREMOVE(GLOB.objects_of_interest, src)

/obj/item/device/autopsy_scanner/proc/get_weapon_display_name(value)
	var/static/list/causes = list(
		"teeth marks" = "牙印",
		"EMP" = "电磁脉冲",
		"falling" = "坠落",
		"Misadventure" = "意外事故",
		"Electrocution" = "触电",
		"Electronics meltdown" = "电子设备熔毁",
		"High Body Temperature" = "体温过高",
		"Low Body Temperature" = "体温过低",
		"Explosive blast" = "爆炸冲击",
		"An unlucky pull of the trigger during Russian Roulette!" = "俄罗斯轮盘赌中的致命一枪！",
	)
	var/prefix = "Point blank shot in the mouth with "
	if(findtext(value, prefix) == 1)
		var/weapon_label = copytext(value, length(prefix) + 1)
		if(findtext(weapon_label, "a ") == 1)
			weapon_label = copytext(weapon_label, 3)
		else if(findtext(weapon_label, "an ") == 1)
			weapon_label = copytext(weapon_label, 4)
		return "用[localized_player_label(weapon_label)]向口中近距离射击"
	return causes[value] || localized_player_label(value)

/datum/autopsy_data_scanner
	var/weapon = null // this is the DEFINITE weapon type that was used
	var/list/organs_scanned = list() // this maps a number of scanned organs to the wounds to those organs with this data's weapon type
	var/organ_names = ""

/datum/autopsy_data
	var/weapon = null
	var/pretend_weapon = null
	var/damage = 0
	var/hits = 0
	var/time_inflicted = 0

/datum/autopsy_data/proc/copy()
	var/datum/autopsy_data/W = new()
	W.weapon = weapon
	W.pretend_weapon = pretend_weapon
	W.damage = damage
	W.hits = hits
	W.time_inflicted = time_inflicted
	return W

/obj/item/device/autopsy_scanner/proc/add_data(obj/limb/O)
	if(!length(O.autopsy_data) && !length(O.trace_chemicals)) return

	for(var/V in O.autopsy_data)
		var/datum/autopsy_data/W = O.autopsy_data[V]

		if(!W.pretend_weapon)
			/*
			// the more hits, the more likely it is that we get the right weapon type
			if(prob(50 + W.hits * 10 + W.damage))
			*/

			// Buffing this stuff up for now!
			W.pretend_weapon = W.weapon

		var/datum/autopsy_data_scanner/D = wdata[V]
		if(!D)
			D = new()
			D.weapon = W.weapon
			wdata[V] = D

		if(!D.organs_scanned[O.name])
			if(D.organ_names == "")
				D.organ_names = localized_player_label(O.display_name)
			else
				D.organ_names += "、[O.display_name]"

		qdel(D.organs_scanned[O.name])
		D.organs_scanned[O.name] = W.copy()

	for(var/V in O.trace_chemicals)
		if(O.trace_chemicals[V] > 0 && !chemtraces.Find(V))
			chemtraces += V

/obj/item/device/autopsy_scanner/verb/print_data()
	set category = "物品"
	set src in view(usr, 1)
	set name = "打印数据"
	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		to_chat(usr, "无法执行。")
		return

	var/scan_data = ""

	if(timeofdeath)
		scan_data += "<b>死亡时间：</b>[time2text(timeofdeath, "[GLOB.game_year]年MM月DD日")] [worldtime2text("hh:mm", timeofdeath)]<br><br>"

	var/n = 1
	for(var/wdata_idx in wdata)
		var/datum/autopsy_data_scanner/D = wdata[wdata_idx]
		var/total_hits = 0
		var/total_score = 0
		var/list/weapon_chances = list() // maps weapon names to a score
		var/age = 0

		for(var/wound_idx in D.organs_scanned)
			var/datum/autopsy_data/W = D.organs_scanned[wound_idx]
			total_hits += W.hits

			var/wname = W.pretend_weapon

			if(weapon_chances[wname])
				weapon_chances[wname] += W.damage
			else
				weapon_chances[wname] = max(W.damage, 1)
			total_score+=W.damage


			var/wound_age = W.time_inflicted
			age = max(age, wound_age)

		var/damage_desc

		var/damaging_weapon = (total_score != 0)

		// total score happens to be the total damage
		switch(total_score)
			if(0)
				damage_desc = "未知"
			if(1 to 5)
				damage_desc = "<font color='green'>微不足道</font>"
			if(5 to 15)
				damage_desc = "<font color='green'>轻度</font>"
			if(15 to 30)
				damage_desc = "<font color='orange'>中度</font>"
			if(30 to 1000)
				damage_desc = "<font color='red'>重度</font>"

		if(!total_score) total_score = length(D.organs_scanned)

		scan_data += "<b>武器编号 [n]</b><br>"
		if(damaging_weapon)
			scan_data += "严重程度：[damage_desc]<br>"
			scan_data += "该武器命中次数：[total_hits]<br>"
		scan_data += "大致受伤时间：[time2text(age, "[GLOB.game_year]年MM月DD日")] [worldtime2text("hh:mm", age)]<br>"
		scan_data += "受伤部位：[D.organ_names]<br>"
		scan_data += "可能的致伤武器：<br>"
		for(var/weapon_name in weapon_chances)
			scan_data += "\t[100*weapon_chances[weapon_name]/total_score]% [get_weapon_display_name(weapon_name)]<br>"

		scan_data += "<br>"

		n++

	if(length(chemtraces))
		scan_data += "<b>化学物质残留：</b><br>"
		for(var/chemID in chemtraces)
			var/datum/reagent/chemical = GLOB.chemical_reagents_list[chemID]
			scan_data += chemical ? chemical.name : chemID
			scan_data += "<br>"

	for(var/mob/O in viewers(usr))
		O.show_message(SPAN_DANGER("[src]咔咔作响，打印出一张纸。"), SHOW_MESSAGE_VISIBLE)

	sleep(10)

	var/obj/item/paper/P = new(usr.loc)
	P.name = "尸检数据（[target_name]）"
	P.info = "<tt>[scan_data]</tt>"
	P.icon_state = "paper_words"

	if(istype(usr,/mob/living/carbon))
		// place the item in the usr's hand if possible
		usr.put_in_hands(P)
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/device/autopsy_scanner/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || !M.is_mob_incapacitated())
		return

	var/table
	for(var/obj/surface in get_turf(M)) //An autopsy needs a surgery table, or a field surgery bed.
		if(surface.surgery_duration_multiplier <= SURGERY_SURFACE_MULT_ADEQUATE)
			table = TRUE
			break

	if(!table)
		to_chat(usr, "<b>这里无法进行操作，需要将[M]放到合适的手术床上。</b>")
		return

	if(target_name != M.name)
		target_name = M.name
		src.wdata = list()
		src.chemtraces = list()
		src.timeofdeath = null
		to_chat(user, SPAN_DANGER("已登记新的受检者，正在清除上一位受检者的数据。"))

	src.timeofdeath = M.timeofdeath

	var/obj/limb/S = M.get_limb(user.zone_selected)
	if(!S)
		to_chat(usr, "<b>你无法扫描这个身体部位。</b>")
		return
	if(M.incision_depths[S.name] == SURGERY_DEPTH_SURFACE)
		to_chat(usr, "<b>你必须先切开这个身体部位！</b>")
		return
	for(var/mob/O in viewers(M))
		O.show_message(SPAN_DANGER("[user.name]用[src.name]扫描[M.name]的[localized_player_label(S.display_name)]上的伤口。"), SHOW_MESSAGE_VISIBLE)

	src.add_data(S)

	return TRUE
