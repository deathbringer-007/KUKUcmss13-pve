//Procedures in this file: Synth head reattachment
//////////////////////////////////////////////////////////////////
//   REATTACHING ROBOHEAD //
//////////////////////////////////////////////////////////////////

/datum/surgery/head_reattach
	name = "合成人头部接合术"
	priority = SURGERY_PRIORITY_MAXIMUM
	possible_locs = list("head")
	invasiveness = list(SURGERY_DEPTH_SURFACE)
	pain_reduction_required = NONE
	required_surgery_skill = SKILL_SURGERY_TRAINED
	steps = list(
		/datum/surgery_step/peel_skin,
		/datum/surgery_step/reattach_head,
		/datum/surgery_step/mend_connections,
		/datum/surgery_step/cauterize/reposition_flesh,
	)
	requires_bodypart = FALSE
	requires_bodypart_type = LIMB_DESTROYED
	pain_reduction_required = NONE
	var/obj/item/limb/head/synth/patient_head
	var/no_revive = FALSE
	var/list/species_allowed = list(
		SYNTH_COLONY,
		SYNTH_COLONY_GEN_ONE,
		SYNTH_COLONY_GEN_TWO,
		SYNTH_COMBAT,
		SYNTH_GEN_ONE,
		SYNTH_GEN_TWO,
		SYNTH_GEN_THREE,
		SYNTH_INFILTRATOR,
		SYNTH_WORKING_JOE
		)

/datum/surgery/head_reattach/can_start(mob/user, mob/living/carbon/human/patient, obj/limb/L, obj/item/tool)
	if(patient.species.name in species_allowed)
		return TRUE
	return FALSE

//------------------------------------

/datum/surgery_step/peel_skin
	name = "翻开皮肤"
	desc = "翻开皮肤"
	//Tools used to pry things open without orthopedic dramatics.
	tools = list(
		/obj/item/tool/surgery/retractor = SURGERY_TOOL_MULT_IDEAL,
		/obj/item/tool/surgery/hemostat = SURGERY_TOOL_MULT_SUBOPTIMAL,
		/obj/item/tool/crowbar = SURGERY_TOOL_MULT_SUBSTITUTE,
		/obj/item/tool/wirecutters = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/maintenance_jack = SURGERY_TOOL_MULT_BAD_SUBSTITUTE,
		/obj/item/tool/kitchen/utensil/fork = SURGERY_TOOL_MULT_AWFUL,
	)
	time = 4 SECONDS

/datum/surgery_step/peel_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	//No need for to-patient messages on this one, they're ghosted or in the head.
	user.visible_message(SPAN_NOTICE("[user]开始用[tool]翻开[target]颈部断端的皮肤。") , \
	SPAN_NOTICE("你开始用[tool]翻开[target]颈部断端的皮肤。"))

	log_interact(user, target, "[key_name(user)] began to peel back tattered skin around [key_name(target)]'s neck with \the [tool].")

/datum/surgery_step/peel_skin/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user]将[target]颈部断端参差不齐的皮肉翻了开来。"), \
	SPAN_NOTICE("你将[target]颈部断端参差不齐的皮肉翻了开来。"))

	surgery.affected_limb.setAmputatedTree()
	target.update_body()

	log_interact(user, target, "[key_name(user)] peeled back flesh where [key_name(target)]'s head used to be with \the [tool], beginning [surgery]")

/datum/surgery_step/peel_skin/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]手一滑，竟将[target]断端的皮肉损伤得更严重了！"), \
	SPAN_WARNING("你手一滑，竟将[target]断端的皮肉损伤得更严重了！"))

	log_interact(user, target, "[key_name(user)] failed to finish peeling back flesh where [key_name(target)]'s head used to be with \the [tool], aborting [surgery].")
	return FALSE

//------------------------------------

/datum/surgery_step/reattach_head
	name = "接回合成人头部"
	desc = "接回头部"
	tools = list(/obj/item/limb/head/synth = SURGERY_TOOL_MULT_IDEAL)
	time = 10 SECONDS

/datum/surgery_step/reattach_head/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user]开始将[tool]接回[target]的颈部。"), \
	SPAN_NOTICE("你开始将[tool]接回[target]的颈部。"))
	log_interact(user, target, "[key_name(user)] started to attach [tool] to [key_name(target)]'s reshaped neck.")

