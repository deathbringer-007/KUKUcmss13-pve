/*
//////////////////////////////////////

Hallucigen

	Very noticeable.
	Lowers resistance considerably.
	Decreases stage speed.
	Reduced transmittable.
	Critical Level.

Bonus
	Makes the affected mob be hallucinated for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/hallucigen

	name = "致幻"
	stealth = -2
	resistance = -3
	stage_speed = -3
	transmittable = -1
	level = 5

/datum/symptom/hallucigen/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				to_chat(M, SPAN_NOTICE("[pick("你用余光瞥见旁边似乎有人。", "那是脚步声吗？")]"))
			else
				M.hallucination += 5

	return
