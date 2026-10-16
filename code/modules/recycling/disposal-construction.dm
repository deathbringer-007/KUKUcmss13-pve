// Disposal pipe construction
// This is the pipe that you drag around, not the attached ones.

/obj/structure/disposalconstruct

	name = "废物管道段"
	desc = "用于搭建废物处理系统的大型管道段。"
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "conpipe-s"
	anchored = FALSE
	density = FALSE
	unslashable = TRUE
	matter = list("metal" = 1850)
	level = 2
	var/ptype = 0
	// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk, 6=disposal bin, 7=outlet, 8=inlet

	var/dpdir = 0 // directions as disposalpipe
	var/base_state = "pipe-s"

	// update iconstate and dpdir due to dir and type
/obj/structure/disposalconstruct/proc/update()
	var/flip = turn(dir, 180)
	var/left = turn(dir, 90)
	var/right = turn(dir, -90)

	switch(ptype)
		if(0)
			base_state = "pipe-s"
			dpdir = dir|flip
		if(1)
			base_state = "pipe-c"
			dpdir = dir|right
		if(2)
			base_state = "pipe-j1"
			dpdir = dir|right|flip
		if(3)
			base_state = "pipe-j2"
			dpdir = dir|left|flip
		if(4)
			base_state = "pipe-y"
			dpdir = dir|left|right
		if(5)
			base_state = "pipe-t"
			dpdir = dir
			// disposal bin has only one dir, thus we don't need to care about setting it
		if(6)
			if(anchored)
				base_state = "disposal"
			else
				base_state = "condisposal"

		if(7)
			base_state = "outlet"
			dpdir = dir

		if(8)
			base_state = "intake"
			dpdir = dir

		if(9)
			base_state = "pipe-j1s"
			dpdir = dir|right|flip

		if(10)
			base_state = "pipe-j2s"
			dpdir = dir|left|flip
///// Z-Level stuff
		if(11)
			base_state = "pipe-u"
			dpdir = dir
		if(12)
			base_state = "pipe-d"
			dpdir = dir
///// Z-Level stuff
		if(13)
			base_state = "pipe-tagger"
			dpdir = dir|flip
		if(14)
			base_state = "pipe-tagger-partial"
			dpdir = dir|flip


///// Z-Level stuff
	if(ptype<6 || ptype>8 && !(ptype==11 || ptype==12))
///// Z-Level stuff
		icon_state = "con[base_state]"
	else
		icon_state = base_state

	if(invisibility) // if invisible, fade icon
		alpha = 128

	// hide called by levelupdate if turf intact status changes
	// change visibility status and force update of icon
/obj/structure/disposalconstruct/hide(intact)
	invisibility = (intact && level==1) ? 101: 0 // hide if floor is intact
	update()


	// flip and rotate verbs
/obj/structure/disposalconstruct/verb/rotate()
	set category = "Object"
	set name = "旋转管道"
	set src in view(1)

	if(usr.stat)
		return

	if(anchored)
		to_chat(usr, "旋转前必须先松开管道的固定件。")
		return

	setDir(turn(dir, -90))
	update()

/obj/structure/disposalconstruct/verb/flip()
	set category = "Object"
	set name = "翻转管道"
	set src in view(1)
	if(usr.stat)
		return

	if(anchored)
		to_chat(usr, "翻转前必须先松开管道的固定件。")
		return

	setDir(turn(dir, 180))
	switch(ptype)
		if(2)
			ptype = 3
		if(3)
			ptype = 2
		if(9)
			ptype = 10
		if(10)
			ptype = 9

	update()

	// returns the type path of disposalpipe corresponding to this item dtype
/obj/structure/disposalconstruct/proc/dpipetype()
	switch(ptype)
		if(0,1)
			return /obj/structure/disposalpipe/segment
		if(2,3,4)
			return /obj/structure/disposalpipe/junction
		if(5)
			return /obj/structure/disposalpipe/trunk
		if(6)
			return /obj/structure/machinery/disposal
		if(7)
			return /obj/structure/disposaloutlet
		if(8)
			return /obj/structure/machinery/disposal/deliveryChute
		if(9)
			return /obj/structure/disposalpipe/sortjunction
		if(10)
			return /obj/structure/disposalpipe/sortjunction/flipped
