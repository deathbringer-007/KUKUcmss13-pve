// SS13 DONATOR CUSTOM ITEM STORAGE ZONE OF MAGICAL HAPPINESS APOPHIS - LAST UPDATE - 14JUN2016

//#######################################################\\
//###################### TEMPLATES ######################\\
//#######################################################\\

//HEAD TEMPLATE (for Helmets/Hats/Berets)  ONLY TAKE NAME, DESC, ICON_STATE, AND ITEM_STATE.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/head/helmet/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	//DON'T GRAB STUFF BETWEEN THIS LINE
	icon = 'icons/obj/items/clothing/hats.dmi'
	icon_override = 'icons/mob/humans/onmob/head_0.dmi'
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/fluff/verb/toggle_squad_markings()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("现在不行！"))
		return

	to_chat(usr, SPAN_NOTICE("你[flags_marine_helmet & HELMET_SQUAD_OVERLAY? "隐藏" : "显示"]了小队标识。"))
	flags_marine_helmet ^= HELMET_SQUAD_OVERLAY
	usr.update_inv_head()

/obj/item/clothing/head/helmet/marine/fluff/verb/toggle_garb_overlay()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("现在不行！"))
		return

	to_chat(usr, SPAN_NOTICE("你[flags_marine_helmet & HELMET_GARB_OVERLAY? "隐藏" : "显示"]了头盔装饰。"))
	flags_marine_helmet ^= HELMET_GARB_OVERLAY
	update_icon()

	//AND THIS LINE
//END HEAD TEMPLATE

//MASK TEMPLATE (for masks)  ONLY TAKE NAME, DESC, ICON_STATE, ITEM_STATE,  AND ITEM_COLOR.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/mask/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	//DON'T GRAB STUFF BETWEEN THIS LINE
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	//AND THIS LINE

//END MASK TEMPLATE

//SUIT TEMPLATE (for armor/exosuit)  ONLY TAKE NAME, DESC, ICON_STATE, AND ITEM_STATE.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/suit/storage/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	//DON'T GRAB STUFF BETWEEN THIS LINE
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_override = 'icons/mob/humans/onmob/suit_0.dmi'  //Don't fuck with this in the future please.
	flags_inventory = BLOCKSHARPOBJ
	flags_marine_armor = NO_FLAGS

//LIGHT SUIT TEMPLATE (for armor/exosuit)  ONLY TAKE NAME, DESC, ICON_STATE, AND ITEM_STATE.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/suit/storage/marine/light/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	//DON'T GRAB STUFF BETWEEN THIS LINE
	icon = 'icons/obj/items/clothing/suits.dmi'
	icon_override = 'icons/mob/humans/onmob/suit_0.dmi'  //Don't fuck with this in the future please.
	flags_inventory = BLOCKSHARPOBJ
	flags_marine_armor = NO_FLAGS

/obj/item/clothing/suit/storage/marine/fluff/verb/toggle_squad_markings()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("现在不行！"))
		return

	to_chat(usr, SPAN_NOTICE("你[flags_marine_armor & ARMOR_SQUAD_OVERLAY? "隐藏" : "显示"]了小队标识。"))
	flags_marine_armor ^= ARMOR_SQUAD_OVERLAY
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/marine/fluff/verb/toggle_shoulder_lamp()
	set src in usr
	if(!ishuman(usr)) return

	if(usr.is_mob_incapacitated() || !isturf(usr.loc))
		to_chat(usr, SPAN_WARNING("现在不行！"))
		return

	to_chat(usr, SPAN_NOTICE("你[flags_marine_armor & ARMOR_LAMP_OVERLAY? "隐藏" : "显示"]了肩灯。"))
	flags_marine_armor ^= ARMOR_LAMP_OVERLAY
	update_icon(usr)


	//AND THIS LINE
//END SUIT TEMPLATE

//FEET TEMPLATE (for shoes)  ONLY TAKE NAME, DESC, ICON_STATE, ITEM_STATE,  AND ITEM_COLOR.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/shoes/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null
//END FEET TEMPLATE

/obj/item/storage/backpack/marine/fluff
	xeno_types = null

/obj/item/storage/backpack/marine/satchel/fluff
	xeno_types = null

/obj/item/clothing/gloves/marine/fluff   //MARINE GLOVES TEMPLATE
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	icon_state = null
	item_state = null

/obj/item/clothing/glasses/fluff
	flags_inventory = COVEREYES


//#######################################################\\
//#################### GENERIC SET(S) ###################\\
//#######################################################\\

/obj/item/clothing/head/helmet/marine/fluff/standard_helmet //GENERIC DONOR
	name = "欧米伽小组头盔"
	desc = "欧米伽小组佩戴的头盔。捐赠者物品。"
	icon_state = "standard_helmet"
	item_state = "standard_helmet"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/suit/storage/marine/fluff/standard_armor //GENERIC DONOR
	name = "欧米伽小组护甲"
	desc = "欧米伽小组穿戴的护甲。捐赠者物品。"
	icon_state = "standard_armor"
	item_state = "standard_armor"

/obj/item/clothing/under/marine/fluff/standard_jumpsuit //GENERIC DONOR
	name = "欧米伽小组制服"
	desc = "欧米伽小组穿着的制服。捐赠者物品。"
	icon_state = "standard_jumpsuit"
	worn_state = "standard_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/turtleneck //GENERIC DONOR
	name = "秘密行动高领衫"
	desc = "一件售价900美元的黑色高领衫，仅以最纯净的阿塞拜疆羊绒织成。捐赠者物品。"
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	flags_jumpsuit = FALSE


/obj/item/clothing/mask/fluff/balaclava //GENERIC DONOR
	name = "巴拉克拉瓦头套"
	desc = "一顶用于遮住面孔的黑色巴拉克拉法头套。免责声明：可能并不能真的遮住你的脸……捐赠者物品。"
	item_state = "balaclava"
	icon_state = "balaclava"
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/glasses/fluff/eyepatch //GENERIC DONOR
	name = "眼罩"
	desc = "酷炫程度+10。捐赠者物品。"
	icon_state = "eyepatch"
	item_state = "eyepatch"

//  EXO-SUITS/ARMORS COSMETICS  ////////////////////////////////////////////////

/obj/item/clothing/suit/storage/marine/fluff/santa //CKEY=tophatpenguin
	name = "圣诞老人套装"
	desc = "节日气氛拉满！捐赠者物品。"
	icon_state = "santa"
	item_state = "santa"

