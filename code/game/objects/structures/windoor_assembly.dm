/* Windoor (window door) assembly -Nodrak
 * Step 1: Create a windoor out of rglass
 * Step 2: Add r-glass to the assembly to make a secure windoor (Optional)
 * Step 3: Rotate or Flip the assembly to face and open the way you want
 * Step 4: Wrench the assembly in place
 * Step 5: Add cables to the assembly
 * Step 6: Set access for the door.
 * Step 7: Screwdriver the door to complete
 */


/obj/structure/windoor_assembly
	icon = 'icons/obj/structures/doors/windoor.dmi'

	name = "风窗门组件"
	icon_state = "l_windoor_assembly01"
	unslashable = TRUE
	anchored = FALSE
	density = FALSE
	dir = NORTH

	var/obj/item/circuitboard/airlock/electronics = null

	//Vars to help with the icon's name
	var/facing = "l" //Does the windoor open to the left or right?
	var/secure = "" //Whether or not this creates a secure windoor
	var/state = "01" //How far the door assembly has progressed in terms of sprites

/obj/structure/windoor_assembly/New(Loc, start_dir=NORTH, constructed=0)
	..()
	if(constructed)
		state = "01"
		anchored = FALSE
	switch(start_dir)
		if(NORTH, SOUTH, EAST, WEST)
			setDir(start_dir)
		else //If the user is facing northeast. northwest, southeast, southwest or north, default to north
			setDir(NORTH)


/obj/structure/windoor_assembly/Destroy()
	density = FALSE
	. = ..()

/obj/structure/windoor_assembly/update_icon()
	icon_state = "[facing]_[secure]windoor_assembly[state]"

