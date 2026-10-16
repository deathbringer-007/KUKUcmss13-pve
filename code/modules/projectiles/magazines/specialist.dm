//-------------------------------------------------------
//SNIPER RIFLES
//Keyword rifles. They are subtype of rifles, but still contained here as a specialist weapon.

/obj/item/ammo_magazine/sniper
	name = "\improper M42A精确射手弹匣（10x28mm无壳弹）"
	desc = "装有M252高爆穿甲比赛级10x28mm弹药的弹匣。瞄准射击可造成显著伤害。"
	caliber = "10x28mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m42c" //PLACEHOLDER
	w_class = SIZE_MEDIUM
	max_rounds = 15
	default_ammo = /datum/ammo/bullet/rifle/heavy/heap/sniper
	gun_type = /obj/item/weapon/gun/rifle/sniper/M42A
	ammo_band_icon = "+m42c_band"
	ammo_band_icon_empty = "+m42c_band_e"

/obj/item/ammo_magazine/sniper/basic
	name = "\improper M42A弹匣（10x28mm）"
	desc = "装有M250型10x28mm弹药的弹匣。效果虽不及比赛级弹药，仍有相当杀伤力。瞄准射击会使目标短暂失明，并加剧燃烧。"
	default_ammo = /datum/ammo/bullet/rifle/heavy
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/sniper/incendiary
	name = "\improper M42A燃烧弹匣（10x28mm）"
	desc = "装有M254燃烧比赛级10x28mm弹药的弹匣。瞄准射击会使目标短暂失明，并加剧燃烧。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/incendiary
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/sniper/flak
	name = "\improper M42A破片弹匣（10x28mm）"
	desc = "装有M257高爆破片比赛级10x28mm弹药的弹匣。瞄准射击会使目标暂时减速，并尽量减轻反冲。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/flak
	ammo_band_color = AMMO_BAND_COLOR_IMPACT

//XM43E1 Magazine
/obj/item/ammo_magazine/sniper/anti_materiel
	name = "\improper XM43E1精确射手弹匣（10x99mm）"
	desc = "装有10x99mm无壳反器材弹的弹匣，能够穿透大多数步兵级装备。视命中物体而定，穿透后甚至可能仍有足够能量伤及目标后方的物体。"
	max_rounds = 8
	caliber = "10x99mm"
	default_ammo = /datum/ammo/bullet/sniper/anti_materiel
	gun_type = /obj/item/weapon/gun/rifle/sniper/XM43E1

//M42C magazine

/obj/item/ammo_magazine/sniper/elite
	name = "\improper M42C精确射手弹匣（10x28mm）"
	desc = "装有M252高爆穿甲比赛级10x28mm弹药的弹匣。瞄准射击可造成显著伤害。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/heap/sniper
	gun_type = /obj/item/weapon/gun/rifle/sniper/elite
	caliber = "10x28mm"
	icon_state = "m42c"
	max_rounds = 6

/obj/item/ammo_magazine/sniper/elite/basic
	name = "\improper M42C弹匣（10x28mm）"
	desc = "装有M250型10x28mm弹药的弹匣。效果虽不及比赛级弹药，仍有相当杀伤力。"
	default_ammo = /datum/ammo/bullet/rifle/heavy
	gun_type = /obj/item/weapon/gun/rifle/sniper/elite
	caliber = "10x28mm"
	icon_state = "m42c"
	max_rounds = 6
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

/obj/item/ammo_magazine/sniper/elite/incin
	name = "\improper M42C燃烧弹匣（10x28mm）"
	desc = "装有M254燃烧比赛级10x28mm弹药的弹匣。瞄准射击会使目标短暂失明，并加剧燃烧。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/incendiary
	gun_type = /obj/item/weapon/gun/rifle/sniper/elite
	caliber = "10x28mm"
	icon_state = "m42c"
	max_rounds = 6
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/sniper/elite/flak
	name = "\improper M42C破片弹匣（10x28mm）"
	desc = "装有M257高爆破片比赛级10x28mm弹药的弹匣。瞄准射击会使目标暂时减速，并尽量减轻反冲。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/flak
	gun_type = /obj/item/weapon/gun/rifle/sniper/elite
	caliber = "10x28mm"
	icon_state = "m42c"
	max_rounds = 6
	ammo_band_color = AMMO_BAND_COLOR_IMPACT

