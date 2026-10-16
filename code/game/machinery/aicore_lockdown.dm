/obj/structure/machinery/aicore_lockdown
	name = "AI核心封锁按钮"
	icon_state = "big_red_button_tablev"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/aicore_lockdown/ex_act(severity)
	return FALSE

/obj/structure/machinery/aicore_lockdown/attack_remote(mob/user as mob)
	return FALSE

/obj/structure/machinery/aicore_lockdown/attack_alien(mob/user as mob)
	return FALSE

/obj/structure/machinery/aicore_lockdown/attackby(obj/item/attacking_item, mob/user)
	return attack_hand(user)

/obj/structure/machinery/aicore_lockdown/attack_hand(mob/living/user)
	if(isxeno(user))
		return FALSE
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("拒绝访问"))
		flick(initial(icon_state) + "-denied", src)
		return FALSE

	if(!COOLDOWN_FINISHED(GLOB.ares_datacore, aicore_lockdown))
		to_chat(user, SPAN_BOLDWARNING("AI核心封锁程序正在冷却！将在[COOLDOWN_SECONDSLEFT(GLOB.ares_datacore, aicore_lockdown)]秒后就绪！"))
		return FALSE

	add_fingerprint(user)
	aicore_lockdown(user)

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown
	name = "ARES紧急封锁闸门"
	density = FALSE
	open_layer = 1.9
	plane = FLOOR_PLANE

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/aicore
	icon_state = "aidoor1"
	base_icon_state = "aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/aicore/white
	icon_state = "w_aidoor1"
	base_icon_state = "w_aidoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/white
	icon_state = "w_almayer_pdoor1"
	base_icon_state = "w_almayer_pdoor"

/obj/structure/machinery/door/poddoor/almayer/blended/ai_lockdown/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LOCKDOWN, PROC_REF(close))
	RegisterSignal(SSdcs, COMSIG_GLOB_AICORE_LIFT, PROC_REF(open))


/client/proc/admin_aicore_alert()
	set name = "AI Core Lockdown"
	set category = "Admin.Ship"

	if(!admin_holder ||!check_rights(R_EVENT))
		return FALSE

	var/prompt = "Are you sure you want to trigger an AI Core lockdown? This will raise to red alert, and lockdown the AI Core."

	if(GLOB.ares_datacore.ai_lockdown_active == TRUE)
		prompt = "Are you sure you want to lift the AI Core lockdown? This will lower to blue alert."

	var/choice = tgui_alert(src, prompt, "Choose.", list("Yes", "No"), 20 SECONDS)
	if(choice != "Yes")
		return FALSE

	choice = tgui_alert(src, "Do you want to use a custom announcement?", "Choose.", list("Yes", "No"), 20 SECONDS)
	if(choice == "Yes")
		var/message = tgui_input_text(src, "Please enter announcement text.", "what?")
		aicore_lockdown(usr, message, admin = TRUE)
	else
		aicore_lockdown(usr, admin = TRUE)
	return TRUE

/proc/aicore_lockdown(mob/user, message, admin = FALSE)
	if(IsAdminAdvancedProcCall())
		return PROC_BLOCKED

	var/log = "[key_name(user)] triggered AI core lockdown!"
	var/ares_log = "启动了AI核心紧急封锁。"
	var/person = user.name
	if(message)
		log = "[key_name(user)] triggered AI core emergency lockdown! (Using a custom announcement)."
	if(admin)
		log += " (Admin Triggered)."
		person = MAIN_AI_SYSTEM

	if(GLOB.ares_datacore.ai_lockdown_active)
		GLOB.ares_datacore.ai_lockdown_active = FALSE
		if(!message)
			message = "注意！\n\nAI核心紧急封锁已解除。"
		log = "[key_name(user)] lifted AI core lockdown!"
		ares_log = "解除了AI核心紧急封锁。"
		if(admin)
			log += " (Admin Triggered)."
			person = MAIN_AI_SYSTEM

		if(GLOB.security_level > SEC_LEVEL_GREEN)
			set_security_level(SEC_LEVEL_BLUE, TRUE, FALSE)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_AICORE_LIFT)
	else
		GLOB.ares_datacore.ai_lockdown_active = TRUE
		if(!message)
			message = "注意！\n\n核心安全警报。\n\nAI核心已封锁。"
		if(GLOB.security_level < SEC_LEVEL_RED)
			set_security_level(SEC_LEVEL_RED, TRUE, FALSE)
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_AICORE_LOCKDOWN)

	COOLDOWN_START(GLOB.ares_datacore, aicore_lockdown, 2 MINUTES)
	shipwide_ai_announcement(message, MAIN_AI_SYSTEM, 'sound/effects/biohazard.ogg')
	message_admins(log)
	log_ares_security("AI核心封锁", ares_log, person)
