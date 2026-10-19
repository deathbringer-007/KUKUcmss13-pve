//Seed packet object/procs.
/obj/item/seeds
	name = "种子包"
	icon = 'icons/obj/items/seeds.dmi'
	icon_state = "seed"
	flags_atom = NO_FLAGS
	w_class = SIZE_TINY
	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	. = ..()
	GLOB.seed_list += src
	update_seed()

/obj/item/seeds/Destroy()
	seed = null
	GLOB.seed_list -= src
	return ..()

/obj/item/seeds/verb/rename_seeds() //set amount_per_transfer_from_this
	set name = "Rename Seeds"
	set category = "Object"
	set src in usr
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	var/obj/item/seeds/S = user.get_active_hand()
	if(!istype(S))
		to_chat(user, SPAN_WARNING("你把想重命名的种子放到哪里去了？"))
		return
	if (seed.roundstart)
		to_chat(user, SPAN_WARNING("你不能重命名基础品种的种子！"))
		return
	var/new_name = copytext(reject_bad_text(tgui_input_text(user,"重命名种子品种？", "设置新的种子品种名称", "")), 1, MAX_NAME_LEN)
	if (!new_name)
		return
	S.seed.seed_name = new_name
	//Sure, the various seed types have different names for the plant thing but honestly it's too much work changing that for what it's worth...
	//So generic name instead!
	S.seed.display_name = "[new_name]植株"
	for (var/obj/item/seeds/SS in GLOB.seed_list)
		if (SS.seed.uid == S.seed.uid)
			SS.update_appearance() //updates the name

	to_chat(user, SPAN_INFO("品种编号 [seed.uid] 已重命名为“[new_name]”。"))
	msg_admin_niche("[user] renamed seed variety #[seed.uid] to \"[new_name]\"")


