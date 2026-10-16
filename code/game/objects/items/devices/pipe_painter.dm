/obj/item/device/pipe_painter
	name = "管道喷漆器"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "labeler1"
	item_state = "flight"
	var/list/modes
	var/static/list/color_names = list("grey" = "灰色", "red" = "红色", "blue" = "蓝色", "cyan" = "青色", "green" = "绿色", "yellow" = "黄色", "purple" = "紫色", "darkgrey" = "深灰色")
	var/mode

/obj/item/device/pipe_painter/New()
	..()
	modes = new()
	for(var/C in GLOB.pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/device/pipe_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if(!istype(A,/obj/structure/pipes/standard/) || istype(A,/obj/structure/pipes/standard/tank) || istype(A,/obj/structure/pipes/standard/simple/insulated) || !in_range(user, A))
		return
	var/obj/structure/pipes/standard/P = A

	var/turf/T = P.loc
	if (P.level < 2 && T.level==1 && isturf(T) && T.intact_tile)
		to_chat(user, SPAN_DANGER("你必须先拆除地板覆盖层。"))
		return

	P.change_color(GLOB.pipe_colors[mode])

/obj/item/device/pipe_painter/attack_self(mob/user)
	..()
	var/list/color_options = list()
	for(var/color_key in modes)
		color_options[color_names[color_key] ? color_names[color_key] : color_key] = color_key
	mode = color_options[tgui_input_list(usr, "你想使用哪种颜色？", "管道喷漆器", color_options)]

/obj/item/device/pipe_painter/get_examine_text(mob/user)
	. = ..()
	. += "当前处于[color_names[mode] ? color_names[mode] : mode]模式。"
