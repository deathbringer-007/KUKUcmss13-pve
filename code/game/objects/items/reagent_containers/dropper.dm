////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_container/dropper
	name = "滴管"
	desc = "一支滴管，每次转移5单位液体。"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	w_class = SIZE_TINY
	volume = 5
	matter = list("plastic" = 150)
	transparent = TRUE
	var/filled = 0

/obj/item/reagent_container/dropper/afterattack(obj/target, mob/user , flag)
	if(!target.reagents || !flag) return

	if(filled)

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[target]已满。"))
			return

		if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/reagent_container/food) && !istype(target, /obj/item/clothing/mask/cigarette)) //You can inject humans and food but you cant remove the shit.
			to_chat(user, SPAN_DANGER("你无法直接向这件物品中注入液体。"))
			return

		var/trans = 0

		if(ismob(target))

			var/time = 20 //2/3rds the time of a syringe
			for(var/mob/O in viewers(GLOB.world_view_size, user))
				O.show_message(SPAN_DANGER("<B>[user]正试图将某种液体滴入[target]的眼睛！</B>"), SHOW_MESSAGE_VISIBLE)

			if(!do_after(user, time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)) return

			if(istype(target , /mob/living/carbon/human))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = null
				if( victim.wear_mask )
					if ( victim.wear_mask.flags_inventory & COVEREYES )
						safe_thing = victim.wear_mask
				if( victim.head )
					if ( victim.head.flags_inventory & COVEREYES )
						safe_thing = victim.head
				if(victim.glasses)
					if ( !safe_thing )
						safe_thing = victim.glasses

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)
					trans = src.reagents.trans_to(safe_thing, amount_per_transfer_from_this)

					for(var/mob/O in viewers(GLOB.world_view_size, user))
						O.show_message(SPAN_DANGER("<B>[user]试图将某种液体滴入[target]的眼睛，但失败了！</B>"), SHOW_MESSAGE_VISIBLE)
					spawn(5)
						src.reagents.reaction(safe_thing, TOUCH)

					to_chat(user, SPAN_NOTICE("你转移了[trans]单位溶液。"))
					if (src.reagents.total_volume<=0)
						filled = 0
						icon_state = "dropper[filled]"
					return

			for(var/mob/O in viewers(GLOB.world_view_size, user))
				O.show_message(SPAN_DANGER("<B>[user]将某种液体滴入了[target]的眼睛！</B>"), SHOW_MESSAGE_VISIBLE)
			src.reagents.reaction(target, TOUCH)

			var/mob/living/M = target

			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been squirted with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to squirt [M.name] ([M.key]). Reagents: [contained]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) squirted [M.name] ([M.key]) with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

		trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("你转移了[trans]单位溶液。"))
		if (src.reagents.total_volume<=0)
			filled = 0
			icon_state = "dropper[filled]"

	else

		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			to_chat(user, SPAN_DANGER("你无法直接从[target]中抽取试剂。"))
			return

		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target]是空的。"))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("你未能从[target]中抽取试剂。"))
			return

		to_chat(user, SPAN_NOTICE("你向滴管中吸入了[trans]单位溶液。"))

		filled = 1
		icon_state = "dropper[filled]"

	return

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
