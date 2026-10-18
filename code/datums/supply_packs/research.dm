// Contain all the crate related to research.

//explosif related section

/datum/supply_packs/assembly
	name = "assembly crate"
	localized_name = "组件箱"
	contains = list(
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/igniter,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/timer,
		/obj/item/device/assembly/timer,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "组件箱"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

//Chemical section

/datum/supply_packs/pyrotec
	name = "pyrotechnics crate"
	localized_name = "烟火材料箱"
	contains = list(
		/obj/item/reagent_container/glass/beaker/sulphuric,
		/obj/item/reagent_container/glass/beaker/sulphuric,
		/obj/item/reagent_container/glass/beaker/sulphuric,
		/obj/item/reagent_container/glass/beaker/ethanol,
		/obj/item/reagent_container/glass/beaker/ethanol,
		/obj/item/reagent_container/glass/beaker/ethanol,
		/obj/item/reagent_container/glass/beaker/large/phosphorus,
		/obj/item/reagent_container/glass/beaker/large/phosphorus,
		/obj/item/reagent_container/glass/beaker/large/phosphorus,
		/obj/item/reagent_container/glass/beaker/large/lithium,
		/obj/item/reagent_container/glass/beaker/large/lithium,
		/obj/item/reagent_container/glass/beaker/large/sodiumchloride,
		/obj/item/reagent_container/glass/beaker/large/sodiumchloride,
		/obj/item/reagent_container/glass/beaker/large/potassiumchloride,
		/obj/item/reagent_container/glass/beaker/large/potassiumchloride,
	)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "烟火材料箱"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

/datum/supply_packs/phoron
	name = "phoron crate"
	localized_name = "弗燃素箱"
	contains = list(
		/obj/item/stack/sheet/mineral/phoron/medium_stack,
		/obj/item/stack/sheet/mineral/phoron/medium_stack,
	)
	cost = 30
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "弗燃素箱"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

/datum/supply_packs/plastic
	name = "plastic crate"
	localized_name = "塑料箱"
	contains = list(
		/obj/item/stack/sheet/mineral/plastic/small_stack,
		/obj/item/stack/sheet/mineral/plastic/small_stack,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "塑料箱"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

/datum/supply_packs/precious_metals
	name = "precious metals crate"
	localized_name = "贵金属箱"
	contains = list(
		/obj/item/stack/sheet/mineral/gold/small_stack,
		/obj/item/stack/sheet/mineral/silver/small_stack,
		/obj/item/stack/sheet/mineral/uranium/small_stack,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "贵金属箱"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

/datum/supply_packs/exp_production
	name = "explosives production crate"
	localized_name = "炸药生产用品箱"
	contains = list(
		/obj/item/reagent_container/glass/canister,
		/obj/item/reagent_container/glass/canister,
		/obj/item/reagent_container/glass/canister/ammonia,
		/obj/item/reagent_container/glass/canister/ammonia,
		/obj/item/reagent_container/glass/canister/methane,
		/obj/item/reagent_container/glass/canister/methane,
		/obj/item/reagent_container/glass/canister/oxygen,
		/obj/item/reagent_container/glass/canister/oxygen,
		/obj/item/reagent_container/glass/canister/pacid,
		/obj/item/reagent_container/glass/canister/pacid,
	)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "炸药生产用品箱"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

//Xeno section

/datum/supply_packs/xeno_tags
	name = "Xenomorph IFF Tag Case (x7 tags)"
	localized_name = "异形敌我识别标签盒（7枚标签）"
	contains = list(
		/obj/item/storage/xeno_tag_case/full,
	)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/weyland
	containername = "敌我识别标签箱"
	group = "Research"
