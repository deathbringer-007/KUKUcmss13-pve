

// Surgery Tools
/obj/item/tool/surgery
	icon = 'icons/obj/items/surgery_tools.dmi'
	/// reduced
	attack_speed = 4

/*
 * Retractor
 * Usual substitutes: crowbar for heavy prying, wirecutter for fine adjustment. Fork for extremely fine work.
 */
/obj/item/tool/surgery/retractor
	name = "牵开器"
	desc = "用于牵开组织。"
	icon_state = "retractor"
	matter = list("metal" = 10000, "glass" = 5000)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL

/obj/item/tool/surgery/retractor/predatorretractor
	name = "撑开器"
	desc = "用于牵开组织。"
	icon_state = "predator_retractor"

/*
 * Hemostat
 * Usual substitutes: wirecutter for clamping bleeds or pulling things out, fork for extremely fine work, surgical line/fixovein/cable coil for tying up blood vessels.
 */
/obj/item/tool/surgery/hemostat
	name = "止血钳"
	desc = "你觉得自己以前见过这东西。"
	icon_state = "hemostat"
	matter = list("metal" = 5000, "glass" = 2500)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_SMALL

	attack_verb = list("攻击", "夹击")

/obj/item/tool/surgery/hemostat/miniature
	name = "微型止血钳"
	desc = "用于极其精细的操作。"
	icon_state = "hemostat_mini"
	matter = list("metal" = 1000, "glass" = 500)
	w_class = SIZE_TINY

/obj/item/tool/surgery/hemostat/predatorhemostat
	name = "夹钳"
	desc = "你觉得自己以前见过这东西。"
	icon_state = "predator_hemostat"

/*
 * Cautery
 * Usual substitutes: cigarettes, lighters, welding tools.
 */
/obj/item/tool/surgery/cautery
	name = "烧灼器"
	desc = "用于止血。"
	icon_state = "cautery"
	matter = list("metal" = 5000, "glass" = 2500)
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_TINY
	flags_item = ANIMATED_SURGICAL_TOOL

	attack_verb = list("灼烧")

/obj/item/tool/surgery/cautery/predatorcautery
	name = "烧灼器"
	desc = "用于止血。"
	icon_state = "predator_cautery"
	flags_item = NO_FLAGS

/*
 * Surgical Drill
 * Usual substitutes: pen, metal rods.
 */
/obj/item/tool/surgery/surgicaldrill
	name = "手术钻"
	desc = "用它就能钻孔。懂了吧？"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list("metal" = 15000, "glass" = 10000)
	flags_atom = FPRINT|CONDUCT
	force = 0
	w_class = SIZE_SMALL

	attack_verb = list("钻击")

/obj/item/tool/surgery/surgicaldrill/predatorsurgicaldrill
	name = "骨钻"
	desc = "用它就能钻孔。懂了吧？"
	icon_state = "predator_drill"

/*
 * Scalpel
 * Usual substitutes: bayonets, kitchen knives, glass shards.
 */
/obj/item/tool/surgery/scalpel
	name = "手术刀"
	desc = "切开，切开，再切开。"
	icon_state = "scalpel"
	flags_atom = FPRINT|CONDUCT
	force = 10
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = 1
	demolition_mod = 0.1
	w_class = SIZE_TINY
	throwforce = 5
	flags_item = CAN_DIG_SHRAPNEL
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 10000, "glass" = 5000)

	attack_verb = list("攻击", "劈砍", "刺击", "切割", "撕裂", "撕扯", "剁砍", "割伤")

/obj/item/tool/surgery/scalpel/predatorscalpel
	name = "切割刀"
	desc = "切开，切开，再切开。"
	icon_state = "predator_scalpel"

/*
 * Researchable Scalpels
 */
/obj/item/tool/surgery/scalpel/laser
	name = "原型激光手术刀"
	desc = "配备定向激光的手术刀，可在切开组织时控制出血，也可充当烧灼器。这把看起来是个不太可靠的早期型号。"
	icon_state = "scalpel_laser"
	damtype = "fire"
	flags_item = ANIMATED_SURGICAL_TOOL
	///The likelihood an incision made with this will be bloodless.
	var/bloodlessprob = 60
	black_market_value = 25

