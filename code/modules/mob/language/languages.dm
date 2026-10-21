/datum/language/common
	name = LANGUAGE_ENGLISH
	desc = "地球通用英语。美洲联盟的标准语言。"
	speech_verb = "说道"
	ask_verb = "问道"
	exclaim_verb = list("惊呼道","大喊道","喊道")
	key = "1"
	flags = RESTRICTED

	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")
/datum/language/generated //parent type for languages with custom sound generation methods like chinese and japanese
	space_chance = 100 //uses a unique system

// Galactic common languages (systemwide accepted standards).
/datum/language/scandinavian
	name = LANGUAGE_SCANDINAVIAN
	desc = "斯堪的纳维亚诸语言严格说来并非同一种语言，但如今已十分相近，不熟悉的人几乎无法区分。"
	speech_verb = "低声说道"
	ask_verb = "询问道"
	exclaim_verb = "尖叫道"
	color = "scandinavian"
	key = "0"

	syllables = list("de", "vin", "meg", "og", "vi", "en", "nei", "ing", "gen", "et", "pur", "ke", "er", "nei", "hjort", "tysk", "de", "kjae", "en", "stein", "ja", "ull", "sil", "pa", "hun", "kjo", "erg", "ba", "re", "ol", "kyll", "menn", "esk", "gul", "gronn", "natt", "makt", "to", "fi", "re", "dag", "god", "jul", "ild", "fem", "jeg", "deg", "bjor", "en", "russ", "land", "sve", "rig", "nor", "ge", "dan", "is")

/datum/language/generated/japanese
	name = LANGUAGE_JAPANESE
	desc = "一种以复杂著称的语言，有着庞大的语法体系、三套文字系统和新近引入的英语借词。它因三世界帝国内部频繁的文化交流而广受使用，并随移民传播到境外。"
	speech_verb = "发声道"
	color = "japanese"
	key = "2"

/datum/language/russian
	name = LANGUAGE_RUSSIAN
	desc = "源自地球的东斯拉夫语言。它是进步人民联盟的主要语言，也常被美洲联盟境内的斯拉夫少数族群使用。"
	speech_verb = "清晰地说道"
	color = "soghun"
	key = "3"

	syllables = list("al", "an", "bi", "vye", "vo", "go", "dye", "yel", "en", "yer", "yet", "ka", "ko", "la", "ly", "lo", "l", "na", "nye", "ny", "no", "ov", "ol", "on", "or", "slog", "ot", "po", "pr", "ra", "rye", "ro", "st", "ta", "tye", "to", "t", "at", "bil", "vyer", "yego", "yeny", "yenn", "yest", "kak", "ln", "ova", "ogo", "oro", "ost", "oto", "pry", "pro", "sta", "stv", "tor", "chto", "eto", "rus", "nar", "arya", "mol")

/datum/language/german
	name = LANGUAGE_GERMAN
	desc = "标准高地德语，主要通行于中欧，也被其他地区的德裔移民使用。"
	speech_verb = "宣告道"
	ask_verb = "询问道"
	exclaim_verb = "吼道"
	color = "german"
	key = "4"

	syllables = list("die", "das", "wein", "mir", "und", "wir", "ein", "nein", "gen", "en", "sauen", "bin", "nein", "rhein", "deut", "der", "lieb", "en", "stein", "nein", "ja", "wolle", "sil", "bei", "der", "sie", "sch", "kein", "nur", "ach", "kann", "volk", "vau", "gelb", "grun", "macht", "zwei", "vier", "nacht", "tag")

/datum/language/spanish
	name = LANGUAGE_SPANISH
	desc = "美洲联盟第二常用的语言，由拉丁美洲领土和原美国南部的陆战队员传播开来。"
	speech_verb = "说道"
	ask_verb = "提问道"
	exclaim_verb = "喊道"
	color = "spanish"
	key = "5"

	syllables = list("ha", "pana", "ja", "blo", "que", "spa", "di", "ga", "na", "ces", "si", "mo", "so", "de", "el", "to", "ro", "mi", "ca", "la", "di", "ah", "mio", "tar", "ion", "gran", "van", "jo", "cie", "qie", "las", "locho", "mas", "no", "gui", "es", "mal")

/datum/language/portuguese
	name = LANGUAGE_PORTUGUESE
	desc = "美洲联盟第三常用的语言。"
	speech_verb = "说道"
	ask_verb = "提问道"
	exclaim_verb = "喊道"
	color = "portuguese"
	key = "6"

	syllables = list("o", "de", "e", "que", "um", "para", "com", "por", "seu", "outro", "ele", "já", "eiro", "bem", "bom", "só", "iço", "iça", "lho", "lha", "ção", "pois", "hoje", "ém", "hão", "três", "ela", "aço", "aça", "ça", "você", "ança", "lhe", "lher", "lado", "fim", "nem", "são", "vir", "sem", "sim", "nó", "se", "em", "até", "esse", "nosso", "eu", "dois", "ar", "mal", "não", "muito", "bém", "mais", "en", "tão", "lá", "aí", "ou")

/datum/language/french
	name = LANGUAGE_FRENCH
	desc = "地球上使用最广的语言。法兰西万岁。"
	speech_verb = "宣告道"
	ask_verb = "询问道"
	exclaim_verb = "吼道"
	color = "french"
	key = "7"

	syllables = list("la", "là", "pou", "tu", "cou", "fou", "sous", "chou", "je", "ro", "po", "me", "âge", "île", "ni", "moi", "ami", "pâtes", "fromage", "vin", "coup", "grâce", "rôle", "et", "beau", "cuit", "clé", "eau", "lit", "pain", "plus", "trop", "agi", "bien", "songé", "cure", "vite", "dur", "vide", "cru", "bas", "ta", "pis", "pire", "mieux", "meilleur", "bien", "mauvais", "à", "belle", "mur", "sac", "chez", "ai", "pomme", "que", "longe", "genre", "mon", "gérée", "série", "erreur", "ira", "jeu", "jou", "pu", "puis", "qui", "que", "côté", "côte", "vie", "ville", "sur", "tard", "les", "des", "voix", "pluie", "pont", "pot", "roue", "peu", "sec", "vis", "où", "ou", "seul", "mienne", "os", "né", "mort", "trou", "pâle", "tue", "cher", "en", "incroyable", "on", "un", "eu", "au", "œil", "aide", "oui", "non", "si", "été", "nez", "près", "après", "mûr", "sûr", "croît", "ère", "lui", "tâche")

/datum/language/generated/chinese
	name = LANGUAGE_CHINESE
	desc = "进步人民联盟的第二语言，在亚洲广泛使用，世界其他地区也有规模可观的移民使用者。它是已知星域中使用最广的语言。"
	speech_verb = "发声道"
	ask_verb = "问道"
	exclaim_verb = "大喊道"
	color = "chinese"
	key = "8"

/datum/language/ruspatois
	name = LANGUAGE_RUSPATOIS
	desc = "在美洲联盟和三世界帝国境内居住数十年的东欧人所使用的俄语混合方言。它与当代俄语基本无法互通。"
	speech_verb = "说道"
	color = "ruspatois"
	key = "9"

	syllables = list("che", "de", "da", "du", "yo", "yu", "ty", "yon", "ka", "ke", "don", "yed", "mas", "kyen", "no", "ua", "khe", "kha", "o", "na", "has", "ya", "yen", "tra", "blo", "kho", "est", "soi", "dos", "par", "dya", "tan", "ey", "sa", "kom", "nyo", "min", "svi", "yan", "suy", "des", "ven", "vo", "ro", "ku", "tak", "u", "ov", "so", "ri", "kab", "ten", "nos", "mi", "an", "su", "men", "ma", "dro", "li", "ak", "om", "er", "ir", "ar", "ote", "op", "ki", "to")

