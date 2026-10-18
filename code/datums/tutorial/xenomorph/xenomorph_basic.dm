#define WAITING_HEALTH_THRESHOLD 300

/datum/tutorial/xenomorph/basic
	name = "异形——基础"
	desc = "帮助你熟悉异形最基础玩法的教学。"
	icon_state = "xeno"
	tutorial_id = "xeno_basic_1"
	tutorial_template = /datum/map_template/tutorial/s12x12
	starting_xenomorph_type = /mob/living/carbon/xenomorph/drone

// START OF SCRITPING

/datum/tutorial/xenomorph/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()

	xeno.plasma_stored = 0
	xeno.plasma_max = 0
	xeno.melee_damage_lower = 40
	xeno.melee_damage_upper = 40
	xeno.lock_evolve = TRUE

	message_to_player("欢迎来到异形基础教程。你是[xeno.name]，一只工蜂，是虫巢的建设主力。")

	addtimer(CALLBACK(src, PROC_REF(on_stretch_legs)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_stretch_legs()
	message_to_player("工蜂可以承担虫巢的大多数基础工作，例如铺设菌毯、建造、安置异形卵，以及将俘获的人类固定在巢穴中。")
	addtimer(CALLBACK(src, PROC_REF(on_inform_health)), 5 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_inform_health()
	message_to_player("屏幕<b>右侧</b>的绿色图标和角色旁的绿色条表示你的生命值。")
	addtimer(CALLBACK(src, PROC_REF(on_give_plasma)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_give_plasma()
	message_to_player("你已获得<b>等离子体</b>，这是使用技能所需的资源。屏幕<b>右侧</b>的蓝色图标和角色旁的蓝色条表示其储量。")
	xeno.plasma_max = 200
	xeno.plasma_stored = 200
	addtimer(CALLBACK(src, PROC_REF(on_damage_xenomorph)), 15 SECONDS)

/datum/tutorial/xenomorph/basic/proc/on_damage_xenomorph()
	xeno.apply_damage(350)
	xeno.emote("hiss")
	message_to_player("糟糕！你受伤了。注意，绿色生命条变短了。异形站在菌毯上或在菌毯上休息时可以恢复生命值。")
	addtimer(CALLBACK(src, PROC_REF(request_player_plant_weed)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/request_player_plant_weed()
	update_objective("使用刚获得的<b>种植菌毯</b>技能，种下一个菌毯节点。")
	give_action(xeno, /datum/action/xeno_action/onclick/plant_weeds)
	message_to_player("使用屏幕上方的新技能种下菌毯节点，让菌毯扩散。菌毯能让异形恢复生命值和等离子体，还会减慢人类的行动，帮助你对付他们。")
	RegisterSignal(xeno, COMSIG_XENO_PLANT_RESIN_NODE, PROC_REF(on_plant_resinode))

/datum/tutorial/xenomorph/basic/proc/on_plant_resinode()
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_PLANT_RESIN_NODE)
	message_to_player("做得好。使用<b>休息</b>技能或按[retrieve_bind("rest")]，在菌毯上躺下可以更快恢复。")
	message_to_player("我们提高了你的等离子体储量。注意，在菌毯上时等离子体也会自行恢复。")
	give_action(xeno, /datum/action/xeno_action/onclick/xeno_resting)
	update_objective("休息或等待，直到生命值至少达到[WAITING_HEALTH_THRESHOLD]。")
	xeno.plasma_max = 500
	RegisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS, PROC_REF(on_xeno_gain_health))

/datum/tutorial/xenomorph/basic/proc/on_xeno_gain_health()
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS)
	message_to_player("即使在菌毯上，治疗也需要时间。信息素可以加快恢复。现在使用新技能释放“恢复”信息素，提高治疗速度。")
	give_action(xeno, /datum/action/xeno_action/onclick/emit_pheromones)
	update_objective("释放恢复信息素。")
	RegisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES, PROC_REF(on_xeno_emit_pheromone))

/datum/tutorial/xenomorph/basic/proc/on_xeno_emit_pheromone(emitter, pheromone)
	SIGNAL_HANDLER
	if(!(pheromone == "recovery"))
		message_to_player("你释放的不是恢复信息素。再次点击技能停止释放，然后改选<b>恢复</b>。")
	else if(xeno.health > WAITING_HEALTH_THRESHOLD)
		reach_health_threshold()
		UnregisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES)
	else
		UnregisterSignal(xeno, COMSIG_XENO_START_EMIT_PHEROMONES)
		message_to_player("做得好。恢复信息素可以大幅加快生命值恢复。休息或等待，直到生命值至少达到[WAITING_HEALTH_THRESHOLD]。")
		message_to_player("信息素也会作用于附近的异形姐妹！")
		RegisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS, PROC_REF(reach_health_threshold))

/datum/tutorial/xenomorph/basic/proc/reach_health_threshold()
	SIGNAL_HANDLER
	if(xeno.health < WAITING_HEALTH_THRESHOLD)
		return

	UnregisterSignal(xeno, COMSIG_XENO_ON_HEAL_WOUNDS)

	message_to_player("很好，做得不错。")
	message_to_player("一名敌对人类，也就是“高个宿主”，出现了。使用<b>伤害意图</b>，在近战中杀死他！")
	update_objective("杀死人类！")

	var/mob/living/carbon/human/human_dummy = new(loc_from_corner(7,7))
	add_to_tracking_atoms(human_dummy)
	add_highlight(human_dummy, COLOR_RED)
	RegisterSignal(human_dummy, COMSIG_MOB_DEATH, PROC_REF(on_human_death_phase_one))

/datum/tutorial/xenomorph/basic/proc/on_human_death_phase_one()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)

	UnregisterSignal(human_dummy, COMSIG_MOB_DEATH)
	message_to_player("做得好。杀死人类是帮助虫巢的方式之一。")
	message_to_player("另一种方式是<b>俘获</b>他们。新异形会在他们体内生长，最终破胸而出，成为新的可玩异形！")
	update_objective("")
	addtimer(CALLBACK(human_dummy, TYPE_PROC_REF(/mob/living, rejuvenate)), 8 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(proceed_to_tackle_phase)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/proceed_to_tackle_phase()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	remove_highlight(human_dummy)
	RegisterSignal(human_dummy, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(on_tackle_phase_human_damage))
	RegisterSignal(human_dummy, COMSIG_MOB_TACKLED_DOWN, PROC_REF(proceed_to_cap_phase))
	message_to_player("使用<b>缴械意图</b>把人类扑倒。工蜂最多可能需要尝试四次。")
	update_objective("把人类扑倒！")

/datum/tutorial/xenomorph/basic/proc/on_tackle_phase_human_damage(source, damagedata)
	SIGNAL_HANDLER
	if(damagedata["damage"] <= 0)
		return
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	// Rejuvenate the dummy if it's less than half health so our player can't kill it and softlock themselves.
	if(human_dummy.health < (human_dummy.maxHealth / 2))
		message_to_player("不要伤害人类！")
		human_dummy.rejuvenate()

/datum/tutorial/xenomorph/basic/proc/proceed_to_cap_phase()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)

	UnregisterSignal(human_dummy, COMSIG_MOB_TACKLED_DOWN)

	ADD_TRAIT(human_dummy, TRAIT_KNOCKEDOUT, TRAIT_SOURCE_TUTORIAL)
	ADD_TRAIT(human_dummy, TRAIT_FLOORED, TRAIT_SOURCE_TUTORIAL)
	xeno.melee_damage_lower = 0
	xeno.melee_damage_upper = 0
	message_to_player("做得好。通常你需要持续扑倒人类，才能让其无法起身。不过在本教程中，他会一直保持倒地。")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(cap_phase)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/cap_phase()
	var/obj/effect/alien/resin/special/eggmorph/morpher = new(loc_from_corner(2,2), GLOB.hive_datum[XENO_HIVE_TUTORIAL])
	morpher.stored_huggers = 1
	add_to_tracking_atoms(morpher)
	add_highlight(morpher, COLOR_YELLOW)
	message_to_player("西南方有一座卵化器。点击卵化器，取出一只<b>抱脸虫</b>。")
	update_objective("从卵化器取出一只抱脸虫。")
	RegisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, PROC_REF(take_facehugger_phase))

