//returns TRUE if this mob has sufficient access to use this object
//returns FALSE otherwise
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access() || isRemoteControlling(M))
		return TRUE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.wear_id))
			return TRUE
		return check_yautja_access(H)
	if(istype(M, /mob/living/carbon/xenomorph))
		var/mob/living/carbon/C = M
		if(check_access(C.get_active_hand()))
			return TRUE
		return FALSE

/obj/proc/check_yautja_access(mob/living/carbon/human/yautja)
	if(!istype(yautja))
		return FALSE
	var/obj/item/clothing/gloves/yautja/hunter/bracer = yautja.gloves
	if(!istype(bracer) || !bracer.embedded_id || !check_access(bracer.embedded_id))
		return FALSE
	return TRUE

/obj/item/proc/GetAccess() return list()

/obj/item/proc/GetID() return

/obj/proc/text2access(access_text)
	. = list()
	if(!access_text)
		return
	var/list/split = splittext(access_text,";")
	for(var/x in split)
		var/n = text2num(x)
		if(n)
			. += n

/obj/proc/gen_access()
	if(req_access_txt)
		req_access = list()
		for(var/a in text2access(req_access_txt))
			req_access += a
		req_access_txt = null
	if(!req_access)
		req_access = list()

	if(req_one_access_txt)
		req_one_access = list()
		for(var/a in text2access(req_one_access_txt))
			req_one_access += a
		req_one_access_txt = null
	if(!req_one_access)
		req_one_access = list()

/obj/proc/check_access(obj/item/I)
	//These generations have been moved out of /obj/New() because they were slowing down the creation of objects that never even used the access system.
	gen_access()
	if(!islist(req_access)) return 1//something's very wrong
	var/L[] = req_access
	if(!length(L) && !LAZYLEN(req_one_access)) return 1//no requirements
	if(!I) return

	var/list/A = I.GetAccess()
	for(var/i in req_access)
		if(!(i in A))
			return FALSE//doesn't have this access

	if(LAZYLEN(req_one_access))
		for(var/i in req_one_access)
			if(i in A)
				return TRUE//has an access from the single access list
		return FALSE
	return TRUE

/obj/proc/check_access_list(L[])
	gen_access()
	if(!req_access  && !req_one_access) return 1
	if(!islist(req_access)) return 1
	if(!length(req_access) && !islist(req_one_access))
		return TRUE
	if(!length(req_access) && !LAZYLEN(req_one_access)) return 1
	if(!islist(L)) return
	var/i
	for(i in req_access)
		if(!(i in L)) return //doesn't have this access
	if(LAZYLEN(req_one_access))
		for(i in req_one_access)
			if(i in L) return 1//has an access from the single access list
		return
	return 1


