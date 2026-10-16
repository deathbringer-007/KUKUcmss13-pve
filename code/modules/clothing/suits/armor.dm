
/obj/item/clothing/suit/armor
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	siemens_coefficient = 0.6
	w_class = SIZE_HUGE
	allowed = list(/obj/item/weapon/gun, /obj/item/storage/backpack/general_belt)//Guns only.
	uniform_restricted = list(/obj/item/clothing/under)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M, ACCESSORY_SLOT_PONCHO)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	slowdown = SLOWDOWN_ARMOR_LIGHT

	pickup_sound = "armorequip"
	drop_sound = "armorequip"

/obj/item/clothing/suit/armor/mob_can_equip(mob/living/carbon/human/M, slot, disable_warning = 0)
	. = ..()
	if (.)
		if(issynth(M) && M.allow_gun_usage == FALSE)
			M.visible_message(SPAN_DANGER("你的程序禁止你穿戴这件装备！"))
			return 0

//armored vest

/obj/item/clothing/suit/armor/vest
	name = "防刺背心"
	desc = "各种私营安保人员使用的通用防护背心，专为抵挡刺击设计。"
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	time_to_unequip = 10
	time_to_equip = 10
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
	)

/obj/item/clothing/suit/armor/vest/ballistic
	name = "防弹背心"
	desc = "各种私营安保人员使用的通用文拉尔纤维背心，专为抵挡小口径手枪弹设计。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	icon_state = "ballistic_vest"
	item_state = "ballistic_vest"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/suit/armor/vest/pilot
	name = "\improper M70防破片背心"
	desc = "运输艇机组等战斗支援人员穿着的文拉尔纤维防破片背心，智能机枪手偶尔也会使用。虽说叫防破片背心，它其实更擅长挡子弹……"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	icon_state = "pilot"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)

/obj/item/clothing/suit/armor/vest/dutch
	name = "装甲夹克"
	desc = "丛林里很热。有时热得让人喘不过气，有时则如同人间地狱。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "dutch_armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/suit/armor/vest/security
	name = "维兰德-汤谷安保护甲"
	desc = "各种私营安保人员使用的通用文拉尔纤维防弹背心。这件带有维兰德-汤谷公司徽章。"
	icon_state = "armorsec"
	item_state = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)


/obj/item/clothing/suit/armor/vest/warden
	name = "典狱长夹克"
	desc = "带有银色军衔标志和饰纹的装甲夹克。"
	icon_state = "warden_jacket"
	item_state = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/suit/armor/laserproof
	name = "烧蚀防护背心"
	desc = "擅长保护穿戴者免受能量弹伤害的背心。"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/bulletproof
	name = "防弹背心"
	desc = "擅长保护穿戴者免受高速实弹伤害的背心。"
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM


/obj/item/clothing/suit/armor/bulletproof/badge
	icon_state = "bulletproofbadge"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)

/obj/item/clothing/suit/armor/riot
	name = "防暴服"
	desc = "带有厚重衬垫的护甲，用于抵御近战攻击。看起来可能会妨碍行动。"
	icon_state = "riot"
	item_state = "swat_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	siemens_coefficient = 0.5
	time_to_unequip = 20
	time_to_equip = 20

/obj/item/clothing/suit/armor/gladiator
	name = "角斗士护甲"
	desc = "你们看得不尽兴吗？你们不就是为此而来的吗？"
	icon_state = "gladiator"
	item_state = "gladiator"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEJUMPSUIT
	siemens_coefficient = 0.5
	time_to_unequip = 20
	time_to_equip = 20
	allowed = list(
		/obj/item/weapon/sword,
		/obj/item/weapon/shield/riot,
		/obj/item/device/flashlight,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/armor/riot/marine
	name = "\improper M5防暴护甲"
	desc = "经过大幅改装的M2宪兵护甲，用于镇压铁桶脑袋陆战队员的暴乱。会大幅降低移动速度。"
	icon_state = "riot"
	item_state = "swat_suit"
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	time_to_unequip = 20
	time_to_equip = 20

/obj/item/clothing/suit/armor/riot/marine/vintage_riot
	desc = "除了装甲板有些褪色之外，保存得相当完好。"
	icon_state = "old_riot"

/obj/item/clothing/suit/armor/swat
	name = "特警作战服"
	desc = "用于特种作战的重装防护服，可抵御中等程度的伤害。"
	icon_state = "deathsquad"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/effect/decal/ammo_casing,/obj/item/weapon/baton,/obj/item/restraint/handcuffs,/obj/item/tank/emergency_oxygen)
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = BLOCKSHARPOBJ|NOPRESSUREDMAGE
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT
	siemens_coefficient = 0.6


/obj/item/clothing/suit/armor/swat/officer
	name = "军官夹克"
	desc = "用于特种作战的装甲夹克。"
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS


/obj/item/clothing/suit/armor/det_suit
	name = "护甲"
	desc = "一件带有侦探徽章的装甲背心。"
	icon_state = "detective-armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)

//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "反应式传送护甲"
	desc = "有人让我们的研究主管身首异处了！"
	var/active = 0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	slowdown = 1
	flags_atom = FPRINT|CONDUCT
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE

/obj/item/clothing/suit/armor/reactive/IsShield()
	if(active)
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	..()

	active = !active
	if (active)
		to_chat(user, SPAN_NOTICE("反应式护甲已启动。"))
		icon_state = "reactive"
		item_state = "reactive"
	else
		to_chat(user, SPAN_NOTICE("反应式护甲已关闭。"))
		icon_state = "reactiveoff"
		item_state = "reactiveoff"
		add_fingerprint(user)

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	. = ..()
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"






//All of the armor below is mostly unused


/obj/item/clothing/suit/armor/centcomm
	name = "中央指挥部护甲"
	desc = "能够抵御一定伤害的护甲。"
	icon_state = "centcom"
	item_state = "centcom"
	w_class = SIZE_LARGE//bulky item
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	allowed = list(/obj/item/weapon/gun,/obj/item/weapon/baton,/obj/item/restraint/handcuffs,/obj/item/tank/emergency_oxygen)
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy
	name = "重型护甲"
	desc = "一套装甲厚重的防护服，可抵御中等程度的伤害。"
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = SIZE_LARGE//bulky item
	gas_transfer_coefficient = 0.90
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	slowdown = 3
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/tdome
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/tdome/red
	name = "雷霆竞技场护甲（红色）"
	desc = "偏红色的护甲。"
	icon_state = "tdred"
	item_state = "tdred"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "雷霆竞技场护甲（绿色）"
	desc = "颜色像呕吐物的护甲。"
	icon_state = "tdgreen"
	item_state = "tdgreen"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tactical
	name = "战术护甲"
	desc = "特种武器与情报小队常用的护甲，包括带口袋的衬垫背心，以及护肩和护膝。"
	icon_state = "swatarmor"
	item_state = "armor"
	var/obj/item/weapon/gun/holstered = null
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	slowdown = 1
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/tactical/verb/holster()
	set name = "收枪／拔枪"
	set category = "物品"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(!holstered)
		if(!isgun(usr.get_active_hand()))
			to_chat(usr, SPAN_NOTICE("你需要先将枪拿在手中才能收枪。"))
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		if (W.w_class > SIZE_MEDIUM)
			to_chat(usr, SPAN_DANGER("这把枪放不进腰带！"))
			return
		holstered = usr.get_active_hand()
		usr.drop_held_item()
		holstered.forceMove(src)
		usr.visible_message(SPAN_NOTICE("[usr]将[holstered]收进枪套。"), "你将[holstered]收进枪套。")
	else
		if(istype(usr.get_active_hand(),/obj) && istype(usr.get_inactive_hand(),/obj))
			to_chat(usr, SPAN_DANGER("你需要腾出一只手才能拔枪！"))
		else
			if(usr.a_intent == INTENT_HARM)
				usr.visible_message(SPAN_DANGER("[usr]拔出[holstered]，准备射击！"), \
				SPAN_DANGER("你拔出[holstered]，准备射击！"))
			else
				usr.visible_message(SPAN_NOTICE("[usr]拔出[holstered]，将枪口指向地面。"), \
				SPAN_NOTICE("你拔出[holstered]，将枪口指向地面。"))
			usr.put_in_hands(holstered)
		holstered = null

//Non-hardsuit ERT armor.
/obj/item/clothing/suit/armor/vest/ert
	name = "应急响应小队护甲"
	desc = "维兰德-汤谷应急响应小队成员穿着的护甲。"
	icon_state = "ertarmor_cmd"
	item_state = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

//Commander
/obj/item/clothing/suit/armor/vest/ert/command
	name = "应急响应小队指挥官护甲"
	desc = "维兰德-汤谷应急响应小队指挥官穿着的护甲，带有蓝色饰边。"

//Security
/obj/item/clothing/suit/armor/vest/ert/security
	name = "应急响应小队安保护甲"
	desc = "维兰德-汤谷应急响应小队安保成员穿着的护甲，带有红色饰边。"
	icon_state = "ertarmor_sec"

//Engineer
/obj/item/clothing/suit/armor/vest/ert/engineer
	name = "应急响应小队工程护甲"
	desc = "维兰德-汤谷应急响应小队工程成员穿着的护甲，带有橙色饰边。"
	icon_state = "ertarmor_eng"

//Medical
/obj/item/clothing/suit/armor/vest/ert/medical
	name = "应急响应小队医疗护甲"
	desc = "维兰德-汤谷应急响应小队医护成员穿着的护甲，带有红白饰边。"
	icon_state = "ertarmor_med"

/obj/item/clothing/suit/armor/hos
	name = "装甲大衣"
	desc = "用特殊合金强化的大衣，兼具一定防护能力与时尚感。"
	icon_state = "hos"
	item_state = "hos"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEJUMPSUIT
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/hos/jensen
	name = "装甲风衣"
	desc = "用特殊合金强化的风衣，兼具一定防护能力与时尚感。"
	icon_state = "jensencoat"
	item_state = "jensencoat"
	flags_inv_hide = NO_FLAGS
	siemens_coefficient = 0.6
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
