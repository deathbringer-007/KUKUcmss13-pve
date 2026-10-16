/obj/item/weapon/chainofcommand
	name = "指挥之链"
	desc = "大人物用来安抚群情激愤的民众的工具。"
	icon_state = "chain"
	item_state = "chain"
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	w_class = SIZE_MEDIUM

	attack_verb = list("抽打", "鞭打", "抽打", "鞭笞")

/obj/item/weapon/broken_bottle
	name = "破瓶子"
	desc = "瓶底破裂、断口锋利的瓶子。"
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "broken_bottle"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	item_state = "broken_beer"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("刺击", "劈砍", "攻击")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	var/icon/broken_outline = icon('icons/obj/items/drinks.dmi', "broken")

/obj/item/weapon/broken_bottle/bullet_act(obj/projectile/P)
	. = ..()
	new/obj/item/shard(src.loc)
	new/obj/item/shard(src.loc)
	playsound(src, "shatter", 25, 1)
	qdel(src)

/obj/item/weapon/broken_glass
	name = "破玻璃杯"
	desc = "瓶底破裂、断口锋利的瓶子。"
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "broken_glass"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	item_state = "shard-glass"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("刺击", "劈砍", "攻击")
	sharp = IS_SHARP_ITEM_SIMPLE
	edge = 0
	var/icon/broken_outline = icon('icons/obj/items/drinks.dmi', "broken")

/obj/item/weapon/broken_glass/bullet_act(obj/projectile/P)
	. = ..()
	new/obj/item/shard(src.loc)
	new/obj/item/shard(src.loc)
	playsound(src, "shatter", 25, 1)
	qdel(src)

/obj/item/weapon/dart
	name = "红色飞镖"
	desc = "一支用来投掷的飞镖。这支是红色的。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "red_dart"
	force = MELEE_FORCE_WEAK
	throwforce = MELEE_FORCE_WEAK
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("刺击", "戳刺", "攻击")

/obj/item/weapon/dart/green
	name = "绿色飞镖"
	desc = "一支用来投掷的飞镖。这支是绿色的。"
	icon_state = "green_dart"
