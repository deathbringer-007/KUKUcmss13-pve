/* SNACK
* snack are food items that after being consume destroy themself.
* some snack are slice able.
* some produce trash after being consume/destroyed.
*/

/obj/item/reagent_container/food/snacks
	name = "零食"
	desc = "美味。"
	icon = 'icons/obj/items/food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/package = 0
	var/made_from_player = ""
	center_of_mass = "x=15;y=15"

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/reagent_container/food/snacks/proc/On_Consume(mob/M)
	SEND_SIGNAL(src, COMSIG_SNACK_EATEN, M)
	SEND_SIGNAL(M, COMSIG_MOB_EATEN_SNACK, src)
	if(!usr) return

	if(!reagents.total_volume)
		if(M == usr)
			to_chat(usr, SPAN_NOTICE("你吃完了[src]。"))
		M.visible_message(SPAN_NOTICE("[M]吃完了[src]。"))
		usr.drop_inv_item_on_ground(src) //so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_container/food/snacks/attack_self(mob/user)
	..()

	if (world.time <= user.next_move)
		return FALSE
	attack(user, user, "head")//zone does not matter
	user.next_move += attack_speed

/obj/item/reagent_container/food/snacks/attack(mob/M, mob/user)
	if(reagents && !reagents.total_volume) //Shouldn't be needed but it checks to see if it has anything left in it.
		to_chat(user, SPAN_DANGER("[src]一点都不剩了，糟糕！"))
		M.drop_inv_item_on_ground(src) //so icons update :[
		qdel(src)
		return FALSE

	if(package)
		if(user.a_intent == INTENT_HARM)
			return ..() // chunk box gaming

		if(user == M)
			to_chat(M, SPAN_WARNING("包装还没拆，你打算怎么吃？"))
		else
			to_chat(M, SPAN_WARNING("[user]试图把一份连包装都没拆的零食硬塞给你吃，真是好心办坏事。"))
		return FALSE

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(fullness > NUTRITION_HIGH && world.time < C.overeat_cooldown)
			to_chat(user, SPAN_WARNING("[user == M ? "你" : "对方"]现在不想再吃了。"))
			return FALSE
		if(issynth(C))
			fullness = 200 //Synths never get full

		if(HAS_TRAIT(M, TRAIT_CANNOT_EAT)) //Do not feed the Working Joes
			to_chat(user, SPAN_DANGER("[user == M ? "你" : "[M]"]无法进食！"))
			return FALSE

		if(fullness > NUTRITION_HIGH)
			C.overeat_cooldown = world.time + OVEREAT_TIME

		if(M == user)//If you're eating it yourself

			var/eat_time = (1.5 SECONDS)
			if(user.buckled)
				eat_time *= 0.25

			if(user.action_busy)
				return

			if(!do_after(user, eat_time, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
				return

			if (fullness <= NUTRITION_VERYLOW)
				to_chat(M, SPAN_WARNING("你饥肠辘辘地咬下一块[src]，狼吞虎咽地吃了下去！"))
			if (fullness > NUTRITION_VERYLOW && fullness <= NUTRITION_LOW)
				to_chat(M, SPAN_NOTICE("你饥肠辘辘地开始吃[src]。"))
			if (fullness > NUTRITION_LOW && fullness <= NUTRITION_NORMAL)
				to_chat(M, SPAN_NOTICE("你咬了一口[src]。"))
			if (fullness > NUTRITION_NORMAL && fullness <= NUTRITION_HIGH)
				to_chat(M, SPAN_NOTICE("你不情愿地嚼了一点[src]。"))
			if (fullness > NUTRITION_HIGH)
				to_chat(M, SPAN_WARNING("你勉强把更多[src]硬咽了下去。"))
		else
			if (fullness <= NUTRITION_HIGH)
				user.affected_message(M,
					SPAN_HELPFUL("你<b>开始给</b>[user == M ? "自己" : "[M]"]<b>喂[src]</b>。"),
					SPAN_HELPFUL("[user]<b>开始给你喂[src]</b>。"),
					SPAN_NOTICE("[user]开始给[user == M ? "自己" : "[M]"]喂[src]。"))

			if(user.action_busy)
				return

			if(!do_after(user, (3 SECONDS), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M))
				return

			var/rgt_list_text = get_reagent_list_text()

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
			msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

			user.affected_message(M,
				SPAN_HELPFUL("你<b>给</b>[user == M ? "自己" : "[M]"]<b>喂了[src]</b>。"),
				SPAN_HELPFUL("[user]<b>给你喂了[src]</b>。"),
				SPAN_NOTICE("[user]给[user == M ? "自己" : "[M]"]喂了[src]。"))

		if(reagents) //Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', 15, 1)
			if(reagents.total_volume)
				reagents.set_source_mob(user)
				if(reagents.total_volume > bitesize)
					/*
					 * I totally cannot understand what this code supposed to do.
					 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
					var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
					reagents.trans_to(M, temp_bitesize)
					*/
					reagents.trans_to_ingest(M, bitesize)
				else
					reagents.trans_to_ingest(M, reagents.total_volume)
				bitecount++
				On_Consume(M)
			return TRUE

	return FALSE

/obj/item/reagent_container/food/snacks/afterattack(obj/target, mob/user, proximity)
	return ..()

/obj/item/reagent_container/food/snacks/get_examine_text(mob/user)
	. = ..()
	if (!(user in range(0)) && user != loc)
		return
	if (!bitecount)
		return
	else if (bitecount==1)
		. += SPAN_NOTICE("[src]被人咬过一口！")
	else if (bitecount<=3)
		. += SPAN_NOTICE("[src]被咬过[bitecount]口！")
	else
		. += SPAN_NOTICE("[src]被咬过好几口！")

/obj/item/reagent_container/food/snacks/set_origin_name_prefix(name_prefix)
	made_from_player = name_prefix

/obj/item/reagent_container/food/snacks/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()

	if(istype(W,/obj/item/tool/kitchen/utensil))

		var/obj/item/tool/kitchen/utensil/U = W

		if(!U.reagents)
			U.create_reagents(5)

		if (U.reagents.total_volume > 0)
			to_chat(user, SPAN_DANGER("你的[U]上已经有东西了。"))
			return

		user.visible_message( \
			"[user]用[U]舀起了一些[src]！", \
			SPAN_NOTICE("你用[U]舀起了一些[src]！") \
		)

		src.bitecount++
		U.overlays.Cut()
		U.loaded = "[src]"
		var/image/I = new(U.icon, "loadedfood")
		I.color = src.filling_color
		U.overlays += I

		reagents.trans_to(U,min(reagents.total_volume,5))

		if (reagents.total_volume <= 0)
			qdel(src)
		return

	if((slices_num <= 0 || !slices_num) || !slice_path)
		return 0

	var/inaccurate = 0
	if(W.sharp == IS_SHARP_ITEM_BIG)
		inaccurate = 1
	else if(W.sharp != IS_SHARP_ITEM_ACCURATE)
		return 1
	if ( !istype(loc, /obj/structure/surface/table) && \
			(!isturf(src.loc) || \
			!(locate(/obj/structure/surface/table) in src.loc) && \
			!(locate(/obj/structure/machinery/optable) in src.loc) && \
			!(locate(/obj/item/tool/kitchen/tray) in src.loc)) \
		)
		to_chat(user, SPAN_DANGER("你无法在这里切[src]！你需要一张桌子，至少也得有个托盘。"))
		return 1
	var/slices_lost = 0
	if (!inaccurate)
		user.visible_message( \
			SPAN_NOTICE("[user]切开了[src]！"), \
			SPAN_NOTICE("你切开了[src]！") \
		)
	else
		user.visible_message( \
			SPAN_NOTICE("[user]用[W]粗鲁地切开了[src]！"), \
			SPAN_NOTICE("你用[W]粗鲁地切开了[src]！") \
		)
		slices_lost = rand(1,max(1,floor(slices_num/2)))
	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i=1 to (slices_num-slices_lost))
		var/obj/slice = new slice_path (src.loc)
		reagents.trans_to(slice,reagents_per_slice)
	qdel(src)
	return

/obj/item/reagent_container/food/snacks/attack_animal(mob/M)
	if(isanimal(M))
		if(iscorgi(M))
			if(bitecount == 0 || prob(50))
				M.emote("nibbles away at [src]")
			bitecount++
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where [src] was")
				if(sattisfaction_text)
					M.emote("[sattisfaction_text]")
				qdel(src)
		if(ismouse(M))
			var/mob/living/simple_animal/mouse/N = M
			to_chat(N, text(SPAN_NOTICE("你一点点啃着[src]。")))
			if(prob(50))
				N.visible_message("[N]一点点啃着[src]。", "")
			//N.emote("nibbles away at the [src]")
			N.health = min(N.health + 1, N.maxHealth)


////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////

/*
* SNACKS
* Comment on what items in subcategory snacks need to behave:
* Items in the "Snacks" subcategory are food items that people actually eat.
* The key points are that they are created already filled with reagents and are destroyed when empty.
* Additionally, they make a "munching" noise when eaten.
*
* Notes by Darem:
* Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking.
* You don't want to go over 40 total for the item because you want to leave space for extra condiments.
* If you want effect besides healing, add a reagent for it.
* Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine).
* On use effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).
*
* Comment on how the old and new system compare?:
* The nutriment reagent and bitesize variable replace the old heal_amt and amount variables.
* Each unit of nutriment is equal to 2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed.
* So if you have 6 nutriment and a bitesize of 2, then it'll take 3 bites to eat.
* Unlike the old system, the contained reagents are evenly spread among all the bites. No more contained reagents = no more bites.
*
* Example on how to add a new snack item:
* here is an example of the new formatting for anyone who wants to add more food items.
* /obj/item/reagent_container/food/snacks/xenoburger ///Identification path for the object.
* name = "Xenoburger" ///Name that displays in the UI.
* desc = "Smells caustic. Tastes like heresy." ///Duh
* icon_state = "xburger" ///Refers to an icon in food.dmi
* /obj/item/reagent_container/food/snacks/xenoburger/Initialize() ///Don't mess with this.
* . = ..() ///Same here.
* reagents.add_reagent("xenomicrobes", 10) ///This is what is in the food item. you may copy/paste
* reagents.add_reagent("nutriment", 2) /// this line of code for all the contents.
* bitesize = 3 ///This is the amount each bite consumes.
*/

/obj/item/reagent_container/food/snacks/aesirsalad
	name = "阿萨神族沙拉"
	desc = "大概美妙得让凡人无法尽享其味。"
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"

/obj/item/reagent_container/food/snacks/aesirsalad/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 8)
	reagents.add_reagent("doctorsdelight", 8)
	reagents.add_reagent("tricordrazine", 8)
	bitesize = 3

