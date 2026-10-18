/datum/disease/fake_gbs
	name = "GBS"
	max_stages = 5
	spread = "接触传播"
	spread_type = CONTACT_GENERAL
	cure = "硫"
	cure_id = list("sulfur")
	agent = "重力动能双势体SADS-"
	affected_species = list("Human", "Monkey")
	desc = "若不治疗，患者将会死亡。"
	severity = "严重"

/datum/disease/fake_gbs/stage_act()
	..()
	switch(stage)
		if(2)
			if(prob(1))
				affected_mob.emote("sneeze")
		if(3)
			if(prob(5))
				affected_mob.emote("cough")
			else if(prob(5))
				affected_mob.emote("gasp")
			if(prob(10))
				to_chat(affected_mob, SPAN_DANGER("你开始感到十分虚弱……"))
		if(4)
			if(prob(10))
				affected_mob.emote("cough")

		if(5)
			if(prob(10))
				affected_mob.emote("cough")
