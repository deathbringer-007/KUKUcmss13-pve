
/*
//================================================
				Blast Grenades
//================================================
*/

#define GRENADE_FIRE_RESISTANCE_MIN 10
#define GRENADE_FIRE_RESISTANCE_MAX 40

/obj/item/explosive/grenade/high_explosive
	name = "M40 HEDP 手榴弹"
	desc = "高爆两用手榴弹。体积小，威力却不容小觑，正逐步取代 M15 高爆手榴弹。爆炸猛烈，弹片杀伤半径为五米。可由 PN 30mm 下挂榴弹发射器发射并撞击引爆，也可手动拉火投掷，4 秒后爆炸。"
	icon_state = "grenade"
	det_time = 40
	item_state = "grenade_hedp"
	caliber = "30mm"
	dangerous = TRUE
	underslug_launchable = TRUE
	dual_purpose = TRUE
	arm_sound = 'sound/weapons/grenade.ogg'
	var/explosion_power = 100
	var/explosion_falloff = 30
	var/shrapnel_count = 32
	var/shrapnel_type = /datum/ammo/bullet/shrapnel
	var/fire_resistance = 15 //to prevent highly controlled massive explosions
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF

/obj/item/explosive/grenade/high_explosive/New()
	..()

	fire_resistance = rand(GRENADE_FIRE_RESISTANCE_MIN, GRENADE_FIRE_RESISTANCE_MAX)

/obj/item/explosive/grenade/high_explosive/prime(mob/living/user)
	set waitfor = 0
	if(fuse_type == IMPACT_FUSE)
		to_chat(user, SPAN_WARNING("这枚手榴弹已设为触发引信！"))
		return
	if(shrapnel_count)
		create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	apply_explosion_overlay()
	cell_explosion(loc, explosion_power, explosion_falloff, falloff_mode, null, cause_data)
	qdel(src)

/obj/item/explosive/grenade/high_explosive/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		if(shrapnel_count)
			create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
			sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
		apply_explosion_overlay()
		cell_explosion(loc, explosion_power, explosion_falloff, falloff_mode, null, cause_data)
		qdel(src)

/obj/item/explosive/grenade/high_explosive/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)

/obj/item/explosive/grenade/high_explosive/flamer_fire_act(damage, flame_cause_data)
	fire_resistance--
	if(fire_resistance<=0)
		cause_data = flame_cause_data
		prime()

/obj/item/explosive/grenade/high_explosive/super
	name = "M40/2 HEDP 手榴弹"
	desc = "高爆两用手榴弹，体积小，威力却不容小觑，正逐步取代 M15 高爆手榴弹。此型号威力更强。"
	icon_state = "m40_2"
	item_state = "grenade_hedp2"
	explosion_power = 150
	explosion_falloff = 50

/obj/item/explosive/grenade/high_explosive/pmc
	name = "M12 爆破手榴弹"
	desc = "为私人安保公司制造的高爆手榴弹，拔销后约 3 秒爆炸。"
	icon_state = "grenade_pmc"
	item_state = "grenade_ex"
	caliber = "non-standard"
	underslug_launchable = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	explosion_power = 200
	shrapnel_count = 0
	dual_purpose = FALSE
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF

/obj/item/explosive/grenade/high_explosive/stick
	name = "\improper 韦伯利 Mk15 柄式手榴弹"
	desc = "殖民地生产的爆破手榴弹，大多采用旧式设计和图纸。拔出保险销三秒后爆炸。"
	icon_state = "grenade_stick"
	item_state = "grenade_stick"
	caliber = "non-standard"
	force = 10
	w_class = SIZE_SMALL
	throwforce = 15
	throw_speed = SPEED_FAST
	throw_range = 7
	underslug_launchable = FALSE
	explosion_power = 100
	shrapnel_count = 0
	dual_purpose = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/high_explosive/upp
	name = "\improper 6 式手榴弹"
	desc = "进步人民联盟军队制式破片手榴弹，拔出保险销三秒后爆炸。"
	icon_state = "grenade_upp"
	item_state = "grenade_upp"
	caliber = "non-standard"
	throw_speed = SPEED_FAST
	throw_range = 6
	underslug_launchable = FALSE
	explosion_power = 100
	shrapnel_count = 48
	dual_purpose = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/*
//================================================
				Fragmentation Grenades
//================================================
*/
/obj/item/explosive/grenade/high_explosive/frag
	name = "M40 HEFA 手榴弹"
	desc = "高爆破片反步兵手榴弹。体积小，威力却不容小觑，正与 M40 HEDP 一同逐步取代 M15 破片手榴弹。可装入 M92 发射器，也可手投。"
	icon_state = "grenade_hefa"
	item_state = "grenade_hefa"
	explosion_power = 40
	shrapnel_count = 48
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/high_explosive/frag/toy
	AUTOWIKI_SKIP(TRUE)

	name = "玩具 HEFA 手榴弹"
	desc = "高爆反步兵破片手榴弹。体积小巧，威力却出奇地强，正与 M40 HEDP 一同逐步取代 M15 破片手榴弹。可装入 M92 发射器，也可手投。等等，侧面标签说这是玩具，搞什么鬼？"
	explosion_power = 0
	shrapnel_type = /datum/ammo/bullet/shrapnel/rubber
	antigrief_protection = FALSE
	dual_purpose = FALSE

/obj/item/explosive/grenade/high_explosive/m15
	name = "M15 破片手榴弹"
	desc = "老式 USCM 破片手榴弹。服役数十年后，M15 正逐步被稍安全一些的 M40 系列手榴弹取代。设定为 4 秒后引爆。"
	icon_state = "grenade_ex"
	item_state = "grenade_ex"
	caliber = "non-standard"
	throw_speed = SPEED_FAST
	dual_purpose = FALSE
	throw_range = 6
	underslug_launchable = FALSE
	explosion_power = 120
	shrapnel_count = 48
	arm_sound = 'sound/weapons/pinpull.ogg'
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/*
+//================================================
+				Canister Grenade
+//================================================
+*/

/obj/item/explosive/grenade/high_explosive/airburst/canister
	name = "M108 罐式榴弹"
	desc = "30mm 霰弹榴弹，实际相当于低速鹿弹。配合五发 PN 泵动榴弹发射器时，近战威力可观。不能用锤子敲响它，笨蛋。弹体黄色色带表明它不是手投弹，只能由发射器发射。"
	icon_state = "grenade_buck"
	item_state = "grenade_buck"
	hand_throwable = FALSE
	underslug_launchable = TRUE
	dual_purpose = FALSE
	caliber = "30mm"
	explosion_power = 0
	explosion_falloff = 25
	det_time = 0 //this should mean that it will explode instantly when fired and thus generate the shotshell effect.
	shrapnel_count = 18
	shrapnel_type = /datum/ammo/bullet/shrapnel/canister
	dispersion_angle = 15 //hopefully this means the cone spread is pretty small

/obj/item/explosive/grenade/high_explosive/airburst/canister/proc/canister_fire(mob/living/user, target)
	var/direction = Get_Compass_Dir(user, target)
	var/position = get_step(user, direction) //otherwise we buckshot ourselves
	create_shrapnel(position, min(direct_hit_shrapnel, shrapnel_count), direction , dispersion_angle, shrapnel_type, cause_data, FALSE, 100)
	if(shrapnel_count)
		create_shrapnel(loc, shrapnel_count, direction, dispersion_angle, shrapnel_type, cause_data, FALSE, 0)
	qdel(src)
// canister has no impact explosion.
/obj/item/explosive/grenade/high_explosive/airburst/canister/launch_impact(atom/hit_atom)
	return

