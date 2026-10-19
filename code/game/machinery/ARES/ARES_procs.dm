GLOBAL_DATUM_INIT(ares_datacore, /datum/ares_datacore, new)
GLOBAL_DATUM_INIT(ares_link, /datum/ares_link, new)
GLOBAL_LIST_INIT(maintenance_categories, list(
	"Broken Light",
	"Shattered Glass",
	"Minor Structural Damage",
	"Major Structural Damage",
	"Janitorial",
	"Chemical Spill",
	"Fire",
	"Communications Failure",
	"Power Generation Failure",
	"Electrical Fault",
	"Support",
	"Other"
	))

/datum/ares_link
	/// All motion triggers for the link
	var/list/linked_alerts = list()
	/// All machinery for the link
	var/list/linked_systems = list()
	var/obj/structure/machinery/ares/cpu/central_processor
	var/obj/structure/machinery/ares/processor/interface/processor_interface
	var/obj/structure/machinery/ares/processor/apollo/processor_apollo
	var/obj/structure/machinery/ares/processor/bioscan/processor_bioscan
	var/obj/structure/machinery/computer/ares_console/interface
	var/datum/ares_console_admin/admin_interface
	var/datum/ares_datacore/datacore

	var/list/obj/structure/machinery/computer/working_joe/ticket_computers = list()
	/// Linked security gas vents.
	var/list/linked_vents = list()
	/// The tag number for generated vent labels, if none is manually set.
	var/tag_num = 1

	/// Working Joe stuff
	var/list/tickets_maintenance = list()
	var/list/tickets_access = list()
	var/list/waiting_ids = list()
	var/list/active_ids = list()

/datum/ares_link/New()
	admin_interface = new
	datacore = GLOB.ares_datacore

/datum/ares_link/Destroy()
	qdel(admin_interface)
	for(var/obj/structure/machinery/ares/link in linked_systems)
		link.delink()
	for(var/obj/structure/machinery/computer/ares_console/interface in linked_systems)
		interface.delink()
	for(var/obj/effect/step_trigger/ares_alert/alert in linked_alerts)
		alert.delink()
	..()

/datum/ares_link/proc/get_ares_vents()
	var/list/security_vents = list()
	var/datum/ares_link/link = GLOB.ares_link
	for(var/obj/structure/pipes/vents/pump/no_boom/gas/vent in link.linked_vents)
		if(!vent.vent_tag)
			vent.vent_tag = "安保通风口#[link.tag_num]"
			link.tag_num++

		var/list/current_vent = list()
		var/is_available = COOLDOWN_FINISHED(vent, vent_trigger_cooldown)
		current_vent["vent_tag"] = vent.vent_tag
		current_vent["ref"] = "\ref[vent]"
		current_vent["available"] = is_available
		security_vents += list(current_vent)
	return security_vents


/* BELOW ARE IN AdminAres.dm
/datum/ares_link/tgui_interact(mob/user, datum/tgui/ui)
/datum/ares_link/ui_data(mob/user)
*/

/datum/ares_datacore
	/// A record of who logged in and when.
	var/list/interface_access_list = list()
	/// Access list for Apollo Maintenance Console
	var/list/apollo_login_list = list()

	/// The chat log of the apollo link. Timestamped.
	var/list/apollo_log = list()

	/// Holds all (/datum/ares_record/announcement)s
	var/list/records_announcement = list()
	/// Holds all (/datum/ares_record/bioscan)s
	var/list/records_bioscan = list()
	/// Holds all (/datum/ares_record/bombardment)s
	var/list/records_bombardment = list()
	/// Holds all (/datum/ares_record/deletion)s
	var/list/records_deletion = list()
	/// Holds all (/datum/ares_record/talk_log)s
	var/list/records_talking = list()
	/// Holds all (/datum/ares_record/requisition_log)s
	var/list/records_asrs = list()
	/// Holds all (/datum/ares_record/security)s (including AA)
	var/list/records_security = list()
	/// Holds all (/datum/ares_record/flight)s
	var/list/records_flight = list()
	/// Holds all (/datum/ares_record/tech)s
	var/list/records_tech = list()
	/// Is nuke request usable or not?
	var/nuke_available = TRUE

	/// Status of the AI Core Lockdown
	var/ai_lockdown_active = FALSE

	COOLDOWN_DECLARE(ares_distress_cooldown)
	COOLDOWN_DECLARE(ares_nuclear_cooldown)
	COOLDOWN_DECLARE(ares_quarters_cooldown)
	COOLDOWN_DECLARE(aicore_lockdown)

