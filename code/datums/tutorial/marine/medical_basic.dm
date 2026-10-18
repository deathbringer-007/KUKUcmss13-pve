/datum/tutorial/marine/medical_basic
	name = "陆战队员——医疗基础"
	desc = "学习处理陆战队员可能遇到的常见伤势。"
	tutorial_id = "marine_medical_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/marine/medical_basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("本教程介绍扮演陆战队员时需要掌握的医疗基础知识。")
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/brute_tutorial()
	message_to_player("第一种伤害是最常见的<b>蛮力伤害</b>，代表拳击、武器或枪弹等造成的物理创伤。")
	var/mob/living/living_mob = tutorial_mob
	living_mob.adjustBruteLoss(10)
	addtimer(CALLBACK(src, PROC_REF(brute_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/brute_tutorial_2()
	message_to_player("切换到帮助意图后空手点击自己，就能检查自己是否受到<b>蛮力伤害</b>或<b>烧伤</b>。")
	update_objective("空手点击自己。")
	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_health_examine))

/datum/tutorial/marine/medical_basic/proc/on_health_examine(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob != tutorial_mob)
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	message_to_player("很好。现在你受到了一些蛮力伤害。<b>比卡定</b>能逐渐治疗蛮力伤害。拿起<b>比卡定EZ自动注射器</b>，在手中使用。")
	update_objective("用比卡定注射器给自己注射。")
	var/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use/brute_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(brute_injector)
	add_highlight(brute_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_brute_inject))

/datum/tutorial/marine/medical_basic/proc/on_brute_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless/one_use, brute_injector)
	remove_highlight(brute_injector)
	message_to_player("所有药物在注射后都需要时间生效。接下来是<b>烧伤</b>，酸液和火焰等都可能造成这种伤害。")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.adjustFireLoss(10)
	addtimer(CALLBACK(src, PROC_REF(burn_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/burn_tutorial()
	message_to_player("<b>克洛坦</b>能逐渐治疗烧伤。用<b>克洛坦EZ自动注射器</b>给自己注射。")
	update_objective("用克洛坦注射器给自己注射。")
	var/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use/burn_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(burn_injector)
	add_highlight(burn_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_burn_inject))


/datum/tutorial/marine/medical_basic/proc/on_burn_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless/one_use, burn_injector)
	remove_highlight(burn_injector)
	message_to_player("很好。通常受伤时你也会感到<b>疼痛</b>。疼痛会减慢你的行动，若不处理，还可能让你昏迷。")
	update_objective("")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(PAIN_CHESTBURST_STRONG)
	addtimer(CALLBACK(src, PROC_REF(pain_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/pain_tutorial()
	message_to_player("<b>曲马多</b>可以缓解疼痛。用<b>曲马多EZ自动注射器</b>给自己注射。")
	update_objective("用曲马多注射器给自己注射。")
	var/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use/pain_injector = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pain_injector)
	add_highlight(pain_injector)
	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(on_pain_inject))

/datum/tutorial/marine/medical_basic/proc/on_pain_inject(datum/source, obj/item/reagent_container/hypospray/injector)
	SIGNAL_HANDLER

	if(!istype(injector, /obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless/one_use, pain_injector)
	remove_highlight(pain_injector)
	message_to_player("很好。注意药物也会过量，短时间内不要反复注射同一种药物。战地注射器可以使用3次。")
	update_objective("切勿用药过量！通常连续注射同一种药物3次就会导致过量。")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.apply_pain(-PAIN_CHESTBURST_STRONG) // just to make sure
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/bleed_tutorial()
	message_to_player("枪弹或抓伤等有时会让你<b>出血</b>。失血会不断造成<b>缺氧伤害</b>，最终导致死亡。")
	update_objective("")
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	mob_chest.add_bleeding(damage_amount = 15)
	addtimer(CALLBACK(src, PROC_REF(bleed_tutorial_2)), 4 SECONDS)

/datum/tutorial/marine/medical_basic/proc/bleed_tutorial_2()
	message_to_player("出血伤口可能逐渐自行凝血，也可以用<b>纱布</b>迅速止血。拿起纱布，瞄准自己的<b>胸部</b>并点击自己。")
	update_objective("用纱布包扎胸部，或等待伤口自行凝血。")
	var/obj/item/stack/medical/bruise_pack/two/bandage = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(bandage)
	add_highlight(bandage)
	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	RegisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING, PROC_REF(on_chest_bleed_stop))

/datum/tutorial/marine/medical_basic/proc/on_chest_bleed_stop(datum/source, external, internal)
	SIGNAL_HANDLER

	// If you exit on this step, your limbs get deleted, which stops the bleeding, which progresses the tutorial despite it ending
	if(!tutorial_mob || QDELETED(src))
		return

	var/mob/living/carbon/human/human_mob = tutorial_mob
	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in human_mob.limbs
	UnregisterSignal(mob_chest, COMSIG_LIMB_STOP_BLEEDING)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/stack/medical/bruise_pack/two, bandage)
	remove_from_tracking_atoms(bandage)
	remove_highlight(bandage)
	qdel(bandage)

	message_to_player("很好。有时子弹或碎骨会作为<b>异物</b>留在体内，持续造成伤害。拿起<b>刀</b>并在手中使用，取出异物。")
	update_objective("在手中使用刀，取出体内异物。")
	var/mob/living/living_mob = tutorial_mob
	living_mob.pain.feels_pain = FALSE

	var/obj/item/attachable/bayonet/knife = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(knife)
	add_highlight(knife)

	var/obj/item/shard/shrapnel/tutorial/shrapnel = new
	shrapnel.on_embed(tutorial_mob, mob_chest, TRUE)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_SHRAPNEL_REMOVED, PROC_REF(on_shrapnel_removed))

/datum/tutorial/marine/medical_basic/proc/on_shrapnel_removed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SHRAPNEL_REMOVED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/attachable/bayonet, knife)
	remove_highlight(knife)
	message_to_player("很好。陆战队医疗基础教程到此结束，教程即将关闭。")
	update_objective("教程已完成。")
	tutorial_end_in(5 SECONDS)

// END OF SCRIPTING
// START OF SCRIPT HELPERS

// END OF SCRIPT HELPERS

/datum/tutorial/marine/medical_basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)


/datum/tutorial/marine/medical_basic/init_map()
	new /obj/structure/surface/table/almayer(loc_from_corner(0, 4))