/*
//================================================
				Airburst Grenades
//================================================
*/
// M74 are the launcher-only variant. Flag with hand_throwable = FALSE.
/obj/item/explosive/grenade/high_explosive/airburst
	name = "M74 AGM-F 40mm 手榴弹"
	desc = "M74 空爆榴弹弹药——破片型。必须使用榴弹发射器发射，到达目标位置后引爆。向前方锥形区域抛撒锋利弹片，撕裂肌腱与护甲。散布专为大型目标优化，直接命中时容易过穿。"
	icon_state = "grenade_m74_airburst_f"
	item_state = "grenade_m74_airburst_f_active"
	caliber = "40x53mm"
	explosion_power = 0
	explosion_falloff = 25
	shrapnel_count = 16
	det_time = 0 // Unused, because we don't use prime.
	hand_throwable = FALSE
	dual_purpose = FALSE
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR
	shrapnel_type = /datum/ammo/bullet/shrapnel/jagged
	var/direct_hit_shrapnel = 5
	var/dispersion_angle = 40

/obj/item/explosive/grenade/high_explosive/airburst/prime()
// We don't prime, we use launch_impact.

/obj/item/explosive/grenade/high_explosive/airburst/launch_impact(atom/hit_atom)
	..()
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		if(ismob(hit_atom))
			var/mob/M = hit_atom
			create_shrapnel(loc, min(direct_hit_shrapnel, shrapnel_count), last_move_dir , dispersion_angle ,shrapnel_type, cause_data, FALSE, 100)
			M.apply_effect(3.0, SUPERSLOW)
			shrapnel_count -= direct_hit_shrapnel
		if(shrapnel_count)
			create_shrapnel(loc, shrapnel_count, last_move_dir , dispersion_angle ,shrapnel_type, cause_data, FALSE, 0)
			sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
		apply_explosion_overlay()
		if(explosion_power)
			cell_explosion(loc, explosion_power, explosion_falloff, falloff_mode, last_move_dir, cause_data)
		qdel(src)

/obj/item/explosive/grenade/high_explosive/airburst/hornet_shell
	name = "M74 AGM-H 40mm 蜂群弹"
	desc = "工作方式与标准 AGM-F 40mm 榴弹相同，但蜂群弹射出的是具有全息标记功能的 .22lr 子弹，而非爆炸弹片。相当于远距离鹿弹。"
	icon_state = "grenade_hornet"
	item_state = "grenade_hornet_active"
	dual_purpose = FALSE
	shrapnel_count = 5
	shrapnel_type = /datum/ammo/bullet/shrapnel/hornet_rounds
	direct_hit_shrapnel = 5
	dispersion_angle = 15//tight cone

/obj/item/explosive/grenade/high_explosive/airburst/starshell
	name = "M74 AGM-S 照明弹"
	desc = "工作方式与标准 AGM-F 40mm 榴弹相同，但照明弹释放燃烧的磷来照亮周围，而不是炸成弹片。"
	icon_state = "grenade_starshell"
	item_state = "grenade_starshell_active"
	dual_purpose = FALSE
	shrapnel_count = 8
	shrapnel_type = /datum/ammo/flare/starshell
	direct_hit_shrapnel = 5
	dispersion_angle = 360 //beeg circle

/*
//================================================
				M203 Grenades
//================================================
*/

/obj/item/explosive/grenade/incendiary/impact
	name = "\improper 40 毫米燃烧榴弹"
	desc = "由榴弹发射器发射、触碰目标后爆炸的 40 毫米榴弹。这枚标记为燃烧弹，注意射界。"
	icon_state = "grenade_40mm_inc"
	det_time = 0
	item_state = "grenade_fire"
	caliber = "40x53mm"
	hand_throwable = FALSE
	dangerous = TRUE
	underslug_launchable = TRUE
	flame_level = BURN_TIME_TIER_2
	burn_level = BURN_LEVEL_TIER_3
	flameshape = FLAMESHAPE_DEFAULT
	radius = 2
	fire_type = FIRE_VARIANT_DEFAULT

/obj/item/explosive/grenade/incendiary/impact/prime()
	return

/obj/item/explosive/grenade/incendiary/impact/launch_impact(atom/hit_atom)
	..()
	var/detonate = TRUE
	var/turf/hit_turf = null
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom))
		hit_turf = hit_atom
		if(hit_turf.density && !rebounding)
			detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		var/angle = dir2angle(last_move_dir)
		var/turf/target = locate(x + sin(angle)*radius, y + cos(angle)*radius, z)
		if(target)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), cause_data, radius, get_turf(src), flame_level, burn_level, flameshape, target)
		else
			//Not stellar, but if we can't find a direction, fall back to HIDP behaviour.
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), cause_data, radius, get_turf(src), flame_level, burn_level, flameshape, target)
		playsound(src, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)
		qdel(src)

/obj/item/explosive/grenade/high_explosive/impact //omega hell killer grenade of doom from hell
	name = "\improper 40 毫米高爆榴弹"
	desc = "由榴弹发射器发射、触碰目标后爆炸的 40 毫米榴弹。这枚标记为高爆两用弹，注意射界。"
	icon_state = "grenade_40mm_hedp"
	item_state = "grenade_hedp"
	caliber = "40x53mm"
	det_time = 0
	hand_throwable = FALSE
	dangerous = TRUE
	underslug_launchable = TRUE
	explosion_power = 100 //hedp
	shrapnel_count = 0
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/high_explosive/impact/prime()
// We don't prime, we use launch_impact.

/obj/item/explosive/grenade/high_explosive/impact/launch_impact(atom/hit_atom)
	..()
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		if(explosion_power)
			cell_explosion(loc, explosion_power, explosion_falloff, falloff_mode, last_move_dir, cause_data)
		if(shrapnel_count)
			create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
		qdel(src)

/obj/item/explosive/grenade/high_explosive/impact/frag
	name = "\improper 40 毫米破片榴弹"
	desc = "由榴弹发射器发射、触碰目标后爆炸的 40 毫米榴弹。这枚标记为高爆反步兵破片弹，注意射界。"
	icon_state = "grenade_40mm_he"
	item_state = "grenade_hefa"
	explosion_power = 75
	shrapnel_count = 32
	shrapnel_type = /datum/ammo/bullet/shrapnel/heavy
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/high_explosive/impact/upp
	name = "\improper VOG-73 高爆榴弹"
	desc = "由榴弹发射器发射、触碰目标后爆炸的 40 毫米无壳榴弹，杀伤半径三米。这枚带有进步人民联盟标记。"
	icon_state = "grenade_40mm_upp"
	item_state = "grenade_hedp"
	caliber = "40x103mm"
	dangerous = FALSE
	explosion_power = 180 //Stronger than HEDP to make up for one shot in the tube
	explosion_falloff = 40 //But quicker to lose blast damage
	shrapnel_count = 16
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF

/obj/item/explosive/grenade/high_explosive/impact/upp/ap
	name = "\improper VPG-77 穿甲榴弹"
	desc = "由榴弹发射器发射的 40 毫米无壳穿甲榴弹，用于攻击装甲目标。这枚带有进步人民联盟标记。开火前注意前方有什么。"
	icon_state = "grenade_40mm_upp_ap"
	item_state = "grenade_hedp"
	explosion_power = 300 //Stronger than a HEAP grenade, to make up for one shot in the tube
	explosion_falloff = 900 //But no blast to speak of
	shrapnel_count = 0
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL

/obj/item/explosive/grenade/high_explosive/airburst/upp
	name = "\improper VShG-80 突击榴弹"
	desc = "用于城镇环境及近距离作战的 40 毫米无壳空爆霰弹，深受突击部队和工兵喜爱。碰撞后向宽阔锥形区域发射低速鹿弹。"
	icon_state = "grenade_40mm_buckshot"
	item_state = "grenade_hornet_active"
	caliber = "40x103mm"
	explosion_power = 0
	explosion_falloff = 25
	shrapnel_count = 33
	shrapnel_type = /datum/ammo/bullet/shrapnel/canister
	direct_hit_shrapnel = 33
	dispersion_angle = 25//a little big and forgiving

/obj/item/explosive/grenade/incendiary/impact/upp
	name = "\improper VTBG-44 温压榴弹"
	desc = "用于茂密植被或坚固阵地的 40 毫米无壳燃烧榴弹，爆炸威力十足。"
	caliber = "40x103mm"
	flame_level = BURN_TIME_TIER_5
	burn_level = BURN_LEVEL_TIER_4

/obj/item/explosive/grenade/incendiary/impact/upp/launch_impact(atom/hit_atom)
	..()
	cell_explosion(get_turf(hit_atom), 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, cause_data)

/obj/item/explosive/grenade/high_explosive/airburst/buckshot
	name = "\improper 40 毫米鹿弹"
	desc = "各地榴弹发射器的经典弹药，这枚 40 毫米炮弹装满鹿弹，非常危险，注意射界。"
	icon_state = "grenade_40mm_buckshot"
	item_state = "grenade_hornet_active"
	shrapnel_count = 10
	shrapnel_type = /datum/ammo/bullet/shotgun/spread
	direct_hit_shrapnel = 5
	dispersion_angle = 35//big

/*
//================================================
				Impact HEAP Grenade
//================================================
*/

/obj/item/explosive/grenade/high_explosive/impact/heap
	name = "M38 HEAP 爆破手榴弹"
	desc = "高爆穿甲榴弹。体积小，威力却不容小觑，可穿透可观厚度的装甲，同时保持与标准 M40 相近的杀伤半径。黄色色带表明它不是手投弹，只能由发射器发射。底火存在缺陷，不建议直接打向墙壁等硬表面，最好落在其前方。"
	icon_state = "grenade_heap"
	item_state = "grenade_chem"
	caliber = "30mm"
	explosion_power = 250
	explosion_falloff = 200
	shrapnel_count = 0
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/*
+//================================================
+				Bounding Fragmentation Grenade
+//================================================
+*/

/obj/item/explosive/grenade/high_explosive/impact/tmfrag
	name = "M51A BFAB 手榴弹"
	desc = "跳跃式空爆破片榴弹。不同于传统撞击引爆，它会先弹向空中，一秒后炸成致命弹雨。适合攻击开阔地或散兵坑中的部队。黄色色带表明它不是手投弹，只能由发射器发射。"
	icon_state = "grenade_bfab"
	item_state = "grenade_bfab"
	caliber = "30mm"
	explosion_power = 40
	shrapnel_count = 48
	shrapnel_type = /datum/ammo/bullet/shrapnel/heavy
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/high_explosive/impact/tmfrag/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		sleep(2)
		qdel(src)
		for(var/mob/mob in range(5, hit_atom))
			mob.show_message(SPAN_USERDANGER("手榴弹飞上空中，随后爆炸！"), SHOW_MESSAGE_VISIBLE)
		sleep(5)	//simulating it bounding up into the air before detonating
		if(shrapnel_count)
			create_shrapnel(hit_atom, shrapnel_count, , ,shrapnel_type, cause_data)
			sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
		apply_explosion_overlay()
		if(explosion_power)
			cell_explosion(hit_atom, explosion_power, explosion_falloff, falloff_mode, null, cause_data)

/*
//================================================
				Airborne Starshell Grenade
//================================================
*/

/obj/item/explosive/grenade/high_explosive/impact/flare
	name = "M72A2 HIPF 照明弹手榴弹"
	desc = "高亮降落伞照明弹。M72A2 发射升空后打开降落伞并点燃，可照亮周围数分钟。比 A1 型持续更久，但亮度较低。也可射向天花板，部分嵌入后作为顶灯，直至燃尽。"
	icon_state = "grenade_hipf"
	item_state = "grenade_hipf"
	caliber = "30mm"
	dangerous = TRUE	//kept so marines don't punt flare grenades up aboard the Garrow
	explosion_power = 0
	shrapnel_count = 0

/obj/item/explosive/grenade/high_explosive/impact/flare/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		qdel(src)
		sleep(5)	//simulating it arcing up out of view before igniting
		for(var/mob/mob in range(10, hit_atom))
			mob.show_message(SPAN_HIGHDANGER("一枚照明弹在头顶绽放出耀眼光芒！"), SHOW_MESSAGE_VISIBLE)
		new /obj/item/device/flashlight/flare/on/illumination(hit_atom)
		playsound(hit_atom, 'sound/weapons/gun_flare.ogg', 50, 1, 4)

/*
//================================================
				Incendiary Grenades
//================================================
*/

/obj/item/explosive/grenade/incendiary
	name = "M77 HIAM 燃烧手榴弹"
	desc = "高爆燃烧阻行手榴弹。M77 体积小，威力却不容小觑，利用壳内少量炸药散布持久燃烧的 B 型凝固汽油，阻碍敌方机动。设定为 4 秒后引爆。"
	icon_state = "grenade_fire"
	det_time = 40
	item_state = "grenade_fire"
	caliber = "30mm"
	arm_sound = 'sound/weapons/grenade.ogg'
	dangerous = TRUE
	underslug_launchable = TRUE
	dual_purpose = TRUE
	var/flame_level = BURN_TIME_TIER_5 + 5 //Type B standard, 50 base + 5 from chemfire code.
	var/burn_level = BURN_LEVEL_TIER_2
	var/flameshape = FLAMESHAPE_DEFAULT
	var/radius = 2
	var/fire_type = FIRE_VARIANT_TYPE_B //Armor Shredding Greenfire

/obj/item/explosive/grenade/incendiary/prime(mob/living/user)
	set waitfor = 0
	if(fuse_type == IMPACT_FUSE)
		to_chat(user, SPAN_WARNING("这枚手榴弹已设为触发引信！"))
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), cause_data, radius, get_turf(src), flame_level, burn_level, flameshape, null, fire_type)
	playsound(src.loc, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)
	qdel(src)

/obj/item/explosive/grenade/incendiary/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), cause_data, radius, get_turf(src), flame_level, burn_level, flameshape, null, fire_type)
		playsound(src.loc, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)
		qdel(src)

/proc/flame_radius(datum/cause_data/cause_data, radius = 1, turf/T, flame_level = 20, burn_level = 30, flameshape = FLAMESHAPE_DEFAULT, target, fire_type = FIRE_VARIANT_DEFAULT)
	//This proc is used to generate automatically-colored fires from manually adjusted item variables.
	//It parses them as parameters and sets color automatically based on Intensity, then sends an edited reagent to the standard flame code.
	//By default, this generates a napalm fire with a radius of 1, flame_level of 20 per UT (prev 14 as greenfire), burn_level of 30 per UT (prev 15 as greenfire), in a diamond shape.
	if(!istype(T))
		return
	var/datum/reagent/R = new /datum/reagent/napalm/ut()
	if(burn_level >= BURN_LEVEL_TIER_7)
		R = new /datum/reagent/napalm/blue()
	else if(burn_level <= BURN_LEVEL_TIER_2)
		R = new /datum/reagent/napalm/green()

	R.durationfire = flame_level
	R.intensityfire = burn_level
	R.rangefire = radius

	new /obj/flamer_fire(T, cause_data, R, R.rangefire, null, flameshape, target, , , fire_type)

