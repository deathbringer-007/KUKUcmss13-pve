//the idea is to put all the bulk items scanner secure crate with lot's of flares MRE in it and at the end OB and non buyable.

//non buyable

/datum/supply_packs/ob_incendiary
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/incendiary,
	)

	name = "OB Incendiary Crate"
	localized_name = "轨道轰炸燃烧弹箱"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "轨道轰炸弹药箱（燃烧弹）"
	buyable = 0
	group = "Operations"

/datum/supply_packs/ob_explosive
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/explosive,
	)

	name = "OB HE Crate"
	localized_name = "轨道轰炸高爆弹箱"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "轨道轰炸弹药箱（高爆弹）"
	buyable = 0
	group = "Operations"

/datum/supply_packs/ob_cluster
	contains = list(
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/ob_fuel,
		/obj/structure/ob_ammo/warhead/cluster,
	)

	name = "OB Cluster Crate"
	localized_name = "轨道轰炸集束弹箱"
	cost = 0
	containertype = /obj/structure/closet/crate/secure/ob
	containername = "轨道轰炸弹药箱（集束弹）"
	buyable = 0
	group = "Operations"

/datum/supply_packs/telecommsparts
	name = "Replacement Telecommunications Parts"
	localized_name = "备用电信零件"
	contains = list(
		/obj/item/circuitboard/machine/telecomms/relay/tower,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/cell,
		/obj/item/cell,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	buyable = 0
	containername = "备用电信设备箱"
	group = "Operations"

/datum/supply_packs/nuclearbomb
	name = "Decrypted Operational Nuke"
	localized_name = "已解密作战核装置"
	cost = 0
	containertype = /obj/structure/machinery/nuclearbomb
	buyable = 0
	group = "Operations"

/datum/supply_packs/technuclearbomb
	name = "Encrypted Operational Nuke"
	localized_name = "已加密作战核装置"
	cost = 0
	containertype = /obj/structure/machinery/nuclearbomb/tech
	buyable = 0
	group = "Operations"

/datum/supply_packs/spec_kits
	name = "Weapons Specialist Kits"
	localized_name = "武器专家套件"
	contains = list(
		/obj/item/spec_kit/rifleman,
		/obj/item/spec_kit/rifleman,
		/obj/item/spec_kit/rifleman,
		/obj/item/spec_kit/rifleman,
	)
	cost = 0
	containertype = /obj/structure/closet/crate/supply
	containername = "武器专家套件箱"
	buyable = 0
	group = "Operations"
