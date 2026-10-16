/obj/item/stack/light_w
	name = "布线玻璃地砖"
	singular_name = "布线玻璃地砖"
	desc = "一块不知道怎么接上了电线的玻璃地砖。"
	icon_state = "glass_wire"
	w_class = SIZE_MEDIUM
	force = 3
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 60
	stack_id = "wired glass tile"

/obj/item/stack/light_w/attackby(obj/item/O as obj, mob/user as mob)
	..()
	if(HAS_TRAIT(O, TRAIT_TOOL_WIRECUTTERS))
		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 5
		amount--
		new/obj/item/stack/sheet/glass(user.loc)
		if(amount <= 0)
			user.temp_drop_inv_item(src)
			qdel(src)

	if(istype(O,/obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		if (M.use(1))
			new/obj/item/stack/tile/light(user.loc, 1)
			use(1)
			to_chat(user, SPAN_NOTICE("你制作了一块发光地砖。"))
		else
			to_chat(user, SPAN_WARNING("你还需要一块金属板才能完成发光地砖。"))
		return
