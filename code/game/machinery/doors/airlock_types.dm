
/obj/structure/machinery/door/airlock/secure/colony
	name = "\improper 安全气闸门"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_com
	openspeed = 4
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/command/colony
	name = "\improper 指挥区气闸门"
	icon = 'icons/obj/structures/doors/comdoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_com
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/security/colony
	name = "\improper 安保区气闸门"
	icon = 'icons/obj/structures/doors/secdoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_sec
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_SECURITY)

/obj/structure/machinery/door/airlock/engineering/colony
	name = "\improper 工程区气闸门"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_eng
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/medical/colony
	name = "\improper 医疗区气闸门"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_med
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)


/obj/structure/machinery/door/airlock/maintenance/colony
	name = "\improper 维护舱门"
	icon = 'icons/obj/structures/doors/maintdoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_mai
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/external/colony
	name = "\improper 外部气闸门"
	icon = 'icons/obj/structures/doors/Doorext.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_ext
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/glass/colony
	name = "\improper 玻璃气闸门"
	icon = 'icons/obj/structures/doors/Doorglass.dmi'
	opacity = FALSE
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/centcom/colony
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/comdoor.dmi'
	opacity = 1
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/vault/colony
	name = "\improper 金库门"
	icon = 'icons/obj/structures/doors/vault.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_highsecurity //Until somebody makes better sprites.
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_LEADERSHIP)

/obj/structure/machinery/door/airlock/freezer/colony
	name = "\improper 冷冻库气闸门"
	icon = 'icons/obj/structures/doors/Doorfreezer.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_fre
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/hatch/colony
	name = "\improper 密封舱门"
	icon = 'icons/obj/structures/doors/Doorhatchele.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_hatch
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/glass_command/colony
	name = "\improper 指挥区气闸门"
	icon = 'icons/obj/structures/doors/Doorcomglass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_com
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/glass_engineering/colony
	name = "\improper 工程区气闸门"
	icon = 'icons/obj/structures/doors/engidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_eng
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/glass_security/colony
	name = "\improper 安保区气闸门"
	icon = 'icons/obj/structures/doors/secdoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_sec
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/glass_medical/colony
	name = "\improper 医疗区气闸门"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_med
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/mining/colony
	name = "\improper 采矿区气闸门"
	icon = 'icons/obj/structures/doors/Doormining.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_min
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/marine/colony
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/door_marines.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_min

/obj/structure/machinery/door/airlock/atmos/colony
	name = "\improper 大气系统区气闸门"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_atmo
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/research/colony
	name = "\improper 研究区气闸门"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_research
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/glass_research/colony
	name = "\improper 研究区气闸门"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_research
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/glass_mining/colony
	name = "\improper 采矿区气闸门"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_min
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/glass_atmos/colony
	name = "\improper 大气系统区气闸门"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_atmo
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/requisitions/colony
	name = "\improper 军需发放区"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_CIVILIAN_LOGISTICS, ACCESS_MARINE_CARGO)
	opacity = 0
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/gold
	name = "\improper 黄金气闸门"
	icon = 'icons/obj/structures/doors/Doorgold.dmi'
	mineral = "gold"

/obj/structure/machinery/door/airlock/silver
	name = "\improper 白银气闸门"
	icon = 'icons/obj/structures/doors/Doorsilver.dmi'
	mineral = "silver"

/obj/structure/machinery/door/airlock/diamond
	name = "\improper 钻石气闸门"
	icon = 'icons/obj/structures/doors/Doordiamond.dmi'
	mineral = "diamond"

/obj/structure/machinery/door/airlock/uranium
	name = "\improper 铀制气闸门"
	desc = "他们还说我疯了。"
	icon = 'icons/obj/structures/doors/Dooruranium.dmi'
	mineral = "uranium"
	var/last_event = 0

/obj/structure/machinery/door/airlock/uranium/process()
	if(world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/structure/machinery/door/airlock/uranium/proc/radiate()
	for(var/mob/living/L in range (3,src))
		L.apply_effect(15,IRRADIATE,0)
	return

/obj/structure/machinery/door/airlock/phoron
	name = "\improper 弗燃素气闸门"
	desc = "这怎么可能出岔子呢。"
	icon = 'icons/obj/structures/doors/Doorphoron.dmi'
	mineral = "phoron"

/obj/structure/machinery/door/airlock/sandstone
	name = "\improper 砂岩气闸门"
	icon = 'icons/obj/structures/doors/Doorsand.dmi'
	mineral = "sandstone"

/obj/structure/machinery/door/airlock/science/colony
	name = "\improper 研究区气闸门"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_science
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/glass_science/colony
	name = "\improper 研究区气闸门"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_science
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/highsecurity/colony
	name = "\improper 高科技安保气闸门"
	icon = 'icons/obj/structures/doors/hightechsecurity.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_highsecurity
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_SECURITY, ACCESS_WY_LEADERSHIP)