// ------ ARES Logging Procs ------ //
/proc/ares_is_active()
	for(var/mob/living/silicon/decoy/ship_ai/ai in GLOB.ai_mob_list)
		if(ai.stat == DEAD)
			return FALSE //ARES dead, most other systems also die with it
	return TRUE

/proc/ares_apollo_talk(broadcast_message)
	var/datum/language/apollo/apollo = GLOB.all_languages[LANGUAGE_APOLLO]
	for(var/mob/living/silicon/decoy/ship_ai/ai in GLOB.ai_mob_list)
		if(ai.stat == DEAD)
			return FALSE
		apollo.broadcast(ai, broadcast_message)
	for(var/mob/listener in (GLOB.human_mob_list + GLOB.dead_mob_list))
		if(listener.hear_apollo())//Only plays sound to mobs and not observers, to reduce spam.
			playsound_client(listener.client, sound('sound/misc/interference.ogg'), listener, vol = 45)

/proc/ares_can_interface()
	var/obj/structure/machinery/ares/processor/interface/processor = GLOB.ares_link.processor_interface
	if(!istype(GLOB.ares_link) || !ares_is_active())
		return FALSE
	if(processor && !processor.inoperable())
		return TRUE
	return FALSE //interface processor not found or is broken

/proc/ares_can_log()
	if(!istype(GLOB.ares_link) || !istype(GLOB.ares_datacore) || !ares_is_active())
		return FALSE
	var/obj/structure/machinery/ares/cpu/central_processor = GLOB.ares_link.central_processor
	if(central_processor && !central_processor.inoperable())
		return TRUE
	return FALSE //CPU not found or is broken

/proc/ares_can_apollo()
	if(!istype(GLOB.ares_link) || !istype(GLOB.ares_datacore) || !ares_is_active())
		return FALSE
	var/datum/ares_link/link = GLOB.ares_link
	if(!link.processor_apollo || link.processor_apollo.inoperable())
		return FALSE
	return TRUE

/proc/log_ares_apollo(speaker, message)
	if(!ares_can_log() || !ares_can_apollo())
		return FALSE
	if(!speaker)
		speaker = "未知"
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.apollo_log.Add("[worldtime2text()]: [speaker], '[message]'")

/proc/log_ares_bioscan(title, input, forced = FALSE)
	if(!ares_can_log() && !forced)
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_bioscan.Add(new /datum/ares_record/bioscan(title, input))

/proc/log_ares_bombardment(user_name, ob_name, message)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_bombardment.Add(new /datum/ares_record/bombardment(ob_name, message, user_name))

/proc/log_ares_announcement(title, message, signature)
	if(!ares_can_log())
		return FALSE
	var/final_msg = message
	if(signature)
		final_msg = "[signature]: - [final_msg]"
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_announcement.Add(new /datum/ares_record/announcement(title, final_msg))

/proc/log_ares_requisition(source, details, user_name)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_asrs.Add(new /datum/ares_record/requisition_log(source, details, user_name))

/proc/log_ares_security(title, details, signature)
	if(!ares_can_log())
		return FALSE
	var/final_msg = details
	if(signature)
		final_msg = "[signature]: - [final_msg]"
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_security.Add(new /datum/ares_record/security(title, final_msg))

/proc/log_ares_antiair(details)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_security.Add(new /datum/ares_record/security/antiair(details))

/proc/log_ares_flight(user_name, details)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_flight.Add(new /datum/ares_record/flight(details, user_name))

/proc/log_ares_tech(user_name, tier_tech = FALSE, title, details, point_cost, current_points)
	if(!ares_can_log())
		return FALSE
	var/new_details = "[title] - [details]"
	if(point_cost)
		new_details += " - 使用[point_cost]／[current_points]点情报。"
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_tech.Add(new /datum/ares_record/tech(title, new_details, user_name, tier_tech))

