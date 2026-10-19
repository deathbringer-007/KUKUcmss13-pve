/*
 * Contains:
 * Lasertag
 * Costume
 * Misc
 */

/*
 * Lasertag
 */
/obj/item/clothing/suit/bluetag
	name = "蓝色激光对抗护甲"
	desc = "蓝色荣耀，传遍全站。"
	icon_state = "bluetag"
	item_state = "bluetag"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST
	allowed = list(
		/obj/item/weapon/gun,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	siemens_coefficient = 3

/obj/item/clothing/suit/redtag
	name = "红色激光对抗护甲"
	desc = "据说穿上会跑得更快。"
	icon_state = "redtag"
	item_state = "redtag"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST
	allowed = list (
		/obj/item/weapon/gun,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	siemens_coefficient = 3

/*
 * Costume
 */
/obj/item/clothing/suit/pirate
	name = "海盗外套"
	desc = "啊哈！"
	icon_state = "pirate"
	item_state = "pirate"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS


/obj/item/clothing/suit/hgpirate
	name = "海盗船长外套"
	desc = "啊哈！"
	icon_state = "hgpirate"
	item_state = "hgpirate"
	flags_inv_hide = HIDEJUMPSUIT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW


/obj/item/clothing/suit/cyborg_suit
	name = "机械人装束"
	desc = "用于扮演机械人的服装。"
	icon_state = "death"
	item_state = "death"
	flags_atom = FPRINT|CONDUCT
	fire_resist = T0C+5200
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/johnny_coat
	name = "强尼~~大衣"
	desc = "强尼~~"
	icon_state = "johnny"
	item_state = "johnny"

/obj/item/clothing/suit/justice
	name = "正义套装"
	desc = "这看起来简直荒唐。"
	icon_state = "justice"
	item_state = "justice"
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HANDS|BODY_FLAG_LEGS|BODY_FLAG_FEET

/obj/item/clothing/suit/judgerobe
	name = "法官长袍"
	desc = "这件长袍充满威严。"
	icon_state = "judge"
	item_state = "judge"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/storage/fancy/cigarettes,
		/obj/item/spacecash,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	flags_inv_hide = HIDEJUMPSUIT

/obj/item/clothing/suit/storage/wcoat
	name = "马甲"
	desc = "享受优雅又凶残的乐趣。"
	icon_state = "vest"
	item_state = "wcoat"
	blood_overlay_type = "armor"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/effect/decal/ammo_casing,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/device/taperecorder,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/apron/overalls
	name = "蓝色背带工装"
	desc = "牛仔布背带裤，前面有大口袋，深受各类工人喜爱。"
	icon_state = "overalls"
	item_state = "overalls"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/effect/decal/ammo_casing,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/device/taperecorder,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/apron/overalls/tan
	name = "棕褐色背带工装"
	desc = "棕褐色背带裤，前面有大口袋，深受各类工人喜爱。"
	icon_state = "overalls_tan"
	item_state = "overalls_tan"

/obj/item/clothing/suit/storage/apron/overalls/red
	name = "红色背带工装"
	desc = "红褐色背带裤，前面有大口袋，深受各类工人喜爱。"
	icon_state = "overalls_red"
	item_state = "overalls_red"

/obj/item/clothing/suit/syndicatefake
	name = "红色太空服仿制品"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "辛迪加太空服的塑料仿制品，穿上就像真正嗜血的辛迪加特工！这是玩具，不能用于太空！"
	w_class = SIZE_MEDIUM
	allowed = list(
		/obj/item/toy,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HANDS|BODY_FLAG_LEGS|BODY_FLAG_FEET

/obj/item/clothing/suit/hastur
	name = "哈斯塔长袍"
	desc = "不应由人类穿上的长袍。"
	icon_state = "hastur"
	item_state = "hastur"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/imperium_monk
	name = "帝国修士服"
	desc = "你今天杀过异形了吗？"
	icon_state = "imperium_monk"
	item_state = "imperium_monk"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS
	flags_inv_hide = HIDESHOES|HIDEJUMPSUIT


/obj/item/clothing/suit/chickensuit
	name = "炸鸡套装"
	desc = "古老的肯德基帝国很久以前制作的服装。"
	icon_state = "chickensuit"
	item_state = "chickensuit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_inv_hide = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2


/obj/item/clothing/suit/monkeysuit
	name = "猴子套装"
	desc = "看起来像灵长类动物的服装。"
	icon_state = "monkeysuit"
	item_state = "monkeysuit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_HANDS
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2


/obj/item/clothing/suit/holidaypriest
	name = "节庆牧师服"
	desc = "我的孩子，节日真美好。"
	icon_state = "holidaypriest"
	item_state = "holidaypriest"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEJUMPSUIT
	allowed = list(
		/obj/item/weapon/gun,
	)


/obj/item/clothing/suit/cardborg
	name = "纸板机器人套装"
	desc = "普通硬纸箱，侧面开了几个洞。"
	icon_state = "cardborg"
	item_state = "cardborg"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN
	flags_inv_hide = HIDEJUMPSUIT

/*
 * Misc
 */

/obj/item/clothing/suit/straight_jacket
	name = "拘束衣"
	desc = "完全限制穿着者行动的衣服。"
	icon_state = "straight_jacket"
	item_state = "straight_jacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/clothing/suit/straight_jacket/equipped(mob/user, slot)
	if(slot == WEAR_JACKET && ishuman(user))
		var/mob/living/carbon/human/H = user
		H.drop_inv_item_on_ground(H.handcuffed)
		H.drop_l_hand()
		H.drop_r_hand()
	..()

/obj/item/clothing/suit/ianshirt
	name = "旧衬衫"
	desc = "印有伊恩图案的破旧 T 恤，舒适得出奇。虽然还不至于说穿着像被拥抱，但也差不多了。适合睡觉时穿。"
	icon_state = "ianshirt"
	item_state = "ianshirt"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS

/obj/item/clothing/suit/storage/webbing
	name = "外挂携行带"
	desc = "设计为套在连体服外穿着，而不是夹挂在上面。"
	icon_state = "webbing"
	item_state = "webbing"
	allowed = list(
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,

		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/weapon/gun,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)

/obj/item/clothing/suit/storage/utility_vest
	name = "多用途背心"
	desc = "用于收纳工具的多用途背心。"
	icon_state = "synth_utility_vest"
	item_state = "synth_utility_vest"
	allowed = list(
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,

		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/weapon/gun,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)

//Blue suit jacket toggle
/obj/item/clothing/suit/suit/verb/toggle()
	set name = "Toggle Jacket Buttons"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	if(src.icon_state == "suitjacket_blue_open")
		src.icon_state = "suitjacket_blue"
		src.item_state = "suitjacket_blue"
		to_chat(usr, "你扣上了西装夹克的扣子。")
	else if(src.icon_state == "suitjacket_blue")
		src.icon_state = "suitjacket_blue_open"
		src.item_state = "suitjacket_blue_open"
		to_chat(usr, "你解开了西装夹克的扣子。")
	else
		to_chat(usr, "你扣上了[src]上一些想象中的扣子。")
		return
	update_clothing_icon()

//pyjamas
//originally intended to be pinstripes >.>

/obj/item/clothing/under/bluepyjamas
	name = "蓝色睡衣"
	desc = "略显老式的睡衣。"
	icon_state = "blue_pyjamas"
	item_state = "blue_pyjamas"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS

/obj/item/clothing/under/redpyjamas
	name = "红色睡衣"
	desc = "略显老式的睡衣。"
	icon_state = "red_pyjamas"
	item_state = "red_pyjamas"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS

//stripper
/obj/item/clothing/under/stripper
	flags_armor_protection = 0

/obj/item/clothing/under/stripper/mankini
	name = "男式比基尼"
	desc = "正经人绝不会穿这种怪东西。"
	icon_state = "mankini"
	siemens_coefficient = 1

/obj/item/clothing/suit/xenos
	name = "异形套装"
	desc = "由外星生物几丁质外皮制成的服装。"
	icon_state = "xenos"
	item_state = "xenos_helm"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_FEET|BODY_FLAG_ARMS|BODY_FLAG_HANDS
	flags_inv_hide = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 2
//swimsuit
/obj/item/clothing/under/swimsuit
	siemens_coefficient = 1
	flags_armor_protection = 0

/obj/item/clothing/under/swimsuit/black
	name = "黑色泳装"
	desc = "老式黑色泳装。"
	icon_state = "swim_black"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/blue
	name = "蓝色泳装"
	desc = "老式蓝色泳装。"
	icon_state = "swim_blue"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/purple
	name = "紫色泳装"
	desc = "老式紫色泳装。"
	icon_state = "swim_purp"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/green
	name = "绿色泳装"
	desc = "老式绿色泳装。"
	icon_state = "swim_green"
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/red
	name = "红色泳装"
	desc = "老式红色泳装。"
	icon_state = "swim_red"
	siemens_coefficient = 1

/obj/item/clothing/suit/poncho
	name = "斗篷"
	desc = "简单舒适的斗篷。"
	icon_state = "classicponcho"

/obj/item/clothing/suit/poncho/green
	name = "绿色斗篷"
	desc = "经典、不带种族歧视意味的斗篷。这件是绿色的。"
	icon_state = "greenponcho"

/obj/item/clothing/suit/poncho/red
	name = "红色斗篷"
	desc = "经典、不带种族歧视意味的斗篷。这件是红色的。"
	icon_state = "redponcho"

/obj/item/clothing/suit/storage/bomber
	name = "棕色飞行夹克"
	desc = "一件磨损明显的皮革飞行夹克。"
	icon_state = "bomber"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list (
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,

		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/weapon/gun,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)
	min_cold_protection_temperature = T0C
	siemens_coefficient = 0.7
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/bomber/alt
	name = "黑色飞行夹克"
	icon_state = "bomber_2"

/obj/item/clothing/suit/storage/manager
	name = "经理夹克"
	desc = "属于重要人物的衣服，采用隔热材料制成，对各类伤害略有防护。"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	item_state = "manager_suit"
	icon_state = "manager_suit"

	allowed = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/device/flashlight,
	)

	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN

	min_cold_protection_temperature = ICE_COLONY_TEMPERATURE

	storage_slots = 1

	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/director
	name = "总监夹克"
	desc = "属于非常重要人物的夹克，采用隔热材料制成，对各类伤害略有防护。"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	item_state = "director_suit"
	icon_state = "director_suit"

	allowed = list(
		/obj/item/weapon/gun/pistol,
		/obj/item/device/flashlight,
	)

	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN

	min_cold_protection_temperature = ICE_COLONY_TEMPERATURE
	siemens_coefficient = 0

	storage_slots = 3

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_HARDCORE // Immune to tasers
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
