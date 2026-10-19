

// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

//Grown foods
//Subclass so we can pass on values
/obj/item/reagent_container/food/snacks/grown
	var/plantname
	var/potency = -1
	icon = 'icons/obj/items/harvest.dmi'

/obj/item/reagent_container/food/snacks/grown/New(newloc,newpotency)
	if (!isnull(newpotency))
		potency = newpotency
	..()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

/obj/item/reagent_container/food/snacks/grown/Initialize()
	. = ..()
	GLOB.grown_snacks_list += src
	addtimer(CALLBACK(src, PROC_REF(update_from_seed)), 1)

/obj/item/reagent_container/food/snacks/grown/Destroy()
	GLOB.grown_snacks_list -= src
	return ..()

/obj/item/reagent_container/food/snacks/grown/proc/update_from_seed()// Fill the object up with the appropriate reagents.
	if(!isnull(plantname))
		var/datum/seed/S = GLOB.seed_types[plantname]
		if(!S)
			return
		name = localized_seed_label(S.seed_name) //Copies the name from the seed, important for renamed plants
		if(!S.chems)
			return
		potency = S.potency

		for(var/rid in S.chems)
			var/list/reagent_data = S.chems[rid]
			var/rtotal = reagent_data[1]
			if(length(reagent_data) > 1 && potency > 0)
				rtotal += floor(potency/reagent_data[2])
			if(reagents)
				reagents.add_reagent(rid, max(1, rtotal))

	if(reagents && reagents.total_volume > 0)
		bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/reagent_container/food/snacks/grown/corn
	name = "玉米棒"
	desc = "还缺点黄油！"
	plantname = "corn"
	icon_state = "corn"
	potency = 40
	filling_color = "#FFEE00"
	trash = /obj/item/corncob

/obj/item/reagent_container/food/snacks/grown/cherries
	name = "樱桃"
	desc = "很适合当配料！"
	icon_state = "cherry"
	filling_color = COLOR_RED
	gender = PLURAL
	plantname = "cherry"

/obj/item/reagent_container/food/snacks/grown/poppy
	name = "罂粟"
	desc = "长久以来都是安息、和平与死亡的象征。"
	icon_state = "poppy"
	potency = 30
	filling_color = "#CC6464"
	plantname = "poppies"
	black_market_value = 25

/obj/item/reagent_container/food/snacks/grown/harebell
	name = "风铃草"
	desc = "“我要为你凄清的坟茔添上芬芳：像你面庞的淡色报春花不会少，像你血脉的湛蓝风铃草也不会少；还要有野蔷薇的叶子——不是贬低它，它的香气也比不上你的呼吸。”"
	icon_state = "harebell"
	potency = 1
	filling_color = "#D4B2C9"
	plantname = "harebells"

/obj/item/reagent_container/food/snacks/grown/potato
	name = "土豆"
	desc = "煮着吃！捣成泥！丢进炖锅里！"
	icon_state = "potato"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "potato"

/obj/item/reagent_container/food/snacks/grown/grapes
	name = "一串葡萄"
	desc = "营养丰富！"
	icon_state = "grapes"
	filling_color = "#A332AD"
	plantname = "grapes"

/obj/item/reagent_container/food/snacks/grown/greengrapes
	name = "一串绿葡萄"
	desc = "营养丰富！"
	icon_state = "greengrapes"
	potency = 25
	filling_color = "#A6FFA3"
	plantname = "greengrapes"

/obj/item/reagent_container/food/snacks/grown/peanut
	name = "花生"
	desc = "坚果！"
	icon_state = "peanut"
	filling_color = "857e27"
	potency = 25
	plantname = "peanut"

/obj/item/reagent_container/food/snacks/grown/cabbage
	name = "卷心菜"
	desc = "呕——卷心菜。"
	icon_state = "cabbage"
	potency = 25
	filling_color = "#A2B5A1"
	plantname = "cabbage"

/obj/item/reagent_container/food/snacks/grown/berries
	name = "一串浆果"
	desc = "营养丰富！"
	icon_state = "berrypile"
	filling_color = "#C2C9FF"
	plantname = "berries"

/obj/item/reagent_container/food/snacks/grown/plastellium
	name = "一丛塑钢草"
	desc = "嗯，还得加工一下。"
	icon_state = "plastellium"
	filling_color = "#C4C4C4"
	plantname = "plastic"

