#define HELMET_GARB_RELAY_ICON_STATE "icon_state"
/obj/item/clothing/head/helmet
	name = "头盔"
	desc = "标准安保装备，可保护头部免受冲击。"
	icon_state = "helmet"
	item_state = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_atom = FPRINT|CONDUCT
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	flags_cold_protection = BODY_FLAG_HEAD
	flags_heat_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	siemens_coefficient = 0.7
	w_class = SIZE_MEDIUM
	pickup_sound = "armorequip"
	drop_sound = "armorequip"

/obj/item/clothing/head/helmet/verb/hidehair()
	set name = "Toggle Hair"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return

	if(flags_inv_hide & HIDETOPHAIR)
		flags_inv_hide &= ~HIDETOPHAIR
		to_chat(usr, "你把头发从[src]里放了出来。")
	else
		flags_inv_hide |= HIDETOPHAIR
		to_chat(usr, "你把头发塞进了[src]。")

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			H.update_hair()

/obj/item/clothing/head/helmet/riot
	name = "防暴头盔"
	desc = "一顶专为抵御近距离攻击设计的头盔，能够包住耳朵。"
	icon_state = "riot"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDETOPHAIR

/obj/item/clothing/head/helmet/riot/vintage_riot
	desc = "一顶伤痕累累、布满蛛网的防暴头盔，仍能保护你的耳朵。"
	icon_state = "old_riot"

/obj/item/clothing/head/helmet/augment
	name = "增强组件阵列"
	desc = "一顶装有光学与颅部增强组件的头盔。"
	icon_state = "v62"
	item_state = "v62"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0.5

/obj/item/clothing/head/helmet/HoS
	name = "安保主管帽"
	desc = "安保主管的帽子，能让下属认清谁说了算。"
	icon_state = "hoscap"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = COVEREYES
	flags_inv_hide = HIDEEARS
	flags_armor_protection = 0
	siemens_coefficient = 0.8

/obj/item/clothing/head/helmet/HoS/dermal
	name = "皮下护甲片"
	desc = "你不太清楚自己是怎么把它戴上摘下的，不过它确实能很好地嵌入你的头部。"
	icon_state = "dermal"
	item_state = "dermal"
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/warden
	name = "监狱长帽"
	desc = "配发给安保部监狱长的特制头盔，可保护头部免受冲击。"
	icon_state = "policehelm"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0

/obj/item/clothing/head/helmet/hop
	name = "人事主管帽"
	desc = "一顶时髦的帽子，既能抵御愤怒的前船员，又能给你一种手握大权的错觉。"
	icon_state = "hopcap"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0

/obj/item/clothing/head/helmet/formalcaptain
	name = "阅兵礼帽"
	desc = "任何身居指挥职位的人，都该有一顶完美的白色帽子，以彰显至高权威。"
	icon_state = "officercap"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_armor_protection = 0

/obj/item/clothing/head/helmet/swat
	name = "SWAT 头盔"
	desc = "常由训练有素的特警队员使用。"
	icon_state = "swat"
	item_state = "swat"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT
	siemens_coefficient = 0.5
	anti_hug = 1

/obj/item/clothing/head/helmet/thunderdome
	name = "雷霆竞技场头盔"
	desc = "<i>“让战斗开始吧！”</i>"
	icon_state = "thunderdome"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	item_state = "thunderdome"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROT
	siemens_coefficient = 1

/obj/item/clothing/head/helmet/gladiator
	name = "角斗士头盔"
	desc = "向您致敬，皇帝！赴死之人向您致敬。"
	icon_state = "gladiator"
	item_state = "gladiator"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEMASK|HIDEEARS|HIDEEYES|HIDEALLHAIR
	siemens_coefficient = 1
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/head/helmet/tactical
	name = "战术头盔"
	desc = "一顶可以安装多种附件的装甲头盔。"
	icon_state = "swathelm"
	item_state = "helmet"
	flags_inventory = COVEREYES|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES
	anti_hug = 1
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	siemens_coefficient = 0.7


//===========================//MARINES HELMETS\\=================================\\
//=======================================================================\\

GLOBAL_LIST_INIT(allowed_helmet_items, list(
	// TOBACCO-RELATED
	/obj/item/tool/lighter/random = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/tool/lighter/zippo = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/box/matches = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/emeraldgreen = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/kpack = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/lucky_strikes = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/wypacket = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/lady_finger = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/blackpack = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/arcturian_ace = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/spirit = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/spirit/yellow = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/laika = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigarettes/lucky_strikes_4 = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/storage/fancy/cigar/matchbook = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/mask/cigarette/cigar = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/mask/electronic_cigarette = HELMET_GARB_RELAY_ICON_STATE,

	// CARDS
	/obj/item/toy/deck = "helmet_card_deck",
	/obj/item/toy/deck/uno = "helmet_card_uno",
	/obj/item/toy/handcard = "helmet_card_card",
	/obj/item/toy/handcard/aceofspades = "ace_of_spades",
	/obj/item/toy/handcard/uno_reverse_red = "red_reverse",
	/obj/item/toy/handcard/uno_reverse_blue = "blue_reverse",
	/obj/item/toy/handcard/uno_reverse_yellow = "yellow_reverse",
	/obj/item/toy/handcard/uno_reverse_purple = "purple_reverse",

	// FOOD AND SNACKS
	/obj/item/reagent_container/food/drinks/flask = "helmet_flask",
	/obj/item/reagent_container/food/drinks/flask/marine = "helmet_flask",
	/obj/item/reagent_container/food/snacks/eat_bar = "helmet_snack_eat",
	/obj/item/reagent_container/food/snacks/mushroompizzaslice = "pizza", // Fuck whoever put these under different paths for some REASON
	/obj/item/reagent_container/food/snacks/vegetablepizzaslice = "pizza",
	/obj/item/reagent_container/food/snacks/meatpizzaslice = "pizza",
	/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/reagent_container/food/snacks/wrapped/chunk = "chunkbox",
	/obj/item/reagent_container/food/snacks/microwavable/donkpocket = "donkpocket",
	/obj/item/reagent_container/food/snacks/wrapped/booniebars = "boonie-bars",
	/obj/item/reagent_container/food/snacks/wrapped/barcardine = "barcardine-bars",


	// EYEWEAR
	/obj/item/clothing/glasses/mgoggles = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/prescription = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/black = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/black/prescription = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/orange = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/orange/prescription = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/green = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/green/prescription = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/upp = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/mgoggles/upp/prescription = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/glasses/sunglasses = "sunglasses",
	/obj/item/clothing/glasses/sunglasses/prescription = "sunglasses",
	/obj/item/clothing/glasses/sunglasses/aviator = "aviator",
	/obj/item/clothing/glasses/sunglasses/big = "bigsunglasses",
	/obj/item/clothing/glasses/sunglasses/sechud = "sechud",
	/obj/item/clothing/glasses/eyepatch = "eyepatch",
	/obj/item/clothing/glasses/regular/hipster = "persc-glasses",

	//GASMASK
	/obj/item/clothing/mask/gas/military = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/mask/gas/military/upp = HELMET_GARB_RELAY_ICON_STATE,

	// WALKMAN AND CASSETTES
	/obj/item/device/walkman = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/device/cassette_tape/pop1 = "cassette_blue",
	/obj/item/device/cassette_tape/pop2 = "cassette_rainbow",
	/obj/item/device/cassette_tape/pop3 = "cassette_orange",
	/obj/item/device/cassette_tape/pop4 = "cassette_pink_stripe",
	/obj/item/device/cassette_tape/heavymetal = "cassette_red_black",
	/obj/item/device/cassette_tape/hairmetal = "cassette_red_stripe",
	/obj/item/device/cassette_tape/indie = "cassette_rising_sun",
	/obj/item/device/cassette_tape/hiphop = "cassette_orange_blue",
	/obj/item/device/cassette_tape/nam = "cassette_green",
	/obj/item/device/cassette_tape/ocean = "cassette_ocean",
	/obj/item/storage/pouch/cassette = "cassette_pouch",

	// PREFERENCES GEAR
	/obj/item/prop/helmetgarb/gunoil = "gunoil",
	/obj/item/prop/helmetgarb/netting = "netting",
	/obj/item/prop/helmetgarb/spent_buckshot = "spent_buckshot",
	/obj/item/prop/helmetgarb/spent_slug = "spent_slug",
	/obj/item/prop/helmetgarb/spent_flech = "spent_flech",
	/obj/item/prop/helmetgarb/cartridge = "cartridge",
	/obj/item/prop/helmetgarb/prescription_bottle = "prescription_bottle",
	/obj/item/prop/helmetgarb/raincover = "raincover",
	/obj/item/prop/helmetgarb/camocover = "camocover",
	/obj/item/prop/helmetgarb/camocover/desert = "d_camocover",
	/obj/item/prop/helmetgarb/camocover/snow = "s_camocover",
	/obj/item/prop/helmetgarb/rabbitsfoot = "rabbitsfoot",
	/obj/item/prop/helmetgarb/rosary = "helmet_rosary", // This one was already in the game for some reason, but never had an object
	/obj/item/prop/helmetgarb/lucky_feather = "lucky_feather",
	/obj/item/prop/helmetgarb/lucky_feather/blue = "lucky_feather_blue",
	/obj/item/prop/helmetgarb/lucky_feather/purple = "lucky_feather_purple",
	/obj/item/prop/helmetgarb/lucky_feather/yellow = "lucky_feather_yellow",
	/obj/item/prop/helmetgarb/trimmed_wire = "trimmed_wire",
	/obj/item/prop/helmetgarb/helmet_nvg = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/helmet_nvg/cosmetic = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/helmet_nvg/cosmetic/larp = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/helmet_nvg/marsoc = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/flair_initech = "flair_initech",
	/obj/item/prop/helmetgarb/flair_io = "flair_io",
	/obj/item/prop/helmetgarb/flair_peace ="flair_peace_smiley",
	/obj/item/prop/helmetgarb/flair_uscm = "flair_uscm",
	/obj/item/prop/helmetgarb/bullet_pipe = "bullet_pipe",
	/obj/item/prop/helmetgarb/spacejam_tickets = "tickets_to_space_jam",
	/obj/item/prop/helmetgarb/family_photo = "family_photo",
	/obj/item/prop/helmetgarb/compass = "compass",
	/obj/item/prop/helmetgarb/bug_spray = "bug_spray",

	// MISC
	/obj/item/tool/pen = "helmet_pen_black",
	/obj/item/tool/pen/blue = "helmet_pen_blue",
	/obj/item/tool/pen/red = "helmet_pen_red",
	/obj/item/clothing/glasses/welding ="welding-h",
	/obj/item/clothing/head/headband = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/tan = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/red = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/brown = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/gray = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/alpha = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/bravo = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/charlie = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/delta = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/echo = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/clothing/head/headband/foxtrot = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/tool/candle = "candle",
	/obj/item/clothing/mask/facehugger/lamarr = "lamarr",
	/obj/item/toy/crayon/red = "crayonred",
	/obj/item/toy/crayon/orange = "crayonorange",
	/obj/item/toy/crayon/yellow = "crayonyellow",
	/obj/item/toy/crayon/green = "crayongreen",
	/obj/item/toy/crayon/blue = "crayonblue",
	/obj/item/toy/crayon/purple = "crayonpurple",
	/obj/item/toy/crayon/rainbow = "crayonrainbow",
	/obj/item/toy/crayon/pride/trans = "crayontrans",
	/obj/item/toy/crayon/pride/gay = "crayongay",
	/obj/item/toy/crayon/pride/lesbian = "crayonlesbian",
	/obj/item/toy/crayon/pride/bi = "crayonbi",
	/obj/item/toy/crayon/pride/pan = "crayonpan",
	/obj/item/toy/crayon/pride/ace = "crayonace",
	/obj/item/toy/crayon/pride/trans = "crayontrans",
	/obj/item/toy/crayon/pride/enby = "crayonenby",
	/obj/item/toy/crayon/pride/fluid = "crayonfluid",
	/obj/item/paper = "paper",
	/obj/item/device/flashlight/flare = "flare",
	/obj/item/clothing/head/headset = "headset",
	/obj/item/ammo_magazine/handful = "bullet",
	/obj/item/prop/helmetgarb/riot_shield = "helmet_riot_shield",
	/obj/item/attachable/flashlight = HELMET_GARB_RELAY_ICON_STATE,
	/obj/item/prop/helmetgarb/chaplain_patch = "chaplain_patch",
	/obj/item/tool/pen/fountain = "fountainpen",

	// MEDICAL
	/obj/item/stack/medical/bruise_pack ="brutepack (bandages)",
	/obj/item/stack/medical/ointment = "ointment",
	/obj/item/tool/surgery/scalpel = "scalpel",
	/obj/item/reagent_container/hypospray/autoinjector = "helmet_injector",
	/obj/item/storage/pill_bottle/packet = "brutepack (bandages)",
))

