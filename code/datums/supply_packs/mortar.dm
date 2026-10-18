//group for putting all the items about mortar. mortar/shells/backpack...

//---------------------------------------------
//Backpacks
//---------------------------------------------

/datum/supply_packs/backpack/mortar_pack
	name = "Mortar Shell Backpack Crate (x4)"
	localized_name = "迫击炮弹背包箱（4个）"
	contains = list(
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/storage/backpack/marine/mortarpack,
	)
	cost = 30
	containername = "迫击炮弹背包箱"

/datum/supply_packs/mortar
	name = "M402 mortar crate (Mortar x1, Mortar shell backpack x1)"
	localized_name = "M402迫击炮箱（迫击炮1门、迫击炮弹背包1个）"
	contains = list(
		/obj/item/storage/backpack/marine/mortarpack,
		/obj/item/mortar_kit,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M402迫击炮箱"
	group = "Mortar"

//------------------------Mortar ammunition crates----------------

/datum/supply_packs/ammo_mortar_he
	name = "M402 mortar shells crate (x6 HE)"
	localized_name = "M402迫击炮弹箱（高爆弹6发）"
	cost = 20
	contains = list(
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
		/obj/item/mortar_shell/he,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402迫击炮高爆弹箱"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_incend
	name = "M402 mortar shells crate (x6 Incend)"
	localized_name = "M402迫击炮弹箱（燃烧弹6发）"
	cost = 20
	contains = list(
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
		/obj/item/mortar_shell/incendiary,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402迫击炮燃烧弹箱"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_flare
	name = "M402 mortar shells crate (x6 Flare/Camera)"
	localized_name = "M402迫击炮弹箱（照明／摄像弹6发）"
	cost = 20
	contains = list(
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
		/obj/item/mortar_shell/flare,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402迫击炮照明弹箱"
	group = "Mortar"

/datum/supply_packs/ammo_mortar_frag
	name = "M402 mortar shells crate (x6 Frag)"
	localized_name = "M402迫击炮弹箱（破片弹6发）"
	cost = 20
	contains = list(
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
		/obj/item/mortar_shell/frag,
	)
	containertype = /obj/structure/closet/crate/secure/mortar_ammo
	containername = "\improper M402迫击炮破片弹箱"
	group = "Mortar"