/datum/language/filipino
	name = LANGUAGE_FILIPINO
	desc = "美洲联盟第四常用的语言。"
	speech_verb = "说道"
	ask_verb = "提问道"
	exclaim_verb = "喊道"
	color = "filipino"
	key = "f"

	syllables = list("ako", "ito", "dito", "an", "paa", "lam", "kai", "tay", "saan", "taba", "hok", "kama", "ta", "opi", "oo", "dya", "ryo", "kas", "ngi", "nga", "asu", "kal", "lupa", "damo", "baho", "yon", "mari", "pak", "gan", "king", "atin", "ang", "ng", "sa", "nag", "kita", "han", "kan", "araw", "mala", "laba", "baka", "kay", "kina", "ni", "nina", "para", "tung", "kol", "hing", "gil", "ayon", "tungo", "bag", "ba", "bay")

/datum/language/polish
	name = LANGUAGE_POLISH
	desc = "波兰人使用的一种西斯拉夫语言。目前是进步人民联盟第五常用的语言。"
	speech_verb = "说道"
	ask_verb = "询问道"
	exclaim_verb = "大喊道"
	color = "polish"
	key = "p"

	syllables = list("się", "w", "je", "na", "to", "nie", "że", "i", "z", "do", "tak", "jak", "o", "mnie", "za", "ja", "mi", "ale", "czy", "ty", "ci", "cię", "już", "ma", "mam", "pan", "coś", "dla", "dobrze", "szę", "być", "wię", "mogę", "są", "więc", "kurwa", "pierdole", "był", "moj", "chcę", "ją", "pęk", "gor", "żeb", "że", "źółć", "kto", "bo", "mu", "on", "ona", "tej", "ktoś", "sam", "ta", "czas", "raz", "daj", "kim", "przy", "nikt", "dwa", "cóż", "iść", "ile", "cały", "nią", "idź", "trzy", "rację", "chaj", "spójrz", "nasz", "lub", "kogo", "którą", "źle", "pew", "oto", "całą", "zrób", "wczor", "boga", "bog")

/datum/language/hellhound
	name = LANGUAGE_HELLHOUND
	desc = "一种低沉的喉音交流方式，似乎只有地狱猎犬能发出这些声音。"
	speech_verb = "低吼道"
	ask_verb = "嘟囔道"
	exclaim_verb = "咆哮道"
	color = "monkey"
	key = "h"

/datum/language/hellhound/scramble(input)
	return pick("Grrr...", "Grah!", "Gurrr...")

