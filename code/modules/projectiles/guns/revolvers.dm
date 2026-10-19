//---------------------------------------------------

//Generic parent object.
/obj/item/weapon/gun/revolver
	flags_equip_slot = SLOT_WAIST
	w_class = SIZE_MEDIUM
	mouse_pointer = 'icons/effects/mouse_pointer/pistol_mouse.dmi'
	matter = list("metal" = 2000)

	flags_gun_features = GUN_CAN_POINTBLANK|GUN_INTERNAL_MAG|GUN_ONE_HAND_WIELDED
	gun_category = GUN_CATEGORY_HANDGUN
	wield_delay = WIELD_DELAY_VERY_FAST //If you modify your revolver to be two-handed, it will still be fast to aim
	movement_onehanded_acc_penalty_mult = 3
	has_empty_icon = FALSE
	has_open_icon = TRUE
	current_mag = /obj/item/ammo_magazine/internal/revolver

	fire_sound = 'sound/weapons/gun_44mag_v4.ogg'
	reload_sound = 'sound/weapons/gun_44mag_speed_loader.wav'
	cocked_sound = 'sound/weapons/gun_revolver_spun.ogg'
	unload_sound = 'sound/weapons/gun_44mag_open_chamber.wav'
	var/chamber_close_sound = 'sound/weapons/gun_44mag_close_chamber.wav'
	var/hand_reload_sound = 'sound/weapons/gun_revolver_load3.ogg'
	var/spin_sound = 'sound/effects/spin.ogg'
	var/thud_sound = 'sound/effects/thud.ogg'
	var/list/cylinder_click = list('sound/weapons/gun_empty.ogg')

	var/trick_delay = 4 SECONDS
	var/recent_trick //So they're not spamming tricks.
	var/russian_roulette = 0 //God help you if you do this.

/obj/item/weapon/gun/revolver/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag)
		replace_cylinder(current_mag.current_rounds)

/obj/item/weapon/gun/revolver/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_5)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3
	movement_onehanded_acc_penalty_mult = MOVEMENT_ACCURACY_PENALTY_MULT_TIER_3


/obj/item/weapon/gun/revolver/get_examine_text(mob/user)
	. = ..()
	if(current_mag)
		var/message = "[current_mag.chamber_closed? "It's closed.": "It's open with [current_mag.current_rounds] round\s loaded."]"
		. += message

/obj/item/weapon/gun/revolver/display_ammo(mob/user) // revolvers don't *really* have a chamber, at least in a way that matters for ammo displaying
	if(flags_gun_features & GUN_AMMO_COUNTER && !(flags_gun_features & GUN_BURST_FIRING) && current_mag)
		to_chat(user, SPAN_DANGER("剩余 [current_mag.current_rounds] / [current_mag.max_rounds] 发"))

/obj/item/weapon/gun/revolver/proc/rotate_cylinder(mob/user) //Cylinder moves backward.
	if(current_mag)
		current_mag.chamber_position = current_mag.chamber_position == 1 ? current_mag.max_rounds : current_mag.chamber_position - 1

/obj/item/weapon/gun/revolver/proc/spin_cylinder(mob/user)
	if(current_mag && current_mag.chamber_closed) //We're not spinning while it's open. Could screw up reloading.
		current_mag.chamber_position = rand(1,current_mag.max_rounds)
		to_chat(user, SPAN_NOTICE("你转动了弹巢。"))
		playsound(user, cocked_sound, 25, 1)
		russian_roulette = TRUE //Sets to play RR. Resets when the gun is emptied.

/obj/item/weapon/gun/revolver/proc/replace_cylinder(number_to_replace)
	if(current_mag)
		current_mag.chamber_contents = list()
		current_mag.chamber_contents.len = current_mag.max_rounds
		var/i
		for(i = 1 to current_mag.max_rounds) //We want to make sure to populate the cylinder.
			current_mag.chamber_contents[i] = i > number_to_replace ? "empty" : "bullet"
		current_mag.chamber_position = max(1,number_to_replace)

/obj/item/weapon/gun/revolver/proc/empty_cylinder()
	if(current_mag)
		for(var/i = 1 to current_mag.max_rounds)
			current_mag.chamber_contents[i] = "empty"
	eject_casing()

