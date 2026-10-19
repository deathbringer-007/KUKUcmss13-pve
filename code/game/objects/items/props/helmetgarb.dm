// Holds props for helmet garb

/obj/item/prop/helmetgarb
	icon = 'icons/obj/items/helmet_garb.dmi'
	icon_state = null
	w_class = SIZE_TINY
	garbage = TRUE

/obj/item/prop/helmetgarb/Initialize(mapload, ...)
	. = ..()
	if(garbage)
		flags_obj |= OBJ_IS_HELMET_GARB

/obj/item/prop/helmetgarb/gunoil
	name = "枪械润滑油"
	desc = "一瓶给枪用的润滑油。别听传言，M41A 绝不是会自动清洁的枪械。"
	icon_state = "gunoil"

/obj/item/prop/helmetgarb/netting
	name = "战斗伪装网"
	desc = "大概是头盔用的战斗伪装网，也可能是给阿尔迈耶号那群不存在的厨师多订的发网。大概没什么用。"
	icon_state = "netting"

/obj/item/prop/helmetgarb/spent_buckshot
	name = "已击发的鹿弹壳"
	desc = "三枚经典鹿弹的空弹壳。你知道它们以前会被涂成绿色吗？真是个奇怪的年代。"
	icon_state = "spent_buckshot"

/obj/item/prop/helmetgarb/spent_slug
	name = "已击发的独头弹壳"
	gender = PLURAL
	desc = "当你需要凭借强大的停止作用击倒目标时，就该用上它们了。不过这三枚已经打过了。"
	icon_state = "spent_slug"

/obj/item/prop/helmetgarb/spent_flech
	name = "已击发的箭弹壳"
	desc = "这种弹药打得越多，你就越觉得一颗破片手榴弹也许能更有效地达到同样的目的。话说，这些东西不是应该从枪里抛出来吗？"
	icon_state = "spent_flech"

/obj/item/prop/helmetgarb/cartridge
	name = "变形弹头"
	desc = "这是一枚71式脉冲步枪弹头，撞上装甲表面后发生了变形，如今只能当作幸运纪念品。"
	icon_state = "cartridge"

/obj/item/prop/helmetgarb/prescription_bottle
	name = "处方药瓶"
	desc = "抗焦虑药？安非他命？治疗突发性睡眠障碍的药？标签已经看不清了，瓶子也已空空如也，里面曾装过什么将永远是个谜。瓶盖拧得比任何身份识别锁都紧。"
	icon_state = "prescription_bottle"

/obj/item/prop/helmetgarb/raincover
	name = "防雨罩"
	desc = "标准 M10 战斗头盔本就能在 10 米水深下防水。这东西或许能让顶部彻底防水，至少总比没有好。"
	icon_state = "raincover"

/obj/item/prop/helmetgarb/camocover
	name = "丛林头盔罩"
	desc = "套在 M10 式头盔顶部的罩布，无需涂漆即可实现伪装。"
	icon_state = "camocover"

/obj/item/prop/helmetgarb/camocover/snow
	name = "雪地头盔罩"
	icon_state = "s_camocover"

/obj/item/prop/helmetgarb/camocover/desert
	name = "沙漠头盔罩"
	icon_state = "d_camocover"

/obj/item/prop/helmetgarb/rabbitsfoot
	name = "幸运兔脚"
	desc = "能给你带来好运，却没给那只兔子带来好运。对它来说，这东西可没帮上什么忙。"
	icon_state = "rabbitsfoot"

/obj/item/prop/helmetgarb/rosary
	name = "玫瑰念珠"
	desc = "耶稣拯救世人！"
	icon_state = "rosary"

/obj/item/prop/helmetgarb/lucky_feather
	name = "\improper 红色幸运羽毛"
	desc = "一根红得扎眼的羽毛，由劣质塑料和合成纤维制成。你懂的，和每位公司联络员的脊梁骨用的是同一种材料。"
	icon_state = "lucky_feather"
	color = "red"

/obj/item/prop/helmetgarb/lucky_feather/blue
	name = "\improper 蓝色幸运羽毛"
	desc = "颜色鲜亮的蓝色羽毛。你觉得自己也许曾在全息剧院里见过一只蓝松鸦。"
	color = "blue"

/obj/item/prop/helmetgarb/lucky_feather/purple
	name = "\improper 紫色幸运羽毛"
	desc = "颜色张扬的紫色羽毛。据说一个名叫“莎士比亚”的空间站AI模拟了1000只敲打乱码的猴子，试图重现真正的莎士比亚作品。艺术评论家们还在争论，这算不算首个真正由人工智能创作的抽象艺术作品。"
	color = "purple"

