/* Toys!
 * Contains:
 * Balloons
 * Fake telebeacon
 * Fake singularity
 * Toy mechs
 * Crayons
 * Snap pops
 * Water flower
 * Therapy dolls
 * Inflatable duck
 * Other things
 */

//recreational items

/obj/item/toy
	icon = 'icons/obj/items/toy.dmi'
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	force = 0
	black_market_value = 5

/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "水气球"
	desc = "一个半透明气球，里面空空如也。"
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"

/obj/item/toy/balloon/Initialize()
	. = ..()
	create_reagents(10)

/obj/item/toy/balloon/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/balloon/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE("你用[A]里的液体灌满了气球。"))
		src.desc = "一个半透明气球，里面有某种液体晃来晃去。"
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_container/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, SPAN_WARNING("[O]是空的。"))
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, SPAN_WARNING("酸液蚀穿了气球！"))
					O.reagents.reaction(user)
					qdel(src)
				else
					src.desc = "一个半透明气球，里面有某种液体晃来晃去。"
					to_chat(user, SPAN_NOTICE("你用[O]里的液体灌满了气球。"))
					O.reagents.trans_to(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/launch_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message(SPAN_DANGER("[src]爆开了！"),"你听见啪的一声，接着是液体泼溅的声音。")
		src.reagents.reaction(get_turf(hit_atom))
		for(var/atom/A in get_turf(hit_atom))
			src.reagents.reaction(A)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				qdel(src)
	return

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/syndicateballoon
	name = "辛迪加气球"
	desc = "背面的标签写着：“去他妈的维兰德-汤谷！11！”"
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	force = 0
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	w_class = SIZE_LARGE

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "电子闪光玩具"
	desc = "闪一下。再闪一下。还在闪。适合8岁及以上人群。"
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "beacon"
	item_state = "signaller"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "引力奇点"
	desc = "“奇点”牌旋转玩具。"
	icon = 'icons/obj/structures/props/singularity.dmi'
	icon_state = "singularity_s1"


/*
 * Crayons
 */

/obj/item/toy/crayon
	name = "蜡笔"
	desc = "一支彩色蜡笔。请不要吃掉它，也不要塞进鼻子里。"
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonred"
	w_class = SIZE_TINY
	attack_verb = list("攻击", "涂色")
	black_market_value = 5
	var/crayon_color = COLOR_RED
	var/shade_color = "#220000"
	/// 0 for unlimited uses
	var/uses = 30
	var/instant = 0
	var/colorName = "red" //for updateIcon purposes

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "摔炮"
	desc = "哇！"
	icon_state = "snappop"
	w_class = SIZE_TINY

/obj/item/toy/snappop/launch_impact(atom/hit_atom)
	..()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	new /obj/effect/decal/cleanable/ash(src.loc)
	src.visible_message(SPAN_DANGER("[src.name]炸响了！"),SPAN_DANGER("你听见啪的一声！"))
	playsound(src, 'sound/effects/snap.ogg', 25, 1)
	qdel(src)

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		to_chat(M, SPAN_WARNING("你踩中了摔炮！"))

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 0, src)
		s.start()
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message(SPAN_DANGER("[src.name]炸响了！"),SPAN_DANGER("你听见啪的一声！"))
		playsound(src, 'sound/effects/snap.ogg', 25, 1)
		qdel(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "喷水花"
	desc = "一朵看似无害的向日葵……另有玄机。"
	icon = 'icons/obj/items/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	var/empty = 0
	flags

/obj/item/toy/waterflower/Initialize()
	. = ..()
	create_reagents(10)
	reagents.add_reagent("water", 10)

/obj/item/toy/waterflower/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/toy/waterflower/afterattack(atom/A as mob|obj, mob/user as mob)

	if (istype(A, /obj/item/storage/backpack ))
		return

	else if (locate (/obj/structure/surface/table, src.loc))
		return

	else if (istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src,A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_NOTICE("你给喷水花重新灌满了水！"))
		return

	else if (src.reagents.total_volume < 1)
		src.empty = 1
		to_chat(user, SPAN_NOTICE("你的喷水花没水了！"))
		return

	else
		src.empty = 0


		var/obj/effect/decal/D = new/obj/effect/decal/(get_turf(src))
		D.name = "水"
		D.icon = 'icons/obj/items/chemistry.dmi'
		D.icon_state = "chempuff"
		D.create_reagents(5)
		src.reagents.trans_to(D, 1)
		playsound(src.loc, 'sound/effects/spray3.ogg', 15, 1, 3)

		spawn(0)
			for(var/i=0, i<1, i++)
				step_towards(D,A)
				D.reagents.reaction(get_turf(D))
				for(var/atom/T in get_turf(D))
					D.reagents.reaction(T)
					if(ismob(T) && T:client)
						to_chat(T:client, SPAN_WARNING("[user]向你喷了水！"))
				sleep(4)
			qdel(D)

		return

/obj/item/toy/waterflower/get_examine_text(mob/user)
	. = ..()
	. += "还剩[reagents.total_volume]单位水！"


/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon_state = "ripleytoy"
	var/cooldown = 0
	w_class = SIZE_SMALL

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	..()

	if(cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("你摆弄着[src]。"))
		playsound(user, 'sound/mecha/mechstep.ogg', 15, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user)
	if(loc == user)
		if(cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("你摆弄着[src]。"))
			playsound(user, 'sound/mecha/mechturn.ogg', 15, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "里普利机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！1/11。"

/obj/item/toy/prize/fireripley
	name = "消防型里普利机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！2/11。"
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "死亡小队里普利机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！3/11。"
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "吉盖克斯机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！4/11。"
	icon_state = "gygaxtoy"


/obj/item/toy/prize/durand
	name = "杜兰德机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！5/11。"
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "H.O.N.K.机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！6/11。"
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "掠夺者机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！7/11。"
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "炽天使机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！8/11。"
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "重殴者机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！9/11。"
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "奥德修斯机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！10/11。"
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "法宗机甲玩具"
	desc = "迷你机甲可动人偶！把它们全部收集齐吧！11/11。"
	icon_state = "phazonprize"

/obj/item/toy/prize/apc
	name = "装甲运兵车玩具"
	desc = "限量版装甲运兵车模型。"
	icon_state = "apctoy"

/obj/item/toy/inflatable_duck
	name = "充气鸭泳圈"
	desc = "能直接漂着，谁还费心考虑是沉下去还是游起来呢！"
	icon_state = "inflatable"
	item_state = "inflatable"
	icon = 'icons/obj/items/clothing/belts.dmi'
	flags_equip_slot = SLOT_WAIST
	black_market_value = 20

/obj/item/toy/beach_ball
	name = "沙滩球"
	icon_state = "beachball"
	item_state = "beachball"
	density = FALSE
	anchored = FALSE
	w_class = SIZE_SMALL
	force = 0
	throwforce = 0
	throw_speed = SPEED_SLOW
	throw_range = 20

/obj/item/toy/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	user.drop_held_item()
	throw_atom(target, throw_range, throw_speed, user)

/obj/item/toy/dice
	name = "d6"
	desc = "一枚六面骰子。"
	icon = 'icons/obj/items/dice.dmi'
	icon_state = "d66"
	w_class = SIZE_TINY
	var/sides = 6
	attack_verb = list("切丁")

/obj/item/toy/dice/Initialize()
	. = ..()
	icon_state = "[name][rand(1, sides)]"

/obj/item/toy/dice/d20
	name = "d20"
	desc = "一枚二十面骰子。"
	icon_state = "d2020"
	sides = 20

/obj/item/toy/dice/attack_self(mob/user)
	..()
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "自然20点！"
	else if(sides == 20 && result == 1)
		comment = "哎哟，真倒霉。"
	icon_state = "[name][result]"
	user.visible_message(SPAN_NOTICE("[user]掷出了[src]，点数是[result]。[comment]"), \
						SPAN_NOTICE("你掷出了[src]，点数是[result]。[comment]"), \
						SPAN_NOTICE("你听见[src]落地，点数是[result]。[comment]"))

/obj/item/toy/bikehorn
	name = "自行车喇叭"
	desc = "从自行车上拆下来的喇叭。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	attack_verb = list("鸣笛")
	black_market_value = 25
	var/spam_flag = 0
	var/sound_effect = 'sound/items/bikehorn.ogg'

/obj/item/toy/bikehorn/attack_self(mob/user)
	..()

	if (!spam_flag)
		spam_flag = TRUE
		playsound(src.loc, sound_effect, 25, 1)
		src.add_fingerprint(user)
		addtimer(VARSET_CALLBACK(src, spam_flag, FALSE), 2 SECONDS)

// rubber duck
/obj/item/toy/bikehorn/rubberducky
	name = "橡皮鸭"
	desc = "橡皮鸭呀你真好，有你洗澡真奇妙。橡皮鸭呀我真的好——喜——欢——你——呀～" //thanks doohl
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/item/computer3_part
	name = "computer part"
	desc = "Holy jesus you donnit now"
	gender = PLURAL
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "hdd1"
	w_class = SIZE_SMALL
	crit_fail = 0

/obj/item/computer3_part/toybox
	var/list/prizes = list( /obj/item/storage/box/snappops = 2,
							/obj/item/toy/blink = 2,
							/obj/item/toy/sword = 2,
							/obj/item/toy/gun = 2,
							/obj/item/toy/crossbow = 2,
							/obj/item/clothing/suit/syndicatefake = 2,
							/obj/item/storage/fancy/crayons = 2,
							/obj/item/toy/spinningtoy = 2,
							/obj/item/toy/prize/ripley = 1,
							/obj/item/toy/prize/fireripley = 1,
							/obj/item/toy/prize/deathripley = 1,
							/obj/item/toy/prize/gygax = 1,
							/obj/item/toy/prize/durand = 1,
							/obj/item/toy/prize/honk = 1,
							/obj/item/toy/prize/marauder = 1,
							/obj/item/toy/prize/seraph = 1,
							/obj/item/toy/prize/mauler = 1,
							/obj/item/toy/prize/odysseus = 1,
							/obj/item/toy/prize/phazon = 1,
							/obj/item/clothing/shoes/slippers = 1,
							/obj/item/clothing/shoes/slippers_worn = 1,
							/obj/item/clothing/head/collectable/tophat/super = 1,
							)

/obj/item/toy/festivizer
	name = "\improper C92式“圣诞气氛棒”"
	desc = "尖端工艺、维兰德-汤谷品牌、高科技……算了，骗谁呢，就是个圣诞气氛棒。你注意到上面的标签写着：<i>注意：本设备不会给物品缠上节庆彩线，只会将其染成节庆颜色。</i>真坑人！"
	icon = 'icons/obj/items/marine-items_christmas.dmi'
	icon_state = "festive_wire"
	attack_speed = 0.8 SECONDS

/obj/item/toy/festivizer/get_examine_text(mob/user)
	. = ..()
	. += SPAN_BOLDNOTICE("你看见[src]上的另一张标签写着：<i>同时支持外星生命形式！</i>你不太确定这听起来是不是好事。")

/obj/item/toy/festivizer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!target.Adjacent(user))
		return
	if(ismob(target) || isVehicle(target))
		to_chat(user, SPAN_NOTICE("出于安全考虑，[src]无法为生物或载具增添节庆色彩。"))
		return
	if(target.color)
		to_chat(user, SPAN_NOTICE("[target]已经有颜色了，别太贪心！"))
		return
	var/red = prob(50)
	target.color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, red? 0.2 : 0,!red? 0.2 : 0,0,0)
	target.visible_message(SPAN_GREEN("[user]给[target]添上了节庆色彩！圣诞快乐！"))
	to_chat(user, SPAN_GREEN("你给[target]添上了节庆色彩！圣诞快乐！"))
	playsound(user, pick(95;'sound/items/jingle_short.wav', 5;'sound/items/jingle_long.wav'), 25, TRUE)
	if(prob(5))
		playsound(target, pick('sound/voice/alien_queen_xmas.ogg', 'sound/voice/alien_queen_xmas_2.ogg'), 25, TRUE)
	user.festivizer_hits_total++

