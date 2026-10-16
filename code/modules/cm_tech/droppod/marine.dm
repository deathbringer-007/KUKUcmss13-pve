/obj/structure/droppod/tech
	name = "\improper USCM空投舱"
	var/time_until_return = 2 MINUTES

/obj/structure/droppod/tech/Initialize(mapload, contents_name = "空")
	. = ..()
	name += " ([contents_name])"

/obj/structure/droppod/tech/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user) || !(droppod_flags & DROPPOD_OPEN))
		return

/obj/structure/droppod/tech/post_land()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(recall)), time_until_return)
