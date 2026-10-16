#define HAT_GARB_RELAY_ICON_STATE "icon_state"
/obj/item/clothing/head
	name = "头部装备"
	icon = 'icons/obj/items/clothing/hats.dmi'
	flags_armor_protection = BODY_FLAG_HEAD
	flags_bodypart_hidden = BODY_FLAG_HEAD
	flags_equip_slot = SLOT_HEAD
	w_class = SIZE_SMALL
	blood_overlay_type = "helmet"
	var/anti_hug = 0

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

/obj/item/clothing/head/proc/has_garb_overlay()
	return FALSE

/obj/item/clothing/head/cmbandana
	name = "头巾"
	desc = "重武器操作员、佣兵和侦察兵常戴的头巾，轻便又舒适。有两种时髦颜色可选。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "band"
	flags_inv_hide = HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmbandana/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(/obj/item/clothing/head/cmbandana)

/obj/item/clothing/head/cmbandana/tan
	icon_state = "band2"


/obj/item/clothing/head/beanie
	name = "针织帽"
	desc = "一顶标准军用针织帽，非战斗人员和支援人员经常佩戴，不过不再在乎自身安危的战斗人员戴它也并不罕见。因舒适贴合而颇受欢迎。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "beanie_cargo"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beanie/green
	icon_state = "beaniegreen"

/obj/item/clothing/head/beanie/gray
	icon_state = "beaniegray"

/obj/item/clothing/head/beanie/tan
	icon_state = "beanietan"

/obj/item/clothing/head/beret/cm
	name = "\improper 贝雷帽"
	desc = "法国人常戴的帽子，偶尔也会落到钱多得没处花的人手里。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "beret"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beret/cm/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(/obj/item/clothing/head/beret/cm)

/obj/item/clothing/head/beret/cm/tan
	icon_state = "berettan"

/obj/item/clothing/head/beret/cm/tan/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(/obj/item/clothing/head/beret/cm/tan)

/obj/item/clothing/head/beret/cm/red
	icon_state = "beretred"

/obj/item/clothing/head/beret/cm/white
	icon_state = "s_beret"

/obj/item/clothing/head/beret/cm/black
	icon_state = "beret_black"

/obj/item/clothing/head/beret/cm/green
	icon_state = "beret_green"

/obj/item/clothing/head/beret/cm/alpha
	icon_state = "beret_alpha"

/obj/item/clothing/head/beret/cm/bravo
	icon_state = "beret_bravo"

/obj/item/clothing/head/beret/cm/charlie
	icon_state = "beret_charlie"

/obj/item/clothing/head/beret/cm/delta
	icon_state = "beret_delta"

/obj/item/clothing/head/beret/cm/echo
	icon_state = "beret_echo"

/obj/item/clothing/head/beret/cm/foxtrot
	icon_state = "beret_foxtrot"

/obj/item/clothing/head/beret/cm/intel
	icon_state = "beret_intel"

/obj/item/clothing/head/beret/cm/white/civilian
	name = "白色贝雷帽"
	icon_state = "s_beret"

/obj/item/clothing/head/beret/cm/black/civilian
	name = "黑色贝雷帽"
	icon_state = "beret_black"


/obj/item/clothing/head/headband
	name = "头带"
	desc = "不太循规蹈矩的武器操作员常戴的布条。虽然毫无防护能力，但戴起来肯定比标准头盔舒服。有两种时髦颜色可选。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "headband"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	flags_obj = OBJ_NO_HELMET_BAND|OBJ_IS_HELMET_GARB|NO_SNOW_TYPE

/obj/item/clothing/head/headband/Initialize(mapload, ...)
	. = ..()
	select_gamemode_skin(/obj/item/clothing/head/headband)

/obj/item/clothing/head/headband/red
	icon_state = "headbandred"

/obj/item/clothing/head/headband/tan
	icon_state = "headbandtan"

/obj/item/clothing/head/headband/brown
	icon_state = "headbandbrown"

/obj/item/clothing/head/headband/gray
	icon_state = "headbandgray"

/obj/item/clothing/head/headband/rebel
	desc = "用普通布条制成的头带，正面印着“打倒暴君”。"
	icon_state = "rebelband"