/obj/item/toy/festivizer/attack_alien(mob/living/carbon/xenomorph/M)
	attack_hand(M) //xenos can use them too.
	return XENO_NONCOMBAT_ACTION

/obj/item/toy/festivizer/xeno
	name = "裹着树脂的古怪圣诞气氛棒"
	desc = "这个古怪的圣诞气氛棒裹满黏糊糊的东西。呕！黏成这样，什么东西都能抓住它！拿起它，碰一碰其他物品，就能给它们添上节庆色彩！"

/obj/item/toy/plush
	name = "generic plushie"
	desc = "perfectly generic"
	icon = 'icons/obj/items/plush.dmi'
	icon_state = "debug"
	w_class = SIZE_SMALL
	COOLDOWN_DECLARE(last_hug_time)
	black_market_value = 10

/obj/item/toy/plush/attack_self(mob/user)
	..()
	if(!COOLDOWN_FINISHED(src, last_hug_time))
		return
	user.visible_message(SPAN_NOTICE("[user]紧紧抱住了[src]！"), SPAN_NOTICE("你抱了抱[src]。"))
	playsound(user, "plush", 25, TRUE)
	COOLDOWN_START(src, last_hug_time, 2.5 SECONDS)

/obj/item/toy/plush/farwa
	name = "法尔瓦毛绒玩偶"
	desc = "一个法尔瓦毛绒玩偶，柔软又让人安心！"
	icon_state = "farwa"
	black_market_value = 25

