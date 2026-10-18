/obj/structure/reagent_dispensers
	name = "分配器"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE
	drag_delay = 1
	health = 100 // Can be destroyed in 2-4 slashes.
	flags_atom = CAN_BE_SYRINGED
	wrenchable = TRUE
	unslashable = FALSE
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(5,10,20,30,40,50,60,100,200,300)
	var/chemical = ""
	var/dispensing = TRUE

/obj/structure/reagent_dispensers/Initialize(mapload, reagent_amount = 1000)
	. = ..()
	create_reagents(reagent_amount)
	if(!possible_transfer_amounts)
		verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
	if(chemical)
		reagents.add_reagent(chemical, reagent_amount)
	if(!anchored && is_ground_level(z) && prob(70))
		anchored = TRUE

/obj/structure/reagent_dispensers/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND|PASS_UNDER

/obj/structure/reagent_dispensers/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc) return
	. += SPAN_NOTICE("其中装有：")
	if(reagents && length(reagents.reagent_list))
		for(var/datum/reagent/R in reagents.reagent_list)
			. += SPAN_NOTICE(" [R.name]，共[R.volume]单位")
	else
		. += SPAN_NOTICE(" 空无一物。")
	if(reagents)
		. += SPAN_NOTICE("总容量：[reagents.total_volume]/[reagents.maximum_volume]。")
	if(dispensing)
		. += SPAN_NOTICE("\n输送模式：输出")
	else
		. += SPAN_NOTICE("\n输送模式：注入")
	. += SPAN_NOTICE("输送量：[amount_per_transfer_from_this]单位")

