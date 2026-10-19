/obj/item/clothing/gloves/yautja
	name = "古老外星护腕"
	desc = "一对奇异的外星护腕。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "bracer"
	item_icons = list(
		WEAR_HANDS = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_item = ITEM_PREDATOR
	flags_inventory = CANTSTRIP
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	flags_armor_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT
	unacidable = TRUE

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	var/notification_sound = TRUE // Whether the bracer pings when a message comes or not
	var/charge = 1500
	var/charge_max = 1500
	/// The amount charged per process
	var/charge_rate = 30
	/// Cooldown on draining power from APC
	var/charge_cooldown = COOLDOWN_BRACER_CHARGE
	var/cloak_timer = 0
	var/cloak_malfunction = 0
	/// Determines the alpha level of the cloaking device.
	var/cloak_alpha = 50
	/// If TRUE will change the mob invisibility level, providing 100% invisibility. Exclusively for events.
	var/true_cloak = FALSE

	var/mob/living/carbon/human/owner //Pred spawned on, or thrall given to.
	var/obj/item/clothing/gloves/yautja/linked_bracer //Bracer linked to this one (thrall or mentor).
	COOLDOWN_DECLARE(bracer_recharge)
	/// What minimap icon this bracer should have
	var/minimap_icon = "predator"

/obj/item/clothing/gloves/yautja/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		START_PROCESSING(SSobj, src)
		if(!owner)
			owner = user
		toggle_lock_internal(user, TRUE)
		RegisterSignal(user, list(COMSIG_MOB_STAT_SET_ALIVE, COMSIG_MOB_DEATH), PROC_REF(update_yautja_minimap_icon))
		INVOKE_NEXT_TICK(src, PROC_REF(update_yautja_minimap_icon), user)

/obj/item/clothing/gloves/yautja/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(linked_bracer)
		linked_bracer.linked_bracer = null
		linked_bracer = null
	return ..()

/obj/item/clothing/gloves/yautja/dropped(mob/user)
	STOP_PROCESSING(SSobj, src)
	flags_item = initial(flags_item)
	UnregisterSignal(user, list(COMSIG_MOB_STAT_SET_ALIVE, COMSIG_MOB_DEATH))
	SSminimaps.remove_marker(user)
	unlock_bracer() // So as to prevent the bracer being stuck with nodrop if the pred gets gibbed/arm removed/etc.
	..()

/obj/item/clothing/gloves/yautja/pickup(mob/living/user)
	..()
	if(!isyautja(user))
		to_chat(user, SPAN_WARNING("护腕贴着你的皮肤，冰冷而沉重，带着陌生、近乎外星造物的质感。"))

/obj/item/clothing/gloves/yautja/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return
	var/mob/living/carbon/human/human_holder = loc

	if(charge < charge_max)
		var/charge_increase = charge_rate
		if(is_ground_level(human_holder.z))
			charge_increase = charge_rate / 6
		else if(is_mainship_level(human_holder.z))
			charge_increase = charge_rate / 3

		charge = min(charge + charge_increase, charge_max)
		var/perc_charge = (charge / charge_max * 100)
		human_holder.update_power_display(perc_charge)

	//Non-Yautja have a chance to get stunned with each power drain
	if(!HAS_TRAIT(human_holder, TRAIT_CLOAKED))
		return
	if(human_holder.stat == DEAD)
		decloak(human_holder, TRUE)
	if(!HAS_TRAIT(human_holder, TRAIT_YAUTJA_TECH) && !human_holder.hunter_data.thralled && prob(2))
		decloak(human_holder)
		shock_user(human_holder)

/// handles decloaking only on HUNTER gloves
/obj/item/clothing/gloves/yautja/proc/decloak()
	SIGNAL_HANDLER
	return

/// Called to update the minimap icon of the predator
/obj/item/clothing/gloves/yautja/proc/update_yautja_minimap_icon()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/turf/wearer_turf = get_turf(owner)
	SSminimaps.remove_marker(owner)
	if(!wearer_turf)
		return

	if(!isyautja(owner))
		if(owner.stat >= DEAD)
			if(human_owner.undefibbable)
				SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, "bracer_stolen", 'icons/ui_icons/map_blips.dmi', overlay_iconstates = list("undefibbable"))
			else
				SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, "bracer_stolen", 'icons/ui_icons/map_blips.dmi', overlay_iconstates = list("defibbable"))
		else
			SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, "bracer_stolen", 'icons/ui_icons/map_blips.dmi')
	else
		if(owner?.stat >= DEAD)
			SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, minimap_icon, 'icons/ui_icons/map_blips.dmi', overlay_iconstates = list("undefibbable")) //defib/undefib status doesn't really matter because they're gonna explode in the end regardless
		else
			SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, minimap_icon, 'icons/ui_icons/map_blips.dmi')
/*
*This is the main proc for checking AND draining the bracer energy. It must have human passed as an argument.
*It can take a negative value in amount to restore energy.
*Also instantly updates the yautja power HUD display.
*/
/obj/item/clothing/gloves/yautja/proc/drain_power(mob/living/carbon/human/human, amount)
	if(!human)
		return FALSE
	if(charge < amount)
		to_chat(human, SPAN_WARNING("你的护腕能量不足。当前剩余<b>[charge]/[charge_max]</b>，需要<B>[amount]</b>。"))
		return FALSE

	charge -= amount
	var/perc = (charge / charge_max * 100)
	human.update_power_display(perc)

	return TRUE

