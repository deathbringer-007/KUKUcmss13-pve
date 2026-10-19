////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/reagent_container/syringe
	name = "注射器"
	desc = "一支注射器。"
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	matter = list("glass" = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15
	w_class = SIZE_TINY
	flags_item = NOBLUDGEON
	sharp = IS_SHARP_ITEM_SIMPLE
	transparent = TRUE
	reagent_desc_override = TRUE //uses display_contents
	var/mode = SYRINGE_DRAW

/obj/item/reagent_container/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_container/syringe/get_examine_text(mob/user)
	. = ..()
	var/pill_info = display_contents(user)
	if(pill_info)
		. += pill_info


/obj/item/reagent_container/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/syringe/attack_self(mob/user)
	..()

	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_container/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_container/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return
	if(!target.reagents) return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_DANGER("这支注射器已经损坏！"))
		return

	if (user.a_intent == INTENT_HARM && ismob(target))
		var/mob/M = target
		if(M != user && M.stat != DEAD && M.a_intent == INTENT_HARM && !M.is_mob_incapacitated() && M.faction != user.faction && (skillcheck(M, SKILL_CQC, SKILL_CQC_SKILLED) || isyautja(M))) // preds have null skills
			user.apply_effect(0.5, WEAKEN)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Used CQC skill to stop [key_name(user)] injecting them.</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Was stopped from injecting [key_name(M)] by their cqc skill.</font>")
			msg_admin_attack("[key_name(user)] got robusted by the CQC of [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			M.visible_message(SPAN_DANGER("[M]本能地出手，在[user]使用[src]之前将其击倒！"), \
				SPAN_WARNING("你在[user]给你注射前将其击倒！"), null, 5)
			playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
			return

		syringestab(target, user)
		return

	var/injection_time = 10 SECONDS
	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
			to_chat(user, SPAN_WARNING("你没有接受过注射器使用训练……最好慢慢来。"))
		else
			injection_time = ((injection_time/5)*user.get_skill_duration_multiplier(SKILL_MEDICAL))


	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("注射器已经装满。"))
				return

			if(ismob(target))//Blood!
				if(iscarbon(target))//maybe just add a blood reagent to all mobs. Then you can suck them dry...With hundreds of syringes. Jolly good idea.
					var/amount = src.reagents.maximum_volume - src.reagents.total_volume
					var/mob/living/carbon/T = target
					if(T.get_blood_id() && reagents.has_reagent(T.get_blood_id()))
						to_chat(user, SPAN_DANGER("这支注射器中已经有血样。"))
						return

					if(ishuman(T))
						var/mob/living/carbon/human/H = T
						if(H.species.flags & NO_BLOOD)
							to_chat(user, SPAN_DANGER("你找不到任何血液。"))
							return
						else
							T.take_blood(src,amount)
					else
						T.take_blood(src,amount)

					on_reagent_change()
					reagents.handle_reactions()
					user.visible_message(SPAN_WARNING("[user]从[target]身上抽取了一份血样。"),
						SPAN_NOTICE("你从[target]身上抽取了一份血样。"), null, 4)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_DANGER("[target]是空的。"))
					return

				if(!target.is_open_container() && !target.can_be_syringed())
					to_chat(user, SPAN_DANGER("你无法直接从这个物品中抽取试剂。"))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				if(!trans)
					to_chat(user, SPAN_DANGER("你没能从[target]中抽取试剂。"))
					return

				to_chat(user, SPAN_NOTICE("你向注射器中抽入了[trans]单位溶液。"))
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_DANGER("注射器是空的。"))
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !target.can_be_syringed())
				to_chat(user, SPAN_DANGER("你无法直接向这个物品中注入试剂。"))
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("[target]已经装满。"))
				return

			if(ismob(target))
				var/mob/living/M = target
				if(!istype(M))
					return
				if(!M.can_inject(user, TRUE))
					return
				if(target != user)

					if(ishuman(target))
						var/mob/living/carbon/human/H = target
						if(istype(H.wear_suit, /obj/item/clothing/suit/space))
							injection_time = 60

					if(injection_time != 60)
						user.visible_message(SPAN_DANGER("<B>[user]正试图给[target]注射！</B>"))
					else
						user.visible_message(SPAN_DANGER("<B>[user]开始在[target]的防护服上寻找注射接口！</B>"))

					if(!do_after(user, injection_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)) return

					user.visible_message(SPAN_DANGER("[user]用注射器给[target]注射！"))

					var/list/injected = list()
					for(var/datum/reagent/R in src.reagents.reagent_list)
						injected += R.name
						R.last_source_mob = WEAKREF(user)
					var/contained = english_list(injected)
					M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [key_name(user)]. Reagents: [contained]</font>")
					user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [key_name(M)]. Reagents: [contained]</font>")
					msg_admin_attack("[key_name(user)] injected [key_name(M)] with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				reagents.reaction(target, INGEST)


			var/trans = amount_per_transfer_from_this
			if(iscarbon(target) && locate(/datum/reagent/blood) in reagents.reagent_list)
				var/mob/living/carbon/C = target
				C.inject_blood(src, amount_per_transfer_from_this)
			else

				var/list/reagents_in_syringe = list()
				for(var/datum/reagent/R in reagents.reagent_list)
					reagents_in_syringe += R.name
				var/contained = english_list(reagents_in_syringe)
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>[key_name(user)] injected [target] with a syringe (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))])</font>")
				msg_admin_niche("[key_name(user)] injected [target] with a syringe (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

				trans = reagents.trans_to(target, amount_per_transfer_from_this)

			to_chat(user, SPAN_NOTICE("你注射了[trans]单位溶液。注射器中还剩[src.reagents.total_volume]单位。"))
			if (reagents.total_volume <= 0 && mode==SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()


/obj/item/reagent_container/syringe/update_icon()
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		overlays.Cut()
		return
	var/rounded_vol = round(reagents.total_volume,5)
	overlays.Cut()
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		overlays += injoverlay
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"
	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/person = loc
		if(person.r_hand == src)
			person.update_inv_r_hand()
		if(person.l_hand == src)
			person.update_inv_l_hand()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling


/obj/item/reagent_container/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [key_name(target)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [key_name(user)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))])</font>"
	msg_admin_attack("[key_name(user)] attacked [key_name(target)] with [src.name] (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/target_zone = rand_zone(check_zone(user.zone_selected, target))
		var/obj/limb/affecting = H.get_limb(target_zone)

		if (!affecting)
			return
		if(affecting.status & LIMB_DESTROYED)
			to_chat(user, "哪来的[affecting.display_name]？")
			return
		var/hit_area = affecting.display_name

		if((user != target) && H.check_shields(7, "the [src.name]"))
			return

		if (target != user && target.getarmor(target_zone, ARMOR_MELEE) > 5 && prob(50))
			for(var/mob/O in viewers(GLOB.world_view_size, user))
				O.show_message(text(SPAN_DANGER("<B>[user]试图用[src.name]刺中[target]的[localized_player_label(hit_area)]，但被护甲挡开了！</B>")), SHOW_MESSAGE_VISIBLE)
			user.temp_drop_inv_item(src)
			qdel(src)
			return

		for(var/mob/O in viewers(GLOB.world_view_size, user))
			O.show_message(text(SPAN_DANGER("<B>[user]用[src.name]刺中了[target]的[localized_player_label(hit_area)]！</B>")), SHOW_MESSAGE_VISIBLE)

		if(affecting.take_damage(3))
			target:UpdateDamageIcon()

	else
		for(var/mob/O in viewers(GLOB.world_view_size, user))
			O.show_message(text(SPAN_DANGER("<B>[user]用[src.name]刺中了[target]！</B>")), SHOW_MESSAGE_VISIBLE)
		target.take_limb_damage(3)// 7 is the same as crowbar punch

	src.reagents.reaction(target, INGEST)
	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	src.reagents.trans_to(target, syringestab_amount_transferred)
	src.desc += " 它已经损坏。"
	src.mode = SYRINGE_BROKEN
	src.add_mob_blood(target)
	src.add_fingerprint(usr)
	src.update_icon()


/obj/item/reagent_container/ld50_syringe
	name = "致命注射器"
	desc = "用于执行致命注射的注射器。"
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = null //list(5,10,15)
	volume = 50
	var/mode = SYRINGE_DRAW

/obj/item/reagent_container/ld50_syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_container/ld50_syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/ld50_syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/ld50_syringe/attack_self(mob/user)
	..()
	mode = !mode
	update_icon()

/obj/item/reagent_container/ld50_syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/ld50_syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/reagent_container/ld50_syringe/afterattack(obj/target, mob/user , flag)
	if(!target.reagents) return

	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("注射器已经装满。"))
				return

			if(ismob(target))
				if(istype(target, /mob/living/carbon))//I Do not want it to suck 50 units out of people
					to_chat(usr, "这种针头不能用于抽血。")
					return
			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, SPAN_DANGER("[target]是空的。"))
					return

				if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
					to_chat(user, SPAN_DANGER("你无法直接从这个物品中抽取试剂。"))
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				if(!trans)
					to_chat(user, SPAN_DANGER("你没能从[target]中抽取试剂。"))
					return

				to_chat(user, SPAN_NOTICE("你向注射器中抽入了[trans]单位溶液。"))
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, SPAN_DANGER("注射器是空的。"))
				return
			if(istype(target, /obj/item/implantcase/chem))
				return
			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_container/food))
				to_chat(user, SPAN_DANGER("你无法直接向这个物品中注入试剂。"))
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, SPAN_DANGER("[target]已经装满。"))
				return

			if(ismob(target) && target != user)
				user.visible_message(SPAN_DANGER("<B>[user]正试图用巨型注射器给[target]注射！</B>"))
				if(!do_after(user, 300, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)) return
				user.visible_message(SPAN_DANGER("[user]用巨型注射器给[target]注射！"))
				src.reagents.reaction(target, INGEST)
			if(ismob(target) && target == user)
				src.reagents.reaction(target, INGEST)
			spawn(5)
				var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
				to_chat(user, SPAN_NOTICE("你注射了[trans]单位溶液。注射器中还剩[src.reagents.total_volume]单位。"))
				if (reagents.total_volume >= reagents.maximum_volume && mode==SYRINGE_INJECT)
					mode = SYRINGE_DRAW
					update_icon()
	return