/obj/item/tool/surgery/scalpel/laser/improved
	name = "激光手术刀"
	desc = "配备定向激光的手术刀，可在切开组织时控制出血，也可充当烧灼器。这把看起来可靠，不过还有改进的空间。"
	icon_state = "scalpel_laser_2"
	damtype = "fire"
	force = 12
	bloodlessprob = 80
	black_market_value = 35

/obj/item/tool/surgery/scalpel/laser/advanced
	name = "先进激光手术刀"
	desc = "配备定向激光的手术刀，可在切开组织时控制出血，也可充当烧灼器。这把堪称精密能量刀具的巅峰之作！"
	icon_state = "scalpel_laser_3"
	damtype = "fire"
	force = 15
	bloodlessprob = 100

/*
 * Special Variants
 */

/obj/item/tool/surgery/scalpel/pict_system
	name = "\improper PICT 精密切开烧灼系统"
	desc = "精密切开烧灼工具通过高频振动刀刃、激光烧灼和负压吸液系统，精确切断目标组织，同时防止体液渗漏。尽管研发历程坎坷、价格高得吓人，除了复杂的实验性手术以外，它并不比一把二十美元的普通手术刀好用，也无法在全程无出血的情况下完成整道切口。"
	icon_state = "pict_system"
	w_class = SIZE_SMALL
	force = 7.5
	black_market_value = 25

/obj/item/tool/surgery/scalpel/manager
	name = "切口处理系统"
	desc = "这件神奇的器械宛如外科医生身体的延伸，能瞬间完成切口准备，让治疗操作立刻开始。"
	icon_state = "scalpel_manager"
	force = 7.5
	flags_item = ANIMATED_SURGICAL_TOOL
	black_market_value = 25

/*
 * Circular Saw
 * Usual substitutes: fire axes, machetes, hatchets, butcher's knife, bayonet. Bayonet is better than axes etc. for sawing ribs/skull, worse for amputation.
 */

/obj/item/tool/surgery/circular_saw
	name = "圆锯"
	desc = "用于高强度切割。"
	icon_state = "saw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	flags_atom = FPRINT|CONDUCT
	force = 0
	w_class = SIZE_SMALL
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	matter = list("metal" = 20000,"glass" = 10000)
	flags_item = ANIMATED_SURGICAL_TOOL

	attack_verb = list("攻击", "劈砍", "锯割", "割伤")
	sharp = IS_SHARP_ITEM_BIG
	edge = 1

/obj/item/tool/surgery/circular_saw/predatorbonesaw
	name = "骨锯"
	desc = "用于高强度切割。"
	icon_state = "predator_bonesaw"
	flags_item = NO_FLAGS

/*
 * Bone Gel
 * Usual substitutes: screwdriver.
 */

/obj/item/tool/surgery/bonegel
	name = "骨胶瓶"
	desc = "盛装骨胶的容器，需要经常使用专用机器补充。"
	desc_lore = "骨胶是一种质地类似黏土的生物合成仿骨材料，既能修复细微骨裂，也能修复复杂骨折。骨胶无法替代人体骨髓，因此不应用于修复骨缺损。短期内过量使用可能引起急性免疫功能低下或贫血。"
	icon_state = "bone-gel"
	w_class = SIZE_SMALL
	matter = list("plastic" = 7500)
	///base icon state for update_icon() to reference, fixes bonegel/empty
	var/base_icon_state = "bone-gel"
	///percent of gel remaining in container
	var/remaining_gel = 100
	///If gel is used when doing bone surgery
	var/unlimited_gel = FALSE
	///Time it takes per 10% of gel refilled
	var/time_per_refill = 1 SECONDS
	///if the bone gel is actively being refilled
	var/refilling = FALSE

	///How much bone gel is needed to fix a fracture
	var/fracture_fix_cost = 5
	///How much bone gel is needed to mend bones
	var/mend_bones_fix_cost = 5

