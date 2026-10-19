/obj/item/clothing/suit/storage/jacket/marine //BASE ITEM
	name = "陆战队夹克"
	//This really should not be spawned
	desc = "这鬼东西怎么会在这里？"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	armor_melee = CLOTHING_ARMOR_VERYLOW
	armor_bullet = CLOTHING_ARMOR_VERYLOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW //marginally better against shrapnel.
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	allowed = list(
		/obj/item/weapon/gun/,
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
		/obj/item/storage/belt/gun/type47,
		/obj/item/device/flashlight,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio,
		/obj/item/tank/emergency_oxygen,
		/obj/item/tool/crowbar,
		/obj/item/tool/pen,
		/obj/item/storage/large_holster/machete,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK)

	//Buttons
	var/has_buttons = FALSE
	var/buttoned = TRUE
	var/initial_icon_state

/obj/item/clothing/suit/storage/jacket/marine/proc/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	if(src.buttoned == TRUE)
		src.icon_state = "[initial_icon_state]_o"
		src.buttoned = FALSE
		to_chat(usr, SPAN_INFO("你解开了[src]的扣子。"))
	else
		src.icon_state = "[initial_icon_state]"
		src.buttoned = TRUE
		to_chat(usr, SPAN_INFO("你扣上了[src]的扣子。"))
	update_clothing_icon()

/obj/item/clothing/suit/storage/jacket/marine/Initialize()
	. = ..()
	if(has_buttons)
		verbs += /obj/item/clothing/suit/storage/jacket/marine/proc/toggle

//Marine service & tanker jacket + MP themed variants
/obj/item/clothing/suit/storage/jacket/marine/service
	name = "陆战队常服外套"
	desc = "USCMC 常服外套，通常配发给军官。理论上能防破片和手枪弹，但最好别拿命试。"
	has_buttons = TRUE
	flags_atom = NO_SNOW_TYPE
	icon_state = "coat_officer"
	initial_icon_state = "coat_officer"

/obj/item/clothing/suit/storage/jacket/marine/pilot
	name = "M70B1 轻型防破片夹克"
	desc = "牺牲体积与防护来改善人体工学的 M70 变体。对破片的防护大致相当于军官常服外套。"
	icon_state = "pilot_alt"
	has_buttons = TRUE
	initial_icon_state = "pilot_alt"

/obj/item/clothing/suit/storage/jacket/marine/RO
	name = "军需官夹克"
	desc = "USCM 人员穿着的绿色夹克，背部印有美洲联盟旗帜。"
	icon_state = "RO_jacket"
	icon = 'icons/obj/items/clothing/suits.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_0.dmi'
	)
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/jacket/marine/service/mp
	name = "宪兵常服外套"
	desc = "采用 USCMC 宪兵配色的陆战队常服外套。由于当地规定要求穿着执勤护甲，通常用不上。"
	has_buttons = TRUE
	icon_state = "coat_mp"
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "coat_mp"

/obj/item/clothing/suit/storage/jacket/marine/service/warden
	name = "宪兵监狱官常服夹克"
	desc = "美国殖民地陆战队舰船上宪兵监狱官使用的陆战队常服夹克。讽刺的是，大多数舰船都要求宪兵值勤时穿全套护甲，因此在岗监狱官很少穿它。适合整夜盯着监控屏幕，任由烟蒂在周围堆积。"
	has_buttons = TRUE
	icon_state = "coat_warden"
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "coat_warden"

/obj/item/clothing/suit/storage/jacket/marine/service/cmp
	name = "宪兵长常服夹克"
	desc = "USCM 舰上宪兵使用的陆战队常服外套。讽刺的是，大多数舰船要求宪兵穿全套护甲，执勤时几乎用不上它。深受那些莫名想让自己闻起来像甜甜圈的人喜爱。"
	has_buttons = TRUE
	icon_state = "coat_cmp"
	flags_atom = NO_SNOW_TYPE
	initial_icon_state = "coat_cmp"

/obj/item/clothing/suit/storage/jacket/marine/service/tanker
	name = "坦克乘员夹克"
	desc = "为需在重型机械内外工作的人提供的舒适夹克。袖内特殊材料一旦卷入机器就会将其卡停，保护穿戴者免受伤害。"
	has_buttons = TRUE
	flags_atom = NO_SNOW_TYPE
	icon_state = "jacket_tanker"
	initial_icon_state = "jacket_tanker"

/obj/item/clothing/suit/storage/jacket/marine/chef
	name = "伙食技师夹克"
	desc = "闻起来有香草味。象征地位与权力，虽然有点花哨。"
	icon_state = "chef_jacket"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/jacket/marine/dress
	name = "陆战队正式常服外套"
	desc = "散发着香草味，象征地位与权力，虽然有点招摇。"
	icon_state = "coat_formal"
	initial_icon_state = "coat_formal"
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_atom = NO_SNOW_TYPE
	has_buttons = TRUE