/obj/item/ammo_magazine/sniper/elite/overkill
	name = "\improper M42C超音速弹匣（10x28mm）"
	desc = "装有M252A1高爆穿甲超音速比赛级10x28mm弹药的弹匣，能够穿透大多数步兵级装备。视命中物体而定，穿透后甚至可能仍有足够能量伤及目标后方的物体。"
	default_ammo = /datum/ammo/bullet/sniper/elite
	gun_type = /obj/item/weapon/gun/rifle/sniper/elite
	caliber = "10x28mm"
	icon_state = "m42c"
	max_rounds = 6
	ammo_band_color = AMMO_BAND_COLOR_RUBBER

//Type 88 //Based on the actual Dragunov designated marksman rifle.

/obj/item/ammo_magazine/sniper/svd
	name = "\improper 88式弹匣（7.62x54mmR）"
	desc = "88式精确射手步枪使用的大口径弹匣。"
	caliber = "7.62x54mmR"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "type88mag"
	default_ammo = /datum/ammo/bullet/sniper/upp
	max_rounds = 12
	gun_type = /obj/item/weapon/gun/rifle/sniper/svd
	ammo_band_icon = "+type88_band"
	ammo_band_icon_empty = "+type88_band_e"

/obj/item/ammo_magazine/sniper/svd/heap
	name = "\improper 88式高速弹匣（7.62x54mmR）"
	desc = "88式精确射手步枪使用的大口径弹匣，装有高速弹，可提供额外冲击力与防弹衣穿透能力。"
	ammo_band_color = AMMO_BAND_COLOR_HEAP
	default_ammo = /datum/ammo/bullet/sniper/upp/heap

/obj/item/ammo_magazine/sniper/svd/flak
	name = "\improper 88式破片弹匣（7.62x54mmR）"
	desc = "88式精确射手步枪使用的大口径弹匣，装有命中后爆裂并散布破片的弹药。"
	ammo_band_color = AMMO_BAND_COLOR_IMPACT
	default_ammo = /datum/ammo/bullet/sniper/upp/flak

/obj/item/ammo_magazine/sniper/svd/flak/Initialize(mapload, spawn_empty)
	. = ..()
	desc = desc + SPAN_WARNING(" 小心破片误伤友军。")

/obj/item/ammo_magazine/sniper/svd/pve
	name = "\improper 88式空尖弹匣（7.62x54mmR）"
	default_ammo = /datum/ammo/bullet/sniper/upp_pve

//RMC DMR magazine

/obj/item/ammo_magazine/sniper/rmc
	name = "\improper L64A3碎甲弹匣（8.88x51mm无壳弹）"
	desc = "装有L10A7比赛级8.88x51mm碎甲弹的弹匣。瞄准射击可造成显著伤害。"
	caliber = "8.88x51mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/twe_ammo.dmi'
	icon_state = "rmcdmr"
	w_class = SIZE_MEDIUM
	max_rounds = 25
	default_ammo = /datum/ammo/bullet/rifle/heavy/rmcdmr
	gun_type = /obj/item/weapon/gun/rifle/sniper/rmc
	ammo_band_icon = "+rmcdmr_band"
	ammo_band_icon_empty = "+rmcdmr_band_e"
	ammo_band_color = AMMO_BAND_COLOR_IMPACT

//M49A magazines