/obj/item/clothing/head/helmet/marine
	name = "M10 式防弹头盔"
	desc = "制式高分子密度聚合物战斗头盔，可抵御轻武器擦击和弹片。内置战术摄像机、敌我识别应答器与抬头显示目镜。摄像系统还具备白热／黑热红外观察模式。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	health = 5
	force = 15
	throwforce = 15 // https://i.imgur.com/VW09I4B.gif
	attack_verb = list("敲击", "击打", "拍打", "殴打", "猛击")
	var/obj/structure/machinery/camera/camera
	var/helmet_overlays[]
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NONE
	var/flags_marine_helmet = HELMET_SQUAD_OVERLAY|HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY
	var/helmet_bash_cooldown = 0

	//speciality does NOTHING if you have NO_NAME_OVERRIDE
	var/specialty = "M10 式陆战队" //Give them a specialty var so that they show up correctly in vendors. speciality does NOTHING if you have NO_NAME_OVERRIDE.
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

	var/obj/item/storage/internal/headgear/pockets
	var/storage_slots = 2 // Small items like injectors, bandages, etc
	var/storage_slots_reserved_for_garb = 2 // Cosmetic items & now cigarettes and lighters for RP
	var/storage_max_w_class = SIZE_TINY // can hold tiny items only, EXCEPT for glasses & metal flask.
	var/storage_max_storage_space = 4

	/// The dmi where the grayscale squad overlays are contained
	var/helmet_overlay_icon = 'icons/mob/humans/onmob/head_1.dmi'

	///Any visors built into the helmet
	var/list/built_in_visors = list(new /obj/item/device/helmet_visor)

	///Any visors that have been added into the helmet
	var/list/inserted_visors = list()

	///Max amount of inserted visors
	var/max_inserted_visors = 1

	///The current active visor that is shown
	var/obj/item/device/helmet_visor/active_visor = null

	///Designates a visor type that should start down when initialized
	var/start_down_visor_type

/obj/item/clothing/head/helmet/marine/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT))
	. = ..()
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]头盔"

	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type, null, new_protection)

	helmet_overlays = list() //To make things simple.

	pockets = new(src)
	pockets.storage_slots = HAS_FLAG(flags_marine_helmet, HELMET_GARB_OVERLAY) ? storage_slots + storage_slots_reserved_for_garb : storage_slots
	pockets.slots_reserved_for_garb = HAS_FLAG(flags_marine_helmet, HELMET_GARB_OVERLAY) ? storage_slots_reserved_for_garb : 0
	pockets.max_w_class = storage_max_w_class
	pockets.bypass_w_limit = GLOB.allowed_helmet_items
	pockets.max_storage_space = storage_max_storage_space

	camera = new /obj/structure/machinery/camera/overwatch(src)

	for(var/obj/visor as anything in built_in_visors)
		visor.forceMove(src)

	if(length(inserted_visors) || length(built_in_visors))
		var/datum/action/item_action/cycle_helmet_huds/new_action = new(src)
		if(ishuman(loc))
			var/mob/living/carbon/human/holding_human = loc
			if(holding_human.head == src)
				new_action.give_to(holding_human)

	if(start_down_visor_type)
		for(var/obj/item/device/helmet_visor/cycled_visor in (built_in_visors + inserted_visors))
			if(cycled_visor.type == start_down_visor_type)
				active_visor = cycled_visor
				break

		if(active_visor)
			var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in actions
			if(cycle_action)
				cycle_action.set_action_overlay(active_visor)