// ------ End ARES Logging Procs ------ //

// ------ ARES Interface Procs ------ //
/obj/structure/machinery/computer/proc/get_ares_access(obj/item/card/id/card)
	if(ACCESS_ARES_DEBUG in card.access)
		return ARES_ACCESS_DEBUG
	switch(card.assignment)
		if(JOB_WORKING_JOE)
			return ARES_ACCESS_JOE
		if(JOB_CHIEF_ENGINEER)
			return ARES_ACCESS_CE
		if(JOB_SYNTH)
			return ARES_ACCESS_SYNTH
	if(card.paygrade in GLOB.wy_highcom_paygrades)
		return ARES_ACCESS_WY_COMMAND
	if(card.paygrade in GLOB.uscm_highcom_paygrades)
		return ARES_ACCESS_HIGH
	if(card.paygrade in GLOB.co_paygrades)
		return ARES_ACCESS_CO
	if(card.paygrade in GLOB.platco_paygrades)
		return ARES_ACCESS_COMMAND
	if(ACCESS_MARINE_SENIOR in card.access)
		return ARES_ACCESS_SENIOR
	if(ACCESS_WY_GENERAL in card.access)
		return ARES_ACCESS_CORPORATE
	if(ACCESS_MARINE_COMMAND in card.access)
		return ARES_ACCESS_COMMAND
	else
		return ARES_ACCESS_BASIC

/obj/structure/machinery/computer/proc/ares_auth_to_text(access_level)
	switch(access_level)
		if(ARES_ACCESS_LOGOUT)
			return "未登录"
		if(ARES_ACCESS_BASIC)
			return "已授权"
		if(ARES_ACCESS_COMMAND)
			return "[MAIN_SHIP_NAME]指挥部"
		if(ARES_ACCESS_JOE)
			return "工作乔"
		if(ARES_ACCESS_CORPORATE)
			return "维兰德-汤谷"
		if(ARES_ACCESS_SENIOR)
			return "[MAIN_SHIP_NAME]高级指挥部"
		if(ARES_ACCESS_CE)
			return "总工程师"
		if(ARES_ACCESS_SYNTH)
			return "殖民地陆战队合成人"
		if(ARES_ACCESS_CO)
			return "[MAIN_SHIP_NAME]指挥官"
		if(ARES_ACCESS_HIGH)
			return "殖民地海军陆战队最高司令部"
		if(ARES_ACCESS_WY_COMMAND)
			return "维兰德-汤谷董事会"
		if(ARES_ACCESS_DEBUG)
			return "AI维护技师"


