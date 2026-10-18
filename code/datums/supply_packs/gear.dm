// add all the gear in this group.

/datum/supply_packs/binocs
	name = "Mixed Binoculars Crate (x2 per, x6 total)"
	localized_name = "混合双筒望远镜箱（每种2个，共6个）"
	cost = 20
	containertype = /obj/structure/closet/crate/green
	containername = "混合双筒望远镜箱"
	group = "Gear"
	contains = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/device/binoculars/range/designator,
		/obj/item/device/binoculars/range,
		/obj/item/device/binoculars/range,
		/obj/item/device/binoculars,
		/obj/item/device/binoculars,
	)

/datum/supply_packs/flares
	name = "flare packs crate (x20)"
	localized_name = "照明棒包箱（20包）"
	contains = list(
		/obj/item/ammo_box/magazine/misc/flares,
		/obj/item/ammo_box/magazine/misc/flares,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/ammo
	containername = "照明棒包箱"
	group = "Gear"


/datum/supply_packs/motiondetector
	name = "Motion Detector (x2)"
	localized_name = "运动探测器（2个）"
	contains = list(
		/obj/item/device/motiondetector,
		/obj/item/device/motiondetector,
					)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	containername = "运动探测器箱"
	group = "Gear"

/datum/supply_packs/signal_flares
	name = "signal flare packs crate (x4)"
	localized_name = "信号照明棒包箱（4包）"
	contains = list(
		/obj/item/storage/box/flare/signal,
		/obj/item/storage/box/flare/signal,
		/obj/item/storage/box/flare/signal,
		/obj/item/storage/box/flare/signal,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/ammo
	containername = "信号照明棒包箱"
	group = "Gear"

/datum/supply_packs/fulton
	name = "fulton recovery device crate (x4)"
	localized_name = "富尔顿回收装置箱（4个）"
	contains = list(
		/obj/item/stack/fulton,
		/obj/item/stack/fulton,
		/obj/item/stack/fulton,
		/obj/item/stack/fulton,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/ammo
	containername = "富尔顿回收装置箱"
	group = "Gear"

/datum/supply_packs/parachute
	name = "parachute crate (x20)"
	localized_name = "降落伞箱（20具）"
	contains = list(
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
		/obj/item/parachute,
	)
	cost = 40
	containertype = /obj/structure/closet/crate/supply
	containername = "降落伞箱"
	group = "Gear"
