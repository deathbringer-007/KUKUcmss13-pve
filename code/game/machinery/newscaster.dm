/obj/structure/machinery/newscaster
	name = "新闻终端"
	desc = "获得维兰德-汤谷授权、供商业空间站使用的标准新闻终端。所有对你毫无用处的新闻，全都汇聚于此！"
	icon = 'icons/obj/structures/machinery/terminals.dmi'
	icon_state = "newscaster_normal"
	anchored = TRUE

/obj/structure/machinery/newscaster/security_unit
	name = "安保新闻终端"

/obj/item/newspaper
	name = "报纸"
	desc = "一期《狮鹫报》，在维兰德-汤谷的空间站中流通。"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "newspaper"
	w_class = SIZE_TINY //Let's make it fit in trashbags!
	attack_verb = list("拍打")
