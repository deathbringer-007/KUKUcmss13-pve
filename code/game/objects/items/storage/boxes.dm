/*
 * Everything derived from the common cardboard box.
 * Basically everything except the original is a kit (starts full).
 *
 * Contains:
 * Empty box, starter boxes (survival/engineer),
 * Latex glove and sterile mask boxes,
 * Syringe, beaker, dna injector boxes,
 * Blanks, flashbangs, and EMP grenade boxes,
 * Tracking and chemical implant boxes,
 * Prescription glasses and drinking glass boxes,
 * Condiment bottle and silly cup boxes,
 * Donkpocket and monkeycube boxes,
 * ID and security PDA cart boxes,
 * Handcuff, mousetrap, and pillbottle boxes,
 * Snap-pops and matchboxes,
 * Replacement light boxes.
 *
 * For syndicate call-ins see uplink_kits.dm
 *
 *  EDITED BY APOPHIS 09OCT2015 to prevent in-game abuse of boxes.
 */



/obj/item/storage/box
	name = "箱"
	desc = "只是个普通箱子。"
	icon_state = "box"
	icon = 'icons/obj/items/storage/boxes.dmi'
	item_state = "syringe_kit"
	foldable = TRUE
	storage_slots = null
	max_w_class = SIZE_SMALL //Changed because of in-game abuse
	w_class = SIZE_LARGE //Changed becuase of in-game abuse
	storage_flags = STORAGE_FLAGS_BOX

/obj/item/storage/box/pride
	name = "骄傲主题蜡笔盒"
	desc = "一盒各种风格的骄傲主题蜡笔。"
	storage_slots = 8
	w_class = SIZE_SMALL
	can_hold = list(/obj/item/toy/crayon/pride)

/obj/item/storage/box/pride/fill_preset_inventory()
	new /obj/item/toy/crayon/pride/gay(src)
	new /obj/item/toy/crayon/pride/lesbian(src)
	new /obj/item/toy/crayon/pride/bi(src)
	new /obj/item/toy/crayon/pride/ace(src)
	new /obj/item/toy/crayon/pride/pan(src)
	new /obj/item/toy/crayon/pride/trans(src)
	new /obj/item/toy/crayon/pride/enby(src)
	new /obj/item/toy/crayon/pride/fluid(src)

/obj/item/storage/box/survival
	w_class = SIZE_MEDIUM

/obj/item/storage/box/survival/fill_preset_inventory()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/tank/emergency_oxygen( src )

/obj/item/storage/box/engineer

/obj/item/storage/box/engineer/fill_preset_inventory()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/tank/emergency_oxygen/engi( src )


/obj/item/storage/box/gloves
	name = "乳胶手套盒"
	desc = "内装白色手套。"
	icon_state = "latex"
	can_hold = list(/obj/item/clothing/gloves/latex)
	w_class = SIZE_SMALL


/obj/item/storage/box/gloves/fill_preset_inventory()
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)

/obj/item/storage/box/masks
	name = "无菌口罩盒"
	desc = "内装无菌口罩。"
	icon_state = "sterile"
	can_hold = list(/obj/item/clothing/mask/surgical)
	w_class = SIZE_SMALL

/obj/item/storage/box/masks/fill_preset_inventory()
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)


/obj/item/storage/box/syringes
	name = "注射器盒"
	desc = "装满注射器的盒子。"
	desc = "盒上印有生物危害警告。"
	can_hold = list(/obj/item/reagent_container/syringe)
	icon_state = "syringe"
	w_class = SIZE_SMALL

/obj/item/storage/box/syringes/fill_preset_inventory()
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)


/obj/item/storage/box/beakers
	name = "烧杯盒"
	icon_state = "beaker"
	can_hold = list(/obj/item/reagent_container/glass/beaker)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/beakers/fill_preset_inventory()
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)

/obj/item/storage/box/sprays
	name = "空喷雾瓶盒"
	icon_state = "spray"
	can_hold = list(/obj/item/reagent_container/spray)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/sprays/fill_preset_inventory()
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)

/obj/item/storage/box/flashbangs
	name = "闪光震撼弹盒（警告）"
	desc = "<B>警告：这些装置极其危险，反复使用会导致失明或失聪。</B>"
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "flashbang"
	can_hold = list(/obj/item/explosive/grenade/flashbang)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/flashbangs/fill_preset_inventory()
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		handle_delete_clash_contents()
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(handle_delete_clash_contents))

