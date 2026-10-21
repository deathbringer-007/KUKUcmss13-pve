/obj/structure/machinery/status_display/supply_display
	ignore_friendc = 1

/obj/structure/machinery/status_display/supply_display/update()
	if(!..() && mode == STATUS_DISPLAY_CUSTOM)
		message1 = "补给"
		message2 = ""

		var/datum/shuttle/ferry/supply/shuttle = GLOB.supply_controller.shuttle
		if (!shuttle)
			message2 = "错误"
		else if(shuttle.has_arrive_time())
			message2 = get_supply_shuttle_timer()
			if(length(message2) > CHARS_PER_LINE)
				message2 = "错误"
		else if (shuttle.is_launching())
			if (shuttle.at_station())
				message2 = "起航"
			else
				message2 = "抵达"
		else
			if(shuttle.at_station())
				message2 = "已停靠"
			else
				message1 = ""
		update_display(message1, message2)
		return 1
	return 0

/obj/structure/machinery/status_display/supply_display/receive_signal/(datum/signal/signal)
	if(signal.data["command"] == "supply")
		mode = STATUS_DISPLAY_CUSTOM
	else
		..(signal)
