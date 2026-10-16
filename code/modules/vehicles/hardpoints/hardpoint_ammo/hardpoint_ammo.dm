//Special ammo magazines for hardpoint modules. Some aren't here since you can use normal magazines on them
/obj/item/ammo_magazine/hardpoint
	flags_magazine = 0 //No refilling

/obj/item/ammo_magazine/hardpoint/attackby(obj/item/O, mob/user)
	if(O.type != type)
		to_chat(user, SPAN_WARNING("你需要另一个[initial(name)]才能转移弹药。"))
		return

	transfer_ammo(O, user)

/obj/item/ammo_magazine/hardpoint/transfer_ammo(obj/item/ammo_magazine/source, mob/user)
	if(current_rounds == max_rounds)
		to_chat(user, SPAN_WARNING("[src]已经装满了。"))
		return

	if(source.current_rounds == 0)
		to_chat(user, SPAN_WARNING("[source]是空的，换一个吧。"))
		return

	if(source.caliber != caliber) //Are they the same caliber?
		to_chat(user, SPAN_WARNING("弹药类型不符。"))
		return

	user.visible_message(SPAN_WARNING("[user]开始为[src]补充弹药。"), SPAN_WARNING("你开始为[src]补充弹药。"))

	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		user.visible_message(SPAN_WARNING("[user]停止为[src]补充弹药。"), SPAN_WARNING("你停止为[src]补充弹药。"))
		return

	var/S = min(max_rounds - current_rounds, source.current_rounds)

	source.current_rounds -= S
	current_rounds += S
	source.update_icon()
	update_icon()
	user.visible_message(SPAN_WARNING("[user]为[src]补充好了弹药。"), SPAN_WARNING("你为[src]补充好了弹药。弹药数：[current_rounds]。"))