/obj/item/reagent_container/food/snacks/candy
	name = "糖果"
	desc = "牛轧糖，爱也好，恨也罢。"
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/candy/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("sugar", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/candy/donor
	name = "献血者糖果"
	desc = "送给献血者的一点小甜头。"
	trash = /obj/item/trash/candy

/obj/item/reagent_container/food/snacks/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("sugar", 3)
	bitesize = 5

/obj/item/reagent_container/food/snacks/candy_corn
	name = "玉米糖"
	desc = "一把玉米糖。可惜不能塞进侦探的帽子里。"
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"

/obj/item/reagent_container/food/snacks/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/chips
	name = "薯片"
	desc = "赖克指挥官的“这什么薯片”。"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"

/obj/item/reagent_container/food/snacks/chips/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/wy_chips/pepper
	name = "维兰德-汤谷胡椒薯片"
	desc = "优质高档薯片，现含 0% 反式脂肪，并添加黑胡椒。"
	icon_state = "wy_chips_pepper"
	item_state = "wy_chips_pepper"
	trash = /obj/item/trash/wy_chips_pepper
	filling_color = "#E8C31E"

/obj/item/reagent_container/food/snacks/wy_chips/pepper/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/cookie
	name = "巧克力豆曲奇"
	desc = "一块美味酥脆的巧克力豆曲奇。别拿它喂鹦鹉。"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"

/obj/item/reagent_container/food/snacks/cookie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/chocolatebar
	name = "巧克力棒"
	desc = "如此甜蜜，又如此容易让人发胖。"
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"

/obj/item/reagent_container/food/snacks/chocolatebar/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/chocolateegg
	name = "巧克力蛋"
	desc = "如此甜蜜，又如此容易让人发胖。"
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"

/obj/item/reagent_container/food/snacks/chocolateegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/donut
	name = "甜甜圈"
	desc = "地球上常见的甜甜圈点心，与咖啡绝配。"
	icon_state = "donut1"
	filling_color = "#D9C386"
	var/overlay_state = "donut"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/donut/normal
	name = "甜甜圈"
	desc = "一个甜甜圈。在边疆很少见，珍惜它吧。"
	icon_state = "donut1"

/obj/item/reagent_container/food/snacks/donut/normal/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	src.bitesize = 3
	if(prob(40))
		icon_state = "donut2"
		overlay_state = "fdonut"
		name = "糖霜甜甜圈"
		desc = "裹着粉红糖霜的甜甜圈，在边疆更是罕见。"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/donut/chaos
	name = "混沌甜甜圈"
	desc = "就像生活，每次尝起来都不尽相同。"
	icon_state = "donut1"
	filling_color = "#ED11E6"

/obj/item/reagent_container/food/snacks/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sprinkles", 1)
	bitesize = 10
	var/chaosselect = pick(1,2,3,4,5,6,7,8,9)
	switch(chaosselect)
		if(1)
			reagents.add_reagent("nutriment", 3)
		if(2)
			reagents.add_reagent("hotsauce", 3)
		if(3)
			reagents.add_reagent("frostoil", 3)
		if(4)
			reagents.add_reagent("sprinkles", 3)
		if(5)
			reagents.add_reagent("phoron", 3)
		if(6)
			reagents.add_reagent("coco", 3)
		if(7)
			reagents.add_reagent("banana", 3)
		if(8)
			reagents.add_reagent("berryjuice", 3)
		if(9)
			reagents.add_reagent("tricordrazine", 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "糖霜混沌甜甜圈"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/donut/jelly
	name = "果酱甜甜圈"
	desc = "你眼馋了吗？"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/donut/jelly/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("berryjuice", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "糖霜果酱甜甜圈"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/donut/cherryjelly
	name = "果酱甜甜圈"
	desc = "你眼馋了吗？"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/donut/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("cherryjelly", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "糖霜果酱甜甜圈"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/egg
	name = "鸡蛋"
	desc = "一颗鸡蛋！"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	var/egg_color

/obj/item/reagent_container/food/snacks/egg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/egg/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(loc)
	if(reagents)
		reagents.reaction(hit_atom, TOUCH)
	visible_message(SPAN_WARNING("[name]被砸烂了。"),SPAN_WARNING("你听见啪的一声。"))
	qdel(src)

/obj/item/reagent_container/food/snacks/egg/blue
	icon_state = "egg-blue"
	egg_color = "blue"

/obj/item/reagent_container/food/snacks/egg/green
	icon_state = "egg-green"
	egg_color = "green"

/obj/item/reagent_container/food/snacks/egg/mime
	icon_state = "egg-mime"
	egg_color = "mime"

/obj/item/reagent_container/food/snacks/egg/orange
	icon_state = "egg-orange"
	egg_color = "orange"

/obj/item/reagent_container/food/snacks/egg/purple
	icon_state = "egg-purple"
	egg_color = "purple"

/obj/item/reagent_container/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"
	egg_color = "rainbow"

/obj/item/reagent_container/food/snacks/egg/red
	icon_state = "egg-red"
	egg_color = "red"

/obj/item/reagent_container/food/snacks/egg/yellow
	icon_state = "egg-yellow"
	egg_color = "yellow"

/obj/item/reagent_container/food/snacks/egg/random/Initialize()
	. = ..()
	var/newegg = pick(subtypesof(/obj/item/reagent_container/food/snacks/egg))
	new newegg(loc)
	qdel(src)

/obj/item/reagent_container/food/snacks/egg/dried
	name = "复水蛋"
	desc = "一颗蛋！至少上辈子是。现在只剩一摊可怜的糊状物，也许还能拿来做菜。"
	icon_state = "honeycomb"
	filling_color = "#FDFFD1"

/obj/item/reagent_container/food/snacks/egg/dried/Initialize()
	. = ..()
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/friedegg
	name = "煎蛋"
	desc = "一颗加了少许盐和胡椒的煎蛋。"
	icon_state = "friedegg"
	filling_color = "#FFDF78"

/obj/item/reagent_container/food/snacks/friedegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/boiledegg
	name = "水煮蛋"
	desc = "一颗煮熟的鸡蛋。"
	icon_state = "egg"
	filling_color = COLOR_WHITE

/obj/item/reagent_container/food/snacks/boiledegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)

/obj/item/reagent_container/food/snacks/flour
	name = "面粉"
	desc = "一小袋面粉。"
	icon_state = "flour"

/obj/item/reagent_container/food/snacks/flour/Initialize()
	. = ..()
	reagents.add_reagent("dough", 1)

/obj/item/reagent_container/food/snacks/organ

	name = "内脏"
	desc = "对你有好处。"
	icon = 'icons/obj/items/organs.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"

/obj/item/reagent_container/food/snacks/organ/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", rand(3,5))
	reagents.add_reagent("toxin", rand(1,3))
	src.bitesize = 3

/obj/item/reagent_container/food/snacks/tofu
	name = "豆腐"
	icon_state = "tofu"
	desc = "我们都爱豆腐。"
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofu/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 3)
	src.bitesize = 3

/obj/item/reagent_container/food/snacks/tofurkey
	name = "豆腐火鸡"
	desc = "用豆腐做成的仿制火鸡。"
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofurkey/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 12)
	reagents.add_reagent("stoxin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/stuffing
	name = "禽肉填馅"
	desc = "湿润又带胡椒味的面包屑，用来填进死禽的腹腔。开吃吧！"
	icon_state = "stuffing"
	filling_color = "#C9AC83"

/obj/item/reagent_container/food/snacks/stuffing/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("blackpepper",1)

/obj/item/reagent_container/food/snacks/carpmeat
	name = "鲤鱼片"
	desc = "一片太空鲤鱼肉。"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"

/obj/item/reagent_container/food/snacks/carpmeat/Initialize()
	. = ..()
	reagents.add_reagent("fish", 3)
	reagents.add_reagent("carpotoxin", 6)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/carpmeat/processed
	name = "处理过的鲤鱼片"
	desc = "一片太空鲤鱼肉，已经处理并去除了鲤鱼毒素。"

/obj/item/reagent_container/food/snacks/carpmeat/processed/Initialize()
	. = ..()
	reagents.remove_reagent("carpotoxin", 6)

/obj/item/reagent_container/food/snacks/fishfingers
	name = "炸鱼条"
	desc = "手指状的鱼肉条。"
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"

/obj/item/reagent_container/food/snacks/fishfingers/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	bitesize = 3

/obj/item/reagent_container/food/snacks/hugemushroomslice
	name = "巨型蘑菇片"
	desc = "从一朵巨型蘑菇上切下的一片。"
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"

/obj/item/reagent_container/food/snacks/hugemushroomslice/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("psilocybin", 3)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/tomatomeat
	name = "番茄片"
	desc = "从一个巨型番茄上切下的一片。"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/tomatomeat/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 3)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/bearmeat
	name = "熊肉"
	desc = "一大块充满男子气概的肉。"
	icon_state = "bearmeat"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 12)
	src.bitesize = 3

/obj/item/reagent_container/food/snacks/meatball
	name = "肉丸"
	desc = "一顿圆满的好饭。"
	icon_state = "meatball"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/sausage
	name = "香肠"
	desc = "一条混合肉馅制成的长肉。"
	icon_state = "sausage"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/brainburger
	name = "脑花汉堡"
	desc = "一个模样奇怪的汉堡，看起来几乎有了意识。"
	icon_state = "brainburger"
	filling_color = "#F2B6EA"

/obj/item/reagent_container/food/snacks/brainburger/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("alkysine", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/ghostburger
	name = "幽灵汉堡"
	desc = "阴森森的！看起来不怎么顶饱。"
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"

/obj/item/reagent_container/food/snacks/ghostburger/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/human
	filling_color = "#D63C3C"

/obj/item/reagent_container/food/snacks/human/burger
	name = "鲍勃汉堡"
	desc = "一个血淋淋的汉堡。"
	icon_state = "hamburger"

/obj/item/reagent_container/food/snacks/human/burger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheeseburger
	name = "奶酪汉堡"
	desc = "奶酪增添了美妙的风味。"
	icon_state = "hamburger"

/obj/item/reagent_container/food/snacks/cheeseburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("cheese", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/monkeyburger
	name = "汉堡"
	desc = "每一顿营养早餐的基石。"
	icon_state = "hburger"
	filling_color = "#D63C3C"

/obj/item/reagent_container/food/snacks/monkeyburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fishburger
	name = "麦鲤鱼三明治"
	desc = "仿佛有条鲤鱼正在某处大喊……把那份麦鲤鱼还给我，把那条鲤鱼给我。"
	icon_state = "fishburger"
	filling_color = "#FFDEFE"

/obj/item/reagent_container/food/snacks/fishburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("fish", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/tofuburger
	name = "豆腐汉堡"
	desc = "什么……那是肉吗？"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofuburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("tofu", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/roburger
	name = "机械汉堡"
	desc = "生菜是其中唯一的有机成分。哔。"
	icon_state = "roburger"
	filling_color = "#CCCCCC"

/obj/item/reagent_container/food/snacks/roburger/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("iron", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/roburgerbig
	name = "机械汉堡"
	desc = "这块硕大的肉饼看起来有毒。哔。"
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100

/obj/item/reagent_container/food/snacks/roburgerbig/Initialize()
	. = ..()
	bitesize = 0.1

/obj/item/reagent_container/food/snacks/xenoburger
	name = "异形汉堡"
	desc = "闻起来有腐蚀性，吃起来像异端。"
	icon_state = "xburger"
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/xenoburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/clownburger
	name = "小丑汉堡"
	desc = "这味道有点滑稽……"
	icon_state = "clownburger"
	filling_color = COLOR_MAGENTA

/obj/item/reagent_container/food/snacks/clownburger/Initialize()
	. = ..()
/*
	var/datum/disease/F = new /datum/disease/pierrot_throat(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 4, data)
*/
	reagents.add_reagent("bread", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/mimeburger
	name = "默剧演员汉堡"
	desc = "它的味道无法用语言形容。"
	icon_state = "mimeburger"
	filling_color = COLOR_WHITE

/obj/item/reagent_container/food/snacks/mimeburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/omelette
	name = "奶酪蛋卷"
	desc = "你就只会说这一句！"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"

	//var/herp = 0
/obj/item/reagent_container/food/snacks/omelette/Initialize()
	. = ..()
	reagents.add_reagent("egg", 4)
	reagents.add_reagent("cheese", 4)

/obj/item/reagent_container/food/snacks/muffin
	name = "玛芬蛋糕"
	desc = "一块小玛芬，松软湿润，美味可口。"
	icon_state = "muffin"
	filling_color = "#E0CF9B"

/obj/item/reagent_container/food/snacks/muffin/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/pie
	name = "香蕉奶油派"
	desc = "就像小丑星球老家做的一样！嘟嘟！"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"

/obj/item/reagent_container/food/snacks/pie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("banana",5)
	bitesize = 3

/obj/item/reagent_container/food/snacks/pie/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message(SPAN_DANGER("[src.name]啪地砸烂了。"),SPAN_DANGER("你听见噗的一声。"))
	qdel(src)

/obj/item/reagent_container/food/snacks/berryclafoutis
	name = "浆果克拉芙缇"
	desc = "没有黑鸟，这是个好兆头。"
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate

/obj/item/reagent_container/food/snacks/berryclafoutis/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("berryjuice", 5)
	bitesize = 3

/obj/item/reagent_container/food/snacks/waffles
	name = "华夫饼"
	desc = "嗯，华夫饼。"
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#E6DEB5"

/obj/item/reagent_container/food/snacks/waffles/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("sugar", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/pancakes
	name = "松饼"
	desc = "刚出锅的金棕色奶香松饼，淋着枫糖浆，上面还放着一片黄油。"
	icon_state = "pancakes"
	filling_color = "#bb9857"
	bitesize = 2

/obj/item/reagent_container/food/snacks/pancakes/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("sugar", 4)
	reagents.add_reagent("milk", 5)

/obj/item/reagent_container/food/snacks/eggplantparm
	name = "奶酪焗茄子"
	desc = "茄子唯一好吃的做法。"
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"

/obj/item/reagent_container/food/snacks/eggplantparm/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("cheese", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/soylentgreen
	name = "绿色代餐"
	desc = "不是用人做的。真的。" //Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#B8E6B5"

/obj/item/reagent_container/food/snacks/soylentgreen/Initialize()
	. = ..()
	reagents.add_reagent("bread", 7)
	reagents.add_reagent("meatprotein", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/soylentviridians
	name = "翠绿代餐"
	desc = "不是用人做的。真的。" //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#E6FA61"

/obj/item/reagent_container/food/snacks/soylentviridians/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatpie
	name = "肉派"
	icon_state = "meatpie"
	desc = "理发师的老配方，美味极了！"
	trash = /obj/item/trash/plate
	filling_color = "#948051"

/obj/item/reagent_container/food/snacks/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tofupie
	name = "豆腐派"
	icon_state = "meatpie"
	desc = "一份美味的豆腐派。"
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofupie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("tofu", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/amanita_pie
	name = "毒蝇伞派"
	desc = "又甜又好吃的毒派。"
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"

/obj/item/reagent_container/food/snacks/amanita_pie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("amatoxin", 3)
	reagents.add_reagent("psilocybin", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/plump_pie
	name = "肥菇派"
	desc = "我敢说你一定喜欢肥菇做的东西！"
	icon_state = "plump_pie"
	filling_color = "#B8279B"

/obj/item/reagent_container/food/snacks/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "极品肥菇派"
		desc = "微波炉陷入了灵感狂潮！它烤出了一份极品肥菇派！"
		reagents.add_reagent("bread", 4)
		reagents.add_reagent("mushroom", 4)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 2
	else
		reagents.add_reagent("mushroom", 4)
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_container/food/snacks/xemeatpie
	name = "异形肉派"
	icon_state = "xenomeatpie"
	desc = "一份美味的肉派，可能有点异端。"
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/xemeatpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("meatprotein", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/wingfangchu
	name = "酱烧异形鞭"
	desc = "用酱油烹制的咸香异形鞭。"
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/wingfangchu/Initialize()
	. = ..()
	reagents.add_reagent("soysauce", 4)
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/human/kabob
	name = "人肉串"
	icon_state = "kabob"
	desc = "串在签子上的人肉。"
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

/obj/item/reagent_container/food/snacks/human/kabob/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/monkeykabob
	name = "肉串"
	icon_state = "kabob"
	desc = "串在签子上的美味肉块。"
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

/obj/item/reagent_container/food/snacks/monkeykabob/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tofukabob
	name = "豆腐串"
	icon_state = "kabob"
	desc = "串在签子上的纯素肉。"
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofukabob/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cubancarp
	name = "古巴鲤鱼三明治"
	desc = "一份恶作剧般的三明治，先辣得你舌头着火，再让它彻底麻木！"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"

/obj/item/reagent_container/food/snacks/cubancarp/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	reagents.add_reagent("hotsauce", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/popcorn
	name = "爆米花"
	desc = "影院风味的黄油爆米花。现在该找部电影，边看边吃了。"
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"

/obj/item/reagent_container/food/snacks/popcorn/Initialize()
	. = ..()
	unpopped = rand(1,10)
	reagents.add_reagent("plantmatter", 2)
	bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0

/obj/item/reagent_container/food/snacks/popcorn/On_Consume()
	if(prob(unpopped)) //lol ...what's the point?
		to_chat(usr, SPAN_DANGER("你咬到了一粒没爆开的玉米！"))
		unpopped = max(0, unpopped-1)
	..()

/obj/item/reagent_container/food/snacks/sosjerky
	name = "胆小鬼私藏牛肉干"
	icon_state = "sosjerky"
	desc = "用上等太空牛肉制成的牛肉干。"
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"

/obj/item/reagent_container/food/snacks/sosjerky/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/no_raisin
	name = "4no 葡萄干"
	icon_state = "4no_raisins"
	desc = "全宇宙最好的葡萄干，至于为什么就不知道了。"
	trash = /obj/item/trash/raisins
	filling_color = "#343834"

/obj/item/reagent_container/food/snacks/no_raisin/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 4)
	reagents.add_reagent("grapejuice", 2)

/obj/item/reagent_container/food/snacks/spacetwinkie
	name = "太空夹心蛋糕"
	icon_state = "space_twinkie"
	desc = "保证比你活得久。"
	filling_color = "#FFE591"

/obj/item/reagent_container/food/snacks/spacetwinkie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesiehonkers
	name = "芝士小丑脆"
	icon_state = "cheesie_honkers"
	desc = "一口一个的芝士零食，让你嘴里到处响起嘟嘟声。"
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"

/obj/item/reagent_container/food/snacks/cheesiehonkers/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/syndicake
	name = "辛迪蛋糕"
	icon_state = "syndi_cakes"
	desc = "一款极其湿润的小蛋糕，哪怕挨过核爆，味道依然不变。"
	filling_color = "#FF5D05"
	trash = /obj/item/trash/syndi_cakes

/obj/item/reagent_container/food/snacks/syndicake/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("doctorsdelight", 5)
	bitesize = 3

/obj/item/reagent_container/food/snacks/loadedbakedpotato
	name = "加料烤土豆"
	desc = "烤得透透的。"
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"

/obj/item/reagent_container/food/snacks/loadedbakedpotato/Initialize()
	. = ..()
	reagents.add_reagent("potato", 2)
	reagents.add_reagent("cheese", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fries
	name = "太空薯条"
	desc = "又名法式薯条、自由薯条，诸如此类。"
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

/obj/item/reagent_container/food/snacks/fries/Initialize()
	. = ..()
	reagents.add_reagent("potato", 2)
	reagents.add_reagent("vegetable", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/soydope
	name = "豆泥"
	desc = "大豆做成的糊糊。"
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"

/obj/item/reagent_container/food/snacks/soydope/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/spagetti
	name = "意大利面"
	desc = "一束生意大利面。"
	icon_state = "spagetti"
	filling_color = "#EDDD00"

/obj/item/reagent_container/food/snacks/spagetti/Initialize()
	. = ..()
	reagents.add_reagent("dough", 1)

/obj/item/reagent_container/food/snacks/cheesyfries
	name = "奶酪薯条"
	desc = "薯条，上面盖着奶酪。这还用说？"
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

/obj/item/reagent_container/food/snacks/cheesyfries/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("potato", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/badrecipe
	name = "焦黑的一团"
	desc = "做出这东西的人该被撤掉厨师职务。"
	icon_state = "badrecipe"
	filling_color = "#211F02"

/obj/item/reagent_container/food/snacks/badrecipe/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 1)
	reagents.add_reagent("carbon", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatsteak
	name = "肉排"
	desc = "一块用盐和胡椒调味的上好烤肉排。至于肉从哪来……嗯，最好别问。"
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"

/obj/item/reagent_container/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/spacylibertyduff
	name = "迷幻自由布丁"
	desc = "出自阿尔弗雷德·哈伯德食谱的果冻布丁。"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"

/obj/item/reagent_container/food/snacks/spacylibertyduff/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 6)
	reagents.add_reagent("psilocybin", 6)
	bitesize = 3

/obj/item/reagent_container/food/snacks/amanitajelly
	name = "毒蝇伞冻"
	desc = "看起来莫名有毒。"
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"

/obj/item/reagent_container/food/snacks/amanitajelly/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 6)
	reagents.add_reagent("amatoxin", 6)
	reagents.add_reagent("psilocybin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/poppypretzel
	name = "罂粟籽椒盐卷饼"
	desc = "全都扭在一起了！"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"

/obj/item/reagent_container/food/snacks/poppypretzel/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("bread", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatballsoup
	name = "肉丸汤"
	desc = "小子，你真有种，真有种！"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"

/obj/item/reagent_container/food/snacks/meatballsoup/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 8)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/bloodsoup
	name = "番茄汤"
	desc = "闻起来有铜腥味。"
	icon_state = "tomatosoup"
	filling_color = COLOR_RED

/obj/item/reagent_container/food/snacks/bloodsoup/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("blood", 10)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/clownstears
	name = "小丑之泪"
	desc = "一点也不好笑。"
	icon_state = "clownstears"
	filling_color = "#C4FBFF"

/obj/item/reagent_container/food/snacks/clownstears/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("water", 10)
	bitesize = 5

/obj/item/reagent_container/food/snacks/vegetablesoup
	name = "蔬菜汤"
	desc = "一顿真正的纯素餐。" //TODO
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

/obj/item/reagent_container/food/snacks/vegetablesoup/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 8)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/nettlesoup
	name = "荨麻汤"
	desc = "想想看，植物学家本来可能拿这种东西把你抽死。"
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

/obj/item/reagent_container/food/snacks/nettlesoup/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 8)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("tricordrazine", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/mysterysoup
	name = "神秘汤"
	desc = "神秘之处在于：你怎么还不吃？"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F082FF"

/obj/item/reagent_container/food/snacks/mysterysoup/Initialize()
	. = ..()
	var/mysteryselect = pick(1,2,3,4,5,6,7,8,9)
	switch(mysteryselect)
		if(1)
			reagents.add_reagent("plantmatter", 6)
			reagents.add_reagent("hotsauce", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(2)
			reagents.add_reagent("plantmatter", 6)
			reagents.add_reagent("frostoil", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(3)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 5)
			reagents.add_reagent("tricordrazine", 5)
		if(4)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 10)
		if(5)
			reagents.add_reagent("fruit", 2)
			reagents.add_reagent("banana", 10)
		if(6)
			reagents.add_reagent("meatprotein", 6)
			reagents.add_reagent("blood", 10)
		if(7)
			reagents.add_reagent("carbon", 10)
			reagents.add_reagent("toxin", 10)
		if(8)
			reagents.add_reagent("vegetable", 5)
			reagents.add_reagent("tomatojuice", 10)
		if(9)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("tomatojuice", 5)
			reagents.add_reagent("imidazoline", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/wishsoup
	name = "许愿汤"
	desc = "但愿这真是一碗汤。"
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"

/obj/item/reagent_container/food/snacks/wishsoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)
	bitesize = 5
	if(prob(25))
		src.desc = "愿望成真！"
		reagents.add_reagent("nutriment", 8)

/obj/item/reagent_container/food/snacks/hotchili
	name = "热辣炖肉"
	desc = "一碗辣得能拉响五级警报的得克萨斯辣炖肉！"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"

/obj/item/reagent_container/food/snacks/hotchili/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("hotsauce", 3)
	reagents.add_reagent("tomatojuice", 2)
	bitesize = 5

/obj/item/reagent_container/food/snacks/coldchili
	name = "冰辣炖肉"
	desc = "这冰碴子几乎都算不上液体了！"
	icon_state = "coldchili"
	filling_color = "#2B00FF"

	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_container/food/snacks/coldchili/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("frostoil", 3)
	reagents.add_reagent("tomatojuice", 2)
	bitesize = 5

/* No more of this
/obj/item/reagent_container/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/device/radio/beacon/bacon/baconbeacon
	bitesize = 2
	/Initialize()
		..()
		reagents.add_reagent("nutriment", 4)
		baconbeacon = new /obj/item/device/radio/beacon/bacon(src)
	On_Consume()
		if(!reagents.total_volume)
			baconbeacon.forceMove(usr)
			baconbeacon.digest_delay()
*/

/obj/item/reagent_container/food/snacks/monkeycube
	name = "猴子方块"
	desc = "只需加水！"
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"
	black_market_value = 25
	var/monkey_type = /mob/living/carbon/human/monkey

/obj/item/reagent_container/food/snacks/monkeycube/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein",10)

/obj/item/reagent_container/food/snacks/monkeycube/afterattack(obj/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O,/obj/structure/sink) && !package)
		to_chat(user, "你把[name]放到了水流下……")
		user.drop_held_item()
		return Expand()
	..()

/obj/item/reagent_container/food/snacks/monkeycube/attack_self(mob/user)
	..()

	if(package)
		icon_state = "monkeycube"
		desc = "只需加水！"
		to_chat(user, "你拆开了方块的包装。")
		package = 0

/obj/item/reagent_container/food/snacks/monkeycube/On_Consume(mob/M)
	to_chat(M, SPAN_WARNING("你体内有什么东西突然膨胀了！"))

	if (istype(M, /mob/living/carbon/human))
		//Do not try to understand.
		var/obj/item/surprise = new(M)
		var/mob/ook = monkey_type
		surprise.icon = initial(ook.icon)
		surprise.icon_state = initial(ook.icon_state)
		surprise.name = "畸形的[initial(ook.name)]"
		surprise.desc = "看起来像一只严重畸形的[initial(ook.name)]，比同类略小，没有任何生命迹象。"
		surprise.transform *= 0.6
		surprise.add_mob_blood(M)
		var/mob/living/carbon/human/H = M
		var/obj/limb/E = H.get_limb("chest")
		E.fracture(100)
		H.recalculate_move_delay = TRUE
		for (var/datum/internal_organ/I in E.internal_organs)
			I.take_damage(rand(I.min_bruised_damage, I.min_broken_damage+1))
		if (!E.hidden && prob(60)) //set it snuggly
			E.hidden = surprise
		else //someone is having a bad day
			E.createwound(CUT, 30)
			E.embed(surprise)
	..()

/obj/item/reagent_container/food/snacks/monkeycube/proc/Expand()
	for(var/mob/M as anything in viewers(src,7))
		to_chat(M, SPAN_WARNING("[src]膨胀了！"))
	var/turf/T = get_turf(src)
	if(T)
		new monkey_type(T)
	qdel(src)

/obj/item/reagent_container/food/snacks/monkeycube/extinguish()
	. = ..()
	if(!package)
		Expand()

/obj/item/reagent_container/food/snacks/monkeycube/wrapped
	desc = "外面还裹着一层纸。"
	icon_state = "monkeycubewrap"
	package = 1

/obj/item/reagent_container/food/snacks/monkeycube/farwacube
	name = "法尔瓦方块"
	monkey_type = /mob/living/carbon/human/farwa
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/farwacube
	name = "法尔瓦方块"
	monkey_type =/mob/living/carbon/human/farwa

/obj/item/reagent_container/food/snacks/monkeycube/stokcube
	name = "斯托克方块"
	monkey_type = /mob/living/carbon/human/stok
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/stokcube
	name = "斯托克方块"
	monkey_type =/mob/living/carbon/human/stok

/obj/item/reagent_container/food/snacks/monkeycube/neaeracube
	name = "尼艾拉方块"
	monkey_type = /mob/living/carbon/human/neaera
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/neaeracube
	name = "尼艾拉方块"
	monkey_type =/mob/living/carbon/human/neaera

/obj/item/reagent_container/food/snacks/monkeycube/yirencube
	name = "野人方块"
	monkey_type = /mob/living/carbon/human/yiren
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/yirencube
	name = "野人方块"
	monkey_type =/mob/living/carbon/human/yiren

/obj/item/reagent_container/food/snacks/spellburger
	name = "咒语汉堡"
	desc = "这绝对是“伊·纳斯”。"
	icon_state = "spellburger"
	filling_color = "#D505FF"

/obj/item/reagent_container/food/snacks/spellburger/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/bigbiteburger
	name = "大口汉堡"
	desc = "忘掉巨无霸吧，这才是未来！"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"

/obj/item/reagent_container/food/snacks/bigbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 7)
	reagents.add_reagent("bread", 7)
	bitesize = 3

/obj/item/reagent_container/food/snacks/enchiladas
	name = "墨西哥辣酱烤卷饼"
	desc = "墨西哥万岁！"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"

/obj/item/reagent_container/food/snacks/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent("vegetable",2)
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("hotsauce", 6)
	bitesize = 4

/obj/item/reagent_container/food/snacks/monkeysdelight
	name = "猴子之乐"
	desc = "吱吱！"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"

/obj/item/reagent_container/food/snacks/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	bitesize = 6

/obj/item/reagent_container/food/snacks/baguette
	name = "法棍"
	desc = "祝你好胃口！"
	icon_state = "baguette"
	filling_color = "#E3D796"

/obj/item/reagent_container/food/snacks/baguette/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/fishandchips
	name = "炸鱼薯条"
	desc = "老兄，依我看，确实不错。"
	icon_state = "fishandchips"
	filling_color = "#E3D796"

/obj/item/reagent_container/food/snacks/fishandchips/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	bitesize = 3

/obj/item/reagent_container/food/snacks/sandwich
	name = "三明治"
	desc = "用肉、奶酪、面包和几片生菜造就的杰作！阿瑟·邓特会为此感到骄傲。"
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

/obj/item/reagent_container/food/snacks/sandwich/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cheese", 2)
	reagents.add_reagent("meatprotein", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/toastedsandwich
	name = "烤三明治"
	desc = "要是再有一根胡椒棒就好了。"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

/obj/item/reagent_container/food/snacks/toastedsandwich/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("carbon", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/grilledcheese
	name = "烤奶酪三明治"
	desc = "和番茄汤是绝配！"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

/obj/item/reagent_container/food/snacks/grilledcheese/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("cheese", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tomatosoup
	name = "番茄汤"
	desc = "喝起来感觉像当了吸血鬼！番茄吸血鬼……"
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"

/obj/item/reagent_container/food/snacks/tomatosoup/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/rofflewaffles
	name = "罗弗尔华夫饼"
	desc = "罗弗尔公司出品的华夫饼。"
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#FF00F7"

/obj/item/reagent_container/food/snacks/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("psilocybin", 8)
	bitesize = 4

/obj/item/reagent_container/food/snacks/stew
	name = "炖菜"
	desc = "一份暖乎乎的美味炖菜，健康又滋补。"
	icon_state = "stew"
	filling_color = "#9E673A"

/obj/item/reagent_container/food/snacks/stew/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("meatprotein", 3)
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)
	bitesize = 10

/obj/item/reagent_container/food/snacks/jelliedtoast
	name = "果酱吐司"
	desc = "一片涂满美味果酱的面包。"
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"

/obj/item/reagent_container/food/snacks/jelliedtoast/Initialize()
	. = ..()
	reagents.add_reagent("bread", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/jelliedtoast/cherry

/obj/item/reagent_container/food/snacks/jelliedtoast/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_container/food/snacks/jellyburger
	name = "果酱汉堡"
	desc = "烹饪珍馐……？"
	icon_state = "jellyburger"
	filling_color = "#B572AB"

/obj/item/reagent_container/food/snacks/jellyburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	bitesize = 2

/obj/item/reagent_container/food/snacks/jellyburger/cherry

/obj/item/reagent_container/food/snacks/jellyburger/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_container/food/snacks/milosoup
	name = "米洛汤"
	desc = "全宇宙最棒的汤！好喝！！！"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_container/food/snacks/milosoup/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 8)
	reagents.add_reagent("water", 5)
	bitesize = 4

/obj/item/reagent_container/food/snacks/stewedsoymeat
	name = "炖素肉"
	desc = "就连不吃素的人也会爱上它！"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate

/obj/item/reagent_container/food/snacks/stewedsoymeat/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/boiledspagetti
	name = "水煮意大利面"
	desc = "一盘清汤寡水的面条，真没劲。"
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"

/obj/item/reagent_container/food/snacks/boiledspagetti/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/boiledrice
	name = "白米饭"
	desc = "一碗无聊至极的白米饭。"
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

/obj/item/reagent_container/food/snacks/boiledrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/ricepudding
	name = "米布丁"
	desc = "果酱呢！"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

/obj/item/reagent_container/food/snacks/ricepudding/Initialize()
	. = ..()
	reagents.add_reagent("rice", 3)
	reagents.add_reagent("milk", 1)
	bitesize = 2

/obj/item/reagent_container/food/snacks/pastatomato
	name = "意大利面"
	desc = "意大利面加碎番茄。和你那爱打人的老爸以前做的一模一样！"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

/obj/item/reagent_container/food/snacks/pastatomato/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 4

/obj/item/reagent_container/food/snacks/meatballspagetti
	name = "肉丸意大利面"
	desc = "这才叫好肉丸！"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

/obj/item/reagent_container/food/snacks/meatballspagetti/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 4)
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/spesslaw
	name = "太空法意面"
	desc = "律师的最爱。"
	icon_state = "spesslaw"
	filling_color = "#DE4545"

/obj/item/reagent_container/food/snacks/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("meatprotein", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/carrotfries
	name = "炸胡萝卜条"
	desc = "用新鲜胡萝卜做成的美味炸条。"
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"

/obj/item/reagent_container/food/snacks/carrotfries/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("imidazoline", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/superbiteburger
	name = "超级大口汉堡"
	desc = "这个汉堡堆得像座山。吃的！"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"

/obj/item/reagent_container/food/snacks/superbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 20)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("egg", 5)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 3)
	reagents.add_reagent("cheese", 10)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 10

/obj/item/reagent_container/food/snacks/candiedapple
	name = "糖衣苹果"
	desc = "裹满甜甜糖衣的苹果。"
	icon_state = "candiedapple"
	filling_color = "#F21873"

/obj/item/reagent_container/food/snacks/candiedapple/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/applepie
	name = "苹果派"
	desc = "一份装满甜蜜爱意……或者苹果的派。"
	icon_state = "applepie"
	filling_color = "#E0EDC5"

/obj/item/reagent_container/food/snacks/applepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)
	bitesize = 3


/obj/item/reagent_container/food/snacks/cherrypie
	name = "樱桃派"
	desc = "好吃得让大男人都能哭出来。"
	icon_state = "cherrypie"
	filling_color = "#FF525A"

/obj/item/reagent_container/food/snacks/cherrypie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("cherryjelly", 3)
	reagents.add_reagent("sugar", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/twobread
	name = "双层面包"
	desc = "味道很苦，还带着酒味。"
	icon_state = "twobread"
	filling_color = "#DBCC9A"

/obj/item/reagent_container/food/snacks/twobread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("wine", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/jellysandwich
	name = "果酱三明治"
	desc = "你真希望能有点花生酱来配它……"
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"

/obj/item/reagent_container/food/snacks/jellysandwich/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	bitesize = 3

/obj/item/reagent_container/food/snacks/jellysandwich/cherry

/obj/item/reagent_container/food/snacks/jellysandwich/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_container/food/snacks/mint
	name = "薄荷"
	desc = "只有薄薄的一片。"
	icon_state = "mint"
	filling_color = "#F2F2F2"

/obj/item/reagent_container/food/snacks/mint/Initialize()
	. = ..()
	reagents.add_reagent("minttoxin", 1)

/obj/item/reagent_container/food/snacks/mushroomsoup
	name = "鸡油菌汤"
	desc = "一碗美味浓郁的蘑菇汤。"
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"

/obj/item/reagent_container/food/snacks/mushroomsoup/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 6)
	reagents.add_reagent("milk", 2)
	bitesize = 3

/obj/item/reagent_container/food/snacks/plumphelmetbiscuit
	name = "肥菇饼干"
	desc = "一块精心制作的肥菇饼干，用料包括切得极细的肥菇和磨得很细的矮人小麦粉。"
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"

/obj/item/reagent_container/food/snacks/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "极品肥菇饼干"
		desc = "微波炉陷入了灵感狂潮！它烤出了一块极品肥菇饼干！"
		reagents.add_reagent("bread", 4)
		reagents.add_reagent("mushroom", 4)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 2
	else
		reagents.add_reagent("bread", 3)
		reagents.add_reagent("mushroom", 2)
		bitesize = 2

/obj/item/reagent_container/food/snacks/chawanmushi
	name = "茶碗蒸"
	desc = "传说能让仇敌化干戈为玉帛的蒸蛋，大概烫得猫都下不了嘴。"
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"

/obj/item/reagent_container/food/snacks/chawanmushi/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("mushroom", 2)
	reagents.add_reagent("soysauce", 1)

/obj/item/reagent_container/food/snacks/beetsoup
	name = "甜菜汤"
	desc = "等等，这名字到底怎么拼来着……？"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FAC9FF"

/obj/item/reagent_container/food/snacks/beetsoup/Initialize()
	. = ..()
	switch(rand(1,6))
		if(1)
			name = "罗宋汤（borsch）"
		if(2)
			name = "罗宋汤（bortsch）"
		if(3)
			name = "罗宋汤（borstch）"
		if(4)
			name = "罗宋汤（borsh）"
		if(5)
			name = "罗宋汤（borshch）"
		if(6)
			name = "罗宋汤（borscht）"
	reagents.add_reagent("vegetable", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tossedsalad
	name = "什锦拌沙拉"
	desc = "一份正经的沙拉，简单朴素，混有小块胡萝卜、番茄和苹果。纯素的！"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

/obj/item/reagent_container/food/snacks/tossedsalad/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 4)
	reagents.add_reagent("vegetable", 4)
	bitesize = 3

/obj/item/reagent_container/food/snacks/validsalad
	name = "正当沙拉"
	desc = "不过是一份用可疑“香草”、肉丸和炸土豆片做成的沙拉，没什么可疑的。"
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

/obj/item/reagent_container/food/snacks/validsalad/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 4)
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("potato", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/appletart
	name = "金苹果酥粒挞"
	desc = "一份过不了金属探测器的美味甜点。"
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = COLOR_YELLOW

/obj/item/reagent_container/food/snacks/appletart/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 8)
	reagents.add_reagent("gold", 5)
	bitesize = 3

/*
*Sliceable
* All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels
* sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.
* Make it that every big items are cut down into six smaller slice as a standart.
*/

/obj/item/reagent_container/food/snacks/sliceable
	slices_num = 6

/obj/item/reagent_container/food/snacks/sliceable/meatbread
	name = "整条肉馅面包"
	desc = "每一位自重又能言善辩的/tg/绅士的餐桌基石。"
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_container/food/snacks/meatbreadslice
	filling_color = "#FF7575"

/obj/item/reagent_container/food/snacks/sliceable/meatbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatbreadslice
	name = "肉馅面包片"
	desc = "一片美味的肉馅面包。"
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/xenomeatbread
	name = "整条异形肉面包"
	desc = "每一位自重又能言善辩的绅士的餐桌基石，格外异端。"
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_container/food/snacks/xenomeatbreadslice
	filling_color = "#8AFF75"

/obj/item/reagent_container/food/snacks/sliceable/xenomeatbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/xenomeatbreadslice
	name = "异形肉面包片"
	desc = "一片美味的肉馅面包，格外异端。"
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/bananabread
	name = "香蕉坚果面包"
	desc = "美妙又顶饱的点心。"
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_container/food/snacks/bananabreadslice
	filling_color = "#EDE5AD"

/obj/item/reagent_container/food/snacks/sliceable/bananabread/Initialize()
	. = ..()
	reagents.add_reagent("banana", 15)
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("sugar", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/bananabreadslice
	name = "香蕉坚果面包片"
	desc = "一片美味的香蕉面包。"
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/tofubread
	name = "豆腐面包"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_container/food/snacks/tofubreadslice
	filling_color = "#F7FFE0"

/obj/item/reagent_container/food/snacks/sliceable/tofubread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("tofu", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tofubreadslice
	name = "豆腐面包片"
	desc = "一片美味的豆腐面包。"
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/carrotcake
	name = "胡萝卜蛋糕"
	desc = "某只捣蛋兔子最爱的甜点。这可不是谎言。"
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_container/food/snacks/carrotcakeslice
	filling_color = "#FFD675"

/obj/item/reagent_container/food/snacks/sliceable/carrotcake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("sugar", 5)
	reagents.add_reagent("imidazoline", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/carrotcakeslice
	name = "胡萝卜蛋糕切片"
	desc = "满是胡萝卜风味的蛋糕切片，胡萝卜对眼睛有好处！这也不是谎言。"
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/braincake
	name = "脑花蛋糕"
	desc = "一团软乎乎、像蛋糕的东西。"
	icon_state = "braincake"
	slice_path = /obj/item/reagent_container/food/snacks/braincakeslice
	filling_color = "#E6AEDB"

/obj/item/reagent_container/food/snacks/sliceable/braincake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("alkysine", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/braincakeslice
	name = "脑花蛋糕切片"
	desc = "让我告诉你关于朊病毒的一件事：它们可好吃了。"
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesecake
	name = "奶酪蛋糕"
	desc = "奶酪浓得危险。"
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_container/food/snacks/cheesecakeslice
	filling_color = "#FAF7AF"
	black_market_value = 30

/obj/item/reagent_container/food/snacks/sliceable/cheesecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 15)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesecakeslice
	name = "奶酪蛋糕切片"
	desc = "一片让你“酪”在心里的纯粹满足。"
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2
	black_market_value = 20

/obj/item/reagent_container/food/snacks/sliceable/plaincake
	name = "香草蛋糕"
	desc = "一个普通蛋糕，这不是谎言。"
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_container/food/snacks/plaincakeslice
	filling_color = "#F7EDD5"

/obj/item/reagent_container/food/snacks/sliceable/plaincake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("sugar", 15)

/obj/item/reagent_container/food/snacks/plaincakeslice
	name = "香草蛋糕切片"
	desc = "不过一片蛋糕，够大家分的。"
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/orangecake
	name = "香橙蛋糕"
	desc = "加入了橙子的蛋糕。"
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_container/food/snacks/orangecakeslice
	filling_color = "#FADA8E"

/obj/item/reagent_container/food/snacks/sliceable/orangecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 5)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("orangejuice", 10)

/obj/item/reagent_container/food/snacks/orangecakeslice
	name = "香橙蛋糕切片"
	desc = "不过一片蛋糕，够大家分的。"
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/limecake
	name = "青柠蛋糕"
	desc = "加入了青柠的蛋糕。"
	icon_state = "limecake"
	slice_path = /obj/item/reagent_container/food/snacks/limecakeslice
	filling_color = "#CBFA8E"

/obj/item/reagent_container/food/snacks/sliceable/limecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 5)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("limejuice", 10)

/obj/item/reagent_container/food/snacks/limecakeslice
	name = "青柠蛋糕切片"
	desc = "不过一片蛋糕，够大家分的。"
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/lemoncake
	name = "柠檬蛋糕"
	desc = "加入了柠檬的蛋糕。"
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_container/food/snacks/lemoncakeslice
	filling_color = "#FAFA8E"

/obj/item/reagent_container/food/snacks/sliceable/lemoncake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 5)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("lemonjuice", 10)

/obj/item/reagent_container/food/snacks/lemoncakeslice
	name = "柠檬蛋糕切片"
	desc = "不过一片蛋糕，够大家分的。"
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/chocolatecake
	name = "巧克力蛋糕"
	desc = "加入了巧克力的蛋糕。"
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_container/food/snacks/chocolatecakeslice
	filling_color = "#805930"

/obj/item/reagent_container/food/snacks/sliceable/chocolatecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("sugar", 5)
	reagents.add_reagent("coco", 10)

/obj/item/reagent_container/food/snacks/chocolatecakeslice
	name = "巧克力蛋糕切片"
	desc = "不过一片蛋糕，够大家分的。"
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel
	name = "奶酪轮"
	desc = "一大轮美味的切达奶酪。"
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge
	filling_color = "#FFF700"
	black_market_value = 25 //mendoza likes cheese.

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 20)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge
	name = "楔形奶酪块"
	desc = "一块美味的楔形切达奶酪。切下它的那轮奶酪应该就在附近。"
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2
	black_market_value = 10

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/immature
	name = "未熟成奶酪轮"
	desc = "一大轮据说很美味的切达奶酪，可惜熟成时间不足，因此味道相当糟糕。"
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/immature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/immature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 15)
	reagents.add_reagent("milk", 5)
	bitesize = 4

/obj/item/reagent_container/food/snacks/cheesewedge/immature
	name = "未熟成楔形奶酪块"
	desc = "一块尚未熟成的切达奶酪，尝不出什么好味道。切下它的那轮奶酪应该就在附近。风味淡得你基本可以一口全吞。"
	bitesize = 4

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/mature
	name = "熟成奶酪轮"
	desc = "一大轮美味的切达奶酪，已经充分熟成。"
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/mature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/mature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 20)
	reagents.add_reagent("sodiumchloride", 5)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge/mature
	name = "熟成楔形奶酪块"
	desc = "一块熟成切达奶酪，味道相当不错。切下它的那轮奶酪应该就在附近。"
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge/mature/kraft
	name = "包装奶酪制品片"
	desc = "一片在法律上只能称为“奶酪制品”的东西。吃起来不算美味，但做菜时可以代替真正的奶酪。食用前务必拆除包装。"
	icon_state = "kruft_single"
	bitesize = 2
	package = TRUE

/obj/item/reagent_container/food/snacks/cheesewedge/mature/kraft/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 5)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("plasticide", 2)

/obj/item/reagent_container/food/snacks/cheesewedge/mature/kraft/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("你拆开了“奶酪”片的包装！"))
		reagents.remove_reagent("plasticide", 2)
		package = FALSE
		icon_state = "kruft_single-o"

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/verymature
	name = "陈年奶酪轮"
	desc = "一大轮美味的切达奶酪，经过长时间熟成，风味相当浓烈。"
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/verymature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/verymature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 25)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge/verymature
	name = "陈年楔形奶酪块"
	desc = "一块充分熟成的切达奶酪，已经陈放了不短的时间。切下它的那轮奶酪应该就在附近。"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/extramature
	name = "太古奶酪轮"
	desc = "一大轮美味的切达奶酪，熟成时间简直有亿万年之久。光是看着它就让你直冒冷汗。由于风味过于强烈，根本无法大口食用。"
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/extramature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/extramature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 25)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("enzyme", 1)

/obj/item/reagent_container/food/snacks/cheesewedge/extramature
	name = "太古楔形奶酪块"
	desc = "一块超熟成的切达奶酪，风味强烈得让你每次最多只能吃下几克。切下它的那轮奶酪应该就在附近。"

/obj/item/reagent_container/food/snacks/sliceable/birthdaycake
	name = "生日蛋糕"
	desc = "生日快乐……"
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_container/food/snacks/birthdaycakeslice
	filling_color = "#FFD6D6"

/obj/item/reagent_container/food/snacks/sliceable/birthdaycake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("sprinkles", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/birthdaycakeslice
	name = "生日蛋糕切片"
	desc = "切一片你的生日。"
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/bread
	name = "面包"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_container/food/snacks/breadslice
	filling_color = "#FFE396"

/obj/item/reagent_container/food/snacks/sliceable/bread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/breadslice
	name = "面包片"
	desc = "一片家乡的味道。"
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/creamcheesebread
	name = "奶油奶酪面包"
	desc = "好吃，好吃，真好吃！"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_container/food/snacks/creamcheesebreadslice
	filling_color = "#FFF896"

/obj/item/reagent_container/food/snacks/sliceable/creamcheesebread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/creamcheesebreadslice
	name = "奶油奶酪面包片"
	desc = "一片美味！"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2

/obj/item/reagent_container/food/snacks/watermelonslice
	name = "西瓜片"
	desc = "一片汁水丰沛的美味。"
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/applecake
	name = "苹果蛋糕"
	desc = "以苹果为中心馅料的蛋糕。"
	icon_state = "applecake"
	slice_path = /obj/item/reagent_container/food/snacks/applecakeslice
	filling_color = "#EBF5B8"

/obj/item/reagent_container/food/snacks/sliceable/applecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 10)
	reagents.add_reagent("sugar", 10)

/obj/item/reagent_container/food/snacks/applecakeslice
	name = "苹果蛋糕切片"
	desc = "一片美妙无比的蛋糕。"
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pumpkinpie
	name = "南瓜派"
	desc = "适合秋日享用的美味点心。"
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_container/food/snacks/pumpkinpieslice
	filling_color = "#F5B951"

/obj/item/reagent_container/food/snacks/sliceable/pumpkinpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("sugar", 10)

/obj/item/reagent_container/food/snacks/pumpkinpieslice
	name = "南瓜派切片"
	desc = "一片顶着打发奶油的南瓜派，完美。"
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2

/obj/item/reagent_container/food/snacks/cracker
	name = "咸饼干"
	desc = "一块咸饼干。"
	icon_state = "cracker"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	filling_color = "#F5DEB8"

/obj/item/reagent_container/food/snacks/cracker/Initialize()
	. = ..()
	reagents.add_reagent("bread", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/cracker/tachyon
	name = "咸饼干"
	desc = "一块看起来经过快子分流器的咸饼干。看着没事……对吧？"
	icon_state = "tachyon_cracker"
	filling_color = "#728942"

/obj/item/reagent_container/food/snacks/cracker/tachyon/Initialize()
	. = ..()
	reagents.add_reagent("carpotoxin", 1)

/*
*PIZZA.
*object parent for all the object pizza give the number of slice produce and the filling color.
*example of how it work for each pizza.
*object 1 here is the first item : the pizza it give him name description icon and where to find the corresponding slice object.
*object 2 child to pizza to initialize corresponding pizza and fill it with reagent and define the number of bite to eat it.
*object 3 here is the second item : the pizza slice it give him name description icon filling color and number of bites.
*/

/obj/item/reagent_container/food/snacks/sliceable/pizza
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/mystery
	name = "神秘披萨"
	desc = "看着能吃、让人食欲大开的神秘披萨。"
	slice_path = /obj/item/reagent_container/food/snacks/mysteryslice

/obj/item/reagent_container/food/snacks/sliceable/pizza/mystery/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	icon_state = pick("pizzamargherita","meatpizza","mushroompizza","vegetablepizza")
	if(prob(60))
		reagents.add_reagent("tomatojuice", 6)
	for(var/i in 1 to 3)
		var/ingredient = pick(200;"vegetable", 150;"meatprotein", "mushroom", "fish", "cheese", 80;"potato", 80;"egg", 50;"coco", 50;"fruit", 50;"soysauce", 50;"ketchup", 50;"tofu", 30;"noodles", 30;"honey", 30;"banana")
		reagents.add_reagent(ingredient, rand(6,12))

/obj/item/reagent_container/food/snacks/mysteryslice
	name = "神秘披萨片"
	desc = "你先吃。"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/mysteryslice/Initialize()
	. = ..() // I'm not rewriting a chunk of cooking backend for this, so this just slices into random icons. Intriguing!
	icon_state = pick("pizzamargheritaslice","meatpizzaslice","mushroompizzaslice","vegetablepizzaslice")

/obj/item/reagent_container/food/snacks/sliceable/pizza/margherita
	name = "玛格丽特披萨"
	desc = "披萨的黄金标准。"
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_container/food/snacks/margheritaslice

/obj/item/reagent_container/food/snacks/sliceable/pizza/margherita/Initialize()
	. = ..()
	reagents.add_reagent("bread", 20)
	reagents.add_reagent("cheese", 20)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/reagent_container/food/snacks/margheritaslice
	name = "玛格丽特披萨片"
	desc = "一片经典披萨。"
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza
	name = "肉馅披萨"
	desc = "铺有肉馅的披萨。"
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_container/food/snacks/meatpizzaslice

/obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 20)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("tomatojuice", 6)

/obj/item/reagent_container/food/snacks/meatpizzaslice
	name = "肉馅披萨片"
	desc = "一片肉味十足的披萨。"
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza
	name = "蘑菇披萨"
	desc = "非常特别的披萨。"
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_container/food/snacks/mushroompizzaslice

/obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("mushroom", 20)

/obj/item/reagent_container/food/snacks/mushroompizzaslice
	name = "蘑菇披萨片"
	desc = "也许这是你这辈子吃的最后一片披萨。"
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza
	name = "蔬菜披萨"
	desc = "制作本披萨的过程中，没有任何番茄智人受到伤害。"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_container/food/snacks/vegetablepizzaslice

/obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("vegetable", 15)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("imidazoline", 12)

/obj/item/reagent_container/food/snacks/vegetablepizzaslice
	name = "蔬菜披萨片"
	desc = "在不含绿色食材的披萨中，这一片来自最绿色环保的那款。"
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

//pizzabox

/obj/item/pizzabox
	name = "披萨盒"
	desc = "适合装披萨的盒子。"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_container/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/Destroy(force)
	QDEL_NULL(pizza)
	return ..()

/obj/item/pizzabox/update_icon()

	overlays = list()

	// Set appropriate description
	if( open && pizza )
		desc = "适合装披萨的盒子，里面似乎放着[pizza.name]。"
	else if( length(boxes) > 0 )
		desc = "一摞装披萨的盒子，似乎共有[length(boxes) + 1]个。"

		var/obj/item/pizzabox/topbox = boxes[length(boxes)]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc]最上面的盒子贴着标签，上面写着：“[toptag]”。"
	else
		desc = "适合装披萨的盒子。"

		if( boxtag != "" )
			desc = "[desc]盒子贴着标签，上面写着：“[boxtag]”。"

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image("food.dmi", icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			overlays += pizzaimg

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( length(boxes) > 0 )
			var/obj/item/pizzabox/topbox = boxes[length(boxes)]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = length(boxes) * 3
			overlays += tagimg

	icon_state = "pizzabox[length(boxes)+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, SPAN_DANGER("你从[src]里取出了[src.pizza]。"))
		src.pizza = null
		update_icon()
		return

	if( length(boxes) > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[length(boxes)]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, SPAN_DANGER("你取下了手中最上面的[src]。"))
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self(mob/user)
	..()

	if(length(boxes) > 0)
		return

	open = !open
	if(open && pizza)
		ismessy = TRUE

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (length(boxes)+1) + length(boxestoadd) <= 5 )
				user.drop_inv_item_to_loc(box, src)
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, SPAN_DANGER("你把[box]放在了[src]上面！"))
			else
				to_chat(user, SPAN_DANGER("已经堆得太高了！"))
		else
			to_chat(user, SPAN_DANGER("请先合上[box]！"))

		return

	if( istype(I, /obj/item/reagent_container/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if(open)
			user.drop_inv_item_to_loc(I, src)
			pizza = I

			update_icon()

			to_chat(user, SPAN_DANGER("你把[I]放进了[src]！"))
		else
			to_chat(user, SPAN_DANGER("你想把[I]从盖子里塞进去，但没能成功！"))
		return

	if( istype(I, /obj/item/tool/pen/) )

		if( src.open )
			return

		var/t = stripped_input(user,"输入要添加到标签上的内容：", "书写", "", 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( length(boxes) > 0 )
			boxtotagto = boxes[length(boxes)]

		boxtotagto.boxtag = "[boxtotagto.boxtag][t]"
		playsound(src, "paper_writing", 15, TRUE)
		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "豪华玛格丽特披萨"

/obj/item/pizzabox/vegetable/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "精选蔬菜披萨"

/obj/item/pizzabox/mushroom/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "特色蘑菇披萨"

/obj/item/pizzabox/meat/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "肉食爱好者至尊披萨"

/// Mystery Pizza, made with random ingredients!
/obj/item/pizzabox/mystery/Initialize(mapload, ...)
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/mystery(src)
	boxtag = "神秘披萨"

// Pre-stacked boxes for reqs
/obj/item/pizzabox/mystery/stack/Initialize(mapload, ...)
	. = ..()
	for(var/i in 1 to 2)
		var/obj/item/pizzabox/mystery/extra = new(src)
		boxes += extra
	update_icon()

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

// Flour + egg = dough
/obj/item/reagent_container/food/snacks/flour/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_container/food/snacks/egg))
		new /obj/item/reagent_container/food/snacks/dough(get_turf(src))
		to_chat(user, "你做出了一块面团。")
		qdel(W)
		qdel(src)

// Egg + flour = dough
/obj/item/reagent_container/food/snacks/egg/attackby(obj/item/W, mob/living/user, list/mods)
	if(istype(W, /obj/item/reagent_container/food/snacks/flour))
		new /obj/item/reagent_container/food/snacks/dough(get_turf(src))
		to_chat(user, "你做出了一块面团。")
		qdel(W)
		qdel(src)
		return TRUE

	if(istype(W, /obj/item/toy/crayon))
		var/obj/item/toy/crayon/C = W
		var/clr = C.colorName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, SPAN_NOTICE("这颗蛋不肯染上这种颜色！"))
			return

		to_chat(usr, SPAN_NOTICE("你给[src]涂上了[clr == "purple" ? "紫色" : (clr == "rainbow" ? "彩虹色" : (clr == "mime" ? "默剧配色" : localized_player_label(clr)))]。"))
		icon_state = "egg-[clr]"
		egg_color = clr
		return TRUE

	return ..()

/obj/item/reagent_container/food/snacks/dough
	name = "面团"
	desc = "一块面团。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2

/obj/item/reagent_container/food/snacks/dough/Initialize()
	. = ..()
	reagents.add_reagent("dough", 3)

// Dough + rolling pin = flat dough
/obj/item/reagent_container/food/snacks/dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tool/kitchen/rollingpin))
		new /obj/item/reagent_container/food/snacks/sliceable/flatdough(get_turf(src))
		to_chat(user, "你把面团擀平了。")
		qdel(src)