/obj/item/clothing/suit/storage/jacket/marine/dress/officer
	name = "陆战队军官礼服夹克"
	desc = "USCM 指挥官穿着的礼服外套。"
	icon_state = "co_jacket"
	has_buttons = FALSE
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_MEDAL)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/bomber
	name = "指挥官飞行夹克"
	desc = "仿照旧时代飞行员服装的飞行夹克，是高阶人员经典而时髦的选择。"
	has_buttons = TRUE
	icon_state = "co_bomber"
	initial_icon_state = "co_bomber"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/white
	name = "指挥官白色礼服夹克"
	desc = "适合炎热天气阅兵的白色礼服上衣，明亮、洁净、无瑕，带有金色装饰。"
	icon_state = "co_formal_white"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/black
	name = "指挥官灰色礼服夹克"
	desc = "适合需要深沉低调配色场合的灰色礼服上衣，将利落克制的风格与金色装饰结合。"
	icon_state = "co_formal_black"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/suit
	name = "指挥官蓝色礼服大衣"
	desc = "高级军官的海军制式蓝色礼服外套，献给追求风度与威严的人。"
	icon_state = "co_suit"

/obj/item/clothing/suit/storage/jacket/marine/dress/officer/falcon
	name = "舰长猎鹰夹克"
	desc = "专为高级军官定制的翻新夹克内衬。加上新的面料层、袖口、前口袋和背部定制猎鹰刺绣后，它已经成为一件完整的衣服。无论是凉爽周日的驾车出游，还是寒冷的秋夜，它都能让穿着者保持温暖。"
	icon_state = "co_falcon"

/obj/item/clothing/suit/storage/jacket/marine/dress/general
	name = "将官夹克"
	desc = "带有金色金属饰边的黑色风衣，华丽、防护出色、夸张至极。适合国王——或者这里的将军。口袋还不少。"
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_state = "general_jacket"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_0.dmi'
	)
	item_state = "general_jacket"
	has_buttons = FALSE
	storage_slots = 4
	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	w_class = SIZE_MEDIUM

/obj/item/clothing/suit/storage/jacket/marine/dress/general/executive
	name = "总监夹克"
	desc = "饰有金色金属滚边的黑色风衣。华丽、防护出色，也十分夸张。适合国王——或者说，适合总监。有不少口袋。"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat
	name = "舰桥大衣"
	desc = "配发给美国殖民地陆战队军官的厚重合成羊毛大衣。采用经典设计，无论是在空调寒冷的作战指挥中心，还是荒芜星球上的凄冷夜晚，都十分舒适。这件是舰长礼服蓝配色。"
	has_buttons = FALSE
	item_state = "bridge_coat"
	icon_state = "bridge_coat"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/jacket/marine/dress/bridge_coat_grey
	name = "舰桥大衣"
	desc = "配发给美国殖民地陆战队军官的厚重合成羊毛大衣。采用经典设计，无论是在空调寒冷的作战指挥中心，还是荒芜星球上的凄冷夜晚，都十分舒适。这件是黑色的。"
	has_buttons = FALSE
	item_state = "bridge_coat_grey"
	icon_state = "bridge_coat_grey"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_MEDAL)

/obj/item/clothing/suit/storage/jacket/marine/service/aso
	name = "辅助支援军官夹克"
	desc = "舒适的军官背心，适合那些长时间盯着一排排数字、检查从刀具到鱼雷再到整架运输艇的人员。"
	icon_state = "aso_jacket"
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST
	has_buttons = FALSE


//=========================//PROVOST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/jacket/marine/provost
	name = "\improper 军法监察夹克"
	desc = "带有军法监察徽记的挺括夹克。"
	icon_state = "provost_jacket"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR)

/obj/item/clothing/suit/storage/jacket/marine/provost/chief
	name = "\improper 军法监察指挥夹克"
	desc = "带有军法监察徽记的挺括夹克。"
	icon_state = "provostci_jacket"

/obj/item/clothing/suit/storage/jacket/marine/provost/coat
	name = "\improper 军法监察大衣"
	desc = "军法监察军官的挺括大衣。"
	icon_state = "provost_coat"

/obj/item/clothing/suit/storage/jacket/marine/provost/coat/marshal
	name = "\improper 军法监察长大衣"
	icon_state = "provost_coat_marshal"


//=========================//DRESS BLUES\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/jacket/marine/dress/blues
	name = "陆战队士兵蓝色礼服夹克"
	desc = "传奇陆战队蓝色礼服的外套，自 19 世纪以来几乎没有改变。陆战队员，你穿的是历史，别让先辈失望。"
	icon = 'icons/mob/humans/onmob/contained/marinedressblues.dmi'
	icon_state = "e_jacket"
	item_state = "e_jacket"
	has_buttons = FALSE
	item_state_slots = null
	contained_sprite = TRUE