//STRATA AIRLOCKS // Add me later y'know?
/obj/structure/machinery/door/airlock/strata
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_doors.dmi' //Whoever made it so each door is it's own sheet and doesn't dynamically use overlays ought to be drawn and quartered.
	openspeed = 5
	req_access = null // Colony side airlocks should not have any sort of access.
	req_one_access = null
	tiles_with = list(
		/obj/structure/window/framed/strata,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/strata/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/maintenance
	name = "\improper 维护区气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_maint.dmi'

/obj/structure/machinery/door/airlock/strata/maintenance/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/security
	name = "\improper 安保区气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_sec.dmi'

/obj/structure/machinery/door/airlock/strata/security/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/mining
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_mining.dmi'

/obj/structure/machinery/door/airlock/strata/mining/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/circular
	name = "\improper 安全气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_utility.dmi'

//YAUTJA SHIP - CURRENTLY USES STRATA DOORS
/obj/structure/machinery/door/airlock/yautja
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/strata/strata_doors.dmi'
	openspeed = 5
	req_access = null
	req_one_access = null
	tiles_with = list(
		/obj/structure/window/framed/strata,
		/obj/structure/machinery/door/airlock,
	)
	masterkey_resist = TRUE
	no_panel = TRUE
	not_weldable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/airlock/yautja/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/yautja/secure
	heavy = TRUE
	req_one_access = list(ACCESS_YAUTJA_SECURE, ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT)

/obj/structure/machinery/door/airlock/yautja/secure/elder
	req_one_access = list(ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT)

/obj/structure/machinery/door/airlock/yautja/secure/ancient
	req_one_access = list(ACCESS_YAUTJA_ANCIENT)
	unslashable = TRUE

//FIORINA PENITENTIARY (PRISON_FOP) MAINTENANCE HATCHES

/obj/structure/machinery/door/airlock/prison_hatch
	name = "\improper 维护舱门"
	icon = 'icons/obj/structures/doors/prison_FOP/prison_hatches.dmi'
	openspeed = 5
	req_access = null
	req_one_access = null
	tiles_with = list(
		/obj/structure/window/framed/prison,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/prison_hatch/autoname
	autoname = TRUE

//ALMAYER AIRLOCKS

/obj/structure/machinery/door/airlock/almayer
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/comdoor.dmi' //Tiles with is here FOR SAFETY PURPOSES
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/almayer/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/almayer/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/almayer/take_damage(dam, mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "The fingerprint contains bits of wire and metal specks.")

	..()

/obj/structure/machinery/door/airlock/almayer/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/security
	name = "\improper 安保区气闸门"
	icon = 'icons/obj/structures/doors/secdoor.dmi'
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/machinery/door/airlock/almayer/security/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/almayer/security/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/security/reinforced
	name = "\improper 加固安保气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/security/reinforced/colony
	name = "\improper 加固安保气闸门"
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/almayer/security/glass
	name = "\improper 安保区气闸门"
	icon = 'icons/obj/structures/doors/secdoor_glass.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/security/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)


/obj/structure/machinery/door/airlock/almayer/security/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/security/glass/reinforced
	name = "\improper 加固安保气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/security/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/almayer/command
	name = "\improper 指挥区气闸门"
	icon = 'icons/obj/structures/doors/comdoor.dmi'
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/command/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/command/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/command/reinforced
	name = "\improper 加固指挥区气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/command/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/secure
	name = "\improper 安全气闸门"
	icon = 'icons/obj/structures/doors/securedoor.dmi'
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/secure/glass
	name = "\improper 安全气闸门"
	icon = 'icons/obj/structures/doors/securedoor_glass.dmi'
	opacity = FALSE

/obj/structure/machinery/door/airlock/almayer/secure/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/secure/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/secure/reinforced
	name = "\improper 加固安全气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/secure/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/maint
	name = "\improper 维护舱门"
	icon = 'icons/obj/structures/doors/maintdoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_MAINT)

/obj/structure/machinery/door/airlock/almayer/maint/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/maint/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/maint/colony/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/maint/reinforced
	name = "\improper 加固维护舱门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/maint/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/engineering
	name = "\improper 工程区气闸门"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	opacity = FALSE
	glass = 1
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_ENGINEERING)

/obj/structure/machinery/door/airlock/almayer/engineering/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/almayer/engineering/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/engineering/glass
	name = "\improper 工程区气闸门"
	icon = 'icons/obj/structures/doors/engidoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/engineering/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/almayer/engineering/reinforced
	name = "\improper 加固工程气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/engineering/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/almayer/engineering/reinforced/OT
	name = "\improper 军械工坊"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_OT)

