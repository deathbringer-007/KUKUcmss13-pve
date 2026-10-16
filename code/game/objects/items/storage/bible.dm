/obj/item/storage/bible
	name = "圣经"
	desc = "反复敲击头部使用。"
	icon = 'icons/obj/items/books.dmi'
	icon_state ="bible"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	cant_hold = list(
		/obj/item/tool/screwdriver,
		/obj/item/tool/crowbar,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/device/multitool,
		/obj/item/device/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/analyzer,
		/obj/item/tool/shovel/etool,
	)
	storage_slots = null
	max_storage_space = 8
	black_market_value = 15
	var/mob/affecting = null
	var/deity_name = "Christ"

/obj/item/storage/bible/booze
	name = "圣经"
	desc = "用于反复敲击头部。"
	icon_state ="bible"

/obj/item/storage/bible/booze/fill_preset_inventory()
	new /obj/item/reagent_container/food/drinks/cans/beer(src)
	new /obj/item/reagent_container/food/drinks/cans/beer(src)
	new /obj/item/spacecash(src)
	new /obj/item/spacecash(src)
	new /obj/item/spacecash(src)

/obj/item/storage/bible/hefa
	name = "高爆破片反人员手榴弹圣典"
	desc = "赞美克利尔斯迈尔牧师，是他将我们引入弹片的圣光！我们宣誓为HEFA之主献上神圣的侍奉。纵然人数寥寥，我们仍为沉默的芸芸众生发声！印制于RESS。"
	icon_state ="tome_hefa"

/obj/item/storage/bible/hefa/Initialize()
	. = ..()
	new /obj/item/explosive/grenade/high_explosive/frag(src)
	new /obj/item/explosive/grenade/high_explosive/frag(src)
	new /obj/item/explosive/grenade/high_explosive/frag(src)

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(user.job == "Chaplain")
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			to_chat(user, SPAN_NOTICE("你祝福了[A]。"))
			var/water2holy = A.reagents.get_reagent_amount("water")
			A.reagents.del_reagent("water")
			A.reagents.add_reagent("holywater",water2holy)

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if (use_sound)
		playsound(loc, use_sound, 25, TRUE, 6)
	..()