/obj/structure/reagent_dispensers/Destroy()
	playsound(src.loc, 'sound/effects/slosh.ogg', 50, 1, 3)
	visible_message(SPAN_NOTICE("[src]散架了，里面的液体洒得到处都是！"))
	. = ..()

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "设置输送量"
	set category = "Object"
	set src in view(1)

	if(!ishuman(usr))
		return

	if(!reagents || reagents.locked)
		return

	var/N = tgui_input_list(usr, "每次转移的数量：","[src]", possible_transfer_amounts)
	if(N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/proc/healthcheck()
	if(health <= 0)
		deconstruct(FALSE)

/obj/structure/reagent_dispensers/bullet_act(obj/projectile/Proj)
	health -= Proj.damage
	if(Proj.firer)
		msg_admin_niche("[key_name_admin(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]) [ADMIN_JMP(loc)].")
		log_game("[key_name(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]).")
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	healthcheck()
	return TRUE

/obj/structure/reagent_dispensers/verb/set_transfer_direction() //set amount_per_transfer_from_this
	set name = "设置输送方向"
	set category = "Object"
	set src in view(1)

	if(!ishuman(usr))
		return

	if(!reagents || reagents.locked)
		return

	dispensing = !dispensing
	if(dispensing)
		to_chat(usr, SPAN_NOTICE("[src]现已设为输出模式。"))
	else
		to_chat(usr, SPAN_NOTICE("[src]现已设为注入模式。"))

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(5))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/reagent_dispensers/attack_hand()
	if(!reagents || reagents.locked)
		return

	var/N = tgui_input_list(usr, "每次转移的数量：","[src]", possible_transfer_amounts)
	if(N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/clicked(mob/user, list/mods)
	if(!Adjacent(user))
		return ..()

	if(!ishuman(user))
		return ..()

	if(!reagents || reagents.locked)
		return ..()

	if(mods[ALT_CLICK])
		dispensing = !dispensing
		if(dispensing)
			to_chat(user, SPAN_NOTICE("[src]现已设为输出模式。"))
		else
			to_chat(user, SPAN_NOTICE("[src]现已设为注入模式。"))
		return TRUE
	return ..()

/obj/structure/reagent_dispensers/attackby(obj/item/hit_item, mob/living/user)
	if(istype(hit_item, /obj/item/reagent_container))
		return
	..()

//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "水箱"
	desc = "一个储水箱。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	chemical = "water"

/obj/structure/reagent_dispensers/ammoniatank
	name = "氨罐"
	desc = "一个储氨罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "ammoniatank"
	chemical = "ammonia"

/obj/structure/reagent_dispensers/acidtank
	name = "硫酸罐"
	desc = "一个硫酸储罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "sacidtank"
	chemical = "sulphuric acid"

/obj/structure/reagent_dispensers/pacidtank
	name = "多元酸罐"
	desc = "一个多元酸储罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "pacidtank"
	chemical = "pacid"

/obj/structure/reagent_dispensers/ethanoltank
	name = "乙醇罐"
	desc = "一个乙醇储罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "ethanoltank"
	chemical = "ethanol"

/obj/structure/reagent_dispensers/fueltank
	name = "燃油罐"
	desc = "一个燃油储罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	chemical = "fuel"
	black_market_value = 25
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null
	var/exploding = 0
	var/reinforced = FALSE
	var/datum/weakref/source_mob

/obj/structure/reagent_dispensers/fueltank/get_examine_text(mob/user)
	. = ..()
	if(user != loc)
		return
	if(modded)
		. += SPAN_DANGER("燃油阀已被拧开，正在泄漏燃油！")
	if(rig)
		. += SPAN_NOTICE("罐上似乎安装了某种装置。")
	if(reinforced)
		. += SPAN_NOTICE("它似乎装有金属防护层。")

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if(rig)
		usr.visible_message("[usr]开始从[src]上拆下[rig]。", "你开始从 \the [src] 上拆下 [rig]。")
		if(do_after(usr, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			usr.visible_message(SPAN_NOTICE("[usr]从[src]上拆下了[rig]。"), SPAN_NOTICE(" 你从[src]上拆下了[rig]。"))
			rig.forceMove(get_turf(usr))
			rig = null
			update_icon()
	else
		. = ..()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(user.action_busy)
		to_chat(user, SPAN_WARNING("你正在执行其他动作！"))
		return

	/*if (HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		user.visible_message("[user] wrenches [src]'s faucet [modded ? "closed" : "open"].", \
			"You wrench [src]'s faucet [modded ? "closed" : "open"]")
		modded = modded ? 0 : 1
		if (modded)
			message_admins("[key_name_admin(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel. [ADMIN_JMP(loc)]")
			log_game("[key_name(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel.")
			leak_fuel(amount_per_transfer_from_this)*/
	if(istype(W,/obj/item/device/assembly_holder))

		if(rig)
			to_chat(user, SPAN_DANGER("有另一个装置挡住了位置。"))
			return ..()

		user.visible_message("[user]开始将[W]安装到[src]上。", "你开始将 [W] 装到 \the [src] 上。")

		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
			return

		if(rig)
			to_chat(user, SPAN_DANGER("有另一个装置挡住了位置。"))
			return ..()

		user.visible_message(SPAN_NOTICE("[user]将[W]安装到了[src]上。"), SPAN_NOTICE(" 你将[W]安装到了[src]上。"))

		var/obj/item/device/assembly_holder/H = W
		if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
			msg_admin_niche("[key_name_admin(user)] rigged [name] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. [ADMIN_JMP(loc)]")
			log_game("[key_name(user)] rigged [name] at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.")

		rig = W
		user.drop_inv_item_to_loc(W, src)

		update_icon()

	else if(istype(W,/obj/item/stack/sheet/plasteel))
		var/obj/item/stack/sheet/plasteel/M = W
		if(M.get_amount() < STACK_10)
			to_chat(user, SPAN_WARNING("你的[M]不足以加固[src]。"))
			return

		user.visible_message(SPAN_NOTICE("[user]开始用[M]加固[src]的外壳。"),\
		SPAN_NOTICE("你开始用[M]加固[src]。"))

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL) || reinforced)
			return

		if(!M.use(STACK_10))
			to_chat(user, SPAN_WARNING("你的[M]不足以加固[src]。"))
			return

		user.visible_message(SPAN_NOTICE("[user]用[M]加固了[src]的外壳。"),\
		SPAN_NOTICE("你用[M]加固了[src]。"))

		reinforced = TRUE
		update_icon()

	else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))

		user.visible_message(SPAN_DANGER("[user]开始拆除[src]的防护层。"),\
		SPAN_NOTICE("你开始拆除[src]的防护层。"))

		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src, INTERRUPT_ALL) || !reinforced)
			return

		user.visible_message(SPAN_DANGER("[user]拆除了[src]的防护层。"),\
		SPAN_NOTICE("你拆除了[src]的防护层。"))
		new /obj/item/stack/sheet/plasteel(loc, STACK_10)

		reinforced = FALSE
		update_icon()

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(obj/projectile/Proj)
	if(exploding) return 0
	if(ismob(Proj.firer))
		source_mob = WEAKREF(Proj.firer)

	if(Proj.damage > 10 && prob(60) && !reinforced)
		if(Proj.firer)
			message_admins("[key_name_admin(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]) [ADMIN_JMP(loc)].")
			log_game("[key_name(Proj.firer)] fired a projectile at [name] in [loc.loc.name] ([loc.x],[loc.y],[loc.z]).")
		exploding = TRUE
		explode()

	return TRUE