// slicable into 3xdoughslices
/obj/item/reagent_container/food/snacks/sliceable/flatdough
	name = "擀平的面团"
	desc = "一块擀平的面团。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_container/food/snacks/doughslice

/obj/item/reagent_container/food/snacks/sliceable/flatdough/Initialize()
	. = ..()
	reagents.add_reagent("dough", 3)

/obj/item/reagent_container/food/snacks/doughslice
	name = "面片"
	desc = "制作佳肴的基础材料。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "doughslice"
	bitesize = 2

/obj/item/reagent_container/food/snacks/doughslice/Initialize()
	. = ..()
	reagents.add_reagent("dough", 1)

/obj/item/reagent_container/food/snacks/bun
	name = "汉堡面包"
	desc = "每一个像样汉堡的基础。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2

/obj/item/reagent_container/food/snacks/bun/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)

/obj/item/reagent_container/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_container/food/snacks/meatball))
		new /obj/item/reagent_container/food/snacks/monkeyburger(get_turf(src))
		to_chat(user, "你做出了一个汉堡。")
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_container/food/snacks/cutlet))
		new /obj/item/reagent_container/food/snacks/monkeyburger(get_turf(src))
		to_chat(user, "你做出了一个汉堡。")
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_container/food/snacks/sausage))
		new /obj/item/reagent_container/food/snacks/hotdog(get_turf(src))
		to_chat(user, "你做出了一根热狗。")
		qdel(W)
		qdel(src)

