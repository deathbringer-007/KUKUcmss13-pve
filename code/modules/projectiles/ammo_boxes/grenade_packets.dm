/obj/item/storage/box/packet
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "general_packet"
	w_class = SIZE_MEDIUM//fits into bags
	storage_slots = 5	//Baseline amount the mk1 UGL holds
	can_hold = list(/obj/item/explosive/grenade)
	foldable = TRUE
	var/content_type
	var/base_icon
	var/packet_icon
	has_gamemode_skin = FALSE

/obj/item/storage/box/packet/post_skin_selection()
	base_icon = icon_state

/obj/item/storage/box/packet/update_icon()
	overlays.Cut()
	if(!length(contents))
		icon_state = "[base_icon]_e"
	else
		icon_state = base_icon
		if(packet_icon)
			overlays += image(icon, packet_icon)


/obj/item/storage/box/packet/Initialize()
	if(!content_type)
		return INITIALIZE_HINT_QDEL

	. = ..()

	update_icon()

/obj/item/storage/box/packet/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new content_type(src)

GLOBAL_LIST_INIT(grenade_packets, list(
	/obj/item/storage/box/packet/high_explosive,
	/obj/item/storage/box/packet/high_explosive/upp,
	/obj/item/storage/box/packet/baton,
	/obj/item/storage/box/packet/flare,
	/obj/item/storage/box/packet/canister,
	/obj/item/storage/box/packet/incendiary,
	/obj/item/storage/box/packet/smoke,
	/obj/item/storage/box/packet/phosphorus,
	/obj/item/storage/box/packet/heap,
	/obj/item/storage/box/packet/bfab,
	/obj/item/storage/box/packet/phosphorus/upp,
	/obj/item/storage/box/packet/m15,
	))

/obj/item/storage/box/packet/high_explosive
	name = "\improper M40 HEDP高爆两用手榴弹包"
	desc = "内装五枚M40 HEDP高爆手榴弹。"
	packet_icon = "hedp-p"
	content_type = /obj/item/explosive/grenade/high_explosive

/obj/item/storage/box/packet/high_explosive/upp
	name = "\improper 6式破片手榴弹包"
	desc = "内装六枚6式破片手榴弹。"
	storage_slots = 6
	icon_state = "nadeboxupp"
	packet_icon = "upp-p" //Just so it doesn't come with the HEDP packet icon on it
	content_type = /obj/item/explosive/grenade/high_explosive/upp

/obj/item/storage/box/packet/high_explosive/upp/impact
	name = "\improper VOG-73破片榴弹包"
	desc = "内装六枚VOG-73破片榴弹。"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/upp

/obj/item/storage/box/packet/high_explosive/upp/ap
	name = "\improper VPG-77穿甲榴弹包"
	desc = "内装六枚VPG-77穿甲榴弹。"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/upp/ap

/obj/item/storage/box/packet/high_explosive/upp/incend
	name = "\improper VTBG-44温压手榴弹包"
	desc = "内装六枚VTBG-44温压手榴弹。"
	content_type = /obj/item/explosive/grenade/incendiary/impact/upp

/obj/item/storage/box/packet/high_explosive/upp/smoke
	name = "\improper RDG-17烟雾弹包"
	desc = "内装六枚RDG-17烟雾弹。"
	content_type = /obj/item/explosive/grenade/smokebomb/upp

/obj/item/storage/box/packet/baton
	name = "\improper M230 LLRB低致命橡胶警棍榴弹包"
	desc = "内装五发M230 LLRB低致命橡胶警棍榴弹。"
	packet_icon = "hirr-p"
	content_type = /obj/item/explosive/grenade/slug/baton

/obj/item/storage/box/packet/flare
	name = "\improper M72A2 HIPF星光照明榴弹包"
	desc = "内装五枚M72A2 HIPF星光照明榴弹，用于照明。"
	packet_icon = "hiaf-p"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/flare

/obj/item/storage/box/packet/canister
	name = "\improper M108霰弹榴弹包"
	desc = "内装五枚M108霰弹榴弹，只能使用榴弹发射器发射。"
	packet_icon = "cani-p"
	content_type = /obj/item/explosive/grenade/high_explosive/airburst/canister

/obj/item/storage/box/packet/incendiary
	name = "\improper M77 HIAM燃烧榴弹包"
	desc = "内装五枚M77 HIAM燃烧榴弹。"
	packet_icon = "hiam-p"
	content_type = /obj/item/explosive/grenade/incendiary

/obj/item/storage/box/packet/smoke
	name = "\improper M47 HSDP烟雾弹包"
	desc = "内装五枚M47 HSDP烟雾弹。"
	packet_icon = "hsdp-p"
	content_type = /obj/item/explosive/grenade/smokebomb

/obj/item/storage/box/packet/smoke/green
	name = "\improper M47-G HSDP烟雾弹包"
	desc = "内装五枚M47-G HSDP烟雾弹。"
	content_type = /obj/item/explosive/grenade/smokebomb/green

/obj/item/storage/box/packet/smoke/red
	name = "\improper M47-R HSDP烟雾弹包"
	desc = "内装五枚M47-R HSDP烟雾弹。"
	content_type = /obj/item/explosive/grenade/smokebomb/red

/obj/item/storage/box/packet/phosphorus
	name = "\improper M60 WPSI化合物手榴弹包"
	desc = "内装五枚M60 WPSI化合物手榴弹。"
	packet_icon = "wpsi-p"
	content_type = /obj/item/explosive/grenade/phosphorus