/obj/item/clothing/suit/storage/marine/fluff/commandercookies //CKEY=commandercookies
	name = "挂有弹药的陆战队护甲"
	desc = "挂着弹药的陆战队作战背心。捐赠物品。"
	icon_state = "bulletproofammo"
	item_state = "bulletproofammo"

/obj/item/clothing/suit/storage/marine/fluff/cia
	name = "中央情报局夹克"
	desc = "背后印有 CIA 字样的装甲夹克。捐赠物品。"
	icon_state = "cia"
	item_state = "cia"

/obj/item/clothing/suit/storage/marine/fluff/obey //CKEY=obeystylez (UNIQUE)
	name = "秘密行动烧蚀装甲背心"
	desc = "一件看起来很时髦的护甲。捐赠物品。"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"

/obj/item/clothing/suit/storage/marine/fluff/sas_juggernaut //CKEY=sasoperative (UNIQUE)
	name = "重装战士护甲"
	desc = "一件看起来很时髦的护甲。捐赠物品。"
	icon_state = "skinnerarmor"
	item_state = "skinnerarmor"

/obj/item/clothing/suit/storage/marine/fluff/penguin //CKEY=tophatpenguin
	name = "长风衣"
	desc = "一件18世纪风格的长风衣。穿上它的人，想必不是来闹着玩的。捐赠物品。"
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/marine/fluff/wright //CKEY=wrightthewrong
	name = "特警护甲"
	desc = "一件看起来很时髦的护甲。捐赠物品。"
	icon_state = "deathsquad"
	item_state = "swat_suit"

/obj/item/clothing/suit/storage/marine/fluff/tyran //CKEY=tyran68
	name = "特警护甲"
	desc = "一件看起来很时髦的护甲。捐赠物品。"
	icon_state = "deathsquad"
	item_state = "swat_suit"

/obj/item/clothing/suit/storage/marine/fluff/tristan //CKEY=tristan63
	name = "M3X式护甲"
	desc = "一套实验型 M3式护甲，增设贴合身体的陶瓷板，以加强弹道防护。可惜这些护板似乎已损坏得无法修复，只剩下普通 M3护甲的防护水平。捐赠物品。"
	icon_state = "tristan_armor"
	item_state = "tristan_armor"

/obj/item/clothing/suit/storage/marine/light/fluff/sas_legion //CKEY=sasoperative (UNIQUE)
	name = "M3游骑兵护甲"
	desc = "一套 M3式游骑兵护甲，想必已经相当少见了。捐赠物品。"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	icon_state = "rangerarmor"
	item_state = "rangerarmor"

/obj/item/clothing/suit/storage/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "毁灭战士护甲"
	desc = "一位著名地球战士的制服……捐赠物品。"
	item_state = "doom_armor"
	icon_state = "doom_armor"

/obj/item/clothing/suit/storage/marine/fluff/totalanarchy //CKEY=totalanarchy
	name = "利奥的护甲"
	desc = "用旧的雇佣兵护甲。捐赠物品。"
	item_state = "merc_armor"
	icon_state = "merc_armor"

/obj/item/clothing/suit/storage/marine/fluff/sadokist2 //CKEY=sadokist
	name = "重型安保硬式防护服"
	desc = "配有厚重装甲的安保硬式防护服。捐赠物品。"
	icon_state = "rig-secTG"
	item_state = "rig-secTG"

/obj/item/clothing/suit/storage/marine/fluff/vintage //CKEY=vintagepalmer
	name = "带波纹的复古护甲"
	desc = "一件复古捐赠物品。"
	icon_state = "bulletproof"
	item_state = "bulletproof"

/obj/item/clothing/suit/storage/marine/fluff/john56 //CKEY=johnkilla56
	name = "红色长风衣"
	desc = "一件特殊的长风衣，以令各地灰潮闻风丧胆而出名。捐赠物品。"
	icon_state = "hos"
	item_state = "hos"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/marine/light/fluff/biolock //CKEY=biolock
	name = "M3-L定制护甲"
	desc = "由标准 M3式护甲减重裁改而成，带有大量改装和定制涂装。捐赠物品。"
	item_state = "bio_armor"
	icon_state = "bio_armor"

/obj/item/clothing/suit/storage/marine/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "精英作战护甲"
	desc = "残留着历次战斗血迹的作战护甲。独一无二的捐赠物品。"
	icon_state = "hecuarmor_u"
	item_state = "hecuarmor_u"

/obj/item/clothing/suit/storage/marine/fluff/limo //CKEY=limodish (UNIQUE)
	name = "血红色硬式防护服"
	desc = "看起来像一套硬式防护服。独一无二的捐赠物品。"
	icon_state = "syndicate"
	item_state = "syndicate"

/obj/item/clothing/suit/storage/marine/fluff/Zynax //CKEY=zynax
	name = "戈尔卡背心"
	desc = "俄式迷彩背心。独一无二的捐赠物品。"
	icon_state = "gorkavest_u"
	item_state = "gorkavest_u"

/obj/item/clothing/suit/storage/marine/fluff/bwoincognito //CKEY=bwoincognito
	name = "废土夹克"
	desc = "一位古老废土客的夹克……独一无二的捐赠物品。"
	icon_state = "riotjacket_u"
	item_state = "riotjacket_u"

/obj/item/clothing/suit/storage/marine/fluff/adjective
	name = "安保主管长风衣"
	desc = "一件象征权威的长风衣。捐赠物品。"
	icon_state = "jensencoat"
	item_state = "jensencoat"

/obj/item/clothing/suit/storage/marine/fluff/fickmacher //CKEY=fickmacher (UNIQUE)
	name = "塞莱娜的长风衣"
	desc = "一件象征权威的长风衣。捐赠物品。"
	icon_state = "jensencoat"
	item_state = "jensencoat"

/obj/item/clothing/suit/storage/marine/fluff/juninho
	name = "烧蚀护甲"
	desc = "一套相当先进的护甲。捐赠物品。"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"

/obj/item/clothing/suit/storage/marine/fluff/mitii
	name = "米娅的长风衣"
	desc = "一件象征权威的长风衣。捐赠物品。"
	icon_state = "hos"
	item_state = "hos"

/obj/item/clothing/suit/storage/marine/fluff/gromi
	name = "鹰眼的夹克"
	desc = "一位著名战地医生穿过的夹克。独一无二的捐赠物品。"
	icon_state = "hawkeye_jacket_u"
	item_state = "hawkeye_jacket_u"

/obj/item/clothing/suit/storage/marine/fluff/chimera //CKEY=theultimatechimera
	name = "布雷特的长风衣"
	desc = "一件象征权威的长风衣。捐赠物品。"
	icon_state = "hos"
	item_state = "hos"

