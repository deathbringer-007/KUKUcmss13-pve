
/// Holds all of our phone components
GLOBAL_LIST_EMPTY_TYPED(phones, /datum/component/phone)

/datum/component/phone

	/// Our phone category which sorts us into tabs in the phone menu TGUI
	var/phone_category = "Uncategorised"

	/// Color of phone displayed in the phone menu
	var/phone_color = "white"

	/// The id of our phone which shows up when we talk. Recommended to make unique. Do not include "(#:".
	var/phone_id = "Telephone"
	var/localized_phone_id
	var/localized_phone_label

	/// Our phone icon that is displayed in the phone menu TGUI
	var/phone_icon

	/// Our connected handset
	var/obj/item/handset/phone_handset

	/// What actually holds our phone, defaults to parent but may be set differently
	var/atom/holder

	/// A phone we are calling or has called us
	var/datum/component/phone/calling_phone

	/// Whether or not the phone is receiving calls or not. Varies between on/off or forcibly on/off.
	var/do_not_disturb = PHONE_DND_OFF

	/// The Phone_ID of the last person to call this telephone.
	var/last_caller
	var/localized_last_caller

	/// The ID of our timer to cancel an attempted call and "go to voicemail"
	var/timeout_timer_id

	/// The time it takes for our timer to end to cancel an attempted call and "go to voicemail"
	var/timeout_duration = 30 SECONDS

	/// Networks that this phone can take calls from
	var/list/networks_receive = list()

	/// Networks that this phone can call
	var/list/networks_transmit = list()

	/// The looping ringing sound when the phone is called
	var/datum/looping_sound/phone_ringing/ringing_loop

	/// Whether the phone is able to be called or not
	var/enabled = TRUE

	///If the phone is activated by COMSIG_PHONE_BUTTON_USE or not. And if true Will only allow COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND if recieving a call.
	var/overlay_interactable = FALSE
/datum/component/phone/Initialize(phone_category, phone_color, phone_id, phone_icon, do_not_disturb, list/networks_receive, list/networks_transmit, holder, overlay_interactable)
	. = ..()

	if(!istype(parent, /atom))
		return COMPONENT_INCOMPATIBLE

	if(!handle_initial_variables(arglist(args)))
		return COMPONENT_INCOMPATIBLE

	GLOB.phones += src

/datum/component/phone/Destroy()
	if(phone_handset)
		if(!phone_handset.loc)
			UnregisterSignal(phone_handset, COMSIG_PARENT_PREQDELETED)
			qdel(phone_handset)
		else
			phone_handset.phone_component = null
			phone_handset = null

	networks_receive = null
	networks_transmit = null
	QDEL_NULL(ringing_loop)

	GLOB.phones -= src
	SStgui.close_uis(src)

	reset_call()
	return ..()

/// Handles all of our variables usually set in Initialize(), needs to be a proc so virtual phones don't get incorrect signals or a handset
/datum/component/phone/proc/handle_initial_variables(phone_category, phone_color, phone_id, phone_icon, do_not_disturb, list/networks_receive, list/networks_transmit, holder, overlay_interactable)
	src.phone_category = isnull(phone_category) ? src.phone_category : phone_category
	src.phone_color = isnull(phone_color) ? src.phone_color : phone_color
	src.phone_id = isnull(phone_id) ? src.phone_id : phone_id
	src.phone_icon = isnull(phone_icon) ? src.phone_icon : phone_icon
	src.do_not_disturb = isnull(do_not_disturb) ? src.do_not_disturb : do_not_disturb
	src.networks_receive = isnull(networks_receive) ? src.networks_receive : networks_receive.Copy()
	src.networks_transmit = isnull(networks_transmit) ? src.networks_transmit : networks_transmit.Copy()
	src.holder = holder ? holder : parent
	src.overlay_interactable = isnull(overlay_interactable) ? src.overlay_interactable : overlay_interactable

	//Makes sure all phone IDs are Unique... Hopefully.
	src.phone_id = force_unique_ids(phone_id, initializing=TRUE)

	phone_handset = new(null, src, src.holder)
	RegisterSignal(phone_handset, COMSIG_PARENT_PREQDELETED, PROC_REF(override_delete))

	RegisterSignal(src.holder, COMSIG_ATOM_MOB_ATTACKBY, PROC_REF(item_used_on_phone))
	if(!src.overlay_interactable)
		RegisterSignal(src.holder, COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND, PROC_REF(use_phone))
	else
		RegisterSignal(src.holder, COMSIG_ATOM_PHONE_BUTTON_USE, PROC_REF(use_phone))
	if(istype(src.holder, /obj/item))
		RegisterSignal(src.holder, COMSIG_ITEM_PICKUP, PROC_REF(holder_picked_up))
		RegisterSignal(src.holder, COMSIG_ITEM_DROPPED, PROC_REF(holder_dropped))
		enabled = FALSE

	RegisterSignal(src.holder, COMSIG_MOVABLE_FORCEMOVED, PROC_REF(holder_forcemoved))

	ringing_loop = new(src.holder)

	return TRUE

/// Handles bringing our handset back in case something tries to delete it
/datum/component/phone/proc/override_delete()
	SIGNAL_HANDLER
	recall_handset()
	return COMPONENT_ABORT_QDEL

/// Handles any attackbys on our holder so we can hang up the phone
/datum/component/phone/proc/item_used_on_phone(atom/phone, obj/item/attacking_item, mob/user)
	SIGNAL_HANDLER

	if(attacking_item == phone_handset)
		recall_handset()
		return COMPONENT_CANCEL_ATTACKBY

/// When we initially interact with the phone, whether opening the menu to call someone or picking up the phone being called
/datum/component/phone/proc/use_phone(atom/phone, mob/living/carbon/human/user, click_parameters)
	SIGNAL_HANDLER

	if(!calling_phone)
		INVOKE_ASYNC(src, PROC_REF(tgui_interact), user)

		if(enabled)
			return COMPONENT_CANCEL_HUMAN_ATTACK_HAND
		return

	if(!phone_handset)
		return

	if(phone_handset.loc)
		return

	picked_up_call(user)
	if(src.overlay_interactable)
		UnregisterSignal(src.holder, COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND)
	calling_phone.other_phone_picked_up_call()

	return COMPONENT_CANCEL_HUMAN_ATTACK_HAND

/// Handles what we want to do when we pick up a phone
/datum/component/phone/proc/picked_up_call(mob/living/carbon/human/user)
	to_chat(user, SPAN_PURPLE("[icon2html(holder, user)] 已接听来自 [get_phone_display_label(calling_phone.phone_id)] 的来电。"))
	playsound(get_turf(user), "rtb_handset")

	user.put_in_active_hand(phone_handset)
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_PICKED_UP)
	ringing_loop.stop()

/// Handles what we want to do when a phone we are calling picks up
/datum/component/phone/proc/other_phone_picked_up_call()
	if(!calling_phone)
		return

	if(!phone_handset)
		return

	if(timeout_timer_id)
		deltimer(timeout_timer_id)
		timeout_timer_id = null

	if(!ismob(phone_handset.loc))
		return

	var/mob/phone_user = phone_handset.loc
	to_chat(phone_user, SPAN_PURPLE("[icon2html(calling_phone.holder, phone_user)] [get_phone_display_label(calling_phone.phone_id)] 已接听。"))

