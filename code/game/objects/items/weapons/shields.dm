/obj/item/weapon/shield
	name = "盾牌"
	var/base_icon_state = "shield"
	var/passive_block = 15 // Percentage chance used in prob() to block incoming attack
	var/readied_block = 30
	var/readied_slowdown = SLOWDOWN_ARMOR_VERY_LIGHT // Walking around in a readied shield stance slows you! The armor defs are a useful existing reference point.
	var/shield_readied = FALSE

// Toggling procs
/obj/item/weapon/shield/proc/raise_shield(mob/user as mob) // Prepare for an attack. Slows you down slightly, but increases chance to block.
	user.visible_message(SPAN_BLUE("[user]举起了[src]。"))
	shield_readied = TRUE
	icon_state = "[base_icon_state]_ready"

	var/mob/living/carbon/human/H = user
	var/current_shield_slowdown = H.shield_slowdown
	H.shield_slowdown = max(readied_slowdown, H.shield_slowdown)
	if(H.shield_slowdown != current_shield_slowdown)
		H.recalculate_move_delay = TRUE

/obj/item/weapon/shield/proc/lower_shield(mob/user as mob)
	user.visible_message(SPAN_BLUE("[user]放下了[src]。"))
	shield_readied = FALSE
	icon_state = base_icon_state

	var/mob/living/carbon/human/H = user
	var/current_shield_slowdown = H.shield_slowdown
	var/set_shield_slowdown = 0
	var/obj/item/weapon/shield/offhand_shield
	if(H.l_hand == src && istype(H.r_hand, /obj/item/weapon/shield))
		offhand_shield = H.r_hand
	else if(H.r_hand == src && istype(H.l_hand, /obj/item/weapon/shield))
		offhand_shield = H.l_hand
	if(offhand_shield?.shield_readied)
		set_shield_slowdown = offhand_shield.readied_slowdown
	H.shield_slowdown = set_shield_slowdown
	if(H.shield_slowdown != current_shield_slowdown)
		H.recalculate_move_delay = TRUE

/obj/item/weapon/shield/proc/toggle_shield(mob/user as mob)
	if(shield_readied)
		lower_shield(user)
	else
		raise_shield(user)

// Making sure that debuffs don't stay
/obj/item/weapon/shield/dropped(mob/user as mob)
	if(shield_readied)
		lower_shield(user)
	..()

/obj/item/weapon/shield/equipped(mob/user, slot)
	if(shield_readied)
		lower_shield(user)
	..()

/obj/item/weapon/shield/riot
	name = "防暴盾牌"
	desc = "半透明的复合材料盾牌，可抵挡钝器打击和高速撞击。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "riot"
	item_state = "riot"
	base_icon_state = "riot"
	flags_equip_slot = SLOT_BACK
	force = 15
	passive_block = 20
	readied_block = 40
	readied_slowdown = SLOWDOWN_ARMOR_LIGHT
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE
	matter = list("glass" = 7500, "metal" = 1000)
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/items_lefthand_1.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/items_righthand_1.dmi'
		)

	attack_verb = list("推撞", "猛撞")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/blocks_on_back = TRUE

/obj/item/weapon/shield/riot/IsShield()
	return 1

/obj/item/weapon/shield/riot/attack_self(mob/user)
	..()
	toggle_shield(user)

/obj/item/weapon/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(cooldown < world.time - 25)
		if(istype(W, /obj/item/weapon/baton) || istype(W, /obj/item/weapon/sword) || istype(W, /obj/item/weapon/telebaton) || istype(W, /obj/item/weapon/baseballbat) || istype(W, /obj/item/weapon/classic_baton) || istype(W, /obj/item/weapon/twohanded/fireaxe) || istype(W, /obj/item/weapon/chainofcommand))
			user.visible_message(SPAN_WARNING("[user]用[W]敲击[src]！"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 25, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/energy
	name = "能量战斗盾牌"
	desc = "能抵挡大多数弹丸和近战攻击的盾牌。可收拢或展开，收纳方便。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT|NOBLOODY
	force = 3
	passive_block = 50 // Shield activation takes over functionality, and no slowdown.
	readied_block = 50
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_SMALL

	attack_verb = list("推撞", "猛撞")
	var/active = 0

/obj/item/weapon/shield/riot/metal
	name = "突击盾牌"
	desc = "涂成深灰色的复合材料防弹盾牌。只要使用得当，几乎能抵挡任何攻击。"
	icon_state = "riotmetal"
	item_state = "riotmetal"
	base_icon_state = "riotmetal"
	passive_block = 40
	readied_block = 60

/obj/item/weapon/shield/riot/ballistic //FOR THE ROYAL MARINE SPEC DO NOT TOUCH SMELLY MAN
	name = "FBS-B防弹盾牌"
	desc = "皇家陆战突击队使用的防弹盾牌。轻便又坚固，常用于登舰作战。"
	desc_lore = "狐狸B型防弹盾牌（FBS-B）的前身是FBS。自2151年起，反叛乱部署日益增多，FBS便应运而生，用于应对高强度作战。设计目标是提供最大程度的保护，同时让使用者能够配合主武器作战。到2163年，第三轮弹道试验开始进行，以确定其对改进型弹药的防护效果，也借此解决军需官逐级上报的使用者意见。原版FBS主要有两个问题：过重，以及在长时间作战后，靠近枪管的一侧会熔化。经过进一步的材料研究和实地试验，到2171年，FBS已能挡住一发穿甲弹，取得便携盾牌最高的D级弹道防护评级。据称，这一成果得益于新型纤维增强轻质复合材料。改进成功后，FBS被重新命名为FBS-B：有了强化盾牌，使用者交战时往往格外凶猛，队友便给这些破门手起了“好战者”（Bellicose）的绰号，后来也成为其正式命名的一部分。"
	icon_state = "ballisticshield"
	item_state = "ballisticshield"
	base_icon_state = "ballisticshield"
	passive_block = 60
	readied_block = 90