/obj/item/tool/surgery/bonegel/update_icon()
	. = ..()
	if(remaining_gel >= 100)
		icon_state = base_icon_state
		return
	if(remaining_gel > 50)
		icon_state = "[base_icon_state]_75"
		return
	if(remaining_gel > 25)
		icon_state = "[base_icon_state]_50"
		return
	if(remaining_gel > 0)
		icon_state = "[base_icon_state]_25"
		return
	icon_state = "[base_icon_state]_0"

/obj/item/tool/surgery/bonegel/get_examine_text(mob/user)
	. = ..()
	if(unlimited_gel) //Only show how much gel is left if it actually uses bone gel
		return
	. += "侧面的容量显示器表明，[src]还剩[remaining_gel]%。"
	. += "可以使用仿骨晶格制造机为[src]补充骨胶。"

	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR)) //Know how much you will be using if you can use it
		return
	. += SPAN_NOTICE("修复骨折需要消耗[fracture_fix_cost]%的骨胶。")
	. += SPAN_NOTICE("接合骨骼需要消耗[mend_bones_fix_cost]%的骨胶。")

/obj/item/tool/surgery/bonegel/proc/refill_gel(obj/refilling_obj, mob/user)
	if(unlimited_gel)
		to_chat(user, SPAN_NOTICE("[refilling_obj]拒绝为[src]补充骨胶。"))
		return
	if(remaining_gel >= 100)
		to_chat(user, SPAN_NOTICE("[src]已经装不下更多骨胶了。"))
		return

	if(refilling)
		to_chat(user, SPAN_NOTICE("你已经在使用[refilling_obj]为[src]补充骨胶了。"))
		return
	refilling = TRUE

	while(remaining_gel < 100)
		if(!do_after(user, time_per_refill, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, refilling_obj))
			break
		remaining_gel = clamp(remaining_gel + 10, 0, 100)
		update_icon()
		to_chat(user, SPAN_NOTICE("[refilling_obj]发出提示音，显示“已填充[remaining_gel]%”。"))

	refilling = FALSE
	playsound(refilling_obj, "sound/machines/ping.ogg", 10)
	to_chat(user, SPAN_NOTICE("你从[refilling_obj]中取出了[src]。"))

/obj/item/tool/surgery/bonegel/proc/use_gel(gel_cost)
	if(unlimited_gel)
		return TRUE

	if(remaining_gel < gel_cost)
		return FALSE
	remaining_gel -= gel_cost
	update_icon()
	return TRUE

/obj/item/tool/surgery/bonegel/empty
	remaining_gel = 0
	icon_state = "bone-gel_0"

/obj/item/tool/surgery/bonegel/predatorbonegel
	name = "骨胶枪"
	desc = "内部液体的效果类似骨胶，但所需用量极少，一枚胶囊就能使用几乎无数次。"
	base_icon_state = "predator_bone-gel"
	icon_state = "predator_bone-gel"
	unlimited_gel = TRUE

/*
 * Fix-o-Vein
 * Usual substitutes: surgical line, cable coil, headbands.
 */

/obj/item/tool/surgery/FixOVein
	name = "血管修复器"
	icon_state = "fixovein"
	desc = "用于修复破裂的血管。紧急情况下也可用于重新连接其他组织。"

	force = 0
	throwforce = 1
	matter = list("plastic" = 5000)

	w_class = SIZE_SMALL
	var/usage_amount = 10

/obj/item/tool/surgery/FixOVein/predatorFixOVein
	name = "血管修复器"
	icon_state = "predator_fixovein"

/*
 * Surgical line. Used for suturing wounds, and for some surgeries.
 * Surgical substitutes: fixovein, cable coil.
 */

/obj/item/tool/surgery/surgical_line
	name = "\proper 手术缝合线"
	desc = "一卷军用级手术缝合线，能严密缝合各种伤口。在海上部署时，也能充当结实的钓鱼线。"
	icon_state = "line_brute"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL

/obj/item/tool/surgery/surgical_line/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/suturing, TRUE, FALSE, 2.5, "缝合", "缝合", "被针反复刺扎", "伤口")

