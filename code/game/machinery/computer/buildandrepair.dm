//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/computerframe
	density = FALSE
	anchored = FALSE
	unslashable = TRUE
	name = "计算机机架"
	icon = 'icons/obj/structures/machinery/stock_parts.dmi'
	icon_state = "0"
	var/state = 0
	var/obj/item/circuitboard/computer/circuit = null
// weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE("你用扳手固定好了机架。"))
					src.anchored = TRUE
					src.state = 1
			if(iswelder(P))
				if(!HAS_TRAIT(P, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
					return
				var/obj/item/tool/weldingtool/WT = P
				if(!WT.isOn())
					to_chat(user, SPAN_WARNING("需要先开启[WT]！"))
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src || !WT.isOn()) return
					to_chat(user, SPAN_NOTICE("你拆解了机架。"))
					deconstruct()
		if(1)
			if(HAS_TRAIT(P, TRAIT_TOOL_WRENCH))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					to_chat(user, SPAN_NOTICE("你松开了机架的固定件。"))
					src.anchored = FALSE
					src.state = 0
			if(istype(P, /obj/item/circuitboard/computer) && !circuit)
				if(user.drop_held_item())
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
					to_chat(user, SPAN_NOTICE("你将电路板放入了机架。"))
					icon_state = "1"
					circuit = P
					P.forceMove(src)

			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你用螺丝固定好了电路板。"))
				src.state = 2
				src.icon_state = "2"
			if(HAS_TRAIT(P, TRAIT_TOOL_CROWBAR) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你取出了电路板。"))
				src.state = 1
				src.icon_state = "0"
				circuit.forceMove(loc)
				src.circuit = null
		if(2)
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你松开了电路板的固定件。"))
				src.state = 1
				src.icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = P
				if (C.get_amount() < 5)
					to_chat(user, SPAN_WARNING("你需要五段电线才能给机架布线。"))
					return
				to_chat(user, SPAN_NOTICE("你开始给机架布线。"))
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && state == 2)
					if (C.use(5))
						to_chat(user, SPAN_NOTICE("你给机架接好了电线。"))
						state = 3
						icon_state = "3"
		if(3)
			if(HAS_TRAIT(P, TRAIT_TOOL_WIRECUTTERS))
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你拆除了电线。"))
				src.state = 2
				src.icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( src.loc )
				A.amount = 5

			if(istype(P, /obj/item/stack/sheet/glass))
				var/obj/item/stack/sheet/glass/G = P
				if (G.get_amount() < 2)
					to_chat(user, SPAN_WARNING("你需要两块玻璃才能安装玻璃面板。"))
					return
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你开始安装玻璃面板。"))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && state == 3)
					if (G.use(2))
						to_chat(user, SPAN_NOTICE("你装好了玻璃面板。"))
						src.state = 4
						src.icon_state = "4"
		if(4)
			if(HAS_TRAIT(P, TRAIT_TOOL_CROWBAR))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你拆下了玻璃面板。"))
				src.state = 3
				src.icon_state = "3"
				new /obj/item/stack/sheet/glass( src.loc, 2 )
			if(HAS_TRAIT(P, TRAIT_TOOL_SCREWDRIVER))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("你接好了显示器。"))
				var/B = new src.circuit.build_path ( src.loc )
				src.circuit.construct(B)
				qdel(src)

/obj/structure/computerframe/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/sheet/metal(src.loc, 5)
	return ..()