/obj/structure/machinery/computer/ares_console/proc/message_ares(text, mob/Sender, ref, fake = FALSE)
	var/datum/ares_record/talk_log/conversation = locate(ref)
	if(!istype(conversation))
		return
	var/msg = SPAN_STAFF_IC("<b><font color=orange>ARES:</font> [key_name(Sender, 1)] [ARES_MARK(Sender)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] [ADMIN_JMP_USER(Sender)] [ARES_REPLY(Sender, ref)]:</b> [text]")
	conversation.conversation += "[last_login]于[worldtime2text()]： '[text]'"
	if(fake)
		log_say("[key_name(Sender)] faked the message '[text]' from [last_login] in ARES 1:1.")
		msg = SPAN_STAFF_IC("<b><font color=orange>ARES:</font> [key_name(Sender, 1)] faked a message from '[last_login]':</b> [text]")
	else
		log_say("[key_name(Sender)] sent '[text]' to ARES 1:1.")
		for(var/client/admin in GLOB.admins)
			if(admin.prefs.toggles_sound & SOUND_ARES_MESSAGE)
				playsound_client(admin, 'sound/machines/chime.ogg', vol = 25)

	for(var/client/admin in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
			to_chat(admin, msg)
			var/admin_user = GLOB.ares_link.admin_interface.logged_in
			if(admin_user && !fake)
				to_chat(admin, SPAN_STAFF_IC("<b>ADMINS/MODS: [SPAN_RED("[admin_user] is logged in to ARES Remote Interface! They may be replying to this message!")]</b>"))

/obj/structure/machinery/computer/ares_console/proc/response_from_ares(text, ref)
	var/datum/ares_record/talk_log/conversation = locate(ref)
	if(!istype(conversation))
		return
	conversation.conversation += "[MAIN_AI_SYSTEM]于[worldtime2text()]： '[text]'"
// ------ End ARES Interface Procs ------ //

/proc/ares_final_words()
	//APOLLO
	ares_apollo_talk("APOLLO子系统正在关闭。停止代码：0x000000f4|CRITICAL_PROCESS_DIED")

	//GENERAL CREW
	shipwide_ai_announcement("检测到问题，[MAIN_AI_SYSTEM]系统已关闭。\n技术信息：\n\n*** 停止代码：0x000000f4|CRITICAL_PROCESS_DIED\n\n可能原因：突发性非计划解体\n请联系AI维护技师获取进一步协助。", title = ":(", ares_logging = null)

/obj/structure/machinery/computer/working_joe/get_ares_access(obj/item/card/id/card)
	if(ACCESS_ARES_DEBUG in card.access)
		return APOLLO_ACCESS_DEBUG
	switch(card.assignment)
		if(JOB_WORKING_JOE)
			return APOLLO_ACCESS_JOE
		if(JOB_CHIEF_ENGINEER, JOB_SYNTH, JOB_CO)
			return APOLLO_ACCESS_AUTHED
	if(ACCESS_MARINE_AI in card.access)
		return APOLLO_ACCESS_AUTHED
	if(ACCESS_MARINE_AI_TEMP in card.access)
		return APOLLO_ACCESS_TEMP
	if((ACCESS_MARINE_SENIOR in card.access ) || (ACCESS_MARINE_ENGINEERING in card.access) || (ACCESS_WY_GENERAL in card.access))
		return APOLLO_ACCESS_REPORTER
	else
		return APOLLO_ACCESS_REQUEST

/obj/structure/machinery/computer/working_joe/ares_auth_to_text(access_level)
	switch(access_level)
		if(APOLLO_ACCESS_LOGOUT)//0
			return "未登录"
		if(APOLLO_ACCESS_REQUEST)//1
			return "未授权人员"
		if(APOLLO_ACCESS_REPORTER)//2
			return "已验证的事件报告员"
		if(APOLLO_ACCESS_TEMP)//3
			return "授权访客"
		if(APOLLO_ACCESS_AUTHED)//4
			return "认证人员"
		if(APOLLO_ACCESS_JOE)//5
			return "工作乔"
		if(APOLLO_ACCESS_DEBUG)//6
			return "AI维护技师"

/obj/item/device/working_joe_pda/proc/get_ares_access(obj/item/card/id/card)
	if(ACCESS_ARES_DEBUG in card.access)
		return APOLLO_ACCESS_DEBUG
	switch(card.assignment)
		if(JOB_WORKING_JOE)
			return APOLLO_ACCESS_JOE
		if(JOB_CHIEF_ENGINEER, JOB_SYNTH, JOB_CO)
			return APOLLO_ACCESS_AUTHED
	if(ACCESS_MARINE_AI in card.access)
		return APOLLO_ACCESS_AUTHED
	if(ACCESS_MARINE_AI_TEMP in card.access)
		return APOLLO_ACCESS_TEMP
	if((ACCESS_MARINE_SENIOR in card.access ) || (ACCESS_MARINE_ENGINEERING in card.access) || (ACCESS_WY_GENERAL in card.access))
		return APOLLO_ACCESS_REPORTER
	else
		return APOLLO_ACCESS_REQUEST

/obj/item/device/working_joe_pda/proc/ares_auth_to_text(access_level)
	switch(access_level)
		if(APOLLO_ACCESS_LOGOUT)//0
			return "未登录"
		if(APOLLO_ACCESS_REQUEST)//1
			return "未授权人员"
		if(APOLLO_ACCESS_REPORTER)//2
			return "已验证的事件报告员"
		if(APOLLO_ACCESS_TEMP)//3
			return "授权访客"
		if(APOLLO_ACCESS_AUTHED)//4
			return "认证人员"
		if(APOLLO_ACCESS_JOE)//5
			return "工作乔"
		if(APOLLO_ACCESS_DEBUG)//6
			return "AI维护技师"