/// Handles setting a specific phone ID and enabling the phone when the holder is picked up
/datum/component/phone/proc/holder_picked_up(obj/item/picked_up_holder, mob/user)
	SIGNAL_HANDLER

	enabled = TRUE

	if(!ishuman(user))
		phone_id = "[user]"
		localized_phone_id = phone_id
		localized_phone_label = "[user]"
		return

	var/mob/living/carbon/human/human_user = user
	if(human_user.comm_title)
		phone_id = "[human_user.comm_title] [human_user]"
	else if(human_user.job)
		phone_id = "[human_user.job] [human_user]"
	else
		phone_id = "[human_user]"

	if(human_user.assigned_squad)
		phone_id += " ([human_user.assigned_squad.name])"

	localized_phone_id = phone_id
	var/display_title = human_user.comm_title || get_phone_role_display_label(human_user.job)
	localized_phone_label = "[display_title ? "[display_title] " : ""][human_user]"
	if(human_user.assigned_squad)
		localized_phone_label += "（[get_phone_squad_display_label(human_user.assigned_squad.name)]）"

/// Handles disabling the phone when the holder is dropped
/datum/component/phone/proc/holder_dropped(obj/item/dropped_hold, mob/user)
	SIGNAL_HANDLER

	enabled = FALSE
	phone_id = "[holder]"
	localized_phone_id = phone_id
	localized_phone_label = "[holder]"

/// Tells our phone_handset that the holder has been forcemoved so the tether can be updated if need be
/datum/component/phone/proc/holder_forcemoved(atom/movable/moving_atom, atom/destination)
	SIGNAL_HANDLER

	if(!phone_handset)
		return

	phone_handset.reset_tether()

/// Gathers all phones that we can call from our phone, returns a list of those phones
/datum/component/phone/proc/get_phones()
	var/list/phone_list = list()

	for(var/possible_phone in GLOB.phones)
		var/datum/component/phone/target_phone = possible_phone
		target_phone.phone_id = force_unique_ids(target_phone.phone_id)
		if(!target_phone.phone_available())
			continue

		var/net_link = FALSE
		for(var/network in networks_transmit)
			if(network in target_phone.networks_receive)
				net_link = TRUE
				continue
		if(!net_link)
			continue

		phone_list[target_phone.phone_id] += target_phone

	return phone_list

/// Whether or not our phone is available to be called from other phones, returns TRUE if callable, otherwise FALSE. Note: this does not account for network compatability
/datum/component/phone/proc/phone_available()
	if(calling_phone)
		return FALSE

	if(!phone_handset)
		return FALSE

	if(!enabled)
		return FALSE

	if(phone_handset.loc)
		return FALSE

	if(do_not_disturb == PHONE_DND_ON)
		return FALSE

	if(do_not_disturb == PHONE_DND_FORCED)
		return FALSE

	return TRUE

/// Whether or not clicking on our phone will bring up the phone menu, returns TRUE if it will, otherwise FALSE
/datum/component/phone/proc/phone_menu_usable()
	if(calling_phone)
		return FALSE

	if(!phone_handset)
		return FALSE

	if(!enabled)
		return FALSE

	if(phone_handset.loc)
		return

	return TRUE

/// Starts calling another phone, sets up connection between the phones
/datum/component/phone/proc/call_phone(mob/user, calling_phone_id)
	var/list/phones = get_phones()
	phones -= phone_id

	if(!length(phones) || !(calling_phone_id in phones))
		to_chat(user, SPAN_PURPLE("[icon2html(holder, user)] 找不到可拨打的电话！"))
		return

	calling_phone = phones[calling_phone_id]
	if(!istype(calling_phone) || QDELETED(calling_phone))
		calling_phone = null
		CRASH("Qdelled/improper atom inside phones list! (istype returned: [istype(calling_phone)], QDELETED returned: [QDELETED(calling_phone)])")

	if(!calling_phone.phone_available())
		calling_phone = null
		return

	calling_phone.getting_call(src)

	post_call_phone(user, calling_phone_id)

/// What we do when our phone is receiving a call, called from incoming_call's call_phone()
/datum/component/phone/proc/getting_call(datum/component/phone/incoming_call)
	calling_phone = incoming_call
	last_caller = incoming_call.phone_id
	localized_last_caller = get_phone_display_label(incoming_call.phone_id)
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_RINGING)
	if(src.overlay_interactable)
		RegisterSignal(src.holder, COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND, PROC_REF(use_phone))
	ringing_loop.start()

/// What we do after our call is set up from call_phone()
/datum/component/phone/proc/post_call_phone(mob/user, calling_phone_id)
	to_chat(user, SPAN_PURPLE("[icon2html(holder, user)] 正在拨打 [get_phone_display_label(calling_phone_id)]……"))
	timeout_timer_id = addtimer(CALLBACK(src, PROC_REF(reset_call), TRUE), timeout_duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	playsound(get_turf(user), "rtb_handset")

	user.put_in_active_hand(phone_handset)
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_PICKED_UP)

/// Resets this phone's connection as well as anything we are connected to's connection, calls itself on any other connections
/datum/component/phone/proc/reset_call(timeout = FALSE, recursed = FALSE)
	if(timeout_timer_id)
		deltimer(timeout_timer_id)
		timeout_timer_id = null

	if(!calling_phone)
		return

	if(!recursed)
		calling_phone.reset_call(timeout, recursed = TRUE)

	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_STOPPED_RINGING)
	if(src.overlay_interactable)
		UnregisterSignal(src.holder, COMSIG_ATOM_BEFORE_HUMAN_ATTACK_HAND)
	ringing_loop?.stop()

	handle_reset_call_message(timeout, recursed)

	calling_phone = null

/// Handles any messaging we want when a call is reset
/datum/component/phone/proc/handle_reset_call_message(timeout = FALSE, recursed = FALSE)
	if(!phone_handset)
		return

	if(!ismob(phone_handset.loc))
		return

	var/mob/handset_user = phone_handset.loc
	if(recursed)
		to_chat(handset_user, SPAN_PURPLE("[icon2html(holder, handset_user)] [get_phone_display_label(calling_phone.phone_id)] 挂断了你的电话。"))
	else if(timeout)
		to_chat(handset_user, SPAN_PURPLE("[icon2html(holder, handset_user)] 你拨给 [get_phone_display_label(calling_phone.phone_id)] 的电话转入了语音信箱，你立即断开了线路。"))
	else
		to_chat(handset_user, SPAN_PURPLE("[icon2html(holder, handset_user)] 你挂断了与 [get_phone_display_label(calling_phone.phone_id)] 的通话。"))

/// Recalls our handset back to holder and calls reset_call()
/datum/component/phone/proc/recall_handset()
	if(ismob(phone_handset.loc))
		var/mob/M = phone_handset.loc
		M.drop_held_item(phone_handset)
		playsound(get_turf(M), "rtb_handset", 100, FALSE, 7)

	phone_handset.moveToNullspace()
	reset_call()

	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_HUNG_UP)