/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco
	name = "陆战队士官蓝色礼服夹克"
	desc = "传奇陆战队蓝色礼服的外套，自 19 世纪以来几乎没有改变。配有功勋士官的装饰，传承尽显其中。"
	icon_state = "nco_jacket"
	item_state = "nco_jacket"

/obj/item/clothing/suit/storage/jacket/marine/dress/blues/officer
	name = "陆战队军官蓝色礼服夹克"
	desc = "传奇陆战队蓝色礼服的外套，自 19 世纪以来几乎没有改变。采用军官制服利落的深色设计。"
	icon_state = "o_jacket"
	item_state = "o_jacket"

//==================Combat Correspondent==================\\

/obj/item/clothing/suit/storage/jacket/marine/reporter
	name = "战地记者夹克"
	desc = "献给最讲究时尚的战地记者的夹克。"
	icon_state = "cc_brown"
	item_state = "cc_brown"
	flags_atom = NO_SNOW_TYPE
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/reporter/green
	icon_state = "cc_green"
	item_state = "cc_green"


/obj/item/clothing/suit/storage/jacket/marine/reporter/black
	icon_state = "cc_black"
	item_state = "cc_black"

/obj/item/clothing/suit/storage/jacket/marine/reporter/blue
	icon_state = "cc_blue"
	item_state = "cc_blue"


//==================Corporate Liaison==================\\

/obj/item/clothing/suit/storage/jacket/marine/vest
	name = "棕色背心"
	desc = "一件棕色休闲背心。"
	icon_state = "vest_brown"
	item_state = "vest_brown"
	flags_atom = NO_SNOW_TYPE
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/vest/tan
	name = "棕褐色背心"
	desc = "一件棕褐色休闲背心。"
	icon_state = "vest_tan"
	item_state = "vest_tan"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/vest/grey
	name = "灰色背心"
	desc = "一件灰色休闲背心。"
	icon_state = "vest_grey"
	item_state = "vest_grey"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate
	name = "卡其色西装外套"
	desc = "一件卡其色西装外套。"
	icon_state = "corporate_ivy"
	item_state = "corporate_ivy"
	flags_atom = NO_SNOW_TYPE
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/formal
	name = "正式西装外套"
	desc = "一件象牙白西装外套，右侧翻领别着维兰德-汤谷公司徽章。"
	icon_state = "corporate_formal"
	item_state = "corporate_formal"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/black
	name = "黑色西装外套"
	desc = "一件黑色西装外套。"
	icon_state = "corporate_black"
	item_state = "corporate_black"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/brown
	name = "棕色西装外套"
	desc = "一件棕色西装外套。"
	icon_state = "corporate_brown"
	item_state = "corporate_brown"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/blue
	name = "蓝色西装外套"
	desc = "一件蓝色西装外套。"
	icon_state = "corporate_blue"
	item_state = "corporate_blue"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/corporate/grey
	name = "灰色西装夹克"
	desc = "一件灰色西装夹克。"
	icon_state = "corporate_grey"
	item_state = "corporate_grey"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/bomber
	name = "卡其色飞行夹克"
	desc = "深受各地空间站工作人员与蓝领工人喜爱的卡其色飞行夹克。"
	icon_state = "jacket_khaki"
	item_state = "jacket_khaki"
	flags_atom = NO_SNOW_TYPE
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/bomber/red
	name = "红色飞行夹克"
	desc = "深受各地空间站工作人员与蓝领工人喜爱的红棕色飞行夹克。"
	icon_state = "jacket_red"
	item_state = "jacket_red"
	has_buttons = FALSE

/obj/item/clothing/suit/storage/jacket/marine/bomber/grey
	name = "灰色飞行夹克"
	desc = "深受各地空间站工作人员与蓝领工人喜爱的蓝灰色飞行夹克。"
	icon_state = "jacket_grey"
	item_state = "jacket_grey"
	has_buttons = FALSE

//==================UPP==================\\

/obj/item/clothing/suit/storage/jacket/marine/upp
	name = "\improper 进步人民联盟常服夹克"
	desc = "进步人民联盟常服夹克，分散嵌有少量对位芳纶插片，只能提供最基本的防护。"
	icon_state = "upp_coat_service"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/suit/storage/jacket/marine/upp/mss
	name = "\improper 太空安全部制服夹克"
	desc = "太空安全部常服夹克，分散嵌有少量对位芳纶插片，只能提供最基本的防护。"
	icon_state = "upp_coat_mss"

/obj/item/clothing/suit/storage/jacket/marine/upp/coldweather
	name = "\improper UL2 冬季常服夹克"
	desc = "进步人民联盟制式冬季常服夹克，分散嵌有少量对位芳纶插片，提供最基本的防护，并配有个人照明单元。"
	icon_state = "upp_coat_officer"

/obj/item/clothing/suit/storage/jacket/marine/upp/naval
	name = "\improper 进步人民联盟海军步兵夹克"
	desc = "制式海军步兵常服夹克，分散嵌有少量对位芳纶插片，只能提供最基本的防护。"
	icon_state = "upp_coat_naval"
