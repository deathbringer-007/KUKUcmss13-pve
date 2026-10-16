/obj/vehicle/train/cargo/engine
	name = "货运列车牵引车"
	desc = "用于牵引货运拖车的可驾驶电动车。"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "cargo_engine"
	on = 0
	powered = 1
	locked = 0
	charge_use = 15

	light_system = MOVABLE_LIGHT
	light_range = 5

	var/car_limit = 3 //how many cars an engine can pull before performance degrades
	active_engines = 1
	var/obj/item/key/cargo_train/key

/obj/item/key/cargo_train
	name = "钥匙"
	desc = "钥匙圈上挂着一把小钢钥匙，以及写着“呜呜！”的黄色挂饰。"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "train_keys"
	w_class = SIZE_TINY

/obj/vehicle/train/cargo/trolley
	name = "货运列车拖车"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "cargo_trailer"
	light_range = 0
	anchored = FALSE
	locked = 0
	can_buckle = FALSE

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/Initialize()
	. = ..()
	cell = new /obj/item/cell/apc
	key = new()
	var/image/I = new(icon = 'icons/obj/vehicles/vehicles.dmi', icon_state = "cargo_engine_overlay", layer = src.layer + 0.2) //over mobs
	overlays += I

	if(light_range)
		set_light_on(TRUE)

	turn_off() //so engine verbs are correctly set

/obj/vehicle/train/cargo/engine/Move()
	if(on && cell.charge < charge_use)
		turn_off()
		update_stats()

	if(is_train_head() && !on)
		return 0

	return ..()


/obj/vehicle/train/cargo/engine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/key/cargo_train))
		if(!key)
			user.drop_inv_item_to_loc(W, src)
			key = W
			verbs += /obj/vehicle/train/cargo/engine/verb/remove_key
		return
	..()

/obj/vehicle/train/cargo/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/vehicle/train/cargo/trolley/insert_cell(obj/item/cell/C, mob/living/carbon/human/H)
	return

/obj/vehicle/train/cargo/engine/insert_cell(obj/item/cell/C, mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/cargo/engine/remove_cell(mob/living/carbon/human/H)
	..()
	update_stats()



//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/turn_on()
	if(!key)
		return
	else
		..()
		update_stats()

		verbs -= /obj/vehicle/train/cargo/engine/verb/stop_engine
		verbs -= /obj/vehicle/train/cargo/engine/verb/start_engine

		if(on)
			verbs += /obj/vehicle/train/cargo/engine/verb/stop_engine
		else
			verbs += /obj/vehicle/train/cargo/engine/verb/start_engine

/obj/vehicle/train/cargo/engine/turn_off()
	..()

	verbs -= /obj/vehicle/train/cargo/engine/verb/stop_engine
	verbs -= /obj/vehicle/train/cargo/engine/verb/start_engine

	if(!on)
		verbs += /obj/vehicle/train/cargo/engine/verb/start_engine
	else
		verbs += /obj/vehicle/train/cargo/engine/verb/stop_engine


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/cargo/engine/relaymove(mob/user, direction)
	if(user != buckled_mob)
		return 0

	if(is_train_head())
		if(direction == reverse_direction(dir) && tow)
			return 0
	return ..()

/obj/vehicle/train/cargo/engine/get_examine_text(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	if(get_dist(user,src) <= 1)
		. += "电源指示灯[on ? "亮着" : "熄灭"]。\n点火开关上[key ? "插着钥匙" : "没有钥匙"]。"
		. += "电量表显示为[cell? round(cell.percent(), 0.01) : 0]%。"

/obj/vehicle/train/cargo/engine/verb/start_engine()
	set name = "启动引擎"
	set category = "物品"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(on)
		to_chat(usr, "引擎已经启动了。")
		return

	turn_on()
	if (on)
		to_chat(usr, "你启动了[src]的引擎。")
	else
		if (cell)
			if(cell.charge < charge_use)
				to_chat(usr, "[src]没电了。")
			else
				to_chat(usr, "[src]的引擎无法启动。")
		else
			to_chat(usr, "[src]的引擎无法启动。")

/obj/vehicle/train/cargo/engine/verb/stop_engine()
	set name = "关闭引擎"
	set category = "物品"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		to_chat(usr, "引擎已经关闭了。")
		return

	turn_off()
	if (!on)
		to_chat(usr, "你关闭了[src]的引擎。")

/obj/vehicle/train/cargo/engine/verb/remove_key()
	set name = "拔出钥匙"
	set category = "物品"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key || (buckled_mob && buckled_mob != usr))
		return

	if(on)
		turn_off()

	key.forceMove(usr.loc)
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/train/cargo/engine/verb/remove_key


//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The longer the train, the slower it will go. car_limit
// sets the max number of cars one engine can pull at
// full speed. Adding more cars beyond this will slow the
// train proportionate to the length of the train. Adding
// more engines increases this limit by car_limit per
// engine.
//-------------------------------------------------------
/obj/vehicle/train/cargo/engine/update_car(train_length, active_engines)
	src.train_length = train_length
	src.active_engines = active_engines //makes cargo trains 10% slower than running when not overweight

/obj/vehicle/train/cargo/trolley/update_car(train_length, active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	if(!lead && !tow)
		anchored = FALSE
	else
		anchored = TRUE
