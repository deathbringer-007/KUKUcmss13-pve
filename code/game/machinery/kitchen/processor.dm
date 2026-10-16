/obj/structure/machinery/processor
	name = "食品加工机"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "processor"
	layer = ABOVE_TABLE_LAYER
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	var/broken = 0
	var/processing = 0
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 50

/datum/food_processor_process
	var/input
	var/output
	var/time = 40

/datum/food_processor_process/process(loc, what)
	if (src.output && loc)
		var/obj/item/reagent_container/food/snacks/created_food = new src.output(loc)
		var/obj/item/reagent_container/food/snacks/original_food = what
		if(original_food.made_from_player)
			created_food.made_from_player = original_food.made_from_player
			created_food.name = (created_food.made_from_player + created_food.name)
	if (what)
		qdel(what)

/datum/food_processor_process/proc/can_use(mob/user)
	// By default, anyone can do it.
	return TRUE

	/* objs */

/datum/food_processor_process/xenomeat
	input = /obj/item/reagent_container/food/snacks/meat/xenomeat
	output = /obj/item/reagent_container/food/snacks/meat/xenomeat/processed

/datum/food_processor_process/xenomeat/can_use(mob/user)
	if(!skillcheck(user, SKILL_DOMESTIC, SKILL_DOMESTIC_MASTER))
		to_chat(user, SPAN_DANGER("你没有受过从食物中去除危险物质的训练！"))
		return FALSE
	return TRUE

/datum/food_processor_process/meat
	input = /obj/item/reagent_container/food/snacks/meat
	output = /obj/item/reagent_container/food/snacks/rawmeatball

/datum/food_processor_process/carpmeat
	input = /obj/item/reagent_container/food/snacks/carpmeat
	output = /obj/item/reagent_container/food/snacks/carpmeat/processed

/datum/food_processor_process/carpmeat/can_use(mob/user)
	if(!skillcheck(user, SKILL_DOMESTIC, SKILL_DOMESTIC_MASTER))
		to_chat(user, SPAN_DANGER("你没有受过从食物中去除危险物质的训练！"))
		return FALSE
	return TRUE

/datum/food_processor_process/potato
	input = /obj/item/reagent_container/food/snacks/grown/potato
	output = /obj/item/reagent_container/food/snacks/rawsticks

/datum/food_processor_process/carrot
	input = /obj/item/reagent_container/food/snacks/grown/carrot
	output = /obj/item/reagent_container/food/snacks/carrotfries

/datum/food_processor_process/soybeans
	input = /obj/item/reagent_container/food/snacks/grown/soybeans
	output = /obj/item/reagent_container/food/snacks/soydope

/datum/food_processor_process/wheat
	input = /obj/item/reagent_container/food/snacks/grown/wheat
	output = /obj/item/reagent_container/food/snacks/flour

/datum/food_processor_process/spaghetti
	input = /obj/item/reagent_container/food/snacks/flour
	output = /obj/item/reagent_container/food/snacks/spagetti

/datum/food_processor_process/chocolatebar
	input = /obj/item/reagent_container/food/snacks/grown/cocoapod
	output = /obj/item/reagent_container/food/snacks/chocolatebar

	/* mobs */
/datum/food_processor_process/mob/process(loc, what)
	..()

/obj/structure/machinery/processor/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/processor/proc/select_recipe(X)
	for (var/Type in typesof(/datum/food_processor_process) - /datum/food_processor_process - /datum/food_processor_process/mob)
		var/datum/food_processor_process/P = new Type()
		if (!istype(X, P.input))
			continue
		return P
	return 0

/obj/structure/machinery/processor/attackby(obj/item/O as obj, mob/user as mob)
	if(processing)
		to_chat(user, SPAN_DANGER("食品加工机正在加工。"))
		return 1
	if(length(contents) > 0) //TODO: several items at once? several different items?
		to_chat(user, SPAN_DANGER("加工室里已经有东西了。"))
		return 1
	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		. = ..()
		return
	var/obj/what = O
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		what = G.grabbed_thing

	var/datum/food_processor_process/P = select_recipe(what)
	if (!P)
		to_chat(user, SPAN_DANGER("那东西恐怕没法搅碎。"))
		return 1
	if(!P.can_use(user))
		return 1
	user.visible_message("[user]将[what]放入了[src]。", \
		"你将[what]放入了[src]。")
	user.drop_held_item()
	what.forceMove(src)

/obj/structure/machinery/processor/attack_hand(mob/user as mob)
	if (src.stat != 0) //NOPOWER etc
		return
	if(src.processing)
		to_chat(user, SPAN_DANGER("食品加工机正在加工。"))
		return 1
	if(length(src.contents) == 0)
		to_chat(user, SPAN_DANGER("食品加工机是空的。"))
		return 1
	for(var/O in src.contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor havent suitable recipe. How do you put it in?") //-rastaf0
			continue
		src.processing = 1
		user.visible_message(SPAN_NOTICE("[user]启动了[src]。"), \
			"你启动了[src]。", \
			"你听见食品加工机运转的声音。")
		playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
		use_power(500)
		sleep(P.time)
		P.process(src.loc, O)
		src.processing = 0
	src.visible_message(SPAN_NOTICE("[src]完成了加工。"), \
		"你听见食品加工机停了下来。")