/obj/item/explosive/grenade/incendiary/molotov
	name = "简易燃烧弹"
	desc = "强力的简易燃烧弹，掺有少量火药。廉价、高效，在狭小空间中尤其致命，常见于叛军与恐怖分子手中。引爆延时难以预测，请小心，它可能在你面前炸开。"
	icon_state = "molotov"
	item_state = "molotov"
	caliber = "non-standard"
	arm_sound = 'sound/items/Welder2.ogg'
	underslug_launchable = FALSE
	fire_type = FIRE_VARIANT_DEFAULT

/obj/item/explosive/grenade/incendiary/molotov/New(loc, custom_burn_level)
	det_time = rand(10,40) //Adds some risk to using this thing.
	if(custom_burn_level)
		burn_level = custom_burn_level
	..(loc)

/obj/item/explosive/grenade/incendiary/molotov/prime()
	playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 35, 1, 4)
	..()

/*
//================================================
				Airburst Incendiary Grenades
//================================================
*/
// M74 are the launcher-only variant. Flag with hand_throwable = FALSE.
/obj/item/explosive/grenade/incendiary/airburst
	name = "M74 AGM-I 40mm 手榴弹"
	desc = "M74 空爆榴弹弹药——燃烧型。必须使用榴弹发射器发射，到达目标位置后引爆。在前方小片锥形区域散布持续燃烧的火焰，飞散的扭曲碎片也能引燃物体。"
	icon_state = "grenade_m74_airburst_i"
	item_state = "grenade_m74_airburst_i_active"
	caliber = "40x53mm"
	det_time = 0 // Unused, because we don't use prime.
	hand_throwable = FALSE
	flame_level = 15
	burn_level = 20
	flameshape = FLAMESHAPE_TRIANGLE
	radius = 2
	var/shrapnel_count = 5
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/incendiary

/obj/item/explosive/grenade/incendiary/airburst/prime()

/obj/item/explosive/grenade/incendiary/airburst/launch_impact(atom/hit_atom)
	..()
	var/detonate = TRUE
	var/turf/hit_turf = null
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom))
		hit_turf = hit_atom
		if(hit_turf.density && !rebounding)
			detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		var/angle = dir2angle(last_move_dir)
		var/turf/target = locate(src.loc.x + sin(angle)*radius, src.loc.y + cos(angle)*radius, src.loc.z)
		if(shrapnel_count)
			create_shrapnel(loc, shrapnel_count, last_move_dir , 30 ,shrapnel_type, cause_data, FALSE, 0)
		if(target)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), cause_data, radius, get_turf(src), flame_level, burn_level, flameshape, target)
		else
			//Not stellar, but if we can't find a direction, fall back to HIDP behaviour.
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flame_radius), cause_data, radius, get_turf(src), flame_level, burn_level, FLAMESHAPE_DEFAULT, target)
		playsound(src.loc, 'sound/weapons/gun_flamethrower2.ogg', 35, 1, 4)
		qdel(src)

/*
//================================================
				Smoke Grenades
//================================================
*/

/obj/item/explosive/grenade/smokebomb
	name = "M47 HSDP 烟幕手榴弹"
	desc = "M47 HSDP 是小巧而强力的烟幕手榴弹，基于 M40 HEDP 平台。可由 PN 30mm 下挂榴弹发射器发射并撞击引爆，也可手动拉火投掷，2 秒后引爆。"
	icon_state = "grenade_smoke"
	det_time = 20
	item_state = "grenade_smoke"
	caliber = "30mm"
	underslug_launchable = TRUE
	harmful = FALSE
	antigrief_protection = FALSE
	arm_sound = 'sound/weapons/grenade.ogg'
	var/datum/effect_system/smoke_spread/bad/smoke
	var/smoke_type = /datum/effect_system/smoke_spread/bad
	var/smoke_radius = 3
	var/smoke_duration = 40
	dual_purpose = TRUE
	spent_case = /obj/item/trash/grenade

/obj/item/explosive/grenade/smokebomb/New()
	..()
	smoke = new smoke_type(src)
	smoke.attach(src)

/obj/item/explosive/grenade/smokebomb/Destroy()
	QDEL_NULL(smoke)
	return ..()

/obj/item/explosive/grenade/smokebomb/prime(mob/living/user)
	set waitfor = 0
	if(fuse_type == IMPACT_FUSE)
		to_chat(user, SPAN_WARNING("这枚手榴弹已设为触发引信！"))
		return
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	smoke.set_up(smoke_radius, 0, get_turf(src), null, smoke_duration)
	smoke.start()
	new spent_case(get_turf(src))
	qdel(src)

/obj/item/explosive/grenade/smokebomb/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
		smoke.set_up(smoke_radius, 0, get_turf(src), null, smoke_duration)
		smoke.start()
		if(spent_case)
			new spent_case(get_turf(src))
		qdel(src)

/obj/item/explosive/grenade/smokebomb/green
	name = "M47-G HSDP 烟幕手榴弹"
	desc = "M47 HSDP 是小巧而强力的烟幕手榴弹，基于 M40 HEDP 平台。可由 PN 30mm 下挂榴弹发射器发射并撞击引爆，也可手动拉火投掷，2 秒后引爆。G 型引爆后释放绿色烟幕。"
	icon_state = "grenade_smoke_green"
	smoke_type = /datum/effect_system/smoke_spread/bad/green
	smoke_radius = 2

/obj/item/explosive/grenade/smokebomb/red
	name = "M47-R HSDP 烟幕手榴弹"
	desc = "M47 HSDP 是小巧而强力的烟幕手榴弹，基于 M40 HEDP 平台。可由 PN 30mm 下挂榴弹发射器发射并撞击引爆，也可手动拉火投掷，2 秒后引爆。R 型引爆后释放红色烟幕。"
	icon_state = "grenade_smoke_red"
	smoke_type = /datum/effect_system/smoke_spread/bad/red
	smoke_radius = 2

/obj/item/explosive/grenade/smokebomb/upp
	name = "RDG-17 烟雾手榴弹"
	desc = "17 型烟雾手榴弹。设计简单、古老又高效，几乎各地都在为进步人民联盟武装集体生产它。"
	icon_state = "grenade_upp_smoke"
	caliber = "non-standard"
	arm_sound = 'sound/weapons/pinpull.ogg'

/obj/item/explosive/grenade/phosphorus
	name = "M60 WPSI 手榴弹"
	desc = "M60 WPSI 是小巧而强力的化合物手榴弹，以白色顶盖识别。既可制造烟幕，也可用作燃烧装置。引信为 2 秒。"
	icon_state = "grenade_phos"
	det_time = 20
	item_state = "grenade_training"
	caliber = "30mm"
	underslug_launchable = TRUE
	dual_purpose = TRUE
	arm_sound = 'sound/weapons/grenade.ogg'
	var/shrapnel_count = 16
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/incendiary/light
	var/datum/effect_system/smoke_spread/phosphorus/smoke
	dangerous = TRUE
	harmful = TRUE
	var/smoke_radius = 3

/obj/item/explosive/grenade/phosphorus/Destroy()
	QDEL_NULL(smoke)
	return ..()

/obj/item/explosive/grenade/phosphorus/Initialize()
	. = ..()
	smoke = new /datum/effect_system/smoke_spread/phosphorus
	smoke.attach(src)

/obj/item/explosive/grenade/phosphorus/prime(mob/living/user)
	set waitfor = 0
	if(fuse_type == IMPACT_FUSE)
		to_chat(user, SPAN_WARNING("这枚手榴弹已设为触发引信！"))
		return
	playsound(src.loc, 'sound/effects/wp_smoke.ogg', 25, 1, 5)
	smoke.set_up(smoke_radius, 0, get_turf(src), null, 25)
	smoke.start()
	create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
	qdel(src)

