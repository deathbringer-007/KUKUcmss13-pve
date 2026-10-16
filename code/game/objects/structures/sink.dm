/obj/structure/sink
	name = "洗手池"
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "sink_emptied_animation"
	desc = "用于洗手和洗脸的水池。"
	anchored = TRUE
	/// if something's being washed at the moment
	var/busy = FALSE


/obj/structure/sink/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "sink_emptied"


/obj/structure/sink/proc/stop_flow() //sets sink animation to normal sink (without running water)

	if(prob(50))
		icon_state = "sink_emptied_animation"
	else
		icon_state = "sink_emptied"
	flick("sink_animation_empty", src)


/obj/structure/sink/attack_hand(mob/user)
	if(isRemoteControlling(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_DANGER("已经有人在这里清洗了。"))
		return

	to_chat(usr, SPAN_NOTICE("你开始洗手。"))
	flick("sink_animation_fill", src) //<- play the filling animation then automatically switch back to the loop
	icon_state = "sink_animation_fill_loop" //<- set it to the loop
	addtimer(CALLBACK(src, PROC_REF(stop_flow)), 6 SECONDS)
	playsound(loc, 'sound/effects/sinkrunning.ogg', 25, TRUE)

	busy = TRUE
	sleep(40)
	busy = FALSE

	if(!Adjacent(user)) return //Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message(SPAN_NOTICE("[user]在[src]里洗手。"), SHOW_MESSAGE_VISIBLE)


/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		to_chat(user, SPAN_DANGER("已经有人在这里清洗了。"))
		return

	var/obj/item/reagent_container/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(SPAN_NOTICE("[user]用[src]给[RG]装水。"),SPAN_NOTICE("你用[src]给[RG]装水。"))
		return

	else if (istype(O, /obj/item/weapon/baton))
		var/obj/item/weapon/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.apply_effect(10, STUN)
				user.stuttering = 10
				user.apply_effect(10, WEAKEN)
				B.deductcharge(B.hitcost)
				user.visible_message( \
					SPAN_DANGER("[user]被手里沾水的[O]电晕了！"), \
					SPAN_DANGER("你被手里沾水的[O]电晕了！"))
				return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, SPAN_NOTICE("你开始清洗[I]。"))

	busy = TRUE
	sleep(40)
	busy = FALSE

	if(user.loc != location) return //User has moved
	if(!I) return //Item's been destroyed while washing
	if(user.get_active_hand() != I) return //Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("[user]在[src]里清洗[I]。"), \
		SPAN_NOTICE("你在[src]里清洗[I]。"))


/obj/structure/sink/kitchen
	name = "厨房水槽"
	icon_state = "sink_alt"


/obj/structure/sink/puddle //splishy splashy ^_^
	name = "水洼"
	icon_state = "puddle"


/obj/structure/sink/puddle/attack_hand(mob/M as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"


/obj/structure/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"