/obj/item/clothing/suit/storage/marine/fluff/devilzhand
	name = "“坦克”的长风衣"
	desc = "一件象征权威的长风衣。捐赠物品。"
	icon_state = "jensencoat"
	item_state = "jensencoat"


/obj/item/clothing/suit/storage/marine/fluff/feweh //CKEY=feweh
	name = "平克的烧蚀装甲背心"
	desc = "你见过最时髦的防弹背心。捐赠物品。"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"

/obj/item/clothing/suit/storage/marine/fluff/crazyh206
	name = "圣殿骑士护甲"
	desc = "某种你认不出的神圣护甲……捐赠物品。" //Add UNIQUE if Unique
	icon_state = "templar"
	item_state = "templar"

/obj/item/clothing/suit/storage/marine/fluff/tranquill
	name = "杰西·平克曼的韩·索罗套装"
	desc = "一位著名走私者穿过的衣服。独一无二的捐赠物品。"
	item_state = "solo_jumpsuit_u"
	icon_state = "solo_jumpsuit_u"

/obj/item/clothing/suit/storage/marine/fluff/oneonethreeeight //CKEY=oneonethreeeight
	name = "迷彩护甲"
	desc = "林地迷彩护甲。捐赠物品。" //Add UNIQUE if Unique
	icon_state = "camo_armor"
	item_state = "camo_armor"

/obj/item/clothing/suit/storage/marine/fluff/dino //CKEY=dinobubba7
	name = "潜行服"
	desc = "一位著名间谍使用过的旧衣服，闻起来有股烟味……捐赠物品。"
	icon_state = "snakesuit"
	item_state = "snakesuit"

/obj/item/clothing/suit/storage/marine/fluff/fickmacher2 //CKEY=fickmacher (UNIQUE)
	name = "哈特下士的护甲"
	desc = "左臂看起来是机械的，等等，什么？捐赠物品。"
	icon_state = "hartarmor"
	item_state = "hartarmor"

/obj/item/clothing/suit/storage/marine/fluff/paradox //CKEY=paradox1i7
	name = "圣殿骑士护甲"
	desc = "远古英雄留下的神圣护甲……捐赠物品。"
	icon_state = "templar2"
	item_state = "templar2"

/obj/item/clothing/suit/storage/marine/fluff/chris1464 //CKEY=chris1464
	name = "雇佣兵护甲"
	desc = "某个老牌雇佣兵公司的护甲，希望它还撑得住……捐赠物品。"
	icon_state = "merc_vest"
	item_state = "merc_vest"

/obj/item/clothing/suit/storage/marine/fluff/radical
	name = "赏金猎人护甲"
	desc = "一位古老赏金猎人的护甲。捐赠物品。" //Add UNIQUE if Unique
	icon_state = "boba_armor"
	item_state = "boba_armor"

/obj/item/clothing/suit/storage/marine/fluff/stobarico //CKEY=stobarico (UNIQUE)
	name = "英国海军将官制服"
	desc = "一位海军将官的古老制服。捐赠物品。"
	icon_state = "lordadmiral"
	item_state = "lordadmiral"

/obj/item/clothing/suit/storage/marine/fluff/starscream //CKEY=starscream123 (NOT UNIQUE)
	name = "卡达尔·侯赛因的护甲"
	desc = "略有磨损和破裂。捐赠物品。"
	icon_state = "merc_armor"
	item_state = "merc_armor"

/obj/item/clothing/suit/storage/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X护甲"
	desc = "为对抗异形的陆战队员设计的新一代躯干护甲系统，原本配有特殊耐酸聚合物涂层和加强弹道防护。不过，这套原型恰好不具备这两项功能。捐赠物品。"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	icon_state = "steelpoint_armor"
	item_state = "steelpoint_armor"

/obj/item/clothing/suit/storage/marine/fluff/valentine //CKEY=markvalentine
	name = "肖基的护甲"
	desc = "好得令人震惊的护甲。捐赠物品。"
	icon_state = "ertarmor_sec"
	item_state = "ertarmor_sec"


/obj/item/clothing/suit/storage/marine/fluff/nickiskool //CKEY=nickiskool
	name = "星爵的夹克"
	desc = "谁？捐赠物品。"
	icon_state = "star_jacket"
	item_state = "star_jacker"

/obj/item/clothing/suit/storage/marine/fluff/sadokist //CKEY=sadokist
	name = "T15特种作战护甲"
	desc = "为特战干员制作的紧密编织护甲，兼顾灵活性与轻武器防护。它似乎专为某个人量身定制，衣领上印着“塔妮娅”的名字。捐赠物品。"
	icon_state = "sadokist_armor"
	item_state = "sadokist_armor"

/obj/item/clothing/suit/storage/marine/fluff/fairedan //CKEY=fairedan (UNIQUE)
	name = "货船船员飞行夹克"
	desc = "洛克马特 CM-88B“野牛”星际货船船员的制式夹克。内侧标签上有数字1809246……捐赠物品。"
	icon_state = "Fairedan_vest"
	item_state = "Fairedan_vest"

/obj/item/clothing/suit/storage/marine/fluff/jackmcintyre //CKEY=jackmcintyre (UNIQUE)
	name = "外骨骼夹克"
	desc = "某种奇怪的外骨骼夹克。印着 USCM 字样，下方隐约还能看到褪色的 ATLAS 字样……独一无二的捐赠物品。"
	icon_state = "Adam_jacket_u"
	item_state = "Adam_jacket_u"

/obj/item/clothing/suit/storage/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "欧米伽政委护甲"
	desc = "欧米伽小组那些令人敬畏的政委所穿的护甲。独一无二的捐赠物品。"
	icon_state = "commisar_armor_u"
	item_state = "commisar_armor_u"

/obj/item/clothing/suit/storage/marine/fluff/medicae_armor //CKEY=graciegrace0 (UNIQUE)
	name = "欧米伽军医护甲"
	desc = "欧米伽小组医疗部队所穿的护甲。独一无二的捐赠物品。"
	icon_state = "medicae_armor_u"
	item_state = "medicae_armor_u"

/obj/item/clothing/suit/storage/marine/fluff/dudewithatude
	name = "彩虹外套"
	desc = "由“友谊”的魔力驱动，可以敞开或扣合。独一无二的捐赠物品。"
	icon_state = "AlexLermire_u"
	item_state = "AlexLermire_u"
	var/open = FALSE

