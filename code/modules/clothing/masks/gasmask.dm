
/obj/item/clothing/mask/gas
	name = "防毒面具"
	desc = "一副民用全面罩，可连接供气设备，并过滤空气中的有害气体。"
	icon_state = "gas_alt"
	flags_inventory = COVERMOUTH | COVEREYES | ALLOWINTERNALS | BLOCKGASEFFECT | ALLOWREBREATH | ALLOWCPR
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDELOWHAIR
	flags_cold_protection = BODY_FLAG_HEAD
	flags_equip_slot = SLOT_FACE|SLOT_WAIST
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	w_class = SIZE_SMALL
	item_state = "gas_alt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.9
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	siemens_coefficient = 0.9
	vision_impair = VISION_IMPAIR_NONE
	var/gas_filter_strength = 1 //For gas mask filters
	var/list/filtered_gases = list("phoron", "sleeping_agent", "carbon_dioxide")

/obj/item/clothing/mask/gas/kutjevo
	name = "库特耶沃防尘面罩"
	desc = "戴在脸上的呼吸防护面罩，可过滤库特耶沃空气中常见的有害颗粒。"
	icon_state = "kutjevo_respirator"
	item_state = "kutjevo_respirator"

/obj/item/clothing/mask/gas/military
	name = "\improper M5防毒面具"
	desc = "殖民地陆战队的制式防毒面具，属于旨在替代MOPP防护装备的现代化计划。"
	icon_state = "m5"
	item_state = "m5"
	flags_obj = OBJ_NO_HELMET_BAND|OBJ_IS_HELMET_GARB
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/mask/gas/military/on_enter_storage(obj/item/storage/internal/helmet_internal_inventory)
	..()
	if(!istype(helmet_internal_inventory))
		return
	var/obj/item/clothing/head/helmet/helmet_item = helmet_internal_inventory.master_object

	if(!istype(helmet_item))
		return

	helmet_item.flags_inventory |= BLOCKGASEFFECT
	helmet_item.flags_inv_hide |= HIDEFACE

/obj/item/clothing/mask/gas/military/on_exit_storage(obj/item/storage/internal/helmet_internal_inventory)
	..()
	if(!istype(helmet_internal_inventory))
		return
	var/obj/item/clothing/head/helmet/helmet_item = helmet_internal_inventory.master_object

	if(!istype(helmet_item))
		return

	helmet_item.flags_inventory &= ~(BLOCKGASEFFECT)
	helmet_item.flags_inv_hide &= ~(HIDEFACE)

/obj/item/clothing/mask/gas/military/upp
	name = "\improper ShMB/4防毒面具"
	desc = "进步人民联盟联合武装力量及许多联盟民间组织使用的制式防毒面具。"
	icon_state = "pfb"
	item_state = "pfb"

/obj/item/clothing/mask/gas/pve_mopp
	name = "\improper M2 MOPP防护面罩"
	desc = "M2 MOPP防护面罩带有全包覆头罩，可牢固连接到MOPP防护服上，能够抵御多种放射性和生物威胁。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "cbrn_hood"
	item_state = "cbrn_hood"
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/mask/gas/pmc
	name = "\improper 战术过滤面罩"
	desc = "一种精密过滤面罩，正在为进入军用市场进行试验，目前仅限维兰德-汤谷战术小队使用。"
	item_state = "helmet"
	icon_state = "pmc_mask"
	anti_hug = 3
	vision_impair = VISION_IMPAIR_NONE
	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_NONE
	flags_inventory = COVERMOUTH|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEFACE
	flags_equip_slot = SLOT_FACE

/obj/item/clothing/mask/gas/pmc/marsoc
	name = "\improper 特种部队装甲头套"
	desc = "专为最强防护和最酷造型设计。可抵御面部攻击、过滤毒素并隐藏穿戴者身份。"
	icon_state = "balaclava"

/obj/item/clothing/mask/gas/pmc/upp
	name = "\improper UPP装甲突击头套"
	icon_state = "upp_mask"

/obj/item/clothing/mask/gas/pmc/leader
	name = "\improper M8型装甲头套"
	desc = "既能隐藏使用者身份，又能过滤空气的装甲头套。这件看起来属于一位高级军官。"
	icon_state = "officer_mask"

/obj/item/clothing/mask/gas/bear
	name = "战术头套"
	desc = "铁熊部队穿着的优质头套。"
	icon_state = "bear_mask"
	anti_hug = 2



//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "瘟疫医生面具"
	desc = "经典设计的现代化版本。这副面具既能过滤弗燃素，也能连接供气设备。"
	icon_state = "plaguedoctor"
	item_state = "gas_mask"
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE

/obj/item/clothing/mask/gas/swat
	name = "\improper 特警面罩"
	desc = "一副贴合面部、可连接供气设备的战术面罩。"
	icon_state = "swat"
	siemens_coefficient = 0.7
	flags_armor_protection = BODY_FLAG_FACE|BODY_FLAG_EYES

/obj/item/clothing/mask/gas/swat/navy
	name = "\improper 飞行面罩"
	desc = "一副贴合面部的面罩，供可能在出击中暴露于太空真空的飞行员使用。"

/obj/item/clothing/mask/gas/syndicate
	name = "辛迪加面罩"
	desc = "一副贴合面部、可连接供气设备的战术面罩。"
	icon_state = "swat"
	siemens_coefficient = 0.7

/obj/item/clothing/mask/gas/voice
	name = "防毒面具"
	desc = "一副可连接供气设备的全面罩，里面似乎装着奇怪的电子装置。"

/obj/item/clothing/mask/gas/voice/space_ninja
	name = "忍者面罩"
	desc = "一副贴合面部的面罩，既能过滤空气，又能彰显后现代时尚。"
	icon_state = "s-ninja"
	item_state = "s-ninja_mask"
	siemens_coefficient = 0.2
	vision_impair = VISION_IMPAIR_NONE

/obj/item/clothing/mask/gas/clown_hat
	name = "小丑假发与面具"
	desc = "真正恶作剧大师的面部装扮。没有假发和面具，小丑就不完整。"
	icon_state = "clown"
	item_state = "clown_hat"
	vision_impair = VISION_IMPAIR_NONE
	black_market_value = 25

/obj/item/clothing/mask/gas/mime
	name = "默剧面具"
	desc = "传统的默剧演员面具，表情有些诡异。"
	icon_state = "mime"
	item_state = "mime"
	vision_impair = VISION_IMPAIR_NONE

/obj/item/clothing/mask/gas/monkeymask
	name = "猴子面具"
	desc = "扮演猴子时使用的面具。"
	icon_state = "monkeymask"
	item_state = "monkeymask"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	vision_impair = VISION_IMPAIR_NONE

/obj/item/clothing/mask/gas/fake_mustache
	name = "假胡子"
	desc = "几乎以假乱真。"
	icon_state = "souto_man"
	vision_impair = VISION_IMPAIR_NONE
	unacidable = TRUE
// flags_item = NODROP|DELONDROP
	flags_inventory = CANTSTRIP|COVEREYES|COVERMOUTH|ALLOWINTERNALS|ALLOWREBREATH|BLOCKGASEFFECT|ALLOWCPR|BLOCKSHARPOBJ

//=ROYAL MARINES=\\

/obj/item/clothing/mask/gas/pmc/royal_marine
	name = "\improper L7防毒面具"
	desc = "三世界帝国皇家陆战突击队成员使用的L7防毒面具。"
	icon_state = "rmc_mask"
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	flags_inventory = COVERMOUTH|COVEREYES|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH|ALLOWCPR