/obj/item/reagent_container/food/snacks/grown/shand
	name = "斯兰达之手叶片"
	desc = "一片取自低地灌木丛的叶片，散发着浓重的蜡味。"
	icon_state = "shand"
	filling_color = "#70C470"
	plantname = "shand"

/obj/item/reagent_container/food/snacks/grown/mtear
	name = "一枝梅萨之泪"
	desc = "一种生长在山地气候中的草本植物，开着柔软的冷蓝色花朵，以富含药用成分而闻名。"
	icon_state = "mtear"
	filling_color = "#70C470"
	plantname = "mtear"

/obj/item/reagent_container/food/snacks/grown/mtear/attack_self(mob/user)
	..()

	if(istype(user.loc,/turf/open/space))
		return
	var/obj/item/stack/medical/advanced/ointment/predator/poultice = new /obj/item/stack/medical/advanced/ointment/predator(user.loc)

	poultice.heal_burn = potency
	qdel(src)

	to_chat(user, SPAN_NOTICE("你把花瓣捣成了膏药。"))

/obj/item/reagent_container/food/snacks/grown/shand/attack_self(mob/user)
	..()

	if(istype(user.loc,/turf/open/space))
		return
	var/obj/item/stack/medical/advanced/bruise_pack/predator/poultice = new /obj/item/stack/medical/advanced/bruise_pack/predator(user.loc)

	poultice.heal_brute = potency
	qdel(src)

	to_chat(user, SPAN_NOTICE("你把叶片捣成了膏药。"))

/obj/item/reagent_container/food/snacks/grown/glowberries
	name = "一串发光浆果"
	desc = "营养丰富！"
	var/brightness_on = 2 //luminosity when on
	filling_color = "#D3FF9E"
	icon_state = "glowberrypile"
	plantname = "glowberries"

/obj/item/reagent_container/food/snacks/grown/glowberries/Initialize()
	. = ..()

	set_light_range(brightness_on)
	set_light_on(TRUE)

/obj/item/reagent_container/food/snacks/grown/cocoapod
	name = "可可荚"
	desc = "可以磨成可可粉。"
	icon_state = "cocoapod"
	potency = 50
	filling_color = "#9C8E54"
	plantname = "cocoa"

/obj/item/reagent_container/food/snacks/grown/sugarcane
	name = "甘蔗"
	desc = "甜得发腻。"
	icon_state = "sugarcane"
	potency = 50
	filling_color = "#C0C9AD"
	plantname = "sugarcane"

/obj/item/reagent_container/food/snacks/grown/poisonberries
	name = "一串毒浆果"
	desc = "好吃得让你可能连命都丢了！"
	icon_state = "poisonberrypile"
	gender = PLURAL
	potency = 15
	filling_color = "#B422C7"
	plantname = "poisonberries"

/obj/item/reagent_container/food/snacks/grown/deathberries
	name = "一串致命浆果"
	desc = "好吃得让你肯定连命都丢了！"
	icon_state = "deathberrypile"
	gender = PLURAL
	potency = 50
	filling_color = "#4E0957"
	plantname = "deathberries"

/obj/item/reagent_container/food/snacks/grown/ambrosiavulgaris
	name = "普通仙草枝条"
	desc = "这株植物含有多种药用成分。"
	icon_state = "ambrosiavulgaris"
	potency = 10
	filling_color = "#125709"
	plantname = "ambrosia"

/obj/item/reagent_container/food/snacks/grown/ambrosiavulgaris/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper))
		to_chat(user, SPAN_NOTICE("你抓起普通仙草，用纸把它卷成了一支烟卷。"))
		new /obj/item/clothing/mask/cigarette/weed (user.loc)
		qdel(src)
		qdel(W)
	else
		return ..()


/obj/item/reagent_container/food/snacks/grown/ambrosiadeus
	name = "神圣仙草枝条"
	desc = "吃了它，让你感觉自己能长生不老！"
	icon_state = "ambrosiadeus"
	potency = 10
	filling_color = "#229E11"
	plantname = "ambrosiadeus"

/obj/item/reagent_container/food/snacks/grown/apple
	name = "苹果"
	desc = "一小块伊甸园的滋味。"
	icon_state = "apple"
	potency = 15
	filling_color = "#DFE88B"
	plantname = "apple"

/obj/item/reagent_container/food/snacks/grown/apple/poisoned
	name = "苹果"
	desc = "一小块伊甸园的滋味。"
	icon_state = "apple"
	potency = 15
	filling_color = "#B3BD5E"
	plantname = "poisonapple"

/obj/item/reagent_container/food/snacks/grown/goldapple
	name = "金苹果"
	desc = "金苹果上刻着“Kallisti（献给最美者）”。"
	icon_state = "goldapple"
	potency = 15
	filling_color = "#F5CB42"
	plantname = "goldapple"
	black_market_value = 30

/obj/item/reagent_container/food/snacks/grown/watermelon
	name = "西瓜"
	desc = "汁水丰沛，鲜甜可口。"
	icon_state = "watermelon"
	potency = 10
	filling_color = "#FA2863"
	slice_path = /obj/item/reagent_container/food/snacks/watermelonslice
	slices_num = 5
	plantname = "watermelon"

/obj/item/reagent_container/food/snacks/grown/pumpkin
	name = "南瓜"
	desc = "又大又吓人。"
	icon_state = "pumpkin"
	potency = 10
	filling_color = "#FAB728"
	plantname = "pumpkin"

/obj/item/reagent_container/food/snacks/grown/pumpkin/attackby(obj/item/W as obj, mob/user as mob)
	if(W.sharp == IS_SHARP_ITEM_ACCURATE || W.sharp == IS_SHARP_ITEM_BIG)
		to_chat(user, SPAN_NOTICE("你在[src]上刻出了一张脸！"))
		new /obj/item/clothing/head/pumpkinhead (user.loc)
		qdel(src)
	else
		return ..()

/obj/item/reagent_container/food/snacks/grown/lime
	name = "青柠"
	desc = "酸得能让你的脸皱成一团。"
	icon_state = "lime"
	potency = 20
	filling_color = "#28FA59"
	plantname = "lime"

/obj/item/reagent_container/food/snacks/grown/lemon
	name = "柠檬"
	desc = "生活给你柠檬时，庆幸它没给你青柠吧。"
	icon_state = "lemon"
	potency = 20
	filling_color = "#FAF328"
	plantname = "lemon"

/obj/item/reagent_container/food/snacks/grown/orange
	name = "橙子"
	desc = "一种酸甜的水果。"
	icon_state = "orange"
	potency = 20
	filling_color = "#FAAD28"
	plantname = "orange"

/obj/item/reagent_container/food/snacks/grown/whitebeet
	name = "白甜菜"
	desc = "白甜菜，无可比拟。"
	icon_state = "whitebeet"
	potency = 15
	filling_color = "#FFFCCC"
	plantname = "whitebeet"

/obj/item/reagent_container/food/snacks/grown/banana
	name = "香蕉"
	desc = "喜剧的绝佳道具。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "banana"
	item_state = "banana"
	filling_color = "#FCF695"
	trash = /obj/item/bananapeel
	plantname = "banana"

/obj/item/reagent_container/food/snacks/grown/chili
	name = "辣椒"
	desc = "好辣！等等……烧起来了！！"
	icon_state = "chilipepper"
	filling_color = COLOR_RED
	plantname = "chili"

/obj/item/reagent_container/food/snacks/grown/eggplant
	name = "茄子"
	desc = "也许里面藏着只鸡？"
	icon_state = "eggplant"
	filling_color = "#550F5C"
	plantname = "eggplant"

/obj/item/reagent_container/food/snacks/grown/soybeans
	name = "大豆"
	desc = "味道挺淡，但能做出的花样可不少……"
	gender = PLURAL
	filling_color = "#E6E8B7"
	icon_state = "soybeans"
	plantname = "soybean"

/obj/item/reagent_container/food/snacks/grown/tomato
	name = "番茄"
	desc = "你叫它西红柿，我叫它番茄。"
	icon_state = "tomato"
	filling_color = COLOR_RED
	potency = 10
	plantname = "tomato"

/obj/item/reagent_container/food/snacks/grown/tomato/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/tomato_smudge(src.loc)
	src.visible_message(SPAN_NOTICE("[src.name]被砸烂了。"),SPAN_MODERATE("你听见啪的一声。"))
	qdel(src)
	return

/obj/item/reagent_container/food/snacks/grown/killertomato
	name = "杀人番茄"
	desc = "我叫它番茄，你叫它西红柿……天哪，它在啃我的腿！！"
	icon_state = "killertomato"
	potency = 10
	filling_color = COLOR_RED
	potency = 30
	plantname = "killertomato"

/obj/item/reagent_container/food/snacks/grown/killertomato/attack_self(mob/user)
	..()

	if(istype(user.loc,/turf/open/space))
		return
	new /mob/living/simple_animal/tomato(user.loc)
	qdel(src)

	to_chat(user, SPAN_NOTICE("你种下了杀人番茄。"))

