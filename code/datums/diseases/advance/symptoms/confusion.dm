/*
//////////////////////////////////////

Confusion

	Little bit hidden.
	Lowers resistance.
	Decreases stage speed.
	Not very transmittable.
	Intense Level.

Bonus
	Makes the affected mob be confused for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/confusion

	name = "意识混乱"
	stealth = 1
	resistance = -1
	stage_speed = -3
	transmittable = 0
	level = 4


/datum/symptom/confusion/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				to_chat(M, SPAN_NOTICE("[pick("你感到困惑。", "你忘了自己刚才在想什么。")]"))
			else
				to_chat(M, SPAN_NOTICE("你无法清晰地思考！"))
				M.confused = min(100, M.confused + 2)

	return