/obj/item/clothing/head/helmet/marine/Destroy(force)
	helmet_overlays = null
	QDEL_NULL(camera)
	QDEL_NULL(pockets)
	if(active_visor && istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/potential_user = loc
		if(potential_user.head == src)
			var/obj/item/device/helmet_visor/temp_visor_holder = active_visor
			active_visor = null
			toggle_visor(potential_user, temp_visor_holder, TRUE)
	return ..()

/obj/item/clothing/head/helmet/marine/attack_hand(mob/user)
	if(loc != user)
		..(user) // If it's in a satchel or something don't open the pockets
		return

	if(pockets.handle_attack_hand(user))
		..(user)


/obj/item/clothing/head/helmet/marine/MouseDrop(over_object, src_location, over_location)
	SEND_SIGNAL(usr, COMSIG_ITEM_DROPPED, usr)
	if(pockets.handle_mousedrop(usr, over_object))
		..()

/obj/item/clothing/head/helmet/marine/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ammo_magazine) && world.time > helmet_bash_cooldown && user)
		var/obj/item/ammo_magazine/M = attacking_item
		var/ammo_level = "还有超过一半弹药。"
		playsound(user, 'sound/items/trayhit1.ogg', 15, FALSE)
		if(M.current_rounds == (M.max_rounds/2))
			ammo_level = "还剩一半弹药。"
		if(M.current_rounds < (M.max_rounds/2))
			ammo_level = "剩下的弹药不到一半。"
		if(M.current_rounds < (M.max_rounds/6))
			ammo_level = "快空了。"
		if(M.current_rounds == 0)
			ammo_level = "已经空了。糟糕。"
		user.visible_message("[user]用[M]敲了敲自己的头盔。", "你用[M]敲了敲自己的头盔。弹匣[ammo_level]")
		helmet_bash_cooldown = world.time + 20 SECONDS
		return

	if(istype(attacking_item, /obj/item/device/helmet_visor))
		if(length(inserted_visors) >= max_inserted_visors)
			to_chat(user, SPAN_NOTICE("[src]的所有目镜接口都已占用。"))
			return

		var/obj/item/device/helmet_visor/new_visor = attacking_item
		for(var/obj/item/device/helmet_visor/cycled_visor as anything in (built_in_visors + inserted_visors))
			if(cycled_visor.type == new_visor.type)
				to_chat(user, SPAN_NOTICE("[src]已经装有这种抬头显示器。"))
				return
		if(!user.drop_held_item())
			return

		inserted_visors += new_visor
		to_chat(user, SPAN_NOTICE("你把[new_visor]接到了[src]上。"))
		new_visor.forceMove(src)
		if(!(locate(/datum/action/item_action/cycle_helmet_huds) in actions))
			var/datum/action/item_action/cycle_helmet_huds/new_action = new(src)
			new_action.give_to(user)
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
		// If there isn't anything to remove, return.
		if(!length(inserted_visors))
			// If the user is trying to remove a built-in visor, give them a more helpful failure message.
			switch(length(built_in_visors))
				if(1) // Messy plural handling
					to_chat(user, SPAN_WARNING("[src]上的目镜是内置的！"))
				if(2 to INFINITY)
					to_chat(user, SPAN_WARNING("[src]上的这些目镜都是内置的！"))
			return

		if(active_visor)
			var/obj/item/device/helmet_visor/temp_visor_holder = active_visor
			active_visor = null
			toggle_visor(user, temp_visor_holder, TRUE)

		for(var/obj/item/device/helmet_visor/visor as anything in inserted_visors)
			visor.forceMove(get_turf(src))

		inserted_visors = list()
		to_chat(user, SPAN_NOTICE("你卸下了外接目镜。"))

		var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in actions
		cycle_action.set_default_overlay()
		if(!length(built_in_visors))
			cycle_action.remove_from(user)

		return

	..()
	return pockets.attackby(attacking_item, user)

/obj/item/clothing/head/helmet/marine/on_pocket_insertion()
	update_icon()

/obj/item/clothing/head/helmet/marine/on_pocket_removal()
	update_icon()

/obj/item/clothing/head/helmet/marine/update_icon()
	// Currently done by delegating to the human onmob head inventory updater
	// not the best *possible* solution, but this is complicated by the fact that
	// adding an image to src or trying to render it in overlays does nothing because
	// the "primary" icon of src is the holdable object, not the onmob.
	// the human sprite is the only thing that reliably renders things, so
	// we have to add overlays to that.
	helmet_overlays = list() // Rebuild our list every time
	if(pockets && length(pockets.contents) && (flags_marine_helmet & HELMET_GARB_OVERLAY))
		var/list/above_band_layer = list()
		var/list/below_band_layer = list()
		var/has_helmet_band = FALSE
		for(var/obj/O in pockets.contents)
			if(GLOB.allowed_helmet_items[O.type])
				var/has_band = !HAS_FLAG(O.flags_obj, OBJ_NO_HELMET_BAND)
				if(has_band)
					has_helmet_band = TRUE
				if(GLOB.allowed_helmet_items[O.type] == HELMET_GARB_RELAY_ICON_STATE)
					if(has_band)
						above_band_layer += "helmet_[O.icon_state]"
					else
						below_band_layer += "helmet_[O.icon_state]"
				else
					if(has_band)
						above_band_layer += GLOB.allowed_helmet_items[O.type]
					else
						below_band_layer += GLOB.allowed_helmet_items[O.type]
		if(has_helmet_band)
			helmet_overlays = above_band_layer + list("helmet_band") + below_band_layer
		else
			helmet_overlays = above_band_layer + below_band_layer

	if(active_visor)
		helmet_overlays += active_visor.helmet_overlay

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

/obj/item/clothing/head/helmet/marine/equipped(mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
	if(active_visor)
		recalculate_visors(mob)
	..()

/obj/item/clothing/head/helmet/marine/unequipped(mob/user, slot)
	. = ..()
	if(pockets)
		for(var/obj/item/attachable/flashlight/F in pockets)
			if(F.light_on)
				F.activate_attachment(src, user, TRUE)
	if(active_visor)
		recalculate_visors(user)

/obj/item/clothing/head/helmet/marine/dropped(mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "Unknown"
	if(pockets)
		for(var/obj/item/attachable/flashlight/F in pockets)
			if(F.light_on)
				F.activate_attachment(src, mob, TRUE)
	if(active_visor)
		recalculate_visors(mob)
	..()

/obj/item/clothing/head/helmet/marine/has_garb_overlay()
	return flags_marine_helmet & HELMET_GARB_OVERLAY

/obj/item/clothing/head/helmet/marine/get_examine_text(mob/user)
	. = ..()
	if(active_visor)
		. += active_visor.get_helmet_examine_text()

/obj/item/clothing/head/helmet/marine/proc/add_hugger_damage() //This is called in XenoFacehuggers.dm to first add the overlay and set the var.
	if(flags_marine_helmet & HELMET_DAMAGE_OVERLAY && !(flags_marine_helmet & HELMET_IS_DAMAGED))
		helmet_overlays["damage"] = image('icons/obj/items/clothing/cm_hats.dmi',icon_state = "hugger_damage")
		flags_marine_helmet |= HELMET_IS_DAMAGED
		update_icon()
		desc += "\n<b>这顶头盔似乎布满划痕并已受损，尤其是面部周围……</b>"

/obj/item/clothing/head/helmet/marine/get_pockets()
	if(pockets)
		return pockets
	return ..()

/// Recalculates and sets the proper visor effects
/obj/item/clothing/head/helmet/marine/proc/recalculate_visors(mob/user)
	turn_off_visors(user)

	if(!active_visor)
		return

	if(user != loc)
		return

	var/mob/living/carbon/human/human_user = user
	if(!human_user || human_user.head != src)
		return

	toggle_visor(user, silent = TRUE)

/// Toggles the specified visor, if nothing specified then the active visor, if the visor is the active visor and the helmet is on the user's head it will turn on, if it is not the active visor it will turn off
/obj/item/clothing/head/helmet/marine/proc/toggle_visor(mob/user, obj/item/device/helmet_visor/current_visor, silent = FALSE)
	current_visor = current_visor || active_visor

	if(!current_visor)
		return

	current_visor.toggle_visor(src, user, silent)

	update_icon()

/// Attempts to turn off all visors
/obj/item/clothing/head/helmet/marine/proc/turn_off_visors(mob/user)
	var/list/total_visors = built_in_visors + inserted_visors

	for(var/obj/item/device/helmet_visor/cycled_helmet_visor in total_visors)
		cycled_helmet_visor.deactivate_visor(src, user)

	update_icon()

///Cycles the active HUD to the next between built_in_visors and inserted_visors, nullifies if at end and removes all HUDs
/obj/item/clothing/head/helmet/marine/proc/cycle_huds(mob/user)
	var/list/total_visors = built_in_visors + inserted_visors

	if(!length(total_visors))
		to_chat(user, SPAN_WARNING("没有可切换的目镜。"))
		return FALSE

	if(active_visor)
		var/visor_to_deactivate = active_visor
		var/skipped_hud = FALSE
		var/iterator = 1
		for(var/obj/item/device/helmet_visor/current_visor as anything in total_visors)
			if(current_visor == active_visor || skipped_hud)
				if(length(total_visors) > iterator)
					var/obj/item/device/helmet_visor/next_visor = total_visors[iterator + 1]

					if(!isnull(GLOB.huds[next_visor.hud_type]?.hudusers[user]))
						iterator++
						skipped_hud = TRUE
						continue

					if(!next_visor.can_toggle(user))
						iterator++
						skipped_hud = TRUE
						continue

					active_visor = next_visor
					toggle_visor(user, visor_to_deactivate, silent = TRUE) // disables the old visor
					toggle_visor(user)
					return active_visor
				else
					active_visor = null
					toggle_visor(user, visor_to_deactivate, FALSE)
					return FALSE
			iterator++

	for(var/obj/item/device/helmet_visor/new_visor in total_visors)
		if(!isnull(GLOB.huds[new_visor.hud_type]?.hudusers[user]))
			continue

		if(!new_visor.can_toggle(user))
			continue

		active_visor = new_visor
		toggle_visor(user)
		return active_visor

	to_chat(user, SPAN_WARNING("目前没有可切换的目镜。"))
	return FALSE

/datum/action/item_action/cycle_helmet_huds/New(Target, obj/item/holder)
	. = ..()
	name = "切换头盔抬头显示器"
	button.name = name
	set_default_overlay()

/datum/action/item_action/cycle_helmet_huds/action_activate()
	. = ..()
	var/obj/item/clothing/head/helmet/marine/holder_helmet = holder_item
	var/cycled_hud = holder_helmet.cycle_huds(usr)

	set_action_overlay(cycled_hud)

/// Sets the action overlay based on the visor type
/datum/action/item_action/cycle_helmet_huds/proc/set_action_overlay(obj/item/device/helmet_visor/new_visor)
	if(!new_visor)
		set_default_overlay()
		return

	action_icon_state = new_visor.action_icon_string
	button.overlays.Cut()
	button.overlays += image('icons/obj/items/clothing/helmet_visors.dmi', button, action_icon_state)

/// Sets the action overlay to default hud sight up
/datum/action/item_action/cycle_helmet_huds/proc/set_default_overlay()
	action_icon_state = "hud_sight_up"
	button.overlays.Cut()
	button.overlays += image('icons/obj/items/clothing/helmet_visors.dmi', button, action_icon_state)

/obj/item/clothing/head/helmet/marine/tech
	name = "M10 技术员头盔"
	desc = "为战斗技术员改装的 M10 陆战队头盔，带有可翻下的焊接面罩以保护眼睛。"
	icon_state = "tech_helmet"
	specialty = "M10 技术员"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/welding_visor)

/obj/item/clothing/head/helmet/marine/grey
	desc = "一顶标准 M10 式头盔，尚未涂装迷彩。右侧内置摄像机。"
	icon_state = "c_helmet"
	item_state = "c_helmet"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/jungle
	icon_state = "helmet"
	item_state = "helmet"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/snow
	icon_state = "s_helmet"
	item_state = "s_helmet"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/desert
	icon_state = "d_helmet"
	item_state = "d_helmet"
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/tech/tanker
	name = "Mk20 坦克乘员头盔"
	desc = "较旧的 Mk20 先进装甲乘员头盔，源自 Mk30 前身计划，带有可翻下的焊接面罩。侧面摄像机与生物测量发射器可接入传感器矩阵。"
	icon_state = "tanker_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	specialty = "M50 坦克乘员"
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/welding_visor/tanker)