/proc/get_access(access_list = ACCESS_LIST_GLOBAL)
	switch(access_list)
		if(ACCESS_LIST_GLOBAL)
			return list(ACCESS_ILLEGAL_PIRATE) + get_access(ACCESS_LIST_MARINE_ALL) + get_access(ACCESS_LIST_WY_ALL) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_CLF_ALL) + get_access(ACCESS_LIST_UPP_ALL)
		if(ACCESS_LIST_MARINE_MAIN)
			return list(
				ACCESS_MARINE_SENIOR,
				ACCESS_MARINE_DATABASE,
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_CMP,
				ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY,
				ACCESS_MARINE_CMO,
				ACCESS_MARINE_MEDBAY,
				ACCESS_MARINE_CHEMISTRY,
				ACCESS_MARINE_MORGUE,
				ACCESS_MARINE_RESEARCH,
				ACCESS_MARINE_CE,
				ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MAINT,
				ACCESS_MARINE_OT,
				ACCESS_MARINE_RO,
				ACCESS_MARINE_CARGO,
				ACCESS_MARINE_PREP,
				ACCESS_MARINE_MEDPREP,
				ACCESS_MARINE_ENGPREP,
				ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER,
				ACCESS_MARINE_SPECPREP,
				ACCESS_MARINE_TL_PREP,
				ACCESS_MARINE_ALPHA,
				ACCESS_MARINE_BRAVO,
				ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA,
				ACCESS_MARINE_PILOT,
				ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_SEA,
				ACCESS_MARINE_KITCHEN,
				ACCESS_MARINE_SYNTH,
				ACCESS_MARINE_ASO,
				ACCESS_MARINE_CHAPLAIN,
				ACCESS_PRESS,
			)

		if(ACCESS_LIST_MARINE_ALL)
			return list(
				ACCESS_MARINE_CO,
				ACCESS_MARINE_AI,
				ACCESS_MARINE_AI_TEMP,
			) + get_access(ACCESS_LIST_MARINE_MAIN)

		if(ACCESS_LIST_EMERGENCY_RESPONSE)
			return list(
				ACCESS_MARINE_MAINT,
				ACCESS_MARINE_MEDBAY,
				ACCESS_MARINE_KITCHEN,
				ACCESS_PRESS,
			)

		if(ACCESS_LIST_UA)
			return get_access(ACCESS_LIST_MARINE_MAIN) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_MARINE_LIAISON)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_FLIGHT,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_RESEARCH,
				ACCESS_MARINE_MEDBAY,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_COLONIAL_ALL)
			return list(
				ACCESS_CIVILIAN_PUBLIC,
				ACCESS_CIVILIAN_RESEARCH,
				ACCESS_CIVILIAN_ENGINEERING,
				ACCESS_CIVILIAN_LOGISTICS,
				ACCESS_CIVILIAN_BRIG,
				ACCESS_CIVILIAN_MEDBAY,
				ACCESS_CIVILIAN_COMMAND,
			)

		if(ACCESS_LIST_CIVIL_LIAISON)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_DELIVERY)
			return list(
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_CARGO,
				ACCESS_CIVILIAN_PUBLIC,
				ACCESS_CIVILIAN_RESEARCH,
				ACCESS_CIVILIAN_ENGINEERING,
				ACCESS_CIVILIAN_LOGISTICS,
			)


		if(ACCESS_LIST_WY_ALL)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
				ACCESS_WY_SECURITY,
				ACCESS_WY_ENGINEERING,
				ACCESS_WY_FLIGHT,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
				ACCESS_WY_PMC,
				ACCESS_WY_PMC_TL,
				ACCESS_WY_ARMORY,
				ACCESS_WY_SECRETS,
				ACCESS_WY_DATABASE,
				ACCESS_WY_LEADERSHIP,
				ACCESS_WY_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_WY_BASE)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
			)

		if(ACCESS_LIST_WY_SENIOR)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
				ACCESS_WY_SECURITY,
				ACCESS_WY_ENGINEERING,
				ACCESS_WY_FLIGHT,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
				ACCESS_WY_PMC,
				ACCESS_WY_PMC_TL,
				ACCESS_WY_ARMORY,
				ACCESS_WY_DATABASE,
				ACCESS_WY_LEADERSHIP,
				ACCESS_WY_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_WY_GOON)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
				ACCESS_WY_SECURITY,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_ARMORY,
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

		if(ACCESS_LIST_WY_PMC)
			return list(
				ACCESS_WY_PMC,
				ACCESS_WY_ENGINEERING,
				ACCESS_WY_FLIGHT,
			) + get_access(ACCESS_LIST_WY_GOON)

		if(ACCESS_LIST_CLF_ALL)
			return list(
				ACCESS_CLF_SECURITY,
				ACCESS_CLF_ARMORY,
				ACCESS_CLF_LEADERSHIP,
				ACCESS_CLF_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_CLF_BASE)

		if(ACCESS_LIST_CLF_BASE)
			return list(
				ACCESS_CLF_GENERAL,
				ACCESS_CLF_MEDICAL,
				ACCESS_CLF_ENGINEERING,
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

		if(ACCESS_LIST_UPP_ALL)
			return list(
				ACCESS_UPP_GENERAL,
				ACCESS_UPP_MEDICAL,
				ACCESS_UPP_ENGINEERING,
				ACCESS_UPP_SECURITY,
				ACCESS_UPP_ARMORY,
				ACCESS_UPP_FLIGHT,
				ACCESS_UPP_RESEARCH,
				ACCESS_UPP_COMMANDO,
				ACCESS_UPP_LEADERSHIP,
				ACCESS_UPP_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

		if(ACCESS_LIST_UPP_PLATOON)
			return list(
				ACCESS_UPP_GENERAL,
				ACCESS_UPP_MEDICAL,
				ACCESS_UPP_FLIGHT,
				ACCESS_UPP_LEADERSHIP,
				ACCESS_UPP_SENIOR_LEAD,
				ACCESS_UPP_MEDPREP,
				ACCESS_UPP_TLPREP,
				ACCESS_UPP_MACHINEGUN
			)

		if(ACCESS_LIST_TWE_ALL)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_TWE_GENERAL,
				ACCESS_TWE_MEDICAL,
				ACCESS_TWE_ENGINEERING,
				ACCESS_TWE_SECURITY,
				ACCESS_TWE_ARMORY,
				ACCESS_TWE_FLIGHT,
				ACCESS_TWE_RESEARCH,
				ACCESS_TWE_COMMANDO,
				ACCESS_TWE_LEADERSHIP,
				ACCESS_TWE_MEDPREP,
				ACCESS_TWE_ENGPREP,
				ACCESS_TWE_HEVWEAPPREP,
				ACCESS_TWE_SNIPERPREP,
				ACCESS_TWE_TLPREP
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

		if(ACCESS_LIST_TWE_TROOP)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_FLIGHT,
				ACCESS_TWE_ARMORY,
				ACCESS_TWE_COMMANDO,
				ACCESS_TWE_LEADERSHIP,
				ACCESS_TWE_MEDPREP,
				ACCESS_TWE_ENGPREP,
				ACCESS_TWE_HEVWEAPPREP,
				ACCESS_TWE_SNIPERPREP,
				ACCESS_TWE_TLPREP,
				ACCESS_TWE_SENIOR_LEAD
			)


/proc/get_region_accesses(code)
	switch(code)
		if(0)//Everything
			return get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_MARINE_MAIN)
		if(1)//Security
			return list(ACCESS_MARINE_CMP, ACCESS_MARINE_BRIG, ACCESS_MARINE_ARMORY)
		if(2)//Medbay
			return list(ACCESS_MARINE_CMO, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_MORGUE, ACCESS_MARINE_CHEMISTRY)
		if(3)//Research
			return list(ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
		if(4)//Engineering
			return list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_OT, ACCESS_MARINE_MAINT)
		if(5)//Command
			return list(
				ACCESS_MARINE_SENIOR,
				ACCESS_MARINE_DATABASE,
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_RO,
				ACCESS_MARINE_CARGO,
				ACCESS_MARINE_SEA,
				ACCESS_MARINE_SYNTH,
			)
		if(6)//Marines
			return list(
				ACCESS_MARINE_PREP,
				ACCESS_MARINE_MEDPREP,
				ACCESS_MARINE_ENGPREP,
				ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER,
				ACCESS_MARINE_SPECPREP,
				ACCESS_MARINE_TL_PREP,
				ACCESS_MARINE_KITCHEN,
			)
		if(7)//Squads
			return list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
		if(8)//Civilian
			return list(
				ACCESS_CIVILIAN_PUBLIC,
				ACCESS_CIVILIAN_RESEARCH,
				ACCESS_CIVILIAN_ENGINEERING,
				ACCESS_CIVILIAN_LOGISTICS,
				ACCESS_CIVILIAN_BRIG,
				ACCESS_CIVILIAN_MEDBAY,
				ACCESS_CIVILIAN_COMMAND,
			)