/// Handles any messages that our handset 'hears' and passes to us. Passes the message to this phone and any connected phone via handle_hear()
/datum/component/phone/proc/handle_speak(message, datum/language/message_language, mob/speaker, direct_talking = TRUE)
	if(message_language?.flags & SIGNLANG)
		return

	if(!calling_phone)
		return

	if(direct_talking)
		handle_hear(message, message_language, speaker, direct_talking)

		log_say("TELEPHONE: [key_name(speaker)] on Phone '[phone_id]' to '[calling_phone.phone_id]' said '[message]'")

		var/comm_paygrade = speaker.get_paygrade()

		for(var/mob/dead/observer/cycled_observer in GLOB.player_list)
			if(cycled_observer == get_user() || cycled_observer == calling_phone.get_user())
				continue

			if((cycled_observer.client) && (cycled_observer.client.prefs) && (cycled_observer.client.prefs.toggles_chat & CHAT_GHOSTRADIO))
				var/ghost_message = "<span class='purple'><span class='name'>[comm_paygrade][speaker] (<a href='byond://?src=\ref[cycled_observer];track=\ref[speaker]'>跟随</a>) </span>通过电话“[get_phone_display_label(phone_id)]”向“[get_phone_display_label(calling_phone.phone_id)]”说：<span class='body'>\"[message]\"</span></span>"
				cycled_observer.show_message(ghost_message, SHOW_MESSAGE_AUDIBLE)

	calling_phone.handle_hear(message, message_language, speaker, direct_talking)

/// Handles any messages passed from handle_speak() and serves them to the user
/datum/component/phone/proc/handle_hear(message, datum/language/message_language, mob/speaker, direct_talking)
	if(!phone_handset)
		return

	if(!calling_phone)
		return

	if(!ismob(phone_handset.loc))
		return

	var/loudness = 0
	if(phone_handset.raised)
		loudness = 3

	var/mob/hearing_mob = phone_handset.loc
	var/name_override = get_phone_display_label(calling_phone.phone_id)

	if(hearing_mob == speaker && direct_talking)
		name_override = get_phone_display_label(phone_id)

	hearing_mob.hear_radio(message, "说道", message_language, part_a = "<span class='purple'><span class='name'>", part_b = "</span><span class='message'> ", vname = name_override, speaker = speaker, command = loudness, no_paygrade = TRUE)

/// Toggles do not disturb on or off, does not handle forced or unable do_not_disturb variables
/datum/component/phone/proc/toggle_dnd(mob/user)
	switch(do_not_disturb)
		if(PHONE_DND_ON)
			do_not_disturb = PHONE_DND_OFF
			to_chat(user, SPAN_NOTICE("勿扰模式已关闭。现在可以接听来电。"))
		if(PHONE_DND_OFF)
			do_not_disturb = PHONE_DND_ON
			to_chat(user, SPAN_WARNING("勿扰模式已开启。将不再接收来电。"))
		else
			return FALSE
	return TRUE

/// Returns a mob that is using the phone or null if unable to find a user
/datum/component/phone/proc/get_user()
	return ismob(phone_handset.loc) ? phone_handset.loc : null

///Handles ensuring unique phone_id for each phone, use Inititializing if the phone isn't in GLOB.phones yet.
/datum/component/phone/proc/force_unique_ids(id_to_unique, initializing=FALSE)
	var/id = id_to_unique
	var/num_id
	if(initializing)
		num_id = 2
	else
		num_id = 1
	for(var/possible_phone in GLOB.phones) //Go through extra times to make sure.
		for(var/dupe_phone in GLOB.phones) //Safety check all phones for duplicate IDs
			var/datum/component/phone/possible_duplicate_id = dupe_phone
			if(id == possible_duplicate_id.phone_id)
				if(num_id > 1) //Account for first instance
					if(findtext(id, " (#:")) //Already a duplicate?
						id = copytext(id, 1, findtext(id, " (#:"))
					id = "[id] (#:[num_id])"
					num_id++
	return id
//TGUI section

/datum/component/phone/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(phone_menu_usable())
		return UI_INTERACTIVE

/datum/component/phone/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("call_phone")
			if(calling_phone)
				return TRUE
			call_phone(ui.user, params["phone_id"])
			return TRUE

		if("toggle_dnd")
			toggle_dnd(ui.user)
			return TRUE

/datum/component/phone/ui_data(mob/user)
	var/list/data = list()

	data["availability"] = do_not_disturb
	data["last_caller"] = last_caller
	data["last_caller_display"] = localized_last_caller || get_phone_display_label(last_caller)

	return data

/datum/component/phone/ui_static_data(mob/user)
	. = list()

	.["available_transmitters"] = get_phones() - list(phone_id)
	var/list/phones = list()
	for(var/datum/component/phone/cycled_phone as anything in GLOB.phones)
		phones += list(list(
			"phone_category" = cycled_phone.phone_category,
			"display_phone_category" = get_phone_display_label(cycled_phone.phone_category, TRUE),
			"phone_color" = cycled_phone.phone_color,
			"phone_id" = cycled_phone.phone_id,
			"display_phone_id" = get_phone_display_label(cycled_phone.phone_id),
			"phone_icon" = cycled_phone.phone_icon
		))

	.["transmitters"] = phones

/datum/component/phone/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PhoneMenu", get_phone_display_label(phone_id))
		ui.open()


// Virtual phone section

/// Virtual phone used for situations where you want to be able to use a phone without a handset
/datum/component/phone/virtual
	/// If it is a virtual phone we need a virtual user
	var/client/virtual_user

/datum/component/phone/virtual/Destroy()
	virtual_user = null

	return ..()

/datum/component/phone/virtual/handle_initial_variables(phone_category, phone_color, phone_id, phone_icon, do_not_disturb, list/networks_receive, list/networks_transmit, holder, virtual_user)
	src.phone_category = isnull(phone_category) ? src.phone_category : phone_category
	src.phone_color = isnull(phone_color) ? src.phone_color : phone_color
	src.phone_id = isnull(phone_id) ? src.phone_id : phone_id
	src.phone_icon = isnull(phone_icon) ? src.phone_icon : phone_icon
	src.do_not_disturb = isnull(do_not_disturb) ? src.do_not_disturb : do_not_disturb
	src.networks_receive = isnull(networks_receive) ? src.networks_receive : networks_receive.Copy()
	src.networks_transmit = isnull(networks_transmit) ? src.networks_transmit : networks_transmit.Copy()
	src.holder = holder ? holder : parent

	if(!virtual_user)
		return FALSE
	src.virtual_user = virtual_user

	RegisterSignal(src.holder, COMSIG_ATOM_ATTACK_HAND, PROC_REF(use_phone))

	return TRUE

/datum/component/phone/virtual/use_phone(atom/phone, mob/living/carbon/human/user, click_parameters)
	INVOKE_ASYNC(src, PROC_REF(tgui_interact), user)

/datum/component/phone/virtual/picked_up_call(mob/living/carbon/human/user)
	to_chat(user, SPAN_PURPLE("[icon2html(holder, user)] 已接听来自 [get_phone_display_label(calling_phone.phone_id)] 的来电。"))

	RegisterSignal(virtual_user.mob, COMSIG_DEAD_SPEAK, PROC_REF(handle_virtual_speak))

/datum/component/phone/virtual/other_phone_picked_up_call()
	if(!calling_phone)
		return

	if(timeout_timer_id)
		deltimer(timeout_timer_id)
		timeout_timer_id = null

	RegisterSignal(virtual_user.mob, COMSIG_DEAD_SPEAK, PROC_REF(handle_virtual_speak))
	to_chat(virtual_user, SPAN_PURPLE("[icon2html(calling_phone.holder, virtual_user)] [get_phone_display_label(calling_phone.phone_id)] 已接听。"))

/datum/component/phone/virtual/phone_available()
	if(calling_phone)
		return FALSE

	if(do_not_disturb == PHONE_DND_ON)
		return FALSE

	if(do_not_disturb == PHONE_DND_FORCED)
		return FALSE

	return TRUE

