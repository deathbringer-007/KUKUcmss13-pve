/obj/structure/machinery/requests_console
	name = "请求控制台"
	desc = "用于向空间站各部门发送请求的控制台。"
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/terminals.dmi'
	icon_state = "req_comp0"

/obj/structure/machinery/requests_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp0"