/obj/item/clothing/gloves/yautja/proc/shock_user(mob/living/carbon/human/M)
	if(!HAS_TRAIT(M, TRAIT_YAUTJA_TECH) && !M.hunter_data.thralled)
		//Spark
		playsound(M, 'sound/effects/sparks2.ogg', 60, 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		M.visible_message(SPAN_WARNING("[src]发出哔声，电流穿过[M]的身体！"))
		//Stun and knock out, scream in pain
		M.apply_effect(2, STUN)
		M.apply_effect(2, WEAKEN)
		if(M.pain.feels_pain)
			M.emote("scream")
		//Apply a bit of burn damage
		M.apply_damage(5, BURN, "l_arm", 0, 0, 0, src)
		M.apply_damage(5, BURN, "r_arm", 0, 0, 0, src)

//We use this to determine whether we should activate the given verb, or a random verb
//0 - do nothing, 1 - random function, 2 - this function
/obj/item/clothing/gloves/yautja/hunter/proc/check_random_function(mob/living/carbon/human/user, forced = FALSE, always_delimb = FALSE)
	if(!istype(user))
		return TRUE

	if(forced || HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		return FALSE

	if(user.is_mob_incapacitated()) //let's do this here to avoid to_chats to dead guys
		return TRUE

	var/workingProbability = 20
	var/randomProbability = 10
	if(issynth(user)) // Synths are smart, they can figure this out pretty well
		workingProbability = 40
		randomProbability = 4
	else if(isresearcher(user)) // Researchers are sort of smart, they can sort of figure this out
		workingProbability = 25
		randomProbability = 7

	to_chat(user, SPAN_NOTICE("你按了几个按钮……"))
	//Add a little delay so the user wouldn't be just spamming all the buttons
	user.next_move = world.time + 3
	if(do_after(user, 3, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 1))
		if(prob(randomProbability))
			return activate_random_verb(user)
		if(!prob(workingProbability))
			to_chat(user, SPAN_WARNING("你摆弄着按钮，但什么也没发生……"))
			return TRUE

	if(always_delimb)
		return delimb_user(user)

	return FALSE

/obj/item/clothing/gloves/yautja/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("当前电量为<b>[charge]/[charge_max]</b>。")


// Toggle the notification sound
/obj/item/clothing/gloves/yautja/verb/toggle_notification_sound()
	set name = "Toggle Bracer Sound"
	set desc = "切换护腕通知音。"
	set src in usr

	notification_sound = !notification_sound
	to_chat(usr, SPAN_NOTICE("护腕的提示音现已[notification_sound ? "开启" : "关闭"]。"))


/obj/item/clothing/gloves/yautja/thrall
	name = "奴仆护腕"
	desc = "一对经过改装、适应人类生理的奇异外星护腕。"

	color = "#b85440"
	minimap_icon = "thrall"


/obj/item/clothing/gloves/yautja/thrall/update_yautja_minimap_icon()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/turf/wearer_turf = get_turf(owner)
	if(owner.stat >= DEAD)
		if(human_owner.undefibbable)
			SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, minimap_icon, overlay_iconstates = list("undefibbable"))
		else
			SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, minimap_icon, overlay_iconstates = list("defibbable"))
	else
		SSminimaps.add_marker(owner, wearer_turf.z, MINIMAP_FLAG_YAUTJA, minimap_icon)

/obj/item/clothing/gloves/yautja/hunter
	name = "氏族护腕"
	desc = "铁血战士佩戴的装甲护腕，结构极其复杂，操作却很简单。功能众多，启动后即可使用。"

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

	charge = 3000
	charge_max = 3000

	cloak_alpha = 10

	var/exploding = 0
	var/disc_timer = 0
	var/explosion_type = 1 //0 is BIG explosion, 1 ONLY gibs the user.
	var/name_active = TRUE
	var/translator_type = "Modern"
	var/caster_material = "ebony"

	var/obj/item/card/id/bracer_chip/embedded_id
	var/owner_rank = CLAN_RANK_UNBLOODED_INT

	var/caster_deployed = FALSE
	var/obj/item/weapon/gun/energy/yautja/plasma_caster/caster

	var/wristblades_deployed = FALSE
	var/obj/item/weapon/wristblades/left_wristblades
	var/obj/item/weapon/wristblades/right_wristblades

	///A list of all intrinsic bracer actions
	var/list/bracer_actions = list(/datum/action/predator_action/bracer/wristblade, /datum/action/predator_action/bracer/caster, /datum/action/predator_action/bracer/cloak, /datum/action/predator_action/bracer/thwei, /datum/action/predator_action/bracer/capsule, /datum/action/predator_action/bracer/translator, /datum/action/predator_action/bracer/self_destruct, /datum/action/predator_action/bracer/smartdisc)

/obj/item/clothing/gloves/yautja/hunter/Initialize(mapload, new_translator_type, new_caster_material, new_owner_rank)
	. = ..()
	if(new_owner_rank)
		owner_rank = new_owner_rank
	embedded_id = new(src)
	if(new_translator_type)
		translator_type = new_translator_type
	if(new_caster_material)
		caster_material = new_caster_material
	caster = new(src, FALSE, caster_material)
	left_wristblades = new(src)
	right_wristblades = new(src)

/obj/item/clothing/gloves/yautja/hunter/emp_act(severity)
	. = ..()
	charge = max(charge - (severity * 500), 0)
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(wearer.gloves == src)
			wearer.visible_message(SPAN_DANGER("你听到嘶嘶声和噼啪声！"), SPAN_DANGER("你的护腕发出嘶嘶声，迸出火花！"), SPAN_DANGER("你听到嘶嘶声和噼啪声！"))
			if(HAS_TRAIT(wearer, TRAIT_CLOAKED))
				decloak(wearer, TRUE, DECLOAK_EMP)
		else
			var/turf/our_turf = get_turf(src)
			our_turf.visible_message(SPAN_DANGER("你听到嘶嘶声和噼啪声！"), SPAN_DANGER("你听到嘶嘶声和噼啪声！"))

/obj/item/clothing/gloves/yautja/hunter/equipped(mob/user, slot)
	. = ..()
	if(slot != WEAR_HANDS)
		move_chip_to_bracer()
	else
		if(embedded_id.registered_name)
			embedded_id.set_user_data(user)

	for(var/datum/action/action as anything in bracer_actions)
		give_action(user, action)


//Any projectile can decloak a predator. It does defeat one free bullet though.
/obj/item/clothing/gloves/yautja/hunter/proc/bullet_hit(mob/living/carbon/human/H, obj/projectile/P)
	SIGNAL_HANDLER

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_ROCKET|AMMO_ENERGY|AMMO_ACIDIC)) //<--- These will auto uncloak.
		decloak(H) //Continue on to damage.
	else if(prob(20))
		decloak(H)
		return COMPONENT_CANCEL_BULLET_ACT //Absorb one free bullet.