/obj/item/prop/helmetgarb/lucky_feather/yellow
	name = "\improper 黄色幸运羽毛"
	desc = "颜色顽强的黄色羽毛。据说新堪萨斯殖民地的人均木匠数量，在美洲联盟控制的所有殖民地中名列第一。"
	color = "yellow"

#define NVG_SHAPE_COSMETIC 1
#define NVG_SHAPE_BROKEN 2
#define NVG_SHAPE_PATCHED 3
#define NVG_SHAPE_FINE 4

/obj/item/prop/helmetgarb/helmet_nvg
	name = "\improper M2 夜视仪"
	desc = "殖民地陆战队军用制式 M2 夜视仪，需要电池才能工作。"
	icon_state = "nvg"
	gender = PLURAL
	garbage = FALSE
	w_class = SIZE_MEDIUM
	flags_obj = OBJ_NO_HELMET_BAND

	var/nvg_maxhealth = 125
	var/nvg_health = 125

	/// How much charge the cell should have at most. -1 is infinite
	var/cell_max_charge = 2500

	var/activated = FALSE
	var/nightvision = FALSE
	var/shape = NVG_SHAPE_FINE

	var/active_powered_icon_state = "nvg_down_powered"
	var/active_icon_state = "nvg_down"
	var/inactive_icon_state = "nvg"

	var/datum/action/item_action/activation
	var/obj/item/clothing/head/attached_item
	var/mob/living/attached_mob
	var/lighting_alpha = 100

/obj/item/prop/helmetgarb/helmet_nvg/Initialize(mapload, ...)
	. = ..()
	if(shape != NVG_SHAPE_COSMETIC)
		AddComponent(/datum/component/cell, cell_max_charge, TRUE, charge_drain = 8)
		RegisterSignal(src, COMSIG_CELL_TRY_RECHARGING, PROC_REF(cell_try_recharge))
		RegisterSignal(src, COMSIG_CELL_OUT_OF_CHARGE, PROC_REF(on_power_out))

/obj/item/prop/helmetgarb/helmet_nvg/on_enter_storage(obj/item/storage/internal/S)
	..()

	if(!istype(S))
		return

	remove_attached_item()

	var/obj/item/MO = S.master_object
	if(!istype(MO, /obj/item/clothing/head/helmet/marine) && !istype(MO, /obj/item/clothing/head/cmcap)) // Do not bother if it's not a helmet or at least a hat
		return

	attached_item = MO

	RegisterSignal(attached_item, COMSIG_PARENT_QDELETING, PROC_REF(remove_attached_item))
	RegisterSignal(attached_item, COMSIG_ITEM_EQUIPPED, PROC_REF(toggle_check))

	if(ismob(attached_item.loc))
		set_attached_mob(attached_item.loc)


/obj/item/prop/helmetgarb/helmet_nvg/attackby(obj/item/A as obj, mob/user as mob)
	if(HAS_TRAIT(A, TRAIT_TOOL_SCREWDRIVER))
		repair(user)

	else
		..()

/obj/item/prop/helmetgarb/helmet_nvg/proc/cell_try_recharge(datum/source, mob/living/user)
	SIGNAL_HANDLER

	if(user.action_busy)
		return COMPONENT_CELL_NO_RECHARGE

	if(src != user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("你必须将[src]拿在手中才能为其充电。"))
		return COMPONENT_CELL_NO_RECHARGE

	if(shape == NVG_SHAPE_COSMETIC)
		to_chat(user, SPAN_WARNING("[src]内部没有电池接口。"))
		return COMPONENT_CELL_NO_RECHARGE

	if(shape == NVG_SHAPE_BROKEN)
		to_chat(user, SPAN_WARNING("你需要先修好[src]。"))
		return COMPONENT_CELL_NO_RECHARGE


