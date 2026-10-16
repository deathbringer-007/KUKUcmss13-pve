//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "玻璃盒"
	desc = "装有植入物的盒子。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_TINY
	var/obj/item/implant/imp = null

/obj/item/implantcase/proc/update()
	if (imp)
		icon_state = "implantcase-[imp.implant_color]"
	else
		icon_state = "implantcase-0"
	return

/obj/item/implantcase/attackby(obj/item/I as obj, mob/user as mob)
	..()
	if (HAS_TRAIT(I, TRAIT_TOOL_PEN))
		var/t = stripped_input(user, "你想在标签上写什么？", text("[]", src.name), null)
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && src.loc != user))
			return
		if(t)
			src.name = text("玻璃盒 - '[]'", t)
		else
			src.name = "玻璃盒"
	else if(istype(I, /obj/item/reagent_container/syringe))
		if(!src.imp) return
		if(!src.imp.allow_reagents) return
		if(src.imp.reagents.total_volume >= src.imp.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[src]已经满了。"))
		else
			spawn(5)
				I.reagents.trans_to(src.imp, 5)
				to_chat(user, SPAN_NOTICE("你注入了5单位溶液。注射器中还剩[I.reagents.total_volume]单位。"))
	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if (M.imp)
			if ((src.imp || M.imp.implanted))
				return
			M.imp.forceMove(src)
			src.imp = M.imp
			M.imp = null
			src.update()
			M.update()
		else
			if (src.imp)
				if (M.imp)
					return
				src.imp.forceMove(M)
				M.imp = src.imp
				src.imp = null
				update()
			M.update()
	return


/obj/item/implantcase/tracking
	name = "玻璃盒 - '追踪'"
	desc = "装有追踪植入物的盒子。"
	icon_state = "implantcase-b"

/obj/item/implantcase/tracking/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/tracking( src )

/obj/item/implantcase/explosive
	name = "玻璃盒 - '爆炸'"
	desc = "装有爆炸植入物的盒子。"
	icon_state = "implantcase-r"

/obj/item/implantcase/explosive/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/explosive( src )


/obj/item/implantcase/chem
	name = "玻璃盒 - '化学'"
	desc = "装有化学植入物的盒子。"
	icon_state = "implantcase-b"

/obj/item/implantcase/chem/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/chem( src )

/obj/item/implantcase/loyalty
	name = "玻璃盒 - '维兰德-汤谷'"
	desc = "装有维兰德-汤谷植入物的盒子。"
	icon_state = "implantcase-r"

/obj/item/implantcase/loyalty/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/loyalty( src )

/obj/item/implantcase/death_alarm
	name = "玻璃盒 - '死亡警报'"
	desc = "装有死亡警报植入物的盒子。"
	icon_state = "implantcase-b"

/obj/item/implantcase/death_alarm/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/death_alarm( src )

/obj/item/implantcase/freedom
	name = "玻璃盒 - '脱困'"
	desc = "装有脱困植入物的盒子。"
	icon_state = "implantcase-r"

/obj/item/implantcase/freedom/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/freedom( src )

/obj/item/implantcase/adrenalin
	name = "玻璃盒 - '肾上腺素'"
	desc = "装有肾上腺素植入物的盒子。"
	icon_state = "implantcase-b"

/obj/item/implantcase/adrenalin/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/adrenalin( src )

/obj/item/implantcase/dexplosive
	name = "玻璃盒 - '爆炸'"
	desc = "装有爆炸物的盒子。"
	icon_state = "implantcase-r"

/obj/item/implantcase/dexplosive/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/dexplosive( src )


/obj/item/implantcase/health
	name = "玻璃盒 - '健康监测'"
	desc = "装有健康监测植入物的盒子。"
	icon_state = "implantcase-b"

/obj/item/implantcase/health/Initialize(mapload, ...)
	. = ..()
	imp = new /obj/item/implant/health( src )
