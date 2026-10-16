
/*boozepwr chart
1-2 = non-toxic alcohol
3 = medium-toxic
4 = the hard stuff
5 = potent mixes
<6 = deadly toxic
*/


/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	localized_name = "乙醇"
	id = "ethanol"
	description = "一种广为人知、用途广泛的醇。"
	reagent_state = LIQUID
	nutriment_factor = 0 //So alcohol can fill you up! If they want to.
	color = "#404030" // rgb: 64, 64, 48
	chemfiresupp = TRUE
	burncolor = "#6897f7"
	burncolormod = 2
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	overdose = VHIGH_REAGENTS_OVERDOSE	//I weep for every corpsman on greenshifts
	overdose_critical = VHIGH_REAGENTS_OVERDOSE_CRITICAL
	///higher numbers mean the booze will have an effect faster.
	var/boozepwr = 5
	///If it's a normal drink, let them drink a bit before they start feeling it.
	var/accumulated_alcohol = 0
	///This is when the properties are gonna hit. Drink in moderation.
	var/effect_start = 150


/datum/reagent/ethanol/on_mob_life(mob/living/M, alien)
	//This is all way too snowflake to accurately transition to the property system so it stays here
	if(alien == IS_YAUTJA || alien == IS_HORROR || !holder)
		return
	M:nutrition += nutriment_factor
	holder.remove_reagent(src.id, (alien ? FOOD_METABOLISM : ALCOHOL_METABOLISM)) // Catch-all for creatures without livers.

	accumulated_alcohol += boozepwr

	if(accumulated_alcohol >= effect_start)
		. = ..()