/obj/item/prop/helmetgarb/helmet_nvg/proc/repair(mob/user as mob)
	if(user.action_busy)

		return
	if(src != user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("你必须将[src]拿在手中才能修理。"))
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE)) // level 2 is enough to repair damaged NVG
		to_chat(user, SPAN_WARNING("你没有接受过电子设备维修训练……"))
		return

	if(shape == NVG_SHAPE_BROKEN)
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED)) // level 3 is needed to repair broken NVG
			to_chat(user, SPAN_WARNING("这种复杂的维修对你来说太难了，找个受过更多训练的人来吧。"))
			return

		to_chat(user, "你开始修理[src]。")
		if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			to_chat(user, SPAN_WARNING("你被打断了。"))
			return
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		color = "#bebebe"
		shape = NVG_SHAPE_PATCHED
		to_chat(user, "你成功地临时修补了[src]。")
		nvg_maxhealth = 65
		nvg_health = 65
		return

	else if(nvg_health == nvg_maxhealth)
		if(shape == NVG_SHAPE_PATCHED)
			to_chat(user, SPAN_WARNING("已经修补过了，你无法再做更多了。"))
		else if(shape == NVG_SHAPE_FINE)
			to_chat(user, SPAN_WARNING("没有需要修理的地方。"))
		else if(shape == NVG_SHAPE_COSMETIC)

			to_chat(user, SPAN_WARNING("它如今只剩下一个空壳。"))

	else
		to_chat(user, "你开始修理[src]。")
		if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD, src))
			to_chat(user, "你成功修好了[src]。")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			nvg_health = nvg_maxhealth
		else
			to_chat(user, SPAN_WARNING("你被打断了。"))


/obj/item/prop/helmetgarb/helmet_nvg/get_examine_text(mob/user)
	. = ..()

	if(shape == NVG_SHAPE_BROKEN)
		. += "它似乎坏了。也许有能力的人能把它修好。"
	else

		if(shape == NVG_SHAPE_PATCHED)
			. += "它满是划痕，还留有最近维修过的痕迹。"

		var/nvg_health_procent = nvg_health / nvg_maxhealth * 100
		if(nvg_health_procent > 70)
			. += "它看起来状态良好。"
		else if(nvg_health_procent > 50)
			. += "它有明显的损伤。"
		else if(nvg_health_procent > 30)
			. += "它恐怕经不起更多损伤了。"
		else if(nvg_health_procent >= 0)
			. += "它快要散架了。"

/obj/item/prop/helmetgarb/helmet_nvg/on_exit_storage(obj/item/storage/S)
	remove_attached_item()
	return ..()


/obj/item/prop/helmetgarb/helmet_nvg/proc/set_attached_mob(mob/User)
	attached_mob = User
	activation = new /datum/action/item_action/toggle(src, attached_item)
	activation.give_to(attached_mob)
	add_verb(attached_mob, /obj/item/prop/helmetgarb/helmet_nvg/proc/toggle)
	RegisterSignal(attached_mob, COMSIG_HUMAN_XENO_ATTACK, PROC_REF(break_nvg))
	RegisterSignal(attached_item, COMSIG_ITEM_DROPPED, PROC_REF(remove_attached_mob))

/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_attached_item()
	SIGNAL_HANDLER

	if(!attached_item)
		return
	UnregisterSignal(attached_item, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_ITEM_EQUIPPED
	))

	if(activated)
		activated = FALSE
		icon_state = inactive_icon_state

	remove_attached_mob()
	attached_item = null

/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_attached_mob()
	UnregisterSignal(attached_item, COMSIG_ITEM_DROPPED)
	qdel(activation)
	if(!attached_mob)
		return
	UnregisterSignal(attached_mob, list(
		COMSIG_HUMAN_XENO_ATTACK,
		COMSIG_MOB_CHANGE_VIEW
	))
	remove_verb(attached_mob, /obj/item/prop/helmetgarb/helmet_nvg/proc/toggle)
	remove_nvg()
	attached_mob = null

