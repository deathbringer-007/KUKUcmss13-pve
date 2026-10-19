
//-------------------------------------------------------
//M5 RPG

/obj/item/weapon/gun/launcher/rocket
	name = "火箭筒"
	desc = "仿照经典卡尔·古斯塔夫无后坐力炮的重型装备，杀伤能力依旧不逊于数百年前的祖先。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m5"
	item_state = "m5"
	unacidable = TRUE
	indestructible = 1
	var/launch_sound = 'sound/weapons/gun_rocketlauncher.ogg'
	matter = list("metal" = 10000)
	current_mag = /obj/item/ammo_magazine/rocket
	flags_equip_slot = NO_FLAGS
	w_class = SIZE_HUGE
	force = 15
	wield_delay = WIELD_DELAY_SLOW
	delay_style = WEAPON_DELAY_NO_FIRE
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	attachable_allowed = list(/obj/item/attachable/scope/mini/army) //4 tile zoom if used

	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_INTERNAL_MAG
	var/datum/effect_system/smoke_spread/smoke

	flags_item = TWOHANDED|NO_CRYO_STORE
	flags_equip_slot = SLOT_BACK //The fact you can't carry the tube across your back is daft? Hello?
	var/skill_locked = FALSE

/obj/item/weapon/gun/launcher/rocket/Initialize(mapload, spawn_empty)
	. = ..()
	smoke = new()
	smoke.attach(src)

/obj/item/weapon/gun/launcher/rocket/Destroy()
	QDEL_NULL(smoke)
	return ..()

/obj/item/weapon/gun/launcher/rocket/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/rocket/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("vehicles", /datum/element/bullet_trait_damage_boost, 150, GLOB.damage_boost_vehicles),
	))

/obj/item/weapon/gun/launcher/rocket/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6*2)
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3


/obj/item/weapon/gun/launcher/rocket/get_examine_text(mob/user)
	. = ..()
	if(current_mag.current_rounds <= 0)
		. += "尚未装填。"
	if(current_mag.current_rounds > 0)
		. += "已装填[ammo.name]。"