/obj/item/clothing/head/headband/alpha
	desc = "一条用耐用布料制成的鲜红色头带，看起来崭新，尚未留下磨损。"
	icon_state = "headbandalpha"

/obj/item/clothing/head/headband/bravo
	desc = "一条用耐用布料制成的橘黄色头带，沾着体力劳动留下的汗水和灰尘。"
	icon_state = "headbandbravo"

/obj/item/clothing/head/headband/charlie
	desc = "一条用耐用布料制成的紫色头带，散发着嫉妒和早餐的气息。"
	icon_state = "headbandcharlie"

/obj/item/clothing/head/headband/delta
	desc = "一条用耐用布料制成的蓝色头带，光是戴上就让你想不顾一切地冲向敌人。"
	icon_state = "headbanddelta"

/obj/item/clothing/head/headband/echo
	desc = "一条用耐用布料制成的海绿色头带，经历多次漫长的潜行任务和敌后突袭，颜色已褪去不少。"
	icon_state = "headbandecho"

/obj/item/clothing/head/headband/foxtrot
	desc = "一条用耐用布料制成的棕色头带，多年的低温休眠让它摸起来仍然冰凉。"
	icon_state = "headbandfoxtrot"

/obj/item/clothing/head/headband/intel
	desc = "一条用耐用布料制成的黑色头带，戴上让你觉得自己像个秘密特工。"
	icon_state = "headbandintel"

/obj/item/clothing/head/headband/rambo
	desc = "它迎风飘扬，桀骜不驯，如同戴着它的人。"
	icon = 'icons/obj/items/clothing/hats.dmi'
	icon_state = "headband_rambo"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_0.dmi'
	)

/obj/item/clothing/head/headset
	name = "\improper USCM头戴耳机"
	desc = "与标准耳机配合使用的大型耳机，大到无法与其他头饰同时佩戴。无线电员和军官常用。"
	icon_state = "headset"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/sulacocap
	name = "\improper 金箭号舰帽"
	desc = "驻扎在金箭号上的陆战队员可以购买佩戴的便帽。虽然只能遮阳，但比头盔舒适得多。"
	icon_state = "sulacocap"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	var/helmet_overlays[]
	var/flipped_cap = FALSE
	var/list/flipping_message = list(
		"flipped" = "你把帽子转到后面！看起来像个傻瓜。",
		"unflipped" = "你把帽子转回正面。这下好多了。"
		)
	var/base_cap_icon
	var/flags_marine_hat = HAT_GARB_OVERLAY|HAT_CAN_FLIP
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmcap
	name = "作训帽"
	desc = "作为非战斗制服配发的作训帽。虽然只能遮阳，但比头盔舒适得多。"
	icon_state = "cap"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	flags_atom = FPRINT|NO_SNOW_TYPE
	var/helmet_overlays[]
	var/flipped_cap = FALSE
	var/list/flipping_message = list(
		"flipped" = "你把帽子转到后面！看起来像个傻瓜。",
		"unflipped" = "你把帽子转回正面。这下好多了。"
		)
	var/base_cap_icon
	var/flags_marine_hat = HAT_GARB_OVERLAY|HAT_CAN_FLIP
	var/obj/item/storage/internal/headgear/pockets
	var/list/allowed_hat_items = list(
						/obj/item/storage/fancy/cigarettes/emeraldgreen = "hat_cig_cig",
						/obj/item/storage/fancy/cigarettes/kpack = "hat_cig_kpack",
						/obj/item/storage/fancy/cigarettes/lucky_strikes = "hat_cig_ls",
						/obj/item/storage/fancy/cigarettes/wypacket = "hat_cig_wypack",
						/obj/item/storage/fancy/cigarettes/lady_finger = "hat_cig_lf",
						/obj/item/storage/fancy/cigarettes/blackpack = "hat_cig_blackpack",
						/obj/item/storage/fancy/cigarettes/arcturian_ace = "hat_cig_aapack",
						/obj/item/tool/pen = "hat_pen_black",
						/obj/item/tool/pen/blue = "hat_pen_blue",
						/obj/item/tool/pen/red = "hat_pen_red",
						/obj/item/clothing/glasses/welding = "welding-c",
						/obj/item/clothing/glasses/mgoggles = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/prescription = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/black = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/black/prescription = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/orange = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/orange/prescription = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/green = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/glasses/mgoggles/green/prescription = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/prop/helmetgarb/helmet_nvg = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/prop/helmetgarb/helmet_nvg/cosmetic = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/prop/helmetgarb/helmet_nvg/marsoc = HAT_GARB_RELAY_ICON_STATE,
						/obj/item/clothing/head/headband = "hat_headbandgreen",
						/obj/item/clothing/head/headband/tan = "hat_headbandtan",
						/obj/item/clothing/head/headband/red = "hat_headbandred",
						/obj/item/clothing/head/headband/brown = "hat_headbandbrown",
						/obj/item/clothing/head/headband/gray = "hat_headbandgray",
						/obj/item/clothing/head/headband/alpha = "hat_headbandalpha",
						/obj/item/clothing/head/headband/bravo = "hat_headbandbravo",
						/obj/item/clothing/head/headband/charlie = "hat_headbandcharlie",
						/obj/item/clothing/head/headband/delta = "hat_headbanddelta",
						/obj/item/clothing/head/headband/echo = "hat_headbandecho",
						/obj/item/clothing/head/headband/foxtrot = "hat_headbandfoxtrot",
						/obj/item/clothing/head/headband/foxtrot = "hat_headbandintel",
						/obj/item/prop/helmetgarb/lucky_feather = "lucky_feather",
						/obj/item/prop/helmetgarb/lucky_feather/blue = "lucky_feather_blue",
						/obj/item/prop/helmetgarb/lucky_feather/purple = "lucky_feather_purple",
						/obj/item/prop/helmetgarb/lucky_feather/yellow = "lucky_feather_yellow",
						/obj/item/tool/pen/fountain = "fountainpen",
						)
	var/storage_slots = 1
	var/storage_slots_reserved_for_garb = 1
	var/storage_max_w_class = SIZE_TINY
	var/storage_max_storage_space = 4
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmcap/Initialize(mapload, ...)
	. = ..()
	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	base_cap_icon = icon_state
	helmet_overlays = list("item") //To make things simple.

	pockets = new(src)
	pockets.storage_slots = storage_slots + storage_slots_reserved_for_garb
	pockets.slots_reserved_for_garb = storage_slots_reserved_for_garb
	pockets.max_w_class = storage_max_w_class
	pockets.bypass_w_limit = allowed_hat_items
	pockets.max_storage_space = storage_max_storage_space

