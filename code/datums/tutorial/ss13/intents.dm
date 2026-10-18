/datum/tutorial/ss13/intents
	name = "空间站13——意图"
	desc = "学习意图交互系统的运作方式。"
	icon_state = "intents"
	tutorial_id = "ss13_intents_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// START OF SCRIPTING

/datum/tutorial/ss13/intents/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("本教程介绍空间站13的<b>意图</b>系统。右下角高亮的界面图标表示你当前的意图。")
	var/datum/hud/human/human_hud = tutorial_mob.hud_used
	add_highlight(human_hud.action_intent)

	addtimer(CALLBACK(src, PROC_REF(require_help)), 4.5 SECONDS)

/datum/tutorial/ss13/intents/proc/require_help()
	tutorial_mob.a_intent_change(INTENT_DISARM)
	message_to_player("你现在不处于<b>帮助</b>意图。按<b>[retrieve_bind("select_help_intent")]</b>切换回帮助意图。")
	update_objective("按[retrieve_bind("select_help_intent")]切换到帮助意图。")

	RegisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE, PROC_REF(on_help_intent))

/datum/tutorial/ss13/intents/proc/on_help_intent(datum/source, new_intent)
	SIGNAL_HANDLER

	if(new_intent != INTENT_HELP)
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_INTENT_CHANGE)

	var/mob/living/carbon/human/dummy/tutorial/tutorial_dummy = new(loc_from_corner(2, 3))
	add_to_tracking_atoms(tutorial_dummy)

	message_to_player("第一种是<b>帮助</b>意图，用于友善地触碰他人、灭火或进行心肺复苏等。点击<b>训练假人</b>，拍拍它的背。")
	update_objective("使用帮助意图点击假人。")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_help_attack))

/datum/tutorial/ss13/intents/proc/on_help_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HELP))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	tutorial_dummy.status_flags = DEFAULT_MOB_STATUS_FLAGS
	REMOVE_TRAIT(tutorial_dummy, TRAIT_IMMOBILIZED, TRAIT_SOURCE_TUTORIAL)
	tutorial_dummy.anchored = FALSE

	message_to_player("第二种是<b>缴械</b>意图，按<b>[retrieve_bind("select_disarm_intent")]</b>选择。缴械可以推搡他人，使其掉落物品或摔倒。推搡<b>训练假人</b>，直到它倒地。")
	update_objective("按[retrieve_bind("select_disarm_intent")]切换到缴械意图，把假人推倒。")

	RegisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT, PROC_REF(on_shove_down))

/datum/tutorial/ss13/intents/proc/on_shove_down(datum/source, datum/status_effect/new_effect)
	SIGNAL_HANDLER

	if(!istype(new_effect, /datum/status_effect/incapacitating/knockdown))
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_LIVING_APPLY_EFFECT)
	tutorial_dummy.rejuvenate()

	message_to_player("第三种是<b>抓取</b>意图。抓取分为被动抓取、强力抓取和锁喉。连续抓取可以提升抓取强度。对<b>训练假人</b>进行强力抓取。")
	update_objective("连续抓取假人两次，进行强力抓取。")


	RegisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED, PROC_REF(on_aggrograb))

/datum/tutorial/ss13/intents/proc/on_aggrograb(datum/source, mob/living/carbon/human/choker)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	UnregisterSignal(tutorial_dummy, COMSIG_MOB_AGGRESSIVELY_GRABBED)

	message_to_player("最后一种是<b>伤害</b>意图，用拳头或近战武器伤害他人。空手点击<b>训练假人</b>，挥拳攻击。")
	update_objective("空手攻击假人。")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN, PROC_REF(on_harm_attack))

/datum/tutorial/ss13/intents/proc/on_harm_attack(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if((attacked_mob == src) || (tutorial_mob.a_intent != INTENT_HARM))
		return

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_ATTACKHAND_HUMAN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/dummy/tutorial, tutorial_dummy)
	tutorial_dummy.status_flags = GODMODE

	message_to_player("很好。意图系统的基础操作到此介绍完毕。本教程即将结束。")
	update_objective("")

	tutorial_end_in(5 SECONDS, TRUE)

// END OF SCRIPTING
// START OF SCRIPT HELPERS



// END OF SCRIPT HELPERS

/datum/tutorial/ss13/intents/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 0))
