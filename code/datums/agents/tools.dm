/obj/item/device/portable_vendor/antag
	name = "可疑的自动储物公文包"
	desc = "手提箱大小的自动存取系统，可高效存放小型物品，并按需取出。"

	w_class = SIZE_MEDIUM

	req_access = list()
	req_role = null
	listed_products = list(
		list("武器", 0, null, null, null),
		list("改装电击棍", 25, /obj/item/weapon/baton/antag, "white", "电量更充足的电击棍，经过调整，只有特工才能使用。"),
		list("麻醉枪", 25, /obj/item/weapon/gun/pistol/tranquilizer, "white", "一把麻醉枪，配有 5 支麻醉镖。不造成伤害，保证击昏目标。"),
		list("氯仿布", 18, /obj/item/weapon/chloroform, "white", "浸有氯仿的布，可有效使用 8 次。只能在目标身后使用，使用时必须切换为缴械意图。"),

		list("消耗性工具", 0, null, null, null),
		list("实验型兴奋剂药丸", 20, /obj/item/storage/pill_bottle/ultrazine/antag, "white", "可抵抗耐力伤害的实用兴奋剂，效果持续约 2 分钟。只服用 1 粒，请谨慎使用。"),
		list("诱饵手榴弹", 14, /obj/item/explosive/grenade/decoy, "white", "一枚诱饵手榴弹，会发出远处也能听见的巨大爆炸声，请远离耳朵。可使用 3 次。"),

		list("实用工具", 0, null, null, null),
		list("安全访问调谐器 v2", 25, /obj/item/device/multitool/antag, "white", "经过升级的访问调谐器，可迅速入侵各种机器。外观伪装成普通多功能工具。"),
		list("关注目标追踪器", 20, /obj/item/device/tracker, "white", "追踪附近各种关注目标的追踪器。"),

		list("工具套装", 0, null, null, null),
		list("硬汉套装", 12, /obj/item/storage/box/badass_kit, "white", "内含用于窃听敌方通讯的宪兵私人通讯加密密钥，以及能抵御闪光弹的太阳镜。"),
		list("工具套装", 15, /obj/item/storage/toolbox/antag, "white", "内含常用工具和工程手册的工具箱，帮助你闯入目标地点。"),
		list("入侵工具套装", 15, /obj/item/storage/box/antag_signaller, "white", "内含螺丝刀、多功能工具、工程手册以及 5 个信号器的盒子，可帮助你入侵门禁。"),

		list("转移积分", 0, null, null, null),
		list("1 积分", 1, /obj/item/stack/points/p1, "white", "用于在特工之间转移积分。"),
		list("5 积分", 5, /obj/item/stack/points/p5, "white", "用于在特工之间转移积分。"),
		list("20 积分", 20, /obj/item/stack/points/p20, "white", "用于在特工之间转移积分。"),
	)

	points = 40
	max_points = 100

	var/faction_belonging = "WY"

	var/list/types_to_convert = list(
		/obj/item/ammo_magazine/smg/m39 = /obj/item/ammo_magazine/smg/m39/rubber,
		/obj/item/ammo_magazine/rifle = /obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/l42a = /obj/item/ammo_magazine/rifle/l42a/rubber,
		/obj/item/ammo_magazine/pistol =  /obj/item/ammo_magazine/pistol/rubber
	)

/obj/item/device/portable_vendor/antag/allowed(mob/M)
	if(!ishuman(M))
		return FALSE

	return TRUE

/obj/item/device/portable_vendor/antag/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!allowed(user) || user.action_busy)
		return .

	var/mob/living/carbon/human/H = user
	var/obj/item/ammo_magazine/target_mag = target

	if(!istype(target_mag))
		return .

	if(target.type in types_to_convert)
		var/type_to_set = types_to_convert[target.type]

		if(target_mag.current_rounds < target_mag.max_rounds)
			to_chat(H, SPAN_WARNING("[target_mag]必须装满，才能将其中的弹药改为橡胶弹！"))
			return .

		to_chat(H, SPAN_NOTICE("你开始将[target_mag]改装为橡胶弹弹匣。"))
		playsound(user.loc, "sound/machines/fax.ogg", 5)

		if(!do_after(H, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target_mag, INTERRUPT_ALL))
			return .

		to_chat(H, SPAN_NOTICE("你将[target]改装为橡胶弹弹匣。"))
		var/obj/item/ammo_magazine/mag = new type_to_set(get_turf(user.loc))
		qdel(target)

		H.put_in_any_hand_if_possible(mag)


/obj/item/device/portable_vendor/antag/process()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/portable_vendor/antag/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/points))
		var/obj/item/stack/points/P = W

		if(points >= max_points)
			return . = ..()

		var/amount_to_add = min(P.amount, max_points - points)

		to_chat(user, SPAN_NOTICE("你将[P]插入[src]。"))

		if(P.use(amount_to_add))
			points += amount_to_add
	else
		. = ..()

/obj/item/stack/points
	name = "积分"
	singular_name = "积分"
	gender = PLURAL
	icon_state = "point"

	stack_id = "antag points"

	amount = 0
	max_amount = 40

/obj/item/stack/points/Initialize(mapload, ...)
	. = ..()
	update_name()

/obj/item/stack/points/add(extra)
	. = ..()
	update_name()

/obj/item/stack/points/use(used)
	. = ..()
	update_name()

/obj/item/stack/points/proc/update_name()
	if(amount == 1)
		name = "[amount] [initial(singular_name)]"
	else
		name = "[amount] [initial(name)]"

