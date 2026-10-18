/datum/supply_packs/sandbags
	name = "empty sandbags crate (x50)"
	localized_name = "空沙袋箱（50个）"
	contains = list(/obj/item/stack/sandbags_empty/full)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "空沙袋箱"
	group = "Engineering"

/datum/supply_packs/sandbagskit
	name = "sandbags construction kit (sandbags x50, etool x2)"
	localized_name = "沙袋工事套件（沙袋50个、工兵铲2把）"
	contains = list(
		/obj/item/stack/sandbags_empty/full,
		/obj/item/tool/shovel/etool,
		/obj/item/tool/shovel/etool,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/supply
	containername = "沙袋工事套件"
	group = "Engineering"

/datum/supply_packs/metal
	name = "metal sheets (x50)"
	localized_name = "金属板（50张）"
	contains = list(/obj/item/stack/sheet/metal/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "金属板箱"
	group = "Engineering"

/datum/supply_packs/plas
	name = "plasteel sheets (x40)"
	localized_name = "塑钢板（40张）"
	contains = list(/obj/item/stack/sheet/plasteel/med_large_stack)
	cost = 30
	containertype = /obj/structure/closet/crate/supply
	containername = "塑钢板箱"
	group = "Engineering"

/datum/supply_packs/glass
	name = "glass sheets (x50)"
	localized_name = "玻璃板（50张）"
	contains = list(/obj/item/stack/sheet/glass/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "玻璃板箱"
	group = "Engineering"

/datum/supply_packs/wood50
	name = "wooden planks (x50)"
	localized_name = "木板（50块）"
	contains = list(/obj/item/stack/sheet/wood/large_stack)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "木板箱"
	group = "Engineering"

/datum/supply_packs/folding_barricades
	contains = list(
		/obj/item/stack/folding_barricade/three,
	)
	name = "Folding Barricades (x3)"
	localized_name = "折叠路障（3个）"
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "折叠路障箱"
	group = "Engineering"

/datum/supply_packs/smescoil
	name = "superconducting magnetic coil crate (x1)"
	localized_name = "超导磁线圈箱（1个）"
	contains = list(/obj/item/stock_parts/smes_coil)
	cost = 30
	containertype = /obj/structure/closet/crate/construction
	containername = "超导磁线圈箱"
	group = "Engineering"

/datum/supply_packs/electrical
	name = "electrical maintenance crate (toolbox x2, insulated x2, cell x2, hi-cap cell x2)"
	localized_name = "电气维护箱（工具箱、绝缘手套、电池、高容量电池各2份）"
	contains = list(
		/obj/item/storage/toolbox/electrical,
		/obj/item/storage/toolbox/electrical,
		/obj/item/clothing/gloves/yellow,
		/obj/item/clothing/gloves/yellow,
		/obj/item/cell,
		/obj/item/cell,
		/obj/item/cell/high,
		/obj/item/cell/high,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "电气维护箱"
	group = "Engineering"

/datum/supply_packs/mechanical
	name = "mechanical maintenance crate (utility belt x3, hazard vest x3, welding helmet x2, hard hat x1)"
	localized_name = "机械维护箱（工具腰带3条、警示背心3件、焊接面罩2个、安全帽1顶）"
	contains = list(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/head/hardhat,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "机械维护箱"
	group = "Engineering"

/datum/supply_packs/inflatable
	name = "inflatable barriers (x9 doors, x12 walls)"
	localized_name = "充气屏障（门9个、墙12面）"
	contains = list(
		/obj/item/storage/briefcase/inflatable,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/storage/briefcase/inflatable,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "充气屏障箱"
	group = "Engineering"

/datum/supply_packs/lightbulbs
	name = "replacement lights (x42 tube, x21 bulb)"
	localized_name = "备用灯具（灯管42根、灯泡21个）"
	contains = list(
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/lights/mixed,
		/obj/item/storage/box/lights/mixed,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/supply
	containername = "备用灯具箱"
	group = "Engineering"

/datum/supply_packs/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	localized_name = "P.A.C.M.A.N.便携式发电机零件"
	contains = list(
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/matter_bin,
		/obj/item/circuitboard/machine/pacman,
	)
	cost = 30
	containername = "\improper P.A.C.M.A.N.便携式发电机建造套件"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"

/datum/supply_packs/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	localized_name = "超级P.A.C.M.A.N.便携式发电机零件"
	cost = 40
	containername = "\improper 超级P.A.C.M.A.N.便携式发电机建造套件"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"
	contains = list(
		/obj/item/stock_parts/micro_laser,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/matter_bin,
		/obj/item/circuitboard/machine/pacman/super,
	)

/datum/supply_packs/flashlights
	name = "Flashlights (x8)"
	localized_name = "手电筒（8支）"
	contains = list(
		/obj/item/ammo_box/magazine/misc/flashlight,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "手电筒箱"
	group = "Engineering"

/datum/supply_packs/batteries
	name = "High-Capacity Power Cells (x8)"
	localized_name = "高容量电池（8块）"
	contains = list(
		/obj/item/ammo_box/magazine/misc/power_cell,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/supply
	containername = "电池箱"
	group = "Engineering"