/obj/item/clothing/head/cmcap/attack_hand(mob/user)
	if(loc != user)
		..(user)
		return
	if(pockets.handle_attack_hand(user))
		..()

/obj/item/clothing/head/cmcap/MouseDrop(over_object, src_location, over_location)
	if(pockets.handle_mousedrop(usr, over_object))
		..()

/obj/item/clothing/head/cmcap/attackby(obj/item/W, mob/user)
	..()
	return pockets.attackby(W, user)

/obj/item/clothing/head/cmcap/on_pocket_insertion()
	update_icon()

/obj/item/clothing/head/cmcap/on_pocket_removal()
	update_icon()

/obj/item/clothing/head/cmcap/update_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

/obj/item/clothing/head/cmcap/get_mob_overlay(mob/user_mob, slot)
	var/image/return_image = ..()
	if(slot != WEAR_HEAD)
		return return_image

	if(length(pockets.contents) && (flags_marine_hat & HAT_GARB_OVERLAY))
		for(var/obj/garb_object in pockets.contents)
			if(garb_object.type in allowed_hat_items)
				var/garb_state = allowed_hat_items[garb_object.type]
				if(garb_state == HAT_GARB_RELAY_ICON_STATE)
					garb_state = "hat_[garb_object.icon_state]"
				var/image/garb_image = overlay_image('icons/mob/humans/onmob/helmet_garb.dmi', "[garb_state]", color, RESET_COLOR)
				return_image.overlays += garb_image

	return return_image

/obj/item/clothing/head/cmcap/has_garb_overlay()
	return flags_marine_hat & HAT_GARB_OVERLAY