/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle_check(obj/item/I, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER

	if(attached_mob != user && slot == WEAR_HEAD)
		set_attached_mob(user)

	if(slot == WEAR_HEAD && !nightvision && activated && !SEND_SIGNAL(src, COMSIG_CELL_CHECK_CHARGE) && shape > NVG_SHAPE_BROKEN)
		enable_nvg(user)
	else
		remove_nvg()


/obj/item/prop/helmetgarb/helmet_nvg/proc/enable_nvg(mob/living/carbon/human/user)
	if(nightvision)
		remove_nvg()

	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(update_sight))

	user.add_client_color_matrix("nvg", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string("#7aff7a")))
	user.overlay_fullscreen("nvg", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("nvg_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	playsound(user, 'sound/handling/toggle_nv1.ogg', 25)
	nightvision = TRUE
	user.update_sight()

	icon_state = active_powered_icon_state
	attached_item.update_icon()
	activation.update_button_icon()

	SEND_SIGNAL(src, COMSIG_CELL_START_TICK_DRAIN)


/obj/item/prop/helmetgarb/helmet_nvg/proc/update_sight(mob/M)
	SIGNAL_HANDLER

	if(lighting_alpha < 255)
		M.see_in_dark = 12
	M.lighting_alpha = lighting_alpha
	M.sync_lighting_plane_alpha()


/obj/item/prop/helmetgarb/helmet_nvg/proc/remove_nvg()
	SIGNAL_HANDLER

	if(!attached_mob)
		return

	if(nightvision)
		attached_mob.remove_client_color_matrix("nvg", 1 SECONDS)
		attached_mob.clear_fullscreen("nvg", 0.5 SECONDS)
		attached_mob.clear_fullscreen("nvg_blur", 0.5 SECONDS)
		playsound(attached_mob, 'sound/handling/toggle_nv2.ogg', 25)
		nightvision = FALSE

		UnregisterSignal(attached_mob, COMSIG_HUMAN_POST_UPDATE_SIGHT)

		if(activated)
			icon_state = active_icon_state
			attached_item.update_icon()
			activation.update_button_icon()

		attached_mob.update_sight()

		SEND_SIGNAL(src, COMSIG_CELL_STOP_TICK_DRAIN)


/obj/item/prop/helmetgarb/helmet_nvg/process(delta_time)
	if(!attached_mob)
		return PROCESS_KILL

	if(!activated || !attached_item || attached_mob.is_dead())
		on_power_out()
		return

	if(!attached_item.has_garb_overlay())
		to_chat(attached_mob, SPAN_WARNING("[src]被遮住时，你无法使用它。"))
		remove_nvg()
		return


/obj/item/prop/helmetgarb/helmet_nvg/proc/on_power_out(datum/source)
	SIGNAL_HANDLER

	if(activated && !attached_mob.is_dead())
		to_chat(attached_mob, SPAN_WARNING("[src]发出低电量警告，随即关闭！"))
	remove_nvg()

/obj/item/prop/helmetgarb/helmet_nvg/ui_action_click(mob/owner, obj/item/holder)
	toggle_nods(owner)


/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle()
	set category = "Object"
	set name = "Toggle M2 night vision goggles"

	var/obj/item/clothing/head/helmet/marine/H = usr.get_item_by_slot(WEAR_HEAD)
	if(istype(H))
		for(var/obj/item/prop/helmetgarb/helmet_nvg/G in H.pockets.contents)
			G.toggle_nods(usr)
			break


/obj/item/prop/helmetgarb/helmet_nvg/proc/toggle_nods(mob/living/carbon/human/user)
	if(user.is_mob_incapacitated())
		return

	if(!attached_item)
		return

	if(!attached_item.has_garb_overlay())
		to_chat(user, SPAN_WARNING("[src]被遮住时，你无法使用它。"))
		return

	if(user.client.view > 7 && shape != NVG_SHAPE_COSMETIC)
		to_chat(user, SPAN_WARNING("使用其他光学设备时，你无法使用[src]。"))
		return

	activated = !activated

	if(activated)
		to_chat(user, SPAN_NOTICE("你放下了夜视仪。"))
		icon_state = active_icon_state
		if(!SEND_SIGNAL(src, COMSIG_CELL_CHECK_CHARGE) && user.head == attached_item && shape > NVG_SHAPE_BROKEN)
			enable_nvg(user)
		else
			icon_state = active_icon_state
			attached_item.update_icon()
			activation.update_button_icon()

		if(shape != NVG_SHAPE_COSMETIC)
			RegisterSignal(user, COMSIG_MOB_CHANGE_VIEW, PROC_REF(change_view)) // will flip non-cosmetic nvgs back up when zoomed

	else
		to_chat(user, SPAN_NOTICE("你将[src]推回头盔上方。"))

		icon_state = inactive_icon_state
		attached_item.update_icon()
		activation.update_button_icon()

		remove_nvg()
		UnregisterSignal(user, COMSIG_MOB_CHANGE_VIEW)

/obj/item/prop/helmetgarb/helmet_nvg/proc/change_view(mob/M, new_size)
	SIGNAL_HANDLER

	if(new_size > 7) // cannot use binos with NVG
		toggle_nods(M)

/obj/item/prop/helmetgarb/helmet_nvg/proc/break_nvg(mob/living/carbon/human/user, list/slashdata, mob/living/carbon/xenomorph/Xeno) //xenos can break NVG if aim head
	SIGNAL_HANDLER

	if(check_zone(Xeno.zone_selected) == "head" && user == attached_mob)
		nvg_health -= slashdata["n_damage"] // damage can be adjusted here
	if(nvg_health <= 0)
		nvg_health = 0
		user.visible_message(SPAN_WARNING("[user]头上的[src]发出一阵碎裂声，坏掉了。"),
			SPAN_WARNING("你的[src.name]发出一阵碎裂声，坏掉了。"),
			SPAN_WARNING("你听见一阵碎裂声，像是头盔里的什么东西坏了。"))
		playsound(user, "bone_break", 30, TRUE)
		src.color = "#4e4e4e"
		if(shape != NVG_SHAPE_COSMETIC)
			shape = NVG_SHAPE_BROKEN
		var/obj/item/clothing/head/helmet/marine/H = attached_item
		H.pockets.remove_from_storage(src, get_turf(H))

/obj/item/prop/helmetgarb/helmet_nvg/cosmetic //for "custom loadout", purely cosmetic
	name = "旧式 M2 夜视仪"
	desc = "这副夜视仪的电子元件全被拆光了，已经无法工作。不过，它能让你显得很有战术范儿，而这才是最重要的，对吧？"
	shape = NVG_SHAPE_COSMETIC
	garbage = TRUE

/obj/item/prop/helmetgarb/helmet_nvg/cosmetic/break_nvg(mob/living/carbon/human/user, list/slashdata, mob/living/carbon/xenomorph/Xeno)
	return

/obj/item/prop/helmetgarb/helmet_nvg/cosmetic/larp //something that better fits for the USCM
	name = "旧式 M1 多光谱面罩"
	desc = "殖民地陆战队下一代抬头显示光学设备的失败原型，后来被现役一体式红外目镜取代。这副可放下面罩提供完整的多光谱功能。它确实很酷，直到你意识到，头上只要挨一下，夜视功能就可能报废。"
	icon_state = "larp"
	active_powered_icon_state = "larp_down_powered"
	active_icon_state = "larp_down"
	inactive_icon_state = "larp"


/obj/item/prop/helmetgarb/helmet_nvg/marsoc //for Marine Raiders
	name = "\improper 战术型 M3 夜视仪"
	desc = "内置可自行充电的电池，没什么能阻挡你。把它装到头盔上，按下按钮，就可以行动了。"
	cell_max_charge = -1

#undef NVG_SHAPE_COSMETIC
#undef NVG_SHAPE_BROKEN
#undef NVG_SHAPE_PATCHED
#undef NVG_SHAPE_FINE

/obj/item/prop/helmetgarb/flair_initech
	name = "\improper 伊尼科技装饰徽章"
	desc = "地球上一家古怪科技公司的装饰徽章。他们是怎么把宣传品送到这么偏远的边境来的？"
	icon_state = "flair_initech"

/obj/item/prop/helmetgarb/flair_io
	name = "\improper 木卫一装饰徽章"
	desc = "大角星人如今也许已是我们的盟友，但木卫一事件永远是跨物种关系上的污点。永远不要忘记那些在多拉明号上牺牲的人。"
	icon_state = "flair_io"

/obj/item/prop/helmetgarb/flair_peace
	name = "\improper 和平装饰徽章"
	desc = "只要是大角星人就无所谓，宝贝。"
	icon_state = "flair_peace_smiley"

/obj/item/prop/helmetgarb/flair_uscm
	name = "USCM 装饰徽章"
	desc = "征兵办公室像发糖一样发这些徽章。陆战队员，自豪地戴上吧。"
	icon_state = "flair_uscm"

/obj/item/prop/helmetgarb/spacejam_tickets
	name = "\improper 《空中大灌篮》门票"
	desc = "两张原版、挺括的橙色门票，对应独一无二的2181年《空中大灌篮》。那可真是一场盛会。"
	icon_state = "tickets_to_space_jam"

/obj/item/prop/helmetgarb/riot_shield
	name = "RC6 防暴盾牌"
	desc = "与 RC6 防暴头盔配套、但单独出售的面盾。"
	icon_state = "helmet_riot_shield"
	flags_obj = OBJ_NO_HELMET_BAND

/obj/item/prop/helmetgarb/trimmed_wire
	name = "磨平尖刺的带刺铁丝"
	desc = "一段磨掉了大部分尖刺的带刺铁丝，可以安全拿取。"
	icon_state = "trimmed_wire"

/obj/item/prop/helmetgarb/bullet_pipe
	name = "10×99毫米 XM43E1 弹壳烟斗"
	desc = "XM43E1 是殖民地陆战队和维兰德-汤谷私人军事承包商小队曾短暂列装的实验武器平台，由阿玛特系统公司在阿特拉斯武器设施制造。遗憾的是，它与 M5 一体式防毒面具项目一同遭到撤资。这个空弹壳被改造成了烟斗，但烟嘴里积满焦油，已经无法使用。"
	icon_state = "bullet_pipe"

/obj/item/prop/helmetgarb/chaplain_patch
	name = "\improper 殖民地陆战队军牧头盔布章"
	desc = "这枚布章是阿尔迈耶号军牧部门及其军牧们最后的遗物。他们在“泰肯擒摔”行动中遭受损失，如今部门与军牧都已不复存在。"
	icon_state = "chaplain_patch"
	flags_obj = OBJ_NO_HELMET_BAND

/obj/item/prop/helmetgarb/family_photo
	name = "全家福"
	desc = ""
	icon = 'icons/obj/items/items.dmi'
	icon_state = "photo"
	///The human who spawns with the photo
	var/datum/weakref/owner
	///The belonging human name
	var/owner_name
	///The belonging human faction
	var/owner_faction
	///Text written on the back
	var/scribble

/obj/item/prop/helmetgarb/family_photo/pickup(mob/user, silent)
	. = ..()
	if(!owner)
		RegisterSignal(user, COMSIG_POST_SPAWN_UPDATE, PROC_REF(set_owner), override = TRUE)


///Sets the owner of the family photo to the human it spawns with, needs var/source for signals
/obj/item/prop/helmetgarb/family_photo/proc/set_owner(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_POST_SPAWN_UPDATE)
	var/mob/living/carbon/human/user = source
	owner = WEAKREF(user)
	owner_name = user.name
	owner_faction = user.faction

/obj/item/prop/helmetgarb/family_photo/get_examine_text(mob/user)
	. = ..()
	if(scribble)
		. += "照片背面写着：“[scribble]”。"
	if(user.weak_reference == owner)
		. += "一张你与你家人的合影。"
		return
	if(user.faction == owner_faction)
		. += "一张[owner_name]与其家人的合影。"
		return
	. += "一张陌生人的全家福。"

/obj/item/prop/helmetgarb/family_photo/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_PEN) || istype(attacking_item, /obj/item/toy/crayon))
		if(scribble)
			to_chat(user, SPAN_NOTICE("[src]上已经写过字了。"))
			return
		var/new_text = copytext(strip_html(tgui_input_text(user, "你想在[src]背面写些什么？", "照片题字")), 1, 128)

		if(!loc == user)
			to_chat(user, SPAN_NOTICE("你必须拿着[src]才能在上面写字。"))
			return
		if(!user.stat == CONSCIOUS)
			to_chat(user, SPAN_NOTICE("你现在的状态无法在[src]上写字。"))
			return
		scribble = new_text
		playsound(src, "paper_writing", 15, TRUE)
	return TRUE