/obj/item/clothing/gloves/yautja/hunter/toggle_notification_sound()
	set category = "Yautja.Misc"
	..()

/obj/item/clothing/gloves/yautja/hunter/Destroy()
	QDEL_NULL(caster)
	QDEL_NULL(embedded_id)
	return ..()

/obj/item/clothing/gloves/yautja/hunter/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/carbon/human/human = loc

	//Non-Yautja have a chance to get stunned with each power drain
	if((!HAS_TRAIT(human, TRAIT_YAUTJA_TECH) && !human.hunter_data.thralled) && prob(4))
		if(HAS_TRAIT(human, TRAIT_CLOAKED))
			decloak(human, TRUE, DECLOAK_SPECIES)
		shock_user(human)

	return ..()

/obj/item/clothing/gloves/yautja/hunter/dropped(mob/user)
	move_chip_to_bracer()
	if(HAS_TRAIT(user, TRAIT_CLOAKED))
		decloak(user, TRUE)

	for(var/datum/action/action as anything in bracer_actions)
		remove_action(user, action)

	..()

/obj/item/clothing/gloves/yautja/hunter/on_enter_storage(obj/item/storage/S)
	if(ishuman(loc))
		var/mob/living/carbon/human/human = loc
		if(HAS_TRAIT(human, TRAIT_CLOAKED))
			decloak(human, TRUE)
	. = ..()

//We use this to activate random verbs for non-Yautja
/obj/item/clothing/gloves/yautja/hunter/proc/activate_random_verb(mob/user)
	var/option = rand(1, 10)
	//we have options from 1 to 7, but we're giving the user a higher probability of being punished if they already rolled this bad
	switch(option)
		if(1)
			. = wristblades_internal(user, TRUE)
		if(2)
			. = track_gear_internal(user, TRUE)
		if(3)
			. = cloaker_internal(user, TRUE)
		if(4)
			. = caster_internal(user, TRUE)
		if(5)
			. = injectors_internal(user, TRUE)
		if(6)
			. = call_disc_internal(user, TRUE)
		if(7)
			. = translate_internal(user, TRUE)
		else
			. = delimb_user(user)

//This is used to punish people that fiddle with technology they don't understand
/obj/item/clothing/gloves/yautja/hunter/proc/delimb_user(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(isyautja(user))
		return

	var/obj/limb/O = user.get_limb(check_zone("r_arm"))
	O.droplimb()
	O = user.get_limb(check_zone("l_arm"))
	O.droplimb()

	to_chat(user, SPAN_NOTICE("装置发出怪声后脱落……连同你的双臂一起！"))
	playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)
	return TRUE

//Should put a cool menu here, like ninjas.
/obj/item/clothing/gloves/yautja/hunter/verb/wristblades()
	set name = "Use Wrist Blades"
	set desc = "伸出腕刃。无法丢弃，但可以收回。"
	set category = "Yautja.Weapons"
	set src in usr
	. = wristblades_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/wristblades_internal(mob/living/carbon/human/user, forced = FALSE)
	if(!user.loc || user.is_mob_incapacitated() || !ishuman(user))
		return

	. = check_random_function(user, forced)
	if(.)
		return

	if(wristblades_deployed)
		if(left_wristblades.loc == user)
			user.drop_inv_item_to_loc(left_wristblades, src, FALSE, TRUE)
		if(right_wristblades.loc == user)
			user.drop_inv_item_to_loc(right_wristblades, src, FALSE, TRUE)
		wristblades_deployed = FALSE
		to_chat(user, SPAN_NOTICE("你收回了[left_wristblades.name]。"))
		playsound(user, 'sound/weapons/wristblades_off.ogg', 15, TRUE)
	else
		if(!drain_power(user, 50))
			return
		var/deploying_into_left_hand = user.hand ? TRUE : FALSE
		if(user.get_active_hand())
			to_chat(user, SPAN_WARNING("必须空出手，才能展开腕刃！"))
			return
		var/obj/limb/hand = user.get_limb(deploying_into_left_hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("你无法持握它！"))
			return
		var/is_offhand_full = FALSE
		var/obj/limb/off_hand = user.get_limb(deploying_into_left_hand ? "r_hand" : "l_hand")
		if(user.get_inactive_hand() || (!istype(off_hand) || !off_hand.is_usable()))
			is_offhand_full = TRUE
		if(deploying_into_left_hand)
			user.put_in_active_hand(left_wristblades)
			if(!is_offhand_full)
				user.put_in_inactive_hand(right_wristblades)
		else
			user.put_in_active_hand(right_wristblades)
			if(!is_offhand_full)
				user.put_in_inactive_hand(left_wristblades)
		wristblades_deployed = TRUE
		to_chat(user, SPAN_NOTICE("你展开了[left_wristblades.plural_name]。"))
		playsound(user, 'sound/weapons/wristblades_on.ogg', 15, TRUE)

	var/datum/action/predator_action/bracer/wristblade/wb_action
	for(wb_action as anything in user.actions)
		if(istypestrict(wb_action, /datum/action/predator_action/bracer/wristblade))
			wb_action.update_button_icon(wristblades_deployed)
			break

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/track_gear()
	set name = "Track Yautja Gear"
	set desc = "寻找铁血装备。"
	set category = "Yautja.Tracker"
	set src in usr
	. = track_gear_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/track_gear_internal(mob/user, forced = FALSE)
	. = check_random_function(user, forced)
	if(.)
		return

	var/mob/living/carbon/human/M = user

	var/dead_on_planet = 0
	var/dead_on_almayer = 0
	var/dead_low_orbit = 0
	var/gear_on_planet = 0
	var/gear_on_almayer = 0
	var/gear_low_orbit = 0
	var/closest = 10000
	/// The item itself, to be referenced so Yautja know what to look for.
	var/obj/closest_item
	var/direction = -1
	var/atom/areaLoc = null
	for(var/obj/item/tracked_item as anything in GLOB.loose_yautja_gear)
		var/atom/loc = get_true_location(tracked_item)
		if(tracked_item.anchored)
			continue
		if(is_honorable_carrier(recursive_holder_check(tracked_item)))
			continue
		if(istype(get_area(tracked_item), /area/yautja))
			continue
		if(is_reserved_level(loc.z))
			gear_low_orbit++
		else if(is_mainship_level(loc.z))
			gear_on_almayer++
		else if(is_ground_level(loc.z))
			gear_on_planet++
		if(M.z == loc.z)
			var/dist = get_dist(M,loc)
			if(dist < closest)
				closest = dist
				closest_item = tracked_item
				direction = Get_Compass_Dir(M,loc)
				areaLoc = loc
	for(var/mob/living/carbon/human/Y as anything in GLOB.yautja_mob_list)
		if(Y.stat != DEAD)
			continue
		if(istype(get_area(Y), /area/yautja))
			continue
		if(is_reserved_level(Y.z))
			dead_low_orbit++
		else if(is_mainship_level(Y.z))
			dead_on_almayer++
		else if(is_ground_level(Y.z))
			dead_on_planet++
		if(M.z == Y.z)
			var/dist = get_dist(M,Y)
			if(dist < closest)
				closest = dist
				direction = Get_Compass_Dir(M,Y)
				areaLoc = loc

	var/output = FALSE
	if(dead_on_planet || dead_on_almayer || dead_low_orbit)
		output = TRUE
		to_chat(M, SPAN_NOTICE("你的护腕显示已死亡铁血战士的生物信号统计[dead_on_planet ? "，猎场内<b>[dead_on_planet]</b>个" : ""][dead_on_almayer ? "，轨道上<b>[dead_on_almayer]</b>个" : ""][dead_low_orbit ? "，低轨道上<b>[dead_low_orbit]</b>个" : ""]。"))
	if(gear_on_planet || gear_on_almayer || gear_low_orbit)
		output = TRUE
		to_chat(M, SPAN_NOTICE("护腕显示铁血科技信号读数[gear_on_planet ? "，狩猎场中有 <b>[gear_on_planet]</b> 个" : ""][gear_on_almayer ? "，轨道上有 <b>[gear_on_almayer]</b> 个" : ""][gear_low_orbit ? "，低轨道有 <b>[gear_low_orbit]</b> 个" : ""]。"))
	if(closest < 900)
		output = TRUE
		var/areaName = get_area_name(areaLoc)
		if(closest == 0)
			to_chat(M, SPAN_NOTICE("你就在[closest_item ? "<b>[closest_item.name]</b>的" : ""]信号正上方。"))
		else
			to_chat(M, SPAN_NOTICE("最近的信号[closest_item ? "，即<b>[closest_item.name]</b>，" : ""]位于<b>[areaName]</b>的<b>[localized_player_label(dir2text(direction))]</b>方向，距离[closest > 10 ? "约 <b>[round(closest, 10)]</b>" : "<b>[closest]</b>"]步。"))
	if(!output)
		to_chat(M, SPAN_NOTICE("没有需要你留意的信号。"))
	return TRUE