/obj/item/clothing/head/cmcap/verb/fliphat()
	set name = "正戴／反戴帽子"
	set category = "物品"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.is_mob_incapacitated())
		return
	if(!(flags_marine_hat & HAT_CAN_FLIP))
		to_chat(usr, SPAN_WARNING("[src]无法反戴！"))
		return

	flags_marine_hat ^= HAT_FLIPPED

	if(flags_marine_hat & HAT_FLIPPED)
		to_chat(usr, flipping_message["flipped"])
		icon_state = base_cap_icon + "_b"
	else
		to_chat(usr, flipping_message["unflipped"])
		icon_state = base_cap_icon

	update_clothing_icon()

/obj/item/clothing/head/cmcap/boonie
	name = "\improper 丛林帽"
	desc = "一顶柔软的宽檐丛林帽。只能遮阳挡雨，但非常舒适。"
	icon_state = "booniehat_jungle"
	flipping_message = list(
		"flipped" = "你收起帽子的下颏带。希望风不会把帽子吹走……",
		"unflipped" = "你把帽子的下颏带扣在下巴下面。安心总比体面更重要。"
		)

/obj/item/clothing/head/cmcap/boonie/tan
	icon_state = "booniehat_desert"

/obj/item/clothing/head/cmcap/boonie/snow
	icon_state = "booniehat_snow"

/obj/item/clothing/head/cmcap/co
	name = "\improper USCM指挥官军帽"
	icon_state = "cocap"
	desc = "殖民地陆战队高级军官常戴的帽子。虽然没有防护能力，一些军官仍会在战场佩戴，以便他人辨认自己。"

/obj/item/clothing/head/cmcap/co/formal
	name = "\improper USCM指挥官白色礼帽"
	icon_state = "co_formalhat_white"
	desc = "殖民地陆战队高级军官佩戴的礼帽。"
	flags_marine_hat = HAT_GARB_OVERLAY

/obj/item/clothing/head/cmcap/co/formal/black
	name = "\improper USCM指挥官黑色礼帽"
	icon_state = "co_formalhat_black"

/obj/item/clothing/head/cmcap/khaki
	name = "\improper 卡其色作训帽"
	desc = "一顶卡其色作训帽。"
	icon_state = "cap_khaki"

/obj/item/clothing/head/cmcap/snow
	name = "\improper 寒区作训帽"
	desc = "寒冷环境中佩戴的作训帽。"
	icon_state = "cap_snow"

/obj/item/clothing/head/cmcap/desert
	name = "\improper 沙漠作训帽"
	desc = "一顶沙漠作战服配套作训帽。"
	icon_state = "cap_desert"

/obj/item/clothing/head/cmcap/bridge
	name = "\improper 绿色USCM作业帽"
	desc = "殖民地陆战队设计的加厚帽子，便于在野外或维修作业中更好地抵御恶劣天气。材质厚实，呈橄榄绿，正面用醒目的黑字印着“USCM”。"
	icon_state = "cap_operations"

/obj/item/clothing/head/cmcap/bridge/tan
	name = "\improper 卡其色USCM作业帽"
	desc = "殖民地陆战队设计的加厚帽子，便于在野外或维修作业中更好地抵御恶劣天气。材质厚实，呈沙漠棕褐色，正面用醒目的黑字印着“USCM”。"
	icon_state = "cap_khaki"

/obj/item/clothing/head/cmcap/flap
	name = "\improper 丛林远征帽"
	desc = "作为非战斗制服配发的便帽。虽然只能遮阳，但比头盔舒适得多。这顶带有护颈布，能挡住照向脖子的阳光。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "flapcap_jungle"
	flags_marine_hat = HAT_GARB_OVERLAY

/obj/item/clothing/head/cmcap/flap/desert
	name = "\improper 沙漠远征帽"
	icon_state = "flapcap_desert"

/obj/item/clothing/head/cmcap/flap/snow
	name = "\improper 雪地远征帽"
	desc = "作为非战斗制服配发的便帽。虽然只能防风挡雪，但比头盔舒适得多。这顶带有护颈护耳布，用于保暖。"
	icon_state = "flapcap_snow"

/obj/item/clothing/head/cmcap/flap/canc
	name = "\improper 护颈帽"
	desc = "作为非战斗制服配发的便帽，采用CANC军队配色。"
	icon_state = "canc_flapcap"