/obj/item/storage/box/flashbangs/proc/handle_delete_clash_contents()
	SIGNAL_HANDLER
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		var/grenade_count = 0
		var/grenades_desired = 4
		for(var/grenade in contents)
			if(grenade_count > grenades_desired)
				qdel(grenade)
			grenade_count++
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/storage/box/emps
	name = "电磁脉冲手榴弹盒"
	desc = "内装五枚电磁脉冲手榴弹。"
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "emp"

/obj/item/storage/box/emps/fill_preset_inventory()
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)


/obj/item/storage/box/trackimp
	name = "盒装追踪植入套件"
	desc = "装满追踪坏蛋所需器具的盒子。"
	icon_state = "implant"

/obj/item/storage/box/trackimp/fill_preset_inventory()
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)
	new /obj/item/device/locator(src)

/obj/item/storage/box/chemimp
	name = "盒装化学植入套件"
	desc = "内装化学植入所需器材。"
	icon_state = "implant"

/obj/item/storage/box/chemimp/fill_preset_inventory()
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)



/obj/item/storage/box/rxglasses
	name = "处方眼镜盒"
	desc = "内装书呆子眼镜。"
	icon_state = "glasses"
	can_hold = list(/obj/item/clothing/glasses/regular)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/rxglasses/fill_preset_inventory()
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/drinkingglasses
	name = "饮用玻璃杯盒"
	desc = "上面印着饮用玻璃杯的图片。"

/obj/item/storage/box/drinkingglasses/fill_preset_inventory()
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)

/obj/item/storage/box/cdeathalarm_kit
	name = "死亡警报套件"
	desc = "内装植入死亡警报所需器材。"
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/storage/box/cdeathalarm_kit/fill_preset_inventory()
	new /obj/item/implanter(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)

/obj/item/storage/box/condimentbottles
	name = "调味瓶盒"
	desc = "上面有一大片番茄酱污渍。"

/obj/item/storage/box/condimentbottles/fill_preset_inventory()
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)



/obj/item/storage/box/cups
	name = "纸杯盒"
	desc = "正面印着纸杯的图片。"

/obj/item/storage/box/cups/fill_preset_inventory()
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )


/obj/item/storage/box/donkpockets
	name = "咚咚馅饼盒"
	desc = "<B>说明：</B><I>用微波炉加热。若七分钟内未食用，产品会冷却。</I>"
	icon_state = "donk_kit"
	can_hold = list(/obj/item/reagent_container/food/snacks)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/donkpockets/fill_preset_inventory()
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/microwavable/donkpocket(src)

/obj/item/storage/box/teabags
	name = "伯爵茶包盒"
	desc = "一盒速泡茶包。"
	icon_state = "teabag_box"
	item_state = "teabag_box"
	can_hold = list(/obj/item/reagent_container/pill/teabag)
	w_class = SIZE_SMALL
	storage_slots = 8

/obj/item/storage/box/teabags/fill_preset_inventory()
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)
	new /obj/item/reagent_container/pill/teabag/earl_grey(src)

/obj/item/storage/box/lemondrop
	name = "柠檬糖盒"
	desc = "一盒柠檬味硬糖。"
	icon_state = "lemon_drop_box"
	item_state = "lemon_drop_box"
	can_hold = list(/obj/item/reagent_container/food/snacks/lemondrop)
	w_class = SIZE_TINY //because otherwise it won't go back into MREs, it's not like people are minmaxing with lemon drops anyway
	storage_slots = 8

/obj/item/storage/box/lemondrop/fill_preset_inventory()
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)
	new /obj/item/reagent_container/food/snacks/lemondrop(src)


/obj/item/storage/box/monkeycubes
	name = "猴子方块盒"
	desc = "干伴牌猴子方块，加水即可！"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "monkeycubebox"

/obj/item/storage/box/monkeycubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped(src)

/obj/item/storage/box/monkeycubes/farwacubes
	name = "法尔瓦方块盒"
	desc = "从阿多迈运来的干伴牌法尔瓦方块，加水即可！"

/obj/item/storage/box/monkeycubes/farwacubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped/farwacube(src)

/obj/item/storage/box/monkeycubes/stokcubes
	name = "斯托克方块盒"
	desc = "从莫格斯运来的干伴牌斯托克方块，加水即可！"