/obj/item/prop/helmetgarb/compass
	name = "指南针"
	desc = "它总是指向北方。你确定没坏吗？"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "compass"
	w_class = SIZE_SMALL

/obj/item/prop/helmetgarb/compass/get_examine_text(mob/user)
	. = ..()
	if(is_ground_level(user.z) && !SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_IN_SPACE])
		. += SPAN_NOTICE("你似乎正朝向[localized_player_label(dir2text(user.dir))]。")
		return
	. += SPAN_NOTICE("指针没有转动。")

/obj/item/prop/helmetgarb/bug_spray
	name = "驱虫剂"
	desc = "一瓶商店自有品牌的驱虫剂，可以让各种害虫和蚊子远离你。"
	icon = 'icons/obj/items/spray.dmi'
	icon_state = "pestspray"
	w_class = SIZE_SMALL

/obj/item/prop/helmetgarb/eye_drops
	name = "滴眼液"
	desc = "一小瓶润眼液，让你的眼睛保持湿润、运转正常。"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "eye_drops"
	COOLDOWN_DECLARE(last_eye_drops)

/obj/item/prop/helmetgarb/eye_drops/attack_self(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, last_eye_drops))
		return
	user.visible_message(SPAN_NOTICE("[user]往眼睛里滴了几滴滴眼液。"), SPAN_NOTICE("你往眼睛里滴了几滴滴眼液。"))
	user.apply_effect(5, EYE_BLUR)
	COOLDOWN_START(src, last_eye_drops, 2.5 SECONDS)
