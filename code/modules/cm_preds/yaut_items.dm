//Items specific to yautja. Other people can use em, they're not restricted or anything.
//They can't, however, activate any of the special functions.
//Thrall subtypes are located in /code/modules/cm_preds/thrall_items.dm

/proc/add_to_missing_pred_gear(obj/item/W)
	if(!should_block_game_interaction(W))
		GLOB.loose_yautja_gear |= W

/proc/remove_from_missing_pred_gear(obj/item/W)
	GLOB.loose_yautja_gear -= W

//=================//\\=================\\
//======================================\\

/*
				EQUIPMENT
*/

//======================================\\
//=================\\//=================\\

/obj/item/clothing/suit/armor/yautja
	name = "远古异族护甲"
	desc = "以奇异合金打造的古老护甲。触感冰冷，重量也与人类护甲截然不同。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "halfarmor1_ebony"
	item_state = "armor"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_item = ITEM_PREDATOR
	flags_inventory = NO_FLAGS
	slowdown = SLOWDOWN_ARMOR_NONE
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	siemens_coefficient = 0.1
	allowed = list(
		/obj/item/weapon/harpoon,
		/obj/item/weapon/gun/launcher/spike,
		/obj/item/weapon/gun/energy/yautja,
		/obj/item/weapon/yautja,
		/obj/item/weapon/twohanded/yautja,
	)
	unacidable = TRUE
	item_state_slots = list(WEAR_JACKET = "halfarmor1")
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	var/thrall = FALSE//Used to affect icon generation.
	fire_intensity_resistance = 10
	black_market_value = 100

/obj/item/clothing/suit/armor/yautja/Initialize(mapload, armor_number = rand(1,7), armor_material = "ebony", legacy = "None")
	. = ..()
	if(thrall)
		return
	flags_cold_protection = flags_armor_protection
	flags_heat_protection = flags_armor_protection

	if(legacy != "None")
		switch(legacy)
			if("dragon")
				icon_state = "halfarmor_elder_tr"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_tr")
				return
			if("swamp")
				icon_state = "halfarmor_elder_joshuu"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_joshuu")
				return
			if("enforcer")
				icon_state = "halfarmor_elder_feweh"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_feweh")
				return
			if("collector")
				icon_state = "halfarmor_elder_n"
				LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor_elder_n")
				return

	if(armor_number > 7)
		armor_number = 1
	if(armor_number) //Don't change full armor number
		icon_state = "halfarmor[armor_number]_[armor_material]"
		LAZYSET(item_state_slots, WEAR_JACKET, "halfarmor[armor_number]_[armor_material]")



/obj/item/clothing/suit/armor/yautja/hunter
	name = "氏族护甲"
	desc = "带有轻型衬垫的护甲。虽然陈旧，却仍然堪用。"

	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH


/obj/item/clothing/suit/armor/yautja/hunter/full
	name = "重型氏族护甲"
	desc = "带有厚重衬垫的护甲。虽然陈旧，却仍然堪用。"
	icon_state = "fullarmor_ebony"
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HEAD|BODY_FLAG_LEGS
	flags_item = ITEM_PREDATOR
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_HIGH
	armor_rad = CLOTHING_ARMOR_HIGH
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	slowdown = 1
	var/speed_timer = 0
	item_state_slots = list(WEAR_JACKET = "fullarmor")
	allowed = list(
		/obj/item/weapon/harpoon,
		/obj/item/weapon/gun/launcher/spike,
		/obj/item/weapon/gun/energy/yautja,
		/obj/item/weapon/yautja,
		/obj/item/storage/backpack/yautja,
		/obj/item/weapon/twohanded/yautja,
	)
	fire_intensity_resistance = 20

/obj/item/clothing/suit/armor/yautja/hunter/full/Initialize(mapload, armor_number, armor_material = "ebony")
	. = ..(mapload, 0)
	icon_state = "fullarmor_[armor_material]"
	LAZYSET(item_state_slots, WEAR_JACKET, "fullarmor_[armor_material]")


/obj/item/clothing/yautja_cape
	name = PRED_YAUTJA_CAPE
	desc = "由铁血长老代代相传、饱经战火的披风。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "fullcape"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	flags_equip_slot = SLOT_BACK
	flags_item = ITEM_PREDATOR
	unacidable = TRUE
	var/clan_rank_required = CLAN_RANK_ELDER_INT
	var/councillor_override = FALSE

/obj/item/clothing/yautja_cape/Initialize(mapload, new_color = "#654321")
	. = ..()
	color = new_color