/obj/item/storage/box/monkeycubes/stokcubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped/stokcube(src)

/obj/item/storage/box/monkeycubes/neaeracubes
	name = "尼艾拉方块盒"
	desc = "从贾尔贡四号星运来的干伴牌尼艾拉方块，加水即可！"

/obj/item/storage/box/monkeycubes/neaeracubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped/neaeracube(src)

/obj/item/storage/box/ids
	name = "备用身份卡盒"
	desc = "装有许多空白身份卡。"
	icon_state = "id"

/obj/item/storage/box/ids/fill_preset_inventory()
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)


/obj/item/storage/box/handcuffs
	name = "手铐盒"
	desc = "装满手铐的盒子。"
	icon_state = "handcuff"

/obj/item/storage/box/handcuffs/fill_preset_inventory()
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)


/obj/item/storage/box/legcuffs
	name = "脚镣盒"
	desc = "装满脚镣的盒子。"
	icon_state = "handcuff"

/obj/item/storage/box/legcuffs/fill_preset_inventory()
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)

/obj/item/storage/box/zipcuffs
	name = "整箱扎带手铐"
	desc = "一箱扎带手铐。"
	w_class = SIZE_MEDIUM
	icon_state = "handcuff"

/obj/item/storage/box/zipcuffs/fill_preset_inventory()
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)

/obj/item/storage/box/zipcuffs/small
	name = "小型束缚扎带盒"
	desc = "装满束缚扎带的小盒子。"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/zipcuffs/small/fill_preset_inventory()
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)

/obj/item/storage/box/tapes
	name = "整箱警戒胶带"
	desc = "一箱录音机磁带，总计可录制 10 小时 40 分钟！"

/obj/item/storage/box/tapes/fill_preset_inventory()
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)

/obj/item/storage/box/mousetraps
	name = "灭害灵捕鼠夹盒"
	desc = "<B><FONT color='red'>警告：</FONT></B><I>请置于儿童无法触及之处</I>。"
	icon_state = "mousetraps"

/obj/item/storage/box/mousetraps/fill_preset_inventory()
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )

/obj/item/storage/box/pillbottles
	name = "整箱药瓶"
	desc = "正面印有药瓶图案。"
	icon_state = "pillbox"

/obj/item/storage/box/pillbottles/fill_preset_inventory()
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )


/obj/item/storage/box/snappops
	name = "摔炮盒"
	desc = "八包欢乐！适合八岁及以上使用。不适合儿童。"
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "spbox"
	max_storage_space = 8

/obj/item/storage/box/snappops/fill_preset_inventory()
	for(var/i=1; i <= 8; i++)
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/matches
	name = "火柴盒"
	desc = "一小盒“太空适用”优质火柴。"
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_WAIST
	flags_obj = parent_type::flags_obj|OBJ_IS_HELMET_GARB
	can_hold = list(/obj/item/tool/match)

/obj/item/storage/box/matches/fill_preset_inventory()
	for(var/i=1; i <= 14; i++)
		new /obj/item/tool/match(src)

/obj/item/storage/box/matches/attackby(obj/item/tool/match/W as obj, mob/user as mob)
	if(istype(W) && !W.heat_source && !W.burnt)
		W.light_match()

/obj/item/storage/box/lights
	name = "备用灯泡盒"
	icon = 'icons/obj/items/storage/boxes.dmi'
	icon_state = "light"
	desc = "盒内形状只适合容纳灯管和灯泡。"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap
	can_hold = list(
		/obj/item/light_bulb/tube,
		/obj/item/light_bulb/bulb,
	)
	max_storage_space = 42 //holds 21 items of w_class 2
	storage_flags = STORAGE_FLAGS_BOX|STORAGE_CLICK_GATHER

/obj/item/storage/box/lights/bulbs/fill_preset_inventory()
	for(var/i = 0; i < 21; i++)
		new /obj/item/light_bulb/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "备用灯管盒"
	icon_state = "lighttube"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/lights/tubes/fill_preset_inventory()
	for(var/i = 0; i < 21; i++)
		new /obj/item/light_bulb/tube/large(src)

/obj/item/storage/box/lights/mixed
	name = "备用灯具盒"
	icon_state = "lightmixed"