// Burger + cheese wedge = cheeseburger
/obj/item/reagent_container/food/snacks/monkeyburger/attackby(obj/item/reagent_container/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/reagent_container/food/snacks/cheesewedge))
		new /obj/item/reagent_container/food/snacks/cheeseburger(get_turf(src))
		to_chat(user, "你做出了一个奶酪汉堡。")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_container/food/snacks/human/burger/attackby(obj/item/reagent_container/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/reagent_container/food/snacks/cheeseburger(get_turf(src))
		to_chat(user, "你做出了一个奶酪汉堡。")
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/reagent_container/food/snacks/taco
	name = "墨西哥夹饼"
	desc = "来一口！"
	icon_state = "taco"
	bitesize = 3

/obj/item/reagent_container/food/snacks/taco/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 7)

/obj/item/reagent_container/food/snacks/rawcutlet
	name = "生肉片"
	desc = "一片薄薄的生肉。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawcutlet"

/obj/item/reagent_container/food/snacks/rawcutlet/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 1)

/obj/item/reagent_container/food/snacks/cutlet
	name = "熟肉片"
	desc = "一片美味的肉。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2

/obj/item/reagent_container/food/snacks/cutlet/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 2)

/obj/item/reagent_container/food/snacks/rawmeatball
	name = "生肉丸"
	desc = "一颗生肉丸。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2