/obj/item/clothing/head/cmcap/reporter
	name = "战地记者帽"
	desc = "一顶可靠的帽子，适合战地记者可能遇到的各种地形。"
	icon_state = "cc_flagcap"
	item_state = "cc_flagcap"

/obj/item/clothing/head/cmcap/weyyu
	name = "\improper 维兰德-汤谷便帽"
	desc = "维兰德-汤谷安保人员佩戴的米白色便帽。"
	icon_state = "pmc_hat"
	flags_marine_hat = HAT_GARB_OVERLAY

/obj/item/clothing/head/cmo
	name = "\improper 首席医疗官大檐帽"
	desc = "配发给高级文职医疗官的大檐帽，看起来有那么一点滑稽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "cmohat"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmcap/corrections
	name = "深蓝色作训帽"
	desc = "一顶深蓝色作训帽。"
	icon_state = "corrections"
	item_state = "corrections"

//============================//BERETS\\=================================\\
//=======================================================================\\
//Berets DO NOT have armor, so they have their own category. PMC caps are helmets, so they're in helmets.dm.
/obj/item/clothing/head/beret/marine
	name = "陆战队军官贝雷帽"
	desc = "一顶印有USCM徽章的贝雷帽，散发着威严与权威。"
	icon_state = "beret_badge"

/obj/item/clothing/head/beret/marine/mp
	name = "\improper USCM宪兵贝雷帽"
	icon_state = "beretred"
	desc = "一顶印有殖民地陆战队宪兵徽章的贝雷帽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	black_market_value = 25

/obj/item/clothing/head/beret/marine/mp/warden
	name = "\improper USCM宪兵典狱长大檐帽"
	icon_state = "warden"
	desc = "一顶印有殖民地陆战队宪兵尉官徽章的大檐帽，通常由殖民地陆战队舰艇上的典狱长佩戴。"

/obj/item/clothing/head/beret/marine/mp/cmp
	name = "\improper USCM宪兵长贝雷帽"
	desc = "一顶印有殖民地陆战队宪兵中尉徽章的贝雷帽，闪耀着腐败权威的光芒，还沾着一块甜甜圈污渍。"
	icon_state = "beretwo"
	black_market_value = 30

/obj/item/clothing/head/beret/marine/mp/mppeaked
	name = "\improper USCM宪兵大檐帽"
	desc = "殖民地陆战队宪兵佩戴的大檐帽。它让你想起曾在历史书上读到的某件事。"
	icon_state = "mppeaked"

/obj/item/clothing/head/beret/marine/mp/mpcap
	name = "\improper USCM宪兵棒球帽"
	desc = "一顶棒球帽，通常由作风较随意的殖民地陆战队宪兵佩戴。"
	icon_state = "mpcap"

/obj/item/clothing/head/beret/marine/mp/provost
	name = "\improper USCM军法监察贝雷帽"
	icon_state = "beretwo"
	desc = "一顶印有殖民地陆战队宪兵徽章的贝雷帽。"

/obj/item/clothing/head/beret/marine/mp/provost/senior
	name = "\improper USCM高级军法监察贝雷帽"
	icon_state = "coblackberet"
	desc = "一顶印有殖民地陆战队宪兵徽章的贝雷帽。"

/obj/item/clothing/head/beret/marine/mp/provost/chief
	name = "\improper USCM军法监察指挥贝雷帽"
	icon_state = "pvciberet"

/obj/item/clothing/head/beret/marine/commander
	name = "陆战队指挥官贝雷帽"
	desc = "一顶印有指挥官徽章的贝雷帽，佩戴者可能会感到沉重责任压在头肩上。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "coberet"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	black_market_value = 30

/obj/item/clothing/head/beret/marine/commander/dress
	name = "陆战队少校白色贝雷帽"
	icon_state = "codressberet"
	desc = "一顶印有少校徽章的白色贝雷帽，耀眼的白色彰显权力与格调。"

/obj/item/clothing/head/beret/marine/commander/black
	name = "陆战队少校黑色贝雷帽"
	icon_state = "coblackberet"
	desc = "一顶印有少校徽章的黑色贝雷帽，利落的黑色彰显权力与格调。"

