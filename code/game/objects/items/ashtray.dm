/obj/item/ashtray
	icon = 'icons/obj/items/ashtray.dmi'

	var/max_butts = 0
	var/empty_desc = ""
	var/icon_empty = ""
	var/icon_half = ""
	var/icon_full = ""
	var/icon_broken = ""

/obj/item/ashtray/attackby(obj/item/W as obj, mob/user as mob)
	if (health < 1)
		return
	if (istype(W,/obj/item/trash/cigbutt) || istype(W,/obj/item/clothing/mask/cigarette) || istype(W, /obj/item/tool/match))
		if (length(contents) >= max_butts)
			to_chat(user, "这个烟灰缸已经满了。")
			return
		var/drop = TRUE

		if (istype(W,/obj/item/clothing/mask/cigarette))
			var/obj/item/clothing/mask/cigarette/cig = W
			if(cig.type_butt)
				if(cig.heat_source)
					user.visible_message("[user]把[cig]按在[src]里碾灭了。", "你把[cig]按在[src]里碾灭了。")
					var/obj/item/butt = cig.go_out(user, TRUE)
					butt.forceMove(src)
					drop = FALSE
				else if (cig.heat_source == 0)
					to_chat(user, "你连一口都没抽，就把[cig]放进了[src]。何必呢？")
			else
				drop = FALSE
				var/obj/item/clothing/mask/cigarette/pipe/P = W
				if(P.ash)
					user.visible_message("[user]把[P]里的烟灰倒进了[src]。", "你把[P]里的烟灰倒进了[src]。")
					P.ash = FALSE
				else
					to_chat(user, "[P]里没有烟灰。")

		if(drop)
			user.visible_message("[user]把[W]放进了[src]。", "你把[W]放进了[src]。")
			user.drop_inv_item_to_loc(W, src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		add_fingerprint(user)
		if (length(contents) == max_butts)
			icon_state = icon_full
			desc = empty_desc + "里面已经塞满了。"
		else if (length(contents) > max_butts/2)
			icon_state = icon_half
			desc = empty_desc + "里面已经装了一半。"
	else
		health = max(0,health - W.force)
		to_chat(user, "你用[W]敲打[src]。")
		if (health < 1)
			die()
	return

/obj/item/ashtray/launch_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (health < 1)
			die()
			return
		if (length(contents))
			src.visible_message(SPAN_DANGER("[src]猛地撞上[hit_atom]，里面的东西洒了出来！"))
		for (var/obj/item/clothing/mask/cigarette/O in contents)
			O.forceMove(src.loc)
		icon_state = icon_empty
	return ..()

/obj/item/ashtray/proc/die()
	src.visible_message(SPAN_DANGER("[src]碎裂了，里面的东西洒了一地！"))
	for (var/obj/item/clothing/mask/cigarette/O in contents)
		O.forceMove(src.loc)
	icon_state = icon_broken

/obj/item/ashtray/plastic
	name = "塑料烟灰缸"
	desc = "廉价的塑料烟灰缸。"
	icon_state = "ashtray_bl"
	icon_empty = "ashtray_bl"
	icon_half  = "ashtray_half_bl"
	icon_full  = "ashtray_full_bl"
	icon_broken  = "ashtray_bork_bl"
	max_butts = 14
	health = 24
	matter = list("metal" = 30,"glass" = 30)
	empty_desc = "廉价的塑料烟灰缸。"
	throwforce = 3

/obj/item/ashtray/plastic/die()
	..()
	name = "塑料碎片"
	desc = "沾着烟灰的塑料碎片。"
	return


/obj/item/ashtray/bronze
	name = "青铜烟灰缸"
	desc = "厚重的青铜烟灰缸。"
	icon_state = "ashtray_br"
	icon_empty = "ashtray_br"
	icon_half  = "ashtray_half_br"
	icon_full  = "ashtray_full_br"
	icon_broken  = "ashtray_bork_br"
	max_butts = 10
	health = 72
	matter = list("metal" = 80)
	empty_desc = "厚重的青铜烟灰缸。"
	throwforce = 10

/obj/item/ashtray/bronze/die()
	..()
	name = "青铜碎片"
	desc = "沾着烟灰的青铜碎片。"
	return


/obj/item/ashtray/glass
	name = "玻璃烟灰缸"
	desc = "玻璃烟灰缸。看起来很容易碎。"
	icon_state = "ashtray_gl"
	icon_empty = "ashtray_gl"
	icon_half  = "ashtray_half_gl"
	icon_full  = "ashtray_full_gl"
	icon_broken  = "ashtray_bork_gl"
	max_butts = 12
	health = 12
	matter = list("glass" = 60)
	empty_desc = "玻璃烟灰缸。看起来很容易碎。"
	throwforce = 6

/obj/item/ashtray/glass/die()
	..()
	name = "玻璃碎片"
	desc = "沾着烟灰的玻璃碎片。"
	playsound(src, "glassbreak", 25, 1)
	return
