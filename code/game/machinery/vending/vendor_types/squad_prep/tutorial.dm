GLOBAL_LIST_INIT(cm_vending_clothing_tutorial, list(
		list("标准装备（全部领取）", 0, null, null, null),
		list("陆战队制式服装", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/clothing/head/helmet/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),

		list("护甲（选一件）", 0, null, null, null),
		list("中型护甲", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("背包（选一个）", 0, null, null, null),
		list("挎包", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("腰带（选一条）", 0, null, null, null),
		list("M276弹药携行腰带", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("携行袋（选一个）", 0, null, null, null),
		list("照明棒袋（装满）", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),

	)) // The pouch uses a different category so they only get one

/obj/structure/machinery/cm_vending/clothing/tutorial
	name = "ColMarTech陆战队自动装备架"
	desc = "连接着大型仓库的自动装备架，提供陆战队步枪手的制式装备。"
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/tutorial/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial
