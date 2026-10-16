/datum/xeno_strain/watcher
	name = FACEHUGGER_WATCHER
	localized_name = "守望者"
	description = "你失去躲藏能力，换取更远的视野。你可以远距离跟踪宿主，等待最佳袭击时机。"
	flavor_description = "只要能提前看见危险，就无须躲藏。"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/xenohide,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_long_range/facehugger,
	)

	behavior_delegate_type = /datum/behavior_delegate/facehugger_watcher

/datum/xeno_strain/watcher/apply_strain(mob/living/carbon/xenomorph/facehugger/huggy)
	huggy.viewsize = 10
	huggy.layer = initial(huggy.layer)

// This has no special effects, it's just here to skip `/datum/behavior_delegate/facehugger_base/on_life()`.
/datum/behavior_delegate/facehugger_watcher
	name = "Watcher Facehugger Behavior Delegate"

/datum/behavior_delegate/facehugger_watcher/on_life()
	// Sap health if we're standing, not on weeds, and not zoomed out
	if(bound_xeno.body_position != STANDING_UP)
		return
	if(bound_xeno.is_zoomed)
		return
	if(locate(/obj/effect/alien/weeds) in get_turf(bound_xeno))
		return
	bound_xeno.adjustBruteLoss(1)