/obj/item/reagent_container/food/snacks/rawmeatball/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 2)

/obj/item/reagent_container/food/snacks/hotdog
	name = "热狗"
	desc = "大概和狗没什么关系。"
	icon_state = "open-hotdog"
	bitesize = 2

/obj/item/reagent_container/food/snacks/hotdog/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 3)

/obj/item/reagent_container/food/snacks/flatbread
	name = "扁面包"
	desc = "寡淡，但顶饱。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2

/obj/item/reagent_container/food/snacks/flatbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)

// potato + knife = raw sticks
/obj/item/reagent_container/food/snacks/grown/potato/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tool/kitchen/utensil/knife))
		new /obj/item/reagent_container/food/snacks/rawsticks(get_turf(src))
		to_chat(user, "你切开了土豆。")
		qdel(src)
		return TRUE

	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(C.use(5))
			to_chat(user, SPAN_NOTICE("你给土豆接上电缆，再把它塞进电池外壳。"))
			var/obj/item/cell/potato/pocell = new /obj/item/cell/potato(user.loc)
			pocell.maxcharge = src.potency * 10
			pocell.charge = pocell.maxcharge
			qdel(src)
			return TRUE

	return ..()

/obj/item/reagent_container/food/snacks/rawsticks
	name = "生土豆条"
	desc = "还没炸的薯条，不怎么好吃。"
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2

