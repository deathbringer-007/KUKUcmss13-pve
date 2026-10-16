/obj/item/stack/revival_jelly
	name = "复生凝胶"
	singular_name = "复生凝胶"
	desc = "一种奇怪的凝胶，可以让死去的异形复活。"

	icon_state = "royal_jelly"

	stack_id = "royal jelly"

	amount = 0
	max_amount = 9
	var/time_to_take = 3 SECONDS

/obj/item/stack/revival_jelly/attack_alien(mob/living/carbon/xenomorph/M)
	attack_hand(M) //This has a .2 second delay of its own.
	return XENO_NO_DELAY_ACTION

/obj/item/stack/revival_jelly/proc/can_revive(required_jelly, mob/living/carbon/xenomorph/X, mob/living/user)
	if(user.action_busy)
		to_chat(user, SPAN_WARNING("你已经在执行其他动作了！"))
		return FALSE

	if(!X.caste.can_be_revived)
		to_chat(user, SPAN_WARNING("这只异形无法复活！"))
		return FALSE

	if(X == user)
		to_chat(user, SPAN_WARNING("你不能对自己使用这个！"))
		return FALSE

	if(!X.stat || !X.caste.can_be_revived)
		to_chat(user, SPAN_WARNING("你不能对[X]使用这个！"))
		return FALSE

	if(amount < required_jelly)
		to_chat(user, SPAN_WARNING("[src]不足，无法复活[X]！此操作需要[required_jelly]份。"))
		return FALSE

	return TRUE

/obj/item/stack/revival_jelly/attack(mob/living/carbon/xenomorph/X, mob/living/user)
	if(!istype(X))
		return ..()

	var/required_jelly = max(1, X.tier)

	if(!can_revive(required_jelly, X, user))
		return

	to_chat(user, SPAN_NOTICE("你开始将[src]涂在[X]身上。"))
	if(!do_after(user, time_to_take, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, X, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		to_chat(user, SPAN_WARNING("你停止将[src]涂在[X]身上。"))
		return

	if(!can_revive(required_jelly, X, user))
		return

	X.away_timer = 0
	X.revive()
	playsound(get_turf(X), 'sound/effects/xeno_newlarva.ogg', 35)

	var/mob/original_mob = X.mind?.current
	// Make sure they still have a client and are still a ghost.
	if(original_mob?.client && original_mob.stat == DEAD)
		X.mind.transfer_to(X, TRUE)
	else
		X.away_timer = XENO_LEAVE_TIMER

	use(required_jelly)