/obj/item/reagent_container/food/snacks/grown/bloodtomato
	name = "血番茄"
	desc = "好多血……太……太多……血了……啊啊啊啊！！！！"
	icon_state = "bloodtomato"
	potency = 10
	filling_color = COLOR_RED
	plantname = "bloodtomato"

/obj/item/reagent_container/food/snacks/grown/bloodtomato/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/blood/splatter(src.loc)
	src.visible_message(SPAN_NOTICE("[src.name]被砸烂了。"),SPAN_MODERATE("你听见啪的一声。"))
	src.reagents.reaction(get_turf(hit_atom))
	for(var/atom/A in get_turf(hit_atom))
		src.reagents.reaction(A)
	qdel(src)
	return

/obj/item/reagent_container/food/snacks/grown/bluetomato
	name = "蓝番茄"
	desc = "我叫它蓝番茄，你叫它蓝西红柿。"
	icon_state = "bluetomato"
	potency = 10
	filling_color = "#586CFC"
	plantname = "bluetomato"

/obj/item/reagent_container/food/snacks/grown/bluetomato/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/blood/oil(src.loc)
	src.visible_message(SPAN_NOTICE("[src.name]被砸烂了。"),SPAN_MODERATE("你听见啪的一声。"))
	src.reagents.reaction(get_turf(hit_atom))
	for(var/atom/A in get_turf(hit_atom))
		src.reagents.reaction(A)
	qdel(src)
	return

/obj/item/reagent_container/food/snacks/grown/bluetomato/Crossed(AM as mob|obj)
	if (iscarbon(AM))
		var/mob/living/carbon/C = AM
		C.slip(name, 8, 5)

/obj/item/reagent_container/food/snacks/grown/wheat
	name = "小麦"
	desc = "唉……小麦……又来一茬？"
	gender = PLURAL
	icon_state = "wheat"
	filling_color = "#F7E186"
	plantname = "wheat"

/obj/item/reagent_container/food/snacks/grown/ricestalk
	name = "稻秆"
	desc = "很高“稻”见到你。"
	gender = PLURAL
	icon_state = "rice"
	filling_color = "#FFF8DB"
	plantname = "rice"

/obj/item/reagent_container/food/snacks/grown/kudzupod
	name = "葛藤荚"
	desc = "<I>Pueraria Virallis</I>：一种入侵植物，其藤蔓会迅速蔓延，缠住接触到的一切。"
	icon_state = "kudzupod"
	filling_color = "#59691B"
	plantname = "kudzu"

/obj/item/reagent_container/food/snacks/grown/icepepper
	name = "冰椒"
	desc = "这是一种变异辣椒。"
	icon_state = "icepepper"
	potency = 20
	filling_color = "#66CEED"
	plantname = "icechili"

/obj/item/reagent_container/food/snacks/grown/carrot
	name = "胡萝卜"
	desc = "对眼睛有好处！"
	icon_state = "carrot"
	potency = 10
	filling_color = "#FFC400"
	plantname = "carrot"

/obj/item/reagent_container/food/snacks/grown/mushroom/reishi
	name = "灵芝"
	desc = "<I>Ganoderma lucidum</I>：一种特殊真菌，据说有助于缓解压力。"
	icon_state = "reishi"
	potency = 10
	filling_color = "#FF4800"
	plantname = "reishi"

/obj/item/reagent_container/food/snacks/grown/mushroom/amanita
	name = "毒蝇伞"
	desc = "<I>Amanita Muscaria</I>：要牢记毒蘑菇的特征，只采摘自己认识的蘑菇。"
	icon_state = "amanita"
	potency = 10
	filling_color = COLOR_RED
	plantname = "amanita"

/obj/item/reagent_container/food/snacks/grown/mushroom/angel
	name = "毁灭天使菇"
	desc = "<I>Amanita Virosa</I>：一种剧毒的担子菌，富含α型鹅膏毒素。"
	icon_state = "angel"
	potency = 35
	filling_color = "#FFDEDE"
	plantname = "destroyingangel"

/obj/item/reagent_container/food/snacks/grown/mushroom/libertycap
	name = "自由帽菇"
	desc = "<I>Psilocybe Semilanceata</I>：解放自己！"
	icon_state = "libertycap"
	potency = 15
	filling_color = "#F714BE"
	plantname = "libertycap"

