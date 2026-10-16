/obj/structure/machinery/prop/almayer/CICmap/yautja
	name = "猎手全息球"
	desc = "猎手制造的球形装置，可显示猎场中猎物的位置。"
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "globe"
	breakable = FALSE

	minimap_type = MINIMAP_FLAG_ALL
	faction = FACTION_YAUTJA

/obj/structure/machinery/autolathe/yautja
	name = "铁血战士自动车床"
	desc = "使用金属和玻璃制造物品。"
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	stored_material =  list("metal" = 40000, "glass" = 20000)
	breakable = FALSE

/obj/structure/machinery/prop/yautja/bubbler
	name = "铁血战士煮骨锅"
	desc = "一台发出不祥嗡鸣的大型黑色机器，连着一口盛满沸腾液体的锅。锅中漂浮着像是残余油脂和毛发团的东西。"
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "vat"
	density = TRUE
	breakable = FALSE

/obj/structure/machinery/prop/yautja/bubbler/get_examine_text(mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		. += SPAN_NOTICE("你可以用这台机器去除肢体上的皮肉，获得装饰护甲用的骨骼。")
		. += SPAN_NOTICE("首先找来一条肢体，再用仪式匕首进行处理。")
		. += SPAN_NOTICE("处理完肢体后，将它放入锅中去除血肉，只留下骨骼。")
		. += SPAN_NOTICE("然后用抛光布清洁、打磨骨骼，就可以将它装到护甲上了。")

/obj/structure/machinery/prop/yautja/bubbler/attackby(obj/potential_limb, mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_NOTICE("你不知道这东西是干什么的，也觉得现在不是研究它的时候。"))
		return

	if(!istype(potential_limb, /obj/item/limb))
		to_chat(user, SPAN_NOTICE("你不能把这东西放进[src]。"))
		return
	var/obj/item/limb/current_limb = potential_limb

	if(!current_limb.flayed)
		to_chat(user, SPAN_NOTICE("这条肢体还没处理好。"))
		return
	icon_state = "vat_boiling"
	to_chat(user, SPAN_WARNING("你放入[current_limb]并启动煮骨锅。"))
	if(!do_after(user, 15 SECONDS, INTERRUPT_NONE, BUSY_ICON_HOSTILE, current_limb))
		to_chat(user, SPAN_NOTICE("你把[current_limb]从锅中拿了出来。"))
		icon_state = initial(icon_state)
		return
	icon_state = initial(icon_state)

	var/obj/item/clothing/accessory/limb/skeleton/new_bone = new current_limb.bone_type(get_turf(src))
	if(istype(new_bone, /obj/item/clothing/accessory/limb/skeleton/head))
		new_bone.desc = SPAN_NOTICE("这颗头骨原本是[current_limb.name]。")
	qdel(current_limb)
