/obj/structure/machinery/cm_vending/sorted/supplies
	name = "补给柜"
	desc = "装有各种补给物资的柜子。"
	icon = 'icons/obj/structures/machinery/lifeboat.dmi'
	icon_state = "supplycab"
	vend_delay = 0.3 SECONDS
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/supplies/lifeboat
	name = "救生艇壁柜"
	desc = "装有求生物资的壁挂式应急柜。"
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	density = FALSE

	listed_products = list(

			list("食品与饮料", -1, null, null),
			list("即食军粮", 25, /obj/item/storage/box/mre, VENDOR_ITEM_REGULAR),
			list("瓶装水", 25, /obj/item/reagent_container/food/drinks/cans/waterbottle, VENDOR_ITEM_REGULAR),

			list("实用工具", -1, null, null),
			list("M94标记照明棒包", 5, /obj/item/storage/box/flare, VENDOR_ITEM_REGULAR),
			list("M5刺刀", 8, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
			list("手持无线电", 5, /obj/item/device/radio, VENDOR_ITEM_REGULAR),
			list("一副UNO牌", 5, /obj/item/toy/deck/uno, VENDOR_ITEM_REGULAR),

			list("服装", -1, null, null),
			list("防毒面具", 15, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
			list("吸热头套", 15, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
			)