/obj/structure/reagent_dispensers/fueltank/ex_act(severity)
	if(exploding) return

	if(severity >= EXPLOSION_THRESHOLD_HIGH)
		exploding = TRUE
		explode(TRUE)
	else if(!reinforced)
		exploding = TRUE
		explode()

	if(src)
		return ..()

/obj/structure/reagent_dispensers/fueltank/proc/explode(force)
	reagents.source_mob = source_mob
	if(reagents.handle_volatiles() || force)
		deconstruct(FALSE)
		return

	exploding = FALSE
	update_icon()


/obj/structure/reagent_dispensers/fueltank/update_icon(cut_overlays = TRUE)
	if(cut_overlays)
		overlays.Cut()
	. = ..()

	if(rig)
		overlays += image(icon, "t_signaller")
		if(exploding)
			overlays += image(icon, "t_boom")
		else
			overlays += image(icon, "t_active")
	else
		overlays += image(icon, "t_inactive")

	if(reinforced)
		overlays += image(icon, icon_state = "t_reinforced")

/obj/structure/reagent_dispensers/fueltank/fire_act(temperature, volume)
	if(temperature > T0C+500 && !reinforced)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	. = ..()
	if(. && modded && reagents && !reagents.locked)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if(reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(chemical,amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount)

/obj/structure/reagent_dispensers/fueltank/flamer_fire_act(damage, datum/cause_data/flame_cause_data)
	if(!reinforced)
		reagents.source_mob = flame_cause_data?.weak_mob
		explode()

/obj/structure/reagent_dispensers/fueltank/gas
	name = "气罐"
	desc = "一个储气罐。"

/obj/structure/reagent_dispensers/fueltank/gas/leak_fuel(amount)
	if(reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(chemical,amount)

/obj/structure/reagent_dispensers/fueltank/gas/methane
	name = "甲烷罐"
	desc = "一个甲烷储罐。"
	icon_state = "methanetank"
	chemical = "methane"

/obj/structure/reagent_dispensers/fueltank/gas/hydrogen
	name = "氢气罐"
	desc = "一个氢气储罐。"
	icon_state = "hydrogentank"
	chemical = "hydrogen"

/obj/structure/reagent_dispensers/fueltank/oxygentank
	name = "氧气罐"
	desc = "一个氧气储罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "oxygentank"
	chemical = "oxygen"

/obj/structure/reagent_dispensers/fueltank/custom
	name = "试剂罐"
	desc = "一个试剂罐，通常用于储存大量化学品。"

	chemical = null
	dispensing = FALSE //Empty fuel tanks start by accepting chemicals by default. Can't dispense nothing!
	icon_state = "tank_normal"

/obj/structure/reagent_dispensers/fueltank/custom/Initialize(mapload, volume)
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/fueltank/custom/on_reagent_change()
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/fueltank/custom/update_icon()
	. = ..()

	var/set_icon_state = "tn_color"

	if(icon_state == "tank_explosive")
		set_icon_state = "te_color"

	var/image/I = image(icon, icon_state=set_icon_state)

	if(reagents)
		I.color = mix_color_from_reagents(reagents.reagent_list)

	overlays += I


/obj/structure/reagent_dispensers/peppertank
	name = "胡椒喷雾补充罐"
	desc = "用于补充胡椒喷雾罐。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	drag_delay = 3
	wrenchable =  FALSE
	density = FALSE
	amount_per_transfer_from_this = 45
	chemical = "condensedcapsaicin"

/obj/structure/reagent_dispensers/water_cooler
	name = "饮水机"
	desc = "提供饮用水的机器。虽然有冷热水开关，但只能放出常温水。"
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE
	drag_delay = 3
	chemical = "water"

/obj/structure/reagent_dispensers/water_cooler/walk_past
	density = FALSE

/obj/structure/reagent_dispensers/water_cooler/stacks
	icon_state = "water_cooler_2"

/obj/structure/reagent_dispensers/beerkeg
	name = "啤酒桶"
	desc = "一个啤酒桶。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	chemical = "beer"
	drag_delay = 3

/obj/structure/reagent_dispensers/beerkeg/alt
	icon_state = "beertank_alt"

/obj/structure/reagent_dispensers/beerkeg/alt_dark
	icon_state = "beertank_alt2"

/obj/structure/reagent_dispensers/virusfood
	name = "病毒营养液分配器"
	desc = "用于分配病毒营养液。"
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	drag_delay = 3
	wrenchable = FALSE
	density = FALSE
	chemical = "virusfood"