/datum/component/phone/virtual/reset_call(timeout = FALSE, recursed = FALSE)
	. = ..()
	if(!virtual_user?.mob)
		return

	UnregisterSignal(virtual_user.mob, COMSIG_DEAD_SPEAK)

/datum/component/phone/virtual/handle_reset_call_message(timeout = FALSE, recursed = FALSE)
	if(recursed)
		to_chat(virtual_user, SPAN_PURPLE("[icon2html(holder, virtual_user)] [get_phone_display_label(calling_phone.phone_id)] 挂断了你的电话。"))
	else if(timeout)
		to_chat(virtual_user, SPAN_PURPLE("[icon2html(holder, virtual_user)] 你拨给 [get_phone_display_label(calling_phone.phone_id)] 的电话转入了语音信箱，你立即断开了线路。"))
	else
		to_chat(virtual_user, SPAN_PURPLE("[icon2html(holder, virtual_user)] 你挂断了与 [get_phone_display_label(calling_phone.phone_id)] 的通话。"))

/datum/component/phone/virtual/getting_call(datum/component/phone/incoming_call)
	calling_phone = incoming_call
	SEND_SIGNAL(holder, COMSIG_ATOM_PHONE_RINGING)
	playsound_client(virtual_user, 'sound/machines/telephone/telephone_ring.ogg', vol = 50)
	addtimer(CALLBACK(src, PROC_REF(delayed_client_sound)), (10 SECONDS))

/datum/component/phone/virtual/proc/delayed_client_sound()
	if(!calling_phone || !calling_phone.timeout_timer_id)
		return

	playsound_client(virtual_user, 'sound/machines/telephone/telephone_ring.ogg', vol = 50)

/datum/component/phone/virtual/post_call_phone(mob/user, calling_phone_id)
	to_chat(user, SPAN_PURPLE("[icon2html(holder, user)] 正在拨打 [get_phone_display_label(calling_phone_id)]……"))
	timeout_timer_id = addtimer(CALLBACK(src, PROC_REF(reset_call), TRUE), timeout_duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)

	playsound_client(user.client, "rtb_handset")

/datum/component/phone/virtual/recall_handset()
	reset_call() // I don't think this will be possible given like... we don't have a handset but just in case
	return

/datum/component/phone/virtual/handle_hear(message, datum/language/message_language, mob/speaker, direct_talking)
	if(!calling_phone)
		return

	var/name_override = get_phone_display_label(calling_phone.phone_id)

	if(virtual_user == speaker)
		name_override = get_phone_display_label(phone_id)

	if(!virtual_user.mob)
		return

	virtual_user.mob.hear_radio(message, "说道", message_language, part_a = "<span class='purple'><span class='name'>", part_b = "</span><span class='message'> ", vname = name_override, speaker = speaker, command = 3, no_paygrade = TRUE)

/// Used to fake the other side of our phone connection as a virtual user
/datum/component/phone/virtual/proc/handle_virtual_speak(mob/speaker, message)
	SIGNAL_HANDLER

	if(!calling_phone)
		return

	handle_hear(message, null, speaker, TRUE)

	log_say("TELEPHONE: [key_name(speaker)] on Phone '[phone_id]' to '[calling_phone.phone_id]' said '[message]'")

	for(var/mob/dead/observer/cycled_observer in GLOB.player_list)
		if(cycled_observer == get_user() || cycled_observer == calling_phone.get_user())
			continue

		if((cycled_observer.client) && (cycled_observer.client.prefs) && (cycled_observer.client.prefs.toggles_chat & CHAT_GHOSTRADIO))
			var/ghost_message = "<span class='purple'><span class='name'>游戏主持人</span>使用电话“[get_phone_display_label(phone_id)]”向“[get_phone_display_label(calling_phone.phone_id)]”说：<span class='body'>\"[message]\"</span></span>"
			cycled_observer.show_message(ghost_message, SHOW_MESSAGE_AUDIBLE)

	calling_phone.handle_hear(message, null, speaker, TRUE)

	return COMPONENT_OVERRIDE_DEAD_SPEAK

/datum/component/phone/virtual/get_user()
	return virtual_user.mob

// TGUI section

/datum/component/phone/virtual/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/component/phone/virtual/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("hang_up")
			reset_call()
			return TRUE
		if("pick_up")
			if(!calling_phone)
				return
			picked_up_call(ui.user)
			calling_phone.other_phone_picked_up_call()
			return TRUE

/datum/component/phone/virtual/ui_data(mob/user)
	. = ..()

	.["virtual_phone"] = TRUE
	.["being_called"] = calling_phone?.timeout_timer_id ? TRUE : FALSE
	.["active_call"] = calling_phone ? TRUE : FALSE
	.["calling_phone_id"] = "[calling_phone?.phone_id]"
	.["calling_phone_display"] = get_phone_display_label(calling_phone?.phone_id)