/proc/get_region_accesses_name(code)
	switch(code)
		if(0)
			return "全部"
		if(1)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]安保区" // Security
		if(2)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]医务区" // Medbay
		if(3)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]科研区" // Research
		if(4)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]工程区" // Engineering
		if(5)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]指挥区" // Command
		if(6)
			return "陆战队" // Marine prep
		if(7)
			return "小队" // Squads
		if(8)
			return "平民" // Civilian

/proc/get_access_desc(A)
	switch(A)
		if(ACCESS_MARINE_CMP)
			return "宪兵长办公室"
		if(ACCESS_MARINE_BRIG)
			return "禁闭区"
		if(ACCESS_MARINE_ARMORY)
			return "军械库"
		if(ACCESS_MARINE_CMO)
			return "首席医疗官办公室"
		if(ACCESS_MARINE_MEDBAY)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]医务区"
		if(ACCESS_MARINE_RESEARCH)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]科研区"
		if(ACCESS_MARINE_CHEMISTRY)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]化学区"
		if(ACCESS_MARINE_MORGUE)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]停尸间"
		if(ACCESS_MARINE_CE)
			return "总工程师办公室"
		if(ACCESS_MARINE_RO)
			return "后勤军官办公室"
		if(ACCESS_MARINE_ENGINEERING)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]工程区"
		if(ACCESS_MARINE_OT)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]军械工坊"
		if(ACCESS_MARINE_SENIOR)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]高级指挥区"
		if(ACCESS_MARINE_CO)
			return "指挥官住舱"
		if(ACCESS_MARINE_DATABASE)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]数据库"
		if(ACCESS_MARINE_COMMAND)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]指挥区"
		if(ACCESS_MARINE_CREWMAN)
			return "载具乘员"
		if(ACCESS_MARINE_PREP)
			return "陆战队整备区"
		if(ACCESS_MARINE_ENGPREP)
			return "陆战队小队工程"
		if(ACCESS_MARINE_MEDPREP)
			return "陆战队小队医疗"
		if(ACCESS_MARINE_SPECPREP)
			return "陆战队武器专家"
		if(ACCESS_MARINE_SMARTPREP)
			return "陆战队智能机枪手"
		if(ACCESS_MARINE_TL_PREP)
			return "陆战队战斗组长"
		if(ACCESS_MARINE_LEADER)
			return "陆战队小队长"
		if(ACCESS_MARINE_ALPHA)
			return "阿尔法小队"
		if(ACCESS_MARINE_BRAVO)
			return "布拉沃小队"
		if(ACCESS_MARINE_CHARLIE)
			return "查理小队"
		if(ACCESS_MARINE_DELTA)
			return "德尔塔小队"
		if(ACCESS_MARINE_CARGO)
			return "补给部"
		if(ACCESS_MARINE_DROPSHIP)
			return "运输艇驾驶"
		if(ACCESS_MARINE_PILOT)
			return "飞行员装备"
		if(ACCESS_MARINE_MAINT)
			return "[get_statistic_display_label(MAIN_SHIP_NAME)]维护区"
		if(ACCESS_CIVILIAN_RESEARCH)
			return "平民科研区"
		if(ACCESS_CIVILIAN_COMMAND)
			return "平民指挥区"
		if(ACCESS_CIVILIAN_MEDBAY)
			return "平民医务区"
		if(ACCESS_CIVILIAN_LOGISTICS)
			return "平民后勤区"
		if(ACCESS_CIVILIAN_ENGINEERING)
			return "平民工程区"
		if(ACCESS_CIVILIAN_BRIG)
			return "平民禁闭区"
		if(ACCESS_CIVILIAN_PUBLIC)
			return "平民"
		if(ACCESS_MARINE_SEA)
			return "资深士官顾问办公室"
		if(ACCESS_MARINE_KITCHEN)
			return "厨房"
		if(ACCESS_MARINE_SYNTH)
			return "合成人储藏室"
		if(ACCESS_MARINE_AI)
			return "AI 核心"
		if(ACCESS_MARINE_AI_TEMP)
			return "AI 访问权限"
		if(ACCESS_ARES_DEBUG)
			return "AI 调试权限"

