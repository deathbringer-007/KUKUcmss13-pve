/*
 * Job related
 */

//Botonist
/obj/item/clothing/suit/apron
	name = "围裙"
	desc = "一条普通的蓝色围裙。"
	icon_state = "apron"
	item_state = "apron"
	blood_overlay_type = "armor"
	flags_armor_protection = 0
	allowed = list (
		/obj/item/reagent_container/spray/plantbgone,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/seeds,/obj/item/reagent_container/glass/fertilizer,
		/obj/item/tool/minihoe,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)
//Captain
/obj/item/clothing/suit/captunic
	name = "舰长检阅礼服"
	desc = "舰长用于展现身份的礼服。"
	icon_state = "captunic"
	item_state = "bio_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	flags_inv_hide = HIDEJUMPSUIT

/obj/item/clothing/suit/captunic/capjacket
	name = "舰长制服夹克"
	desc = "一件没那么正式的夹克，供舰长日常穿着。"
	icon_state = "capjacket"
	item_state = "bio_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDEJUMPSUIT

//Cultist
/obj/item/clothing/suit/cultist_hoodie
	name = "黑色长袍"
	desc = "看起来诡异阴森，仿佛属于某个邪教。"
	icon_state = "chaplain_hoodie"
	item_state = "chaplain_hoodie"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN

	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROT

	allowed = list(
		/obj/item/weapon/gun/,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

	armor_bio = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_HARDCORE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW

	slowdown = SLOWDOWN_ARMOR_LIGHT
	time_to_equip = 2 SECONDS

//Chaplain
/obj/item/clothing/suit/nun
	name = "修女袍"
	desc = "整个星系最虔诚的装束。"
	icon_state = "nun"
	item_state = "nun"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS
	flags_inv_hide = HIDESHOES|HIDEJUMPSUIT
	allowed = list(
		/obj/item/weapon/gun,
	)

//Chef
/obj/item/clothing/suit/chef
	name = "厨师服"
	desc = "高级厨师穿着的外套。"
	icon_state = "chef"
	item_state = "chef"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	allowed = list (
		/obj/item/tool/kitchen/knife,
		/obj/item/tool/kitchen/knife/butcher,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)

//Chef
/obj/item/clothing/suit/chef/classic
	name = "白色围裙"
	desc = "一条普通、单调的白色厨师围裙。"
	icon_state = "apronchef"
	item_state = "apronchef"
	blood_overlay_type = "armor"
	flags_armor_protection = 0
	allowed = list (
		/obj/item/tool/kitchen/knife,
		/obj/item/tool/kitchen/knife/butcher,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
	)

//Security
/obj/item/clothing/suit/security/navyofficer
	name = "安保人员夹克"
	desc = "这件夹克适合那些安保人员难得觉得安全的特殊场合。"
	icon_state = "officerbluejacket"
	item_state = "officerbluejacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/suit/security/navywarden
	name = "典狱长夹克"
	desc = "最适合想给禁闭室访客留下时尚印象的典狱长。"
	icon_state = "wardenbluejacket"
	item_state = "wardenbluejacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

/obj/item/clothing/suit/security/navyhos
	name = "安保主管夹克"
	desc = "这件衣服专为彰显上级权威而设计。"
	icon_state = "hosbluejacket"
	item_state = "hosbluejacket"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS

//Detective
/obj/item/clothing/suit/storage/det_suit
	name = "大衣"
	desc = "一件18世纪风格的多用途风衣。穿着它的人可不是闹着玩的。"
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/device/analyzer,
		/obj/item/device/multitool,
		/obj/item/device/pipe_painter,
		/obj/item/device/radio,
		/obj/item/device/t_scanner,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/clothing/mask/gas,

		/obj/item/weapon/gun,
		/obj/item/ammo_magazine,
		/obj/effect/decal/ammo_casing,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
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

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/taperecorder,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/det_suit/black
	icon_state = "detective2"

//Forensics
/obj/item/clothing/suit/storage/forensics
	name = "夹克"
	desc = "一件刑事鉴证技术员夹克。"
	item_state = "det_suit"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	allowed = list(
		/obj/item/device/analyzer,
		/obj/item/device/multitool,
		/obj/item/device/pipe_painter,
		/obj/item/device/radio,
		/obj/item/device/t_scanner,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/clothing/mask/gas,

		/obj/item/weapon/gun,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/ammo_magazine,
		/obj/effect/decal/ammo_casing,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/mateba,
		/obj/item/storage/belt/gun/smartpistol,

		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/taperecorder,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/crew_monitor,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/large_holster/katana,
		/obj/item/device/motiondetector,
	)
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/forensics/red
	name = "红色夹克"
	desc = "一件红色刑事鉴证技术员夹克。"
	icon_state = "forensics_red"

/obj/item/clothing/suit/storage/forensics/blue
	name = "蓝色夹克"
	desc = "一件蓝色刑事鉴证技术员夹克。"
	icon_state = "forensics_blue"

//Engineering
/obj/item/clothing/suit/storage/hazardvest
	name = "橙色警示背心"
	desc = "工作区域使用的橙色高可视性背心。"
	icon_state = "hazard"
	item_state = "hazard"
	blood_overlay_type = "armor"
	allowed = list (
		/obj/item/device/analyzer,
		/obj/item/device/multitool,
		/obj/item/device/pipe_painter,
		/obj/item/device/radio,
		/obj/item/device/t_scanner,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/weldingtool,
		/obj/item/tool/wirecutters,
		/obj/item/tool/wrench,
		/obj/item/clothing/mask/gas,

		/obj/item/weapon/gun,
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
	flags_armor_protection = BODY_FLAG_CHEST
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/hazardvest/blue
	name = "蓝色警示背心"
	desc = "工作区域使用的蓝色高可视性背心。"
	icon_state = "hazard_blue"
	item_state = "hazard_blue"

/obj/item/clothing/suit/storage/hazardvest/yellow
	name = "黄色警示背心"
	desc = "工作区域使用的黄色高可视性背心。"
	icon_state = "hazard_yellow"
	item_state = "hazard_yellow"

/obj/item/clothing/suit/storage/hazardvest/black
	name = "黑色警示背心"
	desc = "一件面向小众市场的黑色背心，据说可视性很高，号称用于工作区域。带有超强反光条。标签坚称它完全符合美洲联盟的所有工作场所安全标准。"
	icon_state = "hazard_black"
	item_state = "hazard_black"

/obj/item/clothing/suit/storage/hazardvest/usasf
	name = "军械组夹克"
	desc = "美国航空航天军飞行甲板军械人员穿着的橘红色高可视性夹克。"
	icon_state = "hazard"
	item_state = "hazard"

/obj/item/clothing/suit/storage/hazardvest/usasf/green
	name = "维修组夹克"
	desc = "美国航空航天军维修人员穿着的绿色高可视性夹克，他们负责维护航空航天飞行器及配套起降设备。"
	icon_state = "hazard_green"
	item_state = "hazard_green"

/obj/item/clothing/suit/storage/hazardvest/usasf/purple
	name = "燃料组夹克"
	desc = "美国航空航天军燃料人员穿着的鲜紫色高可视性夹克，他们负责飞行甲板上一切与燃料有关的工作。其他机组人员常称他们为“葡萄”。"
	icon_state = "hazard_purple"
	item_state = "hazard_purple"

/obj/item/clothing/suit/storage/hazardvest/usasf/white
	name = "安全组夹克"
	desc = "美国航空航天军安全人员穿着的灰白色高可视性夹克，他们负责确保飞行甲板作业安全高效地进行。"
	icon_state = "hazard_white"
	item_state = "hazard_white"

/obj/item/clothing/suit/storage/hazardvest/usasf/blue
	name = "调运组夹克"
	desc = "美国航空航天军调运人员穿着的蓝色高可视性夹克，他们负责在机库内移动航空航天飞行器。"
	icon_state = "hazard_blue"
	item_state = "hazard_blue"

/obj/item/clothing/suit/storage/hazardvest/usasf/yellow
	name = "航空作业主管夹克"
	desc = "美国航空航天军飞行甲板主管军官穿着的亮黄色高可视性夹克，他们负责甲板各项事务。"
	icon_state = "hazard_yellow"
	item_state = "hazard_yellow"

//Lawyer
/obj/item/clothing/suit/storage/lawyer/bluejacket
	name = "蓝色西装外套"
	desc = "一件利落的礼服外套。"
	icon_state = "suitjacket_blue_open"
	item_state = "suitjacket_blue_open"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/lawyer/purpjacket
	name = "紫色西装外套"
	desc = "一件利落的礼服外套。"
	icon_state = "suitjacket_purp"
	item_state = "suitjacket_purp"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS

//Internal Affairs
/obj/item/clothing/suit/storage/internalaffairs
	name = "内务部夹克"
	desc = "一件平整光滑的黑色夹克。"
	icon_state = "ia_jacket_open"
	item_state = "ia_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/internalaffairs/verb/toggle()
	set name = "扣上／解开外套纽扣"
	set category = "物品"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	switch(icon_state)
		if("ia_jacket_open")
			src.icon_state = "ia_jacket"
			to_chat(usr, "你扣上了夹克纽扣。")
		if("ia_jacket")
			src.icon_state = "ia_jacket_open"
			to_chat(usr, "你解开了夹克纽扣。")
		else
			to_chat(usr, "你试图扣上[src]的魔术贴，随即意识到自己有多蠢。")
			return
	update_clothing_icon() //so our overlays update

//Windbreakers
/obj/item/clothing/suit/storage/windbreaker
	name = "防风夹克原型"
	desc = "这东西不该在这里……"
	blood_overlay_type = "armor"
	allowed = list(
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
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	var/zip_unzip = FALSE
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/suit/storage/windbreaker/attack_self(mob/user) //Adds UI button
	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		return

	playsound(user, "sound/items/zip.ogg", 10, TRUE)
	zip_unzip(user)

/obj/item/clothing/suit/storage/windbreaker/proc/zip_unzip(mob/user)

	if(zip_unzip)
		icon_state = initial(icon_state)
		to_chat(user, SPAN_NOTICE("你拉上了[src]的拉链。"))

	else
		icon_state = "[initial(icon_state)]_o"
		to_chat(user, SPAN_NOTICE("你拉开了[src]的拉链。"))
	zip_unzip = !zip_unzip

	update_clothing_icon()

/obj/item/clothing/suit/storage/windbreaker/windbreaker_brown
	name = "棕色防风夹克"
	desc = "一件棕色防风夹克。"
	icon_state = "windbreaker_brown"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_gray
	name = "灰色防风夹克"
	desc = "一件灰色防风夹克。"
	icon_state = "windbreaker_gray"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_green
	name = "绿色防风夹克"
	desc = "一件绿色防风夹克。"
	icon_state = "windbreaker_green"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_blue
	name = "蓝色防风夹克"
	desc = "一件蓝色防风夹克。"
	icon_state = "windbreaker_blue"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_yellow
	name = "黄色防风夹克"
	desc = "一件黄色防风夹克。"
	icon_state = "windbreaker_yellow"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_fr
	name = "应急救援人员防风夹克"
	desc = "应急救援人员常穿的棕色防风夹克，带有反光条。"
	icon_state = "windbreaker_fr"

/obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant
	name = "探险者防风夹克"
	desc = "一件棕色防风夹克，上面的各式徽章表明它来自最早进入这片星区的探险队之一。"
	icon_state = "windbreaker_covenant"

//Suspenders
/obj/item/clothing/suit/suspenders
	name = "吊带"
	gender = PLURAL
	desc = "用来吊住裤子。"
	icon = 'icons/obj/items/clothing/belts.dmi'
	icon_state = "suspenders"
	blood_overlay_type = "armor"
	flags_armor_protection = 0
