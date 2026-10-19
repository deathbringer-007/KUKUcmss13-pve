#define DISPENSER_UNHACKABLE -1
#define DISPENSER_NOT_HACKED 0
#define DISPENSER_HACKED 1

/obj/structure/machinery/chem_dispenser
	name = "化学分配器"
	desc = "将元素混合制成化学品的复杂机器，维兰德-汤谷出品。"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "dispenser"
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	layer = BELOW_OBJ_LAYER //So beakers reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_MEDIC
	var/ui_title = "Chem Dispenser 5000"
	var/obj/structure/machinery/chem_storage/chem_storage
	var/network = "Ground"
	var/amount = 30
	var/accept_beaker_only = TRUE
	var/obj/item/reagent_container/beaker = null
	var/obj/item/reagent_container/food/drinks/plasticcup/plasticcup = null
	var/obj/item/reagent_container/food/drinks/coffeecup/coffeecup = null
	var/ui_check = 0
	var/static/list/possible_transfer_amounts = list(5,10,20,30,40)
	var/list/dispensable_reagents = list(
		"hydrogen",
		"lithium",
		"carbon",
		"nitrogen",
		"oxygen",
		"fluorine",
		"sodium",
		"aluminum",
		"silicon",
		"phosphorus",
		"sulfur",
		"chlorine",
		"potassium",
		"iron",
		"copper",
		"mercury",
		"radium",
		"water",
		"ethanol",
		"sugar",
		"sulphuric acid",
	)
	/// Has it been hacked
	var/hacked_check = DISPENSER_UNHACKABLE
	/// Additional reagents gotten when it is hacked
	var/hacked_reagents = list()

/obj/structure/machinery/chem_dispenser/medbay
	network = "Medbay"

/obj/structure/machinery/chem_dispenser/research
	network = "Research"

/obj/structure/machinery/chem_dispenser/process()
	if(!chem_storage)
		chem_storage = GLOB.chemical_data.connect_chem_storage(network)

/obj/structure/machinery/chem_dispenser/Initialize()
	. = ..()
	dispensable_reagents = sortList(dispensable_reagents)
	start_processing()

/obj/structure/machinery/chem_dispenser/Destroy()
	if(!chem_storage)
		chem_storage = GLOB.chemical_data.disconnect_chem_storage(network)
	return ..()

/obj/structure/machinery/chem_dispenser/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/chem_dispenser/update_icon()
	. = ..()
	overlays.Cut()
	if(beaker)
		overlays += "+beaker[rand(1, 5)]"
		if(!inoperable())
			overlays += "+onlight"

/obj/structure/machinery/chem_dispenser/on_stored_atom_del(atom/movable/AM)
	if(AM == beaker)
		beaker = null

/obj/structure/machinery/chem_dispenser/proc/replace_beaker(mob/living/user, obj/item/reagent_container/new_beaker)
	if(beaker)
		beaker.forceMove(src.loc)
		if(user && Adjacent(user))
			user.put_in_hands(beaker)
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
	update_icon()
	SStgui.update_uis(src)
	return TRUE

/obj/structure/machinery/chem_dispenser/clicked(mob/user, list/mods)
	if(mods[ALT_CLICK])
		if(!CAN_PICKUP(user, src))
			return ..()
		replace_beaker(user)
	return ..()

// TGUI \\


/obj/structure/machinery/chem_dispenser/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/chem_dispenser/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", name)
		ui.open()

/obj/structure/machinery/chem_dispenser/ui_static_data(mob/user)
	. = list()
	.["beakerTransferAmounts"] = possible_transfer_amounts