/obj/item/storage/box/lights/mixed/fill_preset_inventory()
	for(var/i = 0; i < 14; i++)
		new /obj/item/light_bulb/tube/large(src)
	for(var/i = 0; i < 7; i++)
		new /obj/item/light_bulb/bulb(src)


/obj/item/storage/box/autoinjectors
	name = "自动注射器盒"
	icon_state = "syringe"

/obj/item/storage/box/autoinjectors/fill_preset_inventory()
	for(var/i = 0; i < 7; i++)
		new /obj/item/reagent_container/hypospray/autoinjector/empty(src)


/obj/item/storage/box/twobore
	name = "2 号口径炮弹盒"
	icon_state = "twobore"
	icon = 'icons/obj/items/storage/kits.dmi'
	desc = "装满巨大独头弹的盒子，仅用于狩猎最危险的猎物。2 号口径。"
	storage_slots = 5
	can_hold = list(/obj/item/ammo_magazine/handful/shotgun/twobore)

/obj/item/storage/box/twobore/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/twobore(src)

/obj/item/storage/box/stompers
	name = "\improper 锐步鞋盒"
	desc = "表面反光的精美鞋盒，顶部有维兰德-汤谷标志，背面写着“锐步践踏者”。"
	icon_state = "stomper_box"
	w_class = SIZE_MEDIUM
	bypass_w_limit = /obj/item/clothing/shoes
	max_storage_space = 3
	can_hold = list(/obj/item/clothing/shoes)

/obj/item/storage/box/stompers/fill_preset_inventory()
	new /obj/item/clothing/shoes/stompers(src)

/obj/item/storage/box/stompers/update_icon()
	if(!length(contents))
		icon_state = "stomper_box_e"
	else
		icon_state = "stomper_box"

////////// MARINES BOXES //////////////////////////


/obj/item/storage/box/explosive_mines
	name = "M20A2 地雷盒"
	desc = "装有五枚 M20 反步兵感应地雷的安全盒。"
	icon = 'icons/obj/items/storage/packets.dmi'
	icon_state = "minebox"
	w_class = SIZE_MEDIUM
	max_storage_space = 10
	can_hold = list(/obj/item/explosive/mine/strong)

/obj/item/storage/box/explosive_mines/fill_preset_inventory()
	for(var/i in 1 to 5)
		new /obj/item/explosive/mine/strong(src)

/obj/item/storage/box/explosive_mines/pmc
	name = "\improper M20A2P 地雷盒"

/obj/item/storage/box/explosive_mines/pmc/fill_preset_inventory()
	for(var/i in 1 to 5)
		new /obj/item/explosive/mine/pmc/strong(src)

/obj/item/storage/box/flare
	name = "M94 标记照明弹包"
	desc = "一包十四枚 M94 标记照明弹。USCM 士兵用它照亮普通 TNR 肩灯照不到的黑暗区域。"
	icon_state = "m94"
	icon = 'icons/obj/items/storage/packets.dmi'
	w_class = SIZE_MEDIUM
	storage_slots = 14
	max_storage_space = 14
	can_hold = list(/obj/item/device/flashlight/flare,/obj/item/device/flashlight/flare/signal)

/obj/item/storage/box/flare/fill_preset_inventory()
	for(var/i = 1 to max_storage_space)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/box/flare/update_icon()
	if(!length(contents))
		icon_state = "m94_e"
	else
		icon_state = "m94"

/obj/item/storage/box/flare/signal
	name = "M89-S 信号照明弹包"
	desc = "一包十四枚 M89-S 信号标记照明弹。"
	icon_state = "m89"

/obj/item/storage/box/flare/signal/fill_preset_inventory()
	for(var/i = 1 to max_storage_space)
		new /obj/item/device/flashlight/flare/signal(src)

/obj/item/storage/box/flare/signal/update_icon()
	if(!length(contents))
		icon_state = "m89_e"
	else
		icon_state = "m89"

/obj/item/storage/box/flare/upp
	name = "R52 标记照明弹包"
	desc = "一包十四枚 R52 标记照明弹。UPPAC 士兵用它照亮普通肩灯照不到的黑暗区域。"
	icon_state = "r52"
	icon = 'icons/obj/items/storage/packets.dmi'
	storage_slots = 14
	max_storage_space = 14
	can_hold = list(/obj/item/device/flashlight/flare,/obj/item/device/flashlight/flare/signal)