/obj/item/explosive/grenade/phosphorus/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
		smoke.set_up(smoke_radius, 0, get_turf(src), null, 25)
		smoke.start()
		create_shrapnel(loc, shrapnel_count, , ,shrapnel_type, cause_data)
		qdel(src)

/obj/item/explosive/grenade/phosphorus/upp
	name = "\improper 8 式白磷手榴弹"
	desc = "进步人民联盟部队使用的致命气体手榴弹，用于向目标泼洒白磷。拔出保险销两秒后爆炸。"
	underslug_launchable = FALSE
	dual_purpose = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	icon_state = "grenade_upp_wp"
	item_state = "grenade_upp_wp"
	caliber = "non-standard"

/obj/item/explosive/grenade/phosphorus/clf
	name = "简易磷弹"
	desc = "简易气体手榴弹改型，用于向目标泼洒白磷。拔销后 2 秒爆炸。"
	underslug_launchable = FALSE
	dual_purpose = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	icon_state = "grenade_phos_clf"
	item_state = "grenade_phos_clf"
	caliber = "non-standard"

/*
//================================================
				Sonic Electronic Ball Breakers
//================================================
*/

/obj/item/explosive/grenade/sebb
	name = "G2 电击手榴弹"
	desc = "G2 电击手榴弹，由阿玛特战场系统制造。一系列事故中，强劲的 1.2 gV 声波载荷造成了某些部位……破裂，因此它有时被称作“声电碎蛋器”。此武器还具备跳雷模式，部署后会启动小型钻头自行埋入地下。将它放在脚边后离开即可。"
	icon_state = "grenade_sebb"
	item_state = "grenade_sebb"
	caliber = "non-standard"
	det_time = 3 SECONDS
	underslug_launchable = TRUE
	/// Maximum range of effect
	var/range = 5
	/// Maximum possible damage before falloff.
	var/damage = 110
	/// Factor to mutiply the effect range has on damage.
	var/falloff_dam_reduction_mult = 20
	/// Post falloff calc damage is divided by this to get xeno slowdown
	var/xeno_slowdown_numerator = 12
	/// Post falloff calc damage is multipled by this to get human stamina damage
	var/human_stam_dam_factor = 0.9

/obj/item/explosive/grenade/sebb/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("在脚边安放即可切换为地雷模式。")