/obj/item/clothing/suit/storage/marine/fluff/dudewithatude/verb/verb_toggleopen()
	set src in usr
	set category = "Object"
	set name = "Toggle Open"
	if(!open)
		icon_state = "AlexLermire_on_u"
		item_state = "AlexLermire_on_u"
		open = TRUE
	else
		open = FALSE
		icon_state = "AlexLermire_u"
		item_state = "AlexLermire_u"
	update_icon()
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/marine/fluff/titus
	name = "ODST护甲"
	desc = "一套模样古怪的护甲，带有褪色的 ODST 字样……独一无二的捐赠物品。"
	icon_state = "leviathan13_u"
	item_state = "leviathan13_u"

/obj/item/clothing/suit/storage/marine/fluff/trblackdragon //CKEY=trblackdragon
	name = "奇异护甲"
	desc = "看起来来自另一个时空……独一无二的捐赠物品。"
	icon_state = "TR-Donor_u"
	item_state = "TR-Donor_u"

/obj/item/clothing/suit/storage/marine/fluff/zegara //CKEY=zegara
	name = "黑粉配色护甲"
	desc = "亮黑色护甲，点缀着粉色装饰……独一无二的捐赠物品。"
	icon_state = "zegara_armor_u"
	item_state = "zegara_armor_u"

/obj/item/clothing/suit/storage/marine/fluff/eonoc
	name = "棕色外套"
	desc = "你夺不走我的天空……捐赠物品。"
	icon_state = "Eonoc_coat"
	item_state = "Eonoc_coat"
	var/open = FALSE

/obj/item/clothing/suit/storage/marine/fluff/eonoc/verb/verb_toggleopen()
	set src in usr
	set category = "Object"
	set name = "Toggle Open"
	if(!open)
		icon_state = "Eonoc_coat_o"
		item_state = "Eonoc_coat_o"
		open = TRUE
	else
		open = FALSE
		icon_state = "Eonoc_coat"
		item_state = "Eonoc_coat"
	update_icon()
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/marine/fluff/kaila
	name = "定制工程护甲"
	desc = "一套施有定制涂装的工程护甲。捐赠物品。"
	icon_state = "kailas_armor"
	item_state = "kailas_armor"

/obj/item/clothing/suit/storage/marine/fluff/fridrich
	name = "纯黑实验服"
	desc = "非常时髦。捐赠物品。"
	icon_state = "Reznoriam"
	item_state = "Reznoriam"

/obj/item/clothing/suit/storage/marine/fluff/lostmixup
	name = "和平行者战斗服"
	desc = "一位远古英雄的制服，背面的标签上写着“斯内克”……独一无二的捐赠物品。"
	icon_state = "lostmixup_u"
	item_state = "lostmixup_u"

/obj/item/clothing/suit/storage/marine/fluff/laser243
	name = "褪色游骑兵护甲"
	desc = "看起来是用几种护甲与布料拼成的，大概出自某个末日后的世界……捐赠物品。"
	icon_state = "laser243"
	item_state = "laser243"

/obj/item/clothing/suit/storage/marine/fluff/killaninja12
	name = "太空牛仔护甲"
	desc = "有人叫你太空牛仔，也有人叫你爱情悍匪……独一无二的捐赠物品。"
	icon_state = "killaninja12_u"
	item_state = "killaninja12_u"

/obj/item/clothing/suit/storage/marine/fluff/forwardslashn
	name = "弹道防护原型甲"
	desc = "一套精良弹道护甲的原型版本。独一无二的捐赠物品。"
	icon_state = "forwardslashn_u"
	item_state = "forwardslashn_u"




// HELMETS/HATS/BERETS COSMETICS  ////////////////////////////////////////////////
/obj/item/clothing/head/helmet/marine/fluff/santahat //CKEY=tophatpenguin
	name = "圣诞老人帽"
	desc = "嚯嚯嚯，圣诞快乐！"
	icon_state = "santa_hat_red"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/sas_juggernaut //CKEY=sasoperative (UNIQUE)
	name = "重装战士头盔"
	icon_state = "skinnerhelmet"
	desc = "用于搭配重装战士护甲的红色头盔。捐赠物品。"

/obj/item/clothing/head/helmet/marine/fluff/tristan //CKEY=tristan63
	name = "时髦头盔"
	desc = "那不是红漆，是真正的鲜血。捐赠物品。"
	icon_state = "syndicate"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/penguin //CKEY=tophatpenguin
	name = "顶级企鹅礼帽"
	icon_state = "petehat"
	desc = "企鹅戴的帽子，说不定还是最顶级的那只企鹅……捐赠物品。"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "毁灭战士头盔"
	icon_state = "doom_helmet"
	desc = "一位著名地球战士的头盔……捐赠物品。"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/sadokist //CKEY=sadokist
	name = "塔妮娅的贝雷帽"
	desc = "一顶鲜红的贝雷帽，属于塔妮娅·伊德妮娅。"
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/robin //CKEY=robin63
	name = "罗宾·洛的贝雷帽"
	desc = "一顶鲜红的贝雷帽，属于罗宾·洛。"
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/vintage //CKEY=vintagepalmer
	name = "复古皮条客礼帽"
	icon_state = "petehat"
	desc = "适合老派皮条客的礼帽。捐赠物品。"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/john56 //CKEY=johnkilla56
	name = "牧师兜帽"
	icon_state = "chaplain_hood"
	desc = "我虽行过死荫的幽谷……捐赠物品。"

/obj/item/clothing/head/helmet/marine/fluff/biolock //CKEY=biolock
	name = "M10定制头盔"
	desc = "一顶定制 M10式头盔，内衬更小、更光滑的衬垫，右侧装有内置摄像头。捐赠物品。"
	icon_state = "bio_helmet"
	item_state = "bio_helmet"

/obj/item/clothing/head/helmet/marine/fluff/haveatya //CKEY=haveatya
	name = "伞降救援贝雷帽"
	desc = "只有最优秀的人才能获配的伞降救援贝雷帽。捐赠物品。"
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "精英作战头盔"
	icon_state = "hecuhelm_u"
	desc = "一顶留下无数战斗伤痕的作战头盔。独一无二的捐赠物品。"

/obj/item/clothing/head/helmet/marine/fluff/sas_legion //CKEY=sasoperative (UNIQUE)
	name = "M3游骑兵头盔"
	desc = "一顶 M3游骑兵头盔，想必已经相当少见了。捐赠物品。"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	icon_state = "rangerhelmet"
	item_state = "rangerhelmet"

