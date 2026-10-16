




/////////////////////// Hand Labeler ////////////////////////////////


/// meant for use with qdelling/newing things to transfer labels between them
/atom/proc/transfer_label_component(atom/target)
	var/datum/component/label/src_label_component = GetComponent(/datum/component/label)
	if(src_label_component)
		var/target_label_text = src_label_component.label_name
		target.AddComponent(/datum/component/label, target_label_text)

/obj/item/tool/hand_labeler
	name = "手持标签机"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 50
	/// off or on.
	var/mode = 0
	var/label_sound = 'sound/items/component_pickup.ogg'
	var/remove_label_sound = 'sound/items/paper_ripped.ogg'

	matter = list("metal" = 125)

/obj/item/tool/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return

	if(!mode) //if it's off, give up.
		to_chat(user, SPAN_WARNING("[src]还没打开。"))
		return

	if(A == loc) // if placing the labeller into something (e.g. backpack)
		return // don't set a label

	if(!labels_left)
		to_chat(user, SPAN_WARNING("标签用完了。"))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_WARNING("标签文字太长了。"))
		return
	if(isliving(A) || istype(A, /obj/item/holder))
		to_chat(user, SPAN_WARNING("你不能给活物贴标签。"))
		return
	if((istype(A, /obj/item/reagent_container/glass)) && (!(istype(A, /obj/item/reagent_container/glass/minitank))))
		to_chat(user, SPAN_WARNING("标签贴不住[A]，改用笔吧。"))
		return
	if(istype(A, /obj/item/tool/surgery) || istype(A, /obj/item/reagent_container/pill))
		to_chat(user, SPAN_WARNING("那样不卫生。"))
		return
	if((istype(A, /obj/vehicle/multitile)) || (istype(A, /obj/structure))) // disallow naming structures
		to_chat(user, SPAN_WARNING("标签贴不住那东西。"))
		return
	if(isturf(A))
		to_chat(user, SPAN_WARNING("标签贴不住那东西。"))
		return
	if(istype(A, /obj/item/storage/pill_bottle))
		var/obj/item/storage/pill_bottle/target_pill_bottle = A
		target_pill_bottle.choose_color(user)

	if(!label || !length(label))
		remove_label(A, user)
		return

	var/datum/component/label/labelcomponent = A.GetComponent(/datum/component/label)
	if(labelcomponent)
		if(labelcomponent.label_name == label)
			to_chat(user, SPAN_WARNING("它已经贴着相同的标签了。"))
			return

	user.visible_message(SPAN_NOTICE("[user]给[A]贴上了“[label]”的标签。"), \
	SPAN_NOTICE("你给[A]贴上了“[label]”的标签。"))

	log_admin("[user] has labeled [A.name] with label \"[label]\". (CKEY: ([user.ckey]))")

	A.AddComponent(/datum/component/label, label)

	playsound(A, label_sound, 20, TRUE)

	labels_left--

/obj/item/tool/hand_labeler/attack_self(mob/user)
	..()
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("你打开了[src]。"))
		//Now let them choose the text.
		var/str = copytext(reject_bad_text(input(user,"标签上要写什么？", "设置标签", "")), 1, MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("标签文字已清空。现在可以移除标签了。"))
			label = null
			return
		label = str
		to_chat(user, SPAN_NOTICE("你将标签文字设为“[str]”。"))
	else
		to_chat(user, SPAN_NOTICE("你关闭了[src]。"))



/*
	Allow the user of the labeler to remove a label, if there is no text set
	@A object trying to remove the label
	@user the player using the labeler

*/

/obj/item/tool/hand_labeler/proc/remove_label(atom/A, mob/user)
	var/datum/component/label/label = A.GetComponent(/datum/component/label)
	if(label)
		user.visible_message(SPAN_NOTICE("[user]移除了[A]上的标签。"), \
						SPAN_NOTICE("你移除了[A]上的标签。"))
		label.remove_label()
		log_admin("[user] has removed label from [A.name]. (CKEY: ([user.ckey]))")
		playsound(A, remove_label_sound, 20, TRUE)
		return
	else
		to_chat(user, SPAN_NOTICE("没有可移除的标签。"))
		return

/**
	Allow the user to refill the labeller
	@I what is the item trying to be used
	@user what is using paper on the handler
*/