/obj/item/clothing/gloves/yautja/hunter/verb/cloaker()
	set name = "Toggle Cloaking Device"
	set desc = "启动护甲的隐形装置。护甲受损或过度浸水时会故障。"
	set category = "Yautja.Utility"
	set src in usr
	. = cloaker_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/cloaker_internal(mob/user, forced = FALSE, silent = FALSE, instant = FALSE)
	. = check_random_function(user, forced)
	if(.)
		return

	var/mob/living/carbon/human/M = user
	var/new_alpha = cloak_alpha

	if(!istype(M) || M.is_mob_incapacitated())
		return FALSE

	if(HAS_TRAIT(user, TRAIT_CLOAKED)) //Turn it off.
		if(cloak_timer > world.time)
			to_chat(M, SPAN_WARNING("隐形装置正忙！剩余 <B>[max(floor((cloak_timer - world.time) / 10), 1)]</b> 秒。"))
			return FALSE
		decloak(user)
	else //Turn it on!
		if(exploding)
			to_chat(M, SPAN_WARNING("你的护腕正忙着猛烈爆炸，没空启动隐形装置。"))
			return FALSE

		if(cloak_malfunction > world.time)
			to_chat(M, SPAN_WARNING("你的披风故障了，暂时无法启动！"))
			return FALSE

		if(cloak_timer > world.time)
			to_chat(M, SPAN_WARNING("隐形装置仍在充能！剩余 <B>[max(floor((cloak_timer - world.time) / 10), 1)]</b> 秒。"))
			return FALSE

		if(!drain_power(M, 50))
			return FALSE

		ADD_TRAIT(M, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))

		RegisterSignal(M, COMSIG_HUMAN_EXTINGUISH, PROC_REF(wrapper_fizzle_camouflage))
		RegisterSignal(M, COMSIG_HUMAN_PRE_BULLET_ACT, PROC_REF(bullet_hit))
		RegisterSignal(M, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak))

		cloak_timer = world.time + 1.5 SECONDS
		if(true_cloak)
			M.invisibility = INVISIBILITY_LEVEL_ONE
			M.see_invisible = SEE_INVISIBLE_LEVEL_ONE

		log_game("[key_name_admin(user)] has enabled their cloaking device.")
		if(!silent)
			M.visible_message(SPAN_WARNING("[M]凭空消失！"), SPAN_NOTICE("常规手段现在无法探测到你。"))
			playsound(M.loc,'sound/effects/pred_cloakon.ogg', 15, 1)

		if(!instant)
			animate(M, alpha = new_alpha, time = 1.5 SECONDS, easing = SINE_EASING|EASE_OUT)
		else
			M.alpha = new_alpha

		var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
		SA.remove_from_hud(M)
		var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
		XI.remove_from_hud(M)
		if(!instant)
			anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

	var/datum/action/predator_action/bracer/cloak/cloak_action
	for(cloak_action as anything in M.actions)
		if(istypestrict(cloak_action, /datum/action/predator_action/bracer/cloak))
			cloak_action.update_button_icon(HAS_TRAIT(user, TRAIT_CLOAKED))
			break

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/wrapper_fizzle_camouflage()
	SIGNAL_HANDLER

	var/mob/wearer = src.loc
	wearer.visible_message(SPAN_DANGER("[wearer]的披风失效了！"), SPAN_DANGER("你的披风失效了！"))

	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(5, 4, src)
	sparks.start()

	decloak(wearer, TRUE, DECLOAK_EXTINGUISHER)

