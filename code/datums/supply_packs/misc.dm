//*******************************************************************************
//SUPPLIES
//*******************************************************************************/

/datum/supply_packs/internals
	name = "oxygen internals crate (x3 masks, x3 tanks)"
	localized_name = "供氧设备箱（面罩3个、氧气罐3个）"
	contains = list(
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/tank/air,
		/obj/item/tank/air,
		/obj/item/tank/air,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/internals
	containername = "供氧设备箱"
	group = "Supplies"

/datum/supply_packs/evacuation
	name = "emergency equipment (x2 toolbox, x2 hazard vest, x5 oxygen tank, x5 masks)"
	localized_name = "应急装备（工具箱2个、警示背心2件、氧气罐5个、面罩5个）"
	contains = list(
		/obj/item/storage/toolbox/emergency,
		/obj/item/storage/toolbox/emergency,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tank/emergency_oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/internals
	containername = "应急装备箱"
	group = "Supplies"

/datum/supply_packs/boxes
	name = "empty boxes (x10)"
	localized_name = "空盒（10个）"
	contains = list(
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
		/obj/item/storage/box,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "空盒箱"
	group = "Supplies"

/datum/supply_packs/janitor
	name = "assorted janitorial supplies"
	localized_name = "各类清洁用品"
	contains = list(
		/obj/item/reagent_container/glass/bucket,
		/obj/item/reagent_container/glass/bucket,
		/obj/item/reagent_container/glass/bucket,
		/obj/item/tool/mop,
		/obj/item/tool/wet_sign,
		/obj/item/tool/wet_sign,
		/obj/item/tool/wet_sign,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_container/spray/cleaner,
		/obj/item/reagent_container/glass/rag,
		/obj/item/explosive/grenade/custom/cleaner,
		/obj/item/explosive/grenade/custom/cleaner,
		/obj/item/explosive/grenade/custom/cleaner,
		/obj/item/reagent_container/glass/bucket/mopbucket,
		/obj/item/paper/janitor,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper 清洁用品箱"
	group = "Supplies"

/datum/supply_packs/poster
	name = "posters"
	localized_name = "海报"
	contains = list(
		/obj/item/poster,
		/obj/item/poster,
		/obj/item/poster,
		/obj/item/poster,
		/obj/item/poster,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper 海报箱"
	group = "Supplies"

/datum/supply_packs/crayons
	name = "boxes of crayons"
	localized_name = "蜡笔盒"
	contains = list(
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/fancy/crayons,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper 蜡笔箱"
	group = "Supplies"

/datum/supply_packs/presents
	name = "assorted presents"
	localized_name = "各类礼物"
	contains = list(
		/obj/item/a_gift,
		/obj/item/a_gift,
		/obj/item/a_gift,
		/obj/item/a_gift,
		/obj/item/a_gift,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper 礼物箱"
	group = "Supplies"

/datum/supply_packs/wrapping_supplies
	name = "wrapping supplies"
	localized_name = "包装用品"
	contains = list(
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/wrapping_paper,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wirecutters,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper 包装用品箱"
	group = "Supplies"
