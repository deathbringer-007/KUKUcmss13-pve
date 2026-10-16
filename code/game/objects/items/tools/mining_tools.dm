

//*****************************Pickaxe********************************/

/obj/item/tool/pickaxe
	name = "镐子"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "pickaxe"
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	force = MELEE_FORCE_STRONG
	throwforce = 4
	item_state = "pickaxe"
	w_class = SIZE_LARGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	matter = list("metal" = 3750)
	/// moving the delay to an item var so R&D can make improved picks. --NEO
	var/digspeed = 40

	attack_verb = list("击打", "刺穿", "切割", "攻击")
	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "picking"
	sharp = IS_SHARP_ITEM_SIMPLE
	var/excavation_amount = 100

/obj/item/tool/pickaxe/hammer
	name = "矿用大锤"
	icon_state = "minesledge"
	item_state = "minesledge"
	desc = "用强化金属制成的矿锤，用起来和镐子一样好使。"

/obj/item/tool/pickaxe/silver
	name = "银镐"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30

	desc = "这在冶金学上完全说不通。"
	black_market_value = 25

/obj/item/tool/pickaxe/drill
	/// Can dig sand as well!
	name = "采矿钻"
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30

	desc = "你的钻头，是要钻穿岩壁的钻头。"
	drill_verb = "drilling"

/obj/item/tool/pickaxe/jackhammer
	name = "声波碎岩锤"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	/// faster than drill, but cannot dig
	digspeed = 20

	desc = "用声波冲击震碎岩石，非常适合对付洞穴蜥蜴。"
	drill_verb = "hammering"

/obj/item/tool/pickaxe/gold
	name = "金镐"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20

	desc = "这在冶金学上完全说不通。"
	black_market_value = 30

/obj/item/tool/pickaxe/plasmacutter
	name = "等离子切割器"
	icon_state = "plasmacutter"
	item_state = "gun"
	/// it is smaller than the pickaxe
	w_class = SIZE_MEDIUM
	damtype = "fire"
	/// Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/ light thermite on fire
	digspeed = 20
	desc = "利用高温等离子脉冲切割岩石的工具。你可以用它切断异形的肢体！当然，也可以拿来挖矿。"
	drill_verb = "cutting"
	heat_source = 3800
	flags_item = IGNITING_ITEM

/obj/item/tool/pickaxe/diamond
	name = "钻石镐"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10

	desc = "装有钻石镐头的镐子，就像《我的世界》里的一样。"
	black_market_value = 5 //fuck you!

/obj/item/tool/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "钻石采矿钻"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	/// Digs through walls, girders, and can dig up sand
	digspeed = 5

	desc = "你的钻头，是要突破天际的钻头！"
	drill_verb = "drilling"
	black_market_value = 35

/obj/item/tool/pickaxe/borgdrill
	name = "赛博格采矿钻"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"