/obj/item/reagent_container/food/snacks/rawsticks/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("potato", 3)

/obj/item/reagent_container/food/snacks/microwavable
	name = "微波即热零食"
	desc = "可以放进微波炉的食物，不过加热也不会更好吃。"
	var/warm_desc = "一些微波加热过的食物。"
	icon_state = "donkpocket"
	bitesize = 3
	var/warm = 0

/obj/item/reagent_container/food/snacks/microwavable/proc/cooltime() //Not working, derp?
	if(warm)
		spawn(4200)
			if(!QDELETED(src)) //not qdel'd
				warm = 0
				reagents.del_reagent("bread", 1)
				reagents.del_reagent("meatprotein", 1)
				name = name

/obj/item/reagent_container/food/snacks/microwavable/donkpocket
	name = "咚咚馅饼"
	desc = "老练叛徒的首选食物。由维兰德-汤谷公司包装。"
	warm_desc = "老练叛徒的首选食物。受热不均，硬得像石头。"
	icon_state = "donkpocket_wr2"
	filling_color = "#DEDEAB"
	package = 2

/obj/item/reagent_container/food/snacks/microwavable/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("cheese", 2)

/obj/item/reagent_container/food/snacks/microwavable/donkpocket/attack_self(mob/user)
	..()

	if(package==1) // this one comes first, otherwise it will run package==2 and THEN package==1 in succession
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("你抽掉了咚咚馅饼的纸套！"))
		package = 0
		icon_state = "donkpocket"
	if(package==2)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("你拆掉了咚咚馅饼的外包装！"))
		package = 1
		icon_state = "donkpocket_wr1"

