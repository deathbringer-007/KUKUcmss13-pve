/obj/item/paper_bin
	name = "纸盒"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	throwforce = 1
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_VERY_FAST
	throw_range = 7
	layer = LOWER_ITEM_LAYER
	var/amount = 30 //How much paper is in the bin.
	var/list/papers = new/list() //List of papers put in the bin for reference.
	var/list/paper_types = list("Carbon-Copy", "Company Document")
	var/sec_paper_type = "Carbon-Copy"

/obj/item/paper_bin/wy
	sec_paper_type = "Company Document"

/obj/item/paper_bin/uscm
	sec_paper_type = "USCM Document"
	paper_types = list("Carbon-Copy", "USCM Document")

/obj/item/paper_bin/MouseDrop(atom/over_object)
	if(over_object == usr && ishuman(usr) && !usr.is_mob_restrained() && !usr.stat && (loc == usr || in_range(src, usr)))
		if(!usr.get_active_hand()) //if active hand is empty
			usr.put_in_hands(src)
	return

/obj/item/paper_bin/attack_hand(mob/user)
	var/response = ""
	if(!length(papers) > 0)
		var/list/paper_labels = list("Regular" = "普通纸", "Carbon-Copy" = "复写纸", "Company Document" = "公司文件", "USCM Document" = "USCM 文件", "Cancel" = "取消")
		var/selection = alert(user, "请选择纸张类型。", "选择纸张类型", paper_labels["Regular"], paper_labels[sec_paper_type] || sec_paper_type, paper_labels["Cancel"])
		for(var/paper_key in paper_labels)
			if(paper_labels[paper_key] == selection)
				response = paper_key
				break
		if (response != "Regular" && response != "Carbon-Copy" && response != "Company Document" && response != "USCM Document")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/paper/P
		if(length(papers) > 0) //If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[length(papers)]
			papers.Remove(P)
		else
			if (response == "Regular")
				P = new /obj/item/paper
			else if (response == "Carbon-Copy")
				P = new /obj/item/paper/carbon
			else if (response == "Company Document")
				P = new /obj/item/paper/wy
			else if (response == "USCM Document")
				P = new /obj/item/paper/uscm



		P.forceMove(user.loc)
		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("你从[src]中取出了[P]。"))
	else
		to_chat(user, SPAN_NOTICE("[src]是空的！"))

	add_fingerprint(user)
	return


/obj/item/paper_bin/attackby(obj/item/paper/i as obj, mob/user as mob)
	if(!istype(i))
		return

	if(user.drop_inv_item_to_loc(i, src))
		to_chat(user, SPAN_NOTICE("你将[i]放入[src]。"))
		papers.Add(i)
		amount++


/obj/item/paper_bin/get_examine_text(mob/user)
	if(amount)
		return list(SPAN_NOTICE("纸盒中有 [amount] 张纸。"))
	else
		return list(SPAN_NOTICE("纸盒中没有纸了。"))


/obj/item/paper_bin/update_icon()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"

/obj/item/paper_bin/verb/set_paper_type()
	set name = "切换纸张类型"
	set category = "物品"
	set src in view(1)
	var/response = ""
	var/list/paper_labels = list("Carbon-Copy" = "复写纸", "Company Document" = "公司文件", "USCM Document" = "USCM 文件", "Cancel" = "取消")
	var/selection = alert(usr, "请选择纸张类型。", "选择纸张类型", paper_labels[paper_types[1]] || paper_types[1], paper_labels[paper_types[2]] || paper_types[2], paper_labels["Cancel"])
	for(var/paper_key in paper_labels)
		if(paper_labels[paper_key] == selection)
			response = paper_key
			break
	if (response != "Carbon-Copy" && response != "Company Document" && response != "USCM Document")
		return
	sec_paper_type = response

/// Relic from the days of cyborgs, kept for flavour, an handheld paper
/// dispenser that was supposed to print pre-filled forms but never did.
/obj/item/form_printer
	name = "出纸器"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"

/obj/item/form_printer/attack(mob/living/carbon/M, mob/living/carbon/user)
	return

/obj/item/form_printer/afterattack(atom/target, mob/living/user, flag, params)
	if(!target || !flag)
		return

	if(istype(target,/obj/structure/surface/table))
		deploy_paper(get_turf(target))

/obj/item/form_printer/attack_self(mob/user)
	..()
	deploy_paper(get_turf(src))

/obj/item/form_printer/proc/deploy_paper(turf/T)
	T.visible_message(SPAN_NOTICE("[src.loc]送出一张挺括的白纸。"))
	new /obj/item/paper(T)
