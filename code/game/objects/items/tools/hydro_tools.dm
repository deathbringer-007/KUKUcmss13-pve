
// *************************************
// Hydroponics Tools
// *************************************

/obj/item/tool/plantspray
	icon = 'icons/obj/items/spray.dmi'
	item_state = "spray"
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	throwforce = 4
	w_class = SIZE_SMALL
	throw_speed = SPEED_SLOW
	throw_range = 10
	var/toxicity = 4
	var/pest_kill_str = 0
	var/weed_kill_str = 0

/obj/item/tool/plantspray/weeds // -- Skie

	name = "除草喷雾"
	desc = "一种有毒的喷雾混合剂，用来清除小型杂草。"
	icon_state = "weedspray"
	weed_kill_str = 6

/obj/item/tool/plantspray/pests
	name = "杀虫喷雾"
	desc = "杀虫喷雾！<I>切勿吸入！</I>"
	icon_state = "pestspray"
	pest_kill_str = 6

/obj/item/tool/plantspray/pests/old
	name = "瓶装杀虫剂"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle16"

/obj/item/tool/plantspray/pests/old/carbaryl
	name = "瓶装西维因"
	icon_state = "bottle16"
	toxicity = 4
	pest_kill_str = 2

/obj/item/tool/plantspray/pests/old/lindane
	name = "瓶装林丹"
	icon_state = "bottle18"
	toxicity = 6
	pest_kill_str = 4

/obj/item/tool/plantspray/pests/old/phosmet
	name = "瓶装亚胺硫磷"
	icon_state = "bottle15"
	toxicity = 8
	pest_kill_str = 7



/obj/item/tool/weedkiller
	name = "瓶装除草剂"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "bottle16"
	var/toxicity = 0
	var/weed_kill_str = 0

/obj/item/tool/weedkiller/triclopyr
	name = "瓶装草甘膦"
	icon_state = "bottle16"
	toxicity = 4
	weed_kill_str = 2

/obj/item/tool/weedkiller/lindane
	name = "瓶装三氯吡氧乙酸"
	icon_state = "bottle18"
	toxicity = 6
	weed_kill_str = 4

/obj/item/tool/weedkiller/D24
	name = "瓶装2,4-D"
	icon_state = "bottle15"
	toxicity = 8
	weed_kill_str = 7




/obj/item/tool/minihoe // -- Numbers
	name = "小锄头"
	desc = "用于除草，也可以拿来挠背。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	force = 5
	throwforce = 7
	w_class = SIZE_SMALL
	matter = list("metal" = 50)
	attack_verb = list("劈砍", "切割", "割伤", "抓挠")




//Hatchets and things to kill kudzu
/obj/item/tool/hatchet
	name = "手斧"
	desc = "一把锋利的手斧，常用于劈开木材或其他东西。樵夫、侦察员和掠夺者经常使用它。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "hatchet"
	flags_atom = FPRINT|CONDUCT
	force = MELEE_FORCE_NORMAL
	w_class = SIZE_SMALL
	throwforce = 20
	throw_speed = SPEED_VERY_FAST
	throw_range = 4
	sharp = IS_SHARP_ITEM_BIG
	edge = 1
	matter = list("metal" = 15000)

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("砍击", "撕裂", "割伤")


/obj/item/tool/scythe
	name = "长柄镰刀"
	desc = "长长的纤维金属柄上装着锋利弯曲的刀刃，让你轻松收获自己种下的作物。"
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "scythe"
	force = 13
	throwforce = 5
	throw_speed = SPEED_FAST
	throw_range = 3
	w_class = SIZE_LARGE
	flags_atom = FPRINT|CONDUCT
	flags_item = NOSHIELD
	flags_equip_slot = SLOT_BACK

	attack_verb = list("砍击", "切割", "割伤", "收割")

/obj/item/tool/scythe/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(A, /obj/effect/plantsegment))
		for(var/obj/effect/plantsegment/B in orange(A,1))
			if(prob(80))
				qdel(B)
		qdel(A)