/obj/item/clothing/head/helmet/marine/medic
	name = "M10 医疗兵头盔"
	desc = "配发给陆战队医疗兵的 M10 战斗头盔。正面画着红十字，伤员与狙击手都很容易注意到它。"
	icon_state = "med_helmet"
	flags_atom = NO_NAME_OVERRIDE
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/advanced)
	start_down_visor_type = /obj/item/device/helmet_visor/medical/advanced

/obj/item/clothing/head/helmet/marine/medic/white
	name = "M10 白色医疗兵头盔"
	desc = "陆战队医疗兵佩戴的 M10 头盔型号。采用医用白色涂装，正面画有红底白十字。"
	icon_state = "med_helmet_white"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/medic/plain
	desc = "配发给陆战队医疗兵的 M10 战斗头盔。除集成医疗光学瞄具外，与标准陆战队 M10 完全相同。"
	icon_state = "helmet"

/obj/item/clothing/head/helmet/marine/covert
	name = "M10 隐蔽作战头盔"
	desc = "为昏暗环境设计的M10陆战队头盔型号，表面涂有特殊的防反光涂料。"
	icon_state = "marsoc_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/leader
	name = "M09 式头盔"
	desc = "旧款战斗头盔的库存型号。戴着不舒服，但据说额外防护值得这点牺牲。接线标准相同，仍可正常接入传感器矩阵。"
	icon_state = "sl_helmet"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/rto
	name = "M12 式头盔"
	desc = "采购落选、限量生产的旧 M10 防弹头盔后继型号。新型陶瓷复合材料与悬挂系统显著提高了抗钝击能力，改良布线还腾出了第二个光学设备接口。"
	icon_state = "io"
	item_state = "io"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	flags_atom = NO_NAME_OVERRIDE
	max_inserted_visors = 2

/obj/item/clothing/head/helmet/marine/rto/intel
	name = "XM12 式情报头盔"
	desc = "一顶实验型脑袋铁桶，后面还垂着一块防尘披布。代价是有点丢脸，换来的则是略好的钝击防护，还能装第二个光学目镜。可到了追悼会上，谁还笑得出来？反正不是你，你正忙着领取情报工作奖章呢。"
	specialty = "XM12 pattern intel"

/obj/item/clothing/head/helmet/marine/specialist
	name = "B18 头盔"
	desc = "B18护甲系统的头盔与面甲组件，采用纳米键合碳纤维与超高分子密度聚合物层压制成，集成循环呼吸器和抬头显示器。"
	icon_state = "grenadier_helmet"
	item_state = "grenadier_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	unacidable = TRUE
	anti_hug = 6
	force = 20
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/grenadier
	name = "M12 榴弹兵头盔"
	desc = "严格来说，M12 更接近 B 系列护甲系统的分支。全封闭结构，配有听力保护和吸收爆炸冲击的抗冲击液体护甲层。USCMC 突击队有时在近战和大量使用手榴弹的行动中采用它。"
	icon_state = "grenadier_helmet"
	item_state = "grenadier_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	unacidable = TRUE
	anti_hug = 6
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/scout
	name = "M10-S 轻型头盔"
	icon_state = "scout_helmet"
	desc = "装有热伪装装置和改良雷达吸波外壳的M10头盔，配发给USCMC侦察兵。"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/pyro
	name = "M10-P 火焰兵头盔"
	icon_state = "pyro_helmet"
	desc = "具备全面面部防护与内置呼吸装置的 M10 变体。聚合物复合材料实现环境密封并抵御燃烧。"
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT|ALLOWCPR
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/M3T
	name = "M10-R 轰炸手头盔"
	icon_state = "sadar_helmet"
	desc = "M10 战斗头盔，配有加强悬挂内衬和改良听力保护，适合使用 M5 RPG 等高冲击武器的人员，也配发给载具乘员。"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	armor_bomb = CLOTHING_ARMOR_HIGH
	flags_atom = NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	unacidable = TRUE

/obj/item/clothing/head/helmet/upp/marinepilot //just so it uses the wide overlay for garbs
	name = "MK30 战术头盔"
	desc = "美洲联盟条约部队的标准飞行头盔，可能是联合采购办公室少数拿得出手的成果之一。可翻下的偏光面罩支持增强现实功能，能实时提供相关数据。"
	icon_state = "helmetp"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	built_in_visors = list(new /obj/item/device/helmet_visor/po_visor)
	specialty = "MK30 tactical"

/obj/item/clothing/head/helmet/upp/marinepilot/tex
	name = "定制Mk30战术头盔"
	desc = "美洲联盟条约部队的标准飞行头盔，可能是联合采购办公室少数拿得出手的成果之一。可翻下的偏光面罩支持增强现实功能，能实时提供相关数据。这顶上面画着得克萨斯旗。"
	icon_state = "helmetp_tex"
	item_state = "helmetp_tex"
	built_in_visors = list(new /obj/item/device/helmet_visor/po_visor/lightblue)

/obj/item/clothing/head/helmet/upp/marinepilot/merc //just so it uses the wide overlay for garbs
	name = "DP MK80-TAC 航空头盔"
	desc = "以美洲联盟条约部队标准飞行头盔为蓝本的仿制品，大概是戴维斯专营公司偷来或捡到样品后，用更便宜的材料复制出来，再卖个天价。戴着不太舒服，倒是附带一副很酷、却毫无用处的护目镜！"
	icon_state = "pilot_merc"
	item_state = "pilot_merc"


