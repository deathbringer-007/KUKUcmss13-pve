//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	flags_equip_slot = SLOT_HEAD

/obj/item/holder/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/holder/process()

	if(istype(loc,/turf) || !(length(contents)))

		for(var/mob/M in contents)

			var/atom/movable/mob_container
			mob_container = M
			M.invisibility = initial(invisibility)
			mob_container.forceMove(get_turf(src))
			M.reset_view()

		qdel(src)

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

/obj/item/holder/proc/show_message(message, m_type)
	for(var/mob/living/M in contents)
		M.show_message(message,m_type)

/obj/item/holder/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)]这是[src]。"
	if(desc)
		. += desc
	if(desc_lore)
		. += SPAN_NOTICE("它有一段<a href='byond://?src=\ref[src];desc_lore=1'>详细背景描述</a>。")


//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(mob/living/carbon/grabber)
	if(!holder_type)
		return
	if(isxeno(grabber))
		to_chat(grabber, SPAN_WARNING("你放过了[src]。它无法成为宿主，对我们没有用处。"))
		return
	if(locate(/obj/item/explosive/plastic) in contents)
		to_chat(grabber, SPAN_WARNING("你放过了[src]。它身上有已经启动的爆炸物！"))
		return

	var/obj/item/holder/mob_holder = new holder_type(loc)
	forceMove(mob_holder)
	mob_holder.name = name
	mob_holder.desc = desc
	mob_holder.gender = gender
	mob_holder.attack_hand(grabber)
	invisibility = INVISIBILITY_MAXIMUM

	to_chat(grabber, "你把[src]捧了起来。")
	to_chat(src, "[grabber]把你捧了起来。")
	grabber.status_flags |= PASSEMOTES
	return

//Mob specific holders.

/obj/item/holder/drone
	name = "维护无人机"
	desc = "一台小型维护机器人。"
	icon_state = "drone"

/obj/item/holder/cat
	name = "猫"
	desc = "一种家养猫科宠物。它往往会主动认领船员当主人。"
	icon_state = "cat2"

/obj/item/holder/cat/kitten
	name = "小猫"
	desc = "哎呀，真可爱。"

/obj/item/holder/cat/Jones
	name = "琼斯"
	desc = "一只顽强的老流浪猫，似乎没人知道它从哪里来。"

/obj/item/holder/cat/blackcat
	name = "黑猫"
	desc = "一只猫，这回是黑色的！"
	icon_state = "cat"

/obj/item/holder/cat/blackcat/Runtime
	name = "运行时"
	desc = "她的毛发看起来、摸起来都像天鹅绒，尾巴偶尔会轻轻颤动。"

/obj/item/holder/kitten
	name = "小猫"
	desc = "哎呀，真可爱。"
	icon_state = "cat2"

/obj/item/holder/mouse
	name = "老鼠"
	desc = "一只小老鼠。"
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_white"
	w_class = SIZE_TINY;
	flags_equip_slot = null

/obj/item/holder/mouse/white
	icon_state = "mouse_white"

/obj/item/holder/mouse/gray
	icon_state = "mouse_gray"

/obj/item/holder/mouse/brown
	icon_state = "mouse_brown"

/obj/item/holder/mouse/white/Doc
	name = "博士"
	desc = "阿尔迈耶号的资深研究员。爱好：奶酪、实验、爆炸。"

/obj/item/holder/mouse/brown/Tom
	name = "汤姆"
	desc = "猫咪杰瑞对此并不开心。"
