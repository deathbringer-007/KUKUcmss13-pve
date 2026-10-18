/proc/create_new_clan(clanname)
	var/datum/entity/clan/C = DB_ENTITY(/datum/entity/clan)
	C.name = clanname
	C.description = "这是一个氏族。"
	C.honor = 0
	C.save()