/obj/item/clothing/gloves/yautja/hunter/decloak(mob/user, forced, force_multipler = DECLOAK_FORCED)
	if(!user)
		return

	SEND_SIGNAL(src, COMSIG_PRED_BRACER_DECLOAKED)

	UnregisterSignal(user, COMSIG_HUMAN_EXTINGUISH)
	UnregisterSignal(user, COMSIG_HUMAN_PRE_BULLET_ACT)
	UnregisterSignal(user, COMSIG_MOB_EFFECT_CLOAK_CANCEL)

	var/decloak_timer = (DECLOAK_STANDARD * force_multipler)
	if(forced)
		cloak_malfunction = world.time + decloak_timer

	REMOVE_TRAIT(user, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))
	log_game("[key_name_admin(user)] has disabled their cloaking device.")
	user.visible_message(SPAN_WARNING("[user]闪烁着重新显现！"), SPAN_WARNING("你的隐形装置关闭了。"))
	playsound(user.loc, 'sound/effects/pred_cloakoff.ogg', 15, 1)
	user.alpha = initial(user.alpha)
	if(true_cloak)
		user.invisibility = initial(user.invisibility)
		user.see_invisible = initial(user.see_invisible)
	cloak_timer = world.time + (DECLOAK_STANDARD / 2)

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(user)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(user)

	anim(user.loc, user, 'icons/mob/mob.dmi', null, "uncloak", null, user.dir)


/obj/item/clothing/gloves/yautja/hunter/verb/caster()
	set name = "Use Plasma Caster"
	set desc = "启动等离子肩炮。丢下后会自动收回护甲。"
	set category = "Yautja.Weapons"
	set src in usr
	. = caster_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/caster_internal(mob/living/carbon/human/user, forced = FALSE)
	if(!user.loc || user.is_mob_incapacitated() || !ishuman(user))
		return

	. = check_random_function(user, forced)
	if(.)
		return

	if(caster_deployed)
		if(caster.loc == user)
			user.drop_inv_item_to_loc(caster, src, FALSE, TRUE)
		caster_deployed = FALSE
	else
		if(!drain_power(user, 50))
			return
		if(user.get_active_hand())
			to_chat(user, SPAN_WARNING("必须空出手，才能展开腕刃！"))
			return
		var/obj/limb/hand = user.get_limb(user.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("你无法持握它！"))
			return
		user.put_in_active_hand(caster)
		caster_deployed = TRUE
		if(user.client?.prefs.custom_cursors)
			user.client?.mouse_pointer_icon = 'icons/effects/mouse_pointer/plasma_caster_mouse.dmi'
		to_chat(user, SPAN_NOTICE("你启动了等离子肩炮。当前为[localized_player_label(caster.mode)]模式。"))
		playsound(src, 'sound/weapons/pred_plasmacaster_on.ogg', 15, TRUE)

		var/datum/action/predator_action/bracer/caster/caster_action
		for(caster_action as anything in user.actions)
			if(istypestrict(caster_action, /datum/action/predator_action/bracer/caster))
				caster_action.update_button_icon(caster_deployed)
				break

	return TRUE


