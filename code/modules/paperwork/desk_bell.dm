// A receptionist's bell

/obj/item/desk_bell
	name = "桌铃"
	desc = "客服工作的必备品。你总是忍不住想按响它。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "desk_bell"
	w_class = SIZE_SMALL
	embeddable = FALSE
	/// The amount of times this bell has been rang, used to check the chance it breaks.
	var/times_rang = 0
	/// Is this bell broken?
	var/broken_ringer = FALSE
	/// Holds the time that the bell can next be rang.
	COOLDOWN_DECLARE(ring_cooldown)
	/// The length of the cooldown. Setting it to 0 will skip all cooldowns alltogether.
	var/ring_cooldown_length = 5 SECONDS // This is here to protect against tinnitus.
	/// The sound the bell makes.
	var/ring_sound = 'sound/misc/desk_bell.ogg'

/obj/item/desk_bell/attack_hand(mob/living/user)
	if(!ishuman(user))
		return FALSE
	if(!anchored)
		return ..()
	if(!COOLDOWN_FINISHED(src, ring_cooldown))
		return FALSE
	if(!ring_bell(user))
		to_chat(user, SPAN_NOTICE("[src]没有响。某个笨蛋把它弄坏了。"))
		return FALSE
	return TRUE

/obj/item/desk_bell/MouseDrop(atom/over_object)
	var/mob/mob = usr
	if(!Adjacent(mob) || anchored)
		return
	if(!ishuman(mob))
		return

	if(over_object == mob)
		mob.put_in_hands(src)

/obj/item/desk_bell/attackby(obj/item/item, mob/user)
	//Repair the desk bell if its broken and we're using a screwdriver.
	if(HAS_TRAIT(item, TRAIT_TOOL_SCREWDRIVER))
		if(broken_ringer)
			user.visible_message(SPAN_NOTICE("[user]开始修理[src]……"), SPAN_NOTICE("你开始修理[src]……"))
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				user.visible_message(SPAN_NOTICE("[user]修好了[src]。"), SPAN_NOTICE("你修好了[src]。"))
				playsound(src, 'sound/items/Screwdriver.ogg', 50)
				broken_ringer = FALSE
				times_rang = 0
				return TRUE
			return FALSE

	//Return at this point if we're not on a turf so we don't anchor or unanchor inside our bag/hands or inventory.
	if(!isturf(loc))
		return

	//Wrenching down and unwrenching.
	if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))
		if(user.a_intent == INTENT_HARM)
			visible_message(SPAN_NOTICE("[user]开始拆解[src]……"), SPAN_NOTICE("你开始拆解[src]……"))
			playsound(src, 'sound/items/deconstruct.ogg', 35)
			if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				visible_message(SPAN_NOTICE("[user]拆解了[src]。"), SPAN_NOTICE("你拆解了[src]。"))
				new /obj/item/stack/sheet/metal(get_turf(src))
				qdel(src)
				return TRUE
		else
			user.visible_message(SPAN_NOTICE("[user]开始[anchored ? "松开" : "固定"][src]……"), SPAN_NOTICE("你开始[anchored ? "松开" : "固定"][src]……"))
			playsound(src, 'sound/items/Ratchet.ogg', 35, TRUE)
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return FALSE
			user.visible_message(SPAN_NOTICE("[user][anchored ? "松开" : "固定"]了[src]。"), SPAN_NOTICE("你[anchored ? "松开" : "固定"]了[src]。"))
			anchored = !anchored
			return TRUE


/// Check if the clapper breaks, and if it does, break it. Chance to break is 1% for every 100 rings of the bell.
/obj/item/desk_bell/proc/check_clapper(mob/living/user)
	if(prob(times_rang / 100))
		to_chat(user, SPAN_NOTICE("你听见[src]的铃舌从铰链上掉了下来。真是好手劲，你把它弄坏了。"))
		broken_ringer = TRUE

/// Ring the bell.
/obj/item/desk_bell/proc/ring_bell(mob/living/user)
	if(broken_ringer)
		return FALSE
	check_clapper(user)
	COOLDOWN_START(src, ring_cooldown, ring_cooldown_length)
	playsound(src, ring_sound, 80)
	flick("desk_bell_activate", src)
	times_rang++
	return TRUE

/obj/item/desk_bell/ares
	name = "AI 核心接待铃"
	desc = "客服工作的必备品。这只铃连接着 ARES，按响时会通知所有正在工作的工作乔。"
	ring_cooldown_length = 60 SECONDS // Prevents spam

/obj/item/desk_bell/ares/ring_bell(mob/living/user)
	if(broken_ringer)
		return FALSE
	ares_apollo_talk("AI 核心接待处需要工作人员前往。")
	return ..()
