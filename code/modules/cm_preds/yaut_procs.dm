// Notify all preds with the bracer icon
/proc/message_all_yautja(msg, soundeffect = TRUE)
	for(var/mob/living/carbon/human/Y in GLOB.yautja_mob_list)
		// Send message to the bracer; appear multiple times if we have more bracers
		for(var/obj/item/clothing/gloves/yautja/hunter/G in Y.contents)
			to_chat(Y, SPAN_YAUTJABOLD("[icon2html(G)] <b>[G]</b>发出哔声：[msg]"))
			if(G.notification_sound)
				playsound(Y.loc, 'sound/items/pred_bracer.ogg', 75, 1)

/mob/living/carbon/human/proc/message_thrall(msg)
	if(!hunter_data.thrall)
		return

	var/mob/living/carbon/T = hunter_data.thrall

	for(var/obj/item/clothing/gloves/yautja/hunter/G in T.contents)
		to_chat(T, SPAN_YAUTJABOLD("[icon2html(G)] <b>[G]</b>发出哔声：[msg]"))
		if(G.notification_sound)
			playsound(T.loc, 'sound/items/pred_bracer.ogg', 75, 1)

//Update the power display thing. This is called in Life()
/mob/living/carbon/human/proc/update_power_display(perc)
	if(hud_used?.pred_power_icon)
		switch(perc)
			if(91 to INFINITY)
				hud_used.pred_power_icon.icon_state = "powerbar100"
			if(81 to 91)
				hud_used.pred_power_icon.icon_state = "powerbar90"
			if(71 to 81)
				hud_used.pred_power_icon.icon_state = "powerbar80"
			if(61 to 71)
				hud_used.pred_power_icon.icon_state = "powerbar70"
			if(51 to 61)
				hud_used.pred_power_icon.icon_state = "powerbar60"
			if(41 to 51)
				hud_used.pred_power_icon.icon_state = "powerbar50"
			if(31 to 41)
				hud_used.pred_power_icon.icon_state = "powerbar40"
			if(21 to 31)
				hud_used.pred_power_icon.icon_state = "powerbar30"
			if(11 to 21)
				hud_used.pred_power_icon.icon_state = "powerbar20"
			else
				hud_used.pred_power_icon.icon_state = "powerbar10"