/obj/item/toy/plush/barricade
	name = "路障毛绒玩偶"
	desc = "害怕的时候捏一捏很合适，轻微受伤的时候也行，其他任何时候都行。"
	icon_state = "barricade"
	item_state = "cade_plush"

/obj/item/toy/plush/shark //A few more generic plushies to increase the size of the plushie loot pool
	name = "鲨鱼毛绒玩偶"
	desc = "一个卡通风格的鲨鱼毛绒玩偶。标签上写着，它由斯堪的纳维亚一家名不见经传的家具制造商生产。"
	icon_state = "shark"

/obj/item/toy/plush/bee
	name = "蜜蜂毛绒玩偶"
	desc = "一个可爱的玩具，连最内敛的陆战队员也会被它唤醒战士之魂。"
	icon_state = "bee"

/obj/item/toy/plush/moth
	name = "飞蛾毛绒玩偶"
	desc = "一个虫子毛绒玩偶。"
	icon_state = "moth"

/obj/item/toy/plush/rock
	name = "石头毛绒玩偶"
	desc = "至少标签上说它是毛绒玩偶。"
	icon_state = "rock"

/obj/item/toy/plush/otter
	name = "水獭毛绒玩偶"
	desc = "一个大小恰好、适合搂抱的水獭毛绒玩偶。请远离蛤蜊。"
	icon_state = "otter"