/obj/item/storage/box/packet/phosphorus/upp
	name = "\improper 8式白磷手榴弹包"
	desc = "内装三枚8式白磷手榴弹。"
	storage_slots = 3
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "cryo_defense_kit"
	content_type = /obj/item/explosive/grenade/phosphorus/upp

/obj/item/storage/box/packet/hefa/toy
	name = "玩具HEFA手榴弹包"
	desc = "这些带来欢乐的小包装，曾作为订阅者纪念奖品随《新兵！》杂志第二季第100期发放。没人知道，整个制作过程中为什么竟没有人问过一句：“等等，这主意是不是糟透了？”"
	packet_icon = "hefa-p"
	content_type = /obj/item/explosive/grenade/high_explosive/frag/toy

/obj/item/storage/box/packet/m15
	name = "\improper M15破片手榴弹包"
	desc = "内装三枚M15破片手榴弹，请小心操作。"
	storage_slots = 3
	packet_icon = "m15-p"
	content_type = /obj/item/explosive/grenade/high_explosive/m15

/obj/item/storage/box/packet/m15/rubber
	name = "M15橡胶弹丸手榴弹包"
	desc = "内装三枚M15橡胶弹丸手榴弹，用于防暴或战斗演习。"
	storage_slots = 3
	packet_icon = "m15r-p"
	content_type = /obj/item/explosive/grenade/high_explosive/m15/rubber

/obj/item/storage/box/packet/sebb
	name = "\improper G2电击手榴弹包"
	desc = "内装三枚G2电击手榴弹，请小心操作。"
	storage_slots = 3
	packet_icon = "sebb-p"
	content_type = /obj/item/explosive/grenade/sebb

/obj/item/storage/box/packet/bfab
	name = "\improper M51A BFAB跳跃空爆破片手榴弹包"
	desc = "内装五枚M51A BFAB跳跃空爆破片手榴弹。在狭小空间内使用时务必格外小心。"
	packet_icon = "bfab-p"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/tmfrag

/obj/item/storage/box/packet/heap
	name = "\improper M38 HEAP高爆穿甲榴弹包"
	desc = "内装五枚M38 HEAP高爆穿甲榴弹。"
	packet_icon = "heap-p"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/heap

/obj/item/storage/box/packet/airburst_smoke
	name = "\improper M74空爆烟雾弹包"
	desc = "内装三枚M74空爆烟雾弹。此端朝敌。"
	packet_icon = "hsdp-p"
	content_type = /obj/item/explosive/grenade/smokebomb/airburst

/obj/item/storage/box/packet/rmc
	name = "\improper R2175/A HEDP高爆两用手榴弹包"
	desc = "内装三枚R2175/A HEDP高爆两用手榴弹，请小心操作。"
	storage_slots = 3
	icon_state = "rmc_packet"
	packet_icon = "hedp-p"
	content_type = /obj/item/explosive/grenade/high_explosive/rmc

/obj/item/storage/box/packet/rmc/incin
	name = "\improper R2175/B HIDP燃烧两用手榴弹包"
	desc = "内装三枚R2175/B HIDP燃烧两用手榴弹，请小心操作。"
	storage_slots = 3
	packet_icon = "hiam-p"
	content_type = /obj/item/explosive/grenade/incendiary/rmc

/obj/item/storage/box/packet/rmc/gas
	name = "\improper R2175/CN20毒气手榴弹包"
	desc = "内装三枚R2175/CN20手榴弹，请小心操作。"
	storage_slots = 3
	packet_icon = "bfab-p"
	content_type = /obj/item/explosive/grenade/nerve_gas/xeno/rmc

/obj/item/storage/box/packet/rmc/mini
	name = "\improper L103A1 20mm高爆榴弹包"
	desc = "内装八枚L103A1 20mm高爆榴弹，请小心操作。"
	w_class = SIZE_LARGE //No more bag-storing for these
	storage_slots = 8
	icon_state = "rmc_packet"
	packet_icon = "bfab-p"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/rmc20mm

/obj/item/storage/box/packet/rmc/mini/frag
	name = "\improper L104A1 20mm破片榴弹包"
	desc = "内装八枚L104A1 20mm破片榴弹，请小心操作。"
	packet_icon = "wpsi-p"
	content_type = /obj/item/explosive/grenade/high_explosive/airburst/rmc20mm

/obj/item/storage/box/packet/rmc/mini/incen
	name = "\improper L103A1/I 20mm燃烧榴弹包"
	desc = "内装八枚L103A1/I 20mm燃烧榴弹，请小心操作。"
	packet_icon = "sebb-p"
	content_type = /obj/item/explosive/grenade/incendiary/airburst/rmc20mm

/obj/item/storage/box/packet/rmc/mini/gas
	name = "\improper L101A2 20mm神经毒剂榴弹包"
	desc = "内装八枚L101A2 20mm神经毒气榴弹，请小心操作。"
	packet_icon = "hirr-p"
	content_type = /obj/item/explosive/grenade/smokebomb/airburst/rmc20mm

/obj/item/storage/box/packet/rmc/mini/holo
	name = "\improper L104A1/H 20mm全息标记榴弹包"
	desc = "内装八枚L104A1/H 20mm全息标记榴弹，请小心操作。"
	packet_icon = "hiaf-p"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/rmc20mm/holo

/obj/item/storage/box/packet/rmc/mini/squash
	name = "\improper L108A1 20mm HESH碎甲榴弹包"
	desc = "内装八枚L108A1高爆碎甲榴弹，请小心操作。"
	packet_icon = "heap-p"
	content_type = /obj/item/explosive/grenade/high_explosive/impact/heap/rmc20mm