/obj/item/ammo_magazine/rifle/m49a/custom
	name = "\improper A19高速弹匣（10x28mm）"
	desc = "装有供后期型号M49A战斗步枪使用的A19高速弹。只有M49A5和M49A6战斗步枪能使用这种弹药。"
	icon_state = "a19"
	default_ammo = /datum/ammo/bullet/rifle/heavy/spec
	max_rounds = 30
	gun_type = /obj/item/weapon/gun/rifle/m49a_custom
	ammo_band_icon = "+a19_band"
	ammo_band_icon_empty = "+a19_band_e"
	ammo_band_color = AMMO_BAND_COLOR_HIGH_IMPACT

/obj/item/ammo_magazine/rifle/m49a/custom/incendiary
	name = "\improper A19高速燃烧弹匣（10x28mm）"
	desc = "装有供后期型号M49A战斗步枪使用的A19高速燃烧弹。只有M49A5和M49A6战斗步枪能使用这种弹药。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/spec/incendiary
	gun_type = /obj/item/weapon/gun/rifle/m49a_custom
	ammo_band_color = AMMO_BAND_COLOR_INCENDIARY

/obj/item/ammo_magazine/rifle/m49a/custom/explosive
	name = "\improper A19高速爆破弹匣（10x28mm）"
	desc = "装有供后期型号M49A战斗步枪使用的A19高速爆破弹。只有M49A5和M49A6战斗步枪能使用这种弹药。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/spec/explosive
	gun_type = /obj/item/weapon/gun/rifle/m49a_custom
	ammo_band_color = AMMO_BAND_COLOR_EXPLOSIVE

/obj/item/ammo_magazine/rifle/m49a/custom/pve
	name = "\improper A19高速贫铀弹匣（10x28mm）"
	desc = "装有可穿墙、穿透人体且带毒性的A19高速10x28mm弹药。由门户空间站军械师手工装填，供M49A6战斗步枪使用。"
	default_ammo = /datum/ammo/bullet/rifle/heavy/spec/du
	gun_type = /obj/item/weapon/gun/rifle/m49a/pve
	ammo_band_color = AMMO_BAND_COLOR_TOXIN

//-------------------------------------------------------
//SMARTGUN
/obj/item/ammo_magazine/smartgun
	name = "智能机枪弹鼓"
	caliber = "10x28mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "m56_drum"
	max_rounds = 500 //Should be 500 in total.
	w_class = SIZE_MEDIUM
	default_ammo = /datum/ammo/bullet/rifle/heavy/tracer
	gun_type = /obj/item/weapon/gun/smartgun

/obj/item/ammo_magazine/smartgun/dirty
	name = "智能机枪辐射弹鼓"
	desc = "乍看像是标准的500发M56智能机枪弹鼓，实际装有辐射弹，为子弹增添了额外的“劲头”。弹鼓稍经改造，仅适配M56T智能机枪，并带有红色X标记。"
	icon_state = "m56_drum_dirty"
	default_ammo = /datum/ammo/bullet/rifle/heavy/dirty
	gun_type = /obj/item/weapon/gun/smartgun

/obj/item/ammo_magazine/smartgun/holo_targeting
	name = "智能机枪全息标记弹鼓"
	desc = "供皇家海军陆战队突击队L58A3智能机枪使用的全息标记弹。弹鼓仅适配L58A3智能机枪，并带有蓝色X标记。"
	icon_state = "m56_drum_holo"
	default_ammo = /datum/ammo/bullet/rifle/heavy/holo_target
	gun_type = /obj/item/weapon/gun/smartgun/rmc

/obj/item/ammo_magazine/smartgun/upp
	name = "自动机枪弹鼓"
	caliber = "12.7x40mm"
	max_rounds = 250
	desc = "简单的大口径250发机枪弹鼓。"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "rfvs37"
	default_ammo = /datum/ammo/bullet/rifle/heavy/upp_smartgun
	gun_type = /obj/item/weapon/gun/smartgun/upp


