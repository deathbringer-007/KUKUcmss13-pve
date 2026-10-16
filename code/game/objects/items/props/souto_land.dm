//souto land props

/obj/structure/prop/souto_land
	name = "占位道具"
	desc = "欢迎来到索托乐园！这个道具不该出现在这里，请在 GitLab 上提交问题并通知地图制作者！"
	icon = 'icons/obj/structures/souto_land.dmi'
	density = FALSE
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE //can't destroy these
	flags_atom = NOINTERACT

/obj/structure/prop/souto_land/ex_act(severity, direction)
	return

/obj/structure/prop/souto_land/streamer
	name = "橙色彩带"
	gender = PLURAL
	desc = "它们轻轻飘动，令人感伤。"
	icon_state = "streamers"
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/souto_land/pole
	name = "彩带支杆"
	desc = "用来连接一条条彩带。"
	icon_state = "post"
	layer = ABOVE_MOB_LAYER