/obj/item/clothing/head/helmet/marine/fluff/officialjake
	name = "蒂莫西的贝雷帽"
	desc = "蒂莫西·塞德纳的时髦红色贝雷帽。捐赠物品。"
	icon_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/ningajai
	name = "安东尼的头盔"
	desc = "安东尼·卡敏的 COG 头盔。"
	icon_state = "anthonycarmine"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/goldshieldberet
	name = "贝雷帽"
	desc = "一顶带有金色盾徽的黑色军用贝雷帽。"
	icon_state = "gberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/goldtrimberet
	name = "贝雷帽"
	desc = "一顶饰有金色镶边的栗色贝雷帽。"
	icon_state = "gtberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/commandercookies //CKEY=commandercookies
	name = "埃利奥特的贝雷帽"
	desc = "一顶深栗色贝雷帽。"
	icon_state = "eberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/juniho
	name = "希特的帽子"
	desc = "一顶与“安保人员不称职”之类指控密切相关的帽子……捐赠物品。" //Add UNIQUE if Unique
	icon_state = "detective"
	item_state = "detective"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/limo //CKEY=limodish (UNIQUE)
	name = "血红色硬式防护服"
	desc = "看起来像一顶扮装用的硬式防护服头盔。捐赠物品。"
	icon_state = "syndicate"
	item_state = "syndicate"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/devilzhand
	name = "MICH作战头盔"
	desc = "一顶时髦的作战头盔。捐赠物品。"
	icon_state = "mich"
	item_state = "mich"

/obj/item/clothing/head/helmet/marine/fluff/bark
	name = "判官头盔"
	desc = "我就是法律。独一无二的捐赠物品。"
	icon_state = "judgehelm_u"
	item_state = "judgehelm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES

/obj/item/clothing/head/helmet/marine/fluff/bwoincognito //CKEY=bwoincognito
	name = "废土头盔"
	desc = "一位古老废土客的头盔……独一无二的捐赠物品。"
	icon_state = "riothelm_u"
	item_state = "riothelm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/mitii
	name = "米娅的贝雷帽"
	desc = "一顶带有闪亮安保徽章的红色贝雷帽。捐赠物品。"
	icon_state = "beret_badge"
	item_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/fickmacher //CKEY=fickmacher (UNIQUE)
	name = "塞莱娜的帽子"
	desc = "一顶时髦的贝雷帽。捐赠物品。"
	icon_state = "hosberet"
	item_state = "hosberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/eastgerman
	name = "梅尔文的帽子"
	desc = "一顶时髦的贝雷帽。捐赠物品。"
	icon_state = "hosberet"
	item_state = "hosberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/chimera //CKEY=theultimatechimera
	name = "布雷特的帽子"
	desc = "一顶时髦的贝雷帽。捐赠物品。"
	icon_state = "hosberet"
	item_state = "hosberet"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/lostmixup
	name = "无限弹药头巾"
	desc = "免责声明：大概并不能提供无限弹药。独一无二的捐赠物品。"
	icon_state = "headband_u"
	item_state = "headband_u"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/totalanarchy //CKEY=totalanarchy
	name = "利奥的头盔"
	desc = "一顶旧雇佣兵头盔。捐赠物品。"
	icon_state = "merc_helm"
	item_state = "merc_helm"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDELOWHAIR

/obj/item/clothing/head/helmet/marine/fluff/oneonethreeeight //CKEY=oneonethreeeight
	name = "迷彩头盔"
	desc = "林地迷彩头盔。捐赠物品。"
	icon_state = "camo_helm"
	item_state = "camo_helm"

/obj/item/clothing/head/helmet/marine/fluff/dino //CKEY=dinobubba7
	name = "斯内克的头巾"
	desc = "“首领”所有。捐赠物品。"
	icon_state = "snakeheadband"
	item_state = "snakeheadband"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/paradox //CKEY=paradox1i7
	name = "圣殿骑士头盔"
	desc = "一支昔日强大骑士团的头盔。捐赠物品。"
	icon_state = "templar_helm"
	item_state = "templar_helm"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/deejay
	name = "鲁克的贝雷帽"
	desc = "胡安“鲁克”加西亚的时髦红色贝雷帽。捐赠物品。"
	icon_state = "beret_badge"
	item_state = "beret_badge"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/chris1464 //CKEY=chris1464
	name = "雇佣兵贝雷帽"
	desc = "某个雇佣兵公司的贝雷帽。捐赠物品。"
	icon_state = "cargosoft"
	item_state = "cargosoft"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/radical
	name = "赏金猎人头盔"
	desc = "一位古老赏金猎人的头盔。捐赠物品。"
	icon_state = "boba_helmet"
	item_state = "boba_helmet"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/whiteblood17 //CKEY=whiteblood17
	name = "秘密行动头盔"
	desc = "你没有查看它的权限。捐赠物品。"
	icon_state = "syndicate-helm-black"
	item_state = "syndicate-helm-black"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/leondark //CKEY=leondark16
	name = "猎手的殖民地陆战队帽"
	desc = "一顶用旧的帽子，内侧写着“巴里恩托斯”。捐赠物品。"
	icon_state = "USCM_cap"
	item_state = "USCM_cap"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/starscream //CKEY=starscream123 (UNIQUE)
	name = "卡达尔·侯赛因的头盔"
	desc = "略有磨损和破裂。捐赠物品。"
	icon_state = "asset_protect"
	item_state = "asset_protect"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/trblackdragon //CKEY=trblackdragon
	name = "斯巴达头盔"
	desc = "斯巴达人，你们的职业是什么？捐赠物品。"
	icon_state = "blackdragon_helmet_u" //UNIQUE
	item_state = "blackdragon_helmet_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X头盔"
	desc = "用于搭配 M4-X护甲的新一代作战头盔。全覆面设计原本能够提供完整的轻型弹道防护和更强的耐酸性能，不过这顶原型并不具备这些功能。捐赠物品。"
	icon_state = "steelpoint_helmet"
	item_state = "steelpoint_helmet"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/valentine //CKEY=markvalentine
	name = "肖基的头盔"
	desc = "好得令人震惊的头盔。捐赠物品。"
	icon_state = "syndicate-helm-black"
	item_state = "syndicate-helm-black"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/jdobbin49 //CKEY=jdobbin49
	name = "菲利普的贝雷帽"
	desc = "菲利普·格林沃尔的贝雷帽。捐赠物品。"
	icon_state = "berettan"
	item_state = "berettan"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/nickiskool //CKEY=nickiskool
	name = "星爵面具"
	desc = "以防有人认出你……捐赠物品。"
	icon_state = "star_mask"
	item_state = "star_mask"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/bibblesless
	name = "黄色应急响应队头盔"
	desc = "黄色款的标准应急头盔……捐赠物品。"
	icon_state = "rig0-ert_engineer"
	item_state = "rig0-ert_engineer"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/fernkiller
	name = "白色应急响应队头盔"
	desc = "白色款的标准应急头盔……捐赠物品。"
	icon_state = "rig0-ert_medical"
	item_state = "rig0-ert_medical"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/jackmcintyre //CKEY=jackmcintyre (UNIQUE)
	name = "殖民地陆战队棒球帽"
	desc = "殖民地陆战队寒区棒球帽……捐赠物品。"
	icon_state = "Adam_hat"
	item_state = "Adam_hat"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "欧米伽政委头盔"
	desc = "欧米伽小组政委佩戴的头盔。独一无二的捐赠物品。"
	icon_state = "commissar_helmet_u"
	item_state = "commissar_helmet_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/medicae_helmet //CKEY=graciegrace0 (UNIQUE)
	name = "欧米伽军医头盔"
	desc = "欧米伽小组医疗部队佩戴的头盔。独一无二的捐赠物品。"
	icon_state = "medicae_helmet_u"
	item_state = "medicae_helmett_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/dingledangle
	name = "拉斯蒂的帽子"
	desc = "有些陈旧破败，颜色也随岁月略微褪去。捐赠物品。"
	icon_state = "bluesoft"
	item_state = "bluesoft"
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/marine/fluff/titus
	name = "ODST头盔"
	desc = "一顶带有褪色 ODST 字样的旧头盔。独一无二的捐赠物品。"
	icon_state = "leviathan13_helm_u"
	item_state = "leviathan13_helm_u"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/kaila
	name = "定制工程雪地头盔"
	desc = "一顶施有定制涂装的工程头盔。捐赠物品。"
	icon_state = "kailas_helmet"
	item_state = "kailas_helmet"