/obj/item/stack/points/p1
	amount = 1

/obj/item/stack/points/p5
	amount = 5

/obj/item/stack/points/p20
	amount = 20

/obj/item/device/portable_vendor/antag/cia
	name = "自动储物公文包"
	desc = "可按使用者意愿提供物品的公文包。这一个锁得严严实实，似乎无法打开。"
	points = 200
	max_points = 300
	delay = 0.5
	force = MELEE_FORCE_STRONG
	req_access = list()

	listed_products = list(
		list("文具", 0, null, null, null),
		list("笔", 1, /obj/item/tool/pen/clicky, "white", "一支随时随地都能书写的笔。"),
		list("纸张", 1, /obj/item/paper, "white", "一张供书写用的崭新纸张。"),
		list("复写纸", 1, /obj/item/paper/carbon, "white", "一张复写纸，一次书写便可留下两份。"),
		list("写字夹板", 1, /obj/item/clipboard, "white", "一块写字夹板，用来收纳写好的文件。"),

		list("武器", 0, null, null, null),
		list("M48A4 SOCOM", 25, /obj/item/weapon/gun/pistol/m1911/socom/equipped, "white", "一把定制的 M48A4，使用 .45 ACP 弹药。"),
		list("改装电击棍", 25, /obj/item/weapon/baton/antag, "white", "一根电量更充足的电击棍。"),
		list("麻醉枪", 25, /obj/item/weapon/gun/pistol/tranquilizer, "white", "一把麻醉枪，配有 5 支麻醉镖。不造成伤害，保证击昏目标。"),
		list("氯仿布", 18, /obj/item/weapon/chloroform, "white", "浸有氯仿的布，可有效使用 8 次。只能在目标身后使用，使用时必须切换为缴械意图。"),
		list("镇静剂笔", 15, /obj/item/tool/pen/sleepypen, "white", "伪装成笔的镇静剂注射器，可悄悄击昏目标。"),
		list("手铐", 2, /obj/item/restraint/handcuffs, "white", "一副手铐。"),

		list("弹药", 0, null, null, null),
		list("M1911 弹匣", 5, /obj/item/ammo_magazine/pistol/m1911, "white", "M1911 手枪使用的弹匣。"),
		list("麻醉弹匣", 5, /obj/item/ammo_magazine/pistol/tranq, "white", "麻醉手枪使用的弹匣。"),

		list("实用工具", 0, null, null, null),
		list("安全访问调谐器 v2", 25, /obj/item/device/multitool/antag, "white", "经过升级的访问调谐器，可迅速入侵各种机器。外观伪装成普通多功能工具。"),
		list("窃听器", 20, /obj/item/device/radio/listening_bug/radio_linked/cia, "white", "一个窃听器，右键点击即可将其伪装成任何物品。"),
		list("殖民地陆战队密码本", 20, /obj/item/book/codebook, "white", "一本殖民地陆战队密码本，用于向指挥官验证身份。"),
		list("工具套装", 15, /obj/item/storage/toolbox/mechanical, "white", "一个装有常用工具的工具箱。"),
		list("中央情报局挑战币", 15, /obj/item/coin/silver/cia, "white", "一枚饰有雄鹰的挑战币，可在行动现场一眼认出其他中央情报局特工。"),

		list("陆战队服装", 0, null, null, null),
		list("陆战队头盔", 5, /obj/item/clothing/head/helmet/marine, "white", "殖民地陆战队制式军用头盔。"),
		list("陆战队作战服", 8, /obj/item/clothing/under/marine, "white", "殖民地陆战队制式作战服。"),
		list("M3 式陆战队护甲", 20, /obj/item/clothing/suit/marine, "white", "殖民地陆战队战斗用制式护甲。"),
		list("M3-L 式陆战队护甲", 15, /obj/item/clothing/suit/marine/light, "white", "殖民地陆战队战斗用轻型护甲。"),
		list("M3-VL 防弹背心", 12, /obj/item/clothing/suit/storage/marine/light/vest, "white", "殖民地陆战队战斗用轻型防弹背心。"),

		list("无线电密钥", 0, null, null, null),
		list("无线电密钥：中央情报局", 10, /obj/item/device/encryptionkey/cia, "white", "用于中央情报局与殖民地陆战队通讯的无线电密钥。"),
		list("无线电密钥：殖民地执法局", 20, /obj/item/device/encryptionkey/cmb, "white", "殖民地执法局的无线电密钥。"),
		list("无线电密钥：殖民地", 20, /obj/item/device/encryptionkey/colony, "white", "用于已知当地殖民地频率的无线电密钥。"),
		list("无线电密钥：进步人民联盟", 20, /obj/item/device/encryptionkey/upp, "white", "用于已知进步人民联盟监听频率的无线电密钥。"),

		list("转移积分", 0, null, null, null),
		list("1 积分", 1, /obj/item/stack/points/p1, "white", "用于在特工之间转移积分。"),
		list("5 积分", 5, /obj/item/stack/points/p5, "white", "用于在特工之间转移积分。"),
		list("20 积分", 20, /obj/item/stack/points/p20, "white", "用于在特工之间转移积分。"),
	)

/obj/item/device/portable_vendor/antag/cia/covert
	name = "公文包"
	icon_state = "briefcase"
	desc = "采用货真价实的人造皮革制成，价格标签还没摘。它的主人一定是个真正的专业人士。"
	covert = TRUE