//-------------------------------------------------------
//Flare gun. Close enough?
/obj/item/ammo_magazine/internal/flare
	name = "flare gun internal magazine"
	caliber = "FL"
	max_rounds = 1
	default_ammo = /datum/ammo/flare

//-------------------------------------------------------
//M5 RPG

/obj/item/ammo_magazine/rocket
	name = "\improper 84mm高爆火箭弹"
	desc = "装有高爆战斗部的火箭筒。直接命中软目标时造成高额伤害，并使5米宽范围内的大多数目标短暂眩晕。对重装甲目标的效果较弱。"
	caliber = "rocket"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "rocket"

	reload_delay = 60
	matter = list("metal" = 10000)
	w_class = SIZE_MEDIUM
	max_rounds = 1
	default_ammo = /datum/ammo/rocket
	gun_type = /obj/item/weapon/gun/launcher/rocket
	flags_magazine = NO_FLAGS

/obj/item/ammo_magazine/rocket/attack_self(mob/user)
	. = ..()
	if(current_rounds <= 0)
		to_chat(user, SPAN_NOTICE("你开始拆解空发射筒框架……"))
		if(do_after(user,10, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message("[user]拆解了火箭筒框架。",SPAN_NOTICE("你拆解了空框架。"))
			var/obj/item/stack/sheet/metal/M = new(get_turf(user))
			M.amount = 2
			user.drop_held_item()
			qdel(src)
	else
		to_chat(user, "里面还有导弹，不能拆解！")

/obj/item/ammo_magazine/rocket/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(!istype(M) || !istype(user) || get_dist(user, M) > 1)
		return
	var/obj/item/weapon/gun/launcher/in_hand = M.get_active_hand()
	if(!in_hand || !istype(in_hand))
		return
	if(!in_hand.current_mag)
		return
	var/obj/item/weapon/twohanded/offhand/off_hand = M.get_inactive_hand()
	if(!off_hand || !istype(off_hand))
		to_chat(user, SPAN_WARNING("[M]必须双手握持[in_hand]，才能装填！"))
		return
	if(!skillcheck(M, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("你不知道如何装填[in_hand]！"))
		return
	if(M.dir != user.dir || M.loc != get_step(user, user.dir))
		to_chat(user, SPAN_WARNING("你必须站在[M]身后才能装填！"))
		return
	if(in_hand.current_mag.current_rounds > 0)
		to_chat(user, SPAN_WARNING("[in_hand]已经装填好了！"))
		return
	if(user.action_busy)
		return
	to_chat(user, SPAN_NOTICE("你开始为[M]的[in_hand]装填！保持不动……"))
	if(!do_after(user,(in_hand.current_mag.reload_delay / 2), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_WARNING("装填被打断了！"))
		return
	if(off_hand != M.get_inactive_hand())
		to_chat(user, SPAN_WARNING("[M]必须双手握持[in_hand]，才能装填！"))
		return
	if(M.dir != user.dir)
		to_chat(user, SPAN_WARNING("你必须站在[M]身后才能装填！"))
		return
	user.drop_inv_item_on_ground(src)
	qdel(in_hand.current_mag)
	in_hand.replace_ammo(user,src)
	in_hand.current_mag = src
	forceMove(in_hand)
	to_chat(user, SPAN_NOTICE("你将[src]装进了[M]的[in_hand]。"))
	if(in_hand.reload_sound)
		playsound(M, in_hand.reload_sound, 25, 1)
	else
		playsound(M,'sound/machines/click.ogg', 25, 1)

	return 1

/obj/item/ammo_magazine/rocket/update_icon()
	if(current_rounds <= 0)
		name = "\improper 84mm空火箭筒"
		icon_state = "rocket_e"
		desc = "M5 RPG火箭发射器用过的空筒。拿在手中激活可拆解成金属。"
		add_to_garbage(src)
	else
		icon_state = initial(icon_state)

/obj/item/ammo_magazine/rocket/custom/update_icon()
	if(current_rounds <= 0)
		return ..()
	if(warhead)
		if(locked)
			if(fuel && fuel.reagents.get_reagent_amount(fuel_type) >= fuel_requirement)
				icon_state = initial(icon_state) +"_locked"
			else
				icon_state = initial(icon_state) +"_no_fuel"
		else if(!locked)
			icon_state = initial(icon_state) +"_unlocked"
	else
		icon_state = initial(icon_state)

/obj/item/ammo_magazine/rocket/ap
	name = "\improper 84mm反装甲火箭弹"
	icon_state = "ap_rocket"
	default_ammo = /datum/ammo/rocket/ap
	desc = "装有穿甲战斗部的火箭筒，能够穿透重装甲目标。溅射伤害极小或没有，但必定使大多数目标眩晕。7米内精度较高。"

/obj/item/ammo_magazine/rocket/wp
	name = "\improper 84mm白磷火箭弹"
	icon_state = "wp_rocket"
	default_ammo = /datum/ammo/rocket/wp
	desc = "装有白磷战斗部的火箭筒，具有两种杀伤效果：命中后无视掩体，在半径4米范围内散布X型Napthal燃料（蓝色火焰），同时爆裂出高温破片，点燃稍大范围内的目标。"

/obj/item/ammo_magazine/rocket/custom
	name = "\improper 84mm自制火箭弹"
	desc = "一枚84mm自制火箭弹。"
	icon_state = "custom_rocket"
	default_ammo = /datum/ammo/rocket/custom
	matter = list("metal" = 7500) //2 sheets
	var/obj/item/explosive/warhead/rocket/warhead
	var/obj/item/reagent_container/glass/fuel
	var/fuel_requirement = 60
	var/fuel_type = "methane"
	var/locked = FALSE

/obj/item/ammo_magazine/rocket/custom/attack_self(mob/user as mob)
	if(!locked && current_rounds)
		if(warhead)
			user.put_in_hands(warhead)
			warhead = null
		else if(fuel)
			user.put_in_hands(fuel)
			fuel = null
		update_icon()
		return
	. = ..()

/obj/item/ammo_magazine/rocket/custom/get_examine_text(mob/user)
	. = ..()
	if(fuel)
		. += SPAN_NOTICE("内有燃料。")
	if(warhead)
		. += SPAN_NOTICE("内有战斗部。")

/obj/item/ammo_magazine/rocket/custom/attackby(obj/item/W as obj, mob/user as mob)
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
		to_chat(user, SPAN_WARNING("你不知道如何改装[name]。"))
		return
	if(current_rounds <= 0)
		to_chat(user, SPAN_WARNING("这个火箭筒已经用过了。"))
		return
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!warhead)
			to_chat(user, SPAN_NOTICE("[name]必须装有战斗部才能这样做！"))
			return
		if(locked)
			to_chat(user, SPAN_NOTICE("你解锁了[name]。"))
		else
			to_chat(user, SPAN_NOTICE("你锁定了[name]。"))
		locked = !locked
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 0, 6)
	else if(istype(W,/obj/item/reagent_container/glass) && !locked)
		if(fuel)
			to_chat(user, SPAN_DANGER("[name]已经装有燃料容器！"))
			return
		else
			user.temp_drop_inv_item(W)
			W.forceMove(src)
			fuel = W
			to_chat(user, SPAN_DANGER("你将[W]装入了[name]。"))
			playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
	else if(istype(W,/obj/item/explosive/warhead/rocket) && !locked)
		if(warhead)
			to_chat(user, SPAN_DANGER("[name]已经装有战斗部！"))
			return
		var/obj/item/explosive/warhead/rocket/det = W
		if(det.assembly_stage < ASSEMBLY_LOCKED)
			to_chat(user, SPAN_DANGER("[W]尚未固定好！"))
			return
		user.temp_drop_inv_item(W)
		W.forceMove(src)
		warhead = W
		to_chat(user, SPAN_DANGER("你将[W]装入了[name]。"))
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
	update_icon()

//-------------------------------------------------------
//M5 RPG'S MEAN FUCKING COUSIN

/obj/item/ammo_magazine/rocket/m57a4
	name = "\improper 84mm温压火箭弹组"
	desc = "供M57-A4四联装发射器使用的温压火箭筒，装有4枚战斗部。"
	caliber = "rocket array"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "quad_rocket"

	max_rounds = 4
	default_ammo = /datum/ammo/rocket/wp/quad
	gun_type = /obj/item/weapon/gun/launcher/rocket/m57a4
	reload_delay = 200

/obj/item/ammo_magazine/rocket/m57a4/update_icon()
	..()
	if(current_rounds <= 0)
		name = "\improper 84mm空火箭筒组"
		desc = "M57-A4四联装发射器用过的空筒组件。拿在手中激活可拆解成金属。"
		icon_state = "quad_rocket_e"

//-------------------------------------------------------
//Anti-tank rocket

/obj/item/ammo_magazine/rocket/anti_tank
	name = "\improper 84mm反坦克火箭弹"
	desc = "专门改装用于穿透装甲车辆车体的反装甲火箭弹。"
	caliber = "rocket"
	icon_state = "at_rocket"

	max_rounds = 1
	default_ammo = /datum/ammo/rocket/ap/anti_tank
	gun_type = /obj/item/weapon/gun/launcher/rocket/anti_tank
	reload_delay = 100


//-------------------------------------------------------
//UPP Rockets

/obj/item/ammo_magazine/rocket/upp
	name = "\improper HJRA-12高爆火箭弹"
	desc = "供进步人民联盟制式HJRA-12便携式反坦克榴弹发射器使用的火箭弹。这是标准高爆弹，用于杀伤人员或攻击轻型车辆。"
	caliber = "88mm"
	icon_state = "hjra_explosive"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'

	max_rounds = 1
	default_ammo = /datum/ammo/rocket
	gun_type = /obj/item/weapon/gun/launcher/rocket/upp
	reload_delay = 85

/obj/item/ammo_magazine/rocket/upp/update_icon()
	if(current_rounds <= 0)
		qdel(src)
	else
		icon_state = initial(icon_state)

/obj/item/ammo_magazine/rocket/upp/at
	name = "\improper HJRA-12反坦克火箭弹"
	desc = "供进步人民联盟制式HJRA-12便携式反坦克榴弹发射器使用的火箭弹。这是标准反坦克弹，用于瘫痪或摧毁敌方车辆。"
	caliber = "88mm"
	icon_state = "hjra_tank"

	max_rounds = 1
	default_ammo = /datum/ammo/rocket/ap/anti_tank
	gun_type = /obj/item/weapon/gun/launcher/rocket/upp
	reload_delay = 85

/obj/item/ammo_magazine/rocket/upp/incen
	name = "\improper HJRA-12超强燃烧火箭弹"
	desc = "供进步人民联盟制式HJRA-12便携式反坦克榴弹发射器使用的火箭弹。这种超强燃烧弹使用联盟编号为R-189的实验性化学物质，原本用于熔穿工事和碉堡。但由于配发过量，且用于原定用途后会使空气温度高到人类无法生存，它更多被用来杀伤人员。"
	caliber = "88mm"
	icon_state = "hjra_incen"

	max_rounds = 1
	default_ammo = /datum/ammo/rocket/wp/upp
	gun_type = /obj/item/weapon/gun/launcher/rocket/upp
	reload_delay = 85

//-------------------------------------------------------
//AA Missiles

/obj/item/ammo_magazine/rocket/anti_air
	name = "\improper 70mm“大黄蜂”超高速防空导弹"
	desc = "一种细长导弹，可由M579 ADS-C车辆或SIM-118便携式防空导弹系统发射。大黄蜂是一种结构简洁的超高速导弹，依靠撞击时释放的动能击毁目标。"
	caliber = "missile"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "hornet"
	default_ammo = /datum/ammo/rocket/ap/anti_air
	gun_type = /obj/item/weapon/gun/launcher/rocket/anti_air/uscm

/obj/item/ammo_magazine/rocket/anti_air/update_icon()
	if(current_rounds <= 0)
		qdel(src)
	else
		icon_state = initial(icon_state)

/obj/item/ammo_magazine/rocket/anti_air/upp
	name = "\improper 92mm“大雁”防空导弹筒"
	desc = "EMBLR地对空武器系统使用的矮粗导弹筒。与USCM同类武器不同，大雁携带小巧而强劲的战斗部，能够在目标周围散布大量箭形弹。"
	caliber = "missile"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/upp.dmi'
	icon_state = "emblr"
	default_ammo = /datum/ammo/rocket/anti_air
	gun_type = /obj/item/weapon/gun/launcher/rocket/anti_air/upp

/obj/item/ammo_magazine/rocket/anti_air/upp/update_icon()
	..()
	if(current_rounds <= 0)
		name = "\improper 92mm空导弹筒"
		desc = "EMBLR防空导弹发射器用过的空筒组件。"
		icon_state = "emblr_e"

//-------------------------------------------------------
// XM99 power/fuel cells

/obj/item/ammo_magazine/plasma
	name = "\improper XM99A1电池弹鼓"
	desc = "适配XM99A系列相位等离子脉冲步枪的电池与碲化镉弹丸混合弹匣。切勿刺穿或放入微波炉。"
	caliber = "40W"
	icon_state = "xm99a_cell"
	w_class = SIZE_MEDIUM
	flags_magazine = NO_FLAGS //It's a battery, can't yank bullets or shells outa this
	max_rounds = 4
	default_ammo = /datum/ammo/energy/plasma
	gun_type = /obj/item/weapon/gun/XM99

// The "round-remover" power/fuel cell for the XM99
/obj/item/ammo_magazine/plasma/gibber
	name = "\improper XM99A1锂电池弹鼓"
	desc = "适配XM99A系列相位等离子脉冲步枪的电池与碲化锂弹丸混合弹匣。切勿刺穿、放入微波炉、浸水，甚至别用奇怪的眼神看它。极不稳定。"
	icon_state = "xm99a_lcell"
	max_rounds = 2
	default_ammo = /datum/ammo/energy/plasma/heavy

//-------------------------------------------------------
//P9 SHARP Rifle

/obj/item/ammo_magazine/rifle/sharp
	name = "SHARP步枪弹匣"
	icon_state = "sharprifle"
	item_state = "sharprifle"

	w_class = SIZE_MEDIUM
	max_rounds = 10
	default_ammo = /datum/ammo/rifle/sharp/explosive
	gun_type = /obj/item/weapon/gun/rifle/sharp
	flags_magazine = NO_FLAGS

	description_ammo = "枚飞镖"

/obj/item/ammo_magazine/rifle/sharp/explosive
	name = "\improper 9X-E黏附爆炸飞镖弹匣"
	desc = "一种专用的黏附爆炸飞镖弹匣。"

/obj/item/ammo_magazine/rifle/sharp/track
	name = "\improper 9X-T黏附追踪飞镖弹匣"
	desc = "一种专用的追踪飞镖弹匣。"
	icon_state = "sharprifle_tracker"
	default_ammo = /datum/ammo/rifle/sharp/track

/obj/item/ammo_magazine/rifle/sharp/track/infinite
	default_ammo = /datum/ammo/rifle/sharp/track/infinite

/obj/item/ammo_magazine/rifle/sharp/flechette
	name = "\improper 9X-F箭形飞镖弹匣"
	desc = "一种专用的箭形飞镖弹匣。"
	icon_state = "sharprifle_flechette"
	default_ammo = /datum/ammo/rifle/sharp/flechette