/*
 * Synth-graft.
 * No substitutes. Not, strictly speaking, a surgical tool at all, but here for consistency with surgical line.
 */

/obj/item/tool/surgery/synthgraft
	name = "合成皮肤移植剂"
	desc = "用于野战合成皮肤移植的涂敷器。这东西气味难闻，痒得要命，涂上去还很疼，颜色则是 \
		各种肤色平均混合而成的色调，与<i>任何人</i>的肤色都不相配。不过，至少你不用一直待在医务室里。"
	icon_state = "line_burn"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL

/obj/item/tool/surgery/synthgraft/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/suturing, FALSE, TRUE, 2.5, "植皮修复", "植皮修复", "又被烧灼了一遍", "烧伤")

/*
 * Bonesetter.
 * Usual substitutes: wrench.
 */

/obj/item/tool/surgery/bonesetter
	name = "正骨器"
	icon_state = "bonesetter"
	force = 0
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("攻击", "击打", "钝击")
	matter = list("plastic" = 7500)

/obj/item/tool/surgery/bonesetter/predatorbonesetter
	name = "接骨器"
	icon_state = "predator_bonesetter"

/*
WILL BE USED AT A LATER TIME

t. optimisticdude

/obj/item/tool/surgery/handheld_pump
	name = "handheld surgical pump"
	desc = "This sucks. Literally"
	icon_state = "pump"
	force = 0
	throwforce = 9
	throw_speed = SPEED_VERY_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	attack_verb = list("attacked", "hit", "bludgeoned")
	matter = list("plastic" = 7500)
*/

/obj/item/tool/surgery/drapes //Does nothing at present. Might be useful for increasing odds of success.
	name = "手术铺巾"
	desc = "用于在手术开始前覆盖肢体。"
	icon_state = "drapes"
	gender = PLURAL
	w_class = SIZE_SMALL
	flags_item = NOBLUDGEON

/*
 * MEDICOMP TOOLS
 */

/obj/item/tool/surgery/stabilizer_gel
	name = "伤口稳定凝胶瓶"
	desc = "用于稳定伤口，以便进行治疗。"
	icon_state = "stabilizer_gel"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR
	black_market_value = 50

/obj/item/tool/surgery/healing_gun
	name = "愈合枪"
	desc = "用于修复已经稳定的伤口。"
	icon_state = "healing_gun"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR|ANIMATED_SURGICAL_TOOL
	var/loaded  = TRUE
	black_market_value = 50

/obj/item/tool/surgery/healing_gun/update_icon()
	if(loaded)
		icon_state = "healing_gun"
	else
		icon_state = "healing_gun_empty"

/obj/item/tool/surgery/healing_gun/attackby(obj/item/O, mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("你完全不知道该如何将[O]装进[src]！"))
		return
	if(istype(O, /obj/item/tool/surgery/healing_gel))
		if(loaded)
			to_chat(user, SPAN_WARNING("愈合枪里已经装着一枚胶囊了！"))
			return
		user.visible_message(SPAN_NOTICE("[user]将[O]装入[src]。") ,SPAN_NOTICE("你将[O]装入[src]。"))
		playsound(loc, 'sound/items/air_release.ogg',25)
		loaded = TRUE
		update_icon()
		qdel(O)
		return
	return ..()

/obj/item/tool/surgery/healing_gel
	name = "愈合凝胶胶囊"
	desc = "用于补充愈合枪。"
	icon_state = "healing_gel"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR
	black_market_value = 15

/obj/item/tool/surgery/wound_clamp
	name = "伤口夹"
	desc = "用于在治疗后夹闭伤口。"
	icon_state = "wound_clamp"
	force = 0
	throwforce = 1
	w_class = SIZE_SMALL
	flags_item = ITEM_PREDATOR|ANIMATED_SURGICAL_TOOL
	black_market_value = 15


//XENO AUTOPSY TOOL

