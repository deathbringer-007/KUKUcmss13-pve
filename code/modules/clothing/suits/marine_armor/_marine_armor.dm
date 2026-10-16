#define DEBUG_ARMOR_PROTECTION 0

#if DEBUG_ARMOR_PROTECTION
/mob/living/carbon/human/verb/check_overall_protection()
	set name = "Get Armor Value"
	set category = "Debug"
	set desc = "Shows the armor value of the bullet category."

	var/armor = 0
	var/counter = 0
	for(var/X in H.limbs)
		var/obj/limb/E = X
		armor = getarmor_organ(E, ARMOR_BULLET)
		to_chat(src, SPAN_DEBUG("<b>[E.name]</b> is protected with <b>[armor]</b> armor against bullets."))
		counter += armor
	to_chat(src, SPAN_DEBUG("The overall armor score is: <b>[counter]</b>."))
#endif

//=======================================================================\\
//=======================================================================\\

#define ALPHA 1
#define BRAVO 2
#define CHARLIE 3
#define DELTA 4
#define ECHO 5
#define CRYO 6
#define SOF 7
#define NOSQUAD 8

// MARINE STORAGE ARMOR

/obj/item/clothing/suit/storage/marine
	name = "\improper M3 型陆战队护甲"
	desc = "USCMC 制式 M3 型个人护甲，采用复合防弹装甲，集成生命体征监测系统，并带有 IMP 系统和 TNR 肩灯安装座。\n两侧额外配有储物袋。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "1"
	item_state = "marine_armor" //Make unique states for Officer & Intel armors.
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	flags_atom = FPRINT|CONDUCT
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	storage_slots = 3
	siemens_coefficient = 0.7
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/prop/prop_gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/type47,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/gun/m39,
		/obj/item/storage/belt/gun/xm51,
	)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_PONCHO)

	light_power = 3
	light_range = 4
	light_color = LIGHT_COLOR_TUNGSTEN
	light_system = MOVABLE_LIGHT

	var/flashlight_cooldown = 0 //Cooldown for toggling the light
	var/locate_cooldown = 0 //Cooldown for SL locator
	var/armor_overlays[]
	actions_types = list(/datum/action/item_action/toggle)
	var/flags_marine_armor = ARMOR_SQUAD_OVERLAY|ARMOR_LAMP_OVERLAY
	var/specialty = "M3 型陆战队" //Same thing here. Give them a specialty so that they show up correctly in vendors. speciality does NOTHING if you have NO_NAME_OVERRIDE
	w_class = SIZE_HUGE
	uniform_restricted = null
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	time_to_unequip = 20
	time_to_equip = 20
	pickup_sound = "armorequip"
	drop_sound = "armorequip"
	equip_sounds = list('sound/handling/putting_on_armor1.ogg')
	has_light = TRUE
	var/armor_variation = 0
	/// The dmi where the grayscale squad overlays are contained
	var/squad_overlay_icon = 'icons/mob/humans/onmob/suit_1.dmi'

	var/atom/movable/marine_light/light_holder

/obj/item/clothing/suit/storage/marine/Initialize(mapload)
	. = ..()
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]护甲"

	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	armor_overlays = list("lamp") //Just one for now, can add more later.
	if(armor_variation && mapload)
		set_armor_style("Random")
	update_icon()
	pockets.max_w_class = SIZE_SMALL //Can contain small items AND rifle magazines.
	pockets.bypass_w_limit = list(
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/smg,
		/obj/item/ammo_magazine/sniper,
	)
	pockets.max_storage_space = 8

	light_holder = new(src)

/obj/item/clothing/suit/storage/marine/Destroy()
	QDEL_NULL(light_holder)
	return ..()

/obj/item/clothing/suit/storage/marine/update_icon(mob/user)
	var/image/I
	armor_overlays["lamp"] = null
	if(flags_marine_armor & ARMOR_LAMP_OVERLAY)
		if(flags_marine_armor & ARMOR_LAMP_ON)
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-on")
		else
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-off")
		armor_overlays["lamp"] = I
		overlays += I
	else armor_overlays["lamp"] = null
	if(user) user.update_inv_wear_suit()


/obj/item/clothing/suit/storage/marine/post_vendor_spawn_hook(mob/living/carbon/human/user) //used for randomizing/selecting a variant for armors.
	if(!armor_variation)
		return

	if(user?.client?.prefs)
		// Set the armor style to the user's preference.
		set_armor_style(user.client.prefs.preferred_armor)
	else
		// Or if that isn't possible, just pick a random one.
		set_armor_style("Random")
	update_icon(user)