//The cylinder is always emptied out before a reload takes place.
/obj/item/weapon/gun/revolver/proc/add_to_cylinder(mob/user) //Bullets are added forward.
	if(current_mag)
		//First we're going to try and replace the current bullet.
		if(!current_mag.current_rounds)
			current_mag.chamber_contents[current_mag.chamber_position] = "bullet"
		else //Failing that, we'll try to replace the next bullet in line.
			if((current_mag.chamber_position + 1) > current_mag.max_rounds)
				current_mag.chamber_contents[1] = "bullet"
				current_mag.chamber_position = 1
			else
				current_mag.chamber_contents[current_mag.chamber_position + 1] = "bullet"
				current_mag.chamber_position++
		playsound(user, hand_reload_sound, 25, 1)
		return 1

/obj/item/weapon/gun/revolver/reload(mob/user, obj/item/ammo_magazine/magazine)
	if(flags_gun_features & GUN_BURST_FIRING) return

	if(!magazine || !istype(magazine))
		to_chat(user, SPAN_WARNING("那样行不通！"))
		return

	if(magazine.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("[magazine.name]是空的！"))
		return

	if(current_mag)
		if(istype(magazine, /obj/item/ammo_magazine/handful)) //Looks like we're loading via handful.
			if(current_mag.chamber_closed)
				to_chat(user, SPAN_WARNING("弹巢关着时无法装填任何弹药！"))
				return
			if(!current_mag.current_rounds && current_mag.caliber == magazine.caliber) //Make sure nothing's loaded and the calibers match.
				replace_ammo(user, magazine) //We are going to replace the ammo just in case.
				current_mag.match_ammo(magazine)
				current_mag.transfer_ammo(magazine,user,1) //Handful can get deleted, so we can't check through it.
				add_to_cylinder(user)
			//If bullets still remain in the gun, we want to check if the actual ammo matches.
			else if(magazine.default_ammo == current_mag.default_ammo) //Ammo datums match, let's see if they are compatible.
				if(current_mag.transfer_ammo(magazine,user,1))
					add_to_cylinder(user)//If the magazine is deleted, we're still fine.
			else
				to_chat(user, "[current_mag][current_mag.current_rounds ? "已经装了其他弹药，最好别混装。" : "与这种弹药不兼容。"]") //Not the right kind of ammo.
		else //So if it's not a handful, it's an actual speedloader.
			if(current_mag.gun_type == magazine.gun_type) //Has to be the same gun type.
				if(current_mag.chamber_closed) // If the chamber is closed unload it
					unload(user)
				if(current_mag.transfer_ammo(magazine,user,magazine.current_rounds))//Make sure we're successful.
					replace_ammo(user, magazine) //We want to replace the ammo ahead of time, but not necessary here.
					current_mag.match_ammo(magazine)
					replace_cylinder(current_mag.current_rounds)
					playsound(user, reload_sound, 25, 1) // Reloading via speedloader.
					if(!current_mag.chamber_closed) // If the chamber is open, we close it
						unload(user)
			else
				to_chat(user, SPAN_WARNING("[magazine]装不进去！"))

/obj/item/weapon/gun/revolver/unload(mob/user)
	if(flags_gun_features & GUN_BURST_FIRING) return

	if(current_mag)
		if(current_mag.chamber_closed) //If it's actually closed.
			to_chat(user, SPAN_NOTICE("你清空了[src]的弹巢。"))
			empty_cylinder()
			current_mag.create_handful(user)
			current_mag.chamber_closed = !current_mag.chamber_closed
			russian_roulette = FALSE //Resets the RR variable.
			playsound(src, chamber_close_sound, 25, 1)
		else
			current_mag.chamber_closed = !current_mag.chamber_closed
			playsound(src, unload_sound, 25, 1)
		update_icon()
	return

/obj/item/weapon/gun/revolver/able_to_fire(mob/user)
	. = ..()
	if(. && istype(user) && current_mag && !current_mag.chamber_closed)
		to_chat(user, SPAN_WARNING("先关上弹巢！"))
		playsound(user, pick(cylinder_click), 25, 1, 5)
		return 0

