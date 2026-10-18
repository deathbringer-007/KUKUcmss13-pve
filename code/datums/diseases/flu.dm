/datum/disease/flu
	name = "The Flu"
	max_stages = 3
	spread = "Airborne"
	cure = "Spaceacillin"
	cure_id = "spaceacillin"
	cure_chance = 10
	agent = "H13N1 flu virion"
	affected_species = list("Human", "Monkey")
	permeability_mod = 0.75
	desc = "若不治疗，患者会感到十分不适。"
	severity = "Medium"

/datum/disease/flu/stage_act()
	..()
	switch(stage)
		if(2)
/*
			if(affected_mob.sleeping && prob(20))  //removed until sleeping is fixed --Blaank
				to_chat(affected_mob, SPAN_NOTICE(" You feel better."))
				stage--
				return
*/
			if(affected_mob.body_position == LYING_DOWN && prob(20))  //added until sleeping is fixed --Blaank
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				stage--
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到肌肉酸痛。"))
				if(prob(20))
					affected_mob.take_limb_damage(1)
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到胃疼。"))
				if(prob(20))
					affected_mob.apply_damage(1, TOX)
					affected_mob.updatehealth()

		if(3)
/*
			if(affected_mob.sleeping && prob(15))  //removed until sleeping is fixed
				to_chat(affected_mob, SPAN_NOTICE(" You feel better."))
				stage--
				return
*/
			if(affected_mob.body_position == LYING_DOWN && prob(15))  //added until sleeping is fixed
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				stage--
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到肌肉酸痛。"))
				if(prob(20))
					affected_mob.take_limb_damage(1)
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到胃疼。"))
				if(prob(20))
					affected_mob.apply_damage(1, TOX)
					affected_mob.updatehealth()
	return