/obj/item/tool/hand_labeler/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/paper))
		if(labels_left != initial(labels_left))
			to_chat(user, SPAN_NOTICE("你将[I]放入[src]。"))
			qdel(I) //delete the paper item
			labels_left = initial(labels_left)
		else
			to_chat(user, SPAN_NOTICE("[src]已经满了。"))

/*
	Instead of updating labels_left to user every label used,
	Have the user examine it to show them.
*/
/obj/item/tool/hand_labeler/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("还剩[labels_left]/[initial(labels_left)]张标签。")
	. += SPAN_HELPFUL("可以用纸补充标签。")


/*
 * Pens
 */
/obj/item/tool/pen
	desc = "一支普通的黑色墨水笔。"
	name = "笔"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "pen"
	item_state = "pen"
	flags_equip_slot = SLOT_WAIST|SLOT_EAR|SLOT_SUIT_STORE
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	matter = list("metal" = 10)
	inherent_traits = list(TRAIT_TOOL_PEN)
	/// what color the ink is!
	var/pen_color = "black"
	var/on = TRUE
	var/clicky = FALSE

/obj/item/tool/pen/attack_self(mob/living/carbon/human/user)
	..()
	on = !on
	to_chat(user, SPAN_WARNING("你咔哒一声[on? "按出了": "收回了"]笔尖。"))
	if(clicky)
		playsound(user.loc, "sound/items/pen_click_[on? "on": "off"].ogg", 100, 1, 5)
	update_pen_state()

/obj/item/tool/pen/Initialize(mapload, ...)
	. = ..()
	update_pen_state()

/obj/item/tool/pen/proc/update_pen_state()
	overlays.Cut()
	if(on)
		overlays += "+[pen_color]_tip"

/obj/item/tool/pen/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!isobj(target))
		return
	var/obj/obj_target = target
	//Changing name/description of items. Only works if they have the OBJ_UNIQUE_RENAME object flag set
	if(proximity_flag && (obj_target.flags_obj & OBJ_UNIQUE_RENAME))
		var/list/pen_choices = list("重命名" = "Rename", "描述" = "Description", "重置" = "Reset")
		var/penchoice = pen_choices[tgui_input_list(user, "你想编辑什么？", "书写工具设置", pen_choices)]
		if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
			return
		if(penchoice == "Rename")
			var/input = tgui_input_text(user, "你想给[target]取什么名字？", "物品名称", "[target.name]", MAX_NAME_LEN)
			var/oldname = target.name
			if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
				return
			if(input == oldname || !input)
				to_chat(user, SPAN_NOTICE("你把[target]改成了……呃……[target]。"))
			else
				msg_admin_niche("[key_name(usr)] changed \the [src]'s name to [input] [ADMIN_JMP(src)]")
				target.AddComponent(/datum/component/rename, input, target.desc)
				var/datum/component/label/label = target.GetComponent(/datum/component/label)
				if(label)
					label.remove_label()
					label.apply_label()
				to_chat(user, SPAN_NOTICE("你成功将[oldname]重命名为[target]。"))
				obj_target.renamedByPlayer = TRUE
				playsound(target, "paper_writing", 15, TRUE)

		if(penchoice == "Description")
			var/input = tgui_input_text(user, "描述[target]", "描述", "[target.desc]", 140)
			var/olddesc = target.desc
			if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
				return
			if(input == olddesc || !input)
				to_chat(user, SPAN_NOTICE("你决定不修改[target]的描述。"))
			else
				msg_admin_niche("[key_name(usr)] changed \the [src]'s description to [input] [ADMIN_JMP(src)]")
				target.AddComponent(/datum/component/rename, target.name, input)
				to_chat(user, SPAN_NOTICE("你成功修改了[target]的描述。"))
				obj_target.renamedByPlayer = TRUE
				playsound(target, "paper_writing", 15, TRUE)

		if(penchoice == "Reset")
			if(QDELETED(target) || !CAN_PICKUP(user, obj_target))
				return

			qdel(target.GetComponent(/datum/component/rename))

			//reapply any label to name
			var/datum/component/label/label = target.GetComponent(/datum/component/label)
			if(label)
				label.remove_label()
				label.apply_label()

			to_chat(user, SPAN_NOTICE("你成功重置了[target]的名称和描述。"))
			obj_target.renamedByPlayer = FALSE

/obj/item/tool/pen/clicky
	desc = "一支按起来格外响亮的黑色墨水笔。"
	clicky = TRUE

/obj/item/tool/pen/blue
	desc = "一支普通的蓝色墨水笔。"
	pen_color = "blue"