/obj/item/clothing/head/helmet/marine/ghillie
	name = "M10 吉利伪装头盔"
	desc = "装有热伪装吉利条的 M10 头盔，由 USCMC 侦察狙击手使用并自行改装。"
	icon_state = "ghillie_coif"
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	flags_marine_helmet = HELMET_GARB_OVERLAY
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/CO
	name = "M10 式指挥官头盔"
	desc = "USCM 指挥官佩戴的特制 M10 式头盔。标签上写着：“决定葬礼能否开棺的关键。戴在头上效果最佳。”"
	icon_state = "co_officer"
	item_state = "co_officer"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "M10 式指挥官"
	flags_atom = NO_SNOW_TYPE
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/medical/advanced, new /obj/item/device/helmet_visor/security)

/obj/item/clothing/head/helmet/marine/MP
	name = "M10 式 MP 头盔"
	desc = "USCM 宪兵佩戴的 M10 式头盔特别型号。无论面对犯罪集团还是兵变，这个铁桶都能护住你的脑袋。"
	icon_state = "mp_helmet"
	item_state = "mp_helmet"
	flags_atom = NO_NAME_OVERRIDE
	built_in_visors = list(new /obj/item/device/helmet_visor/security)
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/MP/WO
	name = "M3 式宪兵长头盔"
	desc = "通常配发给宪兵长的精制 M10 头盔变体。能让手下认清谁说了算。"
	icon_state = "cmp_helmet"
	item_state = "cmp_helmet"
	flags_atom = NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/MP/SO
	name = "M10 式指挥头盔"
	desc = "USCM 军官佩戴的 M10 式头盔特别型号，既能吸引大兵的目光，也能吸引狙击手的子弹。"
	icon_state = "helmet"
	item_state = "helmet"
	flags_atom = NO_NAME_OVERRIDE
	built_in_visors = list(new /obj/item/device/helmet_visor, new /obj/item/device/helmet_visor/medical/advanced)

/obj/item/clothing/head/helmet/marine/MP/provost/marshal
	name = "军法总监帽"
	desc = "军法总监佩戴的昂贵帽子，以文拉纤维作内衬，铺有碳化硼护片，经过精心裁制，勉强还算舒适。"
	icon_state = "pvmarshalhat"
	item_state = "pvmarshalhat"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_inventory = BLOCKSHARPOBJ|FULL_DECAP_PROTECTION

/obj/item/clothing/head/helmet/marine/sof
	name = "M09 定制头盔"
	desc = "一半是因为旧库存，一半是出于个人偏好。USCM MARSOC突击队使用的防弹头盔，按任务需求定制和升级。"
	icon_state = "marsoc_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	flags_atom = NO_NAME_OVERRIDE
	built_in_visors = list(new /obj/item/device/helmet_visor/night_vision/marine_raider, new /obj/item/device/helmet_visor/security)
	start_down_visor_type = /obj/item/device/helmet_visor/night_vision/marine_raider

//=============================//PMCS\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE //Let's make these keep their name and icon.
	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/veteran/canc
	name = "93式头盔"
	desc = "一顶过时的CANC式头盔。"
	icon_state = "canc"
	flags_inv_hide = HIDEEARS|HIDETOPHAIR

/obj/item/clothing/head/helmet/marine/veteran/pmc
	name = "龟甲战斗头盔"
	desc = "维兰德-汤谷精锐战术小队使用的制式高分子密度聚合物战斗头盔。最初设计为安全帽，后来改造成廉价可靠的战斗头盔系统，内置战术摄像机、敌我识别应答器和抬头显示镜片。摄像系统还支持白热／黑热红外模式。"
	icon_state = "pmc_helmet"
	flags_armor_protection = BODY_FLAG_HEAD
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY|HELMET_GARB_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/pmc/sniper
	name = "Mk12 精确射手头盔"
	desc = "RMC 精确射手与狙击手使用的非制式头盔，这一顶为维兰德-汤谷精锐战术小队涂成了白色。比后续型号更能抵御轻武器擦击与弹片，但也更重。内置战术摄像机、敌我识别应答器和带夜视功能的抬头显示镜片。摄像系统还支持白热／黑热红外模式。"
	icon_state = "pmc_sniper_hat"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW

/obj/item/clothing/head/helmet/marine/veteran/pmc/sniper/rmc
	desc = "RMC 精确射手与狙击手使用的非制式头盔。比后续型号更能抵御轻武器擦击与弹片，但也更重。开放式面部设计未集成呼吸调温器。内置战术摄像机、敌我识别应答器和带夜视功能的抬头显示镜片。摄像系统还支持白热／黑热红外模式。"
	icon_state = "rmc_sniper_hat"
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/advanced/rmc/alt)
	start_down_visor_type = /obj/item/device/helmet_visor/medical/advanced/rmc/alt

/obj/item/clothing/head/helmet/marine/veteran/pmc/gunner
	name = "Mk16 战术头盔"
	desc = "RMC 制式高分子密度聚合物战斗头盔与防弹面罩，这一顶为维兰德-汤谷精锐战术小队涂成了白色。可抵御轻武器擦击与弹片，内置战术摄像机、敌我识别应答器和抬头显示镜片。摄像系统还支持白热／黑热红外模式。"
	icon_state = "heavy_wy"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|ALLOWINTERNALS|BLOCKGASEFFECT|ALLOWREBREATH|ALLOWCPR
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR

/obj/item/clothing/head/helmet/marine/veteran/pmc/gunner/rmc
	desc = "RMC 制式高分子密度聚合物战斗头盔与防弹面罩。可抵御轻武器擦击与弹片，内置战术摄像机、敌我识别应答器和带夜视功能的抬头显示镜片。摄像系统还支持白热／黑热红外模式。"
	icon_state = "heavy_rmc"
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/advanced/rmc)
	start_down_visor_type = /obj/item/device/helmet_visor/medical/advanced/rmc

/obj/item/clothing/head/helmet/marine/veteran/pmc/commando
	name = "M5X 头盔"
	desc = "与M5X外骨骼护甲配套的全封闭装甲头盔。"
	icon_state = "commando_helmet"
	item_state = "commando_helmet"
	unacidable = 1
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT|FULL_DECAP_PROTECTION
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	unacidable = TRUE

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate
	name = "维兰德-汤谷公司安保头盔"
	desc = "公司安保人员佩戴的基础头盔，防护标准是让你的脑袋挡得住一个拿着撬棍闹事的科学家。"
	icon = 'icons/mob/humans/onmob/contained/wy_goons.dmi'
	icon_state = "helmet"
	item_state = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	contained_sprite = TRUE

/obj/item/clothing/head/helmet/marine/veteran/pmc/corporate/lead
	desc = "公司安保人员佩戴的基础头盔。这款由那些脑容量太大、旧款头盔装不下的基层警卫佩戴。至少他们是这么说的。"
	icon_state = "lead_helmet"
	item_state = "lead_helmet"

//FIORINA / UA RIOT CONTROL HELMET//

/obj/item/clothing/head/helmet/marine/veteran/ua_riot
	name = "M10 式防弹头盔"
	desc = "制式高分子密度聚合物战斗头盔，可抵御轻武器擦击与弹片。这款经过简化，移除了通常内置的战术摄像机、敌我识别应答器和抬头显示目镜。"
	icon_state = "ua_riot"
	flags_atom = NO_SNOW_TYPE

// KUTJEVO HELMET

/obj/item/clothing/head/helmet/marine/veteran/kutjevo
	name = "库特耶沃头盔"
	desc = "配发给库特耶沃工人的制式头盔，带有小型织带收纳结构，可放置笔、油瓶，甚至爱人的照片等小物件。"
	icon_state = "kutjevo_helmet"
	item_state = "kutjevo_helmet"

//==========================//DISTRESS\\=================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/dutch
	name = "达奇十二人组头盔"
	desc = "经验极其丰富的雇佣兵佩戴的防护头盔。"
	icon_state = "dutch_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/dutch/cap
	name = "达奇十二人组便帽"
	desc = "经验极其丰富的雇佣兵佩戴的防护便帽。"
	icon_state = "dutch_cap"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/dutch/band
	name = "达奇十二人组头带"
	desc = "经验极其丰富的雇佣兵佩戴的防护头带。"
	icon_state = "dutch_band"
	flags_inventory = NO_FLAGS
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS

/obj/item/clothing/head/helmet/marine/veteran/bear
	name = "铁熊部队头盔"
	desc = "适合冬天戴，因为上面有个能灌伏特加的洞。"
	icon_state = "dutch_helmet"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/UPP
	name = "6B75 头盔"
	desc = "联盟的“阿尔玛兹”战斗头盔，属于库伊亚-M防护系统，采用薄合金破弹板与对位芳纶底层制成。头盔配有抵御弹片和跳弹的脸颊护板、低分辨率摄像系统、听力保护装置和集成通信系统，还预留了红外目镜或夜视系统接口。"
	icon_state = "upp_helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	flags_marine_helmet = HELMET_SQUAD_OVERLAY|HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY
	built_in_visors = list(new /obj/item/device/helmet_visor/upp)
	specialty = "6B75 helmet"