/proc/get_phone_display_label(value, is_category = FALSE)
	if(!istext(value))
		return value
	var/static/list/category_labels = list(
		"Uncategorised" = "未分类",
		"Vehicles" = "载具",
		"BMG290 Otogi" = "BMG290御伽",
		"Solaris Ridge" = "索拉里斯山脊",
		"Lambda Labs" = "兰姆达实验室",
		"Eta Labs" = "伊塔实验室",
		"Bosenmori Site" = "博森莫里设施",
		"Sterling Outpost" = "斯特林哨站",
		"Checkpoint Four" = "四号检查站",
		"Brynhild" = "布伦希尔德号",
		"LV522 Chances Claim" = "LV522机遇矿区",
		"Lazarus Landing" = "拉撒路着陆区",
		"CR-116" = "CR-116",
		"Oread Garrison" = "奥瑞亚德驻军基地",
		"Sekhmet Net" = "塞赫迈特网络",
		"Golden Arrow" = "金箭号",
		"Command" = "指挥部",
		"Supply" = "补给",
		"MP Dept." = "宪兵部",
		"Almayer" = "阿尔迈耶",
		"ARES" = "ARES",
		"Offices" = "办公室",
		"Binhai Net" = "滨海网络",
		"Chapaev" = "恰帕耶夫号",
		"Dropship" = "运输艇",
		"Overwatch" = "战场监控",
		"Klescher Research Facility" = "克莱舍科研区",
		"Redemption Valley" = "救赎谷",
		"Redemption Outpost" = "救赎哨站",
		"CLF" = "殖民地解放阵线",
		"UPP" = "进步人民联盟",
		"W-Y" = "维兰德-汤谷",
		"Game Master" = "游戏主持人",
		"Marine" = "陆战队员",
		"Soldier" = "士兵",
		"IO" = "情报官",
	)
	if(is_category)
		return category_labels[value] || value
	var/static/list/id_labels = list(
		"Telephone" = "电话",
		"M34E1 Armored Engineering Vehicle" = "M34E1装甲工程车",
		"M577 Armoured Personnel Carrier" = "M577装甲运兵车",
		"M577-CMD Armoured Personnel Carrier" = "M577-CMD指挥型装甲运兵车",
		"M577-MED Armoured Personnel Carrier" = "M577-MED医疗型装甲运兵车",
		"M577A3 Armoured Personnel Carrier" = "M577A3装甲运兵车",
		"M540 Armoured Recon Carrier" = "M540装甲侦察车",
		"M34A2 Longstreet Light Tank" = "M34A2“朗斯特里特”轻型坦克",
		"ZSL-68 'Pilgrim'" = "ZSL-68“朝圣者”",
		"Cheetah 2A Light Tank" = "“猎豹”2A轻型坦克",
		"Keppitz Entry Checkpoint" = "凯皮茨入口检查站",
		"Otogi Diner" = "御伽餐馆",
		"Otogi Cargo - Delivery" = "御伽货运部——发货处",
		"Relay Substation" = "中继分站",
		"Relay Cafe" = "中继站咖啡馆",
		"Keppitz Acquisitions" = "凯皮茨采购部",
		"Otogi Filtration Station" = "御伽过滤站",
		"Keppitz Operations Room" = "凯皮茨运营室",
		"Otogi Telecommunication Substation" = "御伽通讯分站",
		"Relay Office" = "中继站办公室",
		"Otogi Flight Control" = "御伽飞行管制",
		"Relay Shelter" = "中继站避难所",
		"Keppitz Director's Office" = "凯皮茨主管办公室",
		"Otogi Public Office" = "御伽公共办公室",
		"Relay Secure Entry" = "中继站安全入口",
		"Otogi Administration Office" = "御伽行政办公室",
		"Otogi Security" = "御伽安保部",
		"Otogi Sports Stage" = "御伽体育场舞台",
		"Otogi Bar" = "御伽酒吧",
		"Otogi Power Station" = "御伽发电站",
		"Otogi Cargo - Receiving" = "御伽货运部——收货处",
		"Otogi Hangar Deck" = "御伽机库甲板",
		"Keppitz Archives" = "凯皮茨档案室",
		"Relay Distress" = "中继站紧急求助",
		"Otogi Recruitment Office" = "御伽征募办公室",
		"Virology Lab" = "病毒学实验室",
		"Clinic" = "诊所",
		"Xenobiology" = "异星生物学",
		"Robotics" = "机器人技术部",
		"Workshop" = "工坊",
		"Observation" = "观察室",
		"Marshal Office" = "法警办公室",
		"Clinic Labs" = "诊所实验室",
		"Director" = "主管",
		"Space Port" = "太空港",
		"Director's Safe Room" = "主管避难室",
		"Security" = "安保部",
		"Administration" = "行政部",
		"Clinic Reception" = "诊所接待处",
		"Virology" = "病毒学",
		"Operations" = "运营中心",
		"Surgery" = "手术室",
		"Filtration" = "过滤设施",
		"Communications" = "通信室",
		"Filtration Checkpoint" = "过滤设施检查站",
		"Corporate Office" = "公司办公室",
		"Supply Kiosk" = "补给服务亭",
		"Food Processing Office" = "食品加工办公室",
		"Dormitory" = "宿舍",
		"Telecommunications" = "通信室",
		"Bar" = "酒吧",
		"Secure Armory" = "安保军械库",
		"Administrator's Office" = "行政主管办公室",
		"Colony Operations" = "殖民地运营中心",
		"Mining Hub" = "采矿枢纽",
		"Cargo Retrievals" = "货物提取处",
		"Supply Maintenance Office" = "补给维修办公室",
		"Dining" = "餐厅",
		"Colony Operations - EMERGENCY LINE" = "殖民地运营中心——紧急专线",
		"News Outlet Office" = "新闻机构办公室",
		"Forward Research" = "前沿研究站",
		"Marshal Office - A" = "法警办公室A",
		"Research Dome" = "科研穹顶",
		"Medbay Reception" = "医务室接待处",
		"Secure Armory Maintenance" = "安保军械库维修间",
		"Engineering Office" = "工程部办公室",
		"Corporate Executive Office" = "公司高管办公室",
		"Security Department Armory Stash" = "安保部军械储藏室",
		"Marshal Office - B" = "法警办公室B",
		"Public Offices" = "公共办公室",
		"Sterling Operations Room" = "斯特林运营室",
		"Checkpoint Four - Overwatch Office" = "四号检查站——战场监控办公室",
		"Checkpoint Four - Bunker Checkpoint" = "四号检查站——地堡检查站",
		"Supply Bay" = "补给舱",
		"Troop Commander" = "突击排指挥官",
		"Engineering" = "工程部",
		"Chief Engineer Office" = "总工程师办公室",
		"Colony Kitchen" = "殖民地厨房",
		"Colony Dorms" = "殖民地宿舍",
		"Colony Northern Dorms" = "殖民地北部宿舍",
		"Colony Operations Centre" = "殖民地运营中心",
		"Colony Corporate" = "殖民地公司办公室",
		"Colony Bar & Grill" = "殖民地烧烤酒吧",
		"Colony Casino" = "殖民地赌场",
		"Colony Dining" = "殖民地餐厅",
		"Reactor Central Office" = "反应堆中央办公室",
		"Colony Engineering" = "殖民地工程部",
		"Reactor Garage" = "反应堆车库",
		"Colony Cargo" = "殖民地货运部",
		"Colony Botany" = "殖民地植物栽培区",
		"Reactor Entrance Office" = "反应堆入口办公室",
		"Colony Medical" = "殖民地医疗部",
		"Reactor Control" = "反应堆控制室",
		"Colony Fitness" = "殖民地健身房",
		"LZ1 Service Tunnel" = "1号着陆区维护隧道",
		"Reactor Meeting Room" = "反应堆会议室",
		"Reactor Sewer" = "反应堆下水道",
		"Colony Security" = "殖民地安保部",
		"Colony Private Casino" = "殖民地私人赌场",
		"Colony Garage" = "殖民地车库",
		"LZ1 Checkpoint" = "1号着陆区检查站",
		"Secure Storage" = "安全储藏室",
		"Director's Office" = "主管办公室",
		"Lakeside Bar" = "湖畔酒吧",
		"Cargo" = "货运部",
		"Medbay" = "医务室",
		"Armoury" = "军械库",
		"Cargo Bay" = "货舱",
		"Medical Bay" = "医务室",
		"Oread CIC" = "奥瑞亚德作战情报中心",
		"LZ Guardhouse" = "着陆区警卫室",
		"Warehouse" = "仓库",
		"PAP Services" = "人民武装警察服务处",
		"Research Surface Entry" = "科研区地面入口",
		"Xenostudies" = "异星研究室",
		"Commissary" = "军人商店",
		"Technica Director Office" = "技术主管办公室",
		"Rapid Fire Response" = "快速消防响应",
		"Treatment Reception" = "治疗接待处",
		"UPP Office" = "进步人民联盟办公室",
		"Confiscation" = "没收物品保管处",
		"Colonial Administrator Office" = "殖民地行政主管办公室",
		"MSS Office" = "太空安全部办公室",
		"Analysis" = "分析室",
		"Chemical Laboratory Reception" = "化学实验室接待处",
		"Overwatch" = "战术监控员",
		"Strike Ops Lead" = "突击行动指挥官",
		"Brig Cells" = "禁闭室牢房",
		"Flight Deck" = "飞行甲板",
		"AI Core" = "AI 核心",
		"CE Office" = "总工程师办公室",
		"Intelligence Center Telephone" = "情报中心电话",
		"Commanding Officer's Office" = "指挥官办公室",
		"Starboard Railgun Control" = "右舷轨道炮控制室",
		"Ordnance Tech" = "军械技术员",
		"Brig CMP's Office" = "禁闭室宪兵长办公室",
		"Brig Main Offices" = "禁闭室主办公室",
		"Auxiliary Support Office Second Line" = "辅助支援军官办公室二线",
		"Auxiliary Support Office" = "辅助支援军官办公室",
		"Port Railgun Control" = "左舷轨道炮控制室",
		"Senior Enlisted Advisor's Office" = "资深士官顾问办公室",
		"Combat Information Center" = "作战情报中心",
		"Charlie Overwatch" = "查理小队战场监控",
		"AI Reception" = "AI接待处",
		"RO Office" = "军需官办公室",
		"Requisition" = "军需部",
		"CL Office" = "公司联络官办公室",
		"Kitchen" = "厨房",
		"Medical Lower" = "下层医疗区",
		"Reporter" = "记者",
		"Delta Overwatch" = "德尔塔小队战场监控",
		"CIC Reception" = "作战情报中心接待处",
		"Alpha Overwatch" = "阿尔法小队战场监控",
		"CMO Office" = "首席医疗官办公室",
		"Brig Warden's Office" = "禁闭室军事监狱长办公室",
		"Bravo Overwatch" = "布拉沃小队战场监控",
		"Research" = "科研部",
		"Hydroponics" = "水培区",
		"Hab Block - South" = "南部居住区",
		"PAP Office" = "人民武装警察办公室",
		"Hab Block - Cantina" = "居住区食堂",
		"Trseatment Reception" = "治疗接待处",
		"UPP Base Command Room" = "进步人民联盟基地指挥室",
		"Lower Engineering" = "下层工程区",
		"Hab Block - North" = "北部居住区",
		"Mining Office" = "采矿办公室",
		"Research Office" = "科研办公室",
		"Administrator Office" = "行政主管办公室",
		"PAP Lobby" = "人民武装警察大厅",
		"Treatment Office" = "治疗办公室",
		"MSS Operations" = "太空安全部行动处",
		"Checkpoint" = "检查站",
		"Lower Mining" = "下层采矿区",
		"Filtration Control" = "过滤设施控制室",
		"UPP Base Quarters" = "进步人民联盟基地宿舍",
		"Station Operations Room" = "空间站运营室",
		"Sanitar's Office" = "卫生员办公室",
		"Captain's Office" = "舰长办公室",
		"Normandy" = "诺曼底号",
		"Unknown Signal" = "未知信号",
		"Briefing" = "简报室",
		"Motor Pool" = "车辆停放场",
		"Supply Launch Bay" = "补给发射舱",
		"Lower Supply Bay" = "下层补给舱",
		"Marshals - 2" = "法警2号线",
		"Library" = "图书馆",
		"Eta Research Lab" = "伊塔研究实验室",
		"Marshals Office" = "法警办公室",
		"Clinic Office" = "诊所办公室",
		"Lambda Safe Room" = "兰姆达避难室",
		"Diner" = "餐馆",
		"Waterworks Office" = "水务办公室",
		"Eta Archives" = "伊塔档案室",
		"Workers Rights Office" = "劳工权益办公室",
		"Weyland Yutani Representative Office" = "维兰德-汤谷代表办公室",
		"Logistics Kiosk" = "后勤服务亭",
		"Janitor Kiosk" = "清洁服务亭",
		"Marshals - 1" = "法警1号线",
		"Eta Security Kiosk" = "伊塔安保服务亭",
		"Cargo Distribution Center" = "货物配送中心",
		"General Research Office" = "综合科研办公室",
		"USCM Recruitment Office" = "殖民地陆战队征募办公室",
		"Eta Directors Office" = "伊塔主管办公室",
		"Lambda Head Research Office" = "兰姆达首席研究员办公室",
		"East Bunker Control" = "东部地堡控制室",
		"Armory" = "军械库",
		"West Bunker Control" = "西部地堡控制室",
		"Flight Control" = "飞行管制",
		"Store" = "商店",
		"Company Housing" = "公司宿舍",
		"Operations Control" = "运营控制室",
		"Cafe" = "咖啡馆",
		"Medical" = "医疗部",
		"Squad Leader" = "小队长",
		"Alamo" = "阿拉莫号",
		"Cyclone" = "旋风号",
		"Gibraltar" = "直布罗陀号",
		"Midway" = "中途岛号",
		"saipan" = "塞班号",
		"Tornado" = "龙卷风号",
		"Tripoli" = "的黎波里号",
		"Typhoon" = "台风号",
		"Typhoon Overwatch" = "台风号战场监控",
		"Akademia Nauk" = "科学院号",
		"CLF Outpost" = "殖民地解放阵线哨站",
		"UPP Station" = "进步人民联盟驻地",
		"W-Y Station CiC" = "维兰德-汤谷驻地作战情报中心",
		"W-Y Station Meeting Room" = "维兰德-汤谷驻地会议室",
		"Ground Command" = "地面指挥部",
		"Ground Requisitions" = "地面军需部",
		"Company Command" = "连部",
	)
	var/duplicate_at = findtext(value, " (#:")
	var/base_id = duplicate_at ? copytext(value, 1, duplicate_at) : value
	var/duplicate_suffix = duplicate_at ? copytext(value, duplicate_at) : ""
	for(var/datum/component/phone/current_phone as anything in GLOB.phones)
		if(current_phone.phone_id == value && current_phone.localized_phone_id == base_id && current_phone.localized_phone_label)
			return "[current_phone.localized_phone_label][duplicate_suffix]"
	return "[id_labels[base_id] || base_id][duplicate_suffix]"

