/datum/supply_packs/medical
	name = "medical crate"
	localized_name = "医疗用品箱"
	contains = list(
		/obj/item/storage/box/syringes,
		/obj/item/reagent_container/glass/bottle/inaprovaline,
		/obj/item/reagent_container/glass/bottle/antitoxin,
		/obj/item/reagent_container/glass/bottle/bicaridine,
		/obj/item/reagent_container/glass/bottle/dexalin,
		/obj/item/reagent_container/glass/bottle/kelotane,
		/obj/item/reagent_container/glass/bottle/tramadol,
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dexalin,
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/box/pillbottles,
	)
	cost = 15
	containertype = /obj/structure/closet/crate/medical
	containername = "医疗用品箱"
	group = "Medical"

/datum/supply_packs/medical_restock_cart
	name = "medical restock cart"
	localized_name = "医疗补货推车"
	contains = list(
		/obj/structure/restock_cart/medical,
	)
	cost = 20
	containertype = null
	containername = "医疗补货推车"
	group = "Medical"

/datum/supply_packs/medical_reagent_cart
	name = "medical reagent restock cart"
	localized_name = "医疗试剂补货推车"
	contains = list(
		/obj/structure/restock_cart/medical/reagent,
	)
	cost = 20
	containertype = null
	containername = "医疗试剂补货推车"
	group = "Medical"

/datum/supply_packs/pillbottle
	name = "pill bottle crate (x2 each)"
	localized_name = "药瓶箱（每种2瓶）"
	contains = list(
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dexalin,
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/antitox,
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dexalin,
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/peridaxon,
		/obj/item/storage/box/pillbottles,
		/obj/item/storage/box/pillbottles,
	)
	cost = 15
	containertype = /obj/structure/closet/crate/medical
	containername = "医疗用品箱"
	group = "Medical"

/datum/supply_packs/firstaid
	name = "first aid kit crate (x2 each)"
	localized_name = "急救箱补给箱（每种2个）"
	contains = list(
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/adv,
		/obj/item/storage/firstaid/adv,
	)
	cost = 11
	containertype = /obj/structure/closet/crate/medical
	containername = "医疗用品箱"
	group = "Medical"

/datum/supply_packs/bodybag
	name = "body bag crate (x28)"
	localized_name = "尸袋箱（28个）"
	contains = list(
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/bodybags,
	)
	cost = 7
	containertype = /obj/structure/closet/crate/medical
	containername = "尸袋箱"
	group = "Medical"

/datum/supply_packs/cryobag
	name = "stasis bag crate (x3)"
	localized_name = "静滞袋箱（3个）"
	contains = list(
		/obj/item/bodybag/cryobag,
		/obj/item/bodybag/cryobag,
		/obj/item/bodybag/cryobag,
	)
	cost = 15
	containertype = /obj/structure/closet/crate/medical
	containername = "静滞袋箱"
	group = "Medical"

/datum/supply_packs/surgery
	name = "surgery crate(tray,anesthetic,surgeon gear)"
	localized_name = "手术用品箱（托盘、麻醉剂、外科医生装备）"
	contains = list(
		/obj/item/storage/surgical_tray,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/tank/anesthetic,
		/obj/item/clothing/under/rank/medical/green,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
	)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/surgery
	containername = "手术用品箱"
	access = ACCESS_MARINE_MEDBAY
	group = "Medical"

/datum/supply_packs/upgraded_medical_kits
	name = "upgraded medical equipment crate (x4)"
	localized_name = "升级医疗设备箱（4件）"
	contains = list(
		/obj/item/storage/box/czsp/medic_upgraded_kits,
		/obj/item/storage/box/czsp/medic_upgraded_kits,
		/obj/item/storage/box/czsp/medic_upgraded_kits,
		/obj/item/storage/box/czsp/medic_upgraded_kits,
	)
	cost = 0
	buyable = FALSE
	containertype = /obj/structure/closet/crate/medical
	containername = "升级医疗设备箱"
	group = "Medical"