/obj/item/weapon/gun/launcher/rocket/able_to_fire(mob/living/user)
	. = ..()
	if(!.) //Let's check all that other stuff first.
		return FALSE
	if(!istype(user))
		return FALSE
	if(skill_locked && !skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ROCKET)
		to_chat(user, SPAN_WARNING("你似乎不知道如何使用[src]……"))
		return FALSE
	if(user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
		to_chat(user, SPAN_WARNING("[name]的安全区防误射装置阻止了你开火！"))
		msg_admin_niche("[key_name(user)] attempted to fire \a [name] in [get_area(src)] [ADMIN_JMP(loc)]")
		return FALSE
	if(current_mag && current_mag.current_rounds > 0)
		make_rocket(user, 0, 1)

/obj/item/weapon/gun/launcher/rocket/load_into_chamber(mob/user)
// if(active_attachable) active_attachable = null
	return ready_in_chamber()

//No such thing
/obj/item/weapon/gun/launcher/rocket/reload_into_chamber(mob/user)
	return TRUE

/obj/item/weapon/gun/launcher/rocket/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	if(!current_mag)
		return
	qdel(projectile_to_fire)
	if(refund)
		current_mag.current_rounds++
	return TRUE

/obj/item/weapon/gun/launcher/rocket/proc/make_rocket(mob/user, drop_override = 0, empty = 1)
	if(!current_mag)
		return

	var/obj/item/ammo_magazine/rocket/r = new current_mag.type()
	//if there's ever another type of custom rocket ammo this logic should just be moved into a function on the rocket
	if(istype(current_mag, /obj/item/ammo_magazine/rocket/custom) && !empty)
		//set the custom rocket variables here.
		var/obj/item/ammo_magazine/rocket/custom/k = new /obj/item/ammo_magazine/rocket/custom
		var/obj/item/ammo_magazine/rocket/custom/cur_mag_cast = current_mag
		k.contents = cur_mag_cast.contents
		k.desc = cur_mag_cast.desc
		k.fuel = cur_mag_cast.fuel
		k.icon_state = cur_mag_cast.icon_state
		k.warhead = cur_mag_cast.warhead
		k.locked = cur_mag_cast.locked
		k.name = cur_mag_cast.name
		k.filters = cur_mag_cast.filters
		r = k

	if(empty)
		r.current_rounds = 0
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		r.forceMove(get_turf(src)) //Drop it on the ground.
	else
		user.put_in_hands(r)
		r.update_icon()

/obj/item/weapon/gun/launcher/rocket/reload(mob/user, obj/item/ammo_magazine/rocket)
	if(!current_mag)
		return
	if(flags_gun_features & GUN_BURST_FIRING)
		return

	if(!rocket || !istype(rocket) || !istype(src, rocket.gun_type))
		to_chat(user, SPAN_WARNING("那东西装不进去！"))
		return

	if(current_mag.current_rounds > 0)
		to_chat(user, SPAN_WARNING("[src]已经装填！"))
		return

	if(rocket.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("那个弹架是空的！"))
		return

	if(user)
		to_chat(user, SPAN_NOTICE("你开始为[src]装填弹药。请保持不动……"))
		if(do_after(user,current_mag.reload_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			qdel(current_mag)
			user.drop_inv_item_on_ground(rocket)
			current_mag = rocket
			rocket.forceMove(src)
			replace_ammo(,rocket)
			to_chat(user, SPAN_NOTICE("你将[rocket]装入[src]。"))
			if(reload_sound)
				playsound(user, reload_sound, 25, 1)
			else
				playsound(user,'sound/machines/click.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("你的装填被打断了！"))
			return
	else
		qdel(current_mag)
		current_mag = rocket
		rocket.forceMove(src)
		replace_ammo(,rocket)
	update_icon()
	return TRUE

/obj/item/weapon/gun/launcher/rocket/unload(mob/user,  reload_override = 0, drop_override = 0)
	if(user && current_mag)
		if(current_mag.current_rounds <= 0)
			to_chat(user, SPAN_WARNING("[src]已经是空的！"))
			return
		to_chat(user, SPAN_NOTICE("你开始卸下[src]的弹药。请保持不动……"))
		if(do_after(user, (current_mag.reload_delay/4), INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
			if(current_mag.current_rounds <= 0)
				to_chat(user, SPAN_WARNING("你已经卸下了[src]的弹药。"))
				return
			playsound(user, unload_sound, 25, 1)
			user.visible_message(SPAN_NOTICE("[user]从[src]中卸下[ammo]。"),
			SPAN_NOTICE("你从[src]中卸下[ammo]。"))
			make_rocket(user, drop_override, 0)
			current_mag.current_rounds = 0

//Adding in the rocket backblast. The tile behind the specialist gets blasted hard enough to down and slightly wound anyone
/obj/item/weapon/gun/launcher/rocket/apply_bullet_effects(obj/projectile/projectile_to_fire, mob/user, i = 1, reflex = 0)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_EAR_PROTECTION) && ishuman(user))
		var/mob/living/carbon/human/huser = user
		to_chat(user, SPAN_WARNING("啊！！[src]发射时的巨响震得你双耳嗡鸣！你大概应该戴上某种听力防护装备……"))
		huser.apply_effect(6, STUTTER)
		huser.emote("pain")
		huser.SetEarDeafness(max(user.ear_deaf,10))

	var/backblast_loc = get_turf(get_step(user.loc, turn(user.dir, 180)))
	smoke.set_up(1, 0, backblast_loc, turn(user.dir, 180))
	smoke.start()
	playsound(src, launch_sound, 100, TRUE, 10)
	for(var/mob/living/carbon/mob in backblast_loc)
		if(mob.body_position != STANDING_UP || HAS_TRAIT(mob, TRAIT_EAR_PROTECTION)) //Have to be standing up to get the fun stuff
			continue
		to_chat(mob, SPAN_BOLDWARNING("你被尾焰击中了！"))
		mob.apply_damage(15, BRUTE) //The shockwave hurts, quite a bit. It can knock unarmored targets unconscious in real life
		var/knockdown_amount = 6
		if(isxeno(mob))
			var/mob/living/carbon/xenomorph/xeno = mob
			knockdown_amount = knockdown_amount * (1 - xeno.caste?.xeno_explosion_resistance / 100)
		mob.KnockDown(knockdown_amount)
		mob.apply_effect(6, STUTTER)
		mob.emote("pain")

//-------------------------------------------------------
//Marine M5 RPG, comes with baked in scope unlike the colony-made launcher
/obj/item/weapon/gun/launcher/rocket/marine
	name = "M5 RPG 火箭筒"
	desc = "M5 RPG 是 USCM 的主要反装甲武器，用于摧毁轻型坦克与敌方建筑，是用途广泛的危险武器。"

/obj/item/weapon/gun/launcher/rocket/marine/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/army/scope = new(src)
	scope.hidden = TRUE
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	update_attachable(scope.slot)

//-------------------------------------------------------
//Army version, just reflavoured description
/obj/item/weapon/gun/launcher/rocket/marine/army
	desc = "M5 火箭筒是美国陆军常用的班组反装甲武器，用于摧毁轻型坦克和敌方建筑，是用途广泛的危险武器。"

//-------------------------------------------------------
//M5 RPG'S MEAN FUCKING COUSIN

/obj/item/weapon/gun/launcher/rocket/m57a4
	name = "\improper M57-A4“闪电”四联装温压发射器"
	desc = "M57-A4“闪电”可能是有史以来破坏力最强的单兵武器。这是一具可连续发射四枚温压导弹的四管发射器。无需多言。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "m57a4"
	item_state = "m57a4"

	current_mag = /obj/item/ammo_magazine/rocket/m57a4
	aim_slowdown = SLOWDOWN_ADS_SUPERWEAPON
	flags_gun_features = GUN_WIELDED_FIRING_ONLY

/obj/item/weapon/gun/launcher/rocket/m57a4/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_7)
	set_burst_amount(BURST_AMOUNT_TIER_4)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_3


//-------------------------------------------------------
//AT rocket launchers, can be used by non specs

/obj/item/weapon/gun/launcher/rocket/anti_tank //reloadable
	name = "\improper QH-4 肩射反坦克火箭筒"
	desc = "QH-4 是专门对付载具的危险武器，用于摧毁轻型坦克和敌方建筑。必须直接命中才能击穿载具装甲。"
	icon_state = "m83a2"
	item_state = "m83a2"
	unacidable = FALSE
	indestructible = FALSE
	skill_locked = FALSE

	current_mag = /obj/item/ammo_magazine/rocket/anti_tank

	attachable_allowed = list()

	flags_gun_features = GUN_WIELDED_FIRING_ONLY

	flags_item = TWOHANDED

/obj/item/weapon/gun/launcher/rocket/anti_tank/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("vehicles", /datum/element/bullet_trait_damage_boost, 200, GLOB.damage_boost_vehicles),
	))

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable //single shot and disposable
	name = "\improper M83A2 SADAR 反坦克火箭筒"
	desc = "M83A2 SADAR 是轻型单发反装甲武器，可攻击最远 1,000 米处的敌方载具。完全一次性使用，发射后即丢弃。收起时（武器特殊操作），SADAR 由防水碳纤维复合外筒及内置装有导弹的铝制发射管组成。按下扳机握把上的发射按钮即可击发，采用肩射瞄准。"
	var/fired = FALSE

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("你可以用武器特殊操作将它折叠。")

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	. = ..()
	if(.)
		fired = TRUE

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/unique_action(mob/M)
	if(fired)
		to_chat(M, SPAN_WARNING("[src]已经发射过，不能再折叠！"))
		return

	M.visible_message(SPAN_NOTICE("[M]开始折叠[src]。"), SPAN_NOTICE("你开始将[src]折叠收拢。"))

	if(!do_after(M, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_NOTICE("你停止折叠[src]。"))
		return

	fold(M)
	M.visible_message(SPAN_NOTICE("[M]完成了[src]的折叠。"), SPAN_NOTICE("你完成了[src]的折叠。"))

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/proc/fold(mob/user)
	var/obj/item/prop/folded_anti_tank_sadar/F = new /obj/item/prop/folded_anti_tank_sadar(src.loc)
	transfer_label_component(F)
	qdel(src)
	user.put_in_active_hand(F)

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/reload()
	to_chat(usr, SPAN_WARNING("你无法重新装填[src]！"))
	return

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/unload()
	to_chat(usr, SPAN_WARNING("你无法卸下[src]的弹药！"))
	return

/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/handle_starting_attachment()
	..()
	var/obj/item/attachable/scope/mini/sadar/scope = new(src)
	scope.hidden = TRUE
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	update_attachable(scope.slot)

//folded version of the sadar
/obj/item/prop/folded_anti_tank_sadar
	name = "\improper M83 SADAR（已折叠）"
	desc = "为便于收纳而折叠的 M83 SADAR 反坦克火箭筒，按 Z 键可展开。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m83a2_folded"
	w_class = SIZE_MEDIUM
	garbage = FALSE

/obj/item/prop/folded_anti_tank_sadar/attack_self(mob/user)
	user.visible_message(SPAN_NOTICE("[user]开始展开[src]。"), SPAN_NOTICE("你开始将[src]展开伸长。"))
	playsound(src, 'sound/items/component_pickup.ogg', 20, TRUE, 5)

	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_NOTICE("你停止展开[src]。"))
		return

	unfold(user)

	user.visible_message(SPAN_NOTICE("[user]完成了[src]的展开。"), SPAN_NOTICE("你完成了[src]的展开。"))
	playsound(src, 'sound/items/component_pickup.ogg', 20, TRUE, 5)
	. = ..()

/obj/item/prop/folded_anti_tank_sadar/proc/unfold(mob/user)
	var/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable/F = new /obj/item/weapon/gun/launcher/rocket/anti_tank/disposable(src.loc)
	transfer_label_component(F)
	qdel(src)
	user.put_in_active_hand(F)

//-------------------------------------------------------
//UPP Rocket Launcher

/obj/item/weapon/gun/launcher/rocket/upp
	name = "\improper HJRA-12 手持反坦克榴弹发射器"
	desc = "HJRA-12 手持反坦克榴弹发射器是进步人民联盟制式反装甲武器，设计简单易用，可摧毁或瘫痪装甲载具。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "hjra12"
	item_state = "hjra12"
	skill_locked = FALSE
	current_mag = /obj/item/ammo_magazine/rocket/upp/at

	attachable_allowed = list(/obj/item/attachable/upp_rpg_breech)

	flags_gun_features = GUN_WIELDED_FIRING_ONLY

	flags_item = TWOHANDED

/obj/item/weapon/gun/launcher/rocket/upp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 33, "muzzle_y" = 18,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = -6, "stock_y" = 16, "special_x" = 37, "special_y" = 16)