/obj/item/clothing/head/helmet/marine/fluff/edgelord
	name = "干员作战帽"
	desc = "一顶配有无线电耳机的坚固棕色殖民地陆战队帽，后侧印着“曼恩”的名字。捐赠物品。"
	icon_state = "edgelord_cap"
	item_state = "edgelord_cap"

/obj/item/clothing/head/helmet/marine/fluff/laser243
	name = "褪色游骑兵头盔"
	desc = "后侧刻着2033年。捐赠物品。"
	icon_state = "laser243"
	item_state = "laser243"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEMASK|HIDEEYES|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/fluff/killaninja12
	name = "太空牛仔帽"
	desc = "帽子内侧写着“莫里斯”的名字……独一无二的捐赠物品。"
	icon_state = "killaninja12_u"
	item_state = "killaninja12_u"


// UNIFORM/JUMPSUIT COSMETICS  ////////////////////////////////////////////////

//UNIFORM TEMPLATE (for uniforms/jumpsuits)  ONLY TAKE NAME, DESC, ICON_STATE, ITEM_STATE,  AND ITEM_COLOR.  Make a copy of those, and put the ckey of the person at the end after fluff
/obj/item/clothing/under/marine/fluff
	name = "ITEM NAME"
	desc = "ITEM DESCRIPTION.  DONOR ITEM" //Add UNIQUE if Unique
	flags_atom = FPRINT|NO_NAME_OVERRIDE|NO_SNOW_TYPE
	icon_state = null
	item_state = null
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/uniform_1.dmi',
	)

//END UNIFORM TEMPLATE

/obj/item/clothing/under/marine/fluff/marinemedic //UNUSED
	name = "陆战队医疗兵连身服"
	desc = "标准的夹棉殖民地陆战队连身服，织入护板以抵御小口径子弹和轻微冲击，带有医疗标识。"
	icon_state = "marine_medic"
	worn_state = "marine_medic"

/obj/item/clothing/under/marine/fluff/marineengineer //UNUSED
	name = "陆战队技术员连身服"
	desc = "标准的夹棉殖民地陆战队连身服，织入护板以抵御小口径子弹和轻微冲击，带有工程标识。"
	icon_state = "marine_engineer"
	worn_state = "marine_engineer"

/obj/item/clothing/under/marine/fluff/tristan //CKEY=tristan63
	desc = "一件带有金色标识的蓝色连身服，标识代表“上尉”军衔。"
	name = "上尉连身服"
	icon_state = "camojump"
	worn_state = "camojump"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "毁灭战士制服"
	desc = "一位著名地球战士的制服……捐赠物品。"
	icon_state = "doom_suit"
	worn_state = "doom_suit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/totalanarchy //CKEY=totalanarchy
	name = "雇佣兵连身服"
	desc = "某支雇佣兵队伍的制服……捐赠物品。"
	icon_state = "merc_jumpsuit"
	worn_state = "merc_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/john56 //CKEY=johnkilla56
	name = "粉色自豪连身服"
	desc = "用粉色展现你的自豪……捐赠物品。"
	icon_state = "pink"
	worn_state = "pink"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "黑色作战服"
	desc = "通常用于夜间行动的黑色迷彩作战服。独一无二的捐赠物品。"
	icon_state = "hecu_u"
	worn_state = "hecu_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/leeeverett //CKEY=theflagbearer (UNIQUE)
	name = "粗犷套装"
	desc = "上面沾满鲜血，气味难闻。究竟是谁穿着它死去了？"
	icon_state = "rugged"
	worn_state = "rugged"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/vintage //CKEY=vintagepalmer
	name = "复古粉色连身服"
	desc = "这件连身服要么曾经是红色，要么曾经是白色，后来和掉色衣物一起洗过……捐赠物品。"
	icon_state = "pink"
	worn_state = "pink"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/wooki //CKEY=tophatpenguin (UNIQUE)
	name = "时髦制服"
	desc = "伍基的时髦蓝色套装。独一无二的捐赠物品。"
	icon_state = "wooki_u"
	worn_state = "wooki_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/Zynax //CKEY=zynax
	name = "戈尔卡套装"
	desc = "俄式迷彩。捐赠物品。"
	icon_state = "gorkasuit"
	worn_state = "gorkasuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/bwoincognito //CKEY=bwoincognito
	name = "废土套装"
	desc = "某群古老废土客的套装……独一无二的捐赠物品。"
	icon_state = "riot_u"
	worn_state = "riot_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/juninho
	name = "公司安保制服"
	desc = "配得上公司安保主管身份的连身服。捐赠物品。" //Add UNIQUE if Unique
	icon_state = "hos_corporate"
	worn_state = "hos_corporate"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/fickmacher //CKEY=fickmacher (UNIQUE)
	name = "塞莱娜的战术服"
	desc = "一件模样古怪的黑色连身服。捐赠物品。"
	icon_state = "robotics"
	worn_state = "robotics"