/obj/item/weapon/gun/revolver/ready_in_chamber()
	if(current_mag)
		if(current_mag.current_rounds > 0)
			if(current_mag.chamber_contents[current_mag.chamber_position] == "bullet")
				current_mag.current_rounds-- //Subtract the round from the mag.
				in_chamber = create_bullet(ammo, initial(name))
				apply_traits(in_chamber)
				return in_chamber
		else if(current_mag.chamber_closed)
			unload(null)

/obj/item/weapon/gun/revolver/load_into_chamber(mob/user)
	if(ready_in_chamber())
		return in_chamber
	rotate_cylinder() //If we fail to return to chamber the round, we just move the firing pin some.

/obj/item/weapon/gun/revolver/reload_into_chamber(mob/user)
	in_chamber = null
	if(current_mag)
		current_mag.chamber_contents[current_mag.chamber_position] = "blank" //We shot the bullet.
		rotate_cylinder()
		return 1

/obj/item/weapon/gun/revolver/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund && current_mag)
		current_mag.current_rounds++
	return TRUE

// FLUFF
/obj/item/weapon/gun/revolver/unique_action(mob/user)
	spin_cylinder(user)

/obj/item/weapon/gun/revolver/proc/revolver_basic_spin(mob/living/carbon/human/user, direction = 1, obj/item/weapon/gun/revolver/double)
	set waitfor = 0
	playsound(user, spin_sound, 25, 1)
	if(double)
		user.visible_message("[user]熟练地甩动并转起[src]和[double]！", SPAN_NOTICE("你甩动并转起[src]和[double]！"),  null, 3)
		animation_wrist_flick(double, 1)
	else
		user.visible_message("[user]熟练地甩动并转起[src]！",SPAN_NOTICE("你甩动并转起[src]！"),  null, 3)

	animation_wrist_flick(src, direction)
	sleep(3)
	if(loc && user) playsound(user, thud_sound, 25, 1)

/obj/item/weapon/gun/revolver/proc/revolver_throw_catch(mob/living/carbon/human/user)
	set waitfor = 0
	user.visible_message("[user]熟练地甩起[src]，将它抛向空中！", SPAN_NOTICE("你甩起[src]，将它抛向空中！"), null, 3)
	var/img_layer = MOB_LAYER+0.1
	var/image/trick = image(icon,user,icon_state,img_layer)
	switch(pick(1,2))
		if(1) animation_toss_snatch(trick)
		if(2) animation_toss_flick(trick, pick(1,-1))

	invisibility = 100
	var/list/client/displayed_for = list()
	for(var/mob/M as anything in viewers(user))
		var/client/C = M.client
		if(C)
			C.images += trick
			displayed_for += C

	sleep(6) // BOO

	for(var/client/C in displayed_for)
		C.images -= trick
	trick = null
	invisibility = 0

	if(loc && user)
		playsound(user, thud_sound, 25, 1)
		if(user.get_inactive_hand())
			user.visible_message("[user]用同一只手接住了[src]！", SPAN_NOTICE("你接住了旋转着落入手中的[src]！"), null, 3)
		else
			user.visible_message("[user]用另一只手接住了[src]！", SPAN_NOTICE("你用另一只手一把接住[src]！帅极了！"), null, 3)
			user.temp_drop_inv_item(src)
			user.put_in_inactive_hand(src)
			user.swap_hand()
			user.update_inv_l_hand(0)
			user.update_inv_r_hand()