/obj/item/clothing/gloves/yautja/hunter/proc/explode(mob/living/carbon/victim)
	set waitfor = 0

	if (exploding)
		return

	notify_ghosts(header = "铁血自毁", message = "[victim]为捍卫荣誉，正在启动自毁！", source = victim, action = NOTIFY_ORBIT)

	exploding = 1
	var/turf/T = get_turf(src)
	if(explosion_type == SD_TYPE_BIG && victim.stat == CONSCIOUS && (is_ground_level(T.z) || MODE_HAS_TOGGLEABLE_FLAG(MODE_SHIPSIDE_SD)))
		playsound(src, 'sound/voice/pred_deathlaugh.ogg', 100, 0, 17, status = 0)

	playsound(src, 'sound/effects/pred_countdown.ogg', 100, 0, 17, status = 0)
	message_admins(FONT_SIZE_XL("<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];admincancelpredsd=1;bracer=\ref[src];victim=\ref[victim]'>CLICK TO CANCEL THIS PRED SD</a>"))
	do_after(victim, rand(72, 80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	T = get_turf(src)
	if(istype(T) && exploding)
		victim.apply_damage(50,BRUTE,"chest")
		if(victim)
			victim.gib() // kills the pred
			qdel(victim)
		var/datum/cause_data/cause_data = create_cause_data("yautja self-destruct", victim)
		if(explosion_type == SD_TYPE_BIG && (is_ground_level(T.z) || MODE_HAS_TOGGLEABLE_FLAG(MODE_SHIPSIDE_SD)))
			cell_explosion(T, 600, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //Dramatically BIG explosion.
		else
			cell_explosion(T, 800, 550, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)

/obj/item/clothing/gloves/yautja/hunter/verb/change_explosion_type()
	set name = "Change Explosion Type"
	set desc = "将护腕爆炸方式切换为仅炸碎自身，或引发大爆炸。"
	set category = "Yautja.Misc"
	set src in usr

	if(explosion_type == SD_TYPE_SMALL && exploding)
		to_chat(usr, SPAN_WARNING("你为什么想这么做？"))
		return

	if(alert("你想使用哪种爆炸模式？","爆炸护腕", "Small", "Big") == "Big")
		explosion_type = SD_TYPE_BIG
		log_attack("[key_name_admin(usr)] has changed their Self-Destruct to Large")
	else
		explosion_type = SD_TYPE_SMALL
		log_attack("[key_name_admin(usr)] has changed their Self-Destruct to Small")
		return

/obj/item/clothing/gloves/yautja/hunter/verb/activate_suicide()
	set name = "Final Countdown (!)"
	set desc = "启动护腕中的爆炸装置。你已经失败！拿出荣耀来！"
	set category = "Yautja.Misc"
	set src in usr
	. = activate_suicide_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/activate_suicide_internal(mob/user, forced = FALSE)
	. = check_random_function(user, forced, TRUE)
	if(.)
		return

	var/mob/living/carbon/human/M = user

	if(HAS_TRAIT(M, TRAIT_CLOAKED))
		to_chat(M, SPAN_WARNING("隐形时不行，可能会干扰启动程序。"))
		return
	if(M.stat == DEAD)
		to_chat(M, SPAN_WARNING("现在有点太迟了！"))
		return
	if(M.health < HEALTH_THRESHOLD_CRIT)
		to_chat(M, SPAN_WARNING("你在失去意识倒下前，没能启动自毁装置。"))
		return
	if(M.stat)
		to_chat(M, SPAN_WARNING("失去意识时不行……"))
		return

	var/obj/item/grab/G = M.get_active_hand()
	if(istype(G))
		var/mob/living/carbon/human/victim = G.grabbed_thing
		if(victim.stat == DEAD)
			var/obj/item/clothing/gloves/yautja/hunter/bracer = victim.gloves
			var/message = "确定要引爆这个 [victim.species] 的护腕吗？"
			if(isspeciesyautja(victim))
				message = "确定要送这个 [victim.species] 前往伟大的狩猎场吗？"
			if(istype(bracer))
				if(forced || alert(message,"爆炸护腕", "Yes", "No") == "Yes")
					if(M.get_active_hand() == G && victim && victim.gloves == bracer && !bracer.exploding)
						var/area/A = get_area(M)
						var/turf/T = get_turf(M)
						if(A)
							message_admins(FONT_SIZE_HUGE("ALERT: [M] ([M.key]) triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name] [ADMIN_JMP(T)]</font>"))
							log_attack("[key_name(M)] triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name]")
						if (!bracer.exploding)
							bracer.explode(victim)
						M.visible_message(SPAN_WARNING("[M]在[victim]的护腕上按了几个按钮。"),SPAN_DANGER("你启动了定时器。愿[victim]的最后一次狩猎迅速结束。"))
						message_all_yautja("[M.real_name] has triggered [victim.real_name]'s bracer's self-destruction sequence.")
			else
				to_chat(M, SPAN_WARNING("<b>这个[localized_player_label(victim.species)]没有佩戴护腕。</b>"))
			return

	if(M.gloves != src && !forced)
		return

	if(exploding)
		if(forced || alert("确定要停止倒计时吗？","护腕", "Yes", "No") == "Yes")
			if(M.gloves != src)
				return
			if(M.stat == DEAD)
				to_chat(M, SPAN_WARNING("现在有点太迟了！"))
				return
			if(M.stat)
				to_chat(M, SPAN_WARNING("失去意识时不行……"))
				return
			exploding = FALSE
			to_chat(M, SPAN_NOTICE("你的护腕停止鸣响。"))
			message_all_yautja("[M.real_name] has cancelled their bracer's self-destruction sequence.")
			message_admins("[key_name(M)] has deactivated their Self-Destruct.")

			var/datum/action/predator_action/bracer/self_destruct/sd_action
			for(sd_action as anything in M.actions)
				if(istypestrict(sd_action, /datum/action/predator_action/bracer/self_destruct))
					sd_action.update_button_icon(exploding)
					break

		return

	if(istype(M.wear_mask,/obj/item/clothing/mask/facehugger) || (M.status_flags & XENO_HOST))
		to_chat(M, SPAN_WARNING("奇怪……似乎有什么在干扰护腕功能……"))
		return

	if(forced || alert("确定要引爆护腕吗？\n\n注意：如果在战斗中或战斗结束后因非意外原因启动自毁，就必须完成自毁。启动自毁即表示你已接受以死亡维护失去的荣誉。","爆炸护腕", "Yes", "No") == "Yes")
		if(M.gloves != src)
			return
		if(M.stat == DEAD)
			to_chat(M, SPAN_WARNING("现在有点太迟了！"))
			return
		if(M.stat)
			to_chat(M, SPAN_WARNING("失去意识时不行……"))
			return
		if(exploding)
			return
		to_chat(M, SPAN_DANGER("你设好了定时器。愿你迅速抵达伟大的狩猎场。"))
		var/area/A = get_area(M)
		var/turf/T = get_turf(M)
		message_admins(FONT_SIZE_HUGE("ALERT: [M] ([M.key]) triggered their predator self-destruct sequence [A ? "in [A.name]":""] [ADMIN_JMP(T)]"))
		log_attack("[key_name(M)] triggered their predator self-destruct sequence in [A ? "in [A.name]":""]")
		message_all_yautja("[M.real_name] has triggered their bracer's self-destruction sequence.")
		explode(M)

		var/datum/action/predator_action/bracer/self_destruct/sd_action
		for(sd_action as anything in M.actions)
			if(istypestrict(sd_action, /datum/action/predator_action/bracer/self_destruct))
				sd_action.update_button_icon(exploding)
				break

	return TRUE

#define YAUTJA_CREATE_CRYSTAL_COOLDOWN "yautja_create_crystal_cooldown"
/obj/item/clothing/gloves/yautja/hunter/verb/injectors()
	set name = "制造稳定水晶"
	set category = "Yautja.Utility"
	set desc = "制造聚能晶体，促进自然愈合。"
	set src in usr
	. = injectors_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/injectors_internal(mob/user, forced = FALSE)
	if(user.is_mob_incapacitated())
		return FALSE

	. = check_random_function(user, forced)
	if(.)
		return

	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("你的主手必须空着！"))
		return FALSE

	if(TIMER_COOLDOWN_CHECK(src, YAUTJA_CREATE_CRYSTAL_COOLDOWN))
		var/remaining_time = DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(src, YAUTJA_CREATE_CRYSTAL_COOLDOWN))
		to_chat(user, SPAN_WARNING("你刚合成过稳定晶体，再过[remaining_time]才能制造下一枚。"))
		return FALSE

	if(!drain_power(user, 400))
		return FALSE

	S_TIMER_COOLDOWN_START(src, YAUTJA_CREATE_CRYSTAL_COOLDOWN, 2 MINUTES)

	to_chat(user, SPAN_NOTICE("你感觉到轻微嘶响，一枚晶体注射器落入手中。"))
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(user)
	user.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return TRUE
#undef YAUTJA_CREATE_CRYSTAL_COOLDOWN

/obj/item/clothing/gloves/yautja/hunter/verb/healing_capsule()
	set name = "制造治疗胶囊"
	set category = "Yautja.Utility"
	set desc = "为治疗枪制造治疗胶囊。"
	set src in usr
	. = healing_capsule_internal(usr, FALSE)

#define YAUTJA_CREATE_CAPSULE_COOLDOWN "yautja_create_capsule_cooldown"
/obj/item/clothing/gloves/yautja/hunter/proc/healing_capsule_internal(mob/user, forced = FALSE)
	if(user.is_mob_incapacitated())
		return FALSE

	. = check_random_function(user, forced)
	if(.)
		return

	if(user.get_active_hand())
		to_chat(user, SPAN_WARNING("你的主手必须空着！"))
		return FALSE

	if(TIMER_COOLDOWN_CHECK(src, YAUTJA_CREATE_CAPSULE_COOLDOWN))
		var/remaining_time = DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(src, YAUTJA_CREATE_CAPSULE_COOLDOWN))
		to_chat(user, SPAN_WARNING("你刚合成过治疗胶囊，再过[remaining_time]才能制造下一枚。"))
		return FALSE

	if(!drain_power(user, 600))
		return FALSE

	S_TIMER_COOLDOWN_START(src, YAUTJA_CREATE_CAPSULE_COOLDOWN, 4 MINUTES)

	to_chat(user, SPAN_NOTICE("护腕内部一阵运转，弹出了一枚治疗胶囊。"))
	var/obj/item/tool/surgery/healing_gel/O = new(user)
	user.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return TRUE