/obj/structure/machinery/door/airlock/almayer/medical
	name = "\improper 医疗区气闸门"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/medical/plain
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/medidoor_plain.dmi'
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/medical/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/medical/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/medical/glass
	name = "\improper 医疗区气闸门"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = FALSE
	glass = 1
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/medical/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/medical/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/research
	name = "\improper 研究区气闸门"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	req_one_access = list(ACCESS_MARINE_RESEARCH, ACCESS_WY_RESEARCH, ACCESS_WY_EXEC)

/obj/structure/machinery/door/airlock/almayer/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/almayer/research/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/research/reinforced
	name = "\improper 加固研究气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/research/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/almayer/research/glass
	name = "\improper 研究区气闸门"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = FALSE
	glass = 1
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/door/airlock/almayer/research/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/research/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/research/glass/reinforced
	name = "\improper 加固研究气闸门"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/research/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/generic
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'

/obj/structure/machinery/door/airlock/almayer/generic/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/glass
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/personaldoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/corporate
	name = "企业联络员宿舍"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	req_access = list(ACCESS_WY_GENERAL)

/obj/structure/machinery/door/airlock/almayer/generic/press
	name = "新闻办公室"
	req_access = list(ACCESS_PRESS)

/obj/structure/machinery/door/airlock/almayer/marine
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/marine/requisitions
	name = "\improper 军需发放区"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_CARGO)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/requisitions/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_LOGISTICS, ACCESS_MARINE_CARGO)

/obj/structure/machinery/door/airlock/almayer/marine/alpha
	name = "\improper 阿尔法小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor_alpha.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/sl
	name = "\improper 阿尔法小队长整备室"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/spec
	name = "\improper 阿尔法小队武器专家整备室"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/engineer
	name = "\improper 阿尔法小队通讯技师整备室"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/medic
	name = "\improper 阿尔法小队医疗整备室"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/smart
	name = "\improper 阿尔法小队智能机枪手整备室"
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo
	name = "\improper 布拉沃小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor_bravo.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_BRAVO)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/sl
	name = "\improper 布拉沃小队长整备室"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/spec
	name = "\improper 布拉沃小队武器专家整备室"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/engineer
	name = "\improper 布拉沃小队通讯技师整备室"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/medic
	name = "\improper 布拉沃小队医疗整备室"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/smart
	name = "\improper 布拉沃小队智能机枪手整备室"
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie
	name = "\improper 查理小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor_charlie.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/sl
	name = "\improper 查理小队长整备室"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/spec
	name = "\improper 查理小队武器专家整备室"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/engineer
	name = "\improper 查理小队通讯技师整备室"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/medic
	name = "\improper 查理小队医疗整备室"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/smart
	name = "\improper 查理小队智能机枪手整备室"
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta
	name = "\improper 德尔塔小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor_delta.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/sl
	name = "\improper 德尔塔小队长整备室"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/spec
	name = "\improper 德尔塔小队武器专家整备室"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/engineer
	name = "\improper 德尔塔小队通讯技师整备室"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/medic
	name = "\improper 德尔塔小队医疗整备室"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/smart
	name = "\improper 德尔塔小队智能机枪手整备室"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_SMARTPREP)
	dir = SOUTH
	opacity = FALSE
	glass = 1

//TL doors, yes this is stupid

/obj/structure/machinery/door/airlock/almayer/marine/alpha/tl
	name = "\improper 阿尔法小队战斗组长整备室"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

/obj/structure/machinery/door/airlock/almayer/marine/bravo/tl
	name = "\improper 布拉沃小队战斗组长整备室"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

/obj/structure/machinery/door/airlock/almayer/marine/charlie/tl
	name = "\improper 查理小队战斗组长整备室"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

/obj/structure/machinery/door/airlock/almayer/marine/delta/tl
	name = "\improper 德尔塔小队战斗组长整备室"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