/proc/get_phone_role_display_label(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"Rifleman" = "步枪兵",
		"Section Sergeant" = "分队士官",
		"Combat Engineer" = "战斗工兵",
		"Corpsman" = "医疗兵",
		"Weapons Specialist" = "武器专家",
		"Spotter" = "观测手",
		"Weapons Loader" = "武器装填手",
		"Squad Leader" = "小队长",
		"Smartgunner" = "智能机枪手",
		"Infantryman" = "步兵",
		"Platoon Sergeant" = "排士官",
		"Platoon Sanitar" = "排卫生员",
		"Squad Sergeant" = "小队士官",
		"Machinegunner" = "机枪手",
		"UPP Platoon Commander" = "UPP 排指挥官",
		"Assistant Recon Squad Leader" = "侦察小队副队长",
		"Recon Squad Leader" = "侦察小队长",
		"Recon Corpsman" = "侦察医疗兵",
		"Recon Radio Telephone Operator" = "侦察无线电通讯员",
		"Recon Rifleman" = "侦察步枪兵",
		"Recon Smartgunner" = "侦察智能机枪手",
		"Colonist" = "殖民者",
		"Passenger" = "乘客",
		"Survivor" = "幸存者",
		"Synth Survivor" = "合成人幸存者",
		"CO Survivor" = "指挥官幸存者",
		"Chief Medical Officer" = "首席医疗官",
		"Doctor" = "医生",
		"Surgeon" = "外科医生",
		"Nurse" = "护士",
		"Researcher" = "研究员",
		"Corporate Liaison" = "公司联络员",
		"Combat Correspondent" = "战地记者",
		"Mess Technician" = "炊事员",
		"Synthetic" = "合成人",
		"Working Joe" = "工作乔",
		"Commanding Officer" = "指挥官",
		"Executive Officer" = "副指挥官",
		"Platoon Commander" = "排指挥官",
		"Auxiliary Support Officer" = "辅助支援军官",
		"Gunship Pilot" = "武装艇飞行员",
		"Dropship Pilot" = "运输艇飞行员",
		"Tank Crew" = "坦克乘员",
		"Dropship Crew Chief" = "运输艇机组长",
		"Intelligence Officer" = "情报官",
		"Military Police" = "宪兵",
		"Military Warden" = "军事监狱长",
		"Chief MP" = "宪兵长",
		"Drill Instructor" = "教官",
		"Chief Engineer" = "总工程师",
		"Maintenance Technician" = "维护技术员",
		"Ordnance Technician" = "军械技术员",
		"Logistics Officer" = "后勤军官",
		"Logistics Chief" = "后勤主管",
		"Armorer" = "军械师",
		"Logistics Specialist" = "后勤专员",
		"Marine Raider" = "陆战突击兵",
		"Marine Raider Team Lead" = "陆战突击组长",
		"Marine Raider Platoon Lead" = "陆战突击排长",
		"Stowaway" = "偷渡者",
		"USCM Marine" = "殖民地陆战队员",
		"USCM Colonel" = "USCM 上校",
		"USCM Observer" = "USCM 观察员",
		"USCM General" = "USCM 将军",
		"Assistant Commandant of the Marine Corps" = "海军陆战队副司令",
		"Commandant of the Marine Corps" = "海军陆战队司令",
		"Platoon Corpsman" = "排医疗兵",
		"Platoon Squad Leader" = "排属小队长",
		"Support Technician" = "支援技术员",
		"Ground Commander" = "地面指挥官",
		"Lieutenant Commander" = "海军少校",
		"Honor Guard Squad Leader" = "荣誉卫队队长",
		"Veteran Honor Guard" = "资深荣誉卫兵",
		"Honor Guard Weapons Specialist" = "荣誉卫队武器专家",
		"Honor Guard" = "荣誉卫兵",
		"Mortar Crew" = "迫击炮组员",
		"Bunker Crew Master" = "掩体班长",
		"Bunker Crew" = "掩体组员",
		"Bunker Quartermaster" = "掩体军需官",
		"Bunker Crew Logistics" = "掩体后勤人员",
		"Head Surgeon" = "主任外科医生",
		"Field Doctor" = "战地医生",
		"Chemist" = "化学师",
		"Combat Reporter" = "战地报道员",
		"Support Synthetic" = "支援合成人",
		"Dust Raider Squad Rifleman" = "尘土突袭者小队步枪兵",
		"Dust Raider Squad Hospital Corpsman" = "尘土突袭者小队医疗兵",
		"Dust Raider Squad Combat Technician" = "尘土突袭者小队战斗技术员",
		"Dust Raider Squad Smartgunner" = "尘土突袭者小队智能机枪手",
		"Dust Raider Squad Weapons Specialist" = "尘土突袭者小队武器专家",
		"Dust Raider Squad Leader" = "尘土突袭者小队长",
		"Army Trooper" = "陆军步兵",
		"Army Grenadier" = "陆军榴弹兵",
		"Army Gunner" = "陆军机枪手",
		"Army Heavy Gunner" = "陆军重机枪手",
		"Army Marksman" = "陆军精确射手",
		"Army AT Loader" = "陆军反坦克装填手",
		"Army AT Gunner" = "陆军反坦克射手",
		"Army Combat Engineering Technician" = "陆军战斗工程技术员",
		"Army Technical Engineer" = "陆军技术工程师",
		"Army Logistics Specialist" = "陆军后勤专员",
		"Army Combat Medical Technician" = "陆军战斗医疗技术员",
		"Army Vehicle Crewman" = "陆军载具乘员",
		"Army Fireteam Lead" = "陆军火力组长",
		"Army Squad Leader" = "陆军小队长",
		"Army Lieutenant" = "陆军中尉",
		"Army Intelligence Officer" = "陆军情报官",
		"Army Science Officer" = "陆军科研官",
		"Army Logistics Officer" = "陆军后勤军官",
		"USASF Crewman" = "USASF 舰员",
		"USASF Hospital Corpsman" = "USASF 医疗兵",
		"USASF Engineering Technician" = "USASF 工程技术员",
		"USASF Flight-Deck Crewman" = "USASF 飞行甲板组员",
		"USASF Orbital Fire-Support Liason Officer" = "USASF 轨道火力支援联络官",
		"USASF Para-Rescue Support Technician" = "USASF 伞降救援支援技术员",
		"USASF Support Synthetic" = "USASF 支援合成人",
		"USASF Pilot" = "USASF 飞行员",
		"USASF Engineering Duty Officer" = "USASF 工程值勤军官",
		"USASF Flight-Deck Officer" = "USASF 飞行甲板军官",
		"USASF Duty Officer" = "USASF 值勤军官",
		"USASF Commanding Officer" = "USASF 指挥官",
		"PMC Operator" = "PMC 行动队员",
		"PMC Corporate Technician" = "PMC 公司技术员",
		"PMC Corporate Medic" = "PMC 公司医疗兵",
		"PMC Trauma Surgeon" = "PMC 创伤外科医生",
		"PMC Medical Investigator" = "PMC 医疗调查员",
		"PMC Security Enforcer" = "PMC 安保执法员",
		"PMC Support Weapons Specialist" = "PMC 支援武器专家",
		"PMC Weapons Specialist" = "PMC 武器专家",
		"PMC Vehicle Crewman" = "PMC 载具乘员",
		"PMC Xeno Handler" = "PMC 异形管控员",
		"PMC Leader" = "PMC 队长",
		"PMC Lead Investigator" = "PMC 首席调查员",
		"Corporate Operations Director" = "公司行动主管",
		"PMC Support Synthetic" = "PMC 支援合成人",
		"Corporate Trainee" = "公司实习生",
		"Corporate Junior Executive" = "公司初级主管",
		"Corporate Executive" = "公司主管",
		"Corporate Senior Executive" = "公司高级主管",
		"Corporate Executive Specialist" = "公司业务专员",
		"Corporate Executive Supervisor" = "公司业务督导",
		"Corporate Assistant Manager" = "公司助理经理",
		"Corporate Division Manager" = "公司部门经理",
		"Corporate Chief Executive" = "公司首席执行官",
		"W-Y Director" = "维兰德-汤谷董事",
		"WY Corporate Security" = "维兰德-汤谷公司安保员",
		"WY Corporate Security Technician" = "维兰德-汤谷公司安保技术员",
		"WY Corporate Security Lead" = "维兰德-汤谷公司安保队长",
		"WY Research Consultant" = "维兰德-汤谷科研顾问",
		"Overwatch Operator" = "战场监控操作员",
		"Operations Leader" = "行动队长",
		"Team Leader" = "战斗组长",
		"Heavy Weapons Specialist" = "重武器专家",
		"Tactical Unit" = "战术队员",
		"Medical Specialist" = "医疗专家",
		"Strike Operations Leader" = "突击行动队长",
		"Strike Team Leader" = "突击组长",
		"Strike Heavy Weapons Specialist" = "突击重武器专家",
		"Strike Tactical Unit" = "突击战术队员",
		"Strike Medical Specialist" = "突击医疗专家",
		"VAIPO Mercenary" = "先锋之箭主要行动部雇佣兵",
		"VAIMS Medical Specialist" = "VAIMS医疗专员",
		"VAIPO Engineering Specialist" = "先锋之箭主要行动部工程专家",
		"VAIPO Automatic Rifleman" = "先锋之箭主要行动部自动步枪手",
		"VAIPO Team Leader" = "先锋之箭主要行动部战斗组长",
		"VAIPO Support Synthetic" = "先锋之箭主要行动部支援合成人",
		"VAISO Mercenary" = "先锋之箭特别行动部雇佣兵",
		"VAISO Engineering Specialist" = "先锋之箭特别行动部工程专家",
		"VAISO Automatic Rifleman" = "先锋之箭特别行动部自动步枪手",
		"VAISO Team Leader" = "先锋之箭特别行动部战斗组长",
		"VAISO Support Synthetic" = "先锋之箭特别行动部支援合成人",
		"Office of Colonial Marshals Deputy" = "殖民地执法署副执法官",
		"Colonial Marshal" = "殖民地执法官",
		"CMB Investigative Synthetic" = "殖民地执法局调查合成人",
		"Interstellar Commerce Commission Liaison" = "星际商业委员会联络员",
		"Interstellar Human Rights Observer" = "星际人权观察员",
		"Reconnaissance Commander" = "武装侦察部队指挥官",
		"Reconnaissance Squad Leader" = "武装侦察部队小队长",
		"Reconnaissance Synthetic" = "武装侦察部队合成人",
		"Reconnaissance Sniper" = "武装侦察部队狙击手",
		"Reconnaissance Marksman" = "武装侦察部队精确射手",
		"Reconnaissance Support Technician" = "武装侦察部队支援技术员",
		"Reconnaissance Rifleman" = "武装侦察部队步枪兵",
		"Reconnaissance Smartgunner" = "武装侦察部队智能机枪手",
		"Naval Infantry Rifleman" = "海军步兵步枪兵",
		"Naval Infantry Sapper" = "海军步兵工兵",
		"Naval Infantry Sanitar" = "海军步兵卫生员",
		"Naval Infantry Sergeant" = "海军步兵士官",
		"Naval Infantry Marksman" = "海军步兵精确射手",
		"Naval Infantry Platoon Sergeant" = "海军步兵排士官",
		"Politsiya" = "警察",
		"Logistics Technician" = "后勤技术员",
		"Junior Lieutenant" = "初级中尉",
		"Lieutenant Doctor" = "医疗中尉",
		"Senior Lieutenant" = "高级中尉",
		"Captain" = "上尉",
		"Major" = "少校",
		"Lieutenant Colonel" = "中校",
		"Colonel" = "上校",
		"Major General" = "少将",
		"Lieutenant General" = "中将",
		"General" = "上将",
		"Combat Synthetic" = "战斗合成人",
		"Junior Kommando" = "初级突击队员",
		"2nd Kommando" = "二级突击队员",
		"1st Kommando" = "一级突击队员",
		"UPP Representative" = "进步人民联盟代表",
		"Tank Crewman" = "坦克乘员",
		"Political Commissar" = "政治委员",
		"CLF Guerilla" = "殖民地解放阵线游击队员",
		"CLF Field Technician" = "殖民地解放阵线战地技术员",
		"CLF Field Medic" = "殖民地解放阵线战地医护兵",
		"CLF Field Specialist" = "殖民地解放阵线战地专家",
		"CLF Cell Leader" = "殖民地解放阵线小组长",
		"CLF Cell Commander" = "殖民地解放阵线小组指挥官",
		"CLF Multipurpose Synthetic" = "殖民地解放阵线多用途合成人",
		"TWE Representative" = "三世界帝国代表",
		"Marine Commando" = "陆战突击队员",
		"Medical Assistant" = "医疗助理",
		"Assault Engineer" = "突击工兵",
		"Scout Sniper" = "侦察狙击手",
		"GPMG Gunner" = "通用机枪手",
		"Bombardment Specialist" = "炮击专家",
		"Section Leader" = "班长",
		"Troop Sergeant" = "突击排士官",
		"Troop Commander" = "突击排指挥官",
		"Squadron Commander" = "中队指挥官",
		"Provost Enforcer" = "军法监察执法员",
		"Provost Team Leader" = "军法监察组长",
		"Provost Advisor" = "军法监察顾问",
		"Provost Inspector" = "军法监察官",
		"Provost Chief Inspector" = "军法总监察官",
		"Provost Undercover Inspector" = "军法卧底监察官",
		"Provost Deputy Marshal" = "军法副总监",
		"Provost Marshal" = "军法总监",
		"Provost Sector Marshal" = "星区军法总监",
		"Provost Chief Marshal" = "军法总监长",
		"Riot Control" = "防暴队员",
		"Chief Riot Control" = "防暴队长",
		"Intelligence Analyst" = "情报分析员",
		"Intelligence Liaison Officer" = "情报联络官",
		"BD Grunt" = "黑龙骑兵战斗员",
		"BD Pilot" = "黑龙骑兵飞行员",
		"BD Sentinel" = "黑龙骑兵哨兵",
		"BD Supervisor" = "黑龙骑兵督导",
		"BD Bulwark" = "黑龙骑兵重装卫士",
		"BD Synth" = "黑龙骑兵合成人",
		"BD Infiltrator" = "黑龙骑兵渗透者",
		"BD Officer" = "黑龙骑兵军官",
		"Colonial Militiaman" = "殖民地民兵",
		"Colonial Militiaman Technician" = "殖民地民兵技术员",
		"Colonial Militiaman Medic" = "殖民地民兵医疗兵",
		"Colonial Militiaman Unit Leader" = "殖民地民兵分队长",
		"Colonial Militiaman Officer" = "殖民地民兵军官",
		"Dutch's Dozen - Dutch" = "达奇十二人组——达奇",
		"Dutch's Dozen - Rifleman" = "达奇十二人组——步枪兵",
		"Dutch's Dozen - Minigunner" = "达奇十二人组——迷你机枪手",
		"Dutch's Dozen - Flamethrower" = "达奇十二人组——喷火兵",
		"Dutch's Dozen - Medic" = "达奇十二人组——医疗兵",
		"Predator" = "铁血战士",
		"Xenomorph" = "异形",
		"Queen" = "女皇",
		"Observer" = "旁观者",
	)
	return labels[value] || preference_label(value)

