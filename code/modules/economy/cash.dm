/obj/item/spacecash
	name = "15美元"
	desc = "你有15美元。"
	gender = PLURAL
	icon = 'icons/obj/items/items.dmi'
	icon_state = "spacecash1"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	force = 1
	throwforce = 1
	throw_speed = SPEED_FAST
	throw_range = 2
	w_class = SIZE_TINY
	var/worth = 15
	/// 'Counterfeit' bills cannot be inserted into the black market for dosh. Their worth is also quartered when entered into an ATM.
	var/counterfeit = FALSE

/obj/item/spacecash/Initialize(mapload, ...)
	. = ..()
	update_value()

/obj/item/spacecash/proc/update_value()
	if(counterfeit)
		return
	black_market_value = worth // While money can be inserted directly into the console, this will allow CTs to detect if the money is 'counterfeit' with their scanner.

/obj/item/spacecash/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/attack_cash = W
		if(istype(attack_cash, /obj/item/spacecash/ewallet))
			return FALSE
		if(attack_cash.counterfeit != src.counterfeit)
			to_chat(user, SPAN_NOTICE("这两叠钞票不知为何似乎不太一样……"))
			return

		var/obj/item/spacecash/bundle/bundle
		if(!istype(W, /obj/item/spacecash/bundle))
			var/obj/item/spacecash/cash = W
			user.temp_drop_inv_item(cash)
			bundle = new (src.loc)
			bundle.worth += cash.worth
			bundle.update_value()
			qdel(cash)
		else //is bundle
			bundle = W
		bundle.worth += src.worth
		bundle.update_value()
		bundle.update_icon()
		if(istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/h_user = user
			h_user.temp_drop_inv_item(src)
			h_user.temp_drop_inv_item(bundle)
			h_user.put_in_hands(bundle)
		to_chat(user, SPAN_NOTICE("你将价值[src.worth]美元的钞票加入了钞票堆。<br>现在共有[bundle.worth]美元。"))
		qdel(src)

/obj/item/spacecash/bundle
	name = "一叠钞票"
	icon_state = ""
	desc = "总值0美元。"
	worth = 0

/obj/item/spacecash/bundle/update_icon()
	overlays.Cut()
	var/sum = worth
	var/num = 0
	for(var/i in list(1000,500,200,100,50,20,10,1))
		while(sum >= i && num < 50)
			sum -= i
			num++
			var/image/banknote = image('icons/obj/items/items.dmi', "spacecash[i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			overlays += banknote
	if(num == 0) // Less than one thaler, let's just make it look like 1 for ease
		var/image/banknote = image('icons/obj/items/items.dmi', "spacecash1")
		var/matrix/M = matrix()
		M.Translate(rand(-6, 6), rand(-4, 8))
		M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
		banknote.transform = M
		overlays += banknote
	desc = "总值[worth]美元。"

/obj/item/spacecash/bundle/attack_self(mob/user)
	..()
	var/oldloc = loc
	var/amount = tgui_input_number(user, "你想取出多少美元？（0到[src.worth]）", "取出钞票", 0, src.worth, 0)
	amount = floor(clamp(amount, 0, src.worth))
	if(amount == 0)
		return
	if(QDELETED(src) || loc != oldloc)
		return

	src.worth -= amount
	src.update_icon()
	if(!worth)
		usr.temp_drop_inv_item(src)

	if(amount in list(1000,500,200,100,50,20,1))
		var/cashtype = text2path("/obj/item/spacecash/c[amount]")
		var/obj/cash = new cashtype (usr.loc)
		user.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new (usr.loc)
		bundle.worth = amount
		bundle.update_icon()
		user.put_in_hands(bundle)

	if(!worth)
		qdel(src)

/obj/item/spacecash/c1
	name = "1美元纸币"
	icon_state = "spacecash1"
	desc = "美国政府发行的1美元纸币，上面印着乔治·华盛顿。大多数英格兰人看了都会哭，但它其实不值多少钱。在某些星系里，大概能买半根热狗。"
	worth = 1

/obj/item/spacecash/c10
	name = "10美元纸币"
	icon_state = "spacecash10"
	desc = "美国政府发行的10美元纸币，上面印着亚历山大·汉密尔顿——联邦银行的拥护者，一场恶性捣乱事件的受害者。大概够在廉价餐馆吃顿饭，不含税费和小费。"
	worth = 10

/obj/item/spacecash/c20
	name = "20美元纸币"
	icon_state = "spacecash20"
	desc = "美国政府发行的20美元纸币，上面印着安德鲁·杰克逊——1812年战争的著名英雄，也是到处屠杀原住民的人。大概够你在殖民地的本地牛排馆吃顿不错的两道菜套餐。"
	worth = 20

/obj/item/spacecash/c50
	name = "50美元纸币"
	icon_state = "spacecash50"
	desc = "美国政府发行的50美元纸币，上面印着尤利西斯·S·格兰特。他以在内战中把士兵当消耗品的战术闻名，可能还是比尔·卡森的远亲。大概够请全酒吧喝杯啤酒——前提是酒吧里另外只有4个人。"
	worth = 50

/obj/item/spacecash/c100
	name = "100美元纸币"
	icon_state = "spacecash100"
	desc = "美国政府发行的100美元纸币，上面印着放风筝引雷的奇人本杰明·富兰克林。大概够你一天的上岸休假开销，前提是你不乱花钱。（但你偏偏会。）"
	worth = 100

/obj/item/spacecash/c200
	name = "200美元"
	icon_state = "spacecash200"
	desc = "两张美国政府发行的100美元纸币，上面都印着本杰明·富兰克林。两位本杰明从不同角度，热切而期待地望着你。"
	worth = 200

/obj/item/spacecash/c500
	name = "500美元"
	icon_state = "spacecash500"
	desc = "五张美国政府发行的100美元纸币，上面都印着本杰明·富兰克林。他们急切地瞪着你，让你觉得自己欠了他们什么。"
	worth = 500

/obj/item/spacecash/c500/counterfeit
	// If you're going to slap down huge sums of cash in easily reachable spots for RP or flavor reasons, make them counterfeit, so they don't break the black market - they will be rejected.
	counterfeit = TRUE

/obj/item/spacecash/c1000
	name = "1000美元"
	icon_state = "spacecash1000"
	desc = "十张美国政府发行的100美元纸币，每一张上面都他妈印着本杰明·富兰克林。一屋子的本杰明不耐烦地坐着，仿佛都认为自己才是你的唯一。这群愤怒的本杰明已经知道你和其他本杰明的关系，现在要你给个说法。"
	worth = 1000

/obj/item/spacecash/c1000/counterfeit
	// If you're going to slap down huge sums of cash in easily reachable spots for RP or flavor reasons, make them counterfeit, so they don't break the black market - they will be rejected.
	counterfeit = TRUE

/proc/spawn_money(sum, spawnloc, mob/living/carbon/human/human_user as mob)
	if(sum in list(1000,500,200,100,50,20,10,1))
		var/cash_type = text2path("/obj/item/spacecash/c[sum]")
		var/obj/cash = new cash_type (usr.loc)
		if(ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(cash)
	else
		var/obj/item/spacecash/bundle/bundle = new (spawnloc)
		bundle.worth = sum
		bundle.update_icon()
		if (ishuman(human_user) && !human_user.get_active_hand())
			human_user.put_in_hands(bundle)
	return

/obj/item/spacecash/ewallet
	name = "\improper 维兰德-汤谷现金卡"
	icon_state = "efundcard"
	desc = "由维兰德-汤谷担保、可储存资金的现金卡。"
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/spacecash/ewallet/get_examine_text(mob/user)
	. = ..()
	if(user == loc)
		. += SPAN_NOTICE("现金卡持有人：[owner_name]。剩余金额：[worth]美元。")
