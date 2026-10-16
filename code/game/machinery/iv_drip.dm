/obj/structure/machinery/iv_drip
	name = "\improper 静脉输液架"
	icon = 'icons/obj/structures/machinery/iv_drip.dmi'
	anchored = FALSE
	density = FALSE
	drag_delay = 1
	base_pixel_x = 15
	base_pixel_y = -2

	var/mob/living/carbon/attached = null
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/obj/item/reagent_container/beaker = null
	var/datum/beam/current_beam
	//make it so that IV doesn't require power to function.
	use_power = USE_POWER_NONE

/obj/structure/machinery/iv_drip/update_icon()
	if(attached)
		icon_state = "hooked"
	else
		icon_state = ""

	overlays = null

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/structures/machinery/iv_drip.dmi', src, "reagent")

			var/percent = floor((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9) filling.icon_state = "reagent0"
				if(10 to 24) filling.icon_state = "reagent10"
				if(25 to 49) filling.icon_state = "reagent25"
				if(50 to 74) filling.icon_state = "reagent50"
				if(75 to 79) filling.icon_state = "reagent75"
				if(80 to 90) filling.icon_state = "reagent80"
				if(91 to INFINITY) filling.icon_state = "reagent100"

			filling.color = mix_color_from_reagents(reagents.reagent_list)
			overlays += filling

/obj/structure/machinery/iv_drip/proc/update_beam()
	if(current_beam && !attached)
		QDEL_NULL(current_beam)
	else if(!current_beam && attached && !QDELETED(src))
		current_beam = beam(attached, "iv_tube")

/obj/structure/machinery/iv_drip/Destroy()
	attached?.active_transfusions -= src
	attached = null
	update_beam()
	. = ..()

/obj/structure/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()

	if(ishuman(usr))
		var/mob/living/carbon/human/user = usr
		if(user.is_mob_incapacitated() || get_dist(user, src) > 1 || user.blinded)
			return

		if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_NOVICE))
			to_chat(user, SPAN_WARNING("你不知道如何[attached ? "断开" : "连接"]它！"))
			return

		if(attached)
			user.visible_message("[user]断开了\the [src]与\the [attached]的连接。", \
			"你断开了\the [src]与\the [attached]的连接。")
			attached.active_transfusions -= src
			attached = null
			update_beam()
			update_icon()
			stop_processing()
			return

		if(in_range(src, usr) && iscarbon(over_object) && get_dist(over_object, src) <= 1)
			user.visible_message("[user]将\the [src]接在了\the [over_object]身上。", \
			"你将\the [src]接在了\the [over_object]身上。")
			attached = over_object
			attached.active_transfusions += src
			update_beam()
			update_icon()
			start_processing()

/obj/structure/machinery/iv_drip/attackby(obj/item/container, mob/living/user)
	if (istype(container, /obj/item/reagent_container))
		if(beaker)
			to_chat(user, SPAN_WARNING("已经装有试剂容器了！"))
			return

		if((!istype(container, /obj/item/reagent_container/blood) && !istype(container, /obj/item/reagent_container/glass)) || istype(container, /obj/item/reagent_container/glass/bucket))
			to_chat(user, SPAN_WARNING("那东西装不进去！"))
			return

		if(user.drop_inv_item_to_loc(container, src))
			beaker = container

			var/reagentnames = ""

			for(var/datum/reagent/chem in beaker.reagents.reagent_list)
				reagentnames += ";[chem.name]"

			log_admin("[key_name(user)] put \a [beaker] into [src], containing [reagentnames] at ([src.loc.x],[src.loc.y],[src.loc.z]).")

			to_chat(user, "你将\the [container]装到了\the [src]上。")
			update_beam()
			update_icon()
		return
	else
		return ..()


/obj/structure/machinery/iv_drip/process()
	if(src.attached)

		if(!(get_dist(src, src.attached) <= 1 && isturf(src.attached.loc)))
			visible_message("针头从[src.attached]身上被扯了出来，看着都疼！")
			attached.apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
			if(attached.pain.feels_pain)
				attached.emote("scream")
			attached.active_transfusions -= src
			attached = null
			update_beam()
			update_icon()
			stop_processing()
			return

	if(attached && beaker)
		// Give blood
		if(mode)
			if(beaker.volume > 0)
				var/transfer_amount = REAGENTS_METABOLISM
				if(istype(src.beaker, /obj/item/reagent_container/blood))
					// speed up transfer on blood packs
					transfer_amount = 4
				attached.inject_blood(beaker, transfer_amount)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5)) visible_message("\The [src]发出叮的一声。")
				return

			var/mob/living/carbon/patient = attached

			if(!istype(patient))
				return
			if(ishuman(patient))
				var/mob/living/carbon/human/human_patient = patient
				if(human_patient.species && human_patient.species.flags & NO_BLOOD)
					return

			// If the human is losing too much blood, beep.
			if(patient.blood_volume < BLOOD_VOLUME_SAFE) if(prob(5))
				visible_message("\The [src]大声鸣叫。")

			patient.take_blood(beaker,amount)
			update_icon()

/obj/structure/machinery/iv_drip/attack_hand(mob/user as mob)
	if(src.beaker)
		src.beaker.forceMove(get_turf(src))
		src.beaker = null
		update_icon()
	else
		return ..()


/obj/structure/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "切换模式"
	set src in view(1)

	if(!istype(usr, /mob/living))
		return

	if(usr.stat || usr.is_mob_incapacitated())
		return

	mode = !mode
	to_chat(usr, "静脉输液架现在处于[mode ? "输液" : "抽血"]模式。")

/obj/structure/machinery/iv_drip/get_examine_text(mob/user)
	. = ..()
	. += "静脉输液架正在[mode ? "输液" : "抽血"]。"

	if(beaker)
		if(beaker.reagents && length(beaker.reagents.reagent_list))
			. += SPAN_NOTICE("装有\a [beaker]，内含[beaker.reagents.total_volume]单位液体。")
		else
			. += SPAN_NOTICE("装有一个空的[beaker]。")
	else
		. += SPAN_NOTICE("未连接化学品容器。")

	. += SPAN_NOTICE("当前连接对象：[attached ? attached : "无人"]。")