/obj/item/clothing/yautja_cape/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/clothing/yautja_cape/pickup(mob/living/user)
	if(isyautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/yautja_cape/Destroy()
	. = ..()
	remove_from_missing_pred_gear(src) // after due to item handling calling dropped()

/obj/item/clothing/yautja_cape/ceremonial
	name = PRED_YAUTJA_CEREMONIAL_CAPE
	icon_state = "ceremonialcape"
	clan_rank_required = CLAN_RANK_ELDER_INT

/obj/item/clothing/yautja_cape/third
	name = PRED_YAUTJA_THIRD_CAPE
	icon_state = "thirdcape"
	clan_rank_required = CLAN_RANK_ELDER_INT

/obj/item/clothing/yautja_cape/half
	name = PRED_YAUTJA_HALF_CAPE
	icon_state = "halfcape"
	clan_rank_required = CLAN_RANK_BLOODED_INT

/obj/item/clothing/yautja_cape/quarter
	name = PRED_YAUTJA_QUARTER_CAPE
	icon_state = "quartercape"
	clan_rank_required = CLAN_RANK_BLOODED_INT

/obj/item/clothing/yautja_cape/poncho
	name = PRED_YAUTJA_PONCHO
	icon_state = "councilor_poncho"
	clan_rank_required = CLAN_RANK_BLOODED_INT

/obj/item/clothing/shoes/yautja
	name = "远古异族护胫"
	desc = "以布条和奇异合金制成的护胫。触感冰冷，重量也与人类装备截然不同。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "y-boots1_ebony"

	unacidable = TRUE
	permeability_coefficient = 0.01
	flags_inventory = NOSLIPPING
	flags_armor_protection = BODY_FLAG_FEET|BODY_FLAG_LEGS
	flags_item = ITEM_PREDATOR

	siemens_coefficient = 0.2
	min_cold_protection_temperature = SHOE_MIN_COLD_PROT
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROT
	allowed_items_typecache = list(
		/obj/item/weapon/yautja/knife,
		/obj/item/weapon/gun/energy/yautja/plasmapistol,
	)


	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	var/thrall = FALSE//Used to affect icon generation.
	fire_intensity_resistance = 10
	black_market_value = 50

/obj/item/clothing/shoes/yautja/New(location, boot_number = rand(1,4), armor_material = "ebony")
	..()
	if(thrall)
		return
	if(boot_number > 4)
		boot_number = 1
	icon_state = "y-boots[boot_number]_[armor_material]"

	flags_cold_protection = flags_armor_protection
	flags_heat_protection = flags_armor_protection

/obj/item/clothing/shoes/yautja/hunter
	name = "氏族护胫"
	desc = "一双配重均衡的装甲靴，非常适合在丛林中奔跑。"

	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/clothing/shoes/yautja/hunter/knife
	spawn_item_type = /obj/item/weapon/yautja/knife

/obj/item/clothing/under/chainshirt
	name = "远古异族网甲"
	desc = "用奇异合金编织而成的背心。触感冰冷，重量也与人类装备截然不同。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "mesh_shirt"
	item_icons = list(
		WEAR_BODY = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS //Does not cover the head though.
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_LEGS|BODY_FLAG_ARMS|BODY_FLAG_FEET|BODY_FLAG_HANDS
	flags_item = ITEM_PREDATOR
	has_sensor = UNIFORM_HAS_SENSORS
	sensor_faction = FACTION_YAUTJA
	siemens_coefficient = 0.9
	min_cold_protection_temperature = ICE_PLANET_MIN_COLD_PROT

	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

/obj/item/clothing/under/chainshirt/hunter
	name = "贴身网甲"
	desc = "以极细的链环编成，兼顾舒适与实用的网甲。"

	armor_melee = CLOTHING_ARMOR_LOW
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	black_market_value = 50

//=================//\\=================\\
//======================================\\

/*
				   GEAR
*/

//======================================\\
//=================\\//=================\\

//Yautja channel. Has to delete stock encryption key so we don't receive sulaco channel.
/obj/item/device/radio/headset/yautja
	name = "\improper 通信器"
	desc = "一种奇特的铁血装置，用于向同一猎群的成员传话，功能类似于人类的普通无线电。"
	icon_state = "communicator"
	item_state = "headset"
	frequency = YAUT_FREQ
	unacidable = TRUE
	ignore_z = TRUE
	black_market_value = 100
	flags_item = ITEM_PREDATOR

/obj/item/device/radio/headset/yautja/talk_into(mob/living/M as mob, message, channel, verb = "commands", datum/language/speaking)
	if(!isyautja(M)) //Nope.
		to_chat(M, SPAN_WARNING("你试着对耳机说话，耳中却只传来刺耳的尖啸！"))
		return

	for(var/mob/living/carbon/xenomorph/hellhound/hellhound as anything in GLOB.hellhound_list)
		if(!hellhound.stat)
			to_chat(hellhound, "\[无线电\]：[M.real_name] [localized_player_label(verb)]，“<B>[message]</b>”。")
	..()

/obj/item/device/radio/headset/yautja/elder //primarily for use in another MR
	name = "\improper 长老通信器"
	volume_settings = list(RADIO_VOLUME_QUIET_STR, RADIO_VOLUME_RAISED_STR, RADIO_VOLUME_IMPORTANT_STR, RADIO_VOLUME_CRITICAL_STR)

/obj/item/device/encryptionkey/yautja
	name = "\improper 铁血加密密钥"
	desc = "一种复杂的加密装置。"
	icon_state = "cypherkey"
	channels = list(RADIO_CHANNEL_YAUTJA = 1)

//Yes, it's a backpack that goes on the belt. I want the backpack noises. Deal with it (tm)
/obj/item/storage/backpack/yautja
	name = "狩猎腰包"
	desc = "用厚实鞣皮制成的铁血狩猎腰包。可容纳各种装置和工具，也可用于携带战利品。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "beltbag"
	item_state = "beltbag_w"
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	flags_equip_slot = SLOT_WAIST
	max_w_class = SIZE_MEDIUM
	flags_item = ITEM_PREDATOR
	storage_slots = 12
	max_storage_space = 30
	black_market_value = 50


/obj/item/device/yautja_teleporter
	name = "中继信标"
	desc = "表面刻满神圣文字的装置，每隔几秒就会发出嗡鸣和哔声。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "teleporter"

	flags_item = ITEM_PREDATOR
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	force = 1
	throwforce = 1
	unacidable = TRUE
	black_market_value = 100
	var/timer = 0

/obj/item/device/yautja_teleporter/attack_self(mob/user)
	set waitfor = FALSE

	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/ship_to_tele = list("Yautja Ship" = -1, "Human Ship" = "Human")

	if(!HAS_TRAIT(H, TRAIT_YAUTJA_TECH) || should_block_game_interaction(H))
		to_chat(user, SPAN_WARNING("你摆弄了一下，但什么也没发生！"))
		return

	if(H.client && H.client.clan_info)
		var/datum/entity/clan_player/clan_info = H.client.clan_info
		if(clan_info.permissions & CLAN_PERMISSION_ADMIN_VIEW)
			var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)
			for(var/datum/view_record/clan_view/CV in CPV)
				if(!SSpredships.is_clanship_loaded(CV?.clan_id))
					continue
				ship_to_tele += list("[CV.name]" = "[CV.clan_id]: [CV.name]")
		if(SSpredships.is_clanship_loaded(clan_info?.clan_id))
			ship_to_tele += list("Your clan" = "[clan_info.clan_id]")

	var/clan = ship_to_tele[localized_input_list(H, "选择要传送前往的舰船。", "[src]", ship_to_tele)]
	if(clan != "Human" && !SSpredships.is_clanship_loaded(clan))
		return // Checking ship is valid

	// Getting an arrival point
	var/turf/target_turf
	if(clan == "Human")
		var/obj/effect/landmark/yautja_teleport/pickedYT = pick(GLOB.mainship_yautja_teleports)
		target_turf = get_turf(pickedYT)
	else
		target_turf = SAFEPICK(SSpredships.get_clan_spawnpoints(clan))
	if(!istype(target_turf))
		return

	// Let's go
	playsound(src,'sound/ambience/signal.ogg', 25, 1, sound_range = 6)
	timer = 1
	user.visible_message(SPAN_INFO("[user]的身影开始闪烁，变得模糊不清……"))

	if(do_after(user, 10 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		// Display fancy animation for you and the person you might be pulling (Legacy)
		SEND_SIGNAL(user, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
		user.visible_message(SPAN_WARNING("[icon2html(user, viewers(src))][user]消失了！"))
		var/tele_time = animation_teleport_quick_out(user)
		var/mob/living/M = user.pulling
		if(istype(M)) // Pulled person
			SEND_SIGNAL(M, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
			M.visible_message(SPAN_WARNING("[icon2html(M, viewers(src))][M]消失了！"))
			animation_teleport_quick_out(M)

		sleep(tele_time) // Animation delay
		user.trainteleport(target_turf) // Actually teleports everyone, not just you + pulled

		// Undo animations
		animation_teleport_quick_in(user)
		if(istype(M) && !QDELETED(M))
			animation_teleport_quick_in(M)
		timer = 0
	else
		addtimer(VARSET_CALLBACK(src, timer, FALSE), 1 SECONDS)

/obj/item/device/yautja_teleporter/verb/add_tele_loc()
	set name = "Add Teleporter Destination"
	set desc = "将当前位置添加为传送目的地。"
	set category = "Yautja.Utility"
	set src in usr
	if(!usr || usr.stat || !is_ground_level(usr.z))
		return FALSE

	if(istype(usr.buckled, /obj/structure/bed/nest/))
		return FALSE

	if(!HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("你完全不知道这东西怎么用！"))
		return FALSE

	if(loc && istype(usr.loc, /turf))
		var/turf/location = usr.loc
		GLOB.yautja_teleports += location
		var/name = input("你想给这个地点起什么名字？", "文字") as null|text
		if(!name)
			return FALSE
		GLOB.yautja_teleport_descs[name + location.loc_to_string()] = location
		to_chat(usr, SPAN_WARNING("你现在可以传送到这个位置了！"))
		log_game("[usr] ([usr.key]) has created a new teleport location at [get_area(usr)]")
		message_all_yautja("[usr.real_name]已在[get_area(usr)]的[usr.loc]创建传送地点：[name]")
		return TRUE

//=================//\\=================\\
//======================================\\

/*
			   OTHER THINGS
*/

//======================================\\
//=================\\//=================\\

/obj/item/scalp
	name = "头皮"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	w_class = SIZE_TINY
	icon_state = "scalp_1"
	item_state = "scalp"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	var/true_desc = "这块头皮来自" //humans and Yautja see different things when examining these.
	appearance_flags = NO_FLAGS //So that the blood overlay renders separately and isn't affected by the hair color matrix.

/obj/item/scalp/Initialize(mapload, mob/living/carbon/human/scalpee, mob/living/carbon/human/user)
	. = ..()

	var/variant = rand(1, 4) //Random sprite variant.
	icon_state = "scalp_[variant]"
	blood_color =  BLOOD_COLOR_HUMAN //So examine describes it as 'bloody'. Synths can't be scalped so it'll always be human blood.
	flags_atom = FPRINT|NOBLOODY //Don't want the ugly item blood overlay ending up on this. We'll use our own blood overlay.

	var/image/blood_overlay = image('icons/obj/items/hunter/pred_gear.dmi', "scalp_[variant]_blood")
	blood_overlay.appearance_flags = RESET_COLOR
	overlays += blood_overlay

	if(!scalpee) //Presumably spawned as map decoration.
		true_desc = "这块头皮来自一个无足轻重的人类。"
		color = list(null, null, null, null, rgb(rand(0,255), rand(0,255), rand(0,255)))
		return

	name = "\proper [scalpee.real_name]的头皮"
	color = list(null, null, null, null, rgb(scalpee.r_hair, scalpee.g_hair, scalpee.b_hair)) //Hair color.

	var/they = "其"
	var/their = "其"
	var/them = "其"
	var/themselves = "自己"

	//Gender?
	switch(scalpee.gender)
		if(MALE)
			their = "他的"
			they = "他"
			them = "他"
			themselves = "他自己"

		if(FEMALE)
			their = "她的"
			they = "她"
			them = "她"
			themselves = "她自己"

	//What did this person do?
	var/list/biography = list()
	//Did they disgrace themselves more than humans usually do?
	var/dishonourable = FALSE
	//Did they distinguish themselves?
	var/honourable = FALSE

	if(scalpee.hunter_data.thralled)
		biography += "因‘[scalpee.hunter_data.thralled_reason]’而被[scalpee.hunter_data.thralled_set.real_name]收为仆从"
		honourable = TRUE

	if(scalpee.hunter_data.honored)
		biography += "因‘[scalpee.hunter_data.honored_reason]’而获授荣誉"
		honourable = TRUE

	if(scalpee.hunter_data.dishonored)
		biography +=  "因‘[scalpee.hunter_data.dishonored_reason]’而被标记为不名誉猎物"
		dishonourable = TRUE

	if(scalpee.hunter_data.gear)
		biography +=  "因被[scalpee.hunter_data.gear_set.real_name]认定[them]盗窃铁血装备而遭到猎杀"
		dishonourable = TRUE

	//How impressive a trophy is this?
	var/worth = 1
	switch(scalpee.life_kills_total)
		if(0)
			if(dishonourable)
				true_desc += "一个比寻常人类还要可耻的家伙。"
				worth = -1
			else if(honourable) //They weren't marked as killing anyone but otherwise distinguished themselves.
				true_desc += "一名人类。"
			else
				true_desc += "一个无足轻重的人类。"
				worth = 0

		if(1 to 4)
			if(dishonourable)
				true_desc += "一名原本配得上狩猎的人类，可惜[they]执意让[themselves]蒙羞。"
				worth = -1
			else
				true_desc += "一名双手染血、值得尊重的人类。"

		if(5 to 9)
			true_desc += "一名破坏力异乎寻常的人类。"
			if(!dishonourable)
				worth = 2 //Even if they did do something dishonourable, this person is worth at least grudging respect.

		if(10 to INFINITY)
			true_desc += "一名真正值得狩猎的人类，无疑是历代传奇战士的后裔。[their]双臂曾浸透无数敌人的鲜血。"
			worth = 2

	if(length(biography))
		true_desc += "[scalpee.real_name]曾[jointext(biography, "；")]。"

	if(scalpee.hunter_data.hunter == user) //You don't get your name on it unless you hunted them yourself.
		switch(worth)
			if(-1)
				true_desc += SPAN_BLUE("\n[user.real_name]不得不执行追捕这头猎物的苦差事。")
			if(0) //You hunted someone with no kills for no real reason.
				true_desc += SPAN_BLUE("\n这是一名早慧孩童值得骄傲的首件战利品。[user.real_name]的父母一定很自豪。")
			if(1)
				true_desc += SPAN_BLUE("\n这件战利品是[user.real_name]在一次成功的狩猎后取得的。")
			if(2)
				true_desc += SPAN_BLUE("\n这件精美的战利品是[user.real_name]在一次成功的狩猎后取得的。")

/obj/item/scalp/get_examine_text(mob/user)
	. = ..()
	if(isyautja(user) || isobserver(user))
		. += true_desc
	else
		. += SPAN_WARNING("收集头皮本该只是个<i>玩笑</i>。难道真有人到处干这种破事？接下来是什么，拿割下的耳朵串项链？天啊。")

/obj/item/explosive/grenade/spawnergrenade/hellhound
	name = "地狱猎犬召唤器"
	spawner_type = /mob/living/carbon/xenomorph/hellhound
	deliveryamt = 1
	desc = "一件奇特的异族科技造物，似乎能够召来地狱猎犬。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "hellnade"
	w_class = SIZE_TINY
	det_time = 30
	var/obj/structure/machinery/camera/current = null
	var/turf/activated_turf = null

/obj/item/explosive/grenade/spawnergrenade/hellhound/dropped(mob/user)
	check_eye(user)
	return ..()

/obj/item/explosive/grenade/spawnergrenade/hellhound/attack_self(mob/living/carbon/human/user)
	..()
	if(!active)
		if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
			to_chat(user, SPAN_WARNING("这是什么东西？"))
			return
		to_chat(user, SPAN_WARNING("你启动了地狱猎犬信标！"))
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.toggle_throw_mode(THROW_MODE_NORMAL)

/obj/item/explosive/grenade/spawnergrenade/hellhound/activate(mob/user)
	if(active)
		return

	if(user)
		msg_admin_attack("[key_name(user)] primed \a [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
	icon_state = initial(icon_state) + "_active"
	active = 1
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(prime)), det_time)

/obj/item/explosive/grenade/spawnergrenade/hellhound/prime()
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		if(ispath(spawner_type))
			new spawner_type(T)
	return

/obj/item/explosive/grenade/spawnergrenade/hellhound/check_eye(mob/user)
	if (user.is_mob_incapacitated() || user.blinded )
		user.unset_interaction()
	else if ( !current || get_turf(user) != activated_turf || src.loc != user ) //camera doesn't work, or we moved.
		user.unset_interaction()

/obj/item/explosive/grenade/spawnergrenade/hellhound/New()
	. = ..()

	force = 20
	throwforce = 40

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_set_interaction(mob/user)
	..()
	user.reset_view(current)

/obj/item/explosive/grenade/spawnergrenade/hellhound/on_unset_interaction(mob/user)
	..()
	current = null
	user.reset_view(null)


// Hunting traps
/obj/item/hunting_trap
	name = "狩猎陷阱"
	throw_speed = SPEED_FAST
	throw_range = 2
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "yauttrap0"
	desc = "一种用于捕捉并杀死猎物的奇特铁血装置。"
	black_market_value = 50
	var/armed = 0
	var/datum/effects/tethering/tether_effect
	var/tether_range = 5
	var/mob/trapped_mob
	layer = LOWER_ITEM_LAYER
	flags_item = ITEM_PREDATOR

/obj/item/hunting_trap/Destroy()
	cleanup_tether()
	trapped_mob = null
	. = ..()

/obj/item/hunting_trap/dropped(mob/living/carbon/human/mob) //Changes to "camouflaged" icons based on where it was dropped.
	if(armed && isturf(mob.loc))
		var/turf/T = mob.loc
		if(istype(T,/turf/open/gm/dirt))
			icon_state = "yauttrapdirt"
		else if (istype(T,/turf/open/gm/grass))
			icon_state = "yauttrapgrass"
		else
			icon_state = "yauttrap1"
	..()

/obj/item/hunting_trap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.is_mob_restrained())
		var/wait_time = 3 SECONDS
		if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
			wait_time = rand(5 SECONDS, 10 SECONDS)
		if(!do_after(user, wait_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			return
		armed = TRUE
		anchored = TRUE
		icon_state = "yauttrap[armed]"
		to_chat(user, SPAN_NOTICE("[src]现已设为待发状态。"))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has armed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has armed \a [src] at [get_location_in_text(user)].")
		user.drop_held_item()

/obj/item/hunting_trap/attack_hand(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		disarm(user)
	//Humans and synths don't know how to handle those traps!
	if(ishumansynth_strict(user) && armed)
		to_chat(user, SPAN_WARNING("你愚蠢地伸手触碰[src]……"))
		trapMob(user)
		return
	. = ..()

/obj/item/hunting_trap/proc/trapMob(mob/living/carbon/C)
	if(!armed)
		return

	armed = FALSE
	anchored = TRUE

	var/list/tether_effects = apply_tether(src, C, range = tether_range, resistable = TRUE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, PROC_REF(disarm))

	trapped_mob = C

	icon_state = "yauttrap0"
	playsound(C,'sound/weapons/tablehit1.ogg', 25, 1)
	to_chat(C, "[icon2html(src, C)] \red <B>你被[src]夹住了！</B>")

	C.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(C)] was caught in \a [src] at [get_location_in_text(C)].</font>")
	log_attack("[key_name(C)] was caught in \a [src] at [get_location_in_text(C)].")

	if(ishuman(C))
		C.emote("pain")
	if(isxeno(C))
		var/mob/living/carbon/xenomorph/xeno = C
		C.emote("needhelp")
		xeno.AddComponent(/datum/component/status_effect/interference, 100) // Some base interference to give pred time to get some damage in, if it cannot land a single hit during this time pred is cheeks
		RegisterSignal(xeno, COMSIG_XENO_PRE_HEAL, PROC_REF(block_heal))
	message_all_yautja("位于[get_area_name(loc)]的狩猎陷阱捕获了猎物！")

/obj/item/hunting_trap/proc/block_heal(mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_XENO_HEAL

/obj/item/hunting_trap/Crossed(atom/movable/AM)
	if(armed && ismob(AM))
		var/mob/M = AM
		if(!M.buckled)
			if(iscarbon(AM) && isturf(src.loc))
				var/mob/living/carbon/H = AM
				if(isyautja(H))
					to_chat(H, SPAN_NOTICE("你小心地避开了陷阱。"))
					return
				trapMob(H)
				for(var/mob/O in viewers(H, null))
					if(O == H)
						continue
					O.show_message(SPAN_WARNING("[icon2html(src, O)] <B>[H]被[src]夹住了。</B>"), SHOW_MESSAGE_VISIBLE)
			else if(isanimal(AM) && !istype(AM, /mob/living/simple_animal/parrot))
				armed = FALSE
				var/mob/living/simple_animal/SA = AM
				SA.health -= 20
	..()

/obj/item/hunting_trap/proc/cleanup_tether()
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		qdel(tether_effect)
		tether_effect = null

/obj/item/hunting_trap/proc/disarm(mob/user)
	SIGNAL_HANDLER
	armed = FALSE
	anchored = FALSE
	icon_state = "yauttrap[armed]"
	if (user)
		to_chat(user, SPAN_NOTICE("[src]已解除待发状态。"))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has disarmed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has disarmed \a [src] at [get_location_in_text(user)].")
	if (trapped_mob)
		if (isxeno(trapped_mob))
			var/mob/living/carbon/xenomorph/X = trapped_mob
			UnregisterSignal(X, COMSIG_XENO_PRE_HEAL)
		trapped_mob = null
	cleanup_tether()

/obj/item/hunting_trap/verb/configure_trap()
	set name = "Configure Hunting Trap"
	set category = "Object"

	var/mob/living/carbon/human/H = usr
	if(!HAS_TRAIT(H, TRAIT_YAUTJA_TECH))
		to_chat(H, SPAN_WARNING("你不知道如何配置这个陷阱。"))
		return
	var/range = tgui_input_list(H, "你想将狩猎陷阱的作用范围设为多少？", "狩猎陷阱范围", list(2, 3, 4, 5, 6, 7))
	if(isnull(range))
		return
	tether_range = range
	to_chat(H, SPAN_NOTICE("你将狩猎陷阱的牵绳范围设为了[range]。"))

//flavor armor & greaves, not a subtype
/obj/item/clothing/suit/armor/yautja_flavor
	name = "异族石甲"
	desc = "完全由石头制成的护甲，看起来极其沉重。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	item_state = "armor"
	icon_state = "fullarmor_ebony"

	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_HEAD|BODY_FLAG_LEGS
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_VERY_HEAVY
	siemens_coefficient = 0.1
	allowed = list(
		/obj/item/weapon/harpoon,
		/obj/item/weapon/gun/launcher/spike,
		/obj/item/weapon/gun/energy/yautja,
		/obj/item/weapon/yautja,
		/obj/item/weapon/twohanded/yautja,
	)
	unacidable = TRUE
	item_state_slots = list(WEAR_JACKET = "fullarmor_ebony")

/obj/item/clothing/shoes/yautja_flavor
	name = "异族石制护胫"
	desc = "一双配重均衡的装甲靴。沉重到足以踏穿水泥地面。"

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	icon_state = "y-boots2_ebony"

	unacidable = TRUE
	flags_armor_protection = BODY_FLAG_FEET|BODY_FLAG_LEGS|BODY_FLAG_GROIN
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

/obj/item/card/id/bracer_chip
	name = "护腕身份芯片"
	desc = "嵌在氏族护腕中的复杂加密芯片。"
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "upp_key"
	access = list(ACCESS_YAUTJA_SECURE)
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_ID
	flags_item = ITEM_PREDATOR|DELONDROP|NODROP
	paygrade = null

/obj/item/card/id/bracer_chip/set_user_data(mob/living/carbon/human/human_user)
	if(!istype(human_user))
		return

	registered_name = human_user.real_name
	registered_ref = WEAKREF(human_user)
	registered_gid = human_user.gid
	blood_type = human_user.blood_type

	var/list/new_access = list(ACCESS_YAUTJA_SECURE)
	var/obj/item/clothing/gloves/yautja/hunter/bracer = loc
	if(istype(bracer) && bracer.owner_rank)
		switch(bracer.owner_rank)
			if(CLAN_RANK_ELDER_INT, CLAN_RANK_LEADER_INT)
				new_access = list(ACCESS_YAUTJA_SECURE, ACCESS_YAUTJA_ELDER)
			if(CLAN_RANK_ADMIN_INT)
				new_access = list(ACCESS_YAUTJA_SECURE, ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT)
	access = new_access

/obj/item/storage/medicomp
	name = "医疗终端"
	desc = "一套复杂的异族医疗工具与药品。"
	icon_state = "medicomp"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	use_sound = "toolbox"
	w_class = SIZE_SMALL
	storage_flags = STORAGE_FLAGS_DEFAULT
	flags_item = ITEM_PREDATOR
	storage_slots = 12
	can_hold = list(
		/obj/item/tool/surgery/stabilizer_gel,
		/obj/item/tool/surgery/healing_gun,
		/obj/item/tool/surgery/wound_clamp,
		/obj/item/reagent_container/hypospray/autoinjector/yautja,
		/obj/item/device/healthanalyzer/alien,
		/obj/item/tool/surgery/healing_gel,
	)
	black_market_value = 10

/obj/item/storage/medicomp/full/fill_preset_inventory()
	new /obj/item/tool/surgery/stabilizer_gel(src)
	new /obj/item/tool/surgery/healing_gun(src)
	new /obj/item/tool/surgery/wound_clamp(src)
	new /obj/item/device/healthanalyzer/alien(src)
	new /obj/item/reagent_container/hypospray/autoinjector/yautja(src)
	new /obj/item/reagent_container/hypospray/autoinjector/yautja(src)
	new /obj/item/reagent_container/hypospray/autoinjector/yautja(src)
	new /obj/item/tool/surgery/healing_gel/(src)
	new /obj/item/tool/surgery/healing_gel/(src)
	new /obj/item/tool/surgery/healing_gel/(src)

/obj/item/storage/medicomp/update_icon()
	if(!length(contents))
		icon_state = "medicomp_open"
	else
		icon_state = "medicomp"

/obj/item/reagent_container/glass/rag/polishing_rag
	name = "抛光布"
	desc = "一块以异域布料手工裁成、精细得令人惊叹的布。"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "polishing_rag"
	reagent_desc_override = TRUE //Hide the fact its actually a reagent container

/obj/item/reagent_container/glass/rag/polishing_rag/get_examine_text(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		. += SPAN_NOTICE("你可以用它来抛光骨头。")

/obj/item/reagent_container/glass/rag/polishing_rag/afterattack(obj/potential_limb, mob/user, proximity_flag, click_parameters)

	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		return ..()

	if(!istype(potential_limb, /obj/item/clothing/accessory/limb/skeleton))
		return ..()

	var/obj/item/clothing/accessory/limb/skeleton/current_limb = potential_limb
	if(current_limb.polished)
		to_chat(user, SPAN_NOTICE("这根骨头已经抛光过了。"))
		return ..()

	to_chat(user, SPAN_WARNING("你开始用[name]擦拭[current_limb]。"))
	if(!do_after(user, 5 SECONDS, INTERRUPT_MOVED, BUSY_ICON_HOSTILE, current_limb))
		to_chat(user, SPAN_NOTICE("你停止抛光[current_limb]。"))
		return
	to_chat(user, SPAN_NOTICE("你将[current_limb]抛光得完美无瑕。"))
	current_limb.polished = TRUE
	current_limb.name = "抛光的[current_limb.name]"

//Skeleton limbs, meant to be for bones
//Only an onmob for the skull
/obj/item/clothing/accessory/limb/skeleton
	name = "你是怎么弄到这个的？"
	desc = "一块人类骨头。"
	icon = 'icons/obj/items/skeleton.dmi'
	accessory_icons = list(WEAR_BODY = 'icons/mob/humans/onmob/hunter/pred_gear.dmi')
	icon_state = null
	///Has it been cleaned by a polishing rag?
	var/polished = FALSE
/obj/item/clothing/accessory/limb/skeleton/l_arm
	name = "臂骨"
	icon_state = "l_arm"

/obj/item/clothing/accessory/limb/skeleton/l_foot
	name = "足骨"
	icon_state = "l_foot"

/obj/item/clothing/accessory/limb/skeleton/l_hand
	name = "手骨"
	icon_state = "l_hand"

/obj/item/clothing/accessory/limb/skeleton/l_leg
	name = "腿骨"
	icon_state = "l_leg"

/obj/item/clothing/accessory/limb/skeleton/r_arm
	name = "臂骨"
	icon_state = "r_arm"

/obj/item/clothing/accessory/limb/skeleton/r_foot
	name = "足骨"
	icon_state = "r_foot"

/obj/item/clothing/accessory/limb/skeleton/r_hand
	name = "手骨"
	icon_state = "r_hand"

/obj/item/clothing/accessory/limb/skeleton/r_leg
	name = "腿骨"
	icon_state = "r_leg"

/obj/item/clothing/accessory/limb/skeleton/head
	name = "颅骨"
	icon_state = "skull"
	high_visibility = TRUE

/obj/item/clothing/accessory/limb/skeleton/head/spine
	icon_state = "spine"

/obj/item/clothing/accessory/limb/skeleton/torso
	name = "胸廓"
	icon_state = "torso"

/obj/item/clothing/accessory/limb/skeleton/get_examine_text(mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		if(polished)
			. += SPAN_NOTICE("抛光得完美无瑕。")
		else
			. += SPAN_NOTICE("[src]仍然很脏。")

/obj/item/clothing/accessory/limb/skeleton/can_attach_to(mob/user, obj/item/clothing/C)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH)) //Only Yautja can wear bones on their clothing
		to_chat(user, SPAN_NOTICE("你为什么要把它装在衣服上？"))
		return
	. = ..()