/proc/get_phone_squad_display_label(value)
	if(!istext(value))
		return value
	var/static/list/labels = list(
		"Alpha" = "阿尔法",
		"Bravo" = "布拉沃",
		"Charlie" = "查理",
		"Delta" = "德尔塔",
		"Echo" = "埃科",
		"Foxtrot" = "福克斯特罗特",
		"Sun Riders" = "烈日骑兵",
		"Sun Riders B-Sct" = "烈日骑兵 B 分队",
		"Intel" = "情报组",
		"SOF" = "特种部队",
		"CBRN" = "核生化",
		"FORECON" = "武装侦察部队",
		"Solar Devils" = "太阳恶魔",
		"US Army" = "美国陆军",
		"Red Dawn" = "赤色黎明",
		"Golden Embers" = "金色余烬",
		"AZURE-15" = "苍蓝-15",
		"VIRIDIAN-22" = "翠绿-22",
		"AZURE-16" = "苍蓝-16",
		"Gamma Troop" = "伽马分队",
		"Snake Eaters" = "食蛇者",
		"Ocelot Grapplers" = "豹猫搏击队",
		"UPPS1" = "联盟第1小队",
		"UPPS2" = "联盟第2小队",
		"UPPS3" = "联盟第3小队",
		"UPPS4" = "联盟第4小队",
		"UPPKdo" = "联盟突击队",
		"Team Upsilon" = "宇普西隆小组",
		"Team Gamma" = "伽马小组",
		"Taskforce White" = "白色特遣队",
		"Python" = "蟒蛇",
		"Viper" = "蝰蛇",
		"Cobra" = "眼镜蛇",
		"Boa" = "蚺蛇",
	)
	return labels[value] || value
