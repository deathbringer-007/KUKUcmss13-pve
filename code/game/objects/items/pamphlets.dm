/obj/item/pamphlet
	name = "技能指导手册"
	desc = "用于快速传授重要知识的小册子。"
	icon = 'icons/obj/items/pamphlets.dmi'
	icon_state = "pamphlet_written"
	item_state = "pamphlet_written"
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	throw_range = 20
	var/datum/character_trait/trait = /datum/character_trait
	var/flavour_text = "你反复阅读手册，学会了一项新技能。"
	var/bypass_pamphlet_limit = FALSE

/obj/item/pamphlet/Initialize()
	. = ..()

	trait = GLOB.character_traits[trait]

/obj/item/pamphlet/attack_self(mob/living/carbon/human/user)
	..()

	if(!can_use(user))
		return
	on_use(user)

	qdel(src)

/obj/item/pamphlet/proc/can_use(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(trait in user.traits)
		to_chat(user, SPAN_WARNING("你已经掌握这些知识了！"))
		return FALSE
	if(user.has_used_pamphlet == TRUE && !bypass_pamphlet_limit)
		to_chat(user, SPAN_WARNING("你已经使用过一本教学手册了！"))
		return FALSE
	return TRUE

/obj/item/pamphlet/proc/on_use(mob/living/carbon/human/user)
	to_chat(user, SPAN_NOTICE(flavour_text))
	trait.apply_trait(user)
	if(!bypass_pamphlet_limit)
		user.has_used_pamphlet = TRUE

/obj/item/pamphlet/skill/medical
	name = "医疗教学手册"
	desc = "用于快速传授关键知识的手册。这本印有医疗徽记。"
	icon_state = "pamphlet_medical"
	trait = /datum/character_trait/skills/medical

/obj/item/pamphlet/skill/engineer
	name = "工兵技能指导手册"
	desc = "用于快速传授重要知识的小册子，封面印有工程标志。"
	icon_state = "pamphlet_construction"
	trait = /datum/character_trait/skills/miniengie

/obj/item/pamphlet/skill/jtac
	name = "JTAC 技能指导手册"
	desc = "用于快速传授重要知识的小册子，封面印着无线电图案。"
	icon_state = "pamphlet_jtac"
	trait = /datum/character_trait/skills/jtac

/obj/item/pamphlet/skill/spotter
	name = "观测员教学手册"
	desc = "用于快速传授关键知识的手册。这本印有双筒望远镜的图案。"
	icon_state = "pamphlet_spotter"
	trait = /datum/character_trait/skills/spotter
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/spotter/can_use(mob/living/carbon/human/user)
	if(user.job != JOB_SQUAD_MARINE)
		to_chat(user, SPAN_WARNING("只有小队步枪手才能使用它。"))
		return
	var/obj/item/card/id/ID = user.get_idcard()
	if(!ID) //not wearing an ID
		to_chat(user, SPAN_WARNING("这样做之前你应该先戴好身份卡。"))
		return FALSE
	if(!ID.check_biometrics(user))
		to_chat(user, SPAN_WARNING("这样做之前你应该先戴好身份卡。"))
		return FALSE

	return ..()

/obj/item/pamphlet/skill/spotter/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "ass"
	user.hud_set_squad()

	var/obj/item/card/id/ID = user.get_idcard()
	ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + "Spotter")
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Spotter")

/obj/item/pamphlet/skill/loader
	name = "装填手技能指导手册"
	desc = "用于快速传授重要知识的小册子，封面印着火箭弹图案。"
	icon_state = "pamphlet_loader"
	trait = /datum/character_trait/skills/loader
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/loader/can_use(mob/living/carbon/human/user)
	if(user.job != JOB_SQUAD_MARINE)
		to_chat(user, SPAN_WARNING("只有小队步枪手才能使用它。"))
		return
	var/obj/item/card/id/ID = user.get_idcard()
	if(!ID) //not wearing an ID
		to_chat(user, SPAN_WARNING("这样做之前你应该先戴好身份卡。"))
		return FALSE
	if(!ID.check_biometrics(user))
		to_chat(user, SPAN_WARNING("这样做之前你应该先戴好身份卡。"))
		return FALSE
	return ..()

/obj/item/pamphlet/skill/loader/on_use(mob/living/carbon/human/user)
	. = ..()
	user.rank_fallback = "load"
	user.hud_set_squad()

	var/obj/item/card/id/ID = user.get_idcard()
	ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + "Loader")
	GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), "Loader")

/obj/item/pamphlet/skill/machinegunner
	name = "重机枪手技能指导手册"
	desc = "用于快速传授重要知识的小册子，封面印有工程和机枪标志。"
	icon_state = "pamphlet_machinegunner"
	trait = /datum/character_trait/skills/engineering
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/powerloader
	name = "动力装载机技能指导手册"
	desc = "用于快速传授重要知识的小册子，封面印有动力装载机标志。标题是《搬货与爆头——卡特彼勒 P-5000 动力装载机实用指南》。"
	icon_state = "pamphlet_powerloader"
	trait = /datum/character_trait/skills/powerloader
	/// it's really not necessary to stop people from learning powerloader skill
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/police
	name = "警务教学手册"
	desc = "用于快速传授关键知识的手册。这本印有无线电图案。"
	icon_state = "pamphlet_jtac"
	trait = /datum/character_trait/skills/police
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/surgery
	name = "外科教学手册"
	desc = "用于快速传授关键知识的手册。这本印有医疗徽记。"
	icon_state = "pamphlet_medical"
	trait = /datum/character_trait/skills/surgery
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/skill/intel
	name = "战地情报教学手册"
	desc = "用于快速传授关键知识的手册。这本印有情报部门徽记。"
	icon_state = "pamphlet_reading"
	trait = /datum/character_trait/skills/intel
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/language
	name = "语言教学手册"
	desc = "懒惰的美国殖民地陆战队口译员用它在现场快速学习新语言。"
	flavour_text = "你阅读手册，学会了一门新语言。"
	bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/language/russian
	name = "《打赌》印刷本"
	desc = "《打赌》是俄罗斯剧作家安东·契诃夫写的一篇短篇小说，讲述律师与银行家的赌约：银行家认定律师无法独居禁闭十五年，许诺他若做到就付给他两百万卢布。知道这篇作品，看来你很有文学修养；既然如此，你怎么还会在美国殖民地陆战队？"
	trait = /datum/character_trait/language/russian

