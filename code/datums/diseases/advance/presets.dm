// Cold

/datum/disease/advance/cold/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "感冒"
		symptoms = list(new/datum/symptom/sneeze)
	..(process, D, copy)


// Flu

/datum/disease/advance/flu/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "流感"
		symptoms = list(new/datum/symptom/cough)
	..(process, D, copy)


// Voice Changing

/datum/disease/advance/voice_change/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "会厌突变"
		symptoms = list(new/datum/symptom/voice_change)
	..(process, D, copy)


// Toxin Filter

/datum/disease/advance/heal/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "肝脏强化"
		symptoms = list(new/datum/symptom/heal)
	..(process, D, copy)


// Hullucigen

/datum/disease/advance/hullucigen/New(process = 1, datum/disease/advance/D, copy = 0)
	if(!D)
		name = "现实感障碍"
		symptoms = list(new/datum/symptom/hallucigen)
	..(process, D, copy)
