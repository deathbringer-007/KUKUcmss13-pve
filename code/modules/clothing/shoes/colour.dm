/obj/item/clothing/shoes/black
	name = "黑鞋"
	icon_state = "black"
	desc = "一双黑鞋。"

	flags_cold_protection = BODY_FLAG_FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	flags_heat_protection = BODY_FLAG_FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT

/obj/item/clothing/shoes/brown
	name = "棕鞋"
	desc = "一双棕鞋。"
	icon_state = "brown"

/obj/item/clothing/shoes/blue
	name = "蓝鞋"
	icon_state = "blue"

/obj/item/clothing/shoes/green
	name = "绿鞋"
	icon_state = "green"

/obj/item/clothing/shoes/yellow
	name = "黄鞋"
	icon_state = "yellow"

/obj/item/clothing/shoes/purple
	name = "紫鞋"
	icon_state = "purple"

/obj/item/clothing/shoes/red
	name = "红鞋"
	desc = "时髦的红鞋。"
	icon_state = "red"

/obj/item/clothing/shoes/red/knife
	name = "脏红鞋"
	desc = "时髦的红鞋，带有一个能藏刀的小空间。"
	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/tool/screwdriver,
		/obj/item/weapon/straight_razor,
	)

/obj/item/clothing/shoes/white
	name = "白鞋"
	icon_state = "white"
	permeability_coefficient = 0.01

/obj/item/clothing/shoes/leather
	name = "皮鞋"
	desc = "一双结实的皮鞋。"
	icon_state = "leather"

/obj/item/clothing/shoes/rainbow
	name = "彩虹鞋"
	desc = "一双充满同志骄傲色彩的鞋。"
	icon_state = "rain_bow"

/obj/item/clothing/shoes/orange
	name = "橙鞋"
	icon_state = "orange"
	var/obj/item/restraint/handcuffs/chained = null

/obj/item/clothing/shoes/orange/proc/attach_cuffs(obj/item/restraint/cuffs, mob/user as mob)
	if(chained)
		return FALSE

	user.drop_held_item()
	cuffs.forceMove(src)
	chained = cuffs
	slowdown = 15
	icon_state = "orange1"
	time_to_equip = (cuffs.breakouttime / 4)
	time_to_unequip = cuffs.breakouttime
	return TRUE

/obj/item/clothing/shoes/orange/proc/remove_cuffs(mob/user as mob)
	if(!chained)
		return FALSE

	user.put_in_hands(chained)
	chained.add_fingerprint(user)

	slowdown = initial(slowdown)
	icon_state = "orange"
	chained = null
	time_to_equip = initial(time_to_equip)
	time_to_unequip = initial(time_to_unequip)
	return TRUE

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/orange/attackby(attacking_object as obj, mob/user as mob)
	..()
	if(istype(attacking_object, /obj/item/restraint))
		var/obj/item/restraint/cuffs = attacking_object
		if(cuffs.target_zone == SLOT_LEGS)
			attach_cuffs(cuffs, user)

/obj/item/clothing/shoes/orange/get_examine_text(mob/user)
	. = ..()
	if(chained)
		. += SPAN_RED("鞋上锁着[chained]。")
