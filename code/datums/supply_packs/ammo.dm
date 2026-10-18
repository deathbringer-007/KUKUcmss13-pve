//*******************************************************************************
//AMMO
//*******************************************************************************/

//------------------------Ammunition Boxes crates----------------

/datum/supply_packs/ammo_rounds_box_smg
	name = "SMG ammo box crate (10x20mm) (x600 rounds)"
	localized_name = "冲锋枪弹药箱（10x20毫米，600发）"
	contains = list(/obj/item/ammo_box/rounds/smg)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 冲锋枪弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_smg_ap
	name = "SMG AP ammo box crate (10x20mm AP) (x600 rounds)"
	localized_name = "冲锋枪穿甲弹药箱（10x20毫米穿甲弹，600发）"
	contains = list(/obj/item/ammo_box/rounds/smg/ap)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 冲锋枪穿甲弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_rifle
	name = "Rifle ammo box crate (10x24mm) (x600 rounds)"
	localized_name = "步枪弹药箱（10x24毫米，600发）"
	contains = list(/obj/item/ammo_box/rounds)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 步枪弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_rifle_ap
	name = "Rifle AP ammo box crate (10x24mm AP) (x600 rounds)"
	localized_name = "步枪穿甲弹药箱（10x24毫米穿甲弹，600发）"
	contains = list(/obj/item/ammo_box/rounds/ap)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 步枪穿甲弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_rounds_box_xm88
	name = ".458 bullets box crate (x300 rounds)"
	localized_name = ".458子弹补给箱（300发）"
	contains = list(/obj/item/ammo_box/magazine/lever_action/xm88)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper .458子弹补给箱"
	group = "Ammo"

//------------------------Magazine Boxes crates----------------

//------------------------For M41A----------------