/obj/item/clothing/suit/storage/marine/attack_self(mob/user)
	..()

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("你在[user.loc]内时无法[light_on ? "关闭" : "打开"]灯光。")) //To prevent some lighting anomalies.
		return

	if(flashlight_cooldown > world.time)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		return

	turn_light(user, !light_on)

/obj/item/clothing/suit/storage/marine/item_action_slot_check(mob/user, slot)
	if(!ishuman(user))
		return FALSE
	if(slot != WEAR_JACKET)
		return FALSE
	return TRUE //only give action button when armor is worn.

/obj/item/clothing/suit/storage/marine/turn_light(mob/user, toggle_on)
	. = ..()
	if(. != CHECKS_PASSED)
		return
	set_light_range(initial(light_range))
	set_light_power(floor(initial(light_power) * 0.5))
	set_light_on(toggle_on)
	flags_marine_armor ^= ARMOR_LAMP_ON

	light_holder.set_light_flags(LIGHT_ATTACHED)
	light_holder.set_light_range(initial(light_range))
	light_holder.set_light_power(initial(light_power))
	light_holder.set_light_on(toggle_on)

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/suit/storage/marine/mob_can_equip(mob/living/carbon/human/M, slot, disable_warning = 0)
	. = ..()
	if (.)
		if(issynth(M) && M.allow_gun_usage == FALSE && !(flags_marine_armor & SYNTH_ALLOWED))
			M.visible_message(SPAN_DANGER("你的程序不允许你穿戴这件装备！"))
			return 0

/**
 * Updates the armor's `icon_state` to the style represented by `new_style`.
 *
 * Arguments:
 * * new_style - The new armor style. May only be one of `GLOB.armor_style_list`'s keys, or `"Random"`.
 */
/obj/item/clothing/suit/storage/marine/proc/set_armor_style(new_style)
	// Regex to match one or more digits.
	var/static/regex/digits = new("\\d+")
	// Integer for the new armor style's `icon_state`.
	var/new_look

	if(new_style == "Random")
		// The style icon states are all numbers between 1 and `armor_variation`, so this picks a random one.
		new_look = rand(1, armor_variation)
	else
		new_look = GLOB.armor_style_list[new_style]

	// Replace the digits in the current icon state with `new_look`. (E.g. "L6" -> "L2")
	icon_state = digits.Replace(icon_state, new_look)

/obj/item/clothing/suit/storage/marine/medium/rto
	icon_state = "io"
	armor_variation = 0
	name = "\improper M4 型陆战队护甲"
	desc = "将智能机枪手网状护甲与 M3 型护甲板精心结合的改进护甲。坚固而灵活，能容纳你的各种携行袋。"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 4
	light_range = 5 //slightly higher
	specialty = "M4 型陆战队"

/obj/item/clothing/suit/storage/marine/MP
	name = "\improper M2 型宪兵护甲"
	desc = "殖民地陆战队制式 M2 型胸甲，可保护胸部免受枪弹、利器和意外伤害，附带一个小皮袋，提供有限的储物空间。"
	icon_state = "mp_armor"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine/,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/weapon/baton,
		/obj/item/restraint/handcuffs,
		/obj/item/explosive/grenade,
		/obj/item/device/binoculars,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/hailer,
		/obj/item/storage/belt/gun,
		/obj/item/weapon/sword/ceremonial,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)
	specialty = "M2 型宪兵"
	item_state_slots = list(WEAR_JACKET = "mp_armor")
	black_market_value = 20

/obj/item/clothing/suit/storage/marine/MP/warden
	name = "\improper M3 型典狱长宪兵护甲"
	desc = "做工精良的 M3 型护甲，通常配发给典狱长。有助于让手下认清谁说了算。"
	icon_state = "warden"
	specialty = "M3 型典狱长宪兵"
	item_state_slots = list(WEAR_JACKET = "warden")

/obj/item/clothing/suit/storage/marine/MP/WO
	name = "\improper M3 型宪兵长护甲"
	desc = "做工精良的 M3 型护甲，通常配发给宪兵长。有助于让手下认清谁说了算。"
	icon_state = "warrant_officer"
	specialty = "M3 型宪兵长"
	item_state_slots = list(WEAR_JACKET = "warrant_officer")
	black_market_value = 30

