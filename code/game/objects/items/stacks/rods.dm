/obj/item/stack/rods
	name = "金属杆"
	desc = "一些金属杆，可用于建造之类的工作。"
	singular_name = "金属杆"
	icon_state = "rods"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL
	force = 9
	throwforce = 15
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	matter = list("metal" = 1875)
	max_amount = 60
	attack_verb = list("击打", "钝击", "重击")
	stack_id = "metal rod"
	garbage = TRUE
	var/sheet_path = /obj/item/stack/sheet/metal
	var/used_per_sheet = 4

/obj/item/stack/rods/Initialize(mapload, ...)
	. = ..()
	recipes = GLOB.rod_recipes

/obj/item/stack/rods/attackby(obj/item/W as obj, mob/user as mob)
	if (!iswelder(W))
		return ..()

	if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
		to_chat(user, SPAN_WARNING("你需要功率更大的焊炬！"))
		return

	var/obj/item/tool/weldingtool/WT = W

	if(amount < used_per_sheet)
		to_chat(user, SPAN_DANGER("这至少需要[used_per_sheet]根杆材。"))
		return

	if(WT.remove_fuel(0,user))
		var/obj/item/stack/sheet/new_item = new sheet_path(user.loc)
		new_item.add_to_stacks(user)
		for (var/mob/M as anything in viewers(src))
			M.show_message(SPAN_DANGER("[user.name]用焊炬将[src]加工成了金属板。"), SHOW_MESSAGE_VISIBLE, SPAN_DANGER("你听到了焊接声。"), SHOW_MESSAGE_AUDIBLE)
		use(used_per_sheet)

GLOBAL_LIST_INIT(rod_recipes, list (
	new /datum/stack_recipe("金属栅格", /obj/structure/grille, 4, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED),
	new /datum/stack_recipe("围栏", /obj/structure/fence, 10, time = 20, one_per_turf = ONE_TYPE_PER_TURF, on_floor = 1, skill_req = SKILL_CONSTRUCTION, skill_lvl = SKILL_CONSTRUCTION_TRAINED)
	))


/obj/item/stack/rods/plasteel
	name = "塑钢杆"
	desc = "一些塑钢杆，可用于建造更坚固的结构和物品。"
	singular_name = "塑钢杆"
	icon_state = "rods_plasteel"
	flags_atom = FPRINT
	matter = list("plasteel" = 3750)
	attack_verb = list("击打", "钝击", "重击")
	stack_id = "plasteel rod"
	sheet_path = /obj/item/stack/sheet/plasteel
	used_per_sheet = 2

/obj/item/stack/rods/plasteel/Initialize()
	. = ..()
	recipes = null

/obj/item/stack/rods/plasteel/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/stack/sheet/metal))
		return ..()

	var/obj/item/stack/sheet/metal/M = W

	if(amount < 5) // Placeholder until we get an elaborate crafting system created
		to_chat(user, SPAN_DANGER("这至少需要5根塑钢杆。"))
		return

	if(M.amount >= 10 && do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		if(!M.use(10))
			return
		var/obj/item/device/m56d_post_frame/PF = new(get_turf(user))
		to_chat(user, SPAN_NOTICE("你制作了[PF]。"))
		var/replace = (user.get_inactive_hand()==src)
		use(5)
		if(QDELETED(src) && replace)
			user.put_in_hands(PF)
	else
		to_chat(user, SPAN_WARNING("这至少需要10块金属板。"))
