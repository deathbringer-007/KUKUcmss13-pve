/obj/item/bananapeel
	name = "香蕉皮"
	desc = "剥下来的香蕉皮。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = SIZE_TINY
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	garbage = TRUE

/obj/item/bananapeel/Crossed(AM as mob|obj)
	if (iscarbon(AM))
		var/mob/living/carbon/C = AM
		C.slip(name, 4, 2)

/*
/obj/item/game_kit
	name = "Gaming Kit"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = SIZE_HUGE
*/

/obj/item/gift
	name = "礼物"
	desc = "一件包装好的物品。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "gift3"
	var/size = 3
	var/obj/item/gift = null
	item_state = "gift"
	w_class = SIZE_LARGE

/obj/item/weapon/pole
	name = "木杆"
	desc = "一根粗糙开裂的木杆，似乎是就地制作的。大概可以用来揍人。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "wooden_pole"
	item_state = "wooden_pole"
	force = 20
	attack_speed = 1.5 SECONDS
	var/gripped = FALSE

/obj/item/weapon/pole/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("拿在手中时激活即可握紧。如果你的腿脚不便，会很有用。")

/obj/item/weapon/pole/attack_self(mob/living/user)
	..()
	if(!gripped)
		user.visible_message(SPAN_NOTICE("[user]握紧了[src]。"), SPAN_NOTICE("你握紧了[src]。"))
		flags_item |= NODROP|FORCEDROP_CONDITIONAL
		ADD_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM)
		user.AddComponent(/datum/component/footstep, 6, 35, 4, 1, "cane_step")
		gripped = TRUE
	else
		user.visible_message(SPAN_NOTICE("[user]松开了握着[src]的手。"), SPAN_NOTICE("你松开了握着[src]的手。"))
		flags_item &= ~(NODROP|FORCEDROP_CONDITIONAL)
		REMOVE_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM)
		// Ideally, this would be something like a component added onto every mob that prioritizes certain sounds, such as stomping over canes.
		var/component = user.GetComponent(/datum/component/footstep)
		qdel(component)
		// However, I'm not going to do that. :)
		gripped = FALSE

/obj/item/weapon/pole/pickup(mob/user, silent)
	. = ..()
	gripped = FALSE
	REMOVE_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM) // no fucking around with two canes
	var/component = user.GetComponent(/datum/component/footstep)
	qdel(component)

/obj/item/weapon/pole/dropped(mob/user)
	. = ..()
	gripped = FALSE
	REMOVE_TRAIT(user, TRAIT_HOLDS_CANE, TRAIT_SOURCE_ITEM) // in case their arm is chopped off or something
	var/component = user.GetComponent(/datum/component/footstep)
	qdel(component)

/obj/item/weapon/pole/wooden_cane
	name = "木手杖"
	desc = "一根再普通不过的木手杖，杖头颜色较深。"
	icon_state = "wooden_cane"
	item_state = "wooden_cane"
	force = 15

/obj/item/weapon/pole/fancy_cane
	name = "华丽手杖"
	desc = "一根乌木手杖，杖头装饰华丽，看起来是金制的。"
	icon_state = "fancy_cane"
	item_state = "fancy_cane"
	force = 30

