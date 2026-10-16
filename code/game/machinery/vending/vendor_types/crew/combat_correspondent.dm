//------------ CC CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_combat_correspondent, list(
		list("标准装备（全部领取）", 0, null, null, null),
		list("记者基础装备套装", 0, /obj/effect/essentials_set/cc, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("皮革挎包", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("民用装备（全部领取）", 0, null, null, null),
		list("便携式新闻传真机", 0, /obj/item/device/fax_backpack, CIVILIAN_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("新闻广播摄像机", 0, /obj/item/device/camera/broadcasting, CIVILIAN_CAN_BUY_UTILITY, VENDOR_ITEM_RECOMMENDED),

		list("制服（选一套）", 0, null, null, null),
		list("黑色制服", 0, /obj/item/clothing/under/marine/reporter/black, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("橙色制服", 0, /obj/item/clothing/under/marine/reporter/orange, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("红色制服", 0, /obj/item/clothing/under/marine/reporter/red, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("护甲（选一件）", 0, null, null, null),
		list("战地记者护甲", 0, /obj/item/clothing/suit/storage/marine/light/reporter, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("蓝色背心", 0, /obj/item/clothing/suit/storage/jacket/marine/reporter/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("黑色背心", 0, /obj/item/clothing/suit/storage/hazardvest/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("黑色外套", 0, /obj/item/clothing/suit/storage/jacket/marine/reporter/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("绿色外套", 0, /obj/item/clothing/suit/storage/jacket/marine/reporter/green, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("头部装备（选一件）", 0, null, null, null),
		list("战地记者头盔", 0, /obj/item/clothing/head/helmet/marine/reporter, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("战地记者便帽", 0, /obj/item/clothing/head/cmcap/reporter, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("软呢帽", 0, /obj/item/clothing/head/fedora, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("补充用品", 0, null, null, null),
		list("相机", 10, /obj/item/device/camera, null, VENDOR_ITEM_REGULAR),
		list("相机胶卷", 5, /obj/item/device/camera_film, null, VENDOR_ITEM_REGULAR),
		list("碳粉", 5, /obj/item/device/toner, null, VENDOR_ITEM_REGULAR),
		list("制式录音带", 15, /obj/item/storage/box/tapes, null, VENDOR_ITEM_REGULAR),
		list("纸张盒", 10, /obj/item/paper_bin/uscm, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/combat_correspondent
	name = "ColMarTech战地记者装备架"
	desc = "连接着大型仓库的自动装备架，提供记者的制式装备。"
	req_access = list(ACCESS_PRESS)
	vendor_role = list(JOB_COMBAT_REPORTER)

/obj/structure/machinery/cm_vending/clothing/combat_correspondent/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_combat_correspondent

/obj/effect/essentials_set/cc
	spawned_gear_list = list(
		/obj/item/device/flashlight,
		/obj/item/tool/pen,
		/obj/item/device/binoculars,
		/obj/item/notepad,
		/obj/item/device/taperecorder,
	)
