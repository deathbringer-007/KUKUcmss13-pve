/datum/disease/pierrot_throat
	name = "Pierrot's Throat"
	max_stages = 4
	spread = "Airborne"
	cure = "A whole banana."
	cure_id = "banana"
	cure_chance = 75
	agent = "H0NI<42 Virus"
	affected_species = list("Human")
	permeability_mod = 0.75
	desc = "若不治疗，患者很可能把周围的人逼疯。"
	severity = "Medium"
	longevity = 400

/datum/disease/pierrot_throat/stage_act()
	..()
	switch(stage)
		if(1)
			if(prob(10)) to_chat(affected_mob, SPAN_DANGER("你觉得自己有点傻乎乎的。"))
		if(2)
			if(prob(10)) to_chat(affected_mob, SPAN_DANGER("你开始看见彩虹。"))
		if(3)
			if(prob(10)) to_chat(affected_mob, SPAN_DANGER("一声响亮的<b>喇叭声！</b>打断了你的思绪。"))
		if(4)
			if(prob(5)) affected_mob.say( pick( list("HONK!", "Honk!", "Honk.", "Honk?", "Honk!!", "Honk?!", "Honk...") ) )