/obj/item/weapon/gun/launcher/rocket/upp/handle_starting_attachment()
	..()
	var/obj/item/attachable/upp_rpg_breech/S = new(src)
	S.flags_attach_features &= ~ATTACH_REMOVABLE
	S.Attach(src)
	update_attachables()

	var/obj/item/attachable/scope/mini/army/scope = new(src)
	scope.hidden = TRUE
	scope.flags_attach_features &= ~ATTACH_REMOVABLE
	scope.Attach(src)
	update_attachable(scope.slot)

/obj/item/weapon/gun/launcher/rocket/upp/apply_bullet_effects(obj/projectile/projectile_to_fire, mob/user, i = 1, reflex = 0)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_EAR_PROTECTION) && ishuman(user))
		return

	var/backblast_loc = get_turf(get_step(user.loc, turn(user.dir, 180)))
	smoke.set_up(1, 0, backblast_loc, turn(user.dir, 180))
	smoke.start()
	playsound(src, 'sound/weapons/gun_rocketlauncher.ogg', 100, TRUE, 10)
	for(var/mob/living/carbon/C in backblast_loc)
		if(C.body_position == STANDING_UP && !HAS_TRAIT(C, TRAIT_EAR_PROTECTION)) //Have to be standing up to get the fun stuff
			C.apply_damage(15, BRUTE) //The shockwave hurts, quite a bit. It can knock unarmored targets unconscious in real life
			C.apply_effect(4, STUN) //For good measure
			C.apply_effect(6, STUTTER)
			C.emote("pain")

