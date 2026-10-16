

//*****************************************************************************************************/
//******DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum**********/
//*****************************************************************************************************/

/datum/reagent/drink
	name = "Drink"
	localized_name = "饮料"
	id = "drink"
	description = "呃，某种饮料。"
	reagent_state = LIQUID
	nutriment_factor = 0.5 * REAGENTS_METABOLISM
	// Drinks should be used up faster than other reagents.
	custom_metabolism = FOOD_METABOLISM
	color = "#E78108" // rgb: 231, 129, 8
	var/adj_dizzy = 0
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/datum/reagent/drink/on_mob_life(mob/living/M, alien, delta_time)
	. = ..()
	if(!.)
		return
	//This is all way too snowflake to accurately transition to the property system so it stays here
	M.nutrition += nutriment_factor * delta_time
	if(adj_dizzy)
		M.dizziness = max(0,M.dizziness + adj_dizzy * delta_time)
	if(adj_drowsy)
		M.drowsyness = max(0,M.drowsyness + adj_drowsy * delta_time)
	if(adj_sleepy)
		M.sleeping = max(0,M.sleeping + adj_sleepy * delta_time)
	if(adj_temp && M.bodytemperature < 310) //310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT * delta_time))
		M.recalculate_move_delay = TRUE

/datum/reagent/drink/cold
	name = "Cold drink"
	localized_name = "冷饮"
	adj_temp = 0


//FRIUT JUICE//

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	localized_name = "橙汁"
	id = "orangejuice"
	description = "既美味又富含维生素 C，还求什么呢？"
	color = "#E78108" // rgb: 231, 129, 8

/datum/reagent/drink/orangejuice/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.getOxyLoss() && prob(30))
		M.apply_damage(-1, OXY)

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	localized_name = "番茄汁"
	id = "tomatojuice"
	description = "把番茄榨成了汁。这么大又多汁的番茄，真可惜，对吧？"
	color = "#731008" // rgb: 115, 16, 8

/datum/reagent/drink/tomatojuice/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.getFireLoss() && prob(20)) M.heal_limb_damage(0,1)


/datum/reagent/drink/limejuice
	name = "Lime Juice"
	localized_name = "青柠汁"
	id = "limejuice"
	description = "酸甜的青柠果汁。"
	color = "#365E30" // rgb: 54, 94, 48

/datum/reagent/drink/limejuice/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.getToxLoss() && prob(20)) M.apply_damage(-1*REM, TOX)

/datum/reagent/drink/carrotjuice
	name = "Carrot juice"
	localized_name = "胡萝卜汁"
	id = "carrotjuice"
	description = "和胡萝卜一样，只是不用嚼了。"
	color = "#973800" // rgb: 151, 56, 0

/datum/reagent/drink/carrotjuice/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	M.ReduceEyeBlur(1)
	M.ReduceEyeBlind(1)
	if(!data)
		data = 1
	switch(data)
		if(21 to INFINITY)
			if(prob(data-10))
				M.disabilities &= ~NEARSIGHTED
	data++

/datum/reagent/drink/berryjuice
	name = "Berry Juice"
	localized_name = "混合莓果汁"
	id = "berryjuice"
	description = "由多种不同莓果调成的美味果汁。"
	color = "#990066" // rgb: 153, 0, 102

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	localized_name = "葡萄汁"
	id = "grapejuice"
	description = "葡——萄味，棒极啦！"
	color = "#863333" // rgb: 134, 51, 51

/datum/reagent/drink/poisonberryjuice
	name = "Poison Berry Juice"
	localized_name = "毒莓汁"
	id = "poisonberryjuice"
	description = "由多种剧毒莓果混合而成的美味果汁。"
	color = "#863353" // rgb: 134, 51, 83

/datum/reagent/drink/poisonberryjuice/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.apply_damage(1, TOX)

/datum/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	localized_name = "西瓜汁"
	id = "watermelonjuice"
	description = "西瓜榨成的美味果汁。"
	color = "#a71d1d" // rgb: 167, 29, 29

/datum/reagent/drink/lemonjuice
	name = "Lemon Juice"
	localized_name = "柠檬汁"
	id = "lemonjuice"
	description = "这果汁酸得要命。"
	color = "#d1db42" // rgb: 209, 219, 66

/datum/reagent/drink/banana
	name = "Banana Juice"
	localized_name = "香蕉汁"
	id = "banana"
	description = "香蕉的原汁精华。"
	color = "#e4c439" // rgb: 228, 196, 57