/obj/item/weapon/gun/revolver/proc/revolver_trick(mob/living/carbon/human/user)
	if(world.time < (recent_trick + trick_delay) ) return //Don't spam it.
	if(!istype(user)) return //Not human.
	var/chance = -5
	chance = user.health < 6 ? 0 : user.health - 5

	//Pain is largely ignored, since it deals its own effects on the mob. We're just concerned with health.
	//And this proc will only deal with humans for now.

	recent_trick = world.time //Turn on the delay for the next trick.
	var/obj/item/weapon/gun/revolver/double = user.get_inactive_hand()
	if(prob(chance))
		switch(rand(1,8))
			if(1)
				revolver_basic_spin(user, -1)
			if(2)
				revolver_basic_spin(user, 1)
			if(3)
				revolver_throw_catch(user)
			if(4)
				revolver_basic_spin(user, 1)
			if(5)
				revolver_basic_spin(user, 1)
			if(6)
				var/arguments[] = istype(double) ? list(user, 1, double) : list(user, -1)
				revolver_basic_spin(arglist(arguments))
			if(7)
				var/arguments[] = istype(double) ? list(user, -1, double) : list(user, 1)
				revolver_basic_spin(arglist(arguments))
			if(8)
				if(istype(double))
					spawn(0)
						double.revolver_throw_catch(user)
					revolver_throw_catch(user)
				else
					revolver_throw_catch(user)
		return TRUE
	else
		user.visible_message(SPAN_INFO("<b>[user]</b>像个大傻瓜一样笨拙地摆弄着[src]！"), null, null, 3)
		to_chat(user, SPAN_WARNING("你像个傻瓜一样笨拙地摆弄着[src]……一点也不酷。"))
		return FALSE


//-------------------------------------------------------
//M44 Revolver

/obj/item/weapon/gun/revolver/m44
	name = "M44 左轮手枪"
	desc = ".44 马格南左轮手枪，在 USCMC 中少量服役，用于防卫大型外星野生动物。仔细瞄准效果最佳。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "m44r"
	item_state = "m44r"
	fire_sounds = list('sound/weapons/gun_cmb_1.ogg', 'sound/weapons/gun_cmb_2.ogg')
	cocked_sound = 'sound/weapons/gun_revolver_spun.ogg'
	unload_sound = 'sound/weapons/handling/pkd_open_chamber.ogg'
	chamber_close_sound = 'sound/weapons/handling/pkd_close_chamber.ogg'

	current_mag = /obj/item/ammo_magazine/internal/revolver/m44
	force = 8
	flags_gun_features = GUN_INTERNAL_MAG|GUN_CAN_POINTBLANK|GUN_ONE_HAND_WIELDED
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/stock/revolver,
		/obj/item/attachable/scope,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini_iff,
	)
	var/folded = FALSE // Used for the stock attachment, to check if we can shoot or not

/obj/item/weapon/gun/revolver/m44/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 21,"rail_x" = 12, "rail_y" = 23, "under_x" = 21, "under_y" = 16, "stock_x" = 16, "stock_y" = 20, "side_rail_x" = 21, "side_rail_y" = 16)

/obj/item/weapon/gun/revolver/m44/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_8
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/revolver/m44/able_to_fire(mob/user)
	if (folded)
		to_chat(user, SPAN_NOTICE("你需要展开枪托才能开火！"))//this is stupid
		return 0
	else
		return ..()

/obj/item/weapon/gun/revolver/m44/mp //No differences (yet) beside spawning with marksman ammo loaded
	current_mag = /obj/item/ammo_magazine/internal/revolver/m44/marksman

/obj/item/weapon/gun/revolver/m44/custom //loadout
	name = "\improper M44 定制战斗左轮手枪"
	desc = "M44 左轮手枪的定制版，握把打磨得如珍珠般光亮，枪身镀银。发射 .44 Magnum 弹药。"
	current_mag = /obj/item/ammo_magazine/internal/revolver/m44
	icon_state = "m44rc"
	item_state = "m44rc"