/datum/tutorial/xenomorph/basic/proc/take_facehugger_phase(source, hugger)
	SIGNAL_HANDLER
	UnregisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/effect/alien/resin/special/eggmorph, morpher)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	add_to_tracking_atoms(hugger)
	remove_highlight(morpher)

	add_highlight(hugger, COLOR_YELLOW)
	message_to_player("这是一只抱脸虫，已用黄色高亮标出。点击它将其拿起。")
	message_to_player("站在倒地的人类旁边，点击人类将抱脸虫放到他脸上。也可以把抱脸虫放在附近，看它自动跃向人类的脸。")
	update_objective("让抱脸虫感染人类。")
	RegisterSignal(hugger, COMSIG_PARENT_QDELETING, PROC_REF(on_hugger_deletion))
	RegisterSignal(human_dummy, COMSIG_HUMAN_IMPREGNATE, PROC_REF(nest_cap_phase), override = TRUE)

/datum/tutorial/xenomorph/basic/proc/on_hugger_deletion(hugger)
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/obj/effect/alien/resin/special/eggmorph, morpher)
	morpher.stored_huggers = 1
	add_highlight(morpher, COLOR_YELLOW)
	message_to_player("点击卵化器，取出一只<b>抱脸虫</b>。")
	update_objective("从卵化器取出一只抱脸虫。")
	RegisterSignal(xeno, COMSIG_XENO_TAKE_HUGGER_FROM_MORPHER, PROC_REF(take_facehugger_phase))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/mask/facehugger, hugger)
	UnregisterSignal(human_dummy, COMSIG_MOB_TAKE_DAMAGE)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_IMPREGNATE)
	UnregisterSignal(hugger, COMSIG_PARENT_QDELETING)
	remove_highlight(hugger)

	message_to_player("我们应该把被感染的人类固定在巢穴中，防止其逃走。")
	message_to_player("人类无法独自逃出巢穴，巢穴也能让他们维持生命，直到我们的新姐妹破胸而出。")
	update_objective("")
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_two)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_two()

	loc_from_corner(8,0).ChangeTurf(/turf/closed/wall/resin/tutorial)
	loc_from_corner(8,1).ChangeTurf(/turf/closed/wall/resin/tutorial)
	loc_from_corner(9,1).ChangeTurf(/turf/closed/wall/resin/tutorial)

	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_three)), 5 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_three()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	message_to_player("使用抓取意图抓住人类，或按住Ctrl点击人类。")
	update_objective("使用抓取意图或Ctrl加点击抓住人类。")
	RegisterSignal(human_dummy, COMSIG_MOVABLE_XENO_START_PULLING, PROC_REF(nest_cap_phase_four))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_four()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOVABLE_XENO_START_PULLING)
	message_to_player("做得好。现在选中手里的抓取图标，再点击自己的角色，吞下人类。整个过程中不要移动。")
	update_objective("手持抓取图标点击自己，吞下抓住的人类。")
	RegisterSignal(human_dummy, COMSIG_MOB_DEVOURED, PROC_REF(nest_cap_phase_five))

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_five()
	SIGNAL_HANDLER
	message_to_player("做得好。你可以用刚获得的新技能将人类吐出。")
	message_to_player("小心，真正的玩家可能会反抗，试图从内部切开你的身体逃脱！")
	give_action(xeno, /datum/action/xeno_action/onclick/regurgitate)
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_six)), 15 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_six()
	message_to_player("只能在<b>虫巢菌毯</b>上将人类固定成巢。这种特殊菌毯由虫巢核心或虫巢团块等建筑生成。")
	message_to_player("我们已在东南方布置好虫巢菌毯和墙壁。")
	addtimer(CALLBACK(src, PROC_REF(nest_cap_phase_seven)), 10 SECONDS)

/datum/tutorial/xenomorph/basic/proc/nest_cap_phase_seven()
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_DEVOURED)
	RegisterSignal(human_dummy, COMSIG_MOB_NESTED, PROC_REF(on_mob_nested))
	message_to_player("将俘获的人类固定成巢！")
	update_objective("将俘获的人类固定成巢！")
	message_to_player("把人类拖到墙边，让自己和人类都紧挨着墙壁。")
	message_to_player("选中手中的抓取图标，再点击墙壁；也可以用鼠标把人类拖到墙上。整个过程中不要移动。")
	new /obj/effect/alien/resin/special/cluster(loc_from_corner(9,0), GLOB.hive_datum[XENO_HIVE_TUTORIAL])

/datum/tutorial/xenomorph/basic/proc/on_mob_nested()
	SIGNAL_HANDLER
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_MOB_NESTED)

	message_to_player("做得好。异形基础教程到此结束。")
	message_to_player("教程即将结束。")
	tutorial_end_in(10 SECONDS)

// END OF SCRIPTING

/datum/tutorial/xenomorph/basic/init_map()
	loc_from_corner(9,0).ChangeTurf(/turf/closed/wall/resin/tutorial)

#undef WAITING_HEALTH_THRESHOLD