/datum/reagent/drink/potato_juice
	name = "Potato Juice"
	localized_name = "土豆汁"
	id = "potato"
	description = "土豆榨的汁。呸。"
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	localized_name = "红石榴糖浆"
	id = "grenadine"
	description = "如今都用合适的石榴替代品制作。反正谁还用真水果呢？"
	color = "#FF004F" // rgb: 255, 0, 79

/datum/reagent/drink/pineapplejuice
	name = "Pineapple Juice"
	localized_name = "菠萝汁"
	id = "pineapplejuice"
	description = "酸爽清新，风味宜人。"
	color = "#FFC000" // rgb: 255, 192, 0

/datum/reagent/drink/applejuice
	name = "Apple Juice"
	localized_name = "苹果汁"
	id = "applejuice"
	description = "苹果怡人的甜味，如今成了液体。"
	color = "#f59a40" // rgb: 245, 154, 64


//MILK//

/datum/reagent/drink/milk
	name = "Milk"
	localized_name = "牛奶"
	id = "milk"
	description = "哺乳动物乳腺分泌的不透明白色液体。"
	color = "#DFDFDF" // rgb: 223, 223, 223

/datum/reagent/drink/milk/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(M.getBruteLoss() && prob(20))
		M.heal_limb_damage(1,0)
	holder.remove_reagent("capsaicin", 10*REAGENTS_METABOLISM)
	holder.remove_reagent("hotsauce", 10*REAGENTS_METABOLISM)

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	localized_name = "豆奶"
	id = "soymilk"
	description = "由大豆制成的不透明白色液体。"
	color = "#DFDFC7" // rgb: 223, 223, 199

/datum/reagent/drink/milk/coconut
	name = "Coconut Milk"
	localized_name = "椰奶"
	id = "coconutmilk"
	description = "从椰子中提取的半透明乳状液体，非常稀淡，单独喝几乎没什么味道。"
	color = "#DFDFC7" // rgb: 223, 223, 199
	chemclass = CHEM_CLASS_NONE
	flags = REAGENT_NO_GENERATION

/datum/reagent/drink/milk/cream
	name = "Cream"
	localized_name = "奶油"
	id = "cream"
	description = "牛奶中富含脂肪、仍呈液态的部分。何不兑点苏格兰威士忌试试？"
	color = "#DFD7AF" // rgb: 223, 215, 175

/datum/reagent/drink/milk/chocolate
	name = "Chocolate Milk"
	localized_name = "巧克力牛奶"
	id = "chocolatemilk"
	description = "将哺乳动物乳腺的产物与糖、可可混合制成的不透明棕色液体。"
	color = "#4b3b2f" // rgb: 223, 215, 175

/datum/reagent/drink/milk/eggnog
	name = "Eggnog"
	localized_name = "蛋奶饮"
	id = "eggnog"
	description = "浓郁香甜的无酒精饮料，传统上在圣诞节前后饮用。"
	color = "#DFD7AF" // rgb: 223, 215, 175

/datum/reagent/drink/cold/milkshake
	name = "Milkshake"
	localized_name = "奶昔"
	description = "冰得脑门疼的绝妙混合饮品。"
	id = "milkshake"
	color = "#AEE5E4" // rgb" 174, 229, 228
	adj_temp = 0

/datum/reagent/drink/cold/milkshake/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(!M)
		M = holder.my_atom
	if(prob(1))
		M.emote("shiver")
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, T0C)
	M.recalculate_move_delay = TRUE
	holder.remove_reagent("capsaicin", 5)
	holder.remove_reagent("hotsauce", 5)
	holder.remove_reagent(src.id, FOOD_METABOLISM)

//SOUTO//

/datum/reagent/drink/souto
	name = "Souto Classic"
	localized_name = "经典索托"
	id = "souto_classic"
	description = "在哈瓦那灌装的橘子味汽水。"
	color = "#802b00"
	adj_drowsy = -10
	chemclass = CHEM_CLASS_RARE

/datum/reagent/drink/souto/cherry
	name = "Cherry Souto"
	localized_name = "樱桃味索托"
	id = "souto_cherry"
	description = "在哈瓦那灌装的樱桃味汽水。"
	color = COLOR_MAROON

/datum/reagent/drink/souto/lime
	name = "Lime Souto"
	localized_name = "青柠味索托"
	id = "souto_lime"
	description = "在哈瓦那灌装的青柠味汽水。"
	color = "#878F00"

/datum/reagent/drink/souto/grape
	name = "Grape Souto"
	localized_name = "葡萄味索托"
	id = "souto_grape"
	description = "在哈瓦那灌装的葡萄味汽水。"
	color = "#421C52"