/obj/item/weapon/pole/fancy_cane/this_is_a_knife
	name = "华丽手杖"
	desc = "一根乌木手杖，杖头装饰华丽，看起来是金制的。摸起来似乎是空心的。"
	force = 15 // hollow
	var/obj/item/stored_item
	var/list/allowed_items = list(/obj/item/weapon, /obj/item/attachable/bayonet)

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/Destroy()
	if(stored_item)
		QDEL_NULL(stored_item)
	. = ..()

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/attack_hand(mob/living/mobber)
	if(stored_item && src.loc == mobber && !mobber.is_mob_incapacitated()) //Only allow someone to take out the stored_item if it's being worn or held. So you can pick them up off the floor
		if(mobber.put_in_active_hand(stored_item))
			mobber.visible_message(SPAN_DANGER("[mobber]从[src]中抽出了[stored_item]！"), SPAN_NOTICE("你从[src]中抽出了[stored_item]。"))
			playsound(mobber, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
			stored_item = null
			update_icon()
		return
	..()

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/update_icon()
	if(stored_item == null)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/attackby(obj/item/object, mob/living/mobber)
	if(length(allowed_items))
		for (var/i in allowed_items)
			if(istype(object, i))
				if(stored_item)
					return
				stored_item = object
				mobber.drop_inv_item_to_loc(object, src)
				to_chat(mobber, SPAN_NOTICE("你将[object]插入了[src]。"))
				playsound(mobber, 'sound/weapons/gun_shotgun_shell_insert.ogg', 15, TRUE)
				update_icon()
				break
	. = ..()

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/machete
	stored_item = new /obj/item/weapon/sword/machete

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/ceremonial_sword
	stored_item = new /obj/item/weapon/sword/ceremonial

/obj/item/weapon/pole/fancy_cane/this_is_a_knife/katana
	stored_item = new /obj/item/weapon/sword/katana

// IN SHOTGUNS.DM!!

/*obj/item/weapon/pole/fancy_cane/gun
	name = "fancy cane"
	desc = "An ebony cane with a fancy, seemingly-golden tip. Feels hollow to the touch."
	force = 15 // hollow
*/

/obj/item/research//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/items/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."

/obj/item/moneybag
	icon = 'icons/obj/items/storage/bags.dmi'
	name = "钱袋"
	icon_state = "moneybag"
	force = 10
	throwforce = 2
	w_class = SIZE_LARGE





/obj/item/evidencebag
	name = "物证袋"
	desc = "一个空物证袋。"
	icon = 'icons/obj/items/storage/bags.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = SIZE_SMALL
	var/obj/item/stored_item = null

/obj/item/evidencebag/MouseDrop(obj/item/I as obj)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if (!(user.l_hand == src || user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage)) //in a container.
			var/depth = I.get_storage_depth_to(user)
			if (!depth || depth > 2)
				return //too deeply nested to access or not being carried by the user.

			var/obj/item/storage/U = I.loc
			user.client.remove_from_screen(I)
			U.contents.Remove(I)
		else if(user.l_hand == I) //in a hand
			user.drop_l_hand()
		else if(user.r_hand == I) //in a hand
			user.drop_r_hand()
		else
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, SPAN_NOTICE("你觉得把物证袋装进另一个物证袋有点荒唐。"))
		return

	if(I.w_class > SIZE_MEDIUM)
		to_chat(user, SPAN_NOTICE("[src]装不下[I]。"))
		return

	if(length(contents))
		to_chat(user, SPAN_NOTICE("[src]里面已经装了东西。"))
		return

	user.visible_message("[user]把[I]放进了[src]。", "你把[I]放进了[src]。",\
	"你听见一阵沙沙声，有人正把东西放进塑料袋里。")

	icon_state = "evidence"
	/// save the offset of the item
	var/xx = I.pixel_x
	var/yy = I.pixel_y
	/// then remove it so it'll stay within the evidence bag
	I.pixel_x = 0
	I.pixel_y = 0
	/// take a snapshot. (necessary to stop the underlays appearing under our inventory-HUD slots) ~Carn
	var/image/img = image("icon"=I, "layer"=FLOAT_LAYER)
	/// and then return it
	I.pixel_x = xx
	I.pixel_y = yy
	overlays += img
	/// should look nicer for transparent stuff. not really that important, but hey.
	overlays += "evidence"

	desc = "一个装有[I]的物证袋。"
	I.forceMove(src)
	stored_item = I
	w_class = I.w_class
	return


/obj/item/evidencebag/attack_self(mob/user)
	..()

	if(length(contents))
		var/obj/item/I = contents[1]
		user.visible_message("[user]从[src]中取出了[I]。", "你从[src]中取出了[I]。",\
		"你听见有人翻动塑料袋的沙沙声，随后取出了什么东西。")
		overlays.Cut() //remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "一个空物证袋。"
	else
		to_chat(user, "[src]是空的。")
		icon_state = "evidenceobj"
	return

/obj/item/evidencebag/get_examine_text(mob/user)
	. = ..()
	if(stored_item)
		. += stored_item.get_examine_text(user)

/obj/item/storage/box/evidence
	name = "物证袋盒"
	desc = "一个标称装有物证袋的盒子。"

/obj/item/storage/box/evidence/New()
	..()
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)

/obj/item/parachute
	name = "降落伞包"
	desc = "一个小得出奇却又笨重的背包，安全带数量刚好够研发部门通过安全检查。标签说里面有主伞和备份伞两具降落伞，但你怀疑连一具都装不下。"
	icon = 'icons/obj/items/clothing/backpacks.dmi'
	icon_state = "parachute_pack"
	item_state = "parachute_pack"
	w_class = SIZE_MASSIVE
	flags_equip_slot = SLOT_BACK
	flags_item = SMARTGUNNER_BACKPACK_OVERRIDE

/obj/item/rappel_harness
	name = "索降安全带"
	desc = "一套简陋且不舒服的索降安全带，带子数量刚好够研发部门通过安全检查。内置下降器，但没有弹药袋。"
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "rappel_harness"
	item_state = "rappel_harness"
	w_class = SIZE_MASSIVE
	flags_equip_slot = SLOT_WAIST

