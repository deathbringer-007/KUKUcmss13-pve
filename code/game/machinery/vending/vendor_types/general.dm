/obj/structure/machinery/cm_vending/sorted/walkman
	name = "休闲用品售卖机"
	desc = "提供维兰德-汤谷批准的休闲用品，如随身听和纸牌。"
	icon_state = "walkman"
	wrenchable = TRUE
	hackable = TRUE
	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 0.5 SECONDS

/obj/structure/machinery/cm_vending/sorted/walkman/get_listed_products(mob/user)
	return GLOB.cm_vending_walkman

GLOBAL_LIST_INIT(cm_vending_walkman, list(
	list("随身听", -1, null, null),
	list("蓝色磁带", 10, /obj/item/device/cassette_tape/pop1, VENDOR_ITEM_REGULAR),
	list("蓝条纹磁带", 10, /obj/item/device/cassette_tape/hiphop, VENDOR_ITEM_REGULAR),
	list("绿色磁带", 10, /obj/item/device/cassette_tape/nam, VENDOR_ITEM_REGULAR),
	list("海洋磁带", 10, /obj/item/device/cassette_tape/ocean, VENDOR_ITEM_REGULAR),
	list("橙色磁带", 10, /obj/item/device/cassette_tape/pop3, VENDOR_ITEM_REGULAR),
	list("粉色磁带", 10, /obj/item/device/cassette_tape/pop4, VENDOR_ITEM_REGULAR),
	list("彩虹磁带", 10, /obj/item/device/cassette_tape/pop2, VENDOR_ITEM_REGULAR),
	list("红黑磁带", 10, /obj/item/device/cassette_tape/heavymetal, VENDOR_ITEM_REGULAR),
	list("红条纹磁带", 10, /obj/item/device/cassette_tape/hairmetal, VENDOR_ITEM_REGULAR),
	list("旭日磁带", 10, /obj/item/device/cassette_tape/indie, VENDOR_ITEM_REGULAR),
	list("随身听", 50, /obj/item/device/walkman, VENDOR_ITEM_REGULAR),
	list("磁带袋", 15, /obj/item/storage/pouch/cassette, VENDOR_ITEM_REGULAR),

	list("纸牌", -1, null, null),
	list("一副扑克牌", 5, /obj/item/toy/deck, VENDOR_ITEM_REGULAR),
	list("一副UNO牌", 5, /obj/item/toy/deck/uno, VENDOR_ITEM_REGULAR)
))

/obj/structure/machinery/cm_vending/sorted/walkman/stock(obj/item/item_to_stock, mob/user)
	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3])
			if(istype(item_to_stock,/obj/item/device/walkman))
				var/obj/item/device/walkman/W = item_to_stock
				if(W.tape)
					to_chat(user,SPAN_WARNING("先取出磁带！"))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user]向[src]补充了[R[1]]。"),
			SPAN_NOTICE("你向[src]补充了[R[1]]。"))
			R[2]++
			updateUsrDialog()
			return //We found our item, no reason to go on.