/obj/item/weapon/gun/launcher/rocket/upp/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("vehicles", /datum/element/bullet_trait_damage_boost, 10, GLOB.damage_boost_vehicles),
	))

/obj/item/weapon/gun/launcher/rocket/anti_air
	name = "\improper 防空导弹发射器"
	desc = "哪个疯子把 M5 改成发射防空导弹的了？真是丧心病狂。"
	current_mag = /obj/item/ammo_magazine/rocket/anti_air
	w_class = SIZE_LARGE
	aim_slowdown = SLOWDOWN_ADS_SCOPE
	actions_types = list(/datum/action/item_action/toggle_aerial_targeting)
	var/targeting_air = FALSE
	var/launcher_has_empty_icon = FALSE
	var/is_outside = FALSE //Whether the user is firing from inside an unsuitable location or not
	var/missile_message_time = 1.5 SECONDS

/obj/item/weapon/gun/launcher/rocket/anti_air/set_bullet_traits()
	return

/obj/item/weapon/gun/launcher/rocket/anti_air/Initialize(mapload, ...)
	. = ..()
	smoke = new()
	smoke.attach(src)

/obj/item/weapon/gun/launcher/rocket/anti_air/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/launcher/rocket/anti_air/get_examine_text(mob/user)
	. = ..()
	if(!targeting_air)
		. += "瞄准系统已关闭，发射后会命中正前方的目标。"
	else
		. += "瞄准系统已启动，发射后会将导弹射向天空。"

