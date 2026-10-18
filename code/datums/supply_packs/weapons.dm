/datum/supply_packs/m56_hmg
	name = "M56D Heavy Machine Gun (x1)"
	localized_name = "M56D重机枪（1挺）"
	contains = list(
		/obj/item/storage/box/guncase/m56d,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "M56D机枪箱"
	group = "Weapons"

/datum/supply_packs/m2c_hmg
	name = "M2C Heavy Machine Gun (x1)"
	localized_name = "M2C重机枪（1挺）"
	contains = list(
		/obj/item/storage/box/guncase/m2c,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/weapon
	containername = "M2C机枪箱"
	group = "Weapons"

/datum/supply_packs/flamethrower
	name = "M240 Flamethrower Crate (M240 x2, Broiler-T Fuelback x2)"
	localized_name = "M240喷火器箱（M240喷火器2具、Broiler-T燃料背包2个）"
	contains = list(
		/obj/item/storage/box/guncase/flamer,
		/obj/item/storage/box/guncase/flamer,
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
		/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "M240焚烧器箱"
	group = "Weapons"

/datum/supply_packs/grenade_launchers
	name = "M79 Grenade Launcher Crate (x2 Guncases)"
	localized_name = "M79榴弹发射器箱（枪盒2个）"
	contains = list(
		/obj/item/storage/box/guncase/m79,
		/obj/item/storage/box/guncase/m79,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "M79榴弹发射器箱"
	group = "Weapons"

/datum/supply_packs/mou53
	name = "MOU-53 Break Action Shotgun Crate (x2)"
	localized_name = "MOU-53折管式霰弹枪箱（2支）"
	contains = list(
		/obj/item/storage/box/guncase/mou53,
		/obj/item/storage/box/guncase/mou53,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "MOU-53折管式霰弹枪箱"
	group = "Weapons"

/datum/supply_packs/xm51
	name = "XM51 Breaching Scattergun Crate (x2)"
	localized_name = "XM51破门霰弹枪箱（2支）"
	contains = list(
		/obj/item/storage/box/guncase/xm51,
		/obj/item/storage/box/guncase/xm51,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "XM51破门霰弹枪箱"
	group = "Weapons"

/datum/supply_packs/smartpistol
	name = "SU-6 Smart Pistol Crate (x2)"
	localized_name = "SU-6智能手枪箱（2支）"
	contains = list(
		/obj/item/storage/box/guncase/smartpistol,
		/obj/item/storage/box/guncase/smartpistol,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "SU-6智能手枪箱"
	group = "Weapons"

/datum/supply_packs/vp78
	name = "VP-78 Hand Cannon Crate (x2)"
	localized_name = "VP-78大口径手枪箱（2支）"
	contains = list(
		/obj/item/storage/box/guncase/vp78,
		/obj/item/storage/box/guncase/vp78,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/weapon
	containername = "VP-78大口径手枪箱"
	group = "Weapons"

/datum/supply_packs/gun
	contains = list(
		/obj/item/weapon/gun/rifle/m41aMK1,
		/obj/item/weapon/gun/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1,
	)
	name = "M41A MK1 Rifle Crate (x2 MK1, x2 magazines)"
	localized_name = "M41A MK1步枪箱（MK1步枪2支、弹匣2个）"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "M41A MK1步枪箱"
	group = "Weapons"

/datum/supply_packs/gun/heavyweapons
	contains = list(
		/obj/item/storage/box/guncase/lmg,
		/obj/item/storage/box/guncase/lmg,
	)
	name = "M41AE2 HPR crate (HPR x2, HPR ammo box x2)"
	localized_name = "M41AE2重型脉冲步枪箱（重型脉冲步枪2支、配套弹药盒2个）"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper M41AE2重型脉冲步枪箱"
	group = "Weapons"

/datum/supply_packs/gun/xm88
	contains = list(
		/obj/item/storage/box/guncase/xm88,
		/obj/item/storage/box/guncase/xm88,
	)
	name = "XM88 Heavy Rifle crate (XM88 x2)"
	localized_name = "XM88重型步枪箱（XM88步枪2支）"
	cost = 40
	containertype = /obj/structure/closet/crate/weapon
	containername = "\improper XM88重型步枪箱"
	group = "Weapons"

/* Uncomment me if it's decided to let the m707 be purchasable through req
/datum/supply_packs/gun/m707
	name = "M707 Anti-Materiel Rifle crate (M707 x1)"
	contains = list()
	cost = 120
	containertype = /obj/structure/closet/crate/secure/vulture
	containername = "M707 crate"
	group = "Weapons"
*/

/datum/supply_packs/gun/merc
	contains = list()
	name = "black market firearms (x1)"
	localized_name = "黑市枪械（1支）"
	cost = 40
	contraband = 1
	containertype = /obj/structure/largecrate/guns/merc
	containername = "\improper 黑市枪械箱"
	group = "Weapons"
