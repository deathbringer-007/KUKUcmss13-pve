/datum/disease/cold9
	name = "感冒"
	max_stages = 3
	spread = "接触传播"
	spread_type = CONTACT_GENERAL
	cure = "普通感冒抗体与太空西林"
	cure_id = "spaceacillin"
	agent = "ICE9鼻病毒"
	affected_species = list("Human")
	desc = "若不治疗，患者的动作会逐渐迟缓，仿佛身体被部分冻住。"
	severity = "中度"

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
