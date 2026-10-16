/obj/structure/coatrack
	name = "衣帽架"
	desc = "用来挂外套的架子。"
	icon = 'icons/obj/structures/props/misc.dmi'
	icon_state = "coatrack0"
	unslashable = TRUE
	var/obj/item/clothing/suit/coat
	var/list/allowed = list(/obj/item/clothing/suit/storage/labcoat, /obj/item/clothing/suit/storage/det_suit, /obj/item/clothing/suit/storage/bomber, /obj/item/clothing/suit/storage/bomber/alt)

/obj/structure/coatrack/attack_hand(mob/user as mob)
	if(coat)
		user.visible_message("[user]从[src]上取下了[coat]。", "你从[src]上取下了[coat]。")
		if(!user.put_in_active_hand(coat))
			coat.forceMove(get_turf(user))
		coat = null
		update_icon()

/obj/structure/coatrack/attackby(obj/item/W as obj, mob/user as mob)
	var/can_hang = 0
	for (var/T in allowed)
		if(istype(W,T))
			can_hang = 1
	if (can_hang && !coat)
		user.visible_message("[user]把[W]挂在了[src]上。", "你把[W]挂在了[src]上。")
		coat = W
		user.drop_held_item(src)
		coat.forceMove(src)
		update_icon()
	else
		to_chat(user, SPAN_NOTICE("你不能把[W]挂在[src]上。"))
		return ..()

/obj/structure/coatrack/Crossed(atom/movable/AM)
	..()
	if(!coat)
		for(var/T in allowed)
			if(istype(AM,T))
				src.visible_message("[AM]落在了[src]上。")
				coat = AM
				coat.forceMove(src)
				update_icon()
				break


/obj/structure/coatrack/update_icon()
	overlays.Cut()
	if(istype(coat, /obj/item/clothing/suit/storage/labcoat))
		overlays += image(icon, icon_state = "coat_lab")
	if(istype(coat, /obj/item/clothing/suit/storage/labcoat/cmo))
		overlays += image(icon, icon_state = "coat_cmo")
	if(istype(coat, /obj/item/clothing/suit/storage/det_suit))
		overlays += image(icon, icon_state = "coat_det")
