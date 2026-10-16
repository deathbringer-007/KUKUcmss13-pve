
/obj/item/stack/yautja_rope
	name = "绳索"
	singular_name = "绳索（米）"
	desc = "结实耐用的好绳子。"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "coil"
	item_state = "coil"
	force = 2
	w_class = SIZE_SMALL
	attack_verb = list("鞭打", "抽打", "惩戒", "鞭笞")
	color = "#D2B48C"
	attack_speed = 1.4 SECONDS //stop spam
	amount = 8
	max_amount = 8

/obj/item/stack/yautja_rope/attack(mob/living/mob_victim, mob/living/carbon/human/user)
	if(mob_victim.stat != DEAD)
		return ..()

	if(mob_victim.mob_size != MOB_SIZE_HUMAN)
		to_chat(user, SPAN_WARNING("[mob_victim]的身体构造不适合吊起来。"))
		return TRUE

	var/mob/living/carbon/human/victim = mob_victim

	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		return TRUE

	user.visible_message(SPAN_NOTICE("[user]开始将绳索固定在天花板上……"),
		SPAN_NOTICE("你开始将绳索固定在天花板上……"))

	if(do_after(user, 4 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
		var/turf/rturf = get_turf(victim)
		var/area/rarea = get_area(victim)
		if(rturf.density)
			to_chat(user, SPAN_WARNING("对方在墙里！"))
			return TRUE
		if(rarea.ceiling == CEILING_NONE)
			to_chat(user, SPAN_WARNING("这里没有天花板，无法把对方吊起来！"))
			return TRUE
		user.visible_message(SPAN_NOTICE("[user]固定好了绳索。"),
			SPAN_NOTICE("你固定好了绳索。"))
		if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
			return
		user.visible_message(SPAN_WARNING("[user]开始用绳索吊起[victim]……"),
			SPAN_NOTICE("你开始用绳索吊起[victim]……"))
		if(!do_after(user, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, victim))
			return
		if(victim.anchored)
			return // Just in case weed_food took them during this time
		user.visible_message(SPAN_WARNING("[user]将[victim]吊在了天花板上！"), SPAN_NOTICE("你将[victim]吊了起来。"))
		user.stop_pulling()
		victim.get_hung()
		use(1)
	return TRUE

/mob/living/carbon/human/proc/get_hung()
	animate(src, pixel_y = 9, time = 0.5 SECONDS, easing = SINE_EASING|EASE_OUT)
	setDir(SOUTH)
	var/matrix/A = matrix()
	A.Turn(180)
	apply_transform(A)
	var/rand_swing = rand(6, 3)
	//-6, -3
	animate(src, pixel_x = (rand_swing * -1), time = 3 SECONDS, loop = -1, easing = SINE_EASING|EASE_OUT)
	animate(pixel_x = rand_swing, time = 3 SECONDS,  easing = SINE_EASING|EASE_OUT)

	anchored = TRUE
	RegisterSignal(src, COMSIG_ATTEMPT_MOB_PULL, PROC_REF(deny_pull))
	RegisterSignal(src, list(
		COMSIG_ITEM_ATTEMPT_ATTACK,
		COMSIG_LIVING_REJUVENATED,
		COMSIG_HUMAN_REVIVED
		), PROC_REF(cut_down))

/mob/living/carbon/human/proc/deny_pull()
	return COMPONENT_CANCEL_MOB_PULL

/mob/living/carbon/human/proc/cut_down(mob/living/carbon/human/target, mob/living/user, obj/item/source)
	//source = item, target = src
	SIGNAL_HANDLER
	if(source && !source.sharp)
		return

	if(user)
		if(user.a_intent != INTENT_HELP)
			return
		user.visible_message(SPAN_WARNING("[user]用[source]割断绳索，将[src]放了下来。"), SPAN_WARNING("你用[source]割断绳索，将[src]放了下来。"))
		user.animation_attack_on(src)
		playsound(src, 'sound/effects/vegetation_hit.ogg', 25, TRUE)
	else
		visible_message(SPAN_DANGER("[src]的身体从悬挂的绳索上掉了下来！"))
	UnregisterSignal(src, list(
			COMSIG_ATTEMPT_MOB_PULL,
			COMSIG_ITEM_ATTEMPT_ATTACK,
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED
		))
	animate(src) //remove the anims
	anchored = FALSE
	var/matrix/A = matrix()
	A.Turn(90)
	apply_transform(A)
	pixel_x = 0
	pixel_y = 0
	Moved(loc, NONE, TRUE) // Trigger any movement signals
	return COMPONENT_CANCEL_ATTACK