/obj/item/pamphlet/language/japanese
	name = "《流浪佣兵异世界冒险续篇》残页"
	desc = "几张从著名异世界漫画《流浪佣兵异世界冒险续篇》撕下来的书页，讲述一群四处漂泊的自由佣兵被送进奇幻世界的故事。你怎么会知道这个？"
	trait = /datum/character_trait/language/japanese

/obj/item/pamphlet/language/chinese
	name = "《毛主席语录》书页"
	desc = "没有共产党就没有新中国! Pages from the handbook to starting a famine that kills over 100 million of your people. Apparently this will help you learn Chinese."
	trait = /datum/character_trait/language/chinese

/obj/item/pamphlet/language/german
	name = "《九十九个气球》歌词译稿"
	desc = "这些匆匆写就的译稿原本是为营部年度卡拉 OK 之夜准备的，原曲《九十九个气球》是八十年代的德国流行经典。也许你能让它派上更好的用场。"
	trait = /datum/character_trait/language/german

/obj/item/pamphlet/language/spanish
	name = "《拉丁美洲——美洲联盟南部各州速译指南》"
	desc = "这本手册为在地球执行任务的情报军官编写，便于他们与拉丁美洲各州居民交流——尤其适合那些在方言与礼仪课上睡大觉的情报军官。"
	trait = /datum/character_trait/language/spanish

/obj/item/pamphlet/language/filipino
	name = "菲律宾语常用短句"
	desc = "这本手册教你菲律宾语。"
	trait = /datum/character_trait/language/filipino

/obj/item/pamphlet/language/french
	name = "法语常用短句"
	desc = "这本手册教你法语。"
	trait = /datum/character_trait/language/french

/obj/item/pamphlet/language/portuguese
	name = "葡萄牙语常用短句"
	desc = "这本手册教你葡萄牙语。"
	trait = /datum/character_trait/language/portuguese

/obj/item/pamphlet/language/polish
	name = "波兰语常用短句"
	desc = "这本手册教你波兰语。"
	trait = /datum/character_trait/language/polish

/obj/item/pamphlet/language/ruspatois
	name = "俄语土话常用短句"
	desc = "这本手册教你俄语土话。"
	trait = /datum/character_trait/language/ruspatois

/obj/item/pamphlet/language/scandinavian
	name = "斯堪的纳维亚各语言常用短句"
	desc = "这本手册教你斯堪的纳维亚语言。"
	trait = /datum/character_trait/language/scandinavian

//Restricted languages, spawnable for events.

/obj/item/pamphlet/language/yautja
	name = "污渍斑斑的羊皮纸"
	desc = "一张泛黄的旧羊皮纸，上面布满外星文字系统的奇异符文。字母仿佛在你眼前来回移动，自行排列。"
	trait = /datum/character_trait/language/sainja

/obj/item/pamphlet/language/xenomorph
	name = "异种生物学家的档案"
	desc = "一份异种生物学家的文件，详细记录了圈养异形通过发声和信息素进行交流的观察，以及尝试由人类模仿这些信号的笔记。"
	trait = /datum/character_trait/language/xenomorph

/obj/item/pamphlet/language/monkey
	name = "潦草涂鸦"
	gender = PLURAL
	desc = "一张纸，上面粗糙地画着香蕉和各种灵长类动物。大概出自三岁小孩之手——也可能是某个异常聪明的陆战队员。"
	trait = /datum/character_trait/language/primitive


/obj/item/pamphlet/trait
	bypass_pamphlet_limit = TRUE
	/// What trait to give the user
	var/trait_to_give

/obj/item/pamphlet/trait/can_use(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE

	if(HAS_TRAIT(user, trait_to_give))
		to_chat(user, SPAN_WARNING("你已经掌握这些知识了！"))
		return FALSE

	if(!(user.job in JOB_SQUAD_ROLES_LIST))
		to_chat(user, SPAN_WARNING("只有小队步枪手才能使用它。"))
		return FALSE

	if(user.has_used_pamphlet && !bypass_pamphlet_limit)
		to_chat(user, SPAN_WARNING("你已经使用过一本教学手册了！"))
		return FALSE

	return TRUE

/obj/item/pamphlet/trait/on_use(mob/living/carbon/human/user)
	to_chat(user, SPAN_NOTICE(flavour_text))
	ADD_TRAIT(user, trait_to_give, "pamphlet")
	if(!bypass_pamphlet_limit)
		user.has_used_pamphlet = TRUE

/obj/item/pamphlet/trait/vulture
	name = "\improper M707 教学手册"
	desc = "用于快速传授大口径枪械射击及观测知识的手册。"
	icon_state = "pamphlet_vulture"
	trait_to_give = TRAIT_VULTURE_USER