/datum/reagent/drink/souto/blueraspberry
	name = "Blue Raspberry Souto"
	localized_name = "蓝树莓味索托"
	id = "souto_blueraspberry"
	description = "在哈瓦那灌装的蓝色果味汽水。"
	color = "#005B96"

/datum/reagent/drink/souto/peach
	name = "Peach Souto"
	localized_name = "桃子味索托"
	id = "souto_peach"
	description = "在哈瓦那灌装的桃子味汽水，里面还漂着些桃核碎屑。"
	color = "#FFE5B4"

/datum/reagent/drink/souto/cranberry
	name = "Cranberry Souto"
	localized_name = "蔓越莓味索托"
	id = "souto_cranberry"
	description = "在哈瓦那灌装的蔓越莓味汽水。"
	color = "#950714"

/datum/reagent/drink/souto/vanilla
	name = "Vanilla Souto"
	localized_name = "香草味索托"
	id = "souto_vanilla"
	description = "在哈瓦那灌装的香草味汽水。"
	color = "#F9E5BC"

/datum/reagent/drink/souto/pineapple
	name = "Pineapple Souto"
	localized_name = "菠萝味索托"
	id = "souto_pineapple"
	description = "在哈瓦那灌装的菠萝味汽水。"
	color = "#FEEB75"

//OTHER SODA//

/datum/reagent/drink/cold/sodawater
	name = "Soda Water"
	localized_name = "苏打水"
	id = "sodawater"
	description = "一罐苏打水。何不调杯苏格兰威士忌苏打？"
	color = "#619494" // rgb: 97, 148, 148
	adj_dizzy = -5
	adj_drowsy = -3

/datum/reagent/drink/cold/grapesoda
	name = "Grape Soda"
	localized_name = "葡萄汽水"
	id = "grapesoda"
	description = "葡萄调成的好喝汽水。"
	color = "#421C52" // rgb: 98, 57, 53
	adj_drowsy = -3

/datum/reagent/drink/cold/space_cola
	name = "Coca-Cola"
	localized_name = "可口可乐"
	id = "cola"
	description = "一种清爽的饮料。"
	reagent_state = LIQUID
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy = -3

/datum/reagent/drink/cold/pepsi
	name = "Pepsi"
	localized_name = "百事可乐"
	id = "pepsi"
	description = "一种清爽的饮料。"
	reagent_state = LIQUID
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy = -3

/datum/reagent/drink/cold/wy_cola
	name = "Fruit Beer"
	localized_name = "果啤"
	id = "fruit_beer"
	description = "令人受辱的芒果味饮料，喝起来像烂水果。"
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy = -3

/datum/reagent/drink/cold/nuka_cola
	name = "Nuka Cola"
	localized_name = "核子可乐"
	id = "nuka_cola"
	description = "可乐，可乐从未改变。"
	color = "#100800" // rgb: 16, 8, 0
	adj_sleepy = -2

/datum/reagent/drink/cold/nuka_cola/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness +=5
	M.drowsyness = 0

/datum/reagent/drink/cold/spacemountainwind
	name = "Mountain Dew"
	localized_name = "激浪"
	id = "spacemountainwind"
	description = "真正键盘侠们的最爱。"
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -7
	adj_sleepy = -1

/datum/reagent/drink/cold/dr_gibb
	name = "Dr Pepper"
	localized_name = "胡椒博士"
	id = "dr_gibb"
	description = "23 种不同风味融合而成的美味。"
	color = "#110b03" // rgb: 16, 32, 0
	adj_drowsy = -6

/datum/reagent/drink/cold/space_up
	name = "7-UP"
	localized_name = "七喜"
	id = "space_up"
	description = "许多鸡尾酒的好搭档。"
	color = "#677c12" // rgb: 32, 40, 0
	adj_temp = 0

//BEER//

/datum/reagent/drink/wy_beer
	name = "Aspen Beer"
	localized_name = "阿斯彭啤酒"
	id = "aspen"
	description = "只要不在意喝起来像尿，其实还不错。由维兰德-汤谷公司灌装。"
	color = "#ffcc66"



//COFFEE/TEA//