/obj/item/weapon/gun/launcher/rocket/anti_air/update_icon()
	. = ..()
	var/launcher_sprite = base_gun_icon
	if(launcher_has_empty_icon && current_mag.current_rounds <= 0)
		launcher_sprite += "_e"
	icon_state = launcher_sprite

/obj/item/weapon/gun/launcher/rocket/anti_air/proc/missile_launch(mob/living/user)
	user.visible_message(SPAN_HIGHDANGER("一枚导弹飞向头顶的天空！"), SPAN_WARNING("导弹划着弧线升入空中！"), ,10)
	message_admins("[key_name_admin(user)] fired an AA weapon ([name]) into the air! [ADMIN_JMP(user)]")
	log_game("[key_name_admin(user)] used an AA missile launcher ([name]).")

/obj/item/weapon/gun/launcher/rocket/anti_air/able_to_fire(mob/living/user)
	..()
	if(!current_mag.current_rounds > 0)
		return FALSE
	if(targeting_air)
		var/turf/user_turf = get_turf(user)
		var/area/targ_area = get_area(user)
		if(!istype(user_turf))
			return FALSE
		switch(targ_area.ceiling)
			if(CEILING_NONE)
				is_outside = TRUE
			if(CEILING_GLASS)
				is_outside = TRUE
		if(protected_by_pylon(TURF_PROTECTION_CAS, user_turf))
			is_outside = FALSE
		if(!is_outside)
			to_chat(user, SPAN_WARNING("你不能在屋顶下发射！到室外再试！"))
			return FALSE
		else
			ammo = /datum/ammo/anti_air
			addtimer(CALLBACK(src, PROC_REF(missile_launch), user), missile_message_time)
			return TRUE
	else
		. = ..()

