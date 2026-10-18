/datum/disease/pierrot_throat
	name = "皮埃罗喉炎"
	max_stages = 4
	spread = "空气传播"
	cure = "一整根香蕉。"
	cure_id = "banana"
	cure_chance = 75
	agent = "H0NI<42病毒"
	affected_species = list("Human")
	permeability_mod = 0.75
	desc = "若不治疗，患者很可能把周围的人逼疯。"
	severity = "中等"
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
			if(prob(5)) affected_mob.say( pick( list("叭——！", "叭！", "叭。", "叭？", "叭！！", "叭？！", "叭……") ) )