/obj/item/storage/box/flare/upp/fill_preset_inventory()
	for(var/i = 1 to max_storage_space)
		new /obj/item/device/flashlight/flare/upp(src)

/obj/item/storage/box/flare/upp/update_icon()
	if(!length(contents))
		icon_state = "r52_e"
	else
		icon_state = "r52"

/obj/item/storage/box/flare/rmc
	name = "L96 照明弹包"
	desc = "一包十四枚 L96 照明弹。TWE 士兵用它照亮普通肩灯照不到的黑暗区域。"
	icon_state = "l96"
	can_hold = list(/obj/item/device/flashlight/flare/rmc)

/obj/item/storage/box/flare/rmc/fill_preset_inventory()
	for(var/i = 1 to max_storage_space)
		new /obj/item/device/flashlight/flare/rmc(src)

/obj/item/storage/box/flare/rmc/update_icon()
	if(!length(contents))
		icon_state = "l96_e"
	else
		icon_state = "l96"

//ITEMS-----------------------------------//

/obj/item/storage/box/upp_radio_key
	name = "进步人民联盟军用加密密钥盒"
	desc = "内装无线电加密密钥，可插入无线电耳机。"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "uppkeycase"
	var/icon_lid = "uppkeycase_lid"
	w_class = SIZE_SMALL
	max_w_class = SIZE_TINY
	storage_slots = 4
	can_hold = list(/obj/item/device/encryptionkey)
	use_sound = "toolbox"

/obj/item/storage/box/upp_radio_key/fill_preset_inventory()
	new /obj/item/device/encryptionkey/upp(src)
	new /obj/item/device/encryptionkey/upp(src)
	new /obj/item/device/encryptionkey/upp(src)
	new /obj/item/device/encryptionkey/upp(src)

/obj/item/storage/box/upp_radio_key/update_icon()
	overlays.Cut()
	if(opened)
		overlays += image(icon, "uppkeycase_lid_open")
	else
		overlays += image(icon, icon_lid)
		return
	var/key_tally = -1
	for(var/obj/item/device/encryptionkey/radio_key in contents)
		key_tally++
		if(key_tally+1 > initial(storage_slots))
			return
		if(istype(radio_key, /obj/item/device/encryptionkey/upp))
			var/image/source_image = image(icon, "+upp_engi")
			source_image.pixel_x = key_tally*4
			overlays += source_image
		else
			if(istype(radio_key, /obj/item/device/encryptionkey/colony))
				var/image/source_image = image(icon, "+colony_key")
				source_image.pixel_x = key_tally*4
				overlays += source_image
			else
				if(istype(radio_key, /obj/item/device/encryptionkey))
					var/image/source_image = image(icon, "+generic_key")
					source_image.pixel_x = key_tally*4
					overlays += source_image

/obj/item/storage/box/upp_radio_key/colony
	name = "进步人民联盟民用无线电密钥盒"
	icon_lid = "uppkeycaseciv_lid"

/obj/item/storage/box/upp_radio_key/colony/fill_preset_inventory()
	new /obj/item/device/encryptionkey/colony(src)
	new /obj/item/device/encryptionkey/colony(src)
	new /obj/item/device/encryptionkey/colony(src)
	new /obj/item/device/encryptionkey/colony(src)

/obj/item/storage/box/upp_radio_key/engi
	name = "进步人民联盟工程加密密钥盒"
	icon_lid = "uppkeycaseengi_lid"

/obj/item/storage/box/upp_radio_key/engi/fill_preset_inventory()
	new /obj/item/device/encryptionkey/upp/engi(src)
	new /obj/item/device/encryptionkey/upp/engi(src)
	new /obj/item/device/encryptionkey/upp/engi(src)
	new /obj/item/device/encryptionkey/upp/engi(src)

/obj/item/storage/box/lightstick
	name = "照明棒盒"
	desc = "内装蓝色照明棒。"
	icon_state = "lightstick"
	can_hold = list(/obj/item/lightstick)

/obj/item/storage/box/lightstick/fill_preset_inventory()
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)

/obj/item/storage/box/lightstick/red
	desc = "内装红色照明棒。"
	icon_state = "lightstick2"

/obj/item/storage/box/lightstick/red/fill_preset_inventory()
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)

//food boxes for storage in bulk

//meat
/obj/item/storage/box/meat
	name = "整箱肉"

/obj/item/storage/box/meat/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/meat/monkey(src)