/proc/get_region_accesses_wy(code)
	switch(code)
		if(0)//Everything
			return get_access(ACCESS_LIST_WY_ALL)
		if(1)//Corporate General
			return list(ACCESS_WY_GENERAL, ACCESS_WY_COLONIAL, ACCESS_WY_EXEC)
		if(2)//Corporate Security
			return list(ACCESS_WY_SECURITY, ACCESS_WY_ARMORY)
		if(3)//Corporate Departments
			return list(ACCESS_WY_MEDICAL, ACCESS_WY_ENGINEERING, ACCESS_WY_FLIGHT, ACCESS_WY_RESEARCH)
		if(4)//Corporate Leadership
			return list(ACCESS_WY_LEADERSHIP, ACCESS_WY_SENIOR_LEAD, ACCESS_WY_SECRETS, ACCESS_WY_DATABASE)
		if(5)//PMCs
			return list(ACCESS_WY_PMC, ACCESS_WY_PMC_TL, ACCESS_WY_ARMORY)
		if(6)//Civilian
			return get_access(ACCESS_LIST_COLONIAL_ALL)

/proc/get_region_accesses_name_wy(code)
	switch(code)
		if(0)
			return "全部"
		if(1)
			return "企业" // Security
		if(2)
			return "企业安保" // Medbay
		if(3)
			return "企业部门" // Research
		if(4)
			return "企业管理层" // Engineering
		if(5)
			return "企业私人军事承包商" // Command
		if(6)
			return "平民" // Civilian

