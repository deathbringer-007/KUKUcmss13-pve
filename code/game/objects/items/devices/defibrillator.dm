/obj/item/device/defibrillator
	name = "急救除颤器"
	desc = "用于救治心脏发生纤颤患者的手持式急救除颤器。顺带还能让死人复活。"
	icon_state = "defib"
	item_state = "defib"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM

	var/blocked_by_suit = TRUE
	/// Min damage defib deals to victims' heart
	var/min_heart_damage_dealt = 3
	/// Max damage defib deals to victims' heart
	var/max_heart_damage_dealt = 5
	var/ready = 0
	var/damage_heal_threshold = 12 //This is the maximum non-oxy damage the defibrillator will heal to get a patient above -100, in all categories
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	var/charge_cost = 66 //How much energy is used.
	var/obj/item/cell/dcell = null
	var/datum/effect_system/spark_spread/sparks = new
	var/defib_cooldown = 0 //Cooldown for toggling the defib
	var/shock_cooldown = 0 //cooldown for shocking someone - separate to toggling

/mob/living/carbon/human/proc/check_tod()
	if(!undefibbable && world.time <= timeofdeath + revive_grace_period)
		return TRUE
	return FALSE

/obj/item/device/defibrillator/Initialize(mapload, ...)
	. = ..()

	sparks.set_up(5, 0, src)
	sparks.attach(src)
	dcell = new/obj/item/cell(src)
	update_icon()

/obj/item/device/defibrillator/Destroy()
	QDEL_NULL(dcell)
	QDEL_NULL(sparks)
	return ..()

/obj/item/device/defibrillator/update_icon()
	icon_state = initial(icon_state)
	overlays.Cut()

	if(ready)
		icon_state += "_out"

	if(dcell && dcell.charge)
		switch(floor(dcell.charge * 100 / dcell.maxcharge))
			if(67 to INFINITY)
				overlays += "+full"
			if(34 to 66)
				overlays += "+half"
			if(3 to 33)
				overlays += "+low"
			if(0 to 3)
				overlays += "+empty"
	else
		overlays += "+empty"

/obj/item/device/defibrillator/get_examine_text(mob/user)
	. = ..()
	var/maxuses = 0
	var/currentuses = 0
	maxuses = floor(dcell.maxcharge / charge_cost)
	currentuses = floor(dcell.charge / charge_cost)
	. += SPAN_INFO("内置电池剩余可用次数：[currentuses] / [maxuses]。")
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_STRONG_DEFIBS) || !blocked_by_suit)
		. += SPAN_NOTICE("此除颤器可穿透护甲使用。")

/obj/item/device/defibrillator/attack_self(mob/living/carbon/human/user)
	..()

	if(defib_cooldown > world.time) //cooldown only to prevent spam toggling
		return

	//Job knowledge requirement
	if (istype(user))
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
			return

	defib_cooldown = world.time + 10 //1 second cooldown every time the defib is toggled
	ready = !ready
	user.visible_message(SPAN_NOTICE("[user]将[src][ready? "开启，并取出电极板" : "关闭，并收回电极板"]。"),
	SPAN_NOTICE("你将[src][ready? "开启，并取出电极板" : "关闭，并收回电极板"]。"))
	playsound(get_turf(src), "sparks", 15, 1, 0)
	if(ready)
		w_class = SIZE_LARGE
		playsound(get_turf(src), 'sound/items/defib_safetyOn.ogg', 25, 0)
	else
		w_class = initial(w_class)
		playsound(get_turf(src), 'sound/items/defib_safetyOff.ogg', 25, 0)
	update_icon()
	add_fingerprint(user)

/mob/living/carbon/human/proc/get_ghost(check_client = TRUE, check_can_reenter = TRUE)
	if(client)
		return null

	for(var/mob/dead/observer/G in GLOB.observer_list)
		if(G.mind && G.mind.original == src)
			var/mob/dead/observer/ghost = G
			if(ghost && (!check_client || ghost.client) && (!check_can_reenter || ghost.can_reenter_corpse))
				return ghost

/mob/living/carbon/human/proc/is_revivable(ignore_heart = FALSE)
	if(isnull(internal_organs_by_name) || isnull(internal_organs_by_name["heart"]))
		return FALSE
	var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]
	var/obj/limb/head = get_limb("head")

	if(chestburst || !head || head.status & LIMB_DESTROYED || !ignore_heart && (!heart || heart.organ_status >= ORGAN_BROKEN) || !has_brain() || status_flags & PERMANENTLY_DEAD)
		return FALSE
	return TRUE

/obj/item/device/defibrillator/proc/check_revive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!ishuman(H) || isyautja(H))
		to_chat(user, SPAN_WARNING("你无法给[H]除颤。你甚至不知道该把电极板放在哪里！"))
		return
	if(!ready)
		to_chat(user, SPAN_WARNING("请先取出[src]的电极板。"))
		return
	if(dcell.charge <= charge_cost)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]电量过低！需要充电。"))
		return
	if(H.stat != DEAD)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：检测到生命体征。操作中止。"))
		return

	if(!H.is_revivable())
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：患者整体状况不允许复苏。"))
		return

	if((!MODE_HAS_TOGGLEABLE_FLAG(MODE_STRONG_DEFIBS) && blocked_by_suit) && H.wear_suit && (istype(H.wear_suit, /obj/item/clothing/suit/armor) || istype(H.wear_suit, /obj/item/clothing/suit/storage/marine)) && prob(95))
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：电极板测得电阻大于 100,000 欧姆。可能原因：外套或护甲阻隔。"))
		return

	if((!H.check_tod() && !issynth(H))) //synthetic species have no expiration date
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：患者已脑死亡。"))
		return

	return TRUE

