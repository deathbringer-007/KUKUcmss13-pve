/proc/CreateGeneralRecord()
	var/datum/data/record/general_record = new /datum/data/record()
	general_record.fields["name"] = "新记录"
	general_record.name = "新记录"
	general_record.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	general_record.fields["rank"] = "Unassigned"
	general_record.fields["real_rank"] = "Unassigned"
	general_record.fields["sex"] = "Male"
	general_record.fields["age"] = "Unknown"
	general_record.fields["skin_color"] = "Unknown"
	general_record.fields["p_stat"] = "Active"
	general_record.fields["m_stat"] = "Stable"
	general_record.fields["species"] = "Human"
	general_record.fields["origin"] = "Unknown"
	general_record.fields["faction"] = "Unknown"
	general_record.fields["mob_faction"] = "Unknown"
	general_record.fields["religion"] = "Unknown"
	GLOB.data_core.general += general_record
	return general_record

/proc/CreateSecurityRecord(name as text, id as text)
	var/datum/data/record/security_record = new /datum/data/record()
	security_record.fields["name"] = name
	security_record.fields["id"] = id
	security_record.name = text("安保记录#[id]")
	security_record.fields["incidents"] = "None"
	GLOB.data_core.security += security_record
	return security_record

/proc/create_medical_record(mob/living/carbon/human/person)
	var/datum/data/record/medical_record = new /datum/data/record()
	medical_record.fields["id"] = null
	medical_record.fields["name"] = person.real_name
	medical_record.name = person.real_name
	medical_record.fields["b_type"] = person.b_type
	medical_record.fields["mi_dis"] = "None"
	medical_record.fields["mi_dis_d"] = "未申报轻度残疾。"
	medical_record.fields["ma_dis"] = "None"
	medical_record.fields["ma_dis_d"] = "未诊断出重度残疾。"
	medical_record.fields["alg"] = "None"
	medical_record.fields["alg_d"] = "未发现该患者有过敏症。"
	medical_record.fields["cdi"] = "None"
	medical_record.fields["cdi_d"] = "目前未诊断出疾病。"
	medical_record.fields["last_scan_time"] = null
	medical_record.fields["last_scan_result"] = "尚无扫描记录"
	medical_record.fields["autodoc_data"] = list()
	medical_record.fields["autodoc_manual"] = list()
	medical_record.fields["ref"] = WEAKREF(person)
	GLOB.data_core.medical += medical_record
	return medical_record
