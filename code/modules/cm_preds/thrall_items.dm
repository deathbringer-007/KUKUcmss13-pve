/obj/item/clothing/suit/armor/yautja/thrall
	name = "外星护甲"
	desc = "用碎布和奇异合金制成的护甲，触感冰冷，有着异样的重量。经过改造，可携带人类和外星近战武器。"

	icon = 'icons/obj/items/hunter/thrall_gear.dmi'
	icon_state = "chest1_cloth"
	item_state = "chest1_cloth"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/thrall_gear.dmi'
	)
	thrall = TRUE

	allowed = list(
		/obj/item/weapon/gun/launcher/spike,
		/obj/item/weapon/gun/energy/yautja,
		/obj/item/weapon,
	)

/obj/item/clothing/suit/armor/yautja/thrall/New(mapload, armor_area = pick("shoulders", "chest", "mix"), armor_number = rand(1,3), armor_material = pick("cloth", "bare"))
	if(armor_number > 3)
		armor_number = 1
	if(armor_number)
		icon_state = "[armor_area][armor_number]_[armor_material]"
		LAZYSET(item_state_slots, WEAR_JACKET, "[armor_area][armor_number]_[armor_material]")
	..()

/obj/item/clothing/shoes/yautja/thrall
	name = "外星护胫"
	desc = "用碎布和奇异合金制成的护胫，触感冰冷，有着异样的重量。经过改造，可兼容人类装备。"

	icon = 'icons/obj/items/hunter/thrall_gear.dmi'
	icon_state = "greaves1_cloth"
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/thrall_gear.dmi'
	)
	thrall = TRUE

	allowed_items_typecache = list(
		/obj/item/attachable/bayonet,
		/obj/item/weapon/throwing_knife,
		/obj/item/weapon/gun/pistol/holdout,
		/obj/item/weapon/gun/pistol/clfpistol,
		/obj/item/weapon/straight_razor,
	)

/obj/item/clothing/shoes/yautja/thrall/New(mapload, greaves_number = 1, armor_material = pick("cloth", "bare"))
	if(greaves_number > 1)
		greaves_number = 1
	if(greaves_number)
		icon_state = "greaves[greaves_number]_[armor_material]"
		LAZYSET(item_state_slots, WEAR_JACKET, "greaves[greaves_number]_[armor_material]")
	..()

/obj/item/clothing/under/chainshirt/thrall
	name = "外星网甲"
	color = "#b85440"
	desc = "用奇异合金编织成的背心，触感冰冷，有着异样的重量。经过改造，适合人类身体穿着。"

/obj/item/storage/box/bracer
	name = "外星盒子"
	desc = "一个刻着符文的奇异盒子。"
	color = "#68423b"
	icon = 'icons/obj/structures/closet.dmi'
	icon_state = "pred_coffin"
	foldable = FALSE

/obj/item/storage/box/bracer/fill_preset_inventory()
	new /obj/item/clothing/gloves/yautja/thrall(src)