//SQUAD PREP SHARED DOORS

/obj/structure/machinery/door/airlock/almayer/marine/shared
	name = "\improper 小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/shared/alpha_bravo
	name = "\improper 阿尔法与布拉沃小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor_alpha.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/almayer/marine/shared/alpha_bravo/yellow
	icon = 'icons/obj/structures/doors/prepdoor_bravo.dmi'

/obj/structure/machinery/door/airlock/almayer/marine/shared/charlie_delta
	name = "\improper 查理与德尔塔小队整备室"
	icon = 'icons/obj/structures/doors/prepdoor_charlie.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/almayer/marine/shared/charlie_delta/blue
	icon = 'icons/obj/structures/doors/prepdoor_delta.dmi'

//DROPSHIP SIDE AIRLOCKS

/obj/structure/machinery/door/airlock/dropship_hatch
	name = "\improper 运输艇舱门"
	icon = 'icons/obj/structures/doors/dropship1_side.dmi' //Tiles with is here FOR SAFETY PURPOSES
	id = "sh_dropship1"
	openspeed = 4 //shorter open animation.
	no_panel = 1
	not_weldable = 1
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/airlock/dropship_hatch/ex_act(severity)
	return

/obj/structure/machinery/door/airlock/dropship_hatch/unlock(forced = FALSE)
	if(is_reserved_level(z) && !forced) // in flight
		return FALSE
	return ..()

/obj/structure/machinery/door/airlock/dropship_hatch/attack_alien(mob/living/carbon/xenomorph/xeno)

	if(xeno.hive_pos != XENO_QUEEN)
		return ..()

	if(!locked)
		return ..()

	to_chat(xeno, SPAN_NOTICE("你试图强行打开门。"))
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		unlock(TRUE)
		open(1)
		lock(TRUE)

/obj/structure/machinery/door/airlock/dropship_hatch/two
	icon = 'icons/obj/structures/doors/dropship2_side.dmi' //Tiles with is here FOR SAFETY PURPOSES
	id = "sh_dropship2"

/obj/structure/machinery/door/airlock/dropship_hatch/upp
	icon = 'icons/obj/structures/doors/dropshipupp_side.dmi' //Tiles with is here FOR SAFETY PURPOSES

/obj/structure/machinery/door/airlock/dropship_hatch/monorail
	icon = 'icons/obj/structures/doors/pod_doors.dmi' //TEMPLATE NEED TO REPLACE LATER
	name = "单轨列车门"
	id = "gr_transport1"

/obj/structure/machinery/door/airlock/hatch/cockpit
	icon = 'icons/obj/structures/doors/dropship1_pilot.dmi'
	name = "驾驶舱"
	req_access = list()
	req_one_access = list()
	unslashable = TRUE
	unacidable = TRUE
	dir = SOUTH
	no_panel = 1
	not_weldable = 1

/obj/structure/machinery/door/airlock/hatch/cockpit/two
	icon = 'icons/obj/structures/doors/dropship2_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/three
	icon = 'icons/obj/structures/doors/dropship3_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/four
	icon = 'icons/obj/structures/doors/dropship4_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/upp
	icon = 'icons/obj/structures/doors/dropshipupp_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/pmc
	icon = 'icons/obj/structures/doors/dropshippmc_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/rmc
	icon = 'icons/obj/structures/doors/dropship_rmc_pilot.dmi'

//PRISON AIRLOCKS
/obj/structure/machinery/door/airlock/prison
	name = "牢房门"
	icon = 'icons/obj/structures/doors/celldoor.dmi'
	glass = 0

/obj/structure/machinery/door/airlock/prison/horizontal
	dir = SOUTH

/obj/structure/machinery/door/airlock/upp_green
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/upp/uppdoor_green.dmi'
	openspeed = 5
	req_access = null
	req_one_access = null

/obj/structure/machinery/door/airlock/upp_green/window
	icon = 'icons/obj/structures/doors/upp/uppdoor_glass_green.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/upp_grey
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/upp/uppdoor_grey.dmi'
	openspeed = 5
	req_access = null
	req_one_access = null

/obj/structure/machinery/door/airlock/upp_grey/window
	icon = 'icons/obj/structures/doors/upp/uppdoor_glass_grey.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/upp_utility
	name = "\improper 气闸门"
	icon = 'icons/obj/structures/doors/upp/uppdoor_utility.dmi'
	openspeed = 6
	req_access = null
	req_one_access = null
