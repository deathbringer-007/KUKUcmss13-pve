/datum/disease/cold9
	name = "The Cold"
	max_stages = 3
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Common Cold Anti-bodies & Spaceacillin"
	cure_id = "spaceacillin"
	agent = "ICE9-rhinovirus"
	affected_species = list("Human")
	desc = "若不治疗，患者的动作会逐渐迟缓，仿佛身体被部分冻住。"
	severity = "Moderate"

/datum/disease/cold9/stage_act()
	..()
	switch(stage)
		if(2)
			affected_mob.bodytemperature -= 10
			affected_mob.recalculate_move_delay = TRUE
			if(prob(1) && prob(10))
				to_chat(affected_mob, SPAN_NOTICE("你感觉好多了。"))
				cure()
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到喉咙疼痛。"))
			if(prob(5))
				to_chat(affected_mob, SPAN_DANGER("你感到身体僵硬。"))
		if(3)
			affected_mob.bodytemperature -= 20
			affected_mob.recalculate_move_delay = TRUE
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_DANGER("你感到喉咙疼痛。"))
			if(prob(10))
				to_chat(affected_mob, SPAN_DANGER("你感到身体僵硬。"))