/obj/item/clothing/suit/storage/marine/MP/general
	name = "\improper M3 型将官护甲"
	desc = "做工精良、泛着金光的 M3 型护甲。看起来价格不菲，但出乎意料地便于携带和穿戴。"
	icon_state = "general"
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	specialty = "M3 型将官"
	item_state_slots = list(WEAR_JACKET = "general")
	w_class = SIZE_MEDIUM

/obj/item/clothing/suit/storage/marine/MP/SO
	name = "\improper M3 型军官护甲"
	desc = "做工精良的 M3 型护甲，通常由高级军官使用。上前线时，有助于让手下认清谁说了算。"
	icon_state = "officer"
	storage_slots = 3
	flags_atom = null
	specialty = "M3 型军官"
	item_state_slots = list(WEAR_JACKET = "officer")

//Making a new object because we might want to edit armor values and such.
//Or give it its own sprite. It's more for the future.
/obj/item/clothing/suit/storage/marine/MP/CO
	name = "\improper M3 型指挥官护甲"
	desc = "指挥官专用的坚固护甲，擦得锃亮，按穿戴者身形定制，并带有操控智能机枪的专用背带。让那些陆战队员看看谁才是真正的指挥官。"
	icon_state = "co_officer"
	item_state = "co_officer"
	armor_bullet = CLOTHING_ARMOR_HIGH
	storage_slots = 3
	flags_atom = NO_SNOW_TYPE
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	specialty = "M3 型舰长"
	item_state_slots = list(WEAR_JACKET = "co_officer")
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_RANK, ACCESSORY_SLOT_DECOR, ACCESSORY_SLOT_PONCHO)
	black_market_value = 35


/obj/item/clothing/suit/storage/marine/MP/CO/jacket
	name = "\improper M3 型指挥官装甲大衣"
	desc = "指挥官专用的坚固护甲，擦得锃亮，按穿戴者身形定制，并带有操控智能机枪的专用背带。让那些陆战队员看看谁才是真正的指挥官。这套护甲外罩大衣，更加保暖。"
	icon_state = "bridge_coat_armored"
	item_state = "bridge_coat_armored"
	item_state_slots = list(WEAR_JACKET = "bridge_coat_armored")
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/marine/medium/leader
	name = "\improper B12 型陆战队护甲"
	desc = "类似 M3 的半试验型防弹护甲系统，主要以碳纤维替代碳化硼。\n采用漂亮的橄榄绿色，对钝击和生物危害的防护略有提升。"
	icon_state = "7"
	armor_variation = 0
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	specialty = "B12 型陆战队"
	light_range = 5

/obj/item/clothing/suit/storage/marine/tanker
	name = "\improper M3 型装甲车组护甲"
	desc = "USCMC 装甲车组有时穿戴的装甲背心。比防破片背心或常服夹克更笨重，但在乘员需要下车时能提供明显更好的防护。"
	icon_state = "tanker"
	specialty = "M3 型装甲车组"
	storage_slots = 2

//===========================//PFC ARMOR CLASSES\\================================\\
//=================================================================================\\

// M3 pattern marine armor
/obj/item/clothing/suit/storage/marine/medium
	armor_variation = 6
	light_power = 4

/obj/item/clothing/suit/storage/marine/medium/padless_lines
	name = "M3 型棱纹陆战队护甲"
	icon_state = "2"
	armor_variation = 0
	specialty = "M3 型棱纹陆战队"

/obj/item/clothing/suit/storage/marine/medium/smooth
	name = "M3 型光面陆战队护甲"
	icon_state = "3"
	armor_variation = 0
	specialty = "M3 型光面陆战队"

// M3-L pattern light armor
/obj/item/clothing/suit/storage/marine/light
	name = "\improper M3-L 型轻型护甲"
	desc = "标准 M3 型护甲的精简轻量版本，以降低耐久度换取更快的移动速度。"
	specialty = "\improper M3-L 型轻型"
	icon_state = "L1"
	armor_variation = 6
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW
	storage_slots = 2

/obj/item/clothing/suit/storage/marine/light/padless_lines
	icon_state = "L2"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/smooth
	icon_state = "L3"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/light/standard
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/vest
	name = "\improper M3-VL 型防弹背心"
	desc = "直到 2182 年，USCM 非战斗人员仍配发非标准化防弹背心，缺乏 IMP 兼容性和服装照明屡次暴露出不足。这款改进 M3-L 护甲是六年研发计划的成果，为所有 USCM 非战斗人员兼顾实用、防护与舒适。"
	icon_state = "VL"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_LAMP_OVERLAY //No squad colors when wearing this since it'd look funny.
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_VERYLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	storage_slots = 1
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS
	siemens_coefficient = 0.7