/obj/item/rappel_harness/extract
	name = "索降／富尔顿回收两用安全带"
	desc = "富尔顿地对空回收系统（STARS）。特殊的锁扣和挂钩组件让配有索降系统的飞行器在掠过时收走固定的物品或人员。不过，复杂的文拉尔纤维索具和安全扣需要花些时间才能装好。"
	icon_state = "rappel_harness_adv"
	var/shuttle_id
	actions_types = list(/datum/action/item_action/STARS)

/obj/item/rappel_harness/extract/proc/try_extract(mob/living/carbon/human/user)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_id)

	if(!shuttle)
		return

	if(!shuttle.in_flyby)
		to_chat(user, SPAN_WARNING("未在低轨道检测到运输机，回收中止。"))
		return

	var/obj/structure/dropship_equipment/paradrop_system/rapsys = locate() in shuttle.equipments
	if(!rapsys)
		to_chat(user, SPAN_WARNING("未在运输机上检测到索降系统，回收中止。"))
		return

	user.visible_message(SPAN_DANGER("一股巨力将[user]猛地拽离了地面！"))
	if(prob(50))
		user.emote("scream")
	user.apply_effect(10, STUN)
	animate(user, time = 2, pixel_x = 360, pixel_y = 360, flags = ANIMATION_PARALLEL)
	playsound(user,'sound/effects/bamf.ogg', 50, 1)
	addtimer(CALLBACK(src, PROC_REF(on_extract), user, rapsys), 1.5 SECONDS)

/obj/item/rappel_harness/extract/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(H.belt)
		to_chat(user, SPAN_WARNING("先摘掉对方的腰带！"))
		return

	if(!is_ground_level(H.z))
		return

	var/area/location_area = get_area(H)
	if(CEILING_IS_PROTECTED(location_area.ceiling, CEILING_PROTECTION_TIER_1))
		to_chat(H, SPAN_WARNING("这里没有足够的空间让富尔顿气球升空。"))
		return

	user.visible_message(SPAN_DANGER("[user]开始调整[H]身上的富尔顿装置，准备回收！"))
	playsound(H, 'sound/items/fulton.ogg', 50, 1)
	if(!do_after(user, (10 SECONDS), INTERRUPT_ALL, BUSY_ICON_HOSTILE, H))
		return

	if(H.belt)
		to_chat(user, SPAN_WARNING("摘掉对方的腰带！"))
		return
	user.drop_inv_item_to_loc(src, H)
	H.equip_to_slot_if_possible(src, WEAR_WAIST)
	try_extract(H)

/obj/item/rappel_harness/extract/proc/on_extract(mob/living/carbon/human/user, obj/structure/dropship_equipment/paradrop_system/system)
	flick("rappel_hatch_opening", system)
	user.pixel_x = 0
	user.pixel_y = 0
	user.forceMove(get_turf(system))
	user.apply_effect(5, WEAKEN)
	if(prob(25))
		user.do_vomit()

/datum/action/item_action/STARS/New(Target, obj/item/holder)
	. = ..()
	name = "尝试回收"
	action_icon_state = "extract"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/STARS/action_activate()
	. = ..()
	var/obj/item/rappel_harness/extract/harness = holder_item
	var/mob/living/carbon/human/H = usr
	if(H.belt != harness)
		to_chat(H, SPAN_WARNING("必须将安全带装备在腰带栏位！"))
		return
	if(!is_ground_level(H.z))
		return

	var/area/location_area = get_area(H)
	if(CEILING_IS_PROTECTED(location_area.ceiling, CEILING_PROTECTION_TIER_1))
		to_chat(H, SPAN_WARNING("这里没有足够的空间让富尔顿气球升空。"))
		return
	H.visible_message(SPAN_DANGER("[H]开始调整富尔顿装置，准备自行撤离！"))
	playsound(H, 'sound/items/fulton.ogg', 50, 1)
	if(!do_after(H, (10 SECONDS), INTERRUPT_ALL, BUSY_ICON_HOSTILE, harness))
		return

	harness.try_extract(H)

/obj/item/rappel_harness/extract/midway
	shuttle_id = DROPSHIP_MIDWAY

/obj/item/rappel_harness/extract/cyclone
	shuttle_id = DROPSHIP_CYCLONE

/obj/item/rappel_harness/extract/typhoon
	shuttle_id = DROPSHIP_TYPHOON

/obj/item/rappel_harness/extract/tornado
	shuttle_id = DROPSHIP_TORNADO

/obj/item/rappel_harness/extract/tripoli
	shuttle_id = DROPSHIP_TRIPOLI

/obj/item/rappel_harness/extract/alamo
	shuttle_id = DROPSHIP_ALAMO

/obj/item/rappel_harness/extract/normandy
	shuttle_id = DROPSHIP_NORMANDY

/obj/item/rappel_harness/extract/nauk
	shuttle_id = DROPSHIP_UPP

/obj/item/rappel_harness/extract/rmc
	shuttle_id = DROPSHIP_GIBRALTAR