//fish
/obj/item/storage/box/fish
	name = "整箱鱼"

/obj/item/storage/box/fish/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/carpmeat(src)

//grocery

//milk
/obj/item/storage/box/milk
	name = "整箱牛奶"

/obj/item/storage/box/milk/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/drinks/milk(src)

//soymilk
/obj/item/storage/box/soymilk
	name = "整箱豆奶"

/obj/item/storage/box/soymilk/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/drinks/soymilk(src)

//enzyme
/obj/item/storage/box/enzyme
	name = "整箱酶"

/obj/item/storage/box/enzyme/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/enzyme(src)

//dry storage

//flour
/obj/item/storage/box/flour
	name = "整箱面粉"

/obj/item/storage/box/flour/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/flour(src)

//sugar
/obj/item/storage/box/sugar
	name = "整箱糖"

/obj/item/storage/box/sugar/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/sugar(src)

//saltshaker
/obj/item/storage/box/saltshaker
	name = "整箱盐瓶"

/obj/item/storage/box/saltshaker/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/saltshaker(src)

//peppermill
/obj/item/storage/box/peppermill
	name = "整箱胡椒研磨瓶"

/obj/item/storage/box/peppermill/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/peppermill(src)

//mint
/obj/item/storage/box/mint
	name = "整箱薄荷糖"

/obj/item/storage/box/mint/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/mint(src)

// ORGANICS

//apple
/obj/item/storage/box/apple
	name = "整箱苹果"

/obj/item/storage/box/apple/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/apple(src)

//banana
/obj/item/storage/box/banana
	name = "整箱香蕉"

/obj/item/storage/box/banana/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/banana(src)

//chanterelle
/obj/item/storage/box/chanterelles
	name = "鸡油菌盒"

/obj/item/storage/box/chanterelle/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/mushroom/chanterelle(src)

//cherries
/obj/item/storage/box/cherries
	name = "整箱樱桃"

/obj/item/storage/box/cherries/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/cherries(src)

//chili
/obj/item/storage/box/chili
	name = "整箱辣椒"

/obj/item/storage/box/chili/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/chili(src)

//cabbage
/obj/item/storage/box/cabbage
	name = "整箱卷心菜"

/obj/item/storage/box/cabbage/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/cabbage(src)

//carrot
/obj/item/storage/box/carrot
	name = "整箱胡萝卜"

/obj/item/storage/box/carrot/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/carrot(src)

//corn
/obj/item/storage/box/corn
	name = "整箱玉米"

/obj/item/storage/box/corn/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/corn(src)

//eggplant
/obj/item/storage/box/eggplant
	name = "整箱茄子"

/obj/item/storage/box/eggplant/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/eggplant(src)

//lemon
/obj/item/storage/box/lemon
	name = "整箱柠檬"

/obj/item/storage/box/lemon/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/lemon(src)

//lime
/obj/item/storage/box/lime
	name = "整箱青柠"

/obj/item/storage/box/lime/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/lime(src)

//orange
/obj/item/storage/box/orange
	name = "整箱橙子"

/obj/item/storage/box/orange/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/orange(src)

//potato
/obj/item/storage/box/potato
	name = "整箱土豆"

/obj/item/storage/box/potato/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/potato(src)

//tomato
/obj/item/storage/box/tomato
	name = "整箱番茄"

/obj/item/storage/box/tomato/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/tomato(src)

//whitebeet
/obj/item/storage/box/whitebeet
	name = "整箱白甜菜"

/obj/item/storage/box/whitebeet/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/whitebeet(src)

/obj/item/storage/box/powderedmilk
	name = "奶粉包盒"
	desc = "上面有一块奇怪的污渍。"

/obj/item/storage/box/powderedmilk/fill_preset_inventory()
	new /obj/item/reagent_container/food/condiment/juice/milk(src)
	new /obj/item/reagent_container/food/condiment/juice/milk(src)
	new /obj/item/reagent_container/food/condiment/juice/milk(src)
	new /obj/item/reagent_container/food/condiment/juice/milk(src)
	new /obj/item/reagent_container/food/condiment/juice/milk(src)

/obj/item/storage/box/cheeseslices
	name = "“奶酪制品”切片盒"
	desc = "闻起来像塑料。"
	icon_state = "cheese_kit"

/obj/item/storage/box/cheeseslices/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/cheesewedge/mature/kraft(src)