/obj/item/clothing/suit/storage/marine/light/vest/dcc
	name = "\improper M3-VL 型防破片背心"
	desc = "这款护甲将 M3-VL 防弹背心与 M70 防破片夹克结合，兼具防弹、防破片性能和高机动性，主要供飞行人员使用。叠层装甲也能防护钝击，因此宪兵也常穿戴它。"
	icon_state = "VL_FLAK"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2

/obj/item/clothing/suit/storage/marine/light/synvest
	name = "\improper M3A1 合成人多用途背心"
	desc = "这款常见 M3 型背心的变体经过大幅改造，完全放弃防护，以换取最高机动性和更多储物空间。符合合成人程序限制。"
	icon_state = "VL_syn_camo"
	flags_atom = NO_NAME_OVERRIDE
	flags_marine_armor = ARMOR_LAMP_OVERLAY|SYNTH_ALLOWED //No squad colors + can be worn by synths.
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	storage_slots = 3
	slowdown = SLOWDOWN_ARMOR_SUPER_LIGHT
	time_to_unequip = 0.5 SECONDS
	time_to_equip = 1 SECONDS

/obj/item/clothing/suit/storage/marine/light/synvest/grey
	icon_state = "VL_syn"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/jungle
	icon_state = "VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/snow
	icon_state = "s_VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/desert
	icon_state = "d_VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/synvest/dgrey
	icon_state = "c_VL_syn_camo"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/light/recon
	name = "M3-R 型轻型护甲"
	desc = "专门配发给前出侦察陆战队员的轻型护甲，提供与 M3 护甲相近的防护，却不会拖慢移动速度。"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT

// M3-EOD pattern heavy armor
/obj/item/clothing/suit/storage/marine/heavy
	name = "\improper M3-H 型重型护甲"
	desc = "在胸甲后加入流变衬层的 M3 装甲背心，四肢增设护甲，以增强防弹与抗爆性能。\n其他方面的提升有限，额外护甲板的重量降低了灵活性，在失重环境中尤其明显。"
	desc_lore = "这款经典护甲的变型研发于 2160 年 UPP 与 USCM 之间的广州战争，旨在为承担排爆任务的战斗技术员提供更强防护，堪称普通陆战队员防护装备的巅峰。肩甲和护膝大幅扩展，覆盖四肢动脉。专门开发的防崩落衬层采用了同期 M70 防破片夹克的技术。"
	specialty = "\improper M3-H 型"
	icon_state = "H1"
	armor_variation = 6
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM
	light_power = 4
	light_range = 5

/obj/item/clothing/suit/storage/marine/heavy/padless_lines
	icon_state = "H2"
	armor_variation = 0

/obj/item/clothing/suit/storage/marine/heavy/smooth
	icon_state = "H3"
	armor_variation = 0

//===========================//SPECIALIST\\================================\\
//=======================================================================\\

/obj/item/clothing/suit/storage/marine/specialist
	name = "\improper B18 防护护甲"
	desc = "一套厚重坚固的护甲板，适合你非常、非常不想死得太惨的时候，不过会拖慢行动。\n每个护臂内配有两支广效康复嗪注射器。"
	icon_state = "xarmor"
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	slowdown = SLOWDOWN_ARMOR_HEAVY
	specialty = "B18 防护"
	unacidable = TRUE
	var/injections = 4

/obj/item/clothing/suit/storage/marine/specialist/verb/inject()
	set name = "取出注射器"
	set category = "物品"
	set src in usr

	if(usr.is_mob_incapacitated())
		return 0

	if(!injections)
		to_chat(usr, "你的护甲里已经没有注射器了。")
		return 0

	if(usr.get_active_hand())
		to_chat(usr, "你的当前手必须空着。")
		return 0

	to_chat(usr, "伴随着轻微的嘶声，一支注射器落入你手中。")
	var/obj/item/reagent_container/hypospray/autoinjector/skillless/O = new(usr)
	usr.put_in_active_hand(O)
	injections--
	playsound(src,'sound/machines/click.ogg', 15, 1)
	return

/obj/item/clothing/suit/storage/marine/M3G
	name = "\improper M3-G4 掷弹兵护甲"
	desc = "定制 M3 护甲，塞满了衬垫、护甲板和各种防弹材料，仅供 USCM 掷弹兵使用。"
	icon_state = "grenadier"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	slowdown = SLOWDOWN_ARMOR_HEAVY
	specialty = "M3-G4 掷弹兵"
	unacidable = TRUE
	light_range = 5