/datum/language/commando
	name = LANGUAGE_TSL
	desc = "战术手语是一种现代交流技术，结合了改良的美国手语、战术手势，以及只有精锐突击队才知晓的隐秘无线电代号。"
	speech_verb = "隐秘地交流"
	ask_verb = "盘问道"
	exclaim_verb = "命令道"
	color = "commando"
	key = "l"

	syllables = list("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "?", "@", "#" ,"*")
	sentence_chance = 50
	space_chance = 50

/datum/language/sainja //Yautja tongue
	name = LANGUAGE_YAUTJA
	desc = "铁血战士发出的低沉、隆隆作响的喉音。没有面部颚肢的种族很难说出这种语言。"
	speech_verb = "低沉地说道"
	ask_verb = "低沉地说道"
	exclaim_verb = "咆哮道"
	color = "tajaran"
	key = "s"
	flags = WHITELISTED

	syllables = list("!", "?", ".", "@", "$", "%", "^", "&", "*", "-", "=", "+", "e", "b", "y", "p", "|", "z", "~", ">")
	space_chance = 20

/datum/language/primitive
	name = LANGUAGE_MONKEY
	desc = "噢噢噢。"
	speech_verb = "吱吱叫道"
	ask_verb = "吱吱叫道"
	exclaim_verb = "尖啸道"
	color = "monkey"
	key = "m"

/datum/language/xenomorph
	name = LANGUAGE_XENOMORPH
	color = "xenotalk"
	desc = "异形的通用语言。"
	speech_verb = "嘶声道"
	ask_verb = "嘶声道"
	exclaim_verb = "嘶声道"
	key = "x"
	syllables = list("sss", "sSs", "SSS")
	flags = RESTRICTED

/datum/language/xenos
	name = LANGUAGE_HIVEMIND
	desc = "异形能够通过精神性的虫巢意识交流，十分奇特。"
	speech_verb = "通过巢群意识传达"
	ask_verb = "通过巢群意识传达"
	exclaim_verb = "通过巢群意识传达"
	color = "xeno"
	key = "q"
	flags = RESTRICTED|HIVEMIND

//Make queens BOLD text
/datum/language/xenos/broadcast(mob/living/speaker, message, speaker_mask)
	if(iscarbon(speaker))
		var/mob/living/carbon/C = speaker

		if(!(C.hivenumber in GLOB.hive_datum))
			return

		C.hivemind_broadcast(message, GLOB.hive_datum[C.hivenumber])

/datum/language/apollo
	name = LANGUAGE_APOLLO
	desc = "阿波罗链路是西格森设计的人工智能子处理器，用于协调维护无人机和工作乔。维兰德-汤谷否认了其窃取该处理器用于阿瑞斯的指控。"
	color = "skrell"
	speech_verb = "说道"
	ask_verb = "询问道"
	exclaim_verb = "宣布道"
	key = "a"
	flags = RESTRICTED|HIVEMIND

/datum/language/apollo/broadcast(mob/living/speaker, message, speaker_mask)
	if(!speaker.hear_apollo())
		return

	if (!message)
		return

	///Font size
	var/scale = "message"
	if(isARES(speaker))
		scale = "large"

	var/message_start = "<i><span class='game say'>[name], <span class='name'>[speaker.name]</span>"
	var/message_body = "<span class='message'>广播道：“[message]”</span></span></i>"
	var/full_message = "<span class='[scale]'><span class='[color]'>[message_start] [message_body]</span></span>"


	GLOB.STUI.game.Add("\[[time_stamp()]]<font color='#FFFF00'>APOLLO: [key_name(speaker)] : [message]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT
	log_say("[speaker.name != "Unknown" ? speaker.name : "([speaker.real_name])"] \[APOLLO\]: [message] (CKEY: [speaker.key]) (JOB: [speaker.job]) (AREA: [get_area_name(speaker)])")
	log_ares_apollo(speaker.real_name, message)
	for (var/mob/dead in GLOB.dead_mob_list)
		if(!istype(dead,/mob/new_player) && !istype(dead,/mob/living/brain)) //No meta-evesdropping
			var/dead_message = "<span class='[scale]'><span class='[color]'>[message_start](<a href='byond://?src=\ref[dead];track=\ref[speaker]'>F</a>) [message_body]</span></span>"
			dead.show_message(dead_message, SHOW_MESSAGE_VISIBLE)

	for (var/mob/living/listener in GLOB.alive_mob_list)

		if (!listener.hear_apollo())
			continue

		listener.show_message(full_message, SHOW_MESSAGE_VISIBLE)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(isSilicon(M) || M.hear_apollo())
			continue
		M.show_message("<i><span class='game say'><span class='name'>合成语音</span> <span class='message'>发出哔声：\"哔哔哔\"</span></span></i>",2)

/datum/language/event_hivemind
	name = LANGUAGE_TELEPATH
	desc = "仅供活动使用的语言，为使用者提供共享意识。"
	speech_verb = "共鸣道"
	ask_verb = "共鸣道"
	exclaim_verb = "共鸣道"
	color = "tajaran"
	key = "t"
	flags = RESTRICTED|HIVEMIND