#undef YAUTJA_CREATE_CAPSULE_COOLDOWN

/obj/item/clothing/gloves/yautja/hunter/verb/call_disc()
	set name = "Call Smart-Disc"
	set category = "Yautja.Weapons"
	set desc = "召回范围内的智能飞盘。若超出范围，就得自己去捡。"
	set src in usr
	. = call_disc_internal(usr, FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/call_disc_internal(mob/user, forced = FALSE)
	if(user.is_mob_incapacitated())
		return FALSE

	. = check_random_function(user, forced)
	if(.)
		return

	if(disc_timer)
		to_chat(user, SPAN_WARNING("护腕需要先恢复一段时间。"))
		return FALSE

	if(!drain_power(user, 70))
		return FALSE

	disc_timer = TRUE
	addtimer(VARSET_CALLBACK(src, disc_timer, FALSE), 10 SECONDS)

	for(var/mob/living/simple_animal/hostile/smartdisc/S in range(7))
		to_chat(user, SPAN_WARNING("[S]弹跳着飞回你身边！"))
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(S.loc)
		qdel(S)

	for(var/obj/item/explosive/grenade/spawnergrenade/smartdisc/D in range(10))
		if(isturf(D.loc))
			D.boomerang(user)

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/remove_tracked_item()
	set name = "Remove Item from Tracker"
	set desc = "将一件物品从铁血追踪器中移除。"
	set category = "Yautja.Tracker"
	set src in usr
	. = remove_tracked_item_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/remove_tracked_item_internal(mob/user, forced = FALSE)
	if(user.is_mob_incapacitated())
		return FALSE

	. = check_random_function(user, forced)
	if(.)
		return

	var/obj/item/tracked_item = user.get_active_hand()
	if(!tracked_item)
		to_chat(user, SPAN_WARNING("必须用主手拿着物品，才能从追踪器中移除！"))
		return FALSE
	if(!(tracked_item in GLOB.tracked_yautja_gear))
		to_chat(user, SPAN_WARNING("[tracked_item]不在追踪系统中。"))
		return FALSE
	tracked_item.RemoveElement(/datum/element/yautja_tracked_item)
	to_chat(user, SPAN_NOTICE("你将<b>[tracked_item]</b>从追踪系统中移除。"))
	return TRUE


/obj/item/clothing/gloves/yautja/hunter/verb/add_tracked_item()
	set name = "Add Item to Tracker"
	set desc = "将一件物品加入铁血追踪器。"
	set category = "Yautja.Tracker"
	set src in usr
	. = add_tracked_item_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/add_tracked_item_internal(mob/user, forced = FALSE)
	if(user.is_mob_incapacitated())
		return FALSE

	. = check_random_function(user, forced)
	if(.)
		return

	var/obj/item/untracked_item = user.get_active_hand()
	if(!untracked_item)
		to_chat(user, SPAN_WARNING("必须用主手拿着物品，才能从追踪器中移除！"))
		return FALSE
	if(untracked_item in GLOB.tracked_yautja_gear)
		to_chat(user, SPAN_WARNING("[untracked_item]已经在被追踪。"))
		return FALSE
	untracked_item.AddElement(/datum/element/yautja_tracked_item)
	to_chat(user, SPAN_NOTICE("你将<b>[untracked_item]</b>加入了追踪系统。"))
	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/translate()
	set name = "翻译器"
	set desc = "通过护腕向附近的人发送消息。"
	set category = "Yautja.Utility"
	set src in usr
	. = translate_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/translate_internal(mob/user, forced = FALSE)
	if(!user || user.stat)
		return

	. = check_random_function(user, forced)
	if(.)
		return

	if(user.client.prefs.muted & MUTE_IC)
		to_chat(user, SPAN_DANGER("你已被禁言，无法使用翻译功能。"))
		return

	user.create_typing_indicator()
	var/msg = sanitize(input(user, "护腕发出哔声，耐心等待你输入消息。", "翻译器", "") as text)
	user.remove_typing_indicator()
	if(!msg || !user.client)
		return

	if(!drain_power(user, 50))
		return

	log_say("[user.name != "Unknown" ? user.name : "([user.real_name])"] \[Yautja Translator\]: [msg] (CKEY: [user.key]) (JOB: [user.job]) (AREA: [get_area_name(user)])")

	var/list/heard = get_mobs_in_view(7, user)
	for(var/mob/M in heard)
		if(M.ear_deaf)
			heard -= M

	var/overhead_color = "#ff0505"
	var/span_class = "yautja_translator"
	if(translator_type != "Modern")
		if(translator_type == "Retro")
			overhead_color = "#FFFFFF"
			span_class = "retro_translator"
		msg = replacetext(msg, "a", "@")
		msg = replacetext(msg, "e", "3")
		msg = replacetext(msg, "i", "1")
		msg = replacetext(msg, "o", "0")
		msg = replacetext(msg, "s", "5")
		msg = replacetext(msg, "l", "1")

	user.langchat_speech(msg, heard, GLOB.all_languages, overhead_color, TRUE)

	var/voice_name = "一个陌生的声音"
	if(user.name == user.real_name && user.alpha == initial(user.alpha))
		voice_name = "<b>[user.name]</b>"
	for(var/mob/Q as anything in heard)
		if(Q.stat && !isobserver(Q))
			continue //Unconscious
		to_chat(Q, "[SPAN_INFO("[voice_name]说道：")]<span class='[span_class]'>“[msg]”</span>")

/obj/item/clothing/gloves/yautja/hunter/verb/bracername()
	set name = "Toggle Bracer Name"
	set desc = "切换其他铁血战士检查你时是否能看见你的名字。"
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	name_active = !name_active
	to_chat(usr, SPAN_NOTICE("其他铁血战士检查你时，[src]将[name_active ? "显示" : "不再显示"]你的名字。"))

/obj/item/clothing/gloves/yautja/hunter/verb/idchip()
	set name = "Toggle ID Chip"
	set desc = "显示或隐藏内置护腕身份芯片。"
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	var/mob/living/carbon/human/H = usr
	if(!istype(H) || !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("你不知道如何使用它。"))
		return

	if(H.wear_id == embedded_id)
		to_chat(H, SPAN_NOTICE("你收回了身份芯片。"))
		move_chip_to_bracer()
	else if(H.wear_id)
		to_chat(H, SPAN_WARNING("有东西挡住了身份芯片，无法展开！"))
	else
		to_chat(H, SPAN_NOTICE("你露出了身份芯片。"))
		if(!H.equip_to_slot_if_possible(embedded_id, WEAR_ID))
			to_chat(H, SPAN_WARNING("芯片展开时发生错误！请提交错误报告。"))
			move_chip_to_bracer()

/obj/item/clothing/gloves/yautja/hunter/proc/move_chip_to_bracer()
	if(!embedded_id || !embedded_id.loc)
		return

	if(embedded_id.loc == src)
		return

	if(ismob(embedded_id.loc))
		var/mob/M = embedded_id.loc
		M.u_equip(embedded_id, src, FALSE, TRUE)
	else
		embedded_id.forceMove(src)

/// Verb to let Yautja attempt the unlocking.
/obj/item/clothing/gloves/yautja/hunter/verb/toggle_lock()
	set name = "Toggle Bracer Lock"
	set desc = "切换护腕锁，允许将其取下。"
	set category = "Yautja.Misc"
	set src in usr

	if(usr.stat)
		to_chat(usr, SPAN_WARNING("你现在无法这样做……"))
		return FALSE
	if(!HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("你完全不知道如何使用它……"))
		return FALSE

	attempt_toggle_lock(usr, FALSE)
	return TRUE

/// Handles all the locking and unlocking of bracers.
/obj/item/clothing/gloves/yautja/proc/attempt_toggle_lock(mob/user, force_lock)
	if(!user)
		return FALSE

	var/obj/item/grab/held_mob = user.get_active_hand()
	if(!istype(held_mob))
		log_attack("[key_name_admin(user)] has unlocked their own bracer.")
		toggle_lock_internal(user)
		return TRUE

	var/mob/living/carbon/human/victim = held_mob.grabbed_thing
	var/obj/item/clothing/gloves/yautja/bracer = victim.gloves
	if(isspeciesyautja(victim) && !(victim.stat == DEAD))
		to_chat(user, SPAN_WARNING("你不能解锁活着的猎手的护腕！"))
		return FALSE

	if(!istype(bracer))
		to_chat(user, SPAN_WARNING("<b>这个[localized_player_label(victim.species)]没有佩戴护腕。</b>"))
		return FALSE

	if(alert("确定要解锁这个 [victim.species] 的护腕吗？", "解锁护腕", "Yes", "No") != "Yes")
		return FALSE

	if(user.get_active_hand() == held_mob && victim && victim.gloves == bracer)
		log_interact(user, victim, "[key_name(user)] unlocked the [bracer.name] of [key_name(victim)].")
		user.visible_message(SPAN_WARNING("[user]在[victim]的护腕上按了几个按钮。"),SPAN_DANGER("你解锁了护腕。"))
		bracer.toggle_lock_internal(victim)
		return TRUE

/// The actual unlock/lock function.
/obj/item/clothing/gloves/yautja/proc/toggle_lock_internal(mob/wearer, force_lock)
	if(((flags_item & NODROP) || (flags_inventory & CANTSTRIP)) && !force_lock)
		return unlock_bracer()

	return lock_bracer()

/obj/item/clothing/gloves/yautja/proc/lock_bracer(mob/wearer)
	flags_item |= NODROP
	flags_inventory |= CANTSTRIP
	if(wearer)
		if(isyautja(wearer))
			to_chat(wearer, SPAN_WARNING("护腕牢固地夹住你的前臂，发出舒适熟悉的哔声。"))
		else
			to_chat(wearer, SPAN_WARNING("护腕痛苦地夹住你的前臂，愤怒地鸣响。摘不下来了！"))
	return TRUE

/obj/item/clothing/gloves/yautja/proc/unlock_bracer(mob/wearer)
	flags_item &= ~NODROP
	flags_inventory &= ~CANTSTRIP
	if(wearer)
		if(!isyautja(wearer))
			to_chat(wearer, SPAN_WARNING("护腕愉快地鸣响，松开了你的前臂。"))
		else
			to_chat(wearer, SPAN_WARNING("护腕愤怒地长鸣一声，松开了你的前臂。"))
	return TRUE