/obj/item/clothing/suit/storage/marine/M3T
	name = "\improper M3-T 轻型护甲"
	desc = "为远程爆炸武器使用者设计的定制 M3 护甲。"
	icon_state = "demolitionist"
	armor_bomb = CLOTHING_ARMOR_HIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	specialty = "M3-T 轻型"
	unacidable = TRUE

/obj/item/clothing/suit/storage/marine/M3S
	name = "\improper M3-S 轻型护甲"
	desc = "为 USCM 侦察兵设计的定制 M3 护甲。"
	icon_state = "scout_armor"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LIGHT
	specialty = "M3-S 轻型"
	unacidable = TRUE

//==================Combat Correspondent==================\\

/obj/item/clothing/suit/storage/marine/light/reporter
	name = "记者防弹衣"
	desc = "战地记者在宇宙各地的战斗与战争中使用的防弹衣。"
	icon_state = "cc_armor"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

//==================USASF & ARMY==================\\

/obj/item/clothing/suit/storage/marine/medium/rto/navy
	name = "\improper M4 型海军地面部署护甲"
	desc = "USASF 采购的 M4 护甲，针对部署到星球地表的人员需求进行了改装。坚固而灵活，能容纳你的各种携行袋。"
	movement_compensation = SLOWDOWN_ARMOR_LIGHT	//carbon fibre and shit in the plates rather than heavy stuff, so the swabbies stay nimble
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/storage/marine/medium/rto/army
	name = "\improper M4 型陆军护甲"
	desc = "M4 系列护甲只在 USCMC 中进行了有限的实地试验，美国陆军却已全面采用。即使与老旧的 M3 系列相比，它也出奇地不舒服。"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

//===========================//CUSTOM ARMOR\\================================\\
//=======================================================================\\
//base armor, copies everything from the storage armor for the same traits
/obj/item/clothing/suit/marine
	name = "\improper M3 型陆战队护甲"
	desc = "USCMC 制式 M3 型个人护甲，采用复合防弹装甲，集成生命体征监测系统，并带有 IMP 系统和 TNR 肩灯安装座。"
	icon = 'icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "1"
	item_state = "marine_armor" //Make unique states for Officer & Intel armors.
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/suit_1.dmi'
	)
	flags_atom = FPRINT|CONDUCT
	flags_inventory = BLOCKSHARPOBJ
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS
	flags_bodypart_hidden = BODY_FLAG_CHEST
	min_cold_protection_temperature = HELMET_MIN_COLD_PROT
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROT
	blood_overlay_type = "armor"
	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUMLOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUMLOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	movement_compensation = SLOWDOWN_ARMOR_LIGHT
	siemens_coefficient = 0.7
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	allowed = list(
		/obj/item/weapon/gun,
		/obj/item/prop/prop_gun,
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tool/lighter,
		/obj/item/storage/bible,
		/obj/item/attachable/bayonet,
		/obj/item/storage/backpack/general_belt,
		/obj/item/storage/large_holster/machete,
		/obj/item/storage/belt/gun/type47,
		/obj/item/storage/belt/gun/m4a3,
		/obj/item/storage/belt/gun/m44,
		/obj/item/storage/belt/gun/smartpistol,
		/obj/item/storage/belt/gun/flaregun,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
		/obj/item/storage/belt/gun/m39,
	)
	valid_accessory_slots = list(
		ACCESSORY_SLOT_MEDAL,
		ACCESSORY_SLOT_PAINT,
		ACCESSORY_SLOT_M3UTILITY,
		ACCESSORY_SLOT_PONCHO,
		ACCESSORY_SLOT_DECORNECK,
		ACCESSORY_SLOT_DECORARMOR,
		ACCESSORY_SLOT_DECORBRACER,
		ACCESSORY_SLOT_DECORGROIN,
		ACCESSORY_SLOT_DECORKNEE,
		ACCESSORY_SLOT_DECORSHIN,
	)
	restricted_accessory_slots = list(
		ACCESSORY_SLOT_M3UTILITY,
		ACCESSORY_SLOT_PAINT,
		ACCESSORY_SLOT_DECORNECK,
		ACCESSORY_SLOT_DECORARMOR,
		ACCESSORY_SLOT_DECORBRACER,
		ACCESSORY_SLOT_DECORGROIN,
		ACCESSORY_SLOT_DECORKNEE,
		ACCESSORY_SLOT_DECORSHIN,
	)

	light_power = 3
	light_range = 4
	light_system = MOVABLE_LIGHT

	var/flashlight_cooldown = 0 //Cooldown for toggling the light
	var/locate_cooldown = 0 //Cooldown for SL locator
	var/armor_overlays[]
	actions_types = list(/datum/action/item_action/toggle)
	var/flags_marine_armor = ARMOR_SQUAD_OVERLAY|ARMOR_LAMP_OVERLAY
	var/specialty = "M3 型陆战队" //Same thing here. Give them a specialty so that they show up correctly in vendors. speciality does NOTHING if you have NO_NAME_OVERRIDE
	w_class = SIZE_HUGE
	uniform_restricted = null
	sprite_sheets = list(SPECIES_MONKEY = 'icons/mob/humans/species/monkeys/onmob/suit_monkey_1.dmi')
	time_to_unequip = 20
	time_to_equip = 20
	drag_unequip = TRUE
	pickup_sound = "armorequip"
	drop_sound = "armorequip"
	equip_sounds = list('sound/handling/putting_on_armor1.ogg')
	has_light = TRUE
	var/armor_variation = 0
	/// The dmi where the grayscale squad overlays are contained
	var/squad_overlay_icon = 'icons/mob/humans/onmob/suit_1.dmi'

	var/atom/movable/marine_light/light_holder

