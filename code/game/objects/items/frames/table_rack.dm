


/*
 * Table Parts
 */

/obj/item/frame/table
	name = "棕褐色桌子零件"
	desc = "桌子组装套件，包含一块宽大的平整金属桌面和四条桌腿，需要自行组装。"
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "tan_table_parts"
	item_state = "tan_table_parts"
	matter = list("metal" = 7500) //A table, takes two sheets to build
	flags_atom = FPRINT|CONDUCT
	attack_verb = list("猛砸", "重击", "连击", "钝击", "狠揍", "敲打")
	var/table_type = /obj/structure/surface/table //what type of table it creates when assembled

/obj/item/frame/table/attackby(obj/item/W, mob/user)

	..()

	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(R.use(4))
			new /obj/item/frame/table/reinforced(get_turf(src))
			to_chat(user, SPAN_NOTICE("你加固了[src]。"))
			user.temp_drop_inv_item(src)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("你需要至少四根金属棒才能加固[src]。"))

	if(istype(W, /obj/item/stack/sheet/wood))
		var/obj/item/stack/sheet/wood/S = W
		if(S.use(2))
			new /obj/item/frame/table/wood(get_turf(src))
			new /obj/item/stack/sheet/metal(get_turf(src))
			to_chat(user, SPAN_NOTICE("你更换了[src]的金属部件。"))
			user.temp_drop_inv_item(src)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("你需要至少两块木板才能替换[src]的金属部件。"))

/obj/item/frame/table/attack_self(mob/user)
	..()

	var/obj/structure/blocker/anti_cade/AC = locate(/obj/structure/blocker/anti_cade) in usr.loc  // for M2C HMG, look at smartgun_mount.dm
	if(AC)
		to_chat(user, SPAN_WARNING("你不能在这里搭桌子！"))
		return
	var/turf/open/OT = user.loc
	if(!(istype(OT) && OT.allow_construction))
		to_chat(user, SPAN_WARNING("必须在合适的表面上组装[src]！"))
		return
	if(istype(get_area(loc), /area/shuttle))  //HANGAR/SHUTTLE BUILDING
		to_chat(user, SPAN_WARNING("不行，这片区域要留给登陆艇。"))
		return
	for(var/obj/object in OT)
		if(object.density)
			to_chat(user, SPAN_WARNING("[object]挡住了你，无法组装[src]！"))
			return
	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		to_chat(user, SPAN_WARNING("组装桌子时请保持不动！"))
		return

	var/obj/structure/surface/table/T = new table_type(user.loc)
	T.add_fingerprint(user)
	user.drop_held_item()
	qdel(src)

/*
 * Reinforced Table Parts
 */

/obj/item/frame/table/reinforced
	name = "加固桌子零件"
	desc = "桌子组装套件，包含一块宽大的平整金属桌面、四条桌腿和侧板，需要自行组装。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "reinf_tableparts"
	matter = list("metal" = 15000) //A reinforced table. Two sheets of metal and four rods
	table_type = /obj/structure/surface/table/reinforced

/*
 * Wooden Table Parts
 */

/obj/item/frame/table/wood
	name = "木桌零件"
	desc = "桌子组装套件，包含一块宽大的平整木桌面和四条桌腿，需要自行组装。"
	icon_state = "wood_tableparts"
	flags_atom = FPRINT
	matter = null
	table_type = /obj/structure/surface/table/woodentable

/obj/item/frame/table/wood/attackby(obj/item/W, mob/user)

	if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		deconstruct()

	if(istype(W, /obj/item/stack/tile/carpet) && table_type == /obj/structure/surface/table/woodentable)
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			to_chat(user, SPAN_NOTICE("你在[src]上铺了一层毯子。"))
			new /obj/item/frame/table/gambling(get_turf(src))
			qdel(src)


/obj/item/frame/table/wood/poor
	name = "劣质木桌零件"
	desc = "劣质桌子组装套件，包含一块宽大的平整木桌面和四条桌腿，需要自行组装。"
	icon_state = "pwood_tableparts"
	table_type = /obj/structure/surface/table/woodentable/poor

/obj/item/frame/table/wood/fancy
	name = "精制木桌零件"
	desc = "精制桃花心木桌组装套件，包含一块宽大的平整木桌面和四条桌腿，需要自行组装。"
	icon_state = "fwood_tableparts"
	table_type = /obj/structure/surface/table/woodentable/fancy

/*
 * Gambling Table Parts
 */

/obj/item/frame/table/gambling
	name = "赌桌零件"
	desc = "桌子组装套件，包含一块铺有毯面的宽大平整木桌面和四条桌腿，需要自行组装。"
	icon_state = "gamble_tableparts"
	flags_atom = null
	matter = null
	table_type = /obj/structure/surface/table/gamblingtable

/obj/item/frame/table/gambling/attackby(obj/item/W as obj, mob/user as mob)

	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		to_chat(user, SPAN_NOTICE("你撬下了[src]上的毯子。"))
		new /obj/item/stack/tile/carpet(get_turf(src))
		new /obj/item/frame/table/wood(get_turf(src))
		qdel(src)

/*
 * Almayer Tables
 */
/obj/item/frame/table/almayer
	name = "灰色桌子零件"
	icon_state = "table_parts"
	table_type = /obj/structure/surface/table/almayer

/*
 * Rack Parts
 */

/obj/item/frame/rack
	name = "置物架零件"
	gender = PLURAL
	desc = "多层金属置物架的组装套件，价格相对便宜，适合大量储物，需要自行组装。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "rack_parts"
	flags_atom = FPRINT|CONDUCT
	matter = list("metal" = 3750) //A big storage shelf, takes five sheets to build

/obj/item/frame/rack/attackby(obj/item/W, mob/user)
	..()

/obj/item/frame/rack/attack_self(mob/user)
	..()
	var/turf/open/OT = user.loc
	if(!(istype(OT) && OT.allow_construction))
		to_chat(user, SPAN_WARNING("必须在合适的表面上组装[src]！"))
		return

	if(istype(get_area(loc), /area/shuttle))  //HANGAR/SHUTTLE BUILDING
		to_chat(user, SPAN_WARNING("不行，这片区域要留给登陆艇。"))
		return

	if(locate(/obj/structure/surface/table) in user.loc || locate(/obj/structure/barricade) in user.loc)
		to_chat(user, SPAN_WARNING("这里已经有建筑了。"))
		return

	if(locate(/obj/structure/surface/rack) in user.loc)
		to_chat(user, SPAN_WARNING("这里已经有置物架了。"))
		return

	var/obj/structure/surface/rack/R = new /obj/structure/surface/rack(user.loc)
	R.add_fingerprint(user)
	user.drop_held_item()
	qdel(src)