/obj/item/toy/plush/fox
	name = "狐狸毛绒玩偶"
	desc = "狐狸怎么叫？嗯，这只什么也不会叫，因为它是毛绒玩具。"
	icon_state = "fox"

/obj/item/toy/plush/kitten
	name = "小猫毛绒玩偶"
	desc = "一个可爱的小猫毛绒玩偶。可惜，它不会像真猫一样发出呼噜声。"
	icon_state = "kbitty"

/obj/item/toy/plush/box
	name = "盒子毛绒玩偶"
	desc = "一个装着棉花的玩具盒毛绒玩偶。"
	icon_state = "box"

/obj/item/toy/plush/carp
	name = "鲤鱼毛绒玩偶"
	desc = "一个形似传说中太空鲤鱼的毛绒玩具。"
	icon_state = "carp"

/obj/item/toy/plush/therapy
	name = "疗愈毛绒玩偶"
	desc = "一种疗愈玩具，帮助经历战斗创伤的陆战队员从精神及行为障碍中恢复。"
	icon_state = "therapy"

/obj/item/toy/plush/therapy/red
	name = "红色疗愈毛绒玩偶"
	color = "#FC5274"

/obj/item/toy/plush/therapy/blue
	name = "蓝色疗愈毛绒玩偶"
	color = "#9EBAE0"

