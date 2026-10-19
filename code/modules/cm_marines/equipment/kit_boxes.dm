
//******************************************Spec Kits****************************************************************/

/obj/item/storage/box/spec
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "kit_case"
	var/kit_overlay = null
	w_class = SIZE_HUGE
	storage_slots = 14
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	max_w_class = 0
	foldable = null

/obj/item/storage/box/spec/update_icon()
	if(LAZYLEN(overlays))
		overlays.Cut()
	if(LAZYLEN(contents))
		icon_state = "kit_case"
		overlays += image(icon, kit_overlay)
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/spec/rocketeer
	name = "火箭筒手装备箱"
	desc = "大型装备箱，内含大口径反坦克 M5 RPG 火箭筒、M10-R 轰击手头盔、三枚备用 84mm 火箭弹、装填手装备及其他装备。\n将图标拖到自己身上即可打开！注意：物品无法放回箱内。"
	kit_overlay = "demo"

/obj/item/storage/box/spec/rocketeer/fill_preset_inventory()
	new /obj/item/clothing/head/helmet/marine/M3T(src)
	new /obj/item/weapon/gun/launcher/rocket/marine(src)
	new /obj/item/storage/backpack/marine/rocketpack(src)
	new /obj/item/ammo_magazine/rocket(src)
	new /obj/item/ammo_magazine/rocket/ap(src)
	new /obj/item/ammo_magazine/rocket/wp(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	// loader
	new /obj/item/storage/box/kit/loader(src)

/obj/item/storage/box/kit/loader
	name = "装填手套件"
	desc = "大型套件，包含让一名陆战队员成为 M5 RPG 装填助手所需的全部物资。\n一组小图示说明了装填步骤：\n第一步：拿起火箭弹。\n第二步：站到 M5 射手身后。\n第三步：确保射手正双手握持发射器。\n第四步：将火箭弹装入发射器。\n第五步：避开尾焰喷射区。"
	pro_case_overlay = "loader"

/obj/item/storage/box/kit/loader/fill_preset_inventory()
	// wearables
	new /obj/item/clothing/head/helmet/marine/M3T(src)
	new /obj/item/storage/backpack/marine/rocketpack(src)
	// most the ammo
	new /obj/item/ammo_magazine/rocket(src)
	new /obj/item/ammo_magazine/rocket(src)
	new /obj/item/ammo_magazine/rocket(src)
	new /obj/item/ammo_magazine/rocket/ap(src)
	new /obj/item/ammo_magazine/rocket/ap(src)
	new /obj/item/ammo_magazine/rocket/wp(src)
	// skills
	new /obj/item/pamphlet/skill/loader(src)

/obj/item/storage/box/spec/sniper
	name = "侦察狙击手 (射手) 装备箱"
	desc = "大型装备箱，内含你的专属远程 M42A 狙击步枪、M45 吉利护甲与头盔、M3 昼夜护目镜、弹药及其他装备。\n将图标拖到自己身上即可打开！注意：物品无法放回箱内。"
	kit_overlay = "sniper"

/obj/item/storage/box/spec/sniper/fill_preset_inventory()
	// sniper
	new /obj/item/clothing/suit/storage/marine/ghillie(src)
	new /obj/item/clothing/head/helmet/marine/ghillie(src)
	new /obj/item/clothing/glasses/night/ghillie_goggles(src)
	new /obj/item/ammo_magazine/sniper(src)
	new /obj/item/ammo_magazine/sniper(src)
	new /obj/item/ammo_magazine/sniper/incendiary(src)
	new /obj/item/ammo_magazine/sniper/incendiary(src)
	new /obj/item/ammo_magazine/sniper/flak(src)
	new /obj/item/ammo_magazine/sniper/flak(src)
	new /obj/item/storage/backpack/marine/smock(src)
	new /obj/item/weapon/gun/rifle/sniper/M42A(src)
	new /obj/item/facepaint/sniper(src)

/obj/item/storage/box/spec/sniper/anti_materiel/fill_preset_inventory()
	name = "侦察狙击手（反器材步枪射手）装备箱"
	desc = "一个大箱子，内装实验型 XM43E1、M45 吉利伪装护甲与头盔、M3 昼夜两用护目镜、弹药及其他装备。\n将此图标拖到自己身上即可打开！注意：物品取出后无法放回箱内。"
	kit_overlay = "amr"
	new /obj/item/clothing/suit/storage/marine/ghillie(src)
	new /obj/item/clothing/head/helmet/marine/ghillie(src)
	new /obj/item/clothing/glasses/night/ghillie_goggles(src)
	new /obj/item/weapon/gun/rifle/sniper/XM43E1(src)
	new /obj/item/ammo_magazine/sniper/anti_materiel(src)
	new /obj/item/ammo_magazine/sniper/anti_materiel(src)
	new /obj/item/ammo_magazine/sniper/anti_materiel(src)
	new /obj/item/ammo_magazine/sniper/anti_materiel(src)
	new /obj/item/ammo_magazine/sniper/anti_materiel(src)
	new /obj/item/storage/backpack/marine/smock(src)
	new /obj/item/facepaint/sniper(src)

/obj/item/storage/box/spec/spotter
	name = "侦察狙击手 (观测手) 装备箱"
	desc = "大型装备箱，内含定制 M49A5 战斗步枪、M45 吉利护甲与头盔、M49A 战斗瞄准镜、V3 反应式热伪装布、观测手激光目标指示器、弹药及其他装备。\n将图标拖到自己身上即可打开！注意：物品无法放回箱内。"
	kit_overlay = "spotter"

/obj/item/storage/box/spec/spotter/fill_preset_inventory()
	new /obj/item/clothing/suit/storage/marine/ghillie(src)
	new /obj/item/clothing/head/helmet/marine/ghillie(src)
	new /obj/item/clothing/glasses/night/M49A(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom/incendiary(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom/incendiary(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom/explosive(src)
	new /obj/item/ammo_magazine/rifle/m49a/custom/explosive(src)
	new /obj/item/weapon/gun/rifle/m49a_custom(src)
	new /obj/item/bodybag/tarp/reactive/scout(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/device/encryptionkey/jtac(src)
	new /obj/item/device/binoculars/range/designator/spotter(src)
	new /obj/item/storage/backpack/marine/smock(src)


/obj/item/storage/box/spec/pyro
	name = "火焰兵装备箱"
	desc = "大型装备箱，内含 M240-T 火焰喷射器、M35 火焰兵护甲与头盔、炙炉-T 柔性补油系统及其他装备。\n将图标拖到自己身上即可打开！注意：物品无法放回箱内。"
	kit_overlay = "pyro"

/obj/item/storage/box/spec/pyro/fill_preset_inventory()
	new /obj/item/clothing/suit/storage/marine/M35(src)
	new /obj/item/clothing/head/helmet/marine/pyro(src)
	new /obj/item/storage/large_holster/fuelpack(src)
	new /obj/item/weapon/gun/flamer/M240T(src)
	new /obj/item/ammo_magazine/flamer_tank/large(src)
	new /obj/item/ammo_magazine/flamer_tank/large/B(src)
	new /obj/item/storage/pouch/flamertank(src)


/obj/item/storage/box/spec/heavy_grenadier
	name = "重型榴弹兵装备箱"
	desc = "大型装备箱，内含重型多发阿玛特系统 M92 榴弹发射器、M3-G4 榴弹兵护甲与头盔、大量各型手榴弹及其他装备。\n将图标拖到自己身上即可打开！注意：物品无法放回箱内。"
	kit_overlay = "grenadier"

/obj/item/storage/box/spec/heavy_grenadier/fill_preset_inventory()
	new /obj/item/weapon/gun/launcher/grenade/m92(src)
	new /obj/item/storage/belt/grenade/large/full(src)
	new /obj/item/storage/backpack/marine/grenadepack(src)
	new /obj/item/storage/box/packet/phosphorus(src)
	new /obj/item/storage/box/packet/heap(src)
	new /obj/item/storage/box/packet/canister(src)
	new /obj/item/clothing/gloves/marine/M3G(src)
	new /obj/item/clothing/suit/storage/marine/M3G(src)
	new /obj/item/clothing/head/helmet/marine/grenadier(src)

/obj/item/storage/box/spec/sharp_operator
	name = "\improper SHARP操作员装备箱"
	desc = "一个大箱子，内装P9 SHARP步枪、一套抗爆护甲与头盔，以及各种辅助装备。\n将箱子拖到自己身上即可打开！"
	kit_overlay = "sharp"

/obj/item/storage/box/spec/sharp_operator/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/sharp(src)
	new /obj/item/ammo_magazine/rifle/sharp/explosive(src)
	new /obj/item/ammo_magazine/rifle/sharp/explosive(src)
	new /obj/item/ammo_magazine/rifle/sharp/explosive(src)
	new /obj/item/ammo_magazine/rifle/sharp/explosive(src)
	new /obj/item/ammo_magazine/rifle/sharp/flechette(src)
	new /obj/item/ammo_magazine/rifle/sharp/flechette(src)
	new /obj/item/ammo_magazine/rifle/sharp/flechette(src)
	new /obj/item/clothing/gloves/marine/M3G(src)
	new /obj/item/clothing/suit/storage/marine/M3G(src)
	new /obj/item/clothing/head/helmet/marine/grenadier(src)

//maybe put in req for later use?
/obj/item/storage/box/spec/B18
	name = "\improper B18重型护甲箱"
	desc = "一个大箱子，内装实验性B18护甲平台。请小心搬运，它比整个德尔塔小队的装备还贵。\n将箱子拖到自己身上即可打开！注意：物品取出后无法放回箱内。"
	kit_overlay = "b18"

/obj/item/storage/box/spec/B18/fill_preset_inventory()
	new /obj/item/clothing/gloves/marine/specialist(src)
	new /obj/item/clothing/head/helmet/marine/specialist(src)
	new /obj/item/clothing/suit/storage/marine/specialist(src)

//-----------------SPEC KIT BOX------------------
//For events/WO, allows the user to choose a specalist kit out of available ones in spec_kit_boxes_left list in gloabl_lists.dm

/obj/item/spec_kit
	name = "专家套件"
	desc = "一个纸盒，打开即可获得专家套件。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "spec_kit"
	var/list/allowed_roles_list = list(JOB_SQUAD_SPECIALIST, JOB_WO_SQUAD_SPECIALIST, JOB_WO_CREWMAN)

	///Used for cryo specs who already have "foxtrot" appended to their ID assignments
	var/squad_assignment_update = TRUE

//this one is delivered via ASRS as a reward for DEFCON/techwebs/whatever else we will have
/obj/item/spec_kit/rifleman
	squad_assignment_update = FALSE
	allowed_roles_list = list(JOB_SQUAD_MARINE, JOB_WO_SQUAD_MARINE)

/obj/item/spec_kit/rifleman/jobless
	allowed_roles_list = list()

/obj/item/spec_kit/cryo
	squad_assignment_update = FALSE

/obj/item/spec_kit/get_examine_text(mob/user)
	. = ..()
	if(!ishuman(user) && !isobserver(user))
		return

	var/allowed_roles
	if(length(allowed_roles_list))
		allowed_roles = ""
		for(var/role in allowed_roles_list)
			if(length(allowed_roles))
				allowed_roles += ", "
			allowed_roles += SPAN_HELPFUL("[localized_player_label(role)]")
	else
		allowed_roles = SPAN_HELPFUL("任何人")
	. += SPAN_INFO("尚未使用过此类套件的[allowed_roles]可以使用这个[name]。")

/obj/item/spec_kit/attack_self(mob/living/carbon/human/user)
	..()
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("你无法使用[src]！"))
		return

	if(can_use(user))
		if(select_and_spawn(user))
			qdel(src)
			return
	else
		to_chat(user, SPAN_WARNING("你无法使用这个[name]！"))
	return

/obj/item/spec_kit/proc/can_use(mob/living/carbon/human/user)
	if(!length(allowed_roles_list))
		return TRUE

	for(var/allowed_role in allowed_roles_list)
		if(user.job == allowed_role)
			return TRUE

/obj/item/spec_kit/rifleman/can_use(mob/living/carbon/human/user)
	if(!length(allowed_roles_list))
		return TRUE

	for(var/allowed_role in allowed_roles_list)
		if(user.job == allowed_role)//Alternate check to normal kit as this is distributed to people without SKILL_SPEC_TRAINED.
			return TRUE

/obj/item/spec_kit/proc/select_and_spawn(mob/living/carbon/human/user)
	var/list/available_specialist_kits = list()
	for(var/path in GLOB.specialist_set_datums)
		var/datum/specialist_set/specset = GLOB.specialist_set_datums[path]
		if(specset.get_available_kit_num() >= 1)
			available_specialist_kits += specset.get_name()

	var/selection = tgui_input_list(user, "选择你的专家装备类型。", "专家套件选择", available_specialist_kits, 10 SECONDS)
	if(!selection || QDELETED(src))
		return FALSE
	if(!GLOB.specialist_set_name_dict[selection] || (GLOB.specialist_set_name_dict[selection].get_available_kit_num() <= 0))
		to_chat(user, SPAN_WARNING("此类套件已无剩余可选数量！"))
		return FALSE
	var/obj/item/card/id/card = user.get_idcard()
	if(!card || card.registered_ref != WEAKREF(user))
		to_chat(user, SPAN_WARNING("必须佩戴你的[SPAN_INFO("身份牌")]或[SPAN_INFO("军用身份牌")]才能选择专精！"))
		return FALSE
	return GLOB.specialist_set_name_dict[selection].redeem_set(user, TRUE)


//******************************************PFC Kits****************************************************************/

/obj/item/storage/box/kit
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "pro_case_mini"//to-do redo these sprites, they're out of date by current standards
	w_class = SIZE_HUGE
	storage_slots = 12
	slowdown = 1
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.
	foldable = TRUE
	ground_offset_x = 5
	ground_offset_y = 5
	var/pro_case_overlay

/obj/item/storage/box/kit/Initialize()
	. = ..()
	if(pro_case_overlay)
		overlays += image('icons/obj/items/storage/kits.dmi', "+[pro_case_overlay]")

/obj/item/storage/box/kit/update_icon()
	if(!length(contents))
		qdel(src)
/obj/item/storage/box/kit/mou53_sapper
	name = "\improper M-OU53野外试验套件"
	pro_case_overlay = "mou53"

/obj/item/storage/box/kit/mou53_sapper/fill_preset_inventory()
	new /obj/item/weapon/gun/shotgun/double/mou53(src)
	new /obj/item/attachable/stock/mou53(src)
	new /obj/item/ammo_magazine/shotgun/slugs(src)
	new /obj/item/ammo_magazine/shotgun/flechette(src)
	new /obj/item/storage/belt/shotgun(src)

/obj/item/storage/box/kit/r4t_scout
	name = "\improper R4T环境侦察套件"

/obj/item/storage/box/kit/r4t_scout/New()
	..()
	pro_case_overlay = "r4t"

/obj/item/storage/box/kit/r4t_scout/fill_preset_inventory()
	new /obj/item/weapon/gun/lever_action/r4t(src)
	new /obj/item/attachable/stock/r4t(src)
	new /obj/item/attachable/magnetic_harness/lever_sling(src)
	new /obj/item/ammo_magazine/lever_action(src)
	new /obj/item/ammo_magazine/lever_action(src)
	new /obj/item/storage/belt/shotgun/lever_action(src)
	new /obj/item/storage/belt/gun/m44/lever_action/attach_holster(src)
	new /obj/item/ammo_magazine/lever_action/training(src)

/obj/item/storage/box/kit/machinegunner
	name = "\improper M2C重机枪手套件"
	pro_case_overlay = "hmg"

/obj/item/storage/box/kit/machinegunner/fill_preset_inventory()
	new /obj/item/storage/box/m56d/m2c(src)
	new /obj/item/storage/belt/marine/m2c(src)
	new /obj/item/clothing/head/helmet/marine/tech(src)
	new /obj/item/storage/pouch/tools/tank(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/pamphlet/skill/machinegunner(src)

/obj/item/storage/box/kit/defensegunner
	name = "\improper M56D防御机枪手套件"
	icon_state = "pro_case_large"
	pro_case_overlay = "m56d"

/obj/item/storage/box/kit/defensegunner/fill_preset_inventory()
	new /obj/item/storage/box/m56d_hmg(src)
	new /obj/item/storage/belt/marine/m2c(src)
	new /obj/item/clothing/head/helmet/marine/tech(src)
	new /obj/item/explosive/mine(src)
	new /obj/item/explosive/mine(src)
	new /obj/item/pamphlet/skill/machinegunner(src)


/obj/item/storage/box/kit/mini_pyro
	name = "M240 火焰兵支援套件"
	pro_case_overlay = "flamer"

/obj/item/storage/box/kit/mini_pyro/fill_preset_inventory()
	new /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit(src)
	new /obj/item/weapon/gun/flamer/underextinguisher(src)
	new /obj/item/ammo_magazine/flamer_tank(src)
	new /obj/item/ammo_magazine/flamer_tank(src)
	new /obj/item/ammo_magazine/flamer_tank/gellied(src)
	new /obj/item/tool/extinguisher/mini(src)


/obj/item/storage/box/kit/mini_sniper
	name = "M49A 精确射手套件"
	pro_case_overlay = "sniper"

/obj/item/storage/box/kit/mini_sniper/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/m49a(src)
	new /obj/item/attachable/scope(src)
	new /obj/item/attachable/suppressor(src)
	new /obj/item/attachable/extended_barrel(src)
	new /obj/item/ammo_magazine/rifle/m49a/ap(src)
	new /obj/item/ammo_magazine/rifle/m49a/ap(src)

/obj/item/storage/box/kit/m41a_kit
	name = "M41A 步枪套件"
	pro_case_overlay = "pursuit"

/obj/item/storage/box/kit/m41a_kit/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/m41a(src)
	new /obj/item/attachable/angledgrip(src)
	new /obj/item/attachable/suppressor(src)
	new /obj/item/attachable/extended_barrel(src)
	new /obj/item/ammo_magazine/rifle/ap(src)
	new /obj/item/ammo_magazine/rifle/ap(src)

/obj/item/storage/box/kit/heavy_support
	name = "\improper 前线重型脉冲步枪护盾套件"
	pro_case_overlay = "shield"

/obj/item/storage/box/kit/heavy_support/fill_preset_inventory()
	new /obj/item/weapon/gun/rifle/lmg(src)
	new /obj/item/ammo_magazine/hpr_box(src)
	new /obj/item/ammo_magazine/hpr_box/holo_target(src)
	new /obj/item/attachable/bipod(src)
	new /obj/item/stack/folding_barricade/three(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/tool/weldingtool(src)


/obj/item/storage/box/kit/pursuit
	name = "\improper M39尖兵套件"
	pro_case_overlay = "pursuit"

/obj/item/storage/box/kit/pursuit/fill_preset_inventory()
	new /obj/item/weapon/gun/smg/m39(src)
	new /obj/item/attachable/stock/smg/collapsible/brace(src)
	new /obj/item/attachable/magnetic_harness(src)
	new /obj/item/storage/large_holster/machete/full(src)
	new /obj/item/ammo_magazine/smg/m39/extended(src)


/obj/item/storage/box/kit/mini_engineer
	name = "\improper 战斗技术员支援套件"
	pro_case_overlay = "engi"

/obj/item/storage/box/kit/mini_engineer/fill_preset_inventory()
	new /obj/item/storage/backpack/marine/engineerpack(src)
	new /obj/item/pamphlet/skill/engineer(src)
	new /obj/item/clothing/gloves/marine(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/storage/pouch/tools/pfc(src)
	new /obj/item/stack/folding_barricade/three(src)
	new /obj/item/explosive/mine(src)
	new /obj/item/explosive/plastic(src)
	new /obj/item/explosive/plastic(src)


/obj/item/storage/box/kit/mini_medic
	name = "\improper 现场急救支援套件"
	pro_case_overlay = "medic"

/obj/item/storage/box/kit/mini_medic/fill_preset_inventory()
	new /obj/item/pamphlet/skill/medical(src)
	new /obj/item/storage/pouch/first_responder/full(src)
	new /obj/item/storage/pouch/autoinjector/full(src)
	new /obj/item/device/helmet_visor/medical(src)
	new /obj/item/roller(src)


/obj/item/storage/box/kit/mini_jtac
	name = "\improper JTAC无线电套件"
	pro_case_overlay = "jtac"

/obj/item/storage/box/kit/mini_jtac/fill_preset_inventory()
	new /obj/item/weapon/gun/flare(src)
	new /obj/item/storage/belt/gun/flaregun/full_nogun(src)
	new /obj/item/storage/box/flare/signal(src)
	new /obj/item/storage/box/flare/signal(src)
	new /obj/item/device/binoculars/range/designator(src)
	new /obj/item/device/encryptionkey/jtac(src)
	new /obj/item/storage/backpack/marine/satchel/rto(src)

/obj/item/storage/box/kit/mini_intel
	name = "\improper 战地情报支援套件"
	pro_case_overlay = "intel"

/obj/item/storage/box/kit/mini_intel/fill_preset_inventory()
	new /obj/item/stack/fulton(src)
	new /obj/item/device/encryptionkey/intel(src)
	new /obj/item/pamphlet/skill/intel(src)
	new /obj/item/device/motiondetector/intel(src)

/obj/item/storage/box/kit/mini_grenadier
	name = "\improper 前线M40榴弹兵套件"
	pro_case_overlay = "grenadier"

/obj/item/storage/box/kit/mini_grenadier/fill_preset_inventory()
	new /obj/item/storage/belt/grenade/full(src)
	new /obj/item/storage/pouch/explosive(src)

/obj/item/storage/box/kit/self_defense
	name = "\improper 个人自卫套件"
	pro_case_overlay = "defense"

/obj/item/storage/box/kit/self_defense/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/ammo_magazine/pistol/vp78(src)
	new /obj/item/attachable/reddot(src)
	new /obj/item/attachable/lasersight(src)
	new /obj/item/storage/belt/gun/m4a3(src)

/obj/item/storage/box/kit/cryo_self_defense
	name = "\improper 冷冻休眠自卫套件"
	desc = "一套供紧急情况使用的基础自卫装备。如你所料，库存维护得并不怎么认真——谁会疯到直接袭击殖民地陆战队的舰船？"
	icon_state = "cryo_defense_kit"
	storage_slots = 4

/obj/item/storage/box/kit/cryo_self_defense/update_icon()
	if(LAZYLEN(contents))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_e"

/obj/item/storage/box/kit/cryo_self_defense/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/vp70/flashlight(src)
	new /obj/item/attachable/bayonet(src)
	new /obj/item/tool/crowbar/red(src)
	new /obj/item/mre_food_packet/entree/uscm(src)

/obj/item/storage/box/kit/exp_trooper
	name = "\improper 实验型突击步兵套件"
	pro_case_overlay = "smart"

/obj/item/storage/box/kit/exp_trooper/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/ammo_magazine/pistol/smart(src)
	new /obj/item/attachable/extended_barrel(src)
	new /obj/item/attachable/lasersight(src)
	new /obj/item/storage/belt/gun/smartpistol(src)

/obj/item/storage/box/kit/honorguard
	name = "\improper 仪仗卫队套件"
	pro_case_overlay = "honor_guard"

/obj/item/storage/box/kit/honorguard/fill_preset_inventory()
	new /obj/item/device/radio/headset/almayer/marine/mp_honor(src)
	new /obj/item/storage/pill_bottle/packet/oxycodone(src)
	new /obj/item/storage/pill_bottle/packet/kelotane(src)
	new /obj/item/storage/pill_bottle/packet/bicaridine(src)
	new /obj/item/weapon/gun/shotgun/combat(src)
	new /obj/item/storage/pouch/general/large(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)
	new /obj/item/ammo_magazine/shotgun/buckshot(src)

/obj/item/storage/box/kit/engineering_supply_kit
	name = "工程补给套件"

/obj/item/storage/box/kit/engineering_supply_kit/fill_preset_inventory()
	new /obj/item/storage/pouch/construction/low_grade_full(src)
	new /obj/item/storage/pouch/electronics/full(src)
	new /obj/item/clothing/glasses/welding(src)