/obj/item/clothing/suit/marine/Initialize(mapload)
	. = ..()
	if(!(flags_atom & NO_NAME_OVERRIDE))
		name = "[specialty]护甲"

	if(!(flags_atom & NO_SNOW_TYPE))
		select_gamemode_skin(type)
	armor_overlays = list("lamp") //Just one for now, can add more later.
	if(armor_variation && mapload)
		post_vendor_spawn_hook()
	update_icon()

	light_holder = new(src)

/obj/item/clothing/suit/marine/Destroy()
	QDEL_NULL(light_holder)
	return ..()

/obj/item/clothing/suit/marine/update_icon(mob/user)
	var/image/I
	armor_overlays["lamp"] = null
	if(flags_marine_armor & ARMOR_LAMP_OVERLAY)
		if(flags_marine_armor & ARMOR_LAMP_ON)
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-on")
		else
			I = image('icons/obj/items/clothing/cm_suits.dmi', src, "lamp-off")
		armor_overlays["lamp"] = I
		overlays += I
	else armor_overlays["lamp"] = null
	if(user) user.update_inv_wear_suit()

/obj/item/clothing/suit/marine/MouseDrop(obj/over_object as obj)
	if (ishuman(usr))
		//makes sure that the clothing is equipped so that we can't drag it into our hand from miles away.
		if ((flags_item & NODROP) || loc != usr)
			return

		if (!usr.is_mob_incapacitated() && !(usr.buckled))
			if(over_object)
				switch(over_object.name)
					if("r_hand")
						if(usr.drop_inv_item_on_ground(src))
							usr.put_in_r_hand(src)
					if("l_hand")
						if(usr.drop_inv_item_on_ground(src))
							usr.put_in_l_hand(src)
				add_fingerprint(usr)

/obj/item/clothing/suit/marine/post_vendor_spawn_hook(mob/living/carbon/human/user) //used for randomizing/selecting a variant for armors.
	var/new_look //used for the icon_state text replacement.

	if(!user?.client?.prefs)
		new_look = rand(1,armor_variation)

	else if(user.client.prefs.preferred_armor == "Random")
		new_look = rand(1,armor_variation)

	else
		new_look = GLOB.armor_style_list[user.client.prefs.preferred_armor]

	icon_state = replacetext(icon_state,"1","[new_look]")
	update_icon(user)

/obj/item/clothing/suit/marine/attack_self(mob/user)
	..()

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("你在[user.loc]内时无法[light_on ? "关闭" : "打开"]灯光。")) //To prevent some lighting anomalies.
		return

	if(flashlight_cooldown > world.time)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		return

	turn_light(user, !light_on)

/obj/item/clothing/suit/marine/item_action_slot_check(mob/user, slot)
	if(!ishuman(user))
		return FALSE
	if(slot != WEAR_JACKET)
		return FALSE
	return TRUE //only give action button when armor is worn.

