// Group to populate with all the explosives exept OB and mortar shell

/datum/supply_packs/explosives
	name = "surplus explosives crate (claymore mine x5, M40 HIDP x2, M40 HEDP x2, M15 Frag x2, M12 Blast x2, M40 MFHS x2)"
	localized_name = "剩余库存爆炸物箱（阔剑地雷5枚，M40 HIDP、M40 HEDP、M15破片、M12爆破、M40 MFHS手榴弹各2枚）"
	contains = list(
		/obj/item/storage/box/explosive_mines,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/high_explosive,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/m15,
		/obj/item/explosive/grenade/high_explosive/pmc,
		/obj/item/explosive/grenade/high_explosive/pmc,
		/obj/item/explosive/grenade/metal_foam,
		/obj/item/explosive/grenade/metal_foam,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper 爆炸物箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_mines
	name = "claymore mines crate (x10)"
	localized_name = "阔剑地雷箱（10枚）"
	contains = list(
		/obj/item/storage/box/explosive_mines,
		/obj/item/storage/box/explosive_mines,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper 爆炸地雷补给箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_m15
	name = "M15 fragmentation grenades crate (x6)"
	localized_name = "M15破片手榴弹箱（6枚）"
	contains = list(
		/obj/item/storage/box/packet/m15,
		/obj/item/storage/box/packet/m15,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M15爆炸手榴弹箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_plastic
	name = "plastic explosives crate (x3)"
	localized_name = "塑性炸药箱（3份）"
	contains = list(
		/obj/item/explosive/plastic,
		/obj/item/explosive/plastic,
		/obj/item/explosive/plastic,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper 塑性炸药箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_breaching_charge
	name = "breaching charge crate (x4)"
	localized_name = "破门炸药箱（4份）"
	contains = list(
		/obj/item/explosive/plastic/breaching_charge,
		/obj/item/explosive/plastic/breaching_charge,
		/obj/item/explosive/plastic/breaching_charge,
		/obj/item/explosive/plastic/breaching_charge,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper 塑性炸药箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_incendiary
	name = "M40 HIDP incendiary grenades crate (x6)"
	localized_name = "M40 HIDP燃烧手榴弹箱（6枚）"
	contains = list(
		/obj/item/storage/box/packet/incendiary,
		/obj/item/storage/box/packet/incendiary,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M40 HIDP爆炸燃烧手榴弹箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_M40_HEDP
	name = "M40 HEDP blast grenades crate (x6)"
	localized_name = "M40 HEDP爆破手榴弹箱（6枚）"
	contains = list(
		/obj/item/storage/box/packet/high_explosive,
		/obj/item/storage/box/packet/high_explosive,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M40 HEDP爆炸手榴弹箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_sebb
	name = "G2 electroshock grenades crate (x6)"
	localized_name = "G2电击手榴弹箱（6枚）"
	contains = list(
		/obj/item/storage/box/packet/sebb,
		/obj/item/storage/box/packet/sebb,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper G2电击手榴弹箱（警告）"
	group = "Explosives"


/datum/supply_packs/explosives_hedp
	name = "M40 HEDP blast grenade box crate (x25)"
	localized_name = "M40 HEDP爆破手榴弹补给箱（25枚）"
	contains = list(
		/obj/item/ammo_box/magazine/nade_box,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper HEDP爆炸手榴弹箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_M40_CCDP
	name = "M40 CCDP chemical compound grenades crate (x6)"
	localized_name = "M40 CCDP化学复合手榴弹箱（6枚）"
	contains = list(
		/obj/item/storage/box/packet/phosphorus,
		/obj/item/storage/box/packet/phosphorus,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M40 CCDP手榴弹箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_M40_CCDP_crate
	name = "M40 WPDP chemical compund grenade box crate (x25)"
	localized_name = "M40 WPDP化学复合手榴弹补给箱（25枚）"
	contains = list(
		/obj/item/ammo_box/magazine/nade_box/phophorus,
	)
	cost = 100
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper CCDP手榴弹箱（警告）"
	group = "Explosives"

/datum/supply_packs/explosives_M40_HEFA
	name = "M40 HEFA fragmentation grenades crate (x6)"
	localized_name = "M40 HEFA破片手榴弹箱（6枚）"
	contains = list(
		/obj/item/storage/box/packet/hefa,
		/obj/item/storage/box/packet/hefa,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/explosives
	containername = "\improper M40 HEFA爆炸手榴弹箱（警告）"
	group = "Explosives"
