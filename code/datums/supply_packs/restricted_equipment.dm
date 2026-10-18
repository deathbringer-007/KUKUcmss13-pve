// here they will be all the Equipment that are restricted to a role/job.

/datum/supply_packs/armor_leader
	name = "B12 pattern marine armor crate (x1 helmet, x1 armor)"
	localized_name = "B12型陆战队护甲箱（头盔1顶、护甲1件）"
	contains = list(
		/obj/item/clothing/head/helmet/marine/leader,
		/obj/item/clothing/suit/storage/marine/medium/leader,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "B12型陆战队护甲箱"
	group = "Restricted Equipment"

/datum/supply_packs/armor_tl
	name = "M4 pattern marine armor crate (x1 helmet, x1 armor)"
	localized_name = "M4型陆战队护甲箱（头盔1顶、护甲1件）"
	contains = list(
		/obj/item/clothing/head/helmet/marine/rto,
		/obj/item/clothing/suit/storage/marine/medium/rto,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "M4型陆战队护甲箱"
	group = "Restricted Equipment"

/datum/supply_packs/intel_kit
	name = "Field Intelligence Support Kit crate (x1 fulton pack, x1 data detector, x1 intel pamphlet, x1 large document pouch, 1x intel radio key)"
	localized_name = "战地情报支援套件箱（富尔顿包、数据探测器、情报指导手册、大型文件附包、情报无线电密钥各1份）"
	contains = list(
		/obj/item/storage/box/kit/mini_intel,
	)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "战地情报支援套件箱"
	group = "Restricted Equipment"

/datum/supply_packs/jtac_kit
	name = "JTAC Radio Kit crate (x1 full flare gun belt, x2 M89-S signal flare packs, 1x laser designator, 1x jtac radio key, 1x radiopack)"
	localized_name = "JTAC无线电套件箱（装满的信号枪腰带1条、M89-S信号照明棒包2包、激光指示器1个、JTAC无线电密钥1枚、无线电背包1个）"
	contains = list(
		/obj/item/storage/box/kit/mini_jtac,
	)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "JTAC无线电套件箱"
	group = "Restricted Equipment"