/obj/item/clothing/suit/marine/turn_light(mob/user, toggle_on)
	. = ..()
	if(. != CHECKS_PASSED)
		return
	set_light_range(initial(light_range))
	set_light_power(FLOOR(initial(light_power) * 0.5, 1))
	set_light_on(toggle_on)
	flags_marine_armor ^= ARMOR_LAMP_ON

	light_holder.set_light_flags(LIGHT_ATTACHED)
	light_holder.set_light_range(initial(light_range))
	light_holder.set_light_power(initial(light_power))
	light_holder.set_light_on(toggle_on)

	if(!toggle_on)
		playsound(src, 'sound/handling/click_2.ogg', 50, 1)

	playsound(src, 'sound/handling/suitlight_on.ogg', 50, 1)
	update_icon(user)

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/obj/item/clothing/suit/marine/mob_can_equip(mob/living/carbon/human/M, slot, disable_warning = 0)
	. = ..()
	if (.)
		if(issynth(M) && M.allow_gun_usage == FALSE && !(flags_marine_armor & SYNTH_ALLOWED))
			M.visible_message(SPAN_DANGER("你的程序不允许你穿戴这件装备！"))
			return 0

/obj/item/clothing/suit/marine/lines
	name = "M3 型棱纹陆战队护甲"
	icon_state = "2"
	specialty = "M3 型棱纹陆战队"

/obj/item/clothing/suit/marine/smooth
	name = "M3 型光面陆战队护甲"
	icon_state = "3"
	specialty = "M3 型光面陆战队"

/obj/item/clothing/suit/marine/light
	name = "\improper M3-L 型轻型护甲"
	desc = "标准 M3 型护甲的精简轻量版本，以降低耐久度换取更轻的重量。"
	specialty = "\improper M3-L 型轻型"
	icon_state = "L1"
	armor_variation = 3
	slowdown = SLOWDOWN_ARMOR_LIGHT
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_LOW
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT)

/obj/item/clothing/suit/marine/light/lines
	name = "M3 型棱纹陆战队护甲"
	icon_state = "L2"
	armor_variation = 0

/obj/item/clothing/suit/marine/light/smooth
	name = "M3 型光面陆战队护甲"
	icon_state = "L3"
	armor_variation = 0

/obj/item/clothing/suit/marine/light/standard
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE


/obj/item/clothing/suit/marine/heavy
	name = "\improper M3-H 型重型护甲"
	desc = "在胸甲后加入流变衬层的 M3 装甲背心，四肢增设护甲，以增强防弹与抗爆性能。\n其他方面的提升有限，额外护甲板的重量降低了灵活性，在失重环境中尤其明显。"
	specialty = "\improper M3-H 型"
	icon_state = "H1"
	armor_variation = 3
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_HIGHPLUS
	armor_bomb = CLOTHING_ARMOR_HIGHPLUS
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/marine/heavy/lines
	name = "M3 型棱纹陆战队护甲"
	icon_state = "L2"
	armor_variation = 0

/obj/item/clothing/suit/marine/heavy/smooth
	name = "M3 型光面陆战队护甲"
	icon_state = "L3"
	armor_variation = 0

/obj/item/clothing/suit/marine/rto
	icon_state = "io"
	name = "\improper M4 型陆战队护甲"
	desc = "将智能机枪手网状护甲与 M3 型护甲板精心结合的改进护甲。坚固而灵活，能容纳你的各种携行袋。"
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUM
	light_range = 5 //slightly higher
	specialty = "M4 型陆战队"
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_DECORKNEE)

/obj/item/clothing/suit/marine/rto/forecon
	name = "\improper M3-R 型侦察护甲"
	desc = "改进型殖民地陆战队 M3 型胸甲，可保护胸部免受枪弹、利器和意外伤害，主要配发给侦察部队。"
	icon_state = "4"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORNECK, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PAINT, ACCESSORY_SLOT_DECORKNEE)

/obj/item/clothing/suit/marine/leader
	name = "\improper B12 型陆战队护甲"
	desc = "类似 M3 的半试验型防弹护甲系统，主要以碳纤维替代碳化硼。\n采用漂亮的橄榄绿色，对钝击和生物危害的防护略有提升。"
	icon_state = "7"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	specialty = "B12 型陆战队"

/obj/item/clothing/suit/marine/guard
	desc = "UACG 制式 M3 型个人护甲，采用复合防弹装甲，集成生命体征监测系统，并带有 IMP 系统和 TNR 肩灯安装座。"
	icon_state = "uacg"
	item_state = "uacg"
	flags_atom = NO_SNOW_TYPE
	name = "\improper M3 型护甲"
	specialty = "M3 型"

