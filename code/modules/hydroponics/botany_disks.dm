/obj/item/disk/botany
	name = "植物数据磁盘"
	desc = "用于保存植物遗传数据的小型磁盘。"
	icon = 'icons/obj/items/disk.dmi'
	icon_state = "botanydisk"
	w_class = SIZE_TINY
	ground_offset_x = 5
	ground_offset_y = 5

	var/list/genes = list()
	var/genesource = "unknown"


/obj/item/disk/botany/attack_self(mob/user)
	..()

	if(!length(genes))
		return

	var/choice = alert(user, "确定要清空磁盘吗？", "异星植物学数据", "否", "是")
	if(src && user && genes && choice == "是")
		to_chat(user, "你清空了磁盘数据。")
		name = initial(name)
		desc = initial(name)
		genes = list()
		genesource = "unknown"

/obj/item/storage/box/botanydisk
	name = "植物磁盘盒"
	desc = "显然，这是一盒植物数据磁盘。"

/obj/item/storage/box/botanydisk/Initialize()
	. = ..()
	for(var/i = 0;i<14;i++)
		new /obj/item/disk/botany(src)