/obj/item/toy/plush/therapy/green
	name = "绿色疗愈毛绒玩偶"
	color = "#A3C940"

/obj/item/toy/plush/therapy/orange
	name = "橙色疗愈毛绒玩偶"
	color = "#FD8535"

/obj/item/toy/plush/therapy/purple
	name = "紫色疗愈毛绒玩偶"
	color = "#A26AC7"

/obj/item/toy/plush/therapy/yellow
	name = "黄色疗愈毛绒玩偶"
	color = "#FFE492"

/obj/item/toy/plush/therapy/random_color
	///Hexadecimal 0-F (0-15)
	var/static/list/hexadecimal = list("0", "1", "2", "3" , "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")

/obj/item/toy/plush/therapy/random_color/Initialize(mapload, ...)
	. = ..()
	var/color_code = "#[pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)][pick(hexadecimal)]" //This is dumb and I hope theres a better way I'm missing
	color = color_code
	desc = "一个采用独特色彩的定制疗愈毛绒玩偶。"

/obj/item/toy/plush/random_plushie //Not using an effect so it can fit into storage from loadout
	name = "随机毛绒玩偶"
	desc = "这个毛绒玩偶看起来普通又平淡。它真的是你的吗？"
	/// Standard plushies for the spawner to pick from
	var/list/plush_list = list(
		/obj/item/toy/plush/farwa,
		/obj/item/toy/plush/barricade,
		/obj/item/toy/plush/bee,
		/obj/item/toy/plush/shark,
		/obj/item/toy/plush/moth,
		/obj/item/toy/plush/rock,
		/obj/item/toy/plush/otter,
		/obj/item/toy/plush/fox,
		/obj/item/toy/plush/kitten,
		/obj/item/toy/plush/box,
		/obj/item/toy/plush/carp,
	)
	///Therapy plushies left separately to not flood the entire list
	var/list/therapy_plush_list = list(
		/obj/item/toy/plush/therapy,
		/obj/item/toy/plush/therapy/red,
		/obj/item/toy/plush/therapy/blue,
		/obj/item/toy/plush/therapy/green,
		/obj/item/toy/plush/therapy/orange,
		/obj/item/toy/plush/therapy/purple,
		/obj/item/toy/plush/therapy/yellow,
		/obj/item/toy/plush/therapy/random_color,
	)

/obj/item/toy/plush/random_plushie/Initialize(mapload, ...)
	. = ..()
	if(mapload) //Placed in mapping, will be randomized instantly on spawn
		create_plushie()
		return INITIALIZE_HINT_QDEL

/obj/item/toy/plush/random_plushie/pickup(mob/user, silent)
	. = ..()
	RegisterSignal(user, COMSIG_POST_SPAWN_UPDATE, PROC_REF(create_plushie), override = TRUE)