/datum/reagent/drink/coffee
	name = "Coffee"
	localized_name = "咖啡"
	id = "coffee"
	description = "咖啡是用咖啡树经过烘焙的种子冲煮而成的饮料，这些种子通常被称为咖啡豆。"
	color = "#482000" // rgb: 72, 32, 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL*6
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 5
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/drink/coffee/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(adj_temp > 0 && holder)
		holder.remove_reagent("frostoil", 10*REAGENTS_METABOLISM)

	if(volume > overdose)
		if(!ishuman(M))
			return
		var/mob/living/carbon/human/H = M
		if(prob(5))
			M.emote(pick("twitch", "blink_r", "shiver"))
		if(volume > overdose_critical)
			M.apply_damage(2, TOX) //Overdose starts getting bad
			M.make_jittery(10)
			M.apply_effect(20, PARALYZE)
			var/datum/internal_organ/heart/E = H.internal_organs_by_name["heart"]
			if(prob(10) && E)
				E.take_damage(0.5, TRUE)
				M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	localized_name = "冰咖啡"
	id = "icecoffee"
	description = "咖啡加冰，清爽凉快。"
	color = "#102838" // rgb: 16, 40, 56
	adj_temp = 0
	chemclass = CHEM_CLASS_NONE

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	localized_name = "豆奶拿铁"
	id = "soy_latte"
	description = "读嬉皮士书籍时，来杯这个既惬意又美味。"
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5
	chemclass = CHEM_CLASS_NONE

/datum/reagent/drink/coffee/soy_latte/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.sleeping = 0
	if(M.getBruteLoss() && prob(20)) M.heal_limb_damage(1,0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	localized_name = "拿铁咖啡"
	id = "cafe_latte"
	description = "适合阅读时享用的饮料，浓郁又美味。"
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5

/datum/reagent/drink/coffee/cafe_latte/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.sleeping = 0
	if(M.getBruteLoss() && prob(20)) M.heal_limb_damage(1,0)

/datum/reagent/drink/tea
	name = "Tea"
	localized_name = "茶"
	id = "tea"
	description = "含有抗氧化物质的红茶。"
	color = "#101000" // rgb: 16, 16, 0
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 5
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/drink/tea/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(M.getToxLoss() && prob(20))
		M.apply_damage(-1, TOX)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	localized_name = "冰茶"
	id = "icetea"
	description = "与某位说唱歌手兼演员毫无关系。"
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = 0

/datum/reagent/drink/tea_leaves
	name = "Tea leaves"
	localized_name = "茶叶"
	id = "tea_leaves"
	description = "冻干红茶叶。"
	color = "#1a2b1c" // rgb: 16, 16, 0
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	chemclass = CHEM_CLASS_NONE
	flags = REAGENT_NO_GENERATION

//OTHER//

/datum/reagent/drink/nothing
	name = "Nothing"
	localized_name = "虚无"
	id = "nothing"
	description = "彻彻底底的虚无。"

/datum/reagent/machosauce
	name = "Macho Sauce"
	localized_name = "猛男酱"
	id = "machosauce"
	description = "诞生于禁闭区最黑暗角落的地下怪饮，由辣椒喷雾和索托调成，只有最疯狂的军人才会喝。"
	reagent_state = LIQUID
	color = "#d1001c" // rgb: 209, 0, 28
	chemclass = CHEM_CLASS_RARE
	custom_metabolism = RAPID_METABOLISM

	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_HYPERTHERMIC = 8)

/datum/reagent/drink/cold/tonic
	name = "Tonic Water"
	localized_name = "汤力水"
	id = "tonic"
	description = "味道古怪，但至少其中的奎宁能预防太空疟疾。"
	color = "#664300" // rgb: 102, 67, 0
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2

/datum/reagent/drink/cold/ice
	name = "Ice"
	localized_name = "冰"
	id = "ice"
	description = "冻住的水。你的牙医可不希望你嚼这个。"
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148

/datum/reagent/drink/cold/lemon_lime
	name = "Lemon Lime"
	localized_name = "柠檬青柠汽水"
	description = "酸爽的饮料，含 0.5% 天然柑橘成分！"
	id = "lemon_lime"
	color = "#878F00" // rgb: 135, 40, 0
	adj_temp = 0

/datum/reagent/drink/cold/lemonade
	name = "Lemonade"
	localized_name = "柠檬水"
	description = "啊，真让人怀念……"
	id = "lemonade"
	color = COLOR_YELLOW

//*****************************************************************************************************/
//***************************************Remove When Safe**********************************************/
//*****************************************************************************************************/

/datum/reagent/atomicbomb
	name = "Atomic Bomb"
	localized_name = "原子弹"
	id = "atomicbomb"
	description = "核扩散从未如此美味。"
	reagent_state = LIQUID
	color = "#666300" // rgb: 102, 99, 0

/datum/reagent/atomicbomb/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.druggy = max(M.druggy, 50)
	M.confused = max(M.confused+2,0)
	M.make_dizzy(10)
	if(!M.stuttering) M.stuttering = 1
	M.stuttering += 3
	if(!data) data = 1
	data++
	switch(data)
		if(51 to 200)
			M.sleeping++
		if(201 to INFINITY)
			M.sleeping++
			M.apply_damage(2, TOX)