//----------------------------------------------
// Blade Runner Blasters.
/obj/item/weapon/gun/revolver/m44/custom/pkd_special
	name = "\improper M2019 爆能手枪"
	desc = "正式名称是普尔法格-胜又 D 系列爆能手枪。M2019 于 2019 年取代侦探用的 .38 短管特种左轮，成为侦探和银翼杀手使用的经典武器。发射定制 .44 马格南脱壳弹。法律上属于左轮手枪，其非传统却坚固的内部设计令收藏家和爱好者趋之若鹜。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "lapd_2019"
	item_state = "highpower" //placeholder

	fire_sound = "gun_pkd"
	fire_rattle = 'sound/weapons/gun_pkd_fire01_rattle.ogg'
	reload_sound = 'sound/weapons/handling/pkd_speed_load.ogg'
	cocked_sound = 'sound/weapons/handling/pkd_cock.wav'
	unload_sound = 'sound/weapons/handling/pkd_open_chamber.ogg'
	chamber_close_sound = 'sound/weapons/handling/pkd_close_chamber.ogg'
	hand_reload_sound = 'sound/weapons/gun_revolver_load3.ogg'
	current_mag = /obj/item/ammo_magazine/internal/revolver/m44/pkd
	accepted_ammo = list(
		/obj/item/ammo_magazine/internal/revolver/m44/pkd,
	)

	attachable_allowed = list(
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
	)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 22,"rail_x" = 11, "rail_y" = 25, "under_x" = 20, "under_y" = 18, "stock_x" = 20, "stock_y" = 18, "side_rail_x" = 20, "side_rail_y" = 18)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	set_fire_delay(FIRE_DELAY_TIER_11)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/k2049
	name = "\improper M2049 爆能手枪"
	desc = "自 2049 年起服役的洛杉矶警局 2049 型 .44 特种手枪，“退役”的复制人比美洲走廊的殖民者还多。顶部皮卡汀尼导轨可安装多种光学瞄具，助力有抱负的侦探。复制人虽不得越过外核心星系，这把枪仍偶尔会随叛逃者、收藏家和窃贼流入边缘地区。"
	icon_state = "lapd_2049"
	item_state = "m4a3c" //placeholder

	attachable_allowed = list(
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/scope/mini_iff,
	)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/k2049/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 22,"rail_x" = 11, "rail_y" = 25, "under_x" = 20, "under_y" = 18, "stock_x" = 20, "stock_y" = 18, "side_rail_x" = 20, "side_rail_y" = 18)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/k2049/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_12)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/l_series
	name = "\improper PKL“双响”爆能手枪"
	desc = "面向平民和私人公司销售的普尔法格-胜又 L 系列爆能手枪，是可同时发射两发弹药的高档双管副武器。常见于战斗合成人和复制人手中，价值超过三把“散射者”的总和。最初由华莱士公司委托制造，后来作为奢侈枪械向公众销售。"
	icon_state = "pkd_double"
	item_state = "vp70" //placeholder

	attachable_allowed = list(
		/obj/item/attachable/flashlight,
		/obj/item/attachable/lasersight,
	)

/obj/item/weapon/gun/revolver/m44/custom/pkd_special/l_series/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	set_fire_delay(FIRE_DELAY_TIER_11)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_12)

/obj/item/weapon/gun/revolver/m44/custom/webley //Van Bandolier's Webley.
	name = "\improper 韦伯利 Mk VI 制式手枪"
	desc = "沉重的中折式左轮手枪，配有胶木握把，年纪比大多数国家还大。.455 口径当年能收拾暴怒的部族战士和<i>德国佬</i>，如今当然也足以对付殖民地陆战队员和异形。"
	current_mag = /obj/item/ammo_magazine/internal/revolver/webley
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "webley"
	item_state = "m44r"
	attachable_allowed = list(
		/obj/item/attachable/bayonet,
		/obj/item/attachable/bayonet/upp,
	)

/obj/item/weapon/gun/revolver/m44/custom/webley/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2


//-------------------------------------------------------
//RUSSIAN REVOLVER //Based on the 7.62mm Russian revolvers.

/obj/item/weapon/gun/revolver/upp
	name = "ZHNK-72 左轮手枪"
	desc = "ZHNK-72 是 UPP 设计的左轮手枪，由其武装部队执行警务时使用，也少量配发给高级士官。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "zhnk72"
	item_state = "zhnk72"

	fire_sound = 'sound/weapons/gun_kt42.ogg'
	reload_sound = 'sound/weapons/handling/pkd_speed_load.ogg'
	cocked_sound = 'sound/weapons/handling/pkd_cock.wav'
	unload_sound = 'sound/weapons/handling/pkd_open_chamber.ogg'
	chamber_close_sound = 'sound/weapons/handling/pkd_close_chamber.ogg'
	hand_reload_sound = 'sound/weapons/gun_revolver_load3.ogg'
	current_mag = /obj/item/ammo_magazine/internal/revolver/upp
	force = 8
	attachable_allowed = list(
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/bayonet, // Muzzle
		/obj/item/attachable/bayonet/upp,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/lasersight, // Underbarrel/special
		/obj/item/attachable/flashlight,
		)