/obj/item/clothing/head/helmet/marine/veteran/UPP/heavy
	name = "6B79 头盔"
	desc = "UPP海军步兵使用的全封闭头盔，支持舱外活动。尽管防护等级更高，但其笨重的设计限制了它在海军步兵中的普及，因此主要配发给重武器操作员及其他专业岗位。"
	icon_state = "upp_helmet_heavy"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	specialty = "6B79 helmet"

/obj/item/clothing/head/helmet/marine/veteran/UPP/old
	name = "6B68 头盔"
	desc = "国土卫队和内卫部队仍在使用的旧款UPP联合武装头盔，具备战术数据链、音视频传输功能及红外成像系统接口。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_helmet_68"
	item_state = "helmet"
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NONE
	clothing_traits = null
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY
	specialty = "6B68 helmet"

//==========================//UPP\\=================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/upp
	name = "6B82 头盔"
	desc = "适用于多种环境的海军步兵头盔。合金／对位芳纶防弹外壳由三块独立护板组成，通过复杂内衬系统连接。可配合外大气作战头罩佩戴，提供战术数据链、音视频传输和红外成像系统接口。戴着意外地舒适。此型号的面料质感似橡胶，颜色与 UPP 护甲的标准涂装一致。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_helmet_naval"
	item_state = "helmet"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	health = 5
	force = 15
	throwforce = 15
	attack_verb = list("敲击", "击打", "拍打", "殴打", "猛击")
	var/obj/structure/machinery/camera/camera
	var/helmet_overlays[]
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NONE
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	var/flags_marine_helmet = HELMET_SQUAD_OVERLAY|HELMET_GARB_OVERLAY|HELMET_DAMAGE_OVERLAY
	var/helmet_bash_cooldown = 0

	var/specialty = "6B82 helmet"
	valid_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = list(ACCESSORY_SLOT_HELM_C)
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

	var/obj/item/storage/internal/headgear/pockets
	var/storage_slots = 2
	var/storage_slots_reserved_for_garb = 2
	var/storage_max_w_class = SIZE_TINY
	var/storage_max_storage_space = 4

	var/helmet_overlay_icon = 'icons/mob/humans/onmob/head_1.dmi'

	var/list/built_in_visors = list(new /obj/item/device/helmet_visor/upp)

	var/list/inserted_visors = list()

	var/max_inserted_visors = 1

	var/obj/item/device/helmet_visor/active_visor = null

	var/start_down_visor_type

/obj/item/clothing/head/helmet/upp/Initialize(mapload, new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT))
	. = ..()

	helmet_overlays = list()

	pockets = new(src)
	pockets.storage_slots = HAS_FLAG(flags_marine_helmet, HELMET_GARB_OVERLAY) ? storage_slots + storage_slots_reserved_for_garb : storage_slots
	pockets.slots_reserved_for_garb = HAS_FLAG(flags_marine_helmet, HELMET_GARB_OVERLAY) ? storage_slots_reserved_for_garb : 0
	pockets.max_w_class = storage_max_w_class
	pockets.bypass_w_limit = GLOB.allowed_helmet_items
	pockets.max_storage_space = storage_max_storage_space

	camera = new /obj/structure/machinery/camera/overwatch(src)

	for(var/obj/visor as anything in built_in_visors)
		visor.forceMove(src)

	if(length(inserted_visors) || length(built_in_visors))
		var/datum/action/item_action/cycle_helmet_huds/new_action = new(src)
		if(ishuman(loc))
			var/mob/living/carbon/human/holding_human = loc
			if(holding_human.head == src)
				new_action.give_to(holding_human)

	if(start_down_visor_type)
		for(var/obj/item/device/helmet_visor/cycled_visor in (built_in_visors + inserted_visors))
			if(cycled_visor.type == start_down_visor_type)
				active_visor = cycled_visor
				break

		if(active_visor)
			var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in actions
			if(cycle_action)
				cycle_action.set_action_overlay(active_visor)

/obj/item/clothing/head/helmet/upp/Destroy(force)
	helmet_overlays = null
	QDEL_NULL(camera)
	QDEL_NULL(pockets)
	if(active_visor && istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/potential_user = loc
		if(potential_user.head == src)
			var/obj/item/device/helmet_visor/temp_visor_holder = active_visor
			active_visor = null
			toggle_visor(potential_user, temp_visor_holder, TRUE)
	return ..()

/obj/item/clothing/head/helmet/upp/attack_hand(mob/user)
	if(loc != user)
		..(user)
		return

	if(pockets.handle_attack_hand(user))
		..(user)


/obj/item/clothing/head/helmet/upp/MouseDrop(over_object, src_location, over_location)
	SEND_SIGNAL(usr, COMSIG_ITEM_DROPPED, usr)
	if(pockets.handle_mousedrop(usr, over_object))
		..()

/obj/item/clothing/head/helmet/upp/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ammo_magazine) && world.time > helmet_bash_cooldown && user)
		var/obj/item/ammo_magazine/M = attacking_item
		var/ammo_level = "还有超过一半弹药。"
		playsound(user, 'sound/items/trayhit1.ogg', 15, FALSE)
		if(M.current_rounds == (M.max_rounds/2))
			ammo_level = "还剩一半弹药。"
		if(M.current_rounds < (M.max_rounds/2))
			ammo_level = "剩下的弹药不到一半。"
		if(M.current_rounds < (M.max_rounds/6))
			ammo_level = "快空了。"
		if(M.current_rounds == 0)
			ammo_level = "已经空了。糟糕。"
		user.visible_message("[user]用[M]敲了敲自己的头盔。", "你用[M]敲了敲自己的头盔。弹匣[ammo_level]")
		helmet_bash_cooldown = world.time + 20 SECONDS
		return

	if(istype(attacking_item, /obj/item/device/helmet_visor))
		if(length(inserted_visors) >= max_inserted_visors)
			to_chat(user, SPAN_NOTICE("[src]的所有目镜接口都已占用。"))
			return

		var/obj/item/device/helmet_visor/new_visor = attacking_item
		for(var/obj/item/device/helmet_visor/cycled_visor as anything in (built_in_visors + inserted_visors))
			if(cycled_visor.type == new_visor.type)
				to_chat(user, SPAN_NOTICE("[src]已经装有这种抬头显示器。"))
				return
		if(!user.drop_held_item())
			return

		inserted_visors += new_visor
		to_chat(user, SPAN_NOTICE("你把[new_visor]接到了[src]上。"))
		new_visor.forceMove(src)
		if(!(locate(/datum/action/item_action/cycle_helmet_huds) in actions))
			var/datum/action/item_action/cycle_helmet_huds/new_action = new(src)
			new_action.give_to(user)
		return

	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
		if(!length(inserted_visors))
			switch(length(built_in_visors))
				if(1)
					to_chat(user, SPAN_WARNING("[src]上的目镜是内置的！"))
				if(2 to INFINITY)
					to_chat(user, SPAN_WARNING("[src]上的这些目镜都是内置的！"))
			return

		if(active_visor)
			var/obj/item/device/helmet_visor/temp_visor_holder = active_visor
			active_visor = null
			toggle_visor(user, temp_visor_holder, TRUE)

		for(var/obj/item/device/helmet_visor/visor as anything in inserted_visors)
			visor.forceMove(get_turf(src))

		inserted_visors = list()
		to_chat(user, SPAN_NOTICE("你卸下了外接目镜。"))

		var/datum/action/item_action/cycle_helmet_huds/cycle_action = locate() in actions
		cycle_action.set_default_overlay()
		if(!length(built_in_visors))
			cycle_action.remove_from(user)

		return

	..()
	return pockets.attackby(attacking_item, user)

/obj/item/clothing/head/helmet/upp/on_pocket_insertion()
	update_icon()

/obj/item/clothing/head/helmet/upp/on_pocket_removal()
	update_icon()

/obj/item/clothing/head/helmet/upp/update_icon()
	helmet_overlays = list()
	if(pockets && length(pockets.contents) && (flags_marine_helmet & HELMET_GARB_OVERLAY))
		var/list/above_band_layer = list()
		var/list/below_band_layer = list()
		var/has_helmet_band = FALSE
		for(var/obj/O in pockets.contents)
			if(GLOB.allowed_helmet_items[O.type])
				var/has_band = !HAS_FLAG(O.flags_obj, OBJ_NO_HELMET_BAND)
				if(has_band)
					has_helmet_band = TRUE
				if(GLOB.allowed_helmet_items[O.type] == HELMET_GARB_RELAY_ICON_STATE)
					if(has_band)
						above_band_layer += "wide_[O.icon_state]"
					else
						below_band_layer += "wide_[O.icon_state]"
				else
					if(has_band)
						above_band_layer += GLOB.allowed_helmet_items[O.type]
					else
						below_band_layer += GLOB.allowed_helmet_items[O.type]
		if(has_helmet_band)
			helmet_overlays = above_band_layer + list("wide_band") + below_band_layer
		else
			helmet_overlays = above_band_layer + below_band_layer

	if(active_visor)
		helmet_overlays += active_visor.helmet_overlay

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_head()