/obj/item/clothing/under/marine/fluff/gromi
	name = "鹰眼的衣服"
	desc = "一位传奇战地外科医生穿过的制服。独一无二的捐赠物品。"
	icon_state = "hawkeye_jumpsuit_u"
	worn_state = "hawkeye_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/feweh //CKEY=feweh
	name = "粉色作战服"
	desc = "用于对抗乳腺癌，用子弹来对抗。捐赠物品。"
	icon_state = "pink2"
	worn_state = "pink2"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/oneonethreeeight //CKEY=oneonethreeeight
	name = "迷彩连身服"
	desc = "林地迷彩连身服。捐赠物品。"
	icon_state = "camo_jumpsuit"
	worn_state = "camo_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/fickmacher2 //CKEY=fickmacher (UNIQUE)
	name = "哈特的套装"
	desc = "右臂看起来是机械的。捐赠物品。"
	icon_state = "hart_jumpsuit"
	worn_state = "hart_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/paradox //CKEY=paradox1i7
	name = "圣殿骑士连身服"
	desc = "用于连接圣殿骑士护甲的内衬组件。捐赠物品。"
	icon_state = "templar_jumpsuit"
	worn_state = "templar_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/chris1464 //CKEY=chris1464
	name = "雇佣兵连身服"
	desc = "来自一家极为可疑的雇佣兵公司的连身服。捐赠物品。"
	icon_state = "merc_jumpsuit"
	worn_state = "merc_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/radical
	name = "赏金猎人连身服"
	desc = "一位古老赏金猎人的内层衣物。捐赠物品。"
	icon_state = "boba_jumpsuit"
	worn_state = "boba_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/jackmcintyre_alt //CKEY=jackmcintyre
	name = "军礼服"
	desc = "普通陆战队员穿着的军礼服。捐赠物品。"
	icon_state = "service_uniform"
	worn_state = "service_uniform"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/starscream //CKEY=starscream123 (UNIQUE)
	name = "卡达尔·侯赛因的连身服"
	desc = "略有磨损和破裂。捐赠物品。"
	icon_state = "merc_jumpsuit2"
	worn_state = "merc_jumpsuit2"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/allan1234
	name = "指挥官连身服"
	desc = "一位太空指挥官穿过的连身服……捐赠物品。"
	icon_state = "henrick_jumpsuit"
	worn_state = "henrick_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X连身服"
	desc = "与 M4-X护甲一同配发的连身服，相较于更现代的护甲系统，它已被视为过时装备。捐赠物品。"
	icon_state = "steelpoint_jumpsuit"
	worn_state = "steelpoint_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/valentine //CKEY=markvalentine
	name = "肖基的连身服"
	desc = "好得令人震惊的连身服。捐赠物品。"
	icon_state = "jensen"
	worn_state = "jensen"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/arach
	name = "零式紧身服"
	desc = "穿在未来护甲之下的连身服。捐赠物品。"
	icon_state = "samus_jumpsuit"
	worn_state = "samus_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/nickiskool //CKEY=nickiskool
	name = "星爵的连身服"
	desc = "专为向女士们炫耀你的雄壮肌肉而设计。捐赠物品。"
	icon_state = "star_jumpsuit"
	worn_state = "star_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/jackmcintyre //CKEY=jackmcintyre (UNIQUE)
	name = "白衬衫与黑长裤"
	desc = "既适合正式场合，也能让你在战区保持风度。独一无二的捐赠物品。"
	icon_state = "Adam_jumpsuit_u"
	worn_state = "Adam_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/fairedan //CKEY=fairedan (UNIQUE)
	name = "星际货船连身服"
	desc = "洛克马特 CM-88B“野牛”星际货船船员的制式连身服，内侧标签上有数字1809246……捐赠物品。"
	icon_state = "Fairedan_jumpsuit"
	worn_state = "Fairedan_jumpsuit"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "欧米伽政委制服"
	desc = "欧米伽小组政委所穿的制服。独一无二的捐赠物品。"
	icon_state = "commisar_jumpsuit_u"
	worn_state = "commisar_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/medicae_jumpsuit //CKEY=graciegrace0 (UNIQUE)
	name = "欧米伽军医制服"
	desc = "欧米伽小组医疗部队所穿的制服。独一无二的捐赠物品。"
	icon_state = "medicae_jumpsuit_u"
	worn_state = "medicae_jumpsuit_u"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/sailordave //CKEY=sailordave
	name = "伊甸殖民地陆战队制服"
	desc = "一款较老的殖民地陆战队制服。独一无二的捐赠物品。"
	icon_state = "syndicate"
	worn_state = "syndicate"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/whiteblood17 //CKEY=whiteblood17
	name = "秘密行动制服"
	desc = "远不是你这个级别该过问的……捐赠物品。"
	icon_state = "jensen"
	worn_state = "jensen"
	flags_jumpsuit = FALSE

/obj/item/clothing/under/marine/fluff/mileswolfe //CKEY=mileswolfe
	name = "虎纹作战服"
	desc = "一件带有虎纹的作战服。独一无二的捐赠物品。"
	icon_state = "mileswolfe_u"
	worn_state = "mileswolfe_u"
	flags_jumpsuit = FALSE


// MASK COSMETICS  ////////////////////////////////////////////////

/obj/item/clothing/mask/fluff/john56 //CKEY=johnkilla56
	name = "雷文面具"
	desc = "一位著名西斯的面具……等等，什么？捐赠物品。"
	item_state = "revanmask"
	icon_state = "revanmask"

/obj/item/clothing/mask/fluff/totalanarchy //CKEY=totalanarchy
	name = "私人军事承包商面具"
	desc = "一副白色的私人军事承包商面具。捐赠物品。"
	icon_override = 'icons/mob/humans/onmob/mask.dmi'
	item_state = "pmc_mask"
	icon_state = "pmc_mask"
	flags_inventory = COVERMOUTH|ALLOWREBREATH
	flags_inv_hide = HIDEEARS|HIDEFACE|HIDEALLHAIR

/obj/item/clothing/mask/fluff/sas_elite //CKEY=sasoperative (UNIQUE)
	name = "紧凑型防毒面具"
	desc = "一副呈纯红色调的紧凑型防毒面具。独一无二的捐赠物品。"
	item_state = "hecumask_u"
	icon_state = "hecumask_u"

/obj/item/clothing/mask/fluff/limo //CKEY=limodish
	name = "特警面具"
	desc = "特警防毒面具。捐赠物品。"
	icon_state = "swat"
	item_state = "swat"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEEYES|HIDEFACE