/obj/item/clothing/suit/marine/guard/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/pads/groin/uacg/crotchplate = new()
	src.attach_accessory(null, crotchplate, TRUE)

//Army & USASF custom-armors\\

/obj/item/clothing/suit/marine/medium/rto/navy
	name = "\improper M4-N 型护甲"
	desc = "USASF 采购的 M4 护甲，经过小幅改装，更适合舰上使用。坚固而灵活，能容纳你的各种携行袋，兼容 M3 型护甲系统的附加组件。"
	icon_state = "navy"
	item_state = "navy"
	slowdown = SLOWDOWN_ARMOR_LIGHT    //carbon fibre and shit in the plates rather than heavy stuff, so the swabbies stay nimble
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE

/obj/item/clothing/suit/marine/medium/rto/navy/heavy
	name = "\improper M4-N 型岸勤部署护甲"
	desc = "USASF 采购的 M4 护甲，针对部署到星球地表的人员需求进行了改装。坚固而灵活，能容纳你的各种携行袋，兼容 M3 型护甲系统的附加组件。"

/obj/item/clothing/suit/marine/medium/rto/navy/heavy/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/pads/groin/navy/crotchplate = new()
	src.attach_accessory(null, crotchplate, TRUE)
	var/obj/item/clothing/accessory/pads/greaves/navy/shinguards = new()
	src.attach_accessory(null, shinguards, TRUE)
	var/obj/item/clothing/accessory/pads/navy/shoulderpads = new()
	src.attach_accessory(null, shoulderpads, TRUE)

/obj/item/clothing/suit/marine/medium/rto/army
	name = "\improper 个人防弹护甲系统"
	desc = "M4 系列护甲只在 USCMC 中进行了有限的实地试验，美国陆军却已在 PBAS 计划下全面采用。即使与老旧的 M3 系列相比，它也出奇地不舒服。至少它兼容 M3 系列的附加护甲组件。"
	icon_state = "io"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_PONCHO, ACCESSORY_SLOT_DECORKNEE)
	restricted_accessory_slots = list(ACCESSORY_SLOT_DECORARMOR, ACCESSORY_SLOT_DECORGROIN, ACCESSORY_SLOT_DECORBRACER, ACCESSORY_SLOT_DECORSHIN, ACCESSORY_SLOT_M3UTILITY, ACCESSORY_SLOT_DECORKNEE)

/obj/item/clothing/suit/marine/medium/rto/army/medium

/obj/item/clothing/suit/marine/medium/rto/army/medium/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/pads/groin/crotchplate = new()
	src.attach_accessory(null, crotchplate, TRUE)
	var/obj/item/clothing/accessory/pads/greaves/shinguards = new()
	src.attach_accessory(null, shinguards, TRUE)
	var/obj/item/clothing/accessory/pads/shoulderpads = new()
	src.attach_accessory(null, shoulderpads, TRUE)

/obj/item/clothing/suit/marine/medium/rto/army/heavy

/obj/item/clothing/suit/marine/medium/rto/army/heavy/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/pads/groin/crotchplate = new()
	src.attach_accessory(null, crotchplate, TRUE)
	var/obj/item/clothing/accessory/pads/greaves/shinguards = new()
	src.attach_accessory(null, shinguards, TRUE)
	var/obj/item/clothing/accessory/pads/shoulderpads = new()
	src.attach_accessory(null, shoulderpads, TRUE)
	var/obj/item/clothing/accessory/pads/bracers/armguards = new()
	src.attach_accessory(null, armguards, TRUE)
	var/obj/item/clothing/accessory/pads/kneepads/knees = new()
	src.attach_accessory(null, knees, TRUE)

//==================PLU Lamp Rig==================\\

/obj/item/clothing/suit/marine/lamp
	name = "\improper PLU 肩灯背架"
	icon_state = "lamp_rig"
	desc = "用于支撑肩灯的轻型背架。"
	flags_atom = NO_SNOW_TYPE|NO_NAME_OVERRIDE
	blood_overlay_type = "coat"
	flags_armor_protection = BODY_FLAG_CHEST
	flags_cold_protection = BODY_FLAG_CHEST
	min_cold_protection_temperature = null
	slowdown = SLOWDOWN_ARMOR_NONE
	armor_melee = CLOTHING_ARMOR_NONE
	armor_bullet = CLOTHING_ARMOR_NONE
	armor_laser = CLOTHING_ARMOR_NONE
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_NONE
	armor_bio = CLOTHING_ARMOR_NONE
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_NONE
	time_to_unequip = 10
	time_to_equip = 10