/obj/item/clothing/head/helmet/upp/equipped(mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
	if(active_visor)
		recalculate_visors(mob)
	..()

/obj/item/clothing/head/helmet/upp/unequipped(mob/user, slot)
	. = ..()
	if(pockets)
		for(var/obj/item/attachable/flashlight/F in pockets)
			if(F.light_on)
				F.activate_attachment(src, user, TRUE)
	if(active_visor)
		recalculate_visors(user)

/obj/item/clothing/head/helmet/upp/dropped(mob/living/carbon/human/mob)
	if(camera)
		camera.c_tag = "Unknown"
	if(pockets)
		for(var/obj/item/attachable/flashlight/F in pockets)
			if(F.light_on)
				F.activate_attachment(src, mob, TRUE)
	if(active_visor)
		recalculate_visors(mob)
	..()

/obj/item/clothing/head/helmet/upp/has_garb_overlay()
	return flags_marine_helmet & HELMET_GARB_OVERLAY

/obj/item/clothing/head/helmet/upp/get_examine_text(mob/user)
	. = ..()
	if(active_visor)
		. += active_visor.get_helmet_examine_text()

/obj/item/clothing/head/helmet/upp/proc/add_hugger_damage() //This is called in XenoFacehuggers.dm to first add the overlay and set the var.
	if(flags_marine_helmet & HELMET_DAMAGE_OVERLAY && !(flags_marine_helmet & HELMET_IS_DAMAGED))
		helmet_overlays["damage"] = image('icons/obj/items/clothing/cm_hats.dmi',icon_state = "hugger_damage")
		flags_marine_helmet |= HELMET_IS_DAMAGED
		update_icon()
		desc += "\n<b>这顶头盔似乎布满划痕并已受损，尤其是面部周围……</b>"

/obj/item/clothing/head/helmet/upp/get_pockets()
	if(pockets)
		return pockets
	return ..()

/obj/item/clothing/head/helmet/upp/proc/recalculate_visors(mob/user)
	turn_off_visors(user)

	if(!active_visor)
		return

	if(user != loc)
		return

	var/mob/living/carbon/human/human_user = user
	if(!human_user || human_user.head != src)
		return

	toggle_visor(user, silent = TRUE)

/obj/item/clothing/head/helmet/upp/proc/toggle_visor(mob/user, obj/item/device/helmet_visor/current_visor, silent = FALSE)
	current_visor = current_visor || active_visor

	if(!current_visor)
		return

	current_visor.toggle_visor(src, user, silent)

	update_icon()

/obj/item/clothing/head/helmet/upp/proc/turn_off_visors(mob/user)
	var/list/total_visors = built_in_visors + inserted_visors

	for(var/obj/item/device/helmet_visor/cycled_helmet_visor in total_visors)
		cycled_helmet_visor.deactivate_visor(src, user)

	update_icon()

/obj/item/clothing/head/helmet/upp/proc/cycle_huds(mob/user)
	var/list/total_visors = built_in_visors + inserted_visors

	if(!length(total_visors))
		to_chat(user, SPAN_WARNING("没有可切换的目镜。"))
		return FALSE

	if(active_visor)
		var/visor_to_deactivate = active_visor
		var/skipped_hud = FALSE
		var/iterator = 1
		for(var/obj/item/device/helmet_visor/current_visor as anything in total_visors)
			if(current_visor == active_visor || skipped_hud)
				if(length(total_visors) > iterator)
					var/obj/item/device/helmet_visor/next_visor = total_visors[iterator + 1]

					if(!isnull(GLOB.huds[next_visor.hud_type]?.hudusers[user]))
						iterator++
						skipped_hud = TRUE
						continue

					if(!next_visor.can_toggle(user))
						iterator++
						skipped_hud = TRUE
						continue

					active_visor = next_visor
					toggle_visor(user, visor_to_deactivate, silent = TRUE)
					toggle_visor(user)
					return active_visor
				else
					active_visor = null
					toggle_visor(user, visor_to_deactivate, FALSE)
					return FALSE
			iterator++

	for(var/obj/item/device/helmet_visor/new_visor in total_visors)
		if(!isnull(GLOB.huds[new_visor.hud_type]?.hudusers[user]))
			continue

		if(!new_visor.can_toggle(user))
			continue

		active_visor = new_visor
		toggle_visor(user)
		return active_visor

	to_chat(user, SPAN_WARNING("目前没有可切换的目镜。"))
	return FALSE

/obj/item/clothing/head/helmet/upp/alt
	desc = "适用于多种环境的海军步兵头盔。合金／对位芳纶防弹外壳由三块独立护板组成，通过复杂内衬系统连接。可配合外大气作战头罩佩戴，提供战术数据链、音视频传输和红外成像系统接口。戴着意外地舒适。此型号使用与 UPP 制服相同的面料。"
	icon_state = "upp_helmet_naval_alt"

/obj/item/clothing/head/uppcap
	name = "UL2 便帽"
	desc = "UPP军队的制式巡逻帽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_cap"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	siemens_coefficient = 2
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_VERYLOW
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = null

/obj/item/clothing/head/uppcap/civi
	name = "UL2c 便帽"
	icon_state = "upp_cap_civi"

/obj/item/clothing/head/uppcap/boonie
	name = "UL5 宽檐帽"
	desc = "配发给驻扎在酷热地区的国土卫队部队的制式软檐帽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_boonie"

/obj/item/clothing/head/uppcap/boonie/canc
	name = "丛林帽"
	desc = "采用CANC制服配色的丛林帽。"
	icon_state = "canc_boonie"

/obj/item/clothing/head/uppcap/beret/naval
	name = "UL4 海军步兵贝雷帽"
	desc = "UPP海军步兵佩戴的黑色贝雷帽。自豪地戴上它吧。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_beret_naval"

/obj/item/clothing/head/uppcap/beret/guerilla
	name = "红色贝雷帽"
	desc = "深受共产主义革命者喜爱的红色贝雷帽。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "upp_beret_revolution"

/obj/item/clothing/head/uppcap/beret
	name = "UL3 贝雷帽"
	desc = "UPP军队的制式贝雷帽。"
	icon_state = "upp_beret"

/obj/item/clothing/head/uppcap/peaked
	name = "UL3 大檐帽"
	desc = "UPP军队的制式常服大檐帽。"
	icon_state = "upp_peaked"

/obj/item/clothing/head/uppcap/peaked/police
	name = "UL3 人民武装警察大檐帽"
	desc = "人民武装警察的制式大檐帽。"
	icon_state = "upp_peaked_police"

/obj/item/clothing/head/uppcap/peaked/mss
	name = "UL3 太空安全部大檐帽"
	desc = "太空安全部的制式大檐帽。"
	icon_state = "upp_peaked_mss"

/obj/item/clothing/head/uppcap/ushanka
	name = "UL2 护耳帽"
	desc = "UPP军队的制式寒区帽。"
	icon_state = "upp_ushanka"
	item_state = "upp_ushanka"
	var/tied = FALSE
	var/original_state = "upp_ushanka"
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/uppcap/ushanka/verb/flaps_up()
	set name = "Tie Up/Down"
	set category = "Object"
	set src in usr
	if(usr.is_mob_incapacitated())
		return

	tied = !tied
	if(tied)
		to_chat(usr, SPAN_NOTICE("你把[src]的护耳绑了起来。"))
		icon_state += "_up"
	else
		to_chat(usr, SPAN_NOTICE("你解开了[src]的护耳。"))
		icon_state = original_state



	update_clothing_icon(src) //Update the on-mob icon.

/obj/item/clothing/head/uppcap/ushanka/civi
	name = "UL2c 护耳帽"
	icon_state = "upp_ushanka_civi"
	item_state = "upp_ushanka_civi"
	original_state = "upp_ushanka_civi"
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/helmet/marine/veteran/van_bandolier
	name = "遮阳盔"
	desc = "采用太空时代材料制成的时髦遮阳盔，轻便、透气、凉爽，还能提供防护。"
	icon_state = "van_bandolier"
	item_state = "s_helmet"
	flags_marine_helmet = NO_FLAGS

//head rag

/obj/item/clothing/head/helmet/specrag
	name = "武器专家头巾"
	desc = "重武器操作员用于挡汗的头巾。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "spec"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/helmet/specrag/New()
	select_gamemode_skin(type)
	..()

/obj/item/clothing/head/helmet/skullcap
	name = "软帽"
	desc = "能防止汗水流进眼睛。"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "skullcap"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	flags_inventory = NO_FLAGS
	flags_inv_hide = HIDEEARS|HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/helmet/skullcap/jungle
	name = "M8 精确射手头罩"
	desc = "精确射手在丛林中用于遮蔽面容的头罩。"
	icon_state = "skullcapm"

/obj/item/clothing/head/helmet/skullcap/jungle/New(loc, type,
	new_protection[] = list(MAP_ICE_COLONY = ICE_PLANET_MIN_COLD_PROT))
	select_gamemode_skin(type,, new_protection)
	..()
	switch(icon_state)
		if("s_skullcapm")
			desc = "一顶用于在苔原抵御寒冷、躲避敌人目光的兜帽。"
			flags_inv_hide = HIDEEARS|HIDEALLHAIR

//===========================//HELGHAST - MERCENARY\\================================\\
//=====================================================================\\

/obj/item/clothing/head/helmet/marine/veteran/mercenary
	name = "K12 陶瓷头盔"
	desc = "某个不明雇佣兵组织使用的坚固头盔。"
	icon_state = "mercenary_heavy_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR
	flags_marine_helmet = HELMET_DAMAGE_OVERLAY

/obj/item/clothing/head/helmet/marine/veteran/mercenary
	name = "改装K12陶瓷头盔"
	desc = "某个不明雇佣兵组织使用的坚固头盔，额外加装了护板。"
	armor_melee = CLOTHING_ARMOR_ULTRAHIGH
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_VERYHIGHPLUS

/obj/item/clothing/head/helmet/marine/veteran/mercenary/miner
	name = "Y8 矿工头盔"
	desc = "某个不明雇佣兵组织使用的坚固头盔，专为采矿设计。"
	icon_state = "mercenary_miner_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS


/obj/item/clothing/head/helmet/marine/veteran/mercenary/support
	name = "Z7 头盔"
	desc = "某个不明雇佣兵组织使用的坚固头盔。"
	icon_state = "mercenary_engineer_helmet"
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_HIGHPLUS

/obj/item/clothing/head/helmet/marine/veteran/mercenary/support/engineer
	desc = "某个不明雇佣兵组织使用的坚固头盔，配有可翻转的焊接面罩，以保护眼睛。"
	built_in_visors = list(new /obj/item/device/helmet_visor/welding_visor/mercenary)

//=============================//MEME\\==================================\\
//=======================================================================\\

/obj/item/clothing/head/helmet/marine/specialist/hefa
	name = "HEFA 头盔"
	specialty = "HEFA"
	desc = "不知为何，看到这顶头盔就让你极度不安。"
	icon_state = "hefa_helmet"
	item_state = "hefa_helmet"
	armor_bomb = CLOTHING_ARMOR_HARDCORE // the hefa knight stands
	flags_inv_hide = HIDEEARS|HIDEALLHAIR|HIDEEYES
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE
	armor_bullet = CLOTHING_ARMOR_VERYHIGH
	armor_melee = CLOTHING_ARMOR_VERYHIGH
	armor_bomb = CLOTHING_ARMOR_GIGAHIGH

	built_in_visors = list()

	var/mob/activator = null
	var/active = FALSE
	var/det_time = 40

/obj/item/clothing/head/helmet/marine/specialist/hefa/Initialize(mapload, list/new_protection)
	. = ..()
	pockets.bypass_w_limit = list(/obj/item/explosive/grenade/high_explosive/frag)

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/apply_explosion_overlay()
	var/obj/effect/overlay/O = new /obj/effect/overlay(loc)
	O.name = "grenade"
	O.icon = 'icons/effects/explosion.dmi'
	flick("grenade", O)
	QDEL_IN(O, 7)

/obj/item/clothing/head/helmet/marine/specialist/hefa/attack_self(mob/user)
	..()
	activator = user
	activate()

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/activate()
	if(active)
		return
	active = TRUE

	icon_state = initial(icon_state) + "_active"
	item_state = initial(item_state) + "_active"
	overlays += /obj/effect/overlay/danger
	playsound(loc, 'sound/weapons/armbomb.ogg', 25, 1, 6)

	addtimer(CALLBACK(src, PROC_REF(prime)), det_time)

/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/prime()
	INVOKE_ASYNC(src, PROC_REF(boom))

// Values nabbed from the HEFA nade
/obj/item/clothing/head/helmet/marine/specialist/hefa/proc/boom()
	// TODO: knock down user so the shrapnel isn't all taken by the user
	var/datum/cause_data/cause_data = create_cause_data(initial(name), activator)
	create_shrapnel(loc, 48, , ,/datum/ammo/bullet/shrapnel, cause_data)
	sleep(2) //so that mobs are not knocked down before being hit by shrapnel. shrapnel might also be getting deleted by explosions?
	apply_explosion_overlay()
	cell_explosion(loc, 40, 18, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
	qdel(src)

/obj/item/clothing/head/helmet/marine/reporter
	name = "记者头盔"
	desc = "一顶明确表明佩戴者注重安全、无意交战的头盔。"
	icon_state = "cc_helmet"
	item_state = "cc_helmet"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/cbrn_hood
	name = "M3 MOPP 面罩"
	desc = "M3 MOPP面罩配有全包覆头罩，可牢固连接到MOPP防护服上。面罩能够过滤空气中的有害颗粒，使穿戴者在野外安全呼吸。根据污染区域的恶劣程度，滤芯平均可使用十二小时或更短。"
	icon_state = "cbrn_hood"
	item_state = "cbrn_hood"
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROT
	flags_cold_protection = BODY_FLAG_HEAD
	flags_heat_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGHPLUS
	force = 0 //"The M3 MOPP mask would be a normal weapon if you were to hit someone with it."
	throwforce = 0
	flags_inventory = BLOCKSHARPOBJ|BLOCKGASEFFECT
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_inv_hide = HIDEEARS|HIDEALLHAIR
	built_in_visors = list()

/obj/item/clothing/head/helmet/marine/cbrn_hood/advanced
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_ULTRAHIGH
	armor_bio = CLOTHING_ARMOR_GIGAHIGHPLUS
	armor_rad = CLOTHING_ARMOR_GIGAHIGHPLUS

//=ROYAL MARINES=\\

/obj/item/clothing/head/helmet/marine/veteran/royal_marine
	name = "L5A2 防弹头盔"
	desc = "一顶高切防弹头盔，由林登塔尔-埃伦费尔德军工设计，供皇家陆战突击队作为红隼护甲系统的一部分使用。"
	icon_state = "rmc_helm1"
	item_state = "rmc_helm1"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_LOW
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = NO_FLAGS
	flags_marine_helmet = NO_FLAGS
	flags_atom = NO_NAME_OVERRIDE|NO_SNOW_TYPE

/obj/item/clothing/head/helmet/marine/veteran/royal_marine/breacher
	name = "L5A3 防弹头盔"
	desc = "一顶带有下颌护具的高切防弹头盔，由林登塔尔-埃伦费尔德军工设计，供皇家陆战突击队作为红隼护甲系统的一部分使用。"
	icon_state = "rmc_helm_br"
	item_state = "rmc_helm_br"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_LOW

//=USASF & ARMY=\\

/obj/item/clothing/head/helmet/marine/tech/tanker/para
	name = "MK25 伞降救援头盔"
	desc = "一顶经过大幅改装的USCM坦克乘员头盔，因其紧凑的设计和足够的防护，被美国航空航天军伞降救援部队采用。侧面摄像机与生物测量发射器可接入传感器矩阵。"
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/army)
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/rto/navy
	name = "M12 式舰外行动头盔"
	desc = "虽然USCMC最终没有采用这款头盔，美国航空航天军却乐于用它替换老旧的M09库存，配发给需要执行舰外任务的人员。"
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/army)
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/head/helmet/marine/rto/army
	name = "个人头部护甲系统头盔"
	desc = "虽然USCMC没有采购M12系列头盔，美国陆军却通过作为PBAS配套项目的PHAS计划，在短时间内将其大量配发部队。"
	icon_state = "army_helmet"
	item_state = "army_helmet"
	built_in_visors = list(new /obj/item/device/helmet_visor/medical/army)
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCKSHARPOBJ
	clothing_traits = list(TRAIT_EAR_PROTECTION) //So I don't have to make another subtype for the rocketeers

/obj/item/clothing/head/helmet/construction
	name = "作业头盔"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "rmc_helm2"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	item_state = "rmc_helm2"
	desc = "三世界帝国各类蓝领职业常用的头盔。"
