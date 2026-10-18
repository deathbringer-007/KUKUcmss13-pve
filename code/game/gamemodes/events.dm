//this file left in for legacy support

/proc/carp_migration() // -- Darem
	//sleep(100)
	spawn(rand(300, 600)) //Delayed announcements to keep the crew on their toes.
		marine_announcement("在[MAIN_SHIP_NAME]附近检测到未知生物实体，请待命。", "生命信号警报", 'sound/AI/commandreport.ogg')

/proc/lightsout(isEvent = 0, lightsoutAmount = 1,lightsoutRange = 25) //leave lightsoutAmount as 0 to break ALL lights
	if(isEvent)
		marine_announcement("在你所在区域检测到电磁风暴，请修复可能因过载而损坏的电子设备。", "电磁风暴警报")

	if(lightsoutAmount)
		return

	else
		for(var/obj/structure/machinery/power/apc/apc in GLOB.machines)
			apc.overload_lighting()

	return