/proc/get_weyland_access_desc(A)
	switch(A)
		if(ACCESS_WY_GENERAL)
			return "维兰德-汤谷通用权限"
		if(ACCESS_WY_COLONIAL)
			return "维兰德-汤谷殖民地"
		if(ACCESS_WY_MEDICAL)
			return "维兰德-汤谷医疗"
		if(ACCESS_WY_SECURITY)
			return "维兰德-汤谷安保"
		if(ACCESS_WY_ENGINEERING)
			return "维兰德-汤谷工程"
		if(ACCESS_WY_FLIGHT)
			return "维兰德-汤谷飞行管制"
		if(ACCESS_WY_RESEARCH)
			return "维兰德-汤谷科研"
		if(ACCESS_WY_EXEC)
			return "维兰德-汤谷行政"
		if(ACCESS_WY_PMC)
			return "维兰德-汤谷私人军事承包商"
		if(ACCESS_WY_PMC_TL)
			return "维兰德-汤谷私人军事承包商指挥"
		if(ACCESS_WY_ARMORY)
			return "维兰德-汤谷军械库"
		if(ACCESS_WY_SECRETS)
			return "维兰德-汤谷高安保区"
		if(ACCESS_WY_DATABASE)
			return "维兰德-汤谷数据库"
		if(ACCESS_WY_LEADERSHIP)
			return "维兰德-汤谷管理层"
		if(ACCESS_WY_SENIOR_LEAD)
			return "维兰德-汤谷高级管理层"
		if(ACCESS_CIVILIAN_RESEARCH)
			return "平民科研区"
		if(ACCESS_CIVILIAN_COMMAND)
			return "平民指挥区"
		if(ACCESS_CIVILIAN_MEDBAY)
			return "平民医务区"
		if(ACCESS_CIVILIAN_LOGISTICS)
			return "平民后勤区"
		if(ACCESS_CIVILIAN_ENGINEERING)
			return "平民工程区"
		if(ACCESS_CIVILIAN_BRIG)
			return "平民禁闭区"
		if(ACCESS_CIVILIAN_PUBLIC)
			return "平民"