/obj/item/reagent_container/ld50_syringe/update_icon()
	var/rounded_vol = round(reagents.total_volume,50)
	if(ismob(loc))
		var/mode_t
		switch(mode)
			if (SYRINGE_DRAW)
				mode_t = "d"
			if (SYRINGE_INJECT)
				mode_t = "i"
		icon_state = "[mode_t][rounded_vol]"
	else
		icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"


////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////



/obj/item/reagent_container/syringe/inaprovaline
	name = "\improper 注射器（因纳普罗伐林）"
	desc = "内含因纳普罗伐林，用于稳定患者病情。"

/obj/item/reagent_container/syringe/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/antitoxin
	name = "注射器（抗毒素）"
	desc = "内含抗毒素。"

/obj/item/reagent_container/syringe/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/antiviral
	name = "\improper 注射器（太空西林）"
	desc = "内含抗病毒药物，也可治疗伤口感染。"

/obj/item/reagent_container/syringe/antiviral/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/counteragent
	name = "\improper 注射器（拮抗剂）"
	desc = "内含特殊抗病毒拮抗剂。"

/obj/item/reagent_container/syringe/counteragent/Initialize()
	. = ..()
	reagents.add_reagent("vaccine", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/drugs
	name = "注射器（药物）"
	desc = "内含用于拷问的强烈药物。"

/obj/item/reagent_container/syringe/drugs/Initialize()
	. = ..()
	reagents.add_reagent("space_drugs",  5)
	reagents.add_reagent("mindbreaker",  5)
	reagents.add_reagent("cryptobiolin", 5)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/oxycodone
	name = "注射器（羟考酮）"
	desc = "内含小剂量强效止痛药。"

/obj/item/reagent_container/syringe/oxycodone/Initialize()
	. = ..()
	reagents.add_reagent("oxycodone",  5)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/ld50_syringe/choral

/obj/item/reagent_container/ld50_syringe/choral/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 50)
	mode = SYRINGE_INJECT
	update_icon()


//Robot syringes
//Not special in any way, code wise. They don't have added variables or procs.
/obj/item/reagent_container/syringe/robot/antitoxin
	name = "注射器（抗毒素）"
	desc = "内含抗毒素。"

/obj/item/reagent_container/syringe/robot/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/robot/inoprovaline
	name = "\improper 注射器（因纳普罗伐林）"
	desc = "内含因纳普罗伐林，用于稳定患者病情。"

/obj/item/reagent_container/syringe/robot/inoprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/robot/mixed
	name = "\improper 注射器（混合药物）"
	desc = "内含因纳普罗伐林与抗毒素。"

/obj/item/reagent_container/syringe/robot/mixed/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 7)
	reagents.add_reagent("anti_toxin", 8)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_container/syringe/leporazine_dermaline
	name = "注射器（体温稳定剂）"
	desc = "内含用于稳定体温的勒泊嗪，以及快速治疗烧伤的德玛林。"

/obj/item/reagent_container/syringe/leporazine_dermaline/Initialize()
	. = ..()
	reagents.add_reagent("leporazine", 5)
	reagents.add_reagent("dermaline", 10)
	mode = SYRINGE_INJECT
	update_icon()