/mob/living/carbon/human/proc/butcher()
	set category = "Yautja.Misc"
	set name = "肢解"
	set desc = "肢解脚下的尸体，取得鲜美的肉。"

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		return

	var/list/choices = list()
	for(var/mob/living/carbon/M in view(1, src) - src)
		if(Adjacent(M) && M.stat == DEAD)
			if(ishuman(M))
				var/mob/living/carbon/human/Q = M
				if(Q.species && issamespecies(Q, src))
					continue
			choices += M

	var/mob/living/carbon/T = localized_input_list(src, "你想肢解哪个目标？", "肢解", choices)

	var/mob/living/carbon/xenomorph/xeno_victim
	var/mob/living/carbon/human/victim

	if(!T || !src || !T.stat)
		to_chat(src, SPAN_WARNING("不行。"))
		return

	if(!Adjacent(T))
		to_chat(src, SPAN_WARNING("你必须站在目标旁边。"))
		return

	if(islarva(T) || isfacehugger(T))
		to_chat(src, SPAN_WARNING("这只小虫不值得动用你的工具。"))
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		return

	if(issynth(T))
		to_chat(src, SPAN_WARNING("这样做会损坏工具！"))
		return

	if(isxeno(T))
		xeno_victim = T

	var/static/list/procedure_choices = list(
		"Skin" = null,
		"Behead" = "head",
		"Delimb - Right Hand" = "r_hand",
		"Delimb - Left Hand" = "l_hand",
		"Delimb - Right Arm" = "r_arm",
		"Delimb - Left Arm" = "l_arm",
		"Delimb - Right Foot" = "r_foot",
		"Delimb - Left Foot" = "l_foot",
		"Delimb - Right Leg" = "r_leg",
		"Delimb - Left Leg" = "l_leg",
	)

	var/procedure = ""
	if(ishuman(T))
		victim = T

	if(victim)
		procedure = localized_input_list(src, "你想切取哪个部位？", "切取部位", procedure_choices)
		if(!procedure)
			return

	if(isxeno(T) || procedure == "Skin")
		if(T.butchery_progress)
			playsound(loc, 'sound/weapons/pierce.ogg', 25)
			visible_message(SPAN_DANGER("[src]继续肢解[T]。"), SPAN_NOTICE("你继续肢解[T]。"))
		else
			playsound(loc, 'sound/weapons/pierce.ogg', 25)
			visible_message(SPAN_DANGER("[src]开始剁砍并肢解[T]。"), SPAN_NOTICE("你拿出工具，开始处理[T]。保持不动。"))
			T.butchery_progress = 1

		if(T.butchery_progress == 1)
			if(do_after(src, 7 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				visible_message(SPAN_DANGER("[src]仔细切开[T]的腹腔，扯出内脏。"), SPAN_NOTICE("你仔细剖开[T]，扯出肠子和无用的器官。真臭！"))
				T.butchery_progress = 2
				playsound(loc, 'sound/weapons/slash.ogg', 25)
			else
				to_chat(src, SPAN_NOTICE("你暂停肢解，留待稍后继续。"))

		if(T.butchery_progress == 2)
			if(do_after(src, 6.5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				visible_message(SPAN_DANGER("[src]砍切[T]的四肢，割下滴血的肉条。"), SPAN_NOTICE("你切下[T]的几条肢体，确保取到最好的部位。"))
				if(xeno_victim && isturf(xeno_victim.loc))
					var/obj/item/reagent_container/food/snacks/meat/xenomeat = new /obj/item/reagent_container/food/snacks/meat/xenomeat(T.loc)
					xenomeat.name = "[localized_player_label(trim(xeno_victim.age_prefix))][localized_player_label(xeno_victim.caste_type)]生肉排"
				else if(victim && isturf(victim.loc))
					victim.apply_damage(100, BRUTE, pick("r_leg", "l_leg", "r_arm", "l_arm"), FALSE, TRUE) //Basically just rips off a random limb.
					var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
					meat.name = "[victim.name]生肉排"
				T.butchery_progress = 3
				playsound(loc, 'sound/weapons/bladeslice.ogg', 25)
			else
				to_chat(src, SPAN_NOTICE("你暂停肢解，留待稍后继续。"))

		if(T.butchery_progress == 3)
			if(do_after(src, 7 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				visible_message(SPAN_DANGER("[src]扯开[T]的胸腔，开始切下肉块。"), SPAN_NOTICE("你撕开[T]的胸腔，开始扯出最美味的部位。"))
				if(xeno_victim && isturf(xeno_victim.loc))
					var/obj/item/reagent_container/food/snacks/meat/xenomeat = new /obj/item/reagent_container/food/snacks/meat/xenomeat(T.loc)
					xenomeat.name = "[localized_player_label(trim(xeno_victim.age_prefix))][localized_player_label(xeno_victim.caste_type)]生里脊肉"
				else if(victim && isturf(T.loc))
					var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
					meat.name = "[victim.name]生里脊肉"
					victim.apply_damage(100, BRUTE,"chest", FALSE, FALSE)
				T.butchery_progress = 4
				playsound(loc, 'sound/weapons/wristblades_hit.ogg', 25)
			else
				to_chat(src, SPAN_NOTICE("你暂停肢解，留待稍后继续。"))

		if(T.butchery_progress == 4)
			if(do_after(src, 9 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
				if(xeno_victim && isturf(T.loc))
					visible_message(SPAN_DANGER("[src]剥净了[victim]最后的外骨骼，只剩骨架！"), SPAN_NOTICE("你剥净了[victim]最后的外骨骼！"))
					new /obj/effect/decal/remains/xeno(xeno_victim.loc)
					var/obj/item/stack/sheet/animalhide/xeno/xenohide = new /obj/item/stack/sheet/animalhide/xeno(xeno_victim.loc)
					xenohide.name = "[localized_player_label(trim(xeno_victim.age_prefix))][localized_player_label(xeno_victim.caste_type)]外皮"
					xenohide.singular_name = "[localized_player_label(trim(xeno_victim.age_prefix))][localized_player_label(xeno_victim.caste_type)]外皮"
					xenohide.stack_id = "[xeno_victim.age_prefix][xeno_victim.caste_type]-hide"
				else if(victim && isturf(T.loc))
					visible_message(SPAN_DANGER("[src]俯身扯出了[T]的脊髓和头骨！"), SPAN_NOTICE("你牢牢抓住暴露的脊柱，将[T]的头扯了下来！"))
					if(!(victim.get_limb("head").status & LIMB_DESTROYED))
						victim.apply_damage(150, BRUTE, "head", FALSE, TRUE)
						var/obj/item/clothing/accessory/limb/skeleton/head/spine/new_spine = new /obj/item/clothing/accessory/limb/skeleton/head/spine(victim.loc)
						new_spine.name = "[victim]的脊柱"
					else
						var/obj/item/reagent_container/food/snacks/meat/meat = new /obj/item/reagent_container/food/snacks/meat(victim.loc)
						meat.name = "[victim.real_name]生肉排"
						new /obj/item/clothing/accessory/limb/skeleton/torso(victim.loc)
					var/obj/item/stack/sheet/animalhide/human/hide = new /obj/item/stack/sheet/animalhide/human(victim.loc)
					hide.name = "[victim.name]外皮"
					hide.singular_name = "[victim.name]外皮"
					hide.stack_id = "[victim.name]-hide"
					new /obj/effect/decal/remains/human(T.loc)
				if(T.legcuffed)
					T.drop_inv_item_on_ground(T.legcuffed)
				T.butchery_progress = 5 //Won't really matter.
				playsound(loc, 'sound/weapons/slice.ogg', 25)
				if(hunter_data.prey == T)
					to_chat(src, SPAN_YAUTJABOLD("你将[T]收为了战利品。"))
					emote("roar2")
					message_all_yautja("[src.real_name]已将[T]收为战利品。")
					hunter_data.prey = null
				else
					to_chat(src, SPAN_NOTICE("你完成了肢解！"))
				qdel(T)
			else
				to_chat(src, SPAN_NOTICE("你暂停肢解，留待稍后继续。"))
	else
		var/limb = procedure_choices[procedure]
		var/limbName = localized_player_label(parse_zone(limb))
		if(victim.get_limb(limb).status & LIMB_DESTROYED)
			to_chat(src, SPAN_WARNING("受害者没有[limbName]。"))
			return
		if(limb == "head")
			visible_message("<b>[src]俯身开始斩下[T]的头。</b>","<b>你俯身开始斩下 [T] 的头。</b>")
		else
			visible_message("<b>[src]俯身开始拆下[T]的[limbName]。</b>","<b>你俯身开始拆下 [T] 的[limbName]。</b>")
		if(do_after(src, 9 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			if(victim.get_limb(limb).status & LIMB_DESTROYED)
				to_chat(src, SPAN_WARNING("受害者没有[limbName]。"))
				return
			victim.get_limb(limb).droplimb(TRUE, FALSE, "butchering")
			playsound(loc, 'sound/weapons/slice.ogg', 25)
			if(hunter_data.prey == T)
				to_chat(src, SPAN_YAUTJABOLD("你将[T]收为了战利品。"))
				emote("roar2")
				message_all_yautja("[src.real_name]已将[T]收为战利品。")
				hunter_data.prey = null
			else
				to_chat(src, SPAN_NOTICE("你完成了肢解！"))

/area/yautja
	name = "\improper Yautja Ship"
	icon_state = "teleporter"
	//music = "signal"
	ambience_exterior = AMBIENCE_YAUTJA
	ceiling = CEILING_METAL
	requires_power = FALSE
	base_lighting_alpha = 255

/mob/living/carbon/human/proc/pred_buy()
	set category = "Yautja.Misc"
	set name = "Claim Equipment"
	set desc = "在铁血飞船上领取装备。此操作只能进行一次。"

	if(hunter_data.claimed_equipment)
		to_chat(src, SPAN_WARNING("你已经领取过装备了。"))
		return

	if(is_mob_incapacitated() || body_position != STANDING_UP || buckled)
		to_chat(src, SPAN_WARNING("你现在无法这样做。"))
		return

	if(!isyautja(src))
		to_chat(src, SPAN_WARNING("你是怎么获得这个指令的？"))
		return

	if(!istype(get_area(src), /area/yautja))
		to_chat(src, SPAN_WARNING("这里不行，只能在舰船上领取。"))
		return

	var/obj/item/clothing/gloves/yautja/hunter/bracers = gloves
	if(!istype(bracers))
		to_chat(src, SPAN_WARNING("你需要佩戴护腕才能这样做。"))
		return

	var/sure = localized_native_alert(usr, "一系列强力武器展现在你面前。请谨慎选择装备。若在任何一步取消，将无法领取装备。", "确定？", "Begin the Hunt", "No, not now")
	if(sure != "Begin the Hunt")
		return

	var/list/melee = list(YAUTJA_GEAR_GLAIVE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "glaive"), YAUTJA_GEAR_WHIP = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "whip"),YAUTJA_GEAR_SWORD = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "clansword"),YAUTJA_GEAR_SCYTHE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "predscythe"), YAUTJA_GEAR_STICK = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "combistick"), YAUTJA_GEAR_SCIMS = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "scim"))
	var/list/other = list(YAUTJA_GEAR_LAUNCHER = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "spikelauncher"), YAUTJA_GEAR_PISTOL = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "plasmapistol"), YAUTJA_GEAR_DISC = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "disc"), YAUTJA_GEAR_FULL_ARMOR = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "fullarmor_ebony"), YAUTJA_GEAR_SHIELD = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "shield"), YAUTJA_GEAR_DRONE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "falcon_drone"))
	var/list/restricted = list(YAUTJA_GEAR_LAUNCHER, YAUTJA_GEAR_PISTOL, YAUTJA_GEAR_FULL_ARMOR, YAUTJA_GEAR_SHIELD, YAUTJA_GEAR_DRONE) //Can only select them once each.

	var/list/secondaries = list()
	var/total_secondaries = 2

	var/use_radials = src.client.prefs?.no_radials_preference ? FALSE : TRUE
	var/main_weapon = use_radials ? localized_radial_menu(src, src, melee) : localized_input_list(usr, "你想使用哪种武器狩猎？", "近战武器", melee)

	if(main_weapon == YAUTJA_GEAR_SCYTHE)
		var/list/scythe_variants = list(YAUTJA_GEAR_SCYTHE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "predscythe"), YAUTJA_GEAR_SCYTHE_ALT = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "predscythe_alt"))
		main_weapon = use_radials ? localized_radial_menu(src, src, scythe_variants) : localized_input_list(usr, "选择哪种战镰？", "近战武器", scythe_variants)

	if(main_weapon == YAUTJA_GEAR_GLAIVE)
		var/list/glaive_variants = list(YAUTJA_GEAR_GLAIVE = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "glaive"), YAUTJA_GEAR_GLAIVE_ALT = image(icon = 'icons/obj/items/hunter/pred_gear.dmi', icon_state = "glaive_alt"))
		main_weapon = use_radials ? localized_radial_menu(src, src, glaive_variants) : localized_input_list(usr, "选择哪种战刃？", "近战武器", glaive_variants)

	if(!main_weapon)
		return
	for(var/i = 1 to total_secondaries)
		var/secondary = use_radials ? localized_radial_menu(src, src, other) : localized_input_list(usr, "你想携带哪种辅助装备？", "物品[i]（共[total_secondaries]件）", other)
		if(!secondary)
			return
		secondaries += secondary
		if(secondary in restricted)
			other -= secondary

	bracers = gloves
	if(!istype(bracers))
		to_chat(src, SPAN_WARNING("你需要佩戴护腕才能这样做。"))
		return

	if(hunter_data.claimed_equipment)
		to_chat(src, SPAN_WARNING("你已经领取过装备了。"))
		return

	hunter_data.claimed_equipment = TRUE

	switch(main_weapon)
		if(YAUTJA_GEAR_GLAIVE)
			equip_to_slot_if_possible(new /obj/item/weapon/twohanded/yautja/glaive(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_GLAIVE_ALT)
			equip_to_slot_if_possible(new /obj/item/weapon/twohanded/yautja/glaive/alt(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_WHIP)
			equip_to_slot_if_possible(new /obj/item/weapon/yautja/chain(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_SWORD)
			equip_to_slot_if_possible(new /obj/item/weapon/yautja/sword(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_SCYTHE)
			equip_to_slot_if_possible(new /obj/item/weapon/yautja/scythe(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_SCYTHE_ALT)
			equip_to_slot_if_possible(new /obj/item/weapon/yautja/scythe/alt(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_STICK)
			equip_to_slot_if_possible(new /obj/item/weapon/yautja/combistick(src.loc), WEAR_J_STORE, disable_warning = TRUE)
		if(YAUTJA_GEAR_SCIMS)
			if(bracers.wristblades_deployed)
				bracers.wristblades_internal(usr, TRUE)
			qdel(bracers.left_wristblades)
			qdel(bracers.right_wristblades)
			bracers.left_wristblades = new /obj/item/weapon/wristblades/scimitar(bracers)
			bracers.right_wristblades = new /obj/item/weapon/wristblades/scimitar(bracers)

	for(var/choice in secondaries)
		switch(choice)
			if(YAUTJA_GEAR_LAUNCHER)
				equip_to_slot_if_possible(new /obj/item/weapon/gun/launcher/spike(src.loc), WEAR_IN_BELT, disable_warning = TRUE)
			if(YAUTJA_GEAR_PISTOL)
				equip_to_slot_if_possible(new /obj/item/weapon/gun/energy/yautja/plasmapistol(src.loc), WEAR_IN_BELT, disable_warning = TRUE)
			if(YAUTJA_GEAR_DISC)
				equip_to_slot_if_possible(new /obj/item/explosive/grenade/spawnergrenade/smartdisc(src.loc), WEAR_IN_BELT, disable_warning = TRUE)
			if(YAUTJA_GEAR_FULL_ARMOR)
				if(wear_suit)
					drop_inv_item_on_ground(wear_suit)
				equip_to_slot_if_possible(new /obj/item/clothing/suit/armor/yautja/hunter/full(src.loc, 0, src.client.prefs.predator_armor_material), WEAR_JACKET, disable_warning = TRUE)
			if(YAUTJA_GEAR_SHIELD)
				equip_to_slot_if_possible(new /obj/item/weapon/shield/riot/yautja(src.loc), WEAR_BACK, disable_warning = TRUE)
			if(YAUTJA_GEAR_DRONE)
				equip_to_slot_if_possible(new /obj/item/falcon_drone(src.loc), WEAR_R_EAR, disable_warning = TRUE)

	remove_verb(src, /mob/living/carbon/human/proc/pred_buy)
	remove_action(src, /datum/action/predator_action/claim_equipment)