/obj/item/tool/surgery/WYautopsy
	name = "\improper 维兰德牌自动尸检系统(TM)"
	desc = "让尸检也充满乐趣。无论你发现了什么奇怪的生命体，这个小装置都能在大约30秒内完成整套尸检。"
	icon_state = "scalpel_laser_2"
	damtype = "fire"
	force = 0
	flags_item = ANIMATED_SURGICAL_TOOL
	var/active = 0
	var/resetting = 0//For the reset, to prevent macro-spam abuse

/obj/item/tool/surgery/WYautopsy/verb/reset()
	set category = "角色"
	set name = "重置维兰德-汤谷尸检工具"
	set desc = "在维兰德-汤谷工具发生故障时重置它。"
	set src in usr

	if(!active)
		to_chat(usr, "系统似乎运转正常……")
		return
	if(active)
		resetting = 1
		to_chat(usr, "正在重置工具，需要几秒钟……重置期间请勿尝试使用，否则可能发生故障。")
		while(active) //While keep running until it's reset (in case of lag-spam)
			active = 0 //Sets it to not active
			to_chat(usr, "处理中……")
			spawn(60) // runs a timer before the final check.  timer is longer than autopsy timers.
				if(!active)
					to_chat(usr, "系统重置完成。")
					resetting = 0

/obj/item/tool/surgery/WYautopsy/attack(mob/living/carbon/xenomorph/T as mob, mob/living/user as mob)
/* set category = "Autopsy"
	set name = "Perform Alien Autopsy"
	set src in usr*/
	if(resetting)
		to_chat(usr, "工具正在恢复出厂设置。如果已经等待了一段时间，请尝试再次重置。")
	if(!isxeno(T))
		to_chat(usr, "你他妈是个怪物吗？")
		return
	if(T.health > 0)
		to_chat(usr, "不行。")
		return
	if(active)
		to_chat(usr, "你已经在进行尸检了。")
		return
	if(istype(T, /mob/living/carbon/xenomorph/larva))
		to_chat(usr, "它还太小了……（将在未来更新中支持）")
		return
	active = 1
	var CHECK = user.loc
	playsound(loc, 'sound/weapons/pierce.ogg', 25)
	to_chat(usr, "你开始切开异形……这可能需要一些时间……")
	if(T.health >-100)
		to_chat(usr, "我操，它还活着！它猛地跃起，将你撞倒在地。")
		usr.apply_effect(20, WEAKEN)
		to_chat(T, "剧痛袭来，你猛地跃起，决定在生命的最后时刻用尽剩余的力量杀死[usr]。（约10秒）")
		T.health = T.maxHealth*2 //It's hulk levels of angry.
		active = 0
		spawn (1000) //Around 10 seconds
			T.apply_damage(5000, BRUTE) //to make sure it's DEAD after it's hyper-boost
		return

	switch(T.butchery_progress)
		if(0)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "这操作很困难，你最好别动。")
					return
				to_chat(usr, "你切开了外层的几丁质。")
				new /obj/item/oldresearch/Chitin(T.loc) //This will be 1-3 Chitin eventually (depending on tier)
				new /obj/item/oldresearch/Chitin(T.loc) //This will be 1-3 Chitin eventually (depending on tier)
				T.butchery_progress++
				active = 0
		if(1)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "这操作很困难，你最好别动。")
					return
				to_chat(usr, "你切开了胸腔，取得了一份血液样本。")
				new /obj/item/oldresearch/Blood(T.loc)//This will be a sample of blood eventually
				T.butchery_progress++
				active = 0
		if(2)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "这操作很困难，你最好别动。")
					return
				//to_chat(usr, "You've cut out an intact organ.")
				to_chat(usr, "你切下了一些生物质……")
				new /obj/item/oldresearch/Resin(T.loc)//This will be an organ eventually, based on the caste.
				T.butchery_progress++
				active = 0
		if(3)
			spawn(50)
				if(CHECK != user.loc)
					to_chat(usr, "这操作很困难，你最好别动。")
					return
				to_chat(usr, "你刮出了剩余的生物质。")
				active = 0
				new /obj/item/oldresearch/Resin(T.loc)
				new /obj/effect/decal/remains/xeno(T.loc)
				qdel(T)