/obj/item/tool/pen/blue/clicky
	desc = "一支按起来格外响亮的蓝色墨水笔。"
	clicky = TRUE

/obj/item/tool/pen/red
	desc = "一支普通的红色墨水笔。"
	pen_color = "red"

/obj/item/tool/pen/red/clicky
	desc = "一支按起来格外响亮的红色墨水笔。"
	clicky = TRUE

/obj/item/tool/pen/green
	desc = "一支普通的绿色墨水笔。"
	pen_color = "green"

/obj/item/tool/pen/green/clicky
	desc = "一支按起来格外响亮的绿色墨水笔。"
	clicky = TRUE

/obj/item/tool/pen/invisible
	desc = "一支隐形墨水笔。"
	pen_color = "white"

/obj/item/tool/pen/fountain
	desc = "这支钢笔是设计与实用性的典范，奢华地展示了阿玛特公司的精湛工艺。金色饰边之下藏着精巧的机械结构，只需轻轻一转，就能迅速切换多种墨水颜色。精密工程赋予了每一处机构顺畅、轻松的换色能力，让这件书写工具兼具奢华质感与多样用途。"
	desc_lore = "阿玛特钢笔不仅是一件书写工具，更是美国殖民地海军陆战队（USCM）内部身份与权威的象征。这件传承之物仅颁发给最高层指挥人员，每一支都表达了对获赠者领导能力与奉献精神的敬意。\n \n以武器技术闻名的阿玛特公司，在打造它时走了一条不同的道路。钢笔看似偏离了公司的传统业务，却深深融入了其工程理念，体现着精密、实用与坚固。\n \n金色饰边并非单纯的装饰，更是一种身份标识，让这些钢笔及其主人显得与众不同。黄金与耐用金属精心熔合，使其能够抵御日常磨损。这份坚韧，也象征着殖民地陆战队指挥人员所需的毅力与韧性。\n \n每支钢笔都配备了精巧的换色机构，让使用者能够切换多种墨水颜色。这项功能的灵感来自阿玛特武器的先进瞄准系统，通过微型执行器和精密研磨的零件平稳切换供墨。只需轻轻转动笔身，内部墨囊就会优雅地旋转到位，随时听候使用者的指令。\n \n墨水颜色的选择并非随意。每种颜色都代表殖民地陆战队内部的一个等级，持有者可以使用与自己军衔或书面命令接收者军衔相对应的颜色书写。它无声地彰显文字的权威，仿佛每一笔都在殖民地陆战队的指挥殿堂中回响。\n \n尽管外观华丽，这支钢笔却像阿玛特的任何武器一样坚固，体现了公司对可靠与耐用的坚持。耐腐蚀的金属零件确保它即使面对殖民地陆战队高级指挥人员常处的严苛环境，也能长久使用。\n \n奢华与实用的交融，黄金与金属的结合，展现了指挥者历经磨砺的从容，以及力量与优雅的统一。它不仅是书写工具，更是领导力的象征，是对持有者奉献与力量的嘉奖。阿玛特钢笔彰显着殖民地陆战队最高级军官所具备的严谨、正直与勇气。"
	name = "钢笔"
	icon_state = "fountain_pen"
	item_state = "fountain_pen"
	matter = list("metal" = 20, "gold" = 10)
	var/static/list/color_list = list("red", "blue", "green", "yellow", "purple", "pink", "brown", "black", "orange") // Can add more colors as required
	var/static/list/color_names = list("red" = "红色", "blue" = "蓝色", "green" = "绿色", "yellow" = "黄色", "purple" = "紫色", "pink" = "粉色", "brown" = "棕色", "black" = "黑色", "orange" = "橙色")
	var/current_color_index = 1
	var/owner_name

/obj/item/tool/pen/fountain/pickup(mob/user, silent)
	. = ..()
	if(!owner_name)
		RegisterSignal(user, COMSIG_POST_SPAWN_UPDATE, PROC_REF(set_owner), override = TRUE)

///Sets the owner of the pen to who it spawns with, requires var/source for signals
/obj/item/tool/pen/fountain/proc/set_owner(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_POST_SPAWN_UPDATE)
	var/mob/living/carbon/human/user = source
	owner_name = user.name

/obj/item/tool/pen/fountain/get_examine_text(mob/user)
	. = ..()
	if(owner_name)
		. += "上面用激光刻着[owner_name]的名字。"