/datum/reagent/ethanol/reaction_obj(obj/O, volume)
	if(istype(O,/obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "溶液溶解了纸上的墨迹。")
	if(istype(O,/obj/item/book))
		if(volume >= 5)
			var/obj/item/book/affectedbook = O
			affectedbook.dat = null
			to_chat(usr, "溶液溶解了书上的墨迹。")
		else
			to_chat(usr, "溶液不够……")
	return

/datum/reagent/ethanol/beer
	name = "Beer"
	localized_name = "啤酒"
	id = "beer"
	description = "以发芽谷物、啤酒花、酵母和水酿造的酒精饮料。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/ethanol/beer/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M:jitteriness = max(M:jitteriness-3,0)

/datum/reagent/ethanol/kahlua
	name = "Kahlua"
	localized_name = "甘露咖啡利口酒"
	id = "kahlua"
	description = "广为人知的墨西哥咖啡风味利口酒，自 1936 年起出品！"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/kahlua/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M.make_jittery(5)

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	localized_name = "威士忌"
	id = "whiskey"
	description = "品质出众、陈年醇熟的单一麦芽威士忌。真他妈棒。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/specialwhiskey
	name = "Special Blend Whiskey"
	localized_name = "特调威士忌"
	id = "specialwhiskey"
	description = "正当你觉得空间站的普通威士忌已经很不错时……这杯丝滑的琥珀佳酿却让它们全都黯然失色。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/sake
	name = "Sake"
	localized_name = "清酒"
	id = "sake"
	description = "一种烈性米酒。"
	color = "#0064C8" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	localized_name = "十三狂饮"
	id = "thirteenloko"
	description = "咖啡因与酒精混合而成的烈性饮料。"
	color = "#102000" // rgb: 16, 32, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/ethanol/thirteenloko/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M:drowsyness = max(0,M:drowsyness-7)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)

/datum/reagent/ethanol/vodka
	name = "Vodka"
	localized_name = "伏特加"
	id = "vodka"
	description = "全世界俄罗斯人在饮酒和加燃料时的首选。"
	color = "#0064C8" // rgb: 0, 100, 200
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/bilk
	name = "Bilk"
	localized_name = "奶啤"
	id = "bilk"
	description = "似乎是牛奶混合啤酒。真恶心。"
	color = "#895C4C" // rgb: 137, 92, 76
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1
	nutriment_factor = 2 * FOOD_METABOLISM

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	localized_name = "三里岛冰茶"
	id = "threemileisland"
	description = "为女士调制，劲道却足以满足男士。"
	color = "#666340" // rgb: 102, 99, 64
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 5

/datum/reagent/ethanol/threemileisland/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M.druggy = max(M.druggy, 50)

/datum/reagent/ethanol/gin
	name = "Gin"
	localized_name = "金酒"
	id = "gin"
	description = "金酒，太空里的金酒。容我敬您一杯，先生。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/rum
	name = "Rum"
	localized_name = "朗姆酒"
	id = "rum"
	description = "哟吼吼，海盗喝的就是这个。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/tequila
	name = "Tequila"
	localized_name = "龙舌兰酒"
	id = "tequila"
	description = "墨西哥出产的烈酒，风味温和。朋友，口渴了吗？"
	color = "#FFFF91" // rgb: 255, 255, 145
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	localized_name = "味美思"
	id = "vermouth"
	description = "你突然很想来一杯马天尼……"
	color = "#91FF91" // rgb: 145, 255, 145
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/wine
	name = "Wine"
	localized_name = "葡萄酒"
	id = "wine"
	description = "以蒸馏葡萄汁制成的优质酒精饮料。"
	color = "#7E4043" // rgb: 126, 64, 67
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/cognac
	name = "Cognac"
	localized_name = "干邑"
	id = "cognac"
	description = "经过多次蒸馏和多年陈酿，香甜而劲烈。高雅得他妈没话说。"
	color = "#AB3C05" // rgb: 171, 60, 5
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/hooch
	name = "Hooch"
	localized_name = "劣质私酿酒"
	id = "hooch"
	description = "不是谁调鸡尾酒失败的产物，就是初次尝试酿酒的成果。无论如何，你真想喝这东西吗？"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/ale
	name = "Ale"
	localized_name = "艾尔啤酒"
	id = "ale"
	description = "用发芽大麦和酵母酿造的深色酒精饮料。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	localized_name = "苦艾酒"
	id = "absinthe"
	description = "当心绿仙子来找你！"
	color = "#33EE00" // rgb: 51, 238, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4


/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	localized_name = "毒葡萄酒"
	id = "pwine"
	description = "这还能叫酒吗？有毒！致幻！你的上司们大概正一船一船地灌这东西！"
	color = COLOR_BLACK
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/pwine/on_mob_life(mob/living/M,alien)
	M.druggy = max(M.druggy, 50)
	accumulated_alcohol++
	switch(accumulated_alcohol)
		if(1 to 25)
			if(!M.stuttering) M.stuttering = 1
			M.make_dizzy(1)
			M.hallucination = max(M.hallucination, 3)
			if(prob(1)) M.emote(pick("twitch","giggle"))
		if(25 to 75)
			if(!M.stuttering) M.stuttering = 1
			M.hallucination = max(M.hallucination, 10)
			M.make_jittery(2)
			M.make_dizzy(2)
			M.druggy = max(M.druggy, 45)
			if(prob(5)) M.emote(pick("twitch","giggle"))
		if(75 to 150)
			if(!M.stuttering) M.stuttering = 1
			M.hallucination = max(M.hallucination, 60)
			M.make_jittery(4)
			M.make_dizzy(4)
			M.druggy = max(M.druggy, 60)
			if(prob(10)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.apply_damage(2, TOX)
		if(150 to 300)
			if(!M.stuttering) M.stuttering = 1
			M.hallucination = max(M.hallucination, 60)
			M.make_jittery(4)
			M.make_dizzy(4)
			M.druggy = max(M.druggy, 60)
			if(prob(10)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.apply_damage(2, TOX)
			if(prob(5)) if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
				if(L && istype(L))
					L.take_damage(5, 0)
		if(300 to INFINITY)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/datum/internal_organ/heart/L = H.internal_organs_by_name["heart"]
				if(L && istype(L))
					L.take_damage(100, 0)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	return 1

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	localized_name = "亡者朗姆"
	id = "rum"
	description = "深受水手喜爱，其他人可就不怎么喜欢了。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/deadrum/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M.dizziness +=5


/datum/reagent/ethanol/sake
	name = "Sake"
	localized_name = "清酒"
	id = "sake"
	description = "源自东方的米酒。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/blackout //Added for testing the property quickly
	name = "Blackout Stout"
	localized_name = null
	id = "blackout"
	description = "You probably shouldn't drink this."
	color = "#34220F"
	properties = list(PROPERTY_ALCOHOLIC = 50) //You WILL die in record time
	boozepwr = 250

//*****************************************************************************************************/
//***************************************Cocktail Entities*********************************************/
//*****************************************************************************************************/

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	localized_name = "金箔肉桂酒"
	id = "goldschlager"
	description = "100 proof 的肉桂烈酒，专为春假里嗜酒的少女们而酿。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/patron
	name = "Patron"
	localized_name = "培恩龙舌兰酒"
	id = "patron"
	description = "含银的龙舌兰酒，深受夜店里嗜酒女士的喜爱。"
	color = "#585840" // rgb: 88, 88, 64
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	localized_name = "金汤力"
	id = "gintonic"
	description = "经久不衰的经典，口感温和的鸡尾酒。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	localized_name = "自由古巴"
	id = "cubalibre"
	description = "朗姆酒混合可乐。革命万岁。"
	color = "#3E1B00" // rgb: 62, 27, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	localized_name = "威士忌可乐"
	id = "whiskeycola"
	description = "威士忌混合可乐，意外地清爽。"
	color = "#3E1B00" // rgb: 62, 27, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	localized_name = "经典马天尼"
	id = "martini"
	description = "味美思配金酒。和 007 喜欢的调法不太一样，但依旧美味。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	localized_name = "伏特加马天尼"
	id = "vodkamartini"
	description = "伏特加配金酒。和 007 喜欢的调法不太一样，但依旧美味。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/white_russian
	name = "White Russian"
	localized_name = "白俄罗斯"
	id = "whiterussian"
	description = "那不过是，呃，你自己的看法，老兄……"
	color = "#A68340" // rgb: 166, 131, 64
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	localized_name = "螺丝刀"
	id = "screwdrivercocktail"
	description = "伏特加混合普通橙汁，味道却出奇地好。"
	color = "#A68310" // rgb: 166, 131, 16
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/booger
	name = "Booger"
	localized_name = "鼻屎"
	id = "booger"
	description = "呕……"
	color = "#8CFF8C" // rgb: 140, 255, 140
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	localized_name = "血腥玛丽"
	id = "bloodymary"
	description = "伏特加、番茄汁和青柠汁调出的奇妙美味。至少你以为那红色的东西是番茄汁。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/brave_bull
	name = "Brave Bull"
	localized_name = "勇猛公牛"
	id = "bravebull"
	description = "喝了壮胆，效果一点不差！"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/tequila_sunrise
	name = "Tequila Sunrise"
	localized_name = "龙舌兰日出"
	id = "tequilasunrise"
	description = "龙舌兰酒配橙汁。和螺丝刀差不多，只是更有墨西哥风情～"
	color = "#FFE48C" // rgb: 255, 228, 140
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	localized_name = "毒素特调"
	id = "phoronspecial"
	description = "这东西着火了！快他妈叫穿梭机！"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 5

/datum/reagent/ethanol/toxins_special/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (15 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	localized_name = "爱尔兰奶油酒"
	id = "irishcream"
	description = "浸入威士忌的奶油。对爱尔兰人你还能有什么别的期待。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	localized_name = "硬汉矮人"
	id = "manlydorf"
	description = "啤酒与艾尔啤酒调成的美味混合酒。只供真汉子享用。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	localized_name = "长岛冰茶"
	id = "longislandicedtea"
	description = "把整个酒柜混在一起调成的美味。专供嗜酒的中年女士享用。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	localized_name = "私酿烈酒"
	id = "moonshine"
	description = "你可真是堕落到底了……你的肝脏昨晚就收拾行李跑路了。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/b52
	name = "B-52"
	localized_name = "B-52"
	id = "b52"
	description = "咖啡、爱尔兰奶油酒和干邑。准备好被轰倒吧。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/irishcoffee
	name = "Irish Coffee"
	localized_name = "爱尔兰咖啡"
	id = "irishcoffee"
	description = "咖啡加酒精。早上喝这个可比含羞草鸡尾酒有趣多了。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/margarita
	name = "Margarita"
	localized_name = "玛格丽特"
	id = "margarita"
	description = "加冰，杯口抹盐。干杯～！"
	color = "#8CFF8C" // rgb: 140, 255, 140
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	localized_name = "黑俄罗斯"
	id = "blackrussian"
	description = "适合乳糖不耐受者，依旧和白俄罗斯一样高雅。"
	color = "#360000" // rgb: 54, 0, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	localized_name = "曼哈顿"
	id = "manhattan"
	description = "侦探卧底时的首选。他一直喝不惯金酒……"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	localized_name = "曼哈顿计划"
	id = "manhattan_proj"
	description = "科学家琢磨怎么炸掉空间站时的首选饮品。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 5

/datum/reagent/ethanol/manhattan_proj/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M.druggy = max(M.druggy, 30)

/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	localized_name = "威士忌苏打"
	id = "whiskeysoda"
	description = "献给更有品位的狮鹫。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	localized_name = "防冻液"
	id = "antifreeze"
	description = "清爽到极致。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/antifreeze/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	localized_name = "赤足"
	id = "barefoot"
	description = "光着脚，怀着孕。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	localized_name = "白雪公主"
	id = "snowwhite"
	description = "冰凉爽口。"
	color = COLOR_WHITE
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	localized_name = "蜜瓜利口酒"
	id = "melonliquor"
	description = "偏甜、果香浓郁的 46 proof 利口酒。"
	color = "#138808" // rgb: 19, 136, 8
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	localized_name = "蓝橙酒"
	id = "bluecuracao"
	description = "由橙子蒸馏而成，泛着异域蓝色的果味酒。"
	color = "#0000CD" // rgb: 0, 0, 205
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	localized_name = "翠梦"
	id = "suidream"
	description = "由无色苏打水、蓝橙酒和蜜瓜利口酒调制而成。"
	color = "#00A86B" // rgb: 0, 168, 107
	properties = list(PROPERTY_ALCOHOLIC = 0.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 0.5

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	localized_name = "恶魔之血"
	id = "demonsblood"
	description = "啊啊啊啊！！！！"
	color = "#820000" // rgb: 130, 0, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3
/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	localized_name = "伏特加汤力"
	id = "vodkatonic"
	description = "当金汤力还不够有俄罗斯味儿时，就喝这个。"
	color = "#0064C8" // rgb: 0, 100, 200
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	localized_name = "金菲士"
	id = "ginfizz"
	description = "柠檬清香，干爽美味。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	localized_name = "巴哈马妈妈"
	id = "bahama_mama"
	description = "热带风味鸡尾酒。"
	color = "#FF7F3B" // rgb: 255, 127, 59
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/singulo
	name = "Singulo"
	localized_name = "奇点"
	id = "singulo"
	description = "一种蓝空间饮料！"
	color = "#2E6671" // rgb: 46, 102, 113
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 5

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	localized_name = "斯比滕"
	id = "sbiten"
	description = "辛辣的伏特加！小家伙们可能受不了这股热劲儿！"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/sbiten/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.bodytemperature < 360)
		M.bodytemperature = min(360, M.bodytemperature + (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	localized_name = "魔鬼之吻"
	id = "devilskiss"
	description = "惊悚时刻到了！"
	color = "#A68310" // rgb: 166, 131, 16
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	localized_name = "红蜜酒"
	id = "red_mead"
	description = "真正维京人的饮品！虽然红得有点奇怪。"
	color = "#C73C00" // rgb: 199, 60, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/mead
	name = "Mead"
	localized_name = "蜜酒"
	id = "mead"
	description = "维京人的饮品，不过是便宜货。"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5
	nutriment_factor = 1 * FOOD_METABOLISM

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	localized_name = "冰镇啤酒"
	id = "iced_beer"
	description = "冰冷到连周围空气都会冻结的啤酒。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/iced_beer/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.bodytemperature > 270)
		M.bodytemperature = max(270, M.bodytemperature - (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055

/datum/reagent/ethanol/grog
	name = "Grog"
	localized_name = "格罗格"
	id = "grog"
	description = "兑水的朗姆酒，维兰德-汤谷都说好！"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 0.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 0.5

/datum/reagent/ethanol/aloe
	name = "Aloe"
	localized_name = "芦荟"
	id = "aloe"
	description = "好喝得不得了。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	localized_name = "安达卢西亚"
	id = "andalusia"
	description = "名字奇怪、味道不错的饮品。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	localized_name = "盟友鸡尾酒"
	id = "alliescocktail"
	description = "用你的盟友调制而成，没用敌人调的那么甜。"
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	localized_name = "酸液喷吐"
	id = "acidspit"
	description = "勇者的饮品，调制不当可能致命！"
	reagent_state = LIQUID
	color = "#365000" // rgb: 54, 80, 0
	properties = list(PROPERTY_ALCOHOLIC = 1.5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1.5

/datum/reagent/ethanol/amasec
	name = "Amasec"
	localized_name = "阿玛赛克"
	id = "amasec"
	description = "维兰德-汤谷枪械俱乐部指定饮品！"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 2

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	localized_name = "变形怪之刺"
	id = "changelingsting"
	description = "轻抿一口，就感到火辣辣的灼烧……"
	color = "#2E6671" // rgb: 46, 102, 113
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 5

/datum/reagent/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	localized_name = "爱尔兰汽车炸弹"
	id = "irishcarbomb"
	description = "嗯，喝起来像巧克力蛋糕……"
	color = "#2E6671" // rgb: 46, 102, 113
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	localized_name = "辛迪加炸弹"
	id = "syndicatebomb"
	description = "喝出了恐怖袭击的味道！"
	color = "#2E6671" // rgb: 46, 102, 113
	properties = list(PROPERTY_ALCOHOLIC = 5, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 5

/datum/reagent/ethanol/spikedeggnog
	name = "Spiked Eggnog"
	localized_name = "加酒蛋奶饮"
	id = "spikedeggnog"
	description = "浓郁香甜的酒精饮料，传统上在圣诞节前后饮用。"
	color = "#DFD7AF" // rgb: 223, 215, 175
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	localized_name = "艾丽卡惊喜"
	id = "erikasurprise"
	description = "惊喜就是它居然是绿色的！"
	color = "#2E6671" // rgb: 46, 102, 113
	properties = list(PROPERTY_ALCOHOLIC = 3, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 3

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	localized_name = "极干马天尼"
	id = "driestmartini"
	description = "只有老手才能驾驭。你仿佛看见杯里漂着沙子。"
	nutriment_factor = 1 * FOOD_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	localized_name = "香蕉妈妈"
	id = "bananahonk"
	description = "来自小丑天堂的饮品。"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFF91" // rgb: 255, 255, 140
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/silencer
	name = "Silencer"
	localized_name = "消音器"
	id = "silencer"
	description = "来自默剧演员天堂的饮品。"
	nutriment_factor = 1 * FOOD_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	properties = list(PROPERTY_ALCOHOLIC = 4, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 4

/datum/reagent/ethanol/silencer/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	accumulated_alcohol++
	M.dizziness +=10
	if(accumulated_alcohol >= 55 && accumulated_alcohol <115)
		if(!M.stuttering) M.stuttering = 1
		M.stuttering += 10
	else if(accumulated_alcohol >= 115 && prob(33))
		M.confused = max(M.confused+15,15)

/datum/reagent/ethanol/mojito
	name = "Mojito"
	localized_name = "莫吉托"
	id = "mojito"
	description = "喝上一口，仿佛就能感受到古巴那熟悉而清新的风。"
	color = "#C0FF00" // rgb: 192, 255, 0
	properties = list(PROPERTY_ALCOHOLIC = 1, PROPERTY_FUELING = 3, PROPERTY_OXIDIZING = 3, PROPERTY_FLOWING = 2)
	boozepwr = 1