/obj/item/reagent_container/food/snacks/grown/mushroom/plumphelmet
	name = "肥菇"
	desc = "<I>Plumus Hellmus</I>：饱满、柔软，还、还那么诱人～"
	icon_state = "plumphelmet"
	filling_color = "#F714BE"
	plantname = "plumphelmet"

/obj/item/reagent_container/food/snacks/grown/mushroom/chanterelle
	name = "一簇鸡油菌"
	desc = "<I>鸡油菌</I>：这些讨喜的黄色小蘑菇看起来真好吃！"
	icon_state = "chanterelle"
	filling_color = "#FFE991"
	plantname = "mushrooms"

/obj/item/reagent_container/food/snacks/grown/mushroom/glowshroom
	name = "一簇发光菇"
	desc = "<I>Mycena Bregprox</I>：这种蘑菇会在黑暗中发光。真的会吗？"
	icon_state = "glowshroom"
	filling_color = "#DAFF91"
	potency = 30
	plantname = "glowshroom"
	black_market_value = 20

/obj/item/reagent_container/food/snacks/grown/mushroom/glowshroom/attack_self(mob/user)
	..()

	if(istype(user.loc,/turf/open/space))
		return
	var/obj/effect/glowshroom/planted = new /obj/effect/glowshroom(user.loc)

	planted.delay = 50
	planted.endurance = 100
	planted.potency = potency
	qdel(src)

	to_chat(user, SPAN_NOTICE("你种下了发光菇。"))

// *************************************
// Complex Grown Object Defines -
// Putting these at the bottom so they don't clutter the list up. -Cheridan
// *************************************

/obj/item/reagent_container/food/snacks/grown/bluespacetomato
	name = "蓝空间番茄"
	desc = "滑得让你可能直接滑穿时空。"
	icon_state = "bluespacetomato"
	potency = 20

	filling_color = "#91F8FF"
	plantname = "bluespacetomato"

/obj/item/reagent_container/food/snacks/grown/bluespacetomato/launch_impact(atom/hit_atom)
	..()
	var/mob/M = usr
	var/outer_teleport_radius = potency/10 //Plant potency determines radius of teleport.
	var/inner_teleport_radius = potency/15
	var/list/turfs = new/list()
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	if(inner_teleport_radius < 1) //Wasn't potent enough, it just splats.
		new/obj/effect/decal/cleanable/blood/oil(src.loc)
		src.visible_message(SPAN_NOTICE("[src.name]被砸烂了。"),SPAN_MODERATE("你听见啪的一声。"))
		qdel(src)
		return
	for(var/turf/T as anything in (RANGE_TURFS(outer_teleport_radius, M) - RANGE_TURFS(inner_teleport_radius, M)))
		if(istype(T,/turf/open/space)) continue
		if(T.density) continue
		if(T.x>world.maxx-outer_teleport_radius || T.x<outer_teleport_radius) continue
		if(T.y>world.maxy-outer_teleport_radius || T.y<outer_teleport_radius) continue
		turfs += T
	if(!length(turfs))
		turfs += pick(RANGE_TURFS(outer_teleport_radius, M) - RANGE_TURFS(inner_teleport_radius, M))
	var/turf/picked = pick(turfs)
	if(!isturf(picked)) return
	switch(rand(1,2))//Decides randomly to teleport the thrower or the throwee.
		if(1) // Teleports the person who threw the tomato.
			s.set_up(3, 1, M)
			s.start()
			new/obj/effect/decal/cleanable/molten_item(M.loc) //Leaves a pile of goo behind for dramatic effect.
			M.forceMove(picked )//
			sleep(1)
			s.set_up(3, 1, M)
			s.start() //Two set of sparks, one before the teleport and one after.
		if(2) //Teleports mob the tomato hit instead.
			for(var/mob/A in get_turf(hit_atom))//For the mobs in the tile that was hit...
				s.set_up(3, 1, A)
				s.start()
				new/obj/effect/decal/cleanable/molten_item(A.loc) //Leave a pile of goo behind for dramatic effect...
				A.forceMove(picked)//And teleport them to the chosen location.
				sleep(1)
				s.set_up(3, 1, A)
				s.start()
	new/obj/effect/decal/cleanable/blood/oil(src.loc)
	src.visible_message(SPAN_NOTICE("[src.name]被砸烂了，导致时空发生扭曲。"),SPAN_MODERATE("你听见噗的一声，随后传来噼啪声。"))
	qdel(src)
	return