/obj/item/weapon/gun/launcher/rocket/anti_air/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	. = ..()
	if(. && launcher_has_empty_icon)
		update_icon()

/obj/item/weapon/gun/launcher/rocket/anti_air/uscm
	name = "\improper SIM-118 防空导弹发射器"
	desc = "一次性肩射防空发射器，发射超高速导弹。指向飞行器，等待提示音，扣下扳机，然后丢掉。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "fim_hornet"
	item_state = "fim_hornet"
	launch_sound = 'sound/weapons/gun_hornet.ogg'
	has_empty_icon = TRUE
	current_mag = /obj/item/ammo_magazine/rocket/anti_air
	attachable_allowed = null
	launcher_has_empty_icon = TRUE

/obj/item/weapon/gun/launcher/rocket/anti_air/uscm/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 16,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/rocket/anti_air/uscm/handle_starting_attachment()
	..()
	var/obj/item/attachable/simbarrel/tube = new(src)
	tube.flags_attach_features &= ~ATTACH_REMOVABLE
	tube.Attach(src)
	update_attachable(tube.slot)

/obj/item/weapon/gun/launcher/rocket/anti_air/uscm/reload()
	to_chat(usr, SPAN_WARNING("你无法重新装填[src]！"))
	return

/obj/item/weapon/gun/launcher/rocket/anti_air/uscm/unload()
	to_chat(usr, SPAN_WARNING("你无法卸下[src]的弹药！"))
	return

/obj/item/weapon/gun/launcher/rocket/anti_air/upp
	name = "\improper EMBLR-92 防空武器系统"
	desc = "德国设计的便携式防空导弹系统，用于取代老旧的俄制“长矛”导弹发射器，为进步人民联盟武装集体提供可观的排级防空能力。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "emblr"
	item_state = "emblr"
	launch_sound = 'sound/weapons/gun_emblr.ogg'
	current_mag = /obj/item/ammo_magazine/rocket/anti_air/upp
	attachable_allowed = null
	launcher_has_empty_icon = TRUE

/obj/item/weapon/gun/launcher/rocket/anti_air/upp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 16,"rail_x" = 6, "rail_y" = 19, "under_x" = 19, "under_y" = 14, "stock_x" = 19, "stock_y" = 14)

/obj/item/weapon/gun/launcher/rocket/anti_air/upp/handle_starting_attachment()
	..()
	var/obj/item/attachable/emblrbarrel/tube = new(src)
	tube.flags_attach_features &= ~ATTACH_REMOVABLE
	tube.Attach(src)
	update_attachable(tube.slot)


//-------------------------------------------------------
//Toggle firing level special action for AA launchers, edited from the GL item_action

/datum/action/item_action/toggle_aerial_targeting/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Aerial Targeting"
	button.name = "切换对空瞄准"
	update_icon()

/datum/action/item_action/toggle_aerial_targeting/action_activate()
	. = ..()
	var/obj/item/weapon/gun/launcher/rocket/anti_air/SAM = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || SAM.get_active_firearm(H, FALSE) != holder_item)
		return
	SAM.toggle_aerial_targeting(usr)

/datum/action/item_action/toggle_aerial_targeting/proc/update_icon()
	var/obj/item/weapon/gun/launcher/rocket/anti_air/SAM = holder_item
	if(SAM.targeting_air)
		action_icon_state = "designator_one_weapon"
	else
		action_icon_state = "hightoss_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/launcher/rocket/anti_air/proc/toggle_aerial_targeting(mob/user)
	targeting_air = !targeting_air
	to_chat(user, "[icon2html(src, usr)]你切换了[src]的瞄准系统。现在会[targeting_air ? "向头顶的天空" : "直接向目标"]发射。")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	var/datum/action/item_action/toggle_aerial_targeting/TAT = locate(/datum/action/item_action/toggle_aerial_targeting) in actions
	TAT.update_icon()