/obj/item/device/defibrillator/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(shock_cooldown > world.time) //cooldown is only for shocking, this is so that you can immediately shock when you take the paddles out - stan_albatross
		return

	shock_cooldown = world.time + 20 //2 second cooldown before you can try shocking again

	if(user.action_busy) //Currently deffibing
		return

	//job knowledge requirement
	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
			return

	if(!check_revive(H, user))
		return

	var/mob/dead/observer/G = H.get_ghost()
	if(istype(G) && G.client)
		playsound_client(G.client, 'sound/effects/revive_notify.ogg')
		to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("有人正在尝试复苏你的身体。如果想要复活，请返回身体！ \
			（菜单 → 幽灵 → 返回尸体，或<a href='byond://?src=\ref[G];reentercorpse=1'>点击此处！</a>）")))

	user.visible_message(SPAN_NOTICE("[user]开始将电极板放到[H]胸前。"), \
		SPAN_HELPFUL("你开始将电极板<b>放到</b><b>[H]</b>胸前。"))
	playsound(get_turf(src),'sound/items/defib_charge.ogg', 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds

	//Taking square root not to make defibs too fast...
	if(!do_after(user, (4 + (3 * user.get_skill_duration_multiplier(SKILL_MEDICAL))) SECONDS, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, H, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		user.visible_message(SPAN_WARNING("[user]停止将电极板放到[H]胸前。"), \
		SPAN_WARNING("你停止将电极板放到[H]胸前。"))
		return

	if(!check_revive(H, user))
		return

	//Do this now, order doesn't matter
	sparks.start()
	dcell.use(charge_cost)
	update_icon()
	playsound(get_turf(src), 'sound/items/defib_release.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user]用电极板对[H]进行电击。"),
		SPAN_HELPFUL("你用电极板对<b>[H]</b>进行电击。"))
	H.visible_message(SPAN_DANGER("[H]的身体抽搐了一下。"))
	shock_cooldown = world.time + 10 //1 second cooldown before you can shock again

	var/datum/internal_organ/heart/heart = H.internal_organs_by_name["heart"]

	if(!H.is_revivable())
		playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
		if(heart && heart.organ_status >= ORGAN_BROKEN)
			user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：除颤失败。患者心脏损伤过重，建议立即手术。"))
			msg_admin_niche("[key_name_admin(user)] failed an attempt to revive [key_name_admin(H)] with [src] because of heart damage.")
			return
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：除颤失败。患者整体状况不允许复苏。"))
		msg_admin_niche("[key_name_admin(user)] failed an attempt to revive [key_name_admin(H)] with [src].")
		return

	if(!H.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：未检测到灵魂，正在尝试复苏……"))

	if(isobserver(H.mind?.current) && !H.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
		H.mind.transfer_to(H, TRUE)


	//At this point, the defibrillator is ready to work
	H.apply_damage(-damage_heal_threshold, BRUTE)
	H.apply_damage(-damage_heal_threshold, BURN)
	H.apply_damage(-damage_heal_threshold, TOX)
	H.apply_damage(-damage_heal_threshold, CLONE)
	H.apply_damage(-H.getOxyLoss(), OXY)
	H.updatehealth() //Needed for the check to register properly

	if(!(H.species?.flags & NO_CHEM_METABOLIZATION))
		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/datum/chem_property/P = R.get_property(PROPERTY_ELECTROGENETIC)//Adrenaline helps greatly at restarting the heart
			if(P)
				P.trigger(H)
				H.reagents.remove_reagent(R.id, 1)
				break
	if(H.health > HEALTH_THRESHOLD_DEAD)
		user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] [src]哔哔提示：除颤成功。"))
		msg_admin_niche("[key_name_admin(user)] successfully revived [key_name_admin(H)] with [src].")
		playsound(get_turf(src), 'sound/items/defib_success.ogg', 25, 0)
		user.track_life_saved(user.job)
		user.life_revives_total++
		H.handle_revive()
		if(heart)
			heart.take_damage(rand(min_heart_damage_dealt, max_heart_damage_dealt), TRUE) // Make death and revival leave lasting consequences

		to_chat(H, SPAN_NOTICE("你突然感到一阵电流，意识随之恢复，将你拉回了人世。"))
		if(H.client?.prefs.toggles_flashing & FLASH_CORPSEREVIVE)
			window_flash(H.client)
	else
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] [src]嗡嗡提示：除颤失败。生命体征过于微弱，请处理损伤后重试。")) //Freak case
		msg_admin_niche("[key_name_admin(user)] failed an attempt to revive [key_name_admin(H)] with [src] because of weak vitals.")
		playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
		if(heart && prob(25))
			heart.take_damage(rand(min_heart_damage_dealt, max_heart_damage_dealt), TRUE) // Make death and revival leave lasting consequences

/obj/item/device/defibrillator/compact_adv
	name = "高级袖珍除颤器"
	desc = "以续航换取强劲瞬时功率的高级袖珍除颤器。可穿透护甲，治疗效果强且速度快，但可用次数很少。不会损伤心脏。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "compact_defib"
	item_state = "defib"
	w_class = SIZE_MEDIUM
	blocked_by_suit = FALSE
	min_heart_damage_dealt = 0
	max_heart_damage_dealt = 0
	damage_heal_threshold = 40
	charge_cost = 198

/obj/item/device/defibrillator/compact
	name = "袖珍除颤器"
	desc ="这款除颤器的电池续航只有标准急救除颤器的一半，但能装进口袋。"
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "compact_defib"
	item_state = "defib"
	w_class = SIZE_SMALL
	charge_cost = 99
