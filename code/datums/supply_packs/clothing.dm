/datum/supply_packs/pouches_ammo
	name = "Large Pouch 2x(pistol,magazine,general)"
	localized_name = "大型附包（手枪、弹匣、通用型各2个）"
	contains = list(
		/obj/item/storage/pouch/magazine/large,
		/obj/item/storage/pouch/magazine/large,
		/obj/item/storage/pouch/magazine/pistol/large,
		/obj/item/storage/pouch/magazine/pistol/large,
		/obj/item/storage/pouch/general,
		/obj/item/storage/pouch/general,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "大型附包"
	group = "Clothing"

/datum/supply_packs/pouches_medical
	name = "medical pouches crate (1x firstaid, medical, syringe, medkit, autoinjector)"
	localized_name = "医疗附包箱（急救、医疗、注射器、医疗包、自动注射器型各1个）"
	contains = list(
		/obj/item/storage/pouch/firstaid,
		/obj/item/storage/pouch/medical,
		/obj/item/storage/pouch/syringe,
		/obj/item/storage/pouch/medkit,
		/obj/item/storage/pouch/autoinjector,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "医疗附包箱"
	group = "Clothing"

//---------------------------------------------
//HOLSTERS & WEBBING BELOW THIS LINE
//---------------------------------------------

/datum/supply_packs/webbing_brown_black
	name = "Brown And Black Webbing Crate (x2 each)"
	localized_name = "棕色与黑色装具箱（各2件）"
	contains = list(
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest/brown_vest,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/accessory/storage/black_vest,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/green
	containername = "棕色与黑色装具箱"
	group = "Clothing"

/datum/supply_packs/webbing_large
	name = "Webbing Crate (x4)"
	localized_name = "装具箱（4件）"
	contains = list(
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbing,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/green
	containername = "装具箱"
	group = "Clothing"

/datum/supply_packs/drop_pouches
	name = "Drop Pouch Crate (x4)"
	localized_name = "垂挂附包箱（4个）"
	contains = list(
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
		/obj/item/clothing/accessory/storage/droppouch,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/green
	containername = "垂挂附包箱"
	group = "Clothing"


/datum/supply_packs/webbing_knives//for the lulz
	name = "Knife Vest Crate (x3)"
	localized_name = "刀具背心箱（3件）"
	contains = list(
		/obj/item/clothing/accessory/storage/knifeharness,//old unathi knife harness updated for our needs
		/obj/item/clothing/accessory/storage/knifeharness,
		/obj/item/clothing/accessory/storage/knifeharness
	)
	cost = 30
	containertype = /obj/structure/closet/crate/green
	containername = "刀具背心箱"
	group = "Clothing"

/datum/supply_packs/webbing_holster
	name = "Shoulder Holster Crate (x4)"
	localized_name = "肩挂枪套箱（4个）"
	contains = list(
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
		/obj/item/clothing/accessory/storage/holster,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/green
	containername = "肩挂枪套箱"
	group = "Clothing"

/datum/supply_packs/gunslinger_holster
	contains = list(
		/obj/item/storage/belt/gun/m44/gunslinger,
		/obj/item/storage/belt/gun/m44/gunslinger,
	)
	name = "Red Ranger Cowboy Gunbelt Crate (x2)"
	localized_name = "红衣游侠牛仔枪带箱（2条）"
	cost = 20
	contraband = 1
	containertype = /obj/structure/closet/crate
	containername = "牛仔装扮箱"
	group = "Clothing"

/datum/supply_packs/officer_outfits//lmao this shit is so hideously out of date
	contains = list(
		/obj/item/clothing/under/marine/officer/qm_suit,
		/obj/item/clothing/under/marine/officer/bridge,
		/obj/item/clothing/under/marine/officer/bridge,
		/obj/item/clothing/under/marine/dress,
		/obj/item/clothing/under/marine/officer/ce,
	)
	name = "officer outfit crate"
	localized_name = "军官服装箱"
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "军官礼服箱"
	group = "Clothing"