/obj/structure/windoor_assembly/attackby(obj/item/W as obj, mob/user as mob)
	//I really should have spread this out across more states but thin little windoors are hard to sprite.
	switch(state)
		if("01")
			if(iswelder(W) && !anchored )
				if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
					return
				var/obj/item/tool/weldingtool/WT = W
				if (WT.remove_fuel(0,user))
					user.visible_message("[user]正在拆解风窗门组件。", "你开始拆解风窗门组件。")
					playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)

					if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(!src || !WT.isOn()) return
						to_chat(user, SPAN_NOTICE("你拆解了风窗门组件！"))
						deconstruct()
				else
					to_chat(user, SPAN_NOTICE("你需要更多焊接燃料才能拆解风窗门组件。"))
					return

			//Wrenching an unsecure assembly anchors it in place. Step 4 complete
			if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && !anchored)
				var/turf/open/T = loc
				if(!(istype(T) && T.allow_construction))
					to_chat(user, SPAN_WARNING("必须将[src]固定在合适的表面上！"))
					return
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message("[user]正在将风窗门组件固定在地板上。", "你开始将风窗门组件固定在地板上。")

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src) return
					to_chat(user, SPAN_NOTICE("你固定好了风窗门组件！"))
					src.anchored = TRUE
					if(src.secure)
						src.name = "已固定的加固风窗门组件"
					else
						src.name = "已固定的风窗门组件"

			//Unwrenching an unsecure assembly un-anchors it. Step 4 undone
			else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH) && anchored)
				playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message("[user]正在松开风窗门组件与地板之间的固定件。", "你开始松开风窗门组件与地板之间的固定件。")

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src) return
					to_chat(user, SPAN_NOTICE("你松开了风窗门组件的固定件！"))
					src.anchored = FALSE
					if(src.secure)
						src.name = "加固风窗门组件"
					else
						src.name = "风窗门组件"

			//Adding plasteel makes the assembly a secure windoor assembly. Step 2 (optional) complete.
			else if(istype(W, /obj/item/stack/rods) && !secure)
				var/obj/item/stack/rods/R = W
				if(R.get_amount() < 4)
					to_chat(user, SPAN_WARNING("你需要更多金属棒才能这样做。"))
					return
				to_chat(user, SPAN_NOTICE("你开始用金属棒加固风窗门。"))

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && !secure)
					if (R.use(4))
						to_chat(user, SPAN_NOTICE("你加固了风窗门。"))
						src.secure = "secure_"
						if(src.anchored)
							src.name = "已固定的加固风窗门组件"
						else
							src.name = "加固风窗门组件"

			//Adding cable to the assembly. Step 5 complete.
			else if(istype(W, /obj/item/stack/cable_coil) && anchored)
				user.visible_message("[user]正在给风窗门组件布线。", "你开始给风窗门组件布线。")

				var/obj/item/stack/cable_coil/CC = W
				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if (CC.use(1))
						to_chat(user, SPAN_NOTICE("你给风窗门接好了电线！"))
						src.state = "02"
						if(src.secure)
							src.name = "已布线的加固风窗门组件"
						else
							src.name = "已布线的风窗门组件"
			else
				..()

		if("02")

			//Removing wire from the assembly. Step 5 undone.
			if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS) && !src.electronics)
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message("[user]正在剪除气闸组件的电线。", "你开始剪除气闸组件的电线。")

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src) return

					to_chat(user, SPAN_NOTICE("你剪除了风窗门的电线！"))
					new/obj/item/stack/cable_coil(get_turf(user), 1)
					src.state = "01"
					if(src.secure)
						src.name = "已固定的加固风窗门组件"
					else
						src.name = "已固定的风窗门组件"

			//Adding airlock electronics for access. Step 6 complete.
			else if(istype(W, /obj/item/circuitboard/airlock))
				var/obj/item/circuitboard/airlock/board = W
				if(board.fried)
					return
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message("[user]正在给气闸组件安装电子元件。", "你开始给气闸组件安装电子元件。")

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src) return

					user.drop_held_item()
					W.forceMove(src)
					to_chat(user, SPAN_NOTICE("你装好了气闸电子元件！"))
					src.name = "即将完工的风窗门组件"
					src.electronics = W
				else
					W.forceMove(src.loc)

			//Screwdriver to remove airlock electronics. Step 6 undone.
			else if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER) && src.electronics)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message("[user]正在拆除气闸组件的电子元件。", "你开始拆除气闸组件的电子元件。")

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src || !src.electronics) return
					to_chat(user, SPAN_NOTICE("你拆除了气闸电子元件！"))
					if(src.secure)
						src.name = "已布线的加固风窗门组件"
					else
						src.name = "已布线的风窗门组件"
					var/obj/item/circuitboard/airlock/ae = electronics
					electronics = null
					ae.forceMove(src.loc)

			//Crowbar to complete the assembly, Step 7 complete.
			else if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
				if(!src.electronics)
					to_chat(usr, SPAN_DANGER("组件缺少电子元件。"))
					return
				close_browser(usr, "windoor_access")
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				user.visible_message("[user]正在将风窗门撬入框架。", "你开始将风窗门撬入框架。")

				if(do_after(user, 40 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))

					if(!src) return

					density = TRUE //Shouldn't matter but just incase
					to_chat(user, SPAN_NOTICE("你完成了风窗门！"))

					if(secure)
						var/obj/structure/machinery/door/window/brigdoor/windoor = new /obj/structure/machinery/door/window/brigdoor(src.loc)
						if(src.facing == "l")
							windoor.icon_state = "leftsecureopen"
							windoor.base_state = "leftsecure"
						else
							windoor.icon_state = "rightsecureopen"
							windoor.base_state = "rightsecure"
						windoor.setDir(src.dir)
						windoor.density = FALSE

						if(src.electronics.one_access)
							windoor.req_access = null
							windoor.req_one_access = src.electronics.conf_access
						else
							windoor.req_access = src.electronics.conf_access
						windoor.electronics = src.electronics
						src.electronics.forceMove(windoor)
					else
						var/obj/structure/machinery/door/window/windoor = new /obj/structure/machinery/door/window(src.loc)
						if(src.facing == "l")
							windoor.icon_state = "leftopen"
							windoor.base_state = "left"
						else
							windoor.icon_state = "rightopen"
							windoor.base_state = "right"
						windoor.setDir(src.dir)
						windoor.density = FALSE

						if(src.electronics.one_access)
							windoor.req_access = null
							windoor.req_one_access = src.electronics.conf_access
						else
							windoor.req_access = src.electronics.conf_access
						windoor.electronics = src.electronics
						src.electronics.forceMove(windoor)


					qdel(src)


			else
				..()

	//Update to reflect changes(if applicable)
	update_icon()

/obj/structure/windoor_assembly/deconstruct(disassembled = TRUE)
	if(disassembled)
		new /obj/item/stack/sheet/glass/reinforced(get_turf(src), 5)
		if(secure)
			new /obj/item/stack/rods(get_turf(src), 4)
	return ..()
//Rotates the windoor assembly clockwise
/obj/structure/windoor_assembly/verb/revrotate()
	set name = "旋转风窗门组件"
	set category = "Object"
	set src in oview(1)

	if (src.anchored)
		to_chat(usr, "它已固定在地板上，无法旋转！")
		return 0
	src.setDir(turn(src.dir, 270))
	update_icon()
	return

//Flips the windoor assembly, determines whather the door opens to the left or the right
/obj/structure/windoor_assembly/verb/flip()
	set name = "翻转风窗门组件"
	set category = "Object"
	set src in oview(1)

	if(src.facing == "l")
		to_chat(usr, "风窗门现在会向右滑开。")
		src.facing = "r"
	else
		src.facing = "l"
		to_chat(usr, "风窗门现在会向左滑开。")

	update_icon()
	return