/obj/item/clothing/head/beret/marine/commander/council
	name = "陆战队上校贝雷帽"
	desc = "一顶印有中校徽章的蓝色贝雷帽。蓝色象征忠诚、自信和政治手腕——真正上校的核心素质。"
	icon_state = "cdreberet"

/obj/item/clothing/head/beret/marine/commander/councilchief
	name = "陆战队上校贝雷帽"
	desc = "一顶深蓝色定制贝雷帽，象征着那位上校。绝对不是什么将军的化名。"
	icon_state = "cdrechiefberet"

/obj/item/clothing/head/marine/peaked
	name = "陆战队大檐帽"
	desc = "一顶大檐帽，佩戴者可能会感到沉重责任压在头肩上。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "marine_formal"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/marine/peaked/service
	name = "陆战队常服大檐帽"
	desc = "一顶大檐帽，佩戴者可能会感到沉重责任压在头肩上。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "marine_service"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/marine/peaked/captain
	name = "陆战队指挥官大檐帽"
	desc = "一顶印有指挥官徽章的大檐帽，佩戴者可能会感到沉重责任压在头肩上。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "copeaked"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	black_market_value = 30

/obj/item/clothing/head/marine/peaked/captain/white
	name = "指挥官白色礼服大檐帽"
	desc = "指挥官的白色海军式大檐帽，佩戴者可能会感到沉重责任压在头上。"
	icon_state = "co_peakedcap_white"

/obj/item/clothing/head/marine/peaked/captain/black
	name = "指挥官黑色礼服大檐帽"
	desc = "指挥官的黑色海军式大檐帽，佩戴者可能会感到沉重责任压在头上。"
	icon_state = "co_peakedcap_black"

/obj/item/clothing/head/beret/marine/chiefofficer
	name = "大副贝雷帽"
	desc = "一顶印有海军少校徽章的贝雷帽，散发着黑暗气息，或许能腐蚀灵魂。"
	icon_state = "hosberet"

/obj/item/clothing/head/beret/marine/techofficer
	name = "技术军官贝雷帽"
	desc = "一顶印有尉官徽章的贝雷帽，不知为何透着一股高效的气息……"
	icon_state = "e_beret_badge"

/obj/item/clothing/head/beret/marine/logisticsofficer
	name = "后勤军官贝雷帽"
	desc = "一顶印有尉官徽章的贝雷帽，让人肃然起敬。"
	icon_state = "beret_badge"

/obj/item/clothing/head/beret/marine/ro
	name = "\improper USCM军需官贝雷帽"
	desc = "一顶印有中士徽章的贝雷帽，象征着辛勤工作和见不得光的买卖。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "ro_beret"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

//==========================//PROTECTIVE\\===============================\\
//=======================================================================\\

/obj/item/clothing/head/ushanka
	name = "护耳毛帽"
	desc = "最适合西伯利亚的冬天，对吧？"
	icon_state = "ushankadown"
	item_state = "ushankadown"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	..()

	if(src.icon_state == "ushankadown")
		src.icon_state = "ushankaup"
		src.item_state = "ushankaup"
		to_chat(user, "你掀起毛帽的护耳。")
	else
		src.icon_state = "ushankadown"
		src.item_state = "ushankadown"
		to_chat(user, "你放下毛帽的护耳。")


/obj/item/clothing/head/bearpelt
	name = "熊皮帽"
	desc = "毛茸茸的。"
	icon_state = "bearpelt"
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST|BODY_FLAG_ARMS
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR

/obj/item/clothing/head/ivanberet
	name = "\improper 黑色贝雷帽"
	desc = "特种单位军官佩戴的帽子。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "ivan_beret"
	item_state = "ivan_beret"
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/CMB
	name = "\improper 殖民地执法局便帽"
	desc = "一顶醒目地印有“CMB”缩写的黑色便帽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "cmbcap"
	flags_inv_hide = NO_FLAGS

/obj/item/clothing/head/freelancer
	name = "\improper 自由佣兵装甲便帽"
	desc = "一顶结实的自由佣兵便帽，防护能力比外表看起来更好。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "freelancer_cap"
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/freelancer/beret
	name = "\improper 自由佣兵装甲贝雷帽"
	icon_state = "freelancer_beret"