///The randomizer picking and spawning a plushie on either the ground or in the humans backpack. Needs var/source due to signals
/obj/item/toy/plush/random_plushie/proc/create_plushie(datum/source)
	SIGNAL_HANDLER
	if(source)
		UnregisterSignal(source, COMSIG_POST_SPAWN_UPDATE)
	var/turf/spawn_location = get_turf(src)
	var/plush_list_variety = pick(60; plush_list, 40; therapy_plush_list)
	var/random_plushie = pick(plush_list_variety)
	var/obj/item/toy/plush/plush = new random_plushie(spawn_location) //Starts on floor by default
	var/mob/living/carbon/human/user = source

	if(!user) //If it didn't spawn on a humanoid
		qdel(src)
		return

	var/obj/item/storage/backpack/storage = locate() in user //If the user has a backpack, put it there
	if(storage?.can_be_inserted(plush, user, stop_messages = TRUE))
		storage.attempt_item_insertion(plush, TRUE, user)
	if(plush.loc == spawn_location) // Still on the ground
		user.put_in_hands(plush, drop_on_fail = TRUE)
	qdel(src)

//Admin plushies
/obj/item/toy/plush/yautja
	name = "古怪的毛绒玩偶"
	desc = "一个描绘某种高大双足类人生物的毛绒玩偶……？"
	icon_state = "yautja"
	black_market_value = 100

/obj/item/toy/plush/runner
	name = "\improper XX-121 疗愈毛绒玩偶"
	desc = "别难过！高兴点（至少你还活着）！"
	icon_state = "runner"
	/// If the runner is wearing a beret
	var/beret = FALSE

/obj/item/toy/plush/runner/Initialize(mapload, ...)
	. = ..()
	if(beret)
		update_icon()

/obj/item/toy/plush/runner/attackby(obj/item/attacking_object, mob/user)
	. = ..()
	if(beret)
		return
	if(!istypestrict(attacking_object, /obj/item/clothing/head/beret/marine/mp))
		return
	var/beret_attack = attacking_object
	to_chat(user, SPAN_NOTICE("你给[src]戴上了[beret_attack]。"))
	qdel(beret_attack)
	beret = TRUE
	update_icon()

/obj/item/toy/plush/runner/update_icon()
	. = ..()
	if(beret)
		icon_state = "runner_beret"
		return
	icon_state = "runner"

/obj/item/toy/plush/shark/alt
	icon_state = "shark_alt"

//desk toys
/obj/item/toy/desk
	name = "generic desk-toy"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/items/toy.dmi'
	var/on = FALSE
	var/activation_sound = 'sound/machines/click.ogg'

/obj/item/toy/desk/update_icon()
	if(on)
		icon_state = initial(icon_state) + "-on"
	else
		icon_state = initial(icon_state)

/obj/item/toy/desk/proc/activate(mob/user as mob)
	on = !on
	playsound(src.loc, activation_sound, 75, 1)
	update_icon()
	return 1

/obj/item/toy/desk/attack_self(mob/user)
	..()
	activate(user)

/obj/item/toy/desk/MouseDrop(atom/over_object)
	if(over_object == usr && ishuman(usr) && !usr.is_mob_restrained() && !usr.stat && (loc == usr || in_range(src, usr)))
		if(!usr.get_active_hand()) //if active hand is empty
			usr.put_in_hands(src)
		to_chat(usr, SPAN_NOTICE("你拿起了[src]。"))
	return

/obj/item/toy/desk/newtoncradle
	name = "\improper 牛顿摆"
	desc = "一个古老的21世纪超级武器模型，证明艾萨克·牛顿爵士才是太空中最致命的混蛋。"
	icon_state = "newtoncradle"

/obj/item/toy/desk/fan
	name = "办公风扇"
	desc = "你的头号风扇……兼头号粉丝。"
	icon_state = "fan"

/obj/item/toy/desk/officetoy
	name = "办公玩具"
	desc = "一个普通的电池驱动办公桌玩具，只会产生磁力和无聊感。"
	icon_state = "desktoy"

/obj/item/toy/desk/dippingbird
	name = "喝水鸟玩具"
	desc = "工程师对这台原始热机的缩尺模型赞叹不已。至于为何大多数主人都\
	从事基层文书工作，人们仍争论不休。"
	icon_state = "dippybird"