/obj/item/weapon/gun/revolver/upp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 28, "muzzle_y" = 21,"rail_x" = 14, "rail_y" = 23, "under_x" = 19, "under_y" = 17, "stock_x" = 24, "stock_y" = 19, "side_rail_x" = 19, "side_rail_y" = 17)

/obj/item/weapon/gun/revolver/upp/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil = 0
	recoil_unwielded = 0

/obj/item/weapon/gun/revolver/upp/shrapnel
	current_mag = /obj/item/ammo_magazine/internal/revolver/upp/shrapnel
	random_spawn_chance = 100
	random_siderail_chance = 100
	random_spawn_siderail = list(
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
	)

//-------------------------------------------------------
//357 REVOLVER //Based on the generic S&W 357.
//a lean mean machine, pretty inaccurate unless you play its dance.

/obj/item/weapon/gun/revolver/small
	name = ".38 左轮手枪"
	desc = "边疆特产。这里不少小公司靠提高弹药膛压、再修改设计勉强适配，宣称自家产品更好。通常精度糟糕，但命中冲击很惊人……前提是你知道怎么打准。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "sw357"
	item_state = "sw357"
	fire_sound = 'sound/weapons/gun_44mag2.ogg'
	current_mag = /obj/item/ammo_magazine/internal/revolver/small
	force = 6
	flags_gun_features = GUN_ANTIQUE|GUN_ONE_HAND_WIELDED|GUN_CAN_POINTBLANK

/obj/item/weapon/gun/revolver/small/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 19,"rail_x" = 12, "rail_y" = 21, "under_x" = 20, "under_y" = 15, "stock_x" = 20, "stock_y" = 15, "side_rail_x" = 20, "side_rail_y" = 15)

/obj/item/weapon/gun/revolver/small/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	accuracy_mult = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_1
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_6
	scatter = SCATTER_AMOUNT_TIER_7
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_4
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/revolver/small/unique_action(mob/user)
	var/result = revolver_trick(user)
	if(result)
		to_chat(user, SPAN_NOTICE("你的酷炫枪技让自己士气大振，接下来几枪会更加专注！"))
		accuracy_mult = BASE_ACCURACY_MULT * 2
		accuracy_mult_unwielded = BASE_ACCURACY_MULT * 2
		addtimer(CALLBACK(src, PROC_REF(recalculate_attachment_bonuses)), 3 SECONDS)


//-------------------------------------------------------
//BURST REVOLVER //Mateba is pretty well known. The cylinder folds up instead of to the side.

/obj/item/weapon/mateba_key
	name = "马特巴枪管扳手"
	desc = "用于更换马特巴左轮手枪的枪管。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "matebakey"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	force = 5
	w_class = SIZE_TINY
	throwforce = 5
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	attack_verb = list("刺击")

/obj/item/weapon/gun/revolver/mateba
	name = "马特巴自动左轮手枪"
	desc = "马特巴是威力强大、射速很快的左轮手枪，利用自身后坐力转动弹巢，发射重型 .454 子弹。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/uscm.dmi'
	icon_state = "mateba"
	item_state = "mateba"

	fire_sound = 'sound/weapons/gun_mateba.ogg'
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba
	force = 15
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/mateba,
		/obj/item/attachable/mateba/long,
		/obj/item/attachable/mateba/short,
	)
	starting_attachment_types = list(/obj/item/attachable/mateba)
	unacidable = TRUE
	black_market_value = 100
	var/is_locked = TRUE
	var/can_change_barrel = TRUE