/obj/item/clothing/mask/fluff/feweh //CKEY=feweh
	name = "平克的防毒面具"
	desc = "一副制式防毒面具。捐赠物品。"
	icon_state = "swat"
	item_state = "swat"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEEYES|HIDEFACE

/obj/item/clothing/mask/fluff/fickmacher2 //CKEY=fickmacher (UNIQUE)
	name = "哈特下士的面具"
	desc = "一副具有机械风格的装甲面具。捐赠物品。"
	icon_state = "hartmask"
	item_state = "hartmask"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEFACE

/obj/item/clothing/mask/fluff/starscream //CKEY=starscream123 (UNIQUE)
	name = "卡达尔·侯赛因的面具"
	desc = "略有磨损和破裂。捐赠物品。"
	icon_state = "merc_mask"
	item_state = "merc_mask"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEFACE

/obj/item/clothing/mask/fluff/lostmixup
	name = "幽灵雪茄"
	desc = "这是一支幽、幽、幽、幽、幽灵雪茄。捐赠物品。" //Add UNIQUE if Unique
	icon_state = "cigar_on"
	item_state = "cigar_on"
	flags_inventory = ALLOWREBREATH
	flags_inv_hide = HIDEFACE

// BOOTS/SHOES COSMETICS  ////////////////////////////////////////////////
/obj/item/clothing/shoes/marine/fluff/vintage //CKEY=vintagepalmer
	name = "复古凉鞋"
	desc = "只有最高品位的潮人才配得上的复古凉鞋。捐赠物品。"
	icon_state = "sandals"
	item_state = "sandals"

/obj/item/clothing/shoes/marine/fluff/feodrich //CKEY=feodrich (UNIQUE)
	name = "毁灭战士战靴"
	desc = "一位著名地球战士的制服……捐赠物品。"
	icon_state = "doom_boots"
	item_state = "doom_boots"

/obj/item/clothing/shoes/marine/fluff/steelpoint //CKEY=steelpoint (UNIQUE)
	name = "M4-X战靴"
	desc = "与 M4-X护甲一同配发的制式战靴，原本带有特殊耐酸涂层，让穿戴者能够安全通过酸液遍布的环境。不过，这双原型并不具备该功能。捐赠物品。"
	icon_state = "marine"
	item_state = "marine"

//GENERIC GLASSES, GLOVES, AND MISC ////////////////////

/obj/item/clothing/glasses/fluff/wright //CKEY=wrightthewrong
	name = "眼罩"
	desc = "呀嗬，这是件捐赠物品，呀嗬！"
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/glasses/fluff/sadokist //CKEY=sadokist
	name = "塔妮娅的光学镜"
	desc = "塔妮娅·伊德妮娅的定制光学镜。"
	icon_state = "thermal"
	item_state = "glasses"

/obj/item/clothing/glasses/fluff/haveatya //CKEY=haveatya
	name = "特殊夜视镜"
	desc = "免责声明：可能并不具备夜视功能。捐赠物品。"
	icon_state = "night"
	item_state = "glasses"

/obj/item/clothing/gloves/black/obey //CKEY=obeystylez (UNIQUE)
	desc = "特种作战部队偏爱的黑色手套。捐赠物品。"
	name = "秘密行动黑手套"

//BACKPACKS

/obj/item/storage/backpack/marine/fluff/sadokist //CKEY=sadokist
	name = "塔妮娅的背包"
	desc = "塔妮娅·伊德妮娅使用的大背包。捐赠物品。"
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/marine/fluff/mitii
	name = "米娅的背包"
	desc = "带有无线电信号增强器的大型安保背包。捐赠物品。"
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/storage/backpack/marine/satchel/fluff/sas_juggernaut //CKEY=sasoperative (UNIQUE)
	name = "战术无线电背包"
	desc = "与重装战士护甲配套使用的无线电背包。捐赠物品。"
	icon_state = "skinnerpack"
	item_state = "securitypack"
	has_gamemode_skin = FALSE //same sprite for all gamemodes.

/obj/item/storage/backpack/marine/satchel/fluff/sas_legion //CKEY=sasoperative (UNIQUE)
	name = "M3装甲背包"
	desc = "有大量小袋和口袋。捐赠物品。"
	flags_atom = FPRINT|CONDUCT|NO_NAME_OVERRIDE
	icon_state = "skinnerrangerpack"
	item_state = "skinnerrangerpack"

/obj/item/clothing/glasses/fluff/alexwarhammer
	name = "黑杰克的酷炫墨镜"
	desc = "硬汉指数+20。捐赠物品。"
	icon_state = "sun"
	item_state = "sun"

/obj/item/clothing/gloves/marine/fluff/jedijas //CKEY=jedijasun (UNIQUE)
	name = "曼达洛之拳"
	desc = "如果曼达洛是个人，这双就是他的拳头……捐赠物品。"
	icon_state = "marine_white"
	item_state = "marine_wgloves"

/obj/item/storage/belt/marine/fluff/commissar //used by both ckeys 'hycinth' and 'technokat' (UNIQUE)
	name = "欧米伽佩剑带"
	desc = "欧米伽小组那些令人畏惧的政委所佩戴的腰带。独一无二的捐赠物品。"
	icon_state = "swordbelt_u"
	item_state = "swordbelt_u"

//CUSTOM ITEMS - NO TEMPLATES - ALL UNIQUE ////////////////////////
/obj/item/tool/lighter/zippo/fluff/ghostdex //CKEY=ghostdex
	name = "紫色芝宝打火机"
	desc = "一只刻有约翰·多纳布尔名字的紫色芝宝打火机……独一无二的捐赠物品。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "bluezippo"

/obj/item/clothing/mask/cigarette/fluff/ghostdex //CKEY=ghostdex
	name = "XXX的定制雪茄"
	desc = "在古巴最优质、最炎热、剥削最严重的血汗工厂中，专门为约翰·多纳布尔手工卷制的巨型雪茄。独一无二的捐赠物品。"
	icon_state = "cigar2_off"
	icon_on = "cigar2_on"
	icon_off = "cigar_2off"
	smoketime = 7200
	chem_volume = 30
	flags_inventory = COVERMOUTH|ALLOWREBREATH


//GHOST CIGAR CODE
/obj/item/clothing/mask/cigarette/cigar/fluff/ghostdex/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/lighter/zippo/fluff/ghostdex))
		..()
	else
		to_chat(user, SPAN_NOTICE("[src]坚决拒绝被紫色芝宝打火机以外的任何东西点燃。"))