/datum/reagent/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	localized_name = "泛银河漱口爆破酒"
	id = "gargleblaster"
	description = "哇，这东西看起来很不稳定！"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/gargle_blaster/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	if(!data) data = 1
	data++
	M.dizziness +=6
	if(data >= 15 && data <45)
		if(!M.stuttering) M.stuttering = 1
		M.stuttering += 3
	else if(data >= 45 && prob(50) && data <55)
		M.confused = max(M.confused+3,0)
	else if(data >=55)
		M.druggy = max(M.druggy, 55)
	else if(data >=200)
		M.apply_damage(2, TOX)

/datum/reagent/neurotoxin
	name = "Neurotoxin"
	localized_name = "神经毒素"
	id = "neurotoxin"
	description = "使目标陷入假死状态的强效神经毒素。"
	reagent_state = LIQUID
	color = "#2E2E61" // rgb: 46, 46, 97

/datum/reagent/neurotoxin/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!.) return
	M.KnockDown(5)
	if(!data) data = 1
	data++
	M.dizziness +=6
	if(data >= 15 && data <45)
		if(!M.stuttering) M.stuttering = 1
		M.stuttering += 3
	else if(data >= 45 && prob(50) && data <55)
		M.confused = max(M.confused+3,0)
	else if(data >=55)
		M.druggy = max(M.druggy, 55)
	else if(data >=200)
		M.apply_damage(2, TOX)

/datum/reagent/hippies_delight
	name = "Hippies' Delight"
	localized_name = "嬉皮士之乐"
	id = "hippiesdelight"
	description = "老兄，你就是不懂啊。"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0

/datum/reagent/hippies_delight/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.druggy = max(M.druggy, 50)
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 5)
			if(!M.stuttering) M.stuttering = 1
			M.make_dizzy(10)
			if(prob(10)) M.emote(pick("twitch","giggle"))
		if(5 to 10)
			if(!M.stuttering) M.stuttering = 1
			M.make_jittery(20)
			M.make_dizzy(20)
			M.druggy = max(M.druggy, 45)
			if(prob(20)) M.emote(pick("twitch","giggle"))
		if(10 to 200)
			if(!M.stuttering) M.stuttering = 1
			M.make_jittery(40)
			M.make_dizzy(40)
			M.druggy = max(M.druggy, 60)
			if(prob(30)) M.emote(pick("twitch","giggle"))
		if(200 to INFINITY)
			if(!M.stuttering) M.stuttering = 1
			M.make_jittery(60)
			M.make_dizzy(60)
			M.druggy = max(M.druggy, 75)
			if(prob(40)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.apply_damage(2, TOX)
	holder.remove_reagent(src.id, 0.2)

/datum/reagent/drink/cold/rewriter
	name = "Rewriter"
	localized_name = "改写者"
	description = "图书管理员圣所里的秘密……"
	id = "rewriter"
	color = "#485000" // rgb:72, 080, 0

/datum/reagent/drink/cold/rewriter/on_mob_life(mob/living/M)
	. = ..()
	if(!.) return
	M.make_jittery(5)

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	localized_name = "医生之乐"
	id = "doctorsdelight"
	description = "每天喝一口，医疗机器人远离我。这样大概最好。"
	color = "#FF8CFF" // rgb: 255, 140, 255
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	properties = list(PROPERTY_NEOGENETIC = 0.5, PROPERTY_ANTICORROSIVE = 0.5, PROPERTY_ANTITOXIC = 0.5, PROPERTY_OXYGENATING = 0.5, PROPERTY_RELAXING = 1)
	adj_dizzy = -3

/datum/reagent/drink/cold/kiraspecial
	name = "Kira Special"
	localized_name = "基拉特调"
	description = "那个被所有人误认成女孩的家伙万岁。笨蛋！"
	id = "kiraspecial"
	color = "#CCCC99" // rgb: 204, 204, 153

/datum/reagent/drink/cold/brownstar
	name = "Brown Star"
	localized_name = "棕星"
	description = "不是你听名字想的那回事……"
	id = "brownstar"
	color = "#9F3400" // rgb: 159, 052, 000
	adj_temp = 0


/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	localized_name = "热巧克力"
	id = "hot_coco"
	description = "加热的巧克力饮料。"
	reagent_state = LIQUID
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#403010" // rgb: 64, 48, 16
	chemclass = CHEM_CLASS_RARE
	adj_temp = 5

/datum/reagent/drink/bugjuice
	name = "Bug Juice"
	localized_name = "虫汁"
	id = "bugjuice"
	description = "用各种昆虫制成的汽水，营养十分丰富。"
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#2ca314" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