/obj/item/weapon/gun/revolver/mateba/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/mateba_key) && can_change_barrel)
		if(attachments["special"])
			var/obj/item/attachable/R = attachments["special"]
			visible_message(SPAN_NOTICE("[user]开始从[src]上拆卸[R]。"),
			SPAN_NOTICE("你开始从[src]上拆卸[R]。"), null, 4)

			if(!do_after(usr, 35, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return

			if(!(R == attachments[R.slot]))
				return

			visible_message(SPAN_NOTICE("[user]解锁并从[src]上拆下[R]。"),
			SPAN_NOTICE("你解锁并从[src]上拆下[R]。"), null, 4)
			R.Detach(user, src)
			if(attachments["muzzle"])
				var/obj/item/attachable/M = attachments["muzzle"]
				M.Detach(user, src)
			playsound(src, 'sound/handling/attachment_remove.ogg', 15, 1, 4)
			update_icon()
	else if(istype(I, /obj/item/attachable))
		var/obj/item/attachable/A = I
		if(A.slot == "muzzle" && !attachments["special"] && can_change_barrel)
			to_chat(user, SPAN_WARNING("你需要先装上枪管！"))
			return
	. = ..()


/obj/item/weapon/gun/revolver/mateba/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 25, "muzzle_y" = 20,"rail_x" = 11, "rail_y" = 24, "under_x" = 19, "under_y" = 17, "stock_x" = 19, "stock_y" = 17, "special_x" = 23, "special_y" = 22)

/obj/item/weapon/gun/revolver/mateba/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_3)
	set_burst_amount(BURST_AMOUNT_TIER_3)
	set_burst_delay(FIRE_DELAY_TIER_8)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_2
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_5
	scatter = SCATTER_AMOUNT_TIER_7
	burst_scatter_mult = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_2
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_10
	recoil = RECOIL_AMOUNT_TIER_2
	recoil_unwielded = RECOIL_AMOUNT_TIER_2

/obj/item/weapon/gun/revolver/mateba/pmc
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba/ap

/obj/item/weapon/gun/revolver/mateba/general
	name = "\improper 镀金定制马特巴自动左轮"
	desc = "这把深度定制的马特巴采用镀金枪身和极度濒危红木制成的握把，夸耀的设计与持有者的权势相称。适合国王，或者将军。"
	icon_state = "amateba"
	item_state = "amateba"
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba/impact
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/mateba/dark,
		/obj/item/attachable/mateba/long/dark,
		/obj/item/attachable/mateba/short/dark,
	)
	starting_attachment_types = null

/obj/item/weapon/gun/revolver/mateba/general/handle_starting_attachment()
	..()
	var/obj/item/attachable/mateba/long/dark/barrel = new(src)
	barrel.flags_attach_features &= ~ATTACH_REMOVABLE
	barrel.Attach(src)
	update_attachables()

/obj/item/weapon/gun/revolver/mateba/general/santa
	name = "\improper 圣诞马特巴"
	desc = "圣诞老人亲自使用的马特巴，据说装填着爆炸弹药。"
	icon_state = "amateba"
	item_state = "amateba"
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba/explosive
	color = "#FF0000"
	fire_sound = null
	fire_sounds = list('sound/voice/alien_queen_xmas.ogg', 'sound/voice/alien_queen_xmas_2.ogg')
	starting_attachment_types = list(/obj/item/attachable/heavy_barrel)

/obj/item/weapon/gun/revolver/mateba/engraved
	name = "\improper 雕花马特巴自动左轮"
	desc = "哑光黑枪身、黑檀木握把和金边弹巢，让这把气派的马特巴既是艺术品，也是死亡使者。"
	icon_state = "aamateba"
	item_state = "aamateba"
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba/impact

/obj/item/weapon/gun/revolver/mateba/cmateba
	name = "\improper 定制马特巴自动左轮"
	desc = ".454 口径马特巴 6 Unica 自动左轮是一把半自动手炮，利用自身后坐力转动弹巢。极为罕见、价格高昂且威力惊人，只掌握在少数美国殖民地陆战队高级官员手中。时尚、精致，最重要的是，极其致命。"
	icon_state = "cmateba"
	item_state = "cmateba"
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba/impact
	map_specific_decoration = TRUE

/obj/item/weapon/gun/revolver/mateba/special
	name = "\improper 特制马特巴自动左轮"
	desc = "老旧且经过深度改装的马特巴自动左轮。配有光滑木握把，枪管比原版大得多。显然长期受到精心保养。"
	icon_state = "cmateba_special"
	item_state = "cmateba_special"
	current_mag = /obj/item/ammo_magazine/internal/revolver/mateba/impact
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/reflex,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
	)
	starting_attachment_types = list()
	can_change_barrel = FALSE