/obj/structure/machinery/chem_dispenser/ui_data(mob/user)
	. = list()
	.["amount"] = amount
	.["energy"] = floor(chem_storage.energy)
	.["maxEnergy"] = floor(chem_storage.max_energy)
	.["isBeakerLoaded"] = beaker ? 1 : 0

	var/list/beakerContents = list()
	var/beakerCurrentVolume = 0
	if(beaker && beaker.reagents && length(beaker.reagents.reagent_list))
		for(var/datum/reagent/current_reagent in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = current_reagent.localized_name || current_reagent.name, "volume" = current_reagent.volume))  // list in a list because Byond merges the first list...
			beakerCurrentVolume += current_reagent.volume
	.["beakerContents"] = beakerContents

	if (beaker)
		.["beakerCurrentVolume"] = beakerCurrentVolume
		.["beakerMaxVolume"] = beaker.volume
	else
		.["beakerCurrentVolume"] = null
		.["beakerMaxVolume"] = null

	var/list/chemicals = list()
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
		if(temp)
			var/chemname = temp.localized_name || temp.name
			chemicals.Add(list(list("title" = chemname, "id" = temp.id)))
	.["chemicals"] = chemicals

/obj/structure/machinery/chem_dispenser/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("amount")
			if(inoperable() || QDELETED(beaker))
				return
			var/target = text2num(params["target"])
			if(target in possible_transfer_amounts)
				amount = target
				. = TRUE
		if("dispense")
			if(inoperable() || QDELETED(beaker))
				return
			var/reagent_name = params["reagent"]
			if(beaker && dispensable_reagents.Find(reagent_name))
				var/obj/item/reagent_container/current_beaker = beaker
				var/datum/reagents/current_reagent = current_beaker.reagents
				var/space = current_reagent.maximum_volume - current_reagent.total_volume

				current_reagent.add_reagent(reagent_name, min(amount, chem_storage.energy * 10, space))
				chem_storage.energy = max(chem_storage.energy - min(amount, chem_storage.energy * 10, space) / 10, 0)

			. = TRUE

		if("remove")
			if(inoperable())
				return
			var/amount = text2num(params["amount"])
			if(beaker && (amount in possible_transfer_amounts))
				beaker.reagents.remove_any(amount)
				. = TRUE

		if("eject")
			replace_beaker(usr)
			. = TRUE

/obj/structure/machinery/chem_dispenser/attackby(obj/item/reagent_container/attacking_object, mob/user)
	if(istype(attacking_object, /obj/item/reagent_container/glass) || istype(attacking_object, /obj/item/reagent_container/food))
		if(accept_beaker_only && istype(attacking_object,/obj/item/reagent_container/food))
			to_chat(user, SPAN_NOTICE("这台机器只接受烧杯。"))
		if(user.drop_inv_item_to_loc(attacking_object, src))
			var/obj/item/old_beaker = beaker
			beaker = attacking_object
			if(old_beaker)
				to_chat(user, SPAN_NOTICE("你取出[old_beaker]，换上[attacking_object]。"))
				user.put_in_hands(old_beaker)
			else
				to_chat(user, SPAN_NOTICE("你将[attacking_object]放到机器上。"))
			SStgui.update_uis(src)
		update_icon()
		return

	if(HAS_TRAIT(attacking_object, TRAIT_TOOL_MULTITOOL))
		switch(hacked_check)
			if(DISPENSER_UNHACKABLE)
				to_chat(user, SPAN_NOTICE("无法破解[src]。"))
			if(DISPENSER_NOT_HACKED)
				user.visible_message("[user]用[attacking_object]改装了[src]，一盏指示灯亮了起来。", "你使[src]的一盏指示灯亮了起来。")
				dispensable_reagents += hacked_reagents
				hacked_check = DISPENSER_HACKED
			if(DISPENSER_HACKED)
				user.visible_message("[user]用[attacking_object]改装了[src]，一盏指示灯熄灭了。", "你使[src]的一盏指示灯熄灭了。")
				dispensable_reagents -= hacked_reagents
				hacked_check = DISPENSER_NOT_HACKED

	if(HAS_TRAIT(attacking_object, TRAIT_TOOL_WRENCH))
		if(!wrenchable)
			to_chat(user, "无法用扳手拆下[src]。")
			return

		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		if(!src)
			return

		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		if(anchored)
			user.visible_message("[user]拧紧螺栓，将[src]固定在表面上。", "你拧紧螺栓，将[src]固定在表面上。")
			return

		user.visible_message("[user]松开了将[src]固定在表面上的螺栓。", "你松开了将[src]固定在表面上的螺栓。")