/obj/item/explosive/grenade/sebb/afterattack(atom/target, mob/user, proximity)
	var/turf/user_turf = get_turf(user)
	if(active)
		return

	if(!isturf(target))
		return

	if(user.action_busy)
		return

	if(target != get_turf(user))
		return

	if(locate(/obj/item/explosive/mine) in get_turf(src))
		to_chat(user, SPAN_WARNING("这里已经有一枚地雷！"))
		return

	if(antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
		to_chat(user, SPAN_WARNING("[name]的安全区防误用装置阻止了你安放它！"))
		msg_admin_niche("[key_name(user)] attempted to plant \a [name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		if(!human.allow_gun_usage)
			to_chat(user, SPAN_WARNING("你的程序禁止使用它！"))
			return

	if(user_turf && (user_turf.density || locate(/obj/structure/fence) in user_turf))
		to_chat(user, SPAN_WARNING("你无法在这里布雷。"))
		return

	if(Adjacent(/obj/item/explosive/mine)) // bit more strict on this than normal mines
		to_chat(user, SPAN_WARNING("离另一枚地雷太近了！换个不那么显眼的位置。"))
		return

	user.visible_message(SPAN_NOTICE("[user]开始部署[src]。"),
		SPAN_NOTICE("你将[src]切换为地雷模式，开始安放……"))
	playsound(user.loc, 'sound/effects/thud.ogg', 40)
	if(!do_after(user, 5 SECONDS * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		to_chat(user, SPAN_NOTICE("你停止安放。"))
		return

	user.visible_message(SPAN_NOTICE("[user]完成了[src]的部署。"),
		SPAN_NOTICE("你完成了[src]的部署。"))
	var/obj/item/explosive/mine/sebb/planted = new /obj/item/explosive/mine/sebb(get_turf(user))
	planted.activate_sensors()
	planted.iff_signal = user.faction // assuring IFF is set
	planted.pixel_x += rand(-5, 5)
	planted.pixel_y += rand(-5, 5)
	qdel(src)

/obj/item/explosive/grenade/sebb/activate()
	..()
	var/beeplen = 6 // Actual length of the sound rounded up to nearest decisecond
	var/soundtime = det_time - beeplen
	if(det_time < beeplen) // just play sound if detonation shorter than the sound
		playsound(loc, 'sound/effects/sebb_explode.ogg', 90, 0, 10)
	else
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), loc, 'sound/effects/sebb_beep.ogg', 60, 0, 10), soundtime)

/obj/item/explosive/grenade/sebb/prime()
	var/datum/effect_system/spark_spread/sparka = new
	var/turf/sebb_turf = get_turf(src)
	var/list/full_range = oview(range, src) // Fill a list of stuff in the range so we won't have to spam oview
	new /obj/effect/overlay/temp/sebb(sebb_turf)

	playsound(src.loc, 'sound/effects/sebb_explode.ogg', 90, 0, 10)

	for(var/obj/structure/machinery/defenses/sentry/sentry_stun in full_range)
		sentry_stun.sentry_range = 0 // Temporarily "disable" the sentry by killing its range then setting it back.
		new /obj/effect/overlay/temp/elec_arc(get_turf(sentry_stun))  // sprites are meh but we need visual indication that the sentry was messed up
		addtimer(VARSET_CALLBACK(sentry_stun, sentry_range, initial(sentry_stun.sentry_range)), 5 SECONDS) // assure to set it back
		sentry_stun.visible_message(SPAN_DANGER("[src]遭到电击，屏幕剧烈闪烁！"))
		sentry_stun.visible_message(SPAN_DANGER("[src]说道：“错误：电压严重波动，火控系统正在重置！”"))
		sparka.set_up(1, 1, sentry_stun)
		sparka.start()

	for(var/turf/turf in full_range)
		if(prob(8))
			var/datum/effect_system/spark_spread/sparkTurf = new //using a different spike system because the spark system doesn't like when you reuse it for differant things
			sparkTurf.set_up(1, 1, turf)
			sparkTurf.start()
		if(prob(10))
			new /obj/effect/overlay/temp/emp_sparks(turf)

	for(var/mob/living/carbon/mob in full_range) // no legacy mob support

		var/mob_dist = get_dist(src, mob) // Distance from mob

		/**
		 * Damage equation: damage - (mob distance * falloff_dam_reduction_mult)
		 * Example: A marine is 3 tiles out, the distance (3) is multiplied by falloff_dam_reduction_mult to get falloff.
		 * The raw damage is minused by falloff to get actual damage
		*/

		var/falloff = mob_dist * falloff_dam_reduction_mult
		var/damage_applied = damage - falloff // Final damage applied after falloff calc
		sparka.set_up(1, 1, mob)
		sparka.start()
		shake_camera(mob, 1, 1)
		if(ishuman(mob))
			var/mob/living/carbon/human/shocked_human = mob
			if(isspeciessynth(shocked_human)) // Massive overvoltage to ungrounded robots is pretty bad
				shocked_human.Stun(1 + (damage_applied/40))
				damage_applied *= 1.5
				new /obj/effect/overlay/temp/elec_arc(get_turf(shocked_human))
				to_chat(mob, SPAN_HIGHDANGER("主总线过压[damage_applied*2]伏，你的所有系统都陷入瘫痪。"))
				mob.visible_message(SPAN_WARNING("[mob]被电击得浑身僵直。"))
			shocked_human.take_overall_armored_damage(damage_applied, ARMOR_ENERGY, BURN, 90) // 90% chance to be on additional limbs
			shocked_human.make_dizzy(damage_applied)
			mob.apply_stamina_damage(damage_applied*human_stam_dam_factor) // Stamina damage
			shocked_human.emote("pain")
		else //nonhuman damage + slow
			mob.apply_damage(damage_applied, BURN)
			if((mob_dist < (range-3))) // 2 tiles around small superslow
				mob.Superslow(2)
			mob.Slow(damage_applied/11)

		if(mob_dist < 1) // Range based stuff, standing ontop of the equivalent of a canned lighting bolt should mess you up.
			mob.Superslow(3) // Note that humans will likely be in stamcrit so it's always worse for them when ontop of it and we can just balancing it on xenos.
			mob.eye_blurry = damage_applied/4
			mob.Daze(1)
		else if((mob_dist < (range-1)) && (mob.mob_size < MOB_SIZE_XENO_VERY_SMALL)) // Flicker stun humans that are closer to the grenade and larvas too.
			mob.apply_effect(1 + (damage_applied/100),WEAKEN) // 1 + damage/40
			mob.eye_blurry = damage_applied/8

		else
			to_chat(mob, SPAN_HIGHDANGER("强烈电流贯穿全身，让你彻底僵住！"))


		new /obj/effect/overlay/temp/emp_sparks(mob)
		mob.make_jittery(damage_applied*2)
	empulse(src, 1, 2) // mini EMP
	qdel(src)


/obj/item/explosive/grenade/sebb/primed
	desc = "一枚 G2 电击手榴弹，看起来正怒火中烧！糟了！"
	det_time = 7 // 0.7 seconds to blow up. We want them to get caught if they go through.

/obj/item/explosive/grenade/sebb/primed/Initialize()
	. = ..()
	src.visible_message(SPAN_HIGHDANGER("[src]从地里弹了出来！"))
	activate()

/obj/effect/overlay/temp/sebb
	icon = 'icons/effects/sebb.dmi'
	icon_state = "sebb_explode"
	layer = ABOVE_LIGHTING_PLANE
	pixel_x = -175 // We need these offsets to force center the sprite because BYOND is dumb
	pixel_y = -175
	appearance_flags = RESET_COLOR

/*
//================================================
			Nerve Gas Grenades
//================================================
*/
/obj/item/explosive/grenade/nerve_gas
	name = "\improper CN20 罐装手榴弹"
	desc = "装有致命神经毒气的罐装手榴弹，四秒后引爆。"
	icon_state = "flashbang2"//temp icon
	det_time = 40
	item_state = "grenade_phos_clf"//temp icon
	caliber = "non-standard"
	underslug_launchable = FALSE
	harmful = TRUE
	antigrief_protection = TRUE
	arm_sound = 'sound/weapons/pinpull.ogg'
	/// The nerve gas datum
	var/datum/effect_system/smoke_spread/cn20/nerve_gas
	/// The typepath of the nerve gas
	var/nerve_gas_type = /datum/effect_system/smoke_spread/cn20
	/// The radius the gas will reach
	var/nerve_gas_radius = 4
	spent_case = /obj/item/trash/grenade/gas

/obj/item/explosive/grenade/nerve_gas/Initialize(mapload, ...)
	. = ..()
	nerve_gas = new nerve_gas_type
	nerve_gas.attach(src)

/obj/item/explosive/grenade/nerve_gas/Destroy()
	QDEL_NULL(nerve_gas)
	return ..()

/obj/item/explosive/grenade/nerve_gas/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	nerve_gas.set_up(nerve_gas_radius, 0, get_turf(src), null, 20)
	nerve_gas.start()
	new spent_case(get_turf(src))
	qdel(src)

/obj/item/explosive/grenade/nerve_gas/xeno
	name = "\improper CN20-X 罐装手榴弹"
	nerve_gas_type = /datum/effect_system/smoke_spread/cn20/xeno

/*
//================================================
			LSD Gas Grenades
//================================================
*/
/obj/item/explosive/grenade/LSD
	name = "\improper ALD-91 罐装手榴弹"
	desc = "装有非致命 LSD 气体的罐装手榴弹，四秒后引爆。"
	icon_state = "flashbang2"//temp icon
	det_time = 40
	item_state = "grenade_phos_clf"//temp icon
	caliber = "non-standard"
	underslug_launchable = FALSE
	harmful = TRUE
	antigrief_protection = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	var/datum/effect_system/smoke_spread/LSD/LSD_gas
	var/LSD_gas_radius = 4
	spent_case = /obj/item/trash/grenade/gas

/obj/item/explosive/grenade/LSD/Initialize()
	. = ..() //if it ain't broke don't fix it
	LSD_gas = new /datum/effect_system/smoke_spread/LSD
	LSD_gas.attach(src)

/obj/item/explosive/grenade/LSD/Destroy()
	QDEL_NULL(LSD_gas)
	return ..()

/obj/item/explosive/grenade/LSD/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	LSD_gas.set_up(LSD_gas_radius, 0, get_turf(src), null, 20)
	LSD_gas.start()
	new spent_case(get_turf(src))
	qdel(src)

/*
//================================================
			Tear Gas Grenades
//================================================
*/
/obj/item/explosive/grenade/tear
	name = "催泪瓦斯手榴弹"
	desc = "装有非致命催泪瓦斯的罐式手榴弹，设定为 4 秒后引爆。"
	icon_state = "flashbang2"//temp icon
	det_time = 40
	item_state = "grenade_phos_clf"//temp icon
	caliber = "non-standard"
	underslug_launchable = FALSE
	harmful = TRUE
	antigrief_protection = FALSE
	arm_sound = 'sound/weapons/pinpull.ogg'
	var/datum/effect_system/smoke_spread/tear/tear_gas
	var/tear_gas_radius = 3
	spent_case = /obj/item/trash/grenade/gas

/obj/item/explosive/grenade/tear/Initialize()
	. = ..() //if it ain't broke don't fix it
	tear_gas = new /datum/effect_system/smoke_spread/tear
	tear_gas.attach(src)

/obj/item/explosive/grenade/tear/Destroy()
	QDEL_NULL(tear_gas)
	return ..()

/obj/item/explosive/grenade/tear/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	tear_gas.set_up(tear_gas_radius, 0, get_turf(src), null, 90)
	tear_gas.start()
	new spent_case(get_turf(src))
	qdel(src)

/obj/item/explosive/grenade/tear/marine
	name = "M66 催泪瓦斯手榴弹"
	desc = "用于非致命防暴的催泪瓦斯手榴弹。请佩戴合适的防毒装备。"
	icon_state = "grenade_gas"
	det_time = 40
	item_state = "grenade_phos"//temp icon
	caliber = "30mm"
	underslug_launchable = TRUE
	tear_gas_radius = 4
	arm_sound = 'sound/weapons/grenade.ogg'
	spent_case = /obj/item/trash/grenade/gas/marine

/*
//================================================
			Airburst Smoke Grenades
//================================================
*/

/obj/item/explosive/grenade/smokebomb/airburst
	name = "M74 AGM-S 40mm 手榴弹"
	desc = "M74 空爆榴弹弹药——烟幕型。必须使用榴弹发射器发射，到达目标位置后引爆。引爆时会瞬间混合弹体内的多种化学物质，形成烟幕。"
	icon_state = "grenade_m74_airburst_s"
	item_state = "grenade_m74_airburst_s_active"
	det_time = 0 // Unused, because we don't use prime.
	hand_throwable = FALSE
	smoke_radius = 2
	spent_case = null

/obj/item/explosive/grenade/smokebomb/airburst/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/bad
	smoke.attach(src)


/obj/item/explosive/grenade/smokebomb/airburst/prime()
// We don't prime, we use launch_impact.

/*
//================================================
				Baton Slugs
//================================================
*/

/obj/item/explosive/grenade/slug
	name = "独头弹弹"
	desc = "它其实不会爆炸。真稀奇。"
	icon_state = "chemg"
	hand_throwable = FALSE
	var/impact_damage = 10
	var/impact_sound = 'sound/weapons/baton_slug_impact.ogg'
	var/slowdown_time = 2
	var/knockout_time = 0.1
	var/dazed_time = 0.5
	var/inactive_icon = "chemg"
	var/throw_max = 3 //What is the max range the baton can push/fling someone
	var/throw_min = 1 //what is the min range the baton can push/fling
	var/ram_distance = 2 //How far can the baton bounce after impacting a mob, Also how many times it can bounce
	has_arm_sound = FALSE
	throwforce = 10
	antigrief_protection = FALSE

/obj/item/explosive/grenade/slug/prime()
	active = 0
	overlays.Cut()
	icon_state = initial(icon_state)
	w_class = initial(w_class)
	throwforce = initial(throwforce)
	throw_max = initial(throw_max)
	throw_min = initial(throw_min)
	ram_distance = initial(ram_distance)

/obj/item/explosive/grenade/slug/launch_impact(atom/hit_atom)
	if(!active)
		return
	if(ismob(hit_atom))
		impact_mob(hit_atom)
		ram_distance -- //for max pinballing.
	icon_state = inactive_icon

/obj/item/explosive/grenade/slug/proc/impact_mob(mob/living/smacked)
	var/direction = Get_Angle(src, smacked)
	var/target_turf = get_angle_target_turf(src,direction, throw_max)
	var/fling = rand(throw_min, throw_max) //WEEEEEEEEEEEEEEEEEEEE What is going to be put into throw_atom
	var/random_tile = 0 //random tile for bounce

	playsound(smacked.loc, impact_sound, 75, 1)
	smacked.apply_damage(impact_damage, BRUTE)
	smacked.attack_log += "\[[time_stamp()]\] [src], fired by [fingerprintslast], struck [key_name(smacked)]."

	random_tile = get_random_turf_in_range(src,ram_distance,ram_distance) //getting random tile for bounce
	src.throw_atom(random_tile,ram_distance,SPEED_FAST,src,TRUE,NORMAL_LAUNCH,NO_FLAGS) //time for a little trolling

	if(isyautja(smacked)|| issynth(smacked))
		smacked.apply_effect(slowdown_time * 0.5, SLOW)
		smacked.apply_effect(dazed_time * 0.5, DAZE)

	if(smacked.mob_size >= MOB_SIZE_BIG)//big xenos not KO'ed
		smacked.apply_effect(slowdown_time * 1.2, SLOW)//They are slowed more :trol:
		smacked.apply_effect(dazed_time * 1.2, DAZE)
		return

	smacked.apply_effect(knockout_time, WEAKEN)//but little xenos and humans are
	smacked.throw_atom(target_turf, fling, SPEED_AVERAGE, smacked, TRUE)
	smacked.apply_effect(slowdown_time, SLOW)
	smacked.apply_effect(dazed_time, DAZE)
	smacked.visible_message(SPAN_NOTICE("[smacked]被[src]击中，它随即撞碎。"),
		SPAN_NOTICE("[src]击中你后碎裂！"))
	qdel(src)

/obj/item/explosive/grenade/slug/baton
	name = "M230 LLRB 手榴弹"
	desc = "M230 低致命弹药很少配发给殖民地陆战队，主要用于应对民众骚乱。射中特别脆弱的组织时仍可能致命。"
	icon_state = "grenade_ltl"
	item_state = "baton_slug"
	inactive_icon = "grenade_ltl"
	caliber = "30mm"
	antigrief_protection = FALSE
	underslug_launchable = TRUE
	hand_throwable = FALSE
	impact_damage = 15
	slowdown_time = 2
	knockout_time = 0.8
	dazed_time = 1.7

/obj/item/explosive/grenade/slug/baton/Initialize()
	. = ..()
	setDir(NORTH) //so they're oriented properly in our inventory


/*
//================================================
					Other
//================================================
*/

/obj/item/explosive/grenade/high_explosive/training
	name = "M07 训练手榴弹"
	desc = "用于训练的无害、可重复使用版 M40 HEDP。可装入 M92 发射器，也可手投。"
	icon_state = "grenade_training"
	item_state = "grenade_training"
	dangerous = TRUE
	harmful = FALSE
	antigrief_protection = FALSE
	explosion_power = 0	//SOMEHOW, MARINES FOUND A WAY TO KILL ONE ANOTHER WITH THESE
	explosion_falloff = 0

/obj/item/explosive/grenade/high_explosive/training/prime()
	spawn(0)
		playsound(loc, 'sound/items/detector.ogg', 80, 0, 7)
		active = 0 //so we can reuse it
		overlays.Cut()
		icon_state = initial(icon_state)
		det_time = initial(det_time) //these can be modified when fired by UGL
		throw_range = initial(throw_range)
		w_class = initial(w_class)

/obj/item/explosive/grenade/high_explosive/training/flamer_fire_act()
	return

/obj/item/explosive/grenade/high_explosive/training/launch_impact(atom/hit_atom)
	if(!active)
		return
	icon_state = initial(icon_state)

/obj/item/explosive/grenade/high_explosive/m15/rubber
	name = "M15 橡胶弹丸手榴弹"
	desc = "用于防暴和战斗演习的低伤害版 M15 手榴弹。"
	icon_state = "rubber_grenade"
	item_state = "rubber_grenade"
	explosion_power = 0
	shrapnel_type = /datum/ammo/bullet/shrapnel/rubber
	antigrief_protection = FALSE

/// Baton slugs
/obj/item/explosive/grenade/baton
	name = "\improper HIRR 橡胶独头弹"
	desc = "与 M15 橡胶弹丸同源的 HIRR 橡胶独头弹，曾因脱壳弹壳内推进剂装填过量，被军方及民警召回。如今仍用于对付人类，有时也对付非人类部队的低致命性交战。它在大角星冲突期间极受欢迎，因为冲击力能可靠地将抵抗军的肋骨打进肺部，使其失去战斗力。"
	icon_state = "grenade_ltl"
	item_state = "rubber_grenade"
	hand_throwable = FALSE
	antigrief_protection = FALSE


/obj/item/explosive/grenade/baton/flamer_fire_act()
	return

/obj/item/explosive/grenade/slug/baton/m79
	name = "\improper LTL 40 毫米榴弹"
	desc = "一枚低致命性 40 毫米橡胶弹。"
	icon_state = "grenade_40mm_ltl"
	item_state = "rubber_grenade"

/obj/item/explosive/grenade/high_explosive/holy_hand_grenade
	AUTOWIKI_SKIP(TRUE)

	name = "\improper 安提阿圣手雷"
	desc = "圣阿提拉高举手雷，说：“主啊，求你赐福这枚圣手雷，以你的仁慈，让它将敌人炸成碎片。”主露出笑容，众人便享用羊羔、树懒、鲤鱼和凤尾鱼……主又说：“先拔出神圣保险销，再数到三，不多不少。你当数的数字是三，数数的终点也当是三。不可数四，也不可只数二，除非随后数到三。五绝对不行。到第三个数字，也就是三时，就把你的安提阿圣手雷投向敌人；他们在我眼中作恶，必将一命呜呼。”"
	icon_state = "grenade_antioch"
	item_state = "grenade_antioch"
	caliber = "non-standard"
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	underslug_launchable = FALSE
	explosion_power = 300
	det_time = 50
	unacidable = TRUE
	arm_sound = 'sound/voice/holy_chorus.ogg'//https://www.youtube.com/watch?v=hNV5sPZFuGg
	falloff_mode = EXPLOSION_FALLOFF_SHAPE_LINEAR

/obj/item/explosive/grenade/metal_foam
	name = "M42 MFHS 手榴弹"
	desc = "金属泡沫船体密封手榴弹，原用于应急维修，后来在战场上也找到了其他实用用途。采用与 M40 HEDP 相同的弹体，装有 2 秒引信。"
	icon_state = "grenade_metal_foam"
	item_state = "grenade_metal_foam"
	caliber = "30mm"
	det_time = 20
	underslug_launchable = TRUE
	harmful = FALSE
	arm_sound = 'sound/weapons/grenade.ogg'
	var/foam_metal_type = FOAM_METAL_TYPE_IRON

/obj/item/explosive/grenade/metal_foam/prime()
	var/datum/effect_system/foam_spread/s = new()
	s.set_up(12, get_turf(src), metal_foam = foam_metal_type) //12 amt = 2 tiles radius (5 tile length diamond)
	s.start()
	qdel(src)

// abstract grenades used for hijack explosions

/obj/item/explosive/grenade/high_explosive/bursting_pipe
	name = "爆裂管"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/item/explosive/grenade/incendiary/bursting_pipe
	name = "爆裂管"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	flame_level = BURN_TIME_TIER_3
	burn_level = BURN_LEVEL_TIER_3
	radius = 2
	fire_type = FIRE_VARIANT_DEFAULT

//Royal marine grenades

/obj/item/explosive/grenade/high_explosive/rmc
	name = "R2175/A HEDP 手榴弹"
	desc = "高爆两用手榴弹，体积小，威力却不容小觑，最近才加入 RMC 的武器库。"
	icon_state = "rmc_grenade"
	item_state = "grenade_hedp"
	caliber = "30mm"
	explosion_power = 130
	explosion_falloff = 30

/obj/item/explosive/grenade/incendiary/rmc
	name = "R2175/B HIDP 手榴弹"
	desc = "R2175/B HIDP 是小巧而强力的燃烧手榴弹，以迅速猛烈的火焰清理区域。设定为 4 秒后引爆。"
	icon_state = "rmc_grenade_fire"
	item_state = "grenade_fire"
	caliber = "30mm"
	flame_level = BURN_TIME_TIER_1
	burn_level = BURN_LEVEL_TIER_8
	radius = 3
	fire_type = FIRE_VARIANT_DEFAULT

/obj/item/explosive/grenade/nerve_gas/xeno/rmc
	name = "\improper R2175/CN20 手榴弹"
	desc = "内含一小瓶致命神经毒气的小型手榴弹，通常能让目标失能足够久，供皇家陆战突击队解决他们。你几乎能在脑海里听见教官大吼，似乎提到了防毒面具。引爆时间为 3.5 秒。"
	icon_state = "rmc_grenade_gas"
	item_state = "grenade_smoke"
	caliber = "30mm"
	det_time = 35
	item_state = "grenade_smoke"
	arm_sound = 'sound/weapons/grenade.ogg'
	underslug_launchable = TRUE
	dual_purpose = TRUE
	spent_case = /obj/item/trash/grenade/gas/rmc

/obj/item/explosive/grenade/nerve_gas/xeno/rmc/prime()
	playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
	nerve_gas.set_up(nerve_gas_radius, 0, get_turf(src), null, 12)
	nerve_gas.start()
	new spent_case(get_turf(src))
	qdel(src)

/obj/item/explosive/grenade/nerve_gas/xeno/rmc/launch_impact(atom/hit_atom)
	if(fuse_type != IMPACT_FUSE)
		return
	var/detonate = TRUE
	if(isobj(hit_atom) && !rebounding)
		detonate = FALSE
	if(isturf(hit_atom) && hit_atom.density && !rebounding)
		detonate = FALSE
	if(active && detonate) // Active, and we reached our destination.
		playsound(src.loc, 'sound/effects/smoke.ogg', 25, 1, 4)
		nerve_gas.set_up(nerve_gas_radius, 0, get_turf(src), null, 12)
		nerve_gas.start()
		new spent_case(get_turf(src))
		qdel(src)

// RMC 20mm baby-nades

/obj/item/explosive/grenade/high_explosive/impact/rmc20mm
	name = "L103A1 20mm 高爆榴弹"
	desc = "撞击后爆炸的 20mm 榴弹，威力弱于全尺寸榴弹。"
	icon_state = "grenade_20mm_he"
	item_state = "grenade_hedp"
	caliber = "20mm"
	explosion_power = 80
	shrapnel_count = 8

/obj/item/explosive/grenade/high_explosive/airburst/rmc20mm
	name = "L104A1 20mm 破片手榴弹"
	desc = "撞击后爆散弹片的 20mm 榴弹。"
	icon_state = "grenade_20mm_frag"
	item_state = "grenade_hefa"
	caliber = "20mm"
	shrapnel_type = /datum/ammo/bullet/shrapnel/heavy
	direct_hit_shrapnel = 12
	explosion_power = 30
	shrapnel_count = 36
	dispersion_angle = 45

/obj/item/explosive/grenade/incendiary/airburst/rmc20mm
	name = "L103A1/I 20mm 燃烧手榴弹"
	desc = "撞击后爆散燃烧弹片，并形成燃烧化合物液池的 20mm 榴弹。"
	icon_state = "grenade_20mm_inc"
	item_state = "grenade_fire"
	caliber = "20mm"
	flame_level = BURN_TIME_TIER_1
	burn_level = BURN_LEVEL_TIER_8
	flameshape = FLAMESHAPE_IRREGULAR
	radius = 2
	shrapnel_count = 12
	shrapnel_type = /datum/ammo/bullet/shrapnel/incendiary/heavy

/obj/item/explosive/grenade/smokebomb/airburst/rmc20mm
	name = "L101A2 20mm 神经毒剂榴弹"
	desc = "撞击后释放大量神经毒气的 20mm 榴弹。"
	icon_state = "grenade_20mm_gas"
	item_state = "grenade_smoke"
	caliber = "20mm"
	spent_case = null
	smoke_radius = 3
	smoke_duration = 12

/obj/item/explosive/grenade/smokebomb/airburst/rmc20mm/New()
	..()
	smoke = new /datum/effect_system/smoke_spread/cn20/xeno
	smoke.attach(src)

/obj/item/explosive/grenade/high_explosive/impact/rmc20mm/holo
	name = "L104A1/H 20mm 全息标记榴弹"
	desc = "撞击后爆散弹片的 20mm 榴弹。这一型号的弹片会将化合物洒在目标上，帮助传感器捕获目标。"
	icon_state = "grenade_20mm_holo"
	item_state = "grenade_phos"
	caliber = "20mm"
	explosion_power = 10
	shrapnel_count = 32
	shrapnel_type = /datum/ammo/bullet/shrapnel/hornet_rounds/rmc

/obj/item/explosive/grenade/high_explosive/impact/heap/rmc20mm
	name = "L108A1 HESH 手榴弹"
	desc = "强力的 20mm 高爆碎甲榴弹，撞击后爆炸。"
	icon_state = "grenade_20mm_squash"
	item_state = "grenade_training"
	caliber = "20mm"
	explosion_power = 160
