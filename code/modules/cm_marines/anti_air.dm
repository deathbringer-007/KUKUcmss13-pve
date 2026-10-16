GLOBAL_DATUM(almayer_aa_cannon, /obj/structure/anti_air_cannon)

/obj/structure/anti_air_cannon
	name = "IX-50 MGAD 防空炮"
	desc = "IX-50 是先进的微重力与防空系统，能够自主追踪并消灭搭载火箭推进器的威胁目标。"
	icon = 'icons/effects/128x128.dmi'
	icon_state = "anti_air_cannon"
	density = TRUE
	anchored = TRUE
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
	unslashable = TRUE
	unacidable = TRUE

	// Which ship section is being protected by the AA gun
	var/protecting_section = ""
	var/is_disabled = FALSE

/obj/structure/anti_air_cannon/New()
	. = ..()
	if(!GLOB.almayer_aa_cannon)
		GLOB.almayer_aa_cannon = src

/obj/structure/anti_air_cannon/Destroy()
	. = ..()
	if(GLOB.almayer_aa_cannon == src)
		GLOB.almayer_aa_cannon = null
		message_admins("Reference to GLOB.almayer_aa_cannon is lost!")

/obj/structure/anti_air_cannon/ex_act()
	return

/obj/structure/anti_air_cannon/bullet_act()
	return

/obj/structure/machinery/computer/aa_console
	name = "MGAD 系统控制台"
	desc = "控制防空跟踪系统的控制台。"
	icon_state = "ob_console"
	dir = WEST
	flags_atom = ON_BORDER|CONDUCT|FPRINT

	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_COMMAND)
	unacidable = TRUE
	unslashable = TRUE

/obj/structure/machinery/computer/aa_console/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_ALL

/obj/structure/machinery/computer/aa_console/ex_act()
	return

/obj/structure/machinery/computer/aa_console/bullet_act()
	return

/obj/structure/machinery/computer/aa_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AntiAirConsole", "[src.name]")
		ui.open()


/obj/structure/machinery/computer/aa_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/aa_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!allowed(user))
		return UI_CLOSE

/obj/structure/machinery/computer/aa_console/ui_static_data(mob/user)
	var/list/data = list()

	data["sections"] = list()

	for(var/section in GLOB.almayer_ship_sections)
		data["sections"] += list(list(
			"section_id" = section,
		))

	return data

/obj/structure/machinery/computer/aa_console/ui_data(mob/user)
	var/list/data = list()

	data["disabled"] = GLOB.almayer_aa_cannon.is_disabled
	data["protecting_section"] = GLOB.almayer_aa_cannon.protecting_section

	return data

/obj/structure/machinery/computer/aa_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!GLOB.almayer_aa_cannon)
		return

	switch(action)
		if("protect")
			GLOB.almayer_aa_cannon.protecting_section = params["section_id"]
			if(!(GLOB.almayer_aa_cannon.protecting_section in GLOB.almayer_ship_sections))
				GLOB.almayer_aa_cannon.protecting_section = ""
				return
			message_admins("[key_name(usr)] has set the AA to [html_encode(GLOB.almayer_aa_cannon.protecting_section)].")
			log_ares_antiair("[usr] Set AA to cover [html_encode(GLOB.almayer_aa_cannon.protecting_section)].")
			. = TRUE
		if("deactivate")
			GLOB.almayer_aa_cannon.protecting_section = ""
			message_admins("[key_name(usr)] has deactivated the AA cannon.")
			log_ares_antiair("[usr] Deactivated Anti Air systems.")
			. = TRUE

	add_fingerprint(usr)

// based on big copypasta from the orbital console
// the obvious improvement here is to port to nanoui but i'm too lazy to do that from the get go
/obj/structure/machinery/computer/aa_console/attack_hand(mob/user)
	if(..())
		return TRUE

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("你完全不知道如何使用这台控制台。"))
		return TRUE

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("你没有使用权限。"))
		return TRUE

	tgui_interact(user)
	return TRUE