/datum/surgery_step/reattach_head/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, tool_type, datum/surgery/head_reattach/surgery)
	user.visible_message(SPAN_NOTICE("[user]将[target]的头部重新接到躯体的骨骼和肌肉组织上。"), \
	SPAN_NOTICE("你将[target]的头部重新接到躯体的骨骼和肌肉组织上。"))
	log_interact(user, target, "[key_name(user)] attached [tool] to [key_name(target)]'s neck.")

	surgery.patient_head = tool

	user.drop_inv_item_to_loc(surgery.patient_head, target)
	surgery.affected_limb.robotize(surgery_in_progress = TRUE, uncalibrated = FALSE, synth_skin = TRUE)
	target.updatehealth()
	target.regenerate_icons()

	if(target.status_flags & PERMANENTLY_DEAD) //We'll be using this flag so the patient doesn't get defibbed before their head is all the way reattached.
		surgery.no_revive = TRUE

	target.status_flags |= PERMANENTLY_DEAD

/datum/surgery_step/reattach_head/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]手一滑，损坏了[target]颈部的连接件！"), \
	SPAN_WARNING("你手一滑，损坏了[target]颈部的连接件！"))
	log_interact(user, target, "[key_name(user)] failed to attach [tool] to [key_name(target)]'s reshaped neck.")

	target.apply_damage(20, BRUTE, target_zone)
	return FALSE

//------------------------------------

/datum/surgery_step/mend_connections
	name = "重建咽喉"
	desc = "重建咽喉"
	tools = SURGERY_TOOLS_MEND_BLOODVESSEL
	time = 4 SECONDS

/datum/surgery_step/mend_connections/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user]开始用[tool]将[target]颈部的皮肉恢复成符合解剖结构的形状。"), \
	SPAN_NOTICE("你开始用[tool]将[target]颈部的皮肉恢复成符合解剖结构的形状。"))

	log_interact(user, target, "[key_name(user)] started to reshape [key_name(target)]'s head esophagal and vocal region with \the [tool].")

/datum/surgery_step/mend_connections/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user]完成了[target]咽喉的重建。"), \
	SPAN_NOTICE("你完成了[target]咽喉的重建。"))

	log_interact(user, target, "[key_name(user)] reshaped [key_name(target)]'s head esophagal and vocal region with \the [tool].")

/datum/surgery_step/mend_connections/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]手一滑，将[target]颈部和咽喉的皮肉撕裂得更严重了！"), \
	SPAN_WARNING("你手一滑，将[target]颈部和咽喉的皮肉撕裂得更严重了！"))

	log_interact(user, target, "[key_name(user)] failed to reshape [key_name(target)]'s head esophagal and vocal region with \the [tool].")
	return FALSE

//------------------------------------

/datum/surgery_step/cauterize/reposition_flesh
	name = "闭合皮肤"
	desc = "闭合皮肤"
	time = 6 SECONDS

/datum/surgery_step/cauterize/reposition_flesh/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_NOTICE("[user]开始用[tool]对[target]颈部周围做最后调整。"), \
	SPAN_NOTICE("你开始用[tool]对[target]颈部周围做最后调整。"))
	log_interact(user, target, "[key_name(user)] started to adjust the area around [key_name(target)]'s neck with \the [tool].")

/datum/surgery_step/cauterize/reposition_flesh/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/head_reattach/surgery)
	user.visible_message(SPAN_NOTICE("[user]完成了[target]颈部的调整。"), \
	SPAN_NOTICE("你完成了[target]颈部的调整。"))
	log_interact(user, target, "[key_name(user)] adjusted the area around [key_name(target)]'s neck with \the [tool].")

	if(!surgery.no_revive) //Unset this flag if they didn't have it before the surgery started.
		target.status_flags &= ~PERMANENTLY_DEAD

	//Prepare mind datum
	if(surgery.patient_head.brainmob.mind)
		surgery.patient_head.brainmob.mind.transfer_to(target)

	else // attempt to transfer linked ghost if not found
		for(var/mob/dead/observer/G in GLOB.observer_list)
			if(istype(G) && G.mind && G.mind.original == surgery.patient_head.brainmob && G.can_reenter_corpse)
				G.mind.original = target
				break

	qdel(surgery.patient_head) //Destroy head item.

/datum/surgery_step/cauterize/reposition_flesh/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, tool_type, datum/surgery/surgery)
	user.visible_message(SPAN_WARNING("[user]手一滑，灼伤了[target]的颈部！"), \
	SPAN_WARNING("你手一滑，灼伤了[target]的[localized_player_label(surgery.affected_limb.name)]！"))
	log_interact(user, target, "[key_name(user)] failed to adjust the area around [key_name(target)]'s neck with \the [tool].")

	return FALSE