//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(GLOB.seed_types) && GLOB.seed_types[seed_type])
		seed = GLOB.seed_types[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return
	icon_state = seed.packet_icon
	src.name = "一包[localized_seed_label(seed.seed_name)][localized_seed_label(seed.seed_noun)]"
	src.desc = "正面印有[localized_seed_label(seed.display_name)]的图片。"

/obj/item/seeds/get_examine_text(mob/user)
	. = ..()
	if(seed && !seed.roundstart)
		. += "标签标明这是编号 [seed.uid] 的品种。"

/obj/item/seeds/cutting
	name = "插穗"
	desc = "一些植物插穗。"

/obj/item/seeds/cutting/update_appearance()
	..()

	name = "一包[localized_seed_label(seed.seed_name)]插穗"

/obj/item/seeds/poppyseed
	seed_type = "poppies"
	name = "一包罂粟种子"

/obj/item/seeds/chiliseed
	seed_type = "chili"
	name = "一包辣椒种子"

/obj/item/seeds/plastiseed
	seed_type = "plastic"
	name = "一包塑料植物种子"

/obj/item/seeds/grapeseed
	seed_type = "grapes"
	name = "一包葡萄种子"

/obj/item/seeds/greengrapeseed
	seed_type = "greengrapes"
	name = "一包绿葡萄种子"

/obj/item/seeds/peanutseed
	seed_type = "peanut"
	name = "一包花生种子"

/obj/item/seeds/cabbageseed
	seed_type = "cabbage"
	name = "一包卷心菜种子"

/obj/item/seeds/shandseed
	seed_type = "shand"
	name = "一包香德草种子"

/obj/item/seeds/mtearseed
	seed_type = "mtear"
	name = "一包梅萨之泪种子"

/obj/item/seeds/berryseed
	seed_type = "berries"
	name = "一包浆果种子"

/obj/item/seeds/glowberryseed
	seed_type = "glowberries"
	name = "一包发光浆果种子"

/obj/item/seeds/bananaseed
	seed_type = "banana"
	name = "一包香蕉种子"

/obj/item/seeds/eggplantseed
	seed_type = "eggplant"
	name = "一包茄子种子"

/obj/item/seeds/eggyseed
	seed_type = "realeggplant"
	name = "一包真蛋茄种子"

/obj/item/seeds/bloodtomatoseed
	seed_type = "bloodtomato"
	name = "一包血番茄种子"

/obj/item/seeds/tomatoseed
	seed_type = "tomato"
	name = "一包番茄种子"

/obj/item/seeds/killertomatoseed
	seed_type = "killertomato"
	name = "一包杀人番茄种子"

/obj/item/seeds/bluetomatoseed
	seed_type = "bluetomato"
	name = "一包蓝番茄种子"

/obj/item/seeds/bluespacetomatoseed
	seed_type = "bluespacetomato"
	name = "一包蓝空间番茄种子"

/obj/item/seeds/cornseed
	seed_type = "corn"
	name = "一包玉米种子"

/obj/item/seeds/poppyseed
	seed_type = "poppies"
	name = "一包罂粟种子"

/obj/item/seeds/potatoseed
	seed_type = "potato"
	name = "一包土豆种子"

/obj/item/seeds/icepepperseed
	seed_type = "icechili"
	name = "一包冰辣椒种子"

/obj/item/seeds/soyaseed
	seed_type = "soybean"
	name = "一包大豆种子"

/obj/item/seeds/wheatseed
	seed_type = "wheat"
	name = "一包小麦种子"

/obj/item/seeds/riceseed
	seed_type = "rice"
	name = "一包稻米种子"

/obj/item/seeds/carrotseed
	seed_type = "carrot"
	name = "一包胡萝卜种子"

/obj/item/seeds/reishimycelium
	seed_type = "reishi"
	name = "一包灵芝孢子"

/obj/item/seeds/amanitamycelium
	seed_type = "amanita"
	name = "一包毒蝇伞孢子"

/obj/item/seeds/angelmycelium
	seed_type = "destroyingangel"
	name = "一包毁灭天使菌孢子"

/obj/item/seeds/libertymycelium
	seed_type = "libertycap"
	name = "一包自由帽菇孢子"

/obj/item/seeds/chantermycelium
	seed_type = "mushrooms"
	name = "一包蘑菇孢子"

/obj/item/seeds/towermycelium
	seed_type = "towercap"
	name = "一包高帽菇孢子"

/obj/item/seeds/glowshroom
	seed_type = "glowshroom"
	name = "一包发光菇孢子"

/obj/item/seeds/plumpmycelium
	seed_type = "plumphelmet"
	name = "一包肥菇"

/obj/item/seeds/walkingmushroommycelium
	seed_type = "walkingmushroom"
	name = "一包行走蘑菇孢子"

/obj/item/seeds/nettleseed
	seed_type = "nettle"
	name = "一包荨麻种子"

/obj/item/seeds/deathnettleseed
	seed_type = "deathnettle"
	name = "一包死荨麻种子"

/obj/item/seeds/weeds
	seed_type = "weeds"
	name = "一包杂草种子"

/obj/item/seeds/harebell
	seed_type = "harebells"
	name = "一包风铃草种子"

/obj/item/seeds/sunflowerseed
	seed_type = "sunflowers"
	name = "一包向日葵种子"

/obj/item/seeds/brownmold
	seed_type = "mold"
	name = "一包霉菌孢子"

/obj/item/seeds/appleseed
	seed_type = "apple"
	name = "一包苹果种子"

/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"
	name = "一包毒苹果种子"

/obj/item/seeds/goldappleseed
	seed_type = "goldapple"
	name = "一包金苹果种子"

/obj/item/seeds/ambrosiavulgarisseed
	seed_type = "ambrosia"
	name = "一包神馔草种子"

/obj/item/seeds/ambrosiadeusseed
	seed_type = "ambrosiadeus"
	name = "一包神赐草种子"

/obj/item/seeds/whitebeetseed
	seed_type = "whitebeet"
	name = "一包白甜菜种子"

/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"
	name = "一包甘蔗种子"

/obj/item/seeds/watermelonseed
	seed_type = "watermelon"
	name = "一包西瓜种子"

/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"
	name = "一包南瓜种子"

/obj/item/seeds/limeseed
	seed_type = "lime"
	name = "一包青柠种子"

/obj/item/seeds/lemonseed
	seed_type = "lemon"
	name = "一包柠檬种子"

/obj/item/seeds/orangeseed
	seed_type = "orange"
	name = "一包橙色种子"

/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"
	name = "一包毒浆果种子"

/obj/item/seeds/deathberryseed
	seed_type = "deathberries"
	name = "一包致死浆果种子"

/obj/item/seeds/grassseed
	seed_type = "grass"
	name = "一包草种子"

/obj/item/seeds/cocoapodseed
	seed_type = "cocoa"
	name = "一包可可种子"

/obj/item/seeds/cherryseed
	seed_type = "cherry"
	name = "一包樱桃种子"

/obj/item/seeds/kudzuseed
	seed_type = "kudzu"
	name = "一包葛藤种子"
