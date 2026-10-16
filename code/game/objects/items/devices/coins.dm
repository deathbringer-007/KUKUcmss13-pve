//*****************************Coin********************************/

/obj/item/coin
	icon = 'icons/obj/items/items.dmi'
	name = "硬币"
	icon_state = "coin"
	flags_atom = FPRINT|CONDUCT
	force = 0
	throwforce = 0
	w_class = SIZE_TINY
	black_market_value = 10
	var/string_attached
	var/sides = 2
	ground_offset_x = 8
	ground_offset_y = 4

/obj/item/coin/gold
	name = "金币"
	desc = "一枚纯金铸造的硬币。"
	icon_state = "coin_gold"
	black_market_value = 30

/obj/item/coin/silver
	name = "银币"
	desc = "一枚纯银铸造的硬币。"
	icon_state = "coin_silver"
	black_market_value = 25

//CO coin
/obj/item/coin/silver/falcon
	name = "坠落猎鹰挑战币"
	desc = "一枚刻有坠落猎鹰徽记的小硬币。"

/obj/item/coin/silver/cia
	name = "银币"
	desc = "一枚银币，正面刻着一只鹰。"

/obj/item/coin/copper
	name = "铜币"
	desc = "一种常见却不太值钱的货币。"
	icon_state = "coin_copper"
	black_market_value = 30

/obj/item/coin/diamond
	name = "钻石币"
	desc = "一枚由完美无瑕的钻石制成的硬币。"
	icon_state = "coin_diamond"
	black_market_value = 35

/obj/item/coin/iron
	name = "铁币"
	desc = "一枚用坚硬的铁铸造的硬币。你担心它会生锈。"
	icon_state = "coin_iron"
	black_market_value = 15

/obj/item/coin/phoron
	name = "固态弗燃素币"
	desc = "弗燃素本可以用在更有价值的地方。"
	icon_state = "coin_phoron"
	black_market_value = 35

/obj/item/coin/uranium
	name = "铀币"
	desc = "一枚有放射性的硬币。别碰！"
	icon_state = "coin_uranium"
	black_market_value = 35

/obj/item/coin/platinum
	name = "铂金币"
	desc = "一枚用闪亮铂金制成的硬币，相当值钱。"
	icon_state = "coin_platinum"
	black_market_value = 35

/obj/item/coin/chitin
	name = "几丁质币"
	desc = "用坚韧的异形几丁质压成的硬币。几丁质明明有更好的用途……"
	icon_state = "coin_chitin"
	black_market_value = 35

/obj/item/coin/clown
	name = "小丑币"
	desc = "闻起来像香蕉。每一枚都由一个迷你小丑深情地把脸压在上面印出来。嘟嘟！"
	icon_state = "coin_clown"
	black_market_value = 35

/obj/item/coin/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(string_attached)
			to_chat(user, SPAN_NOTICE("这枚硬币上已经系着绳子了。"))
			return
		if (CC.use(1))
			overlays += image('icons/obj/items/items.dmi',"coin_string_overlay")
			string_attached = 1
			to_chat(user, SPAN_NOTICE("你给硬币系上了绳子。"))
		else
			to_chat(user, SPAN_NOTICE("这卷电缆似乎已经用完了。"))
		return
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(!string_attached)
			..()
			return

		var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
		CC.amount = 1
		CC.updateicon()
		overlays = list()
		string_attached = null
		to_chat(user, SPAN_NOTICE("你解下了硬币上的绳子。"))
	else ..()

/obj/item/coin/attack_self(mob/user)
	..()
	var/result = rand(1, sides)
	var/comment = ""
	if(result == 1)
		comment = "反面"
	else if(result == 2)
		comment = "正面"
	user.visible_message(SPAN_NOTICE("[user]抛起了[src]。落地后是[comment]朝上！"), \
						SPAN_NOTICE("你抛起了[src]。落地后是[comment]朝上！"))


/obj/item/coin/marine
	name = "陆战队装备兑换币"
	desc = "不知道它有什么用？"
	icon_state = "coin_copper"
	black_market_value = 0
	/// What is the token for?
	var/token_type = VEND_TOKEN_VOID

/obj/item/coin/marine/attackby(obj/item/W as obj, mob/user as mob) //To remove attaching a string functionality
	return

/obj/item/coin/marine/engineer
	name = "陆战队工程兵支援装备兑换币"
	desc = "投入工程兵装备供应机，可领取一件支援武器。"
	icon_state = "coin_gold"
	token_type = VEND_TOKEN_ENGINEER

/obj/item/coin/marine/specialist
	name = "陆战队专家武器兑换币"
	desc = "投入USCM装备供应机，可领取一件极具杀伤力的武器。"
	icon_state = "coin_diamond"
	token_type = VEND_TOKEN_SPEC

/obj/item/coin/marine/synth
	name = "合成人实验工具兑换币"
	desc = "投入合成人实验工具供应机，可领取各种实验性支援工具。"
	icon_state = "coin_synth"
	token_type = VEND_TOKEN_SYNTH