/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito
	name = "包装卷饼"
	desc = "硬邦邦的微波卷饼。没标加热时间，但你还是可以试着微波一下。由维兰德-汤谷公司包装。"
	warm_desc = "一份硬邦邦的微波卷饼，外面烫得快化了，里面却几乎没熟。"
	icon_state = "packaged-burrito"
	package = 1
	flags_obj = OBJ_NO_HELMET_BAND|OBJ_IS_HELMET_GARB

/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("cheese", 2)

/obj/item/reagent_container/food/snacks/microwavable/packaged_burrito/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("你拆开了软塌塌卷饼的包装！"))
		package = 0
		icon_state = "open-burrito"

/obj/item/reagent_container/food/snacks/microwavable/packaged_burger
	name = "包装芝士汉堡"
	desc = "湿软的微波汉堡。没标加热时间，但你还是可以试着微波一下。由维兰德-汤谷公司包装。"
	warm_desc = "一个湿软的微波汉堡。和之前一样湿软，只不过现在热了。"
	icon_state = "burger"
	package = 1

/obj/item/reagent_container/food/snacks/microwavable/packaged_burger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("cheese", 2)
	reagents.add_reagent("sodiumchloride", 2)


/obj/item/reagent_container/food/snacks/microwavable/packaged_burger/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("你拆开了软塌塌汉堡的包装！"))
		package = 0
		icon_state = "hburger"
		item_state = "burger"

/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs
	name = "包装热狗"
	desc = "一根软塌塌的常温热狗。没标加热时间，但你还是可以试着微波一下。由维兰德-汤谷公司包装。"
	warm_desc = "一根软塌塌、冒着热气的热狗。肠衣似乎已经爆开，面包也烤干了。"
	icon_state = "packaged-hotdog"
	flags_obj = OBJ_NO_HELMET_BAND|OBJ_IS_HELMET_GARB
	package = 1

/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("ketchup", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/microwavable/packaged_hdogs/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("你拆开了软塌塌热狗的包装！"))
		package = 0
		icon_state = "open-hotdog"

/*
//obj/item/reagent_container/food/snacks/upp
	name = "\improper UPP survival ration"
	desc = "A small compressed package containing a single portion of food you cannot distinguish. Mass produced as emergency rations they are available in abundance anywhere in the Union and are packed with nutritional additives. They are commonplace in the diets of many citizens of the Union who eat them out of convenience in place of more flavourful nutrient bars, or as nutritional additives to dishes. Despite popular myths in the UA, they are not the standard MRE of the UPPAC, but are utilized in scenarios where the actual MRE supply has been depleted, as one would expect of survival food."
	icon_state = "upp_ration"
	bitesize = 4
	package = 1

//obj/item/reagent_container/food/snacks/upp/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 14)

//obj/item/reagent_container/food/snacks/upp/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, TRUE)
		to_chat(user, SPAN_NOTICE("You tear off the ration seal and pull out the contents!"))
		package = FALSE
		name = "survival ration"
		var/variation = rand(1,2)
		switch(variation)
			if(1)
				desc = "A compact chunk of freeze-dried meat or fish featuring nutrient additives in the form of a dense powder. Having little flavoring or colouration as a result of its preparation for long term storage, the appeal of this item is purely in its capacity to provide sustenance."
				icon_state = "upp_1"
			if(2)
				desc = "A compact ball of dough-like rice or oats featuring nutrient additives in the form of a dense powder. Having little flavoring or colouration as a result of its preparation for long term storage, the appeal of this item is purely in its capacity to provide sustenance."
				icon_state = "upp_2"
*/

/obj/item/reagent_container/food/snacks/eat_bar
	name = "肉食能量棒"
	desc = "一管真空封装的可疑肉食，人工塞满了你念不出名字的营养物质。M 字印在侧面，正面只剩 EAT。广告口号大概就是这么来的。"
	icon_state = "eat_bar"
	bitesize = 2
	w_class = SIZE_TINY
	trash = /obj/item/trash/eat

/obj/item/reagent_container/food/snacks/eat_bar/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("meatprotein", 4)


/obj/item/reagent_container/food/snacks/kepler_crisps
	name = "开普勒薯片"
	desc = "“好吃得令人不安！”现含 0% 反式脂肪，并添加真正的海盐。"
	icon_state = "kepler"
	bitesize = 2
	trash = /obj/item/trash/kepler

/obj/item/reagent_container/food/snacks/kepler_crisps/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 12)

/obj/item/reagent_container/food/snacks/kepler_crisps/flamehot
	name = "开普勒烈焰辣味薯片"
	desc = "“好吃得令人不安！”开普勒烈焰辣味在 2165 年上市时配合了一场时机绝佳的广告活动，使开普勒品牌在当年第三季度超越了维兰的其他零食产品。含 0% 反式脂肪。"
	icon_state = "flamehotkepler"
	bitesize = 2
	trash = /obj/item/trash/kepler/flamehot

/obj/item/reagent_container/food/snacks/kepler_crisps/flamehot/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 4)
	reagents.add_reagent("hotsauce", 8)

//Wrapped candy bars

/obj/item/reagent_container/food/snacks/wrapped
	package = 1
	bitesize = 3
	black_market_value = 5
	var/obj/item/trash/wrapper = null //Why this and not trash? Because it pulls the wrapper off when you unwrap it as a trash item.

/obj/item/reagent_container/food/snacks/wrapped/attack_self(mob/user)
	..()

	if(package)
		to_chat(user, SPAN_NOTICE("你撕开了[src]的包装！"))
		playsound(loc,'sound/effects/pageturn2.ogg', 15, 1)

		if(wrapper)
			new wrapper(user.loc)
		icon_state = "[initial(icon_state)]-o"
		package = 0

//CM SNACKS
/obj/item/reagent_container/food/snacks/wrapped/booniebars
	name = "丛林能量棒"
	desc = "两块美味的薄荷巧克力。<i>“有些东西总是……遥不可及。”</i>"
	icon_state = "boonie"
	wrapper = /obj/item/trash/boonie

/obj/item/reagent_container/food/snacks/wrapped/booniebars/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	reagents.add_reagent("coco", 4)

/obj/item/reagent_container/food/snacks/wrapped/chunk
	name = "CHUNK 箱"
	desc = "一块“<b>大块</b>”牌巧克力。<i>“联邦法律允许存在的最致密巧克力。依法提醒：除食用补充营养外，请勿将此钝器用于其他用途。”</i>"
	icon_state = "chunk"
	hitsound = "swing_hit"
	force = 15
	throwforce = 10
	attack_speed = 10
	demolition_mod = 0.3
	bitesize = 2
	wrapper = /obj/item/trash/chunk

/obj/item/reagent_container/food/snacks/wrapped/chunk/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 7)
	reagents.add_reagent("coco", 10)

/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk
	name = "巨块能量棒箱"
	desc = "一“箱”——至少广告这么说——“<b>巨块</b>”牌巧克力。它是大块巧克力盒的早期版本，数百名顾客仅仅尝试咬下一口就崩裂牙齿，随后集体诉讼使品牌破产，并被公司收购。"
	icon_state = "hunk"
	w_class = SIZE_MEDIUM
	force = 35
	throwforce = 50
	bitesize = 20
	wrapper = /obj/item/trash/chunk/hunk

/obj/item/reagent_container/food/snacks/wrapped/chunk/hunk/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 5)
	reagents.add_reagent("iron", 30)
	reagents.add_reagent("coco", 5)

/obj/item/reagent_container/food/snacks/wrapped/barcardine
	name = "巴卡定能量棒"
	desc = "一块闻起来像医务室的巧克力。<i>“巧克力总能赶走疼痛。”</i>"
	icon_state = "barcardine"
	wrapper = /obj/item/trash/barcardine

/obj/item/reagent_container/food/snacks/wrapped/barcardine/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("tramadol", 1) //May be powergamed but it's a single unit.

/obj/item/reagent_container/food/snacks/wrapped/twe_bar
	name = "ORP 燕麦饼干"
	desc = "一条混有少许果干的燕麦饼干，很适合搭配一杯茶。"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "cookie_bar"
	wrapper = null

/obj/item/reagent_container/food/snacks/wrapped/twe_bar/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("fruit", 1)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/wrapped/upp_biscuits
	name = "IRP 军用饼干"
	desc = "也称军用薄脆饼干。烘烤而成，酥脆咸香，可搭配抹酱或直接食用。"
	icon = 'icons/obj/items/food/mre_food/upp.dmi'
	icon_state = "Biscuits_package"
	wrapper = null

/obj/item/reagent_container/food/snacks/wrapped/upp_biscuits/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 1)
