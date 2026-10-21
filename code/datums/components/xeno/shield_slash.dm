/datum/component/shield_slash
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/stat_name
	var/max_shield = 160
	var/shield_per_slash = 20
	var/stored_shield = 0

/datum/component/shield_slash/Initialize(max_shield = 160, shield_per_slash = 20, stat_name = "护盾")
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

	src.max_shield = max_shield
	src.shield_per_slash = shield_per_slash
	src.stat_name = stat_name

/datum/component/shield_slash/RegisterWithParent()
	RegisterSignal(parent, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF, PROC_REF(handle_shield_buildup))
	RegisterSignal(parent, COMSIG_XENO_APPEND_TO_STAT, PROC_REF(handle_stat_display))

/datum/component/shield_slash/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF,
		COMSIG_XENO_APPEND_TO_STAT
	))

/datum/component/shield_slash/PostTransfer()
	if(!isxeno(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/shield_slash/proc/handle_stat_display(mob/living/carbon/xenomorph/X, list/statdata)
	SIGNAL_HANDLER
	statdata += "已积蓄[localized_player_label(stat_name)]：[stored_shield]/[max_shield]"

/datum/component/shield_slash/proc/handle_shield_buildup(mob/living/carbon/xenomorph/X)
	SIGNAL_HANDLER
	stored_shield += shield_per_slash
	if(stored_shield < max_shield)
		return
	X.add_xeno_shield(max_shield, XENO_SHIELD_SOURCE_GENERIC)
	X.visible_message(SPAN_XENOWARNING("[X] 一边咆哮一边撕咬目标，外骨骼短暂地闪烁了一下！"), SPAN_XENOHIGHDANGER("你感到怒火增强了自己的抗伤能力！"))
	X.xeno_jitter(1 SECONDS)
	X.flick_heal_overlay(2 SECONDS, "#FFA800")
	X.emote("roar")
	stored_shield = 0
