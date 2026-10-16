//I still dont think this should be a closet but whatever
/obj/structure/closet/fireaxecabinet
	name = "消防斧柜"
	desc = "一张小标签写着“仅限紧急情况使用”，旁边附有消防斧的安全使用说明。说得好像有人会遵守似的。"
	var/obj/item/weapon/twohanded/fireaxe/fireaxe = new/obj/item/weapon/twohanded/fireaxe
	icon_state = "fireaxe1000"
	icon_closed = "fireaxe1000"
	icon_opened = "fireaxe1100"
	anchored = TRUE
	density = FALSE
	var/localopened = 0 //Setting this to keep it from behaviouring like a normal closet and obstructing movement in the map. -Agouri
	opened = 1
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0

/obj/structure/closet/fireaxecabinet/attackby(obj/item/O, mob/user)  //Marker -Agouri
	//..() //That's very useful, Erro

	var/hasaxe = 0       //gonna come in handy later~
	if(fireaxe)
		hasaxe = 1

	if (src.locked)
		if(HAS_TRAIT(O, TRAIT_TOOL_MULTITOOL))
			to_chat(user, SPAN_DANGER("正在重置电路……"))
			playsound(user, 'sound/machines/lockreset.ogg', 25, 1)
			if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				src.locked = 0
				to_chat(user, "<span class = 'caution'>你停用了锁定模块。</span>")
				update_icon()
			return
		else if(!(O.flags_item & NOBLUDGEON) && O.force)
			var/obj/item/W = O
			if(src.smashed || src.localopened)
				if(localopened)
					localopened = 0
					icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
					spawn(10) update_icon()
				return
			else
				playsound(user, 'sound/effects/Glasshit.ogg', 25, 1) //We don't want this playing every time
			if(W.force < 15)
				to_chat(user, SPAN_NOTICE("柜子的防护玻璃弹开了这次打击。"))
			else
				src.hitstaken++
				if(src.hitstaken == 4)
					playsound(user, 'sound/effects/Glassbr3.ogg', 50, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
					src.smashed = 1
					src.locked = 0
					src.localopened = 1
			update_icon()
		return
	if (istype(O, /obj/item/weapon/twohanded/fireaxe) && src.localopened)
		if(!fireaxe)
			if(O.flags_item & WIELDED)
				to_chat(user, SPAN_DANGER("请先解除消防斧的双手握持状态。"))
				return
			fireaxe = O
			user.drop_held_item()
			src.contents += O
			to_chat(user, SPAN_NOTICE("你将消防斧放回[src.name]。"))
			update_icon()
		else
			if(src.smashed)
				return
			else
				localopened = !localopened
				if(localopened)
					icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				else
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
	else
		if(src.smashed)
			return
		if(HAS_TRAIT(O, TRAIT_TOOL_MULTITOOL))
			if(localopened)
				localopened = 0
				icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()
				return
			else
				to_chat(user, SPAN_DANGER("正在重置电路……"))
				sleep(50)
				src.locked = 1
				to_chat(user, SPAN_NOTICE("你重新启用了锁定模块。"))
				playsound(user, 'sound/machines/lockenable.ogg', 25, 1)
				if(do_after(user,20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
					src.locked = 1
					to_chat(user, "<span class = 'caution'>你重新启用了锁定模块。</span>")
				return
		else
			localopened = !localopened
			if(localopened)
				icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()
			else
				icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()

/obj/structure/closet/fireaxecabinet/attack_hand(mob/user as mob)
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1
	if(!ishuman(user)) return
	if(src.locked)
		to_chat(user, SPAN_DANGER("柜门纹丝不动！"))
		return
	if(localopened)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(user, SPAN_NOTICE("你从[name]中取出消防斧。"))
			src.add_fingerprint(user)
			update_icon()
		else
			if(src.smashed)
				return
			else
				localopened = !localopened
				if(localopened)
					src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				else
					src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()

	else
		localopened = !localopened //I'm pretty sure we don't need an if(src.smashed) in here. In case I'm wrong and it fucks up teh cabinet, **MARKER**. -Agouri
		if(localopened)
			src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
			spawn(10) update_icon()
		else
			src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
			spawn(10) update_icon()

/obj/structure/closet/fireaxecabinet/verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
	set name = "打开／关闭"
	set category = "物品"

	if (src.locked || src.smashed)
		if(src.locked)
			to_chat(usr, SPAN_DANGER("柜门纹丝不动！"))
		else if(src.smashed)
			to_chat(usr, SPAN_NOTICE("防护玻璃已破碎！"))
		return

	localopened = !localopened
	update_icon()

/obj/structure/closet/fireaxecabinet/verb/remove_fire_axe()
	set name = "取出消防斧"
	set category = "物品"

	if (istype(usr, /mob/living/carbon/xenomorph))
		return

	if (localopened)
		if(fireaxe)
			usr.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(usr, SPAN_NOTICE("你从[name]中取出消防斧。"))
		else
			to_chat(usr, SPAN_NOTICE("[src.name]是空的。"))
	else
		to_chat(usr, SPAN_NOTICE("[src.name]关着。"))
	update_icon()

/obj/structure/closet/fireaxecabinet/attack_remote(mob/user as mob)
	if(src.smashed)
		to_chat(user, SPAN_DANGER("柜子的安全系统已遭破坏。"))
		return
	else
		locked = !locked
		if(locked)
			to_chat(user, SPAN_DANGER("柜门已上锁。"))
		else
			to_chat(user, SPAN_NOTICE("柜门已解锁。"))
		return

/obj/structure/closet/fireaxecabinet/update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1
	icon_state = text("fireaxe[][][][]",hasaxe,src.localopened,src.hitstaken,src.smashed)

/obj/structure/closet/fireaxecabinet/open()
	return

/obj/structure/closet/fireaxecabinet/close()
	return