/obj/item/tool/pen/fountain/attack_self(mob/living/carbon/human/user)
	if(on)
		current_color_index = (current_color_index % length(color_list)) + 1
		pen_color = color_list[current_color_index]
		balloon_alert(user,"你转动笔身，将墨水颜色切换为[color_names[pen_color]]。")
		if(clicky)
			playsound(user.loc, 'sound/items/pen_click_on.ogg', 100, 1, 5)
		update_pen_state()
	else
		..()

/obj/item/tool/pen/attack(mob/M as mob, mob/user as mob)
	if(!ismob(M))
		return
	to_chat(user, SPAN_WARNING("你用笔刺了[M]。"))
// to_chat(M, SPAN_WARNING("You feel a tiny prick!")) //That's a whole lot of meta!
	M.last_damage_data = create_cause_data(initial(name), user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name] by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to stab [key_name(M)]</font>")
	msg_admin_attack("[key_name(user)] Used the [name] to stab [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
	return


/*
 * Sleepy Pens
 */
/obj/item/tool/pen/sleepypen
	desc = "一支笔尖锋利的黑色墨水笔，上面精细地刻着“华夫公司”。"
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST

/obj/item/tool/pen/sleepypen/Initialize()
	. = ..()
	create_reagents(25)
	reagents.add_reagent("chloralhydrate", 25)

/obj/item/tool/pen/sleepypen/attack(mob/M as mob, mob/user as mob)
	if(!(istype(M,/mob)))
		return
	..()
	if(reagents.total_volume)
		if(M.reagents) reagents.trans_to(M, 50)
	return

/*
 * Parapens
 */
/obj/item/tool/pen/paralysis
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST



/obj/item/tool/pen/paralysis/attack(mob/living/M as mob, mob/user as mob)
	if(!(istype(M)))
		return
	..()
	if(M.can_inject(user, TRUE))
		if(reagents.total_volume)
			if(M.reagents) reagents.trans_to(M, 50)

/obj/item/tool/pen/paralysis/Initialize()
	. = ..()
	create_reagents(50)
	reagents.add_reagent("zombiepowder", 10)
	reagents.add_reagent("cryptobiolin", 15)

/obj/item/tool/stamp
	name = "橡皮印章"
	desc = "用于给重要文件盖章的橡皮印章。"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "stamp-def"
	item_state = "stamp"
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_VERY_FAST
	throw_range = 15
	matter = list("metal" = 60)
	attack_verb = list("盖戳")

/obj/item/tool/stamp/captain
	name = "舰长橡皮印章"
	icon_state = "stamp-cap"

/obj/item/tool/stamp/hop
	name = "人事主管橡皮印章"
	icon_state = "stamp-hop"

/obj/item/tool/stamp/hos
	name = "安保主管橡皮印章"
	icon_state = "stamp-hos"

/obj/item/tool/stamp/ce
	name = "总工程师橡皮印章"
	icon_state = "stamp-ce"

/obj/item/tool/stamp/rd
	name = "研究主管橡皮印章"
	icon_state = "stamp-rd"

/obj/item/tool/stamp/cmo
	name = "首席医疗官橡皮印章"
	icon_state = "stamp-cmo"

/obj/item/tool/stamp/denied
	name = "\improper “驳回”橡皮印章"
	icon_state = "stamp-deny"

/obj/item/tool/stamp/approved
	name = "\improper “批准”橡皮印章"
	icon_state = "stamp-approve"

/obj/item/tool/stamp/clown
	name = "小丑橡皮印章"
	icon_state = "stamp-clown"

/obj/item/tool/stamp/internalaffairs
	name = "内务部橡皮印章"
	icon_state = "stamp-intaff"

/obj/item/tool/stamp/weyyu
	name = "维兰德-汤谷橡皮印章"
	icon_state = "stamp-weyyu"

/obj/item/tool/stamp/uscm
	name = "USCM 橡皮印章"
	icon_state = "stamp-uscm"

/obj/item/tool/stamp/cmb
	name = "殖民地执法局橡皮印章"
	icon_state = "stamp-cmb"

/obj/item/tool/stamp/ro
	name = "军需官橡皮印章"
	icon_state = "stamp-ro"

/obj/item/tool/carpenters_hammer //doesn't do anything, yet
	name = "木工锤"
	icon_state = "carpenters_hammer" //yay, it now has a sprite.
	item_state = "carpenters_hammer"
	desc = "可将钉子敲进木制物品，用于修理。"