/obj/item/clothing/head/militia
	name = "\improper 民兵装甲兜帽"
	desc = "部分民兵使用的大兜帽，用于在边疆隐蔽身份。采用结实纤维制成，能为头部提供一定防护。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "rebel_hood"
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR

/obj/item/clothing/head/militia/bucket
	name = "水桶"
	desc = "这只金属桶似乎加装了衬垫和下颏带，还在“正面”开了一道观察缝。大概是用来戴在头上的，或许能提供防护。"
	icon_state = "bucket"

/obj/item/clothing/head/general
	name = "\improper 将官装甲军帽"
	desc = "一顶结实的将官军帽，防护能力比外表看起来更好。别像个毛头小子一样把它扔掉换头盔。"
	icon_state = "general_helmet"
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/durag
	name = "包头巾"
	desc = "用制式领巾临时改成的包头巾，很适合防止汗水流进眼睛，也能保护头发。"
	icon_state = "durag"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	flags_atom = NO_SNOW_TYPE
	flags_inv_hide = HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/durag/black
	icon_state = "duragblack"
	desc = "用黑色领巾临时改成的包头巾，很适合防止汗水流进眼睛，也能保护头发。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'

/obj/item/clothing/head/skullcap
	name = "贴头帽"
	desc = "一顶贴合头部的布帽，很适合防止汗水流进眼睛，也能保护头发。"
	icon_state = "skullcap"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	flags_atom = NO_SNOW_TYPE
	flags_inv_hide = HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/drillhat
	name = "\improper USCM教官帽"
	desc = "训练军士佩戴的正式帽子。把你那胡子修整好！"
	icon_state = "drillhat"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

#undef HAT_GARB_RELAY_ICON_STATE

//==========================//DRESS BLUES\\===============================\\
//=======================================================================\\

/obj/item/clothing/head/marine/dress_cover
	name = "陆战队蓝礼服帽"
	desc = "传奇陆战队蓝礼服的配套大檐帽，自19世纪以来几乎未变。抛光徽标骄傲地立在白布上。"
	icon = 'icons/mob/humans/onmob/contained/marinedressblues.dmi'
	icon_state = "e_cap"
	item_state = "e_cap"
	contained_sprite = TRUE

/obj/item/clothing/head/marine/dress_cover/officer
	name = "陆战队军官蓝礼服帽"
	desc = "传奇陆战队蓝礼服的配套大檐帽，自19世纪以来几乎未变。金色饰带和镀银徽标彰显军官身份。"
	icon_state = "o_cap"
	item_state = "o_cap"

/obj/item/clothing/head/owlf_hood
	name = "\improper OWLF热隐蔽兜帽"
	desc = "这顶兜帽连接着一套内置热隐身技术的高科技服装。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "owlf_hood"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	item_state = "owlf_hood"


//=ROYAL MARINES=\\

/obj/item/clothing/head/beanie/royal_marine
	name = "皇家陆战突击队针织帽"
	desc = "一顶标准军用针织帽。"
	icon_state = "rmc_beanie"
	item_state = "rmc_beanie"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beanie/royal_marine/turban
	name = "皇家陆战突击队缠头巾"
	desc = "皇家陆战突击队使用的标准军用缠头巾。这类头巾颇为稀有，深受美洲联盟收藏家珍视。"
	icon_state = "rmc_turban"
	item_state = "rmc_turban"

/obj/item/clothing/head/cmcap/royal_marine
	name = "皇家陆战突击队贝雷帽"
	desc = "三世界帝国皇家陆战突击队佩戴的绿色贝雷帽。自豪地戴上它吧。"
	icon_state = "rmc_beret"
	item_state = "rmc_beret"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	flags_marine_hat = HAT_GARB_OVERLAY
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	allowed_hat_items = list(
		/obj/item/prop/helmetgarb/helmet_nvg = "icon_state",
		/obj/item/prop/helmetgarb/helmet_nvg/cosmetic = "icon_state",
		/obj/item/prop/helmetgarb/helmet_nvg/marsoc = "icon_state",
	)