/datum/supply_packs/ammo_mag_box
	name = "Magazine box (M41A, 10x regular mags)"
	localized_name = "弹匣箱（M41A，普通弹匣10个）"
	contains = list(
		/obj/item/ammo_box/magazine,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41A弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_mag_box_ap
	name = "Magazine box (M41A, 10x AP mags)"
	localized_name = "弹匣箱（M41A，穿甲弹匣10个）"
	contains = list(
		/obj/item/ammo_box/magazine/ap,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41A穿甲弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_mag_box_ext
	name = "Magazine box (M41A, 8x extended mags)"
	localized_name = "弹匣箱（M41A，加长弹匣8个）"
	contains = list(
		/obj/item/ammo_box/magazine/ext,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41A加长弹匣箱"
	group = "Ammo"

//------------------------For M49A----------------

/datum/supply_packs/ammo_dmr_mag_box
	name = "Magazine box (M49A, 16x regular mags)"
	localized_name = "弹匣箱（M49A，普通弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m49a,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M49A弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_dmr_mag_box_ap
	name = "Magazine box (M49A, 16x AP mags)"
	localized_name = "弹匣箱（M49A，穿甲弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m49a/ap,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M49A穿甲弹匣箱"
	group = "Ammo"

//------------------------For M39----------------

/datum/supply_packs/ammo_smg_mag_box
	name = "Magazine box (M39, 12x regular mags)"
	localized_name = "弹匣箱（M39，普通弹匣12个）"
	contains = list(
		/obj/item/ammo_box/magazine/m39,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M39高速弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_smg_mag_box_ap
	name = "Magazine box (M39, 12x AP mags)"
	localized_name = "弹匣箱（M39，穿甲弹匣12个）"
	contains = list(
		/obj/item/ammo_box/magazine/m39/ap,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M39穿甲弹匣箱"
	group = "Ammo"

//------------------------For M49A----------------

/datum/supply_packs/ammo_m49a_mag_box
	name = "Magazine box (M49A, 16x mags)"
	localized_name = "弹匣箱（M49A，弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m49a,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M49A弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_m49a_mag_box_ap
	name = "Magazine box (M49A, 16x AP mags)"
	localized_name = "弹匣箱（M49A，穿甲弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m49a/ap,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M49A穿甲弹匣箱"
	group = "Ammo"

//------------------------For  M44----------------

/datum/supply_packs/ammo_m44_mag_box
	name = "Speed loaders box (M44, 16x)"
	localized_name = "快速装弹器箱（M44，16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m44,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M44快速装弹器箱"
	group = "Ammo"

/datum/supply_packs/ammo_m44_mag_box_ap
	name = "Speed loaders box (Marksman M44, 16x)"
	localized_name = "快速装弹器箱（M44精确射击型，16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m44/marksman,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M44精确射击型快速装弹器箱"
	group = "Ammo"

/datum/supply_packs/ammo_m44_mag_box_heavy
	name = "Speed loaders box (Heavy M44, 16x)"
	localized_name = "快速装弹器箱（M44重型，16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m44/heavy,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M44重型快速装弹器箱"
	group = "Ammo"

//------------------------For  M4A3----------------

/datum/supply_packs/ammo_m4a3_mag_box
	name = "Magazine box (M4A3, 16x regular mags)"
	localized_name = "弹匣箱（M4A3，普通弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m4a3,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M4A3弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_m4a3_mag_box_ap
	name = "Magazine box (M4A3, 16x AP mags)"
	localized_name = "弹匣箱（M4A3，穿甲弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m4a3/ap,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M4A3穿甲弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_m4a3_mag_box_hp
	name = "Magazine box (M4A3, 16x HP mags)"
	localized_name = "弹匣箱（M4A3，空尖弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/m4a3/hp,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M4A3空尖弹匣箱"
	group = "Ammo"

//------------------------For  Shootgun ammo----------------

/datum/supply_packs/ammo_shell_box
	name = "Shell box (100x slug shells)"
	localized_name = "霰弹补给箱（独头弹100发）"
	contains = list(
		/obj/item/ammo_box/magazine/shotgun,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 霰弹枪独头弹箱"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box_buck
	name = "Shell box (100x buckshot shells)"
	localized_name = "霰弹补给箱（鹿弹100发）"
	contains = list(
		/obj/item/ammo_box/magazine/shotgun/buckshot,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 霰弹枪鹿弹箱"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box_flechette
	name = "Shell box (100x flechette shells)"
	localized_name = "霰弹补给箱（箭形霰弹100发）"
	contains = list(
		/obj/item/ammo_box/magazine/shotgun/flechette,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 霰弹枪箭形霰弹箱"
	group = "Ammo"

/datum/supply_packs/ammo_shell_box_breaching
	name = "Shell box (16g) (120x breaching shells)"
	localized_name = "霰弹补给箱（16号口径，破门弹120发）"
	contains = list(
		/obj/item/ammo_box/magazine/shotgun/light/breaching,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 霰弹枪破门弹箱"
	group = "Ammo"

//------------------------For vp70 ----------------

/datum/supply_packs/ammo_vp70_mag_box_ap
	name = "Magazine box (VP70, 16x mags)"
	localized_name = "弹匣箱（VP70，弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/vp70,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper VP70弹匣箱"
	group = "Ammo"

//------------------------Special or non common magazines----------------

/datum/supply_packs/ammo_vp78_mag_box
	name = "Magazine box (VP78, 16x mags)"
	localized_name = "弹匣箱（VP78，弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/vp78,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper VP78弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_su6_mag_box
	name = "Magazine box (SU-6, 16x mags)"
	localized_name = "弹匣箱（SU-6，弹匣16个）"
	contains = list(
		/obj/item/ammo_box/magazine/su6,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper SU-6弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_hpr
	contains = list(
		/obj/item/ammo_magazine/hpr_box,
		/obj/item/ammo_magazine/hpr_box,
		/obj/item/ammo_magazine/hpr_box,
		/obj/item/ammo_magazine/hpr_box,
	)
	name = "M41AE2 magazine crate"
	localized_name = "M41AE2弹匣箱"
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41AE2弹匣箱"
	group = "Ammo"

/datum/supply_packs/ammo_hpr_holo
	contains = list(
		/obj/item/ammo_magazine/hpr_box/holo_target,
		/obj/item/ammo_magazine/hpr_box/holo_target,
		/obj/item/ammo_magazine/hpr_box/holo_target,
		/obj/item/ammo_magazine/hpr_box/holo_target,
	)
	name = "M41AE2 magazine crate"
	localized_name = "M41AE2弹匣箱"
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M41AE2全息标记弹匣箱"
	group = "Ammo"

//------------------------Smartgunner stuff----------------

/datum/supply_packs/ammo_smartgun_battery_pack
	name = "M56 smartgun battery crate (x4)"
	localized_name = "M56智能机枪电池箱（4块）"
	contains = list(
		/obj/item/smartgun_battery,
		/obj/item/smartgun_battery,
		/obj/item/smartgun_battery,
		/obj/item/smartgun_battery,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 智能机枪电池箱"
	group = "Ammo"

/datum/supply_packs/ammo_smartgun
	name = "M56 smartgun drum crate (x2)"
	localized_name = "M56智能机枪弹鼓箱（2个）"
	contains = list(
		/obj/item/ammo_magazine/smartgun,
		/obj/item/ammo_magazine/smartgun,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 智能机枪弹鼓箱"
	group = "Ammo"

//------------------------Sentries Ammo----------------

/datum/supply_packs/ammo_sentry_shotgun
	name = "UA 12-G sentry shotgun ammunition (x2)"
	localized_name = "UA 12-G哨戒霰弹枪弹药（2份）"
	contains = list(
		/obj/item/ammo_magazine/sentry/shotgun,
		/obj/item/ammo_magazine/sentry/shotgun,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 哨戒霰弹枪弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_sentry_flamer
	name = "UA 42-F sentry flamer ammunition (x2)"
	localized_name = "UA 42-F哨戒喷火器燃料（2份）"
	contains = list(
		/obj/item/ammo_magazine/sentry_flamer,
		/obj/item/ammo_magazine/sentry_flamer,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 哨戒喷火器燃料箱"
	group = "Ammo"

/datum/supply_packs/ammo_mini_sentry_flamer
	name = "UA 45-F mini sentry flamer ammunition (x2)"
	localized_name = "UA 45-F微型哨戒喷火器燃料（2份）"
	contains = list(
		/obj/item/ammo_magazine/sentry_flamer/mini,
		/obj/item/ammo_magazine/sentry_flamer/mini,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 微型哨戒喷火器燃料箱"
	group = "Ammo"

/datum/supply_packs/ammo_glob_sentry_flamer
	name = "UA 60-FP sentry plasma incinerator tank (x2)"
	localized_name = "UA 60-FP哨戒等离子焚烧器燃料罐（2个）"
	contains = list(
		/obj/item/ammo_magazine/sentry_flamer/glob,
		/obj/item/ammo_magazine/sentry_flamer/glob,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 哨戒等离子焚烧器弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_sentry
	name = "UA 571-C sentry ammunition (x2)"
	localized_name = "UA 571-C哨戒机枪弹药（2份）"
	contains = list(
		/obj/item/ammo_magazine/sentry,
		/obj/item/ammo_magazine/sentry,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 哨戒机枪弹药箱"
	group = "Ammo"

//------------------------M240 flamer tanks----------------

/datum/supply_packs/ammo_napalm
	name = "M240 UT-Napthal Fuel (x4)"
	localized_name = "M240 UT-Napthal燃料（4罐）"
	contains = list(
		/obj/item/ammo_magazine/flamer_tank,
		/obj/item/ammo_magazine/flamer_tank,
		/obj/item/ammo_magazine/flamer_tank,
		/obj/item/ammo_magazine/flamer_tank,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "\improper UT-Napthal燃料箱"
	group = "Ammo"

/datum/supply_packs/ammo_napalm_gel
	name = "M240 Napalm B-Gel (x4)"
	localized_name = "M240 B型凝固汽油（4罐）"
	contains = list(
		/obj/item/ammo_magazine/flamer_tank/gellied,
		/obj/item/ammo_magazine/flamer_tank/gellied,
		/obj/item/ammo_magazine/flamer_tank/gellied,
		/obj/item/ammo_magazine/flamer_tank/gellied,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "\improper 凝固汽油凝胶箱"
	group = "Ammo"

/datum/supply_packs/ammo_flamer_mixed
	name = "M240 Fuel Crate (x2 normal, x2 b-gel)"
	localized_name = "M240燃料箱（普通燃料2罐、B型凝胶2罐）"
	contains = list(
		/obj/item/ammo_magazine/flamer_tank,
		/obj/item/ammo_magazine/flamer_tank,
		/obj/item/ammo_magazine/flamer_tank/gellied,
		/obj/item/ammo_magazine/flamer_tank/gellied,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	group = "Ammo"

//------------------------Mounted guns ammo----------------
/datum/supply_packs/ammo_m2c
	name = "M2C ammunition crate (x2)"
	localized_name = "M2C弹药箱（2份）"
	contains = list(
		/obj/item/ammo_magazine/m2c,
		/obj/item/ammo_magazine/m2c,
	)
	cost = 25
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M2C弹药箱"
	group = "Ammo"

/datum/supply_packs/ammo_m56d
	name = "M56D drum magazine crate (x1)"
	localized_name = "M56D弹鼓箱（1个）"
	contains = list(
		/obj/item/ammo_magazine/m56d,
	)
	cost = 25
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper M56D弹鼓箱"
	group = "Ammo"

//This crate has a little bit of everything, mostly okay stuff, but it does have some really unique picks.
/datum/supply_packs/ammo_surplus
	name = "Surplus ammo crate (various USCM magazines x10)"
	localized_name = "剩余库存弹药箱（各类殖民地陆战队弹匣10个）"
	randomised_num_contained = 10
	contains = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle/extended,
		/obj/item/ammo_magazine/rifle/ap,
		/obj/item/ammo_magazine/rifle/incendiary,
		/obj/item/ammo_magazine/rifle/m49a/incendiary,
		/obj/item/ammo_magazine/rifle/m41aMK1,
		/obj/item/ammo_magazine/rifle/m41aMK1/ap,
		/obj/item/ammo_magazine/rifle/m49a,
		/obj/item/ammo_magazine/hpr_box,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/pistol,
		/obj/item/ammo_magazine/pistol/incendiary,
		/obj/item/ammo_magazine/smg/m39,
		/obj/item/ammo_magazine/smg/m39,
		/obj/item/ammo_magazine/smg/m39,
		/obj/item/ammo_magazine/smg/m39/extended,
		/obj/item/ammo_magazine/smg/m39/ap,
		/obj/item/ammo_magazine/smg/m39/ap,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver,
		/obj/item/ammo_magazine/revolver/marksman,
		/obj/item/ammo_magazine/revolver/heavy,
		/obj/item/ammo_magazine/shotgun,
		/obj/item/ammo_magazine/shotgun,
		/obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/ammo_magazine/shotgun/buckshot,
		/obj/item/ammo_magazine/shotgun/incendiary,
		/obj/item/ammo_magazine/rifle/m49a/ap,
		/obj/item/ammo_magazine/rifle/m49a,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/ammo
	containername = "\improper 剩余库存弹药箱"
	group = "Ammo"
