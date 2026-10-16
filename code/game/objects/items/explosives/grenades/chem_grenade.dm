/obj/item/explosive/grenade/custom
	name = "自制手雷"
	icon_state = "grenade_custom"
	desc = "采用M40弹壳的自制化学手雷，专为下挂式榴弹发射器设计，也可手掷。"
	w_class = SIZE_SMALL
	force = 2
	dangerous = TRUE
	customizable = TRUE
	underslug_launchable = TRUE
	allowed_sensors = list(/obj/item/device/assembly/timer)
	max_container_volume = 90
	matter = list("metal" = 3750)
	has_blast_wave_dampener = TRUE

/obj/item/explosive/grenade/custom/prime()
	overlays.Cut()
	..()

/obj/item/explosive/grenade/custom/large
	name = "大型自制手雷"
	desc = "采用M15弹壳的自制化学手雷，爆炸容量高于M40版本。"
	icon_state = "large_grenade_custom"
	allowed_containers = list(/obj/item/reagent_container/glass)
	max_container_volume = 180
	reaction_limits = list( "max_ex_power" = 215, "base_ex_falloff" = 90, "max_ex_shards" = 32,
							"max_fire_rad" = 5, "max_fire_int" = 20, "max_fire_dur" = 24,
							"min_fire_rad" = 1, "min_fire_int" = 3, "min_fire_dur" = 3
	)
	underslug_launchable = FALSE
	has_blast_wave_dampener = TRUE
	w_class = SIZE_MEDIUM
	matter = list("metal" = 7000)


/obj/item/explosive/grenade/custom/metal_foam
	name = "金属泡沫手雷"
	desc = "用于紧急封堵漏气的破口。"
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE
	has_blast_wave_dampener = FALSE
	antigrief_protection = FALSE

/obj/item/explosive/grenade/custom/metal_foam/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 30)
	B2.reagents.add_reagent("foaming_agent", 10)
	B2.reagents.add_reagent("pacid", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()

/obj/item/explosive/grenade/custom/incendiary
	name = "燃烧手雷"
	desc = "用于清除房间内的活物。"
	assembly_stage = ASSEMBLY_LOCKED
	has_blast_wave_dampener = FALSE

/obj/item/explosive/grenade/custom/incendiary/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 15)
	B1.reagents.add_reagent("fuel",20)
	B2.reagents.add_reagent("phoron", 15)
	B2.reagents.add_reagent("sulphuric acid", 15)
	B1.reagents.add_reagent("fuel",20)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()

/obj/item/explosive/grenade/custom/flare
	name = "\improper M40-F照明手雷"
	desc = "手雷形式的化学照明弹，兼容大多数制式发射器。"
	assembly_stage = ASSEMBLY_LOCKED
	has_blast_wave_dampener = FALSE
	antigrief_protection = FALSE

/obj/item/explosive/grenade/custom/flare/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/vial/V1 = new(src)
	var/obj/item/reagent_container/glass/beaker/vial/V2 = new(src)
	var/obj/item/reagent_container/glass/beaker/vial/V3 = new(src)

	V1.reagents.add_reagent("aluminum", 30)
	V2.reagents.add_reagent("potassium", 30)
	V3.reagents.add_reagent("sulfur", 30)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += V1
	containers += V2
	containers += V3
	update_icon()

/obj/item/explosive/grenade/custom/large/flare
	name = "\improper M15-F照明手雷"
	desc = "手雷形式的加大号化学照明弹，弹壳过大，无法装入大多数发射器。"
	assembly_stage = ASSEMBLY_LOCKED
	has_blast_wave_dampener = FALSE
	antigrief_protection = FALSE

/obj/item/explosive/grenade/custom/large/flare/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)
	var/obj/item/reagent_container/glass/beaker/B3 = new(src)

	B1.reagents.add_reagent("aluminum", 60)
	B2.reagents.add_reagent("potassium", 60)
	B3.reagents.add_reagent("sulfur", 60)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	containers += B3
	update_icon()


/obj/item/explosive/grenade/custom/antiweed
	name = "除草手雷"
	desc = "用于大面积清除入侵植物。内容物处于加压状态，请勿直接吸入。"
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE
	antigrief_protection = FALSE

/obj/item/explosive/grenade/custom/antiweed/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("plantbgone", 25)
	B1.reagents.add_reagent("potassium", 25)
	B2.reagents.add_reagent("phosphorus", 25)
	B2.reagents.add_reagent("sugar", 25)
	has_blast_wave_dampener = FALSE

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()

/obj/item/explosive/grenade/custom/cleaner
	name = "清洁手雷"
	desc = "BLAM!牌泡沫太空清洁剂，装在专用容器中，可快速清洁大片区域。"
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE
	has_blast_wave_dampener = FALSE
	antigrief_protection = FALSE

/obj/item/explosive/grenade/custom/cleaner/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 40)
	B2.reagents.add_reagent("water", 40)
	B2.reagents.add_reagent("cleaner", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()

/obj/item/explosive/grenade/custom/ied
	name = "简易爆炸装置"
	desc = "简易化学爆炸手雷，依靠破片杀伤目标。"
	assembly_stage = ASSEMBLY_LOCKED
	has_blast_wave_dampener = FALSE

/obj/item/explosive/grenade/custom/ied/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("potassium", 20)
	B1.reagents.add_reagent("iron", 40)
	B2.reagents.add_reagent("water", 20)
	B2.reagents.add_reagent("iron", 40)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src, 2) //~4 second timer

	containers += B1
	containers += B2

	update_icon()


/obj/item/explosive/grenade/custom/ied_incendiary
	name = "简易爆炸装置（燃烧型）"
	desc = "简易化学爆炸手雷，可向大片区域喷射燃烧破片。"
	assembly_stage = ASSEMBLY_LOCKED
	has_blast_wave_dampener = FALSE

/obj/item/explosive/grenade/custom/ied_incendiary/Initialize()
	. = ..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("potassium", 20)
	B1.reagents.add_reagent("iron", 40)
	B2.reagents.add_reagent("water", 20)
	B2.reagents.add_reagent("iron", 30)
	B2.reagents.add_reagent("phoron", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src, 2) //~4 second timer

	containers += B1
	containers += B2

	update_icon()
