/datum/disease/cold
	name = "The Cold"
	max_stages = 3
	spread = "Airborne"
	cure = "Rest & Spaceacillin"
	cure_id = "spaceacillin"
	agent = "XY-rhinovirus"
	affected_species = list("Human", "Monkey")
	permeability_mod = 0.5
	desc = "若不治疗，患者会进一步患上流感。"
	severity = "Minor"

/datum/disease/cold/stage_act()
	..()
	switch(stage)
		if(2)
/*
			if(affected_mob.sleeping && prob(40))  //removed until sleeping is fixed
				to_chat(affected_mob, SPAN_NOTICE(" You feel better."))
				cure()
				return
*/
			if(affected_mob.body_position == LYING_DOWN && prob(40))  //changed FROM prob(10) until sleeping is fixed
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				cure()
				return
			if(prob(1) && prob(5))
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				cure()
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到喉咙疼痛。"))
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("黏液沿着你的喉咙后壁流下。"))
		if(3)
/*
			if(affected_mob.sleeping && prob(25))  //removed until sleeping is fixed
				to_chat(affected_mob, SPAN_NOTICE(" You feel better."))
				cure()
				return
*/
			if(affected_mob.body_position == LYING_DOWN && prob(25))  //changed FROM prob(5) until sleeping is fixed
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				cure()
				return
			if(prob(1) && prob(1))
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				cure()
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到喉咙疼痛。"))
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("黏液沿着你的喉咙后壁流下。"))
			if(prob(1) && prob(50))
				if(!affected_mob.resistances.Find(/datum/disease/flu))
					var/datum/disease/Flu = new /datum/disease/flu(0)
					affected_mob.contract_disease(Flu,1)
					cure()