///// Z-Level stuff
		if(11)
			return /obj/structure/disposalpipe/up
		if(12)
			return /obj/structure/disposalpipe/down
///// Z-Level stuff
		if(13)
			return /obj/structure/disposalpipe/tagger
		if(14)
			return /obj/structure/disposalpipe/tagger/partial
	return



// attackby item
// wrench: (un)anchor
// weldingtool: convert to real pipe

/obj/structure/disposalconstruct/attackby(obj/item/I, mob/user)
	var/nicetype = "管道"
	var/ispipe = 0 // Indicates if we should change the level of this pipe
	src.add_fingerprint(user)
	switch(ptype)
		if(6)
			nicetype = "废物处理箱"
		if(7)
			nicetype = "废物出口"
		if(8)
			nicetype = "投递槽"
		if(9, 10)
			nicetype = "分拣管道"
			ispipe = 1
		if(13)
			nicetype = "标记管道"
			ispipe = 1
		if(14)
			nicetype = "部分标记管道"
			ispipe = 1
		else
			nicetype = "管道"
			ispipe = 1

	var/turf/T = src.loc
	if(T.intact_tile)
		to_chat(user, "必须先拆除地板底板，才能安装[nicetype]。")
		return

	var/obj/structure/disposalpipe/CP = locate() in T

	if(HAS_TRAIT(I, TRAIT_TOOL_WRENCH))
		if(anchored)
			anchored = FALSE
			if(ispipe)
				level = 2
				density = FALSE
			else
				density = TRUE
			to_chat(user, "你将[nicetype]从地板下拆了下来。")
		else
			if(ptype>=6 && ptype <= 8) // Disposal or outlet
				if(CP) // There's something there
					if(!istype(CP,/obj/structure/disposalpipe/trunk))
						to_chat(user, "[nicetype]下方需要主管接口才能运作。")
						return
				else // Nothing under, fuck.
					to_chat(user, "[nicetype]下方需要主管接口才能运作。")
					return
			else
				if(CP)
					update()
					var/pdir = CP.dpdir
					if(istype(CP, /obj/structure/disposalpipe/broken))
						pdir = CP.dir
					if(pdir & dpdir)
						to_chat(user, "那个位置已经有[nicetype]了。")
						return

			anchored = TRUE
			if(ispipe)
				level = 1 // We don't want disposal bins to disappear under the floors
				density = FALSE
			else
				density = TRUE // We don't want disposal bins or outlets to go density 0
			to_chat(user, "你将[nicetype]装到了地板下。")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		update()

	else if(iswelder(I))
		if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("你需要功率更大的焊枪！"))
			return
		if(anchored)
			var/obj/item/tool/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
				to_chat(user, "正在将[nicetype]焊接固定。")
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(!src || !W.isOn()) return
					to_chat(user, "[nicetype]已焊接固定！")
					update() // TODO: Make this neat
					if(ispipe) // Pipe

						var/pipetype = dpipetype()
						var/obj/structure/disposalpipe/P = new pipetype(src.loc)
						src.transfer_fingerprints_to(P)
						P.base_icon_state = base_state
						P.setDir(dir)
						P.dpdir = dpdir
						P.updateicon()

						//Needs some special treatment ;)
						if(ptype==9 || ptype==10)
							var/obj/structure/disposalpipe/sortjunction/SortP = P
							SortP.updatedir()

					else if(ptype==6) // Disposal bin
						var/obj/structure/machinery/disposal/P = new /obj/structure/machinery/disposal(src.loc)
						src.transfer_fingerprints_to(P)
						P.mode = 0 // start with pump off

					else if(ptype==7) // Disposal outlet

						var/obj/structure/disposaloutlet/P = new /obj/structure/disposaloutlet(src.loc)
						src.transfer_fingerprints_to(P)
						P.setDir(dir)
						var/obj/structure/disposalpipe/trunk/Trunk = CP
						Trunk.linked = P

					else if(ptype==8) // Disposal outlet

						var/obj/structure/machinery/disposal/deliveryChute/P = new /obj/structure/machinery/disposal/deliveryChute(src.loc)
						src.transfer_fingerprints_to(P)
						P.setDir(dir)

					qdel(src)
					return
			else
				to_chat(user, "你需要更多焊接燃料才能完成这项工作。")
				return
		else
			to_chat(user, "你得先将它固定到底板上！")
			return
