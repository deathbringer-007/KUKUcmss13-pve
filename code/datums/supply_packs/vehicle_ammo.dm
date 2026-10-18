//*******************************************************************************
//Vehicle Ammo
//*******************************************************************************/

/datum/supply_packs/ammo_ltb_cannon
	name = "LTB Cannon magazines (x6)"
	localized_name = "LTB火炮弹匣（6个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTB火炮弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_ltaaap_minigun
	name = "LTAA-AP Minigun magazines (x3)"
	localized_name = "LTAA-AP转管机枪弹匣（3个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "LTAA转管机枪弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_ace_autocannon
	name = "AC3-E Autocannon magazines (x5)"
	localized_name = "AC3-E自动炮弹匣（5个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "AC3-E自动炮弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_drgn_flamer
	name = "DRG-N Offensive Flamer Unit fuel tanks (x3)"
	localized_name = "DRG-N进攻型喷火器燃料罐（3罐）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "主武器喷火器燃料罐箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_dualcannon
	name = "PARS-159 Boyars Dualcannon magazines (x5)"
	localized_name = "PARS-159“波雅尔”双联炮弹匣（5个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "PARS-159“波雅尔”双联炮弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_glauncher
	name = "M92T Grenade Launcher magazines (x5)"
	localized_name = "M92T榴弹发射器弹匣（5个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "M92T榴弹发射器弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_slauncher
	name = "M34A2-A Multipurpose Turret smoke screen magazines (x4)"
	localized_name = "M34A2-A多用途炮塔烟幕弹匣（4个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "M34A2-A多用途炮塔烟幕弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_towlauncher
	name = "TOW Launcher magazines (x3)"
	localized_name = "TOW发射器弹匣（3个）"
	contains = list(/obj/item/hardpoint/secondary/towlauncher)
	cost = 30
	containertype = /obj/structure/closet/crate/ammo
	containername = "TOW发射器弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_m56_cupola
	name = "M56 Cupola magazines (x2)"
	localized_name = "M56车长机枪塔弹匣（2个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/m56_cupola,
		/obj/item/ammo_magazine/hardpoint/m56_cupola,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "M56车长机枪塔弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/tank_flamer_ammo
	name = "LZR-N Flamer Unit fuel tanks (x2)"
	localized_name = "LZR-N喷火器燃料罐（2罐）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo/alt/flame
	containername = "LZR-N喷火器燃料罐箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_frontalcannon
	name = "Bleihagel RE-RE700 Frontal Cannon magazines (x2)"
	localized_name = "“铅雨”RE-RE700前置炮弹匣（2个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon,
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "“铅雨”RE-RE700前置炮弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_flarelauncher
	name = "M-87F Flare Launcher magazines (x4)"
	localized_name = "M-87F照明弹发射器弹匣（4个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "M-87F照明弹发射器弹药箱"
	group = "Vehicle Ammo"

/datum/supply_packs/ammo_arcsentry
	name = "RE700 Rotary Cannon magazines (x3)"
	localized_name = "RE700转管炮弹匣（3个）"
	contains = list(
		/obj/item/ammo_magazine/hardpoint/arc_sentry,
		/obj/item/ammo_magazine/hardpoint/arc_sentry,
		/obj/item/ammo_magazine/hardpoint/arc_sentry,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "RE700转管炮弹药箱"
	group = "Vehicle Ammo"