/obj/item/weapon/gun/revolver/mateba/special/set_gun_config_values()
	..()
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4

/obj/item/weapon/gun/revolver/mateba/special/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 30, "muzzle_y" = 23,"rail_x" = 9, "rail_y" = 24, "under_x" = 19, "under_y" = 17, "stock_x" = 19, "stock_y" = 17, "special_x" = 23, "special_y" = 22)

//-------------------------------------------------------
//MARSHALS REVOLVER //Spearhead exists in Alien cannon.

/obj/item/weapon/gun/revolver/spearhead
	name = "矛头军械左轮手枪"
	desc = "矛头军械设计的精致优质 .357 左轮手枪，常配发给殖民地执法官。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "spearhead"
	item_state = "spearhead"
	fire_sound = null
	fire_sounds = list('sound/weapons/gun_cmb_1.ogg', 'sound/weapons/gun_cmb_2.ogg')
	fire_rattle = 'sound/weapons/gun_cmb_rattle.ogg'
	//cylinder_click = list('sound/weapons/handling/gun_cmb_click1.ogg', 'sound/weapons/handling/gun_cmb_click2.ogg')
	unload_sound = 'sound/weapons/handling/pkd_open_chamber.ogg'
	chamber_close_sound = 'sound/weapons/handling/pkd_close_chamber.ogg'
	current_mag = /obj/item/ammo_magazine/internal/revolver/spearhead
	force = 15
	attachable_allowed = list(
		/obj/item/attachable/suppressor, // Muzzle
		/obj/item/attachable/extended_barrel,
		/obj/item/attachable/heavy_barrel,
		/obj/item/attachable/compensator,
		/obj/item/attachable/reddot, // Rail
		/obj/item/attachable/reflex,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/gyro, // Under
		/obj/item/attachable/lasersight, // Special
		/obj/item/attachable/flashlight,
	)

/obj/item/weapon/gun/revolver/spearhead/click_empty(mob/user)
	if(user)
		to_chat(user, SPAN_WARNING("<b>*咔嗒*</b>"))
		playsound(user, pick('sound/weapons/handling/gun_cmb_click1.ogg', 'sound/weapons/handling/gun_cmb_click2.ogg'), 25, 1, 5) //5 tile range
	else
		playsound(src, pick('sound/weapons/handling/gun_cmb_click1.ogg', 'sound/weapons/handling/gun_cmb_click2.ogg'), 25, 1, 5)

/obj/item/weapon/gun/revolver/spearhead/Fire(atom/target, mob/living/user, params, reflex = 0, dual_wield)
	playsound('sound/weapons/gun_cmb_bass.ogg') // badass shooting bass
	return ..()

/obj/item/weapon/gun/revolver/spearhead/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 29, "muzzle_y" = 22,"rail_x" = 11, "rail_y" = 25, "under_x" = 20, "under_y" = 18, "stock_x" = 20, "stock_y" = 18, "side_rail_x" = 20, "side_rail_y" = 18)

/obj/item/weapon/gun/revolver/spearhead/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT - HIT_ACCURACY_MULT_TIER_4
	scatter = SCATTER_AMOUNT_TIER_7
	scatter_unwielded = SCATTER_AMOUNT_TIER_5
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_3
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_unwielded = RECOIL_AMOUNT_TIER_3

/obj/item/weapon/gun/revolver/spearhead/hollowpoint
	current_mag = /obj/item/ammo_magazine/internal/revolver/spearhead/hollowpoint

/obj/item/weapon/gun/revolver/spearhead/black
	name = "矛头军械左轮手枪"
	desc = "矛头军械设计的流线型优质 .357 左轮手枪，通常配发殖民地法警。这把经过黑色金属表面定制处理，应该不是制式配枪。"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "spearhead_black"
	item_state = "spearhead_black"

/obj/item/weapon/gun/revolver/spearhead/black/hollowpoint
	current_mag = /obj/item/ammo_magazine/internal/revolver/spearhead/hollowpoint