/obj/structure/machinery/chem_dispenser/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/chem_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("[src]无法运作。"))
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("你没有接受过使用[src]的训练。"))
		return
	tgui_interact(user)

/obj/structure/machinery/chem_dispenser/soda
	icon_state = "soda_dispenser"
	name = "汽水机"
	desc = "一键就能制作多种含糖饮料的饮品机器。"
	ui_title = "Soda Dispens-o-matic"
	req_skill = null
	req_skill_level = null
	accept_beaker_only = FALSE
	wrenchable = TRUE
	network = "Misc"
	hacked_check = DISPENSER_NOT_HACKED
	dispensable_reagents = list(
		"water",
		"ice",
		"coffee",
		"cream",
		"tea",
		"cola",
		"spacemountainwind",
		"dr_gibb",
		"space_up",
		"tonic",
		"sodawater",
		"lemon_lime",
		"sugar",
		"orangejuice",
		"limejuice",
		"watermelonjuice",
		"tomatojuice",
		"carrotjuice",
		"berryjuice",
		"grapejuice",
		"lemonjuice",
		"banana",
	)
	hacked_reagents = list(
		"milk",
		"soymilk",
	)

/obj/structure/machinery/chem_dispenser/soda/beer
	icon_state = "booze_dispenser"
	name = "酒水分配器"
	ui_title = "Booze Portal 9001"
	desc = "科技奇迹，据说你一开口，它就能调出你想喝的那杯酒。"
	dispensable_reagents = list(
		"water",
		"ice",
		"sodawater",
		"sugar",
		"tonic",
		"beer",
		"kahlua",
		"whiskey",
		"sake",
		"wine",
		"vodka",
		"gin",
		"rum",
		"vermouth",
		"cognac",
		"ale",
		"mead",
		"thirteenloko",
		"tequila",
	)
	hacked_reagents = list(
		"goldschlager",
		"patron",
		"absinthe",
	)

/obj/structure/machinery/chem_dispenser/canteen
	name = "雀巢公司自动饮料机"
	desc = "雀巢公司出品的自动饮料机，可将水、速溶果味冲剂及咖啡因添加剂混合，制作多种饮品。"
	icon = 'icons/obj/structures/machinery/vending_32x64.dmi'
	icon_state = "drink"
	ui_title = "NestleCo AutoDrink Dispenser W-A3"
	req_skill = null
	req_skill_level = null
	wrenchable = FALSE
	dispensable_reagents = list(
		"water",
		"coffee",
		"cream",
		"tea",
		"milk",
		"soymilk",
		"orangejuice",
		"limejuice",
		"watermelonjuice",
		"tomatojuice",
		"carrotjuice",
		"berryjuice",
		"grapejuice",
		"lemonjuice",
	)

/obj/structure/machinery/chem_dispenser/canteen/update_icon()
	. = ..()
	overlays.Cut()
	if(!beaker)
		return

	overlays += "+beaker"
	if(inoperable())
		return

	overlays += "+onlight"

#undef DISPENSER_UNHACKABLE
#undef DISPENSER_NOT_HACKED
#undef DISPENSER_HACKED

/obj/structure/machinery/chem_dispenser/canteen/upp
	name = "饮液分配器"
	desc = "可将水、速溶果味冲剂及咖啡因添加剂混合，制作多种饮品的分配器。"
	icon_state = "uppdrink"
	ui_title = "AutoDrink Dispenser"

/obj/structure/machinery/chem_dispenser/canteen/upp/update_icon()
	. = ..()
	overlays.Cut()
	if(!beaker)
		return

	overlays += "+beaker"
	if(inoperable())
		return

	overlays += "+onlightupp"
