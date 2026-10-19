/obj/item/prop
	name = "道具"
	desc = "某种道具。"

/// A prop that acts as a replacement for another item, mimicking their looks.
/// Mainly used in Reqs Tutorial to provide the full item selections without side effects.
/obj/item/prop/replacer
	/// The type that this object is taking the place of
	var/original_type

/obj/item/prop/replacer/Initialize(mapload, obj/original_type)
	if(!original_type)
		return INITIALIZE_HINT_QDEL
	. = ..()
	src.original_type = original_type
	var/obj/created_type = new original_type // Instancing this for the sake of assigning its appearance to the prop and nothing else
	name = initial(original_type.name)
	icon = initial(original_type.icon)
	icon_state = initial(original_type.icon_state)
	desc = initial(original_type.desc)
	if(ispath(original_type, /obj/item))
		var/obj/item/item_type = original_type
		item_state = initial(item_type.item_state)

	appearance = created_type.appearance
	qdel(created_type)

/obj/item/prop/laz_top
	name = "激光手提电脑"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "laptop-gun"
	item_state = ""
	desc = "一把被压缩进手提电脑里的雷克西姆 RXF-M5 舱外活动手枪！也称“激光手提电脑”。它属于一系列隐蔽暗杀武器，分别为大阿根廷与美国的秘密计划开发。"
	w_class = SIZE_SMALL
	garbage = TRUE

/obj/item/prop/geiger_counter
	name = "盖革计数器"
	desc = "盖革计数器用于测量接收到的辐射。这一型号只要装有电池，开启后就会自动记录并传输读数，无需用户进一步操作。"
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "geiger"
	item_state = ""
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_WAIST
	///Whether the geiger counter is on or off
	var/toggled_on = FALSE
	///Iconstate of geiger counter when on
	var/enabled_state = "geiger_on"
	///Iconstate of geiger counter when off
	var/disabled_state = "geiger"
	///New battery it will spawn with
	var/starting_battery = /obj/item/cell/crap
	///Battery inside geiger counter
	var/obj/item/cell/battery //It doesn't drain the battery, but it has a battery for emergency use

/obj/item/prop/geiger_counter/Initialize(mapload, ...)
	. = ..()
	if(!starting_battery)
		return
	battery = new starting_battery(src)

/obj/item/prop/geiger_counter/Destroy()
	. = ..()
	if(battery)
		qdel(battery)

/obj/item/prop/geiger_counter/attack_self(mob/user)
	. = ..()
	toggled_on = !toggled_on
	if(!battery)
		to_chat(user, SPAN_NOTICE("[src]没有电池。"))
		return
	to_chat(user, SPAN_NOTICE("你[toggled_on ? "开启" : "关闭"]了[src]。"))
	update_icon()

/obj/item/prop/geiger_counter/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER) && !HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
		return

	if(!battery)
		to_chat(user, SPAN_NOTICE("这里没有可以拆下的电池。"))
		return
	to_chat(user, SPAN_NOTICE("你用[attacking_item]将[battery]从[src]中强行撬出，造成了无法复原的损坏。"))
	user.put_in_hands(battery)
	battery = null
	update_icon()

/obj/item/prop/geiger_counter/update_icon()
	. = ..()

	if(battery && toggled_on)
		icon_state = enabled_state
		return
	icon_state = disabled_state

/obj/item/prop/tableflag
	name = "美洲联盟桌旗"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "uaflag"
	force = 0.5
	w_class = SIZE_SMALL
	desc = "一面美洲联盟迷你桌旗，代表整个北美洲、南美洲和中美洲。"

/obj/item/prop/tableflag/uscm
	name = "殖民地陆战队桌旗"
	icon_state = "uscmflag"
	desc = "一面美国殖民地海军陆战队迷你桌旗，旗帜底部写着“永远忠诚”。"

/obj/item/prop/tableflag/uscm2
	name = "殖民地陆战队历史桌旗"
	icon_state = "uscmflag2"
	desc = "一面美国殖民地海军陆战队历史迷你桌旗，采用传统的猩红与金色。中央是陆战队徽记，上方站着一只雄鹰，背后衬着船锚。"

/obj/item/prop/tableflag/upp
	name = "进步人民联盟桌旗"
	icon_state = "uppflag"
	desc = "一面进步人民联盟迷你桌旗，猩红旗面上的17颗黄色星星环绕着中央更大的一颗。"

/obj/item/prop/flower_vase
	name = "花瓶"
	icon_state = "flowervase"
	w_class = SIZE_SMALL
	desc = "一个空玻璃花瓶。"

/obj/item/prop/flower_vase/bluewhiteflowers
	name = "蓝白玫瑰花瓶"
	icon_state = "bluewhiteflowers"
	desc = "一个插满蓝白玫瑰的花瓶。"

/obj/item/prop/flower_vase/redwhiteflowers
	name = "红白玫瑰花瓶"
	icon_state = "redwhiteflowers"
	desc = "一个插满红白玫瑰的花瓶。"

/obj/item/prop/colony/usedbandage
	name = "脏绷带"
	desc = "一些用过的纱布。"
	icon_state = "bandages_prop"
	icon = 'icons/monkey_icos.dmi'
	w_class = SIZE_TINY

/obj/item/prop/colony/folded_bedroll
	name = "折叠铺盖"
	desc = "一卷折叠好的铺盖。"
	icon_state = "bedroll"
	icon = 'icons/monkey_icos.dmi'

/obj/item/prop/colony/used_flare
	name = "照明棒"
	desc = "一根用过的殖民地陆战队配发照明棒。侧面的说明写着：“拉动拉绳，即可发光”。"
	icon_state = "flare-empty"
	icon = 'icons/obj/items/lighting.dmi'

/obj/item/prop/colony/canister
	name = "燃料罐"
	desc = "一个油罐。在太空里！也可能是在某座殖民地。"
	icon_state = "canister"
	icon = 'icons/obj/items/tank.dmi'

/obj/item/prop/colony/proptag
	name = "身份信息牌"
	desc = "一名阵亡陆战队员的身份信息牌。上面写着：（空白）"
	icon_state = "dogtag_taken"
	icon = 'icons/obj/items/card.dmi'

/obj/item/prop/colony/game
	name = "便携游戏机"
	desc = "一台思考板系统公司的“游戏兄弟”掌机，简称 TSGBH。可以玩国际象棋、跳棋和三维国际象棋，还能运行 BYOND！可惜这一台的电池已经没电了。"
	icon_state = "game_kit"
	icon = 'icons/obj/items/items.dmi'

/obj/item/prop/gripper
	name = "磁力抓取器"
	desc = "供合成人使用的简易抓取工具。"
	icon_state = "gripper"
	icon = 'icons/obj/items/devices.dmi'

/obj/item/prop/matter_decompiler
	name = "物质分解器"
	desc = "吞入垃圾、玻璃碎片或其他残骸，就能补充你的储备。"
	icon_state = "decompiler"
	icon = 'icons/obj/items/devices.dmi'

/// Xeno-specific props

/obj/item/prop/alien/hugger
	name = "????"
	desc = "它的尾巴末端长着某种管状物。这到底是什么鬼东西？"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "facehugger_impregnated"

//-----USS Almayer Props -----//
//Put any props that don't function properly, they could function in the future but for now are for looks. This system could be expanded for other maps too. ~Art

/obj/item/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, IF YOU SEE THIS THERE IS A PROBLEM IN THE PROP.DM FILE MAKE A BUG REPORT "
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "hangarbox"

/obj/item/prop/almayer/box
	name = "金属箱"
	desc = "一种常用于存放运输艇小型电子设备的金属箱。"
	icon_state = "hangarbox"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/flight_recorder
	name = "\improper FR-112 飞行记录仪"
	desc = "一个小红盒，存放运输艇执行任务时的飞行数据。通常被称为“黑匣子”，尽管这个是血红色的。"
	icon_state = "flight_recorder"
	w_class = SIZE_MEDIUM

/obj/item/prop/almayer/flight_recorder/colony
	name = "\improper CIR-60 殖民地信息记录仪"
	desc = "一个小红盒，记录殖民地公告、殖民者生命体征归零及其他关键读数。通常被称为“黑匣子”，尽管这个是血红色的。"
	icon_state = "flight_recorder"

/obj/item/prop/almayer/flare_launcher
	name = "\improper MJU-77/C 诱饵弹发射器"
	desc = "一种通常安装在运输艇上的红外诱饵弹发射器，可提高运输艇面对红外制导导弹时的生存能力。"
	icon_state = "flare_launcher"
	w_class = SIZE_SMALL

/obj/item/prop/almayer/chaff_launcher
	name = "\improper RR-247 箔条发射器"
	desc = "一种通常安装在运输艇上的箔条发射器，可提高运输艇面对雷达制导导弹时的生存能力。"
	icon_state = "chaff_launcher"
	w_class = SIZE_MEDIUM

/obj/item/prop/almayer/handheld1
	name = "小型手持设备"
	desc = "一个小型电子玩意儿。"
	icon_state = "handheld1"
	w_class = SIZE_SMALL

/obj/item/prop/almayer/comp_closed
	name = "运输艇维护计算机"
	desc = "一台合上的运输艇维护计算机，供技师和飞行员排查运输艇故障。上面有适用于不同系统的各种接口。"
	icon_state = "hangar_comp"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/comp_open
	name = "运输艇维护计算机"
	desc = "一台打开的运输艇维护计算机，不过似乎没有开机。技师和飞行员用它查找运输艇上受损或故障的系统，上面有适用于不同系统的各种接口。"
	icon_state = "hangar_comp_open"
	w_class = SIZE_LARGE

//lore fluff books and magazines

/obj/item/prop/magazine
	name = "杂志道具"
	desc = "一本印着漂亮姑娘照片的杂志……等等，那不是我妈吗？"
	icon = 'icons/obj/structures/props/posters.dmi'
	icon_state = "poster15"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_TINY
	attack_verb = list("猛砸", "重击", "教训")
	pickup_sound = "sound/handling/book_pickup.ogg"
	drop_sound = "sound/handling/book_pickup.ogg"
	black_market_value = 15

//random magazines
/obj/item/prop/magazine/dirty
	name = "成人杂志"
	desc = "哇哦！"
	icon_state = "poster17"

/obj/item/prop/magazine/dirty/torn
	name = "\improper 撕下的杂志页"
	desc = "啧啧，真诱人。"

/obj/item/prop/magazine/dirty/torn/alt
	icon_state = "poster3"

/obj/item/prop/magazine/dropship
	name = "《国际航空航天》杂志：2181年8月刊"
	desc = "一本内容相当平实的杂志，介绍刚在多个星区投入服役的各种航空航天器。这一期刊载了三世界帝国最新采购机型的文章。"
	desc_lore = "DAA.4“猎迷”运输艇 <BR> <BR> 第4型航空航天突击运输艇 <BR> <BR> 皇家陆战队少量采购了夏延运输艇，并将其在三世界帝国服役时命名为“猎迷”。投入实地试验前，阿古斯塔-韦斯特兰公司对其进行了大幅改装，将两台 F29-L-13 涡轮发动机换成四台劳斯莱斯 RBZ.435 线性气塞式发动机。大规模安装的推力矢量装置提高了机动性；在1.4马赫以内，其前向操纵反应灵敏，在2.7马赫以下仍保持敏捷。<BR> <BR> 这些改装，加上为配合快速部署兵力的作战理念而实施的整体减重，使 DAA.4 不再拥有夏延运输艇那样的重武器载荷。<BR> <BR> 降低传感器特征的措施令“猎迷”的隐蔽性显著优于 UD-4；但在防御严密的作战区域，它仍经常大量挂载“击剑手”TSAM 用于自卫，同时保留了转管机炮。"
	icon_state = "poster26"

//books
/obj/item/prop/magazine/book
	name = "书"
	desc = "一本普通的硬核小说。实在无聊。大概吧。无聊得懒得读。"
	icon = 'icons/obj/items/books.dmi'
	icon_state = "book_blue"

/obj/item/prop/magazine/book/spacebeast
	name = "\improper 《太空野兽》，罗伯特·莫尔斯著"
	desc = "一本自传，着重记述2179年8月艾伦·雷普利和一只被称为“巨龙”的未知外星生物抵达狂怒161号后发生的事件。本书文笔极其粗糙，出版后不久便遭到查禁。"

/obj/item/prop/magazine/book/borntokill
	name = "\improper 《天生杀戮》"
	desc = "德里克·A.W.托马霍克撰写的自传，讲述了他在殖民地陆战队的服役经历。本书因文笔平淡、缺乏创意而备受批评，无论公众还是美洲联盟军人都不太买账。不过，人工士兵通常很重视书中包含的信息。"

/obj/item/prop/magazine/book/bladerunner
	name = "\improper 《银翼杀手：真实侦探故事》"
	desc = "2119年，在月球阴暗的下层城区，银翼杀手理查德·福特被召回，奉命清除一个复制人教团；他们逃离地球，试图寻找自身存在的意义。"

/obj/item/prop/magazine/book/starshiptroopers
	name = "《星船伞兵》"
	desc = "罗伯特·A.海因莱因所著。本书对“伞兵”单兵装备的描写实在不着边际，但它仍会在基础训练时发给每个陆战队员，所以想必还是有些价值的。"

/obj/item/prop/magazine/book/theartofwar
	name = "《孙子兵法》"
	desc = "古代地球的伟大将领、战略家和哲学家孙子撰写的兵学著作。本书列入美国殖民地海军陆战队司令推荐书目，大多数军官手里都有一本。读过它的军官大多自称比普通士兵更懂打仗，不过实际效果因人而异。"

/obj/item/prop/magazine/book/uppbooklet
	name = "\improper 《人民手册》"
	desc = "一本发给进步人民联盟广大公民的小册子。首页印有联盟圆形徽记，并题辞献给各成员国及国家委员会领导下的全体工人阶级的团结。本书以浅显易懂的方式概述联盟的集体意识形态，也简要介绍联盟历史、各成员国概况和普遍适用的法律。因此，新公民加入进步人民联盟时通常都会领到一本。"
	icon_state = "book_upp"

/obj/item/prop/magazine/book/warisaracket
	name = "《战争是场骗局》"
	desc = "陆战队传奇人物斯梅德利·巴特勒少将批判美国海军陆战队的著作。本书概述了历史上的陆战队在建立并维持美国全球霸权时扮演的角色。幸好这些批评在当代已经不适用了。对吧？"

/obj/item/prop/magazine/book/littleredbook
	name = "《毛主席语录》"
	desc = "一本能放进掌心的小红书。虽然不是必读书目，却能让读者方便地查阅——正如书名所说——毛主席语录。"
	icon_state = "littleredbook"

/obj/item/prop/magazine/book/communistmanifesto
	name = "《共产党宣言》"
	desc = "共产主义读物的基础入门。"

/obj/item/prop/magazine/book/inframaterialism
	name = "《超物质主义简论》"
	desc = "伊格努斯·尼尔森对深奥的共产主义理论“超物质主义”的简明介绍。"

/obj/item/prop/magazine/sof
	name = "《雇佣兵》杂志：某期……"
	icon_state = "poster8"
	desc = "一本《雇佣兵》杂志，被水泡坏了。该死。"

/obj/item/prop/magazine/sof/n2182
	name = "《雇佣兵》杂志：2182年3月刊"
	icon_state = "poster8"
	desc = "一本《雇佣兵》杂志。封面是一幅正在使用 M314 运动探测器的风格化图像，标题为“22世纪战场态势感知”。文章介绍现代军队地面传感器及对抗技术的进展。封面上还有“独家：《雇佣兵》探访 M41AE2”与“未来战争：赛博戴恩系统公司的作战AI进展”。杂志末尾附有大量承包商和作战装备广告。"

/obj/item/prop/magazine/sof/n2181
	name = "《雇佣兵》杂志：2181年12月刊"
	icon_state = "poster21"
	desc = "一本《雇佣兵》杂志。封面照片是一名穿着全套 MOPP 防护装备的陆战队员，标题为“极限战争：污染环境中的作战行动”。主文讨论污染环境中的战斗，重点介绍“陆战队70”计划带来的改变。封面还印着“独家：《雇佣兵》试射 XM99 相位等离子步枪”和“追忆唐豪瑟”。杂志末尾附有大量承包商和作战装备广告。"

/obj/item/prop/magazine/playboy
	name = "《花花公子》：某期……"
	icon_state = "poster3"
	desc = "一本《花花公子》杂志，被水泡坏了。该死。"

/obj/item/prop/magazine/playboy/n2182
	name = "《花花公子》杂志：2182年3月刊"
	icon_state = "poster3"
	desc = "一本《花花公子》杂志。封面是吉他手莎迪·萨默斯的照片，标题为“莎迪·萨默斯全盘托出”。文章着重讲述她巡演期间的众多风流韵事，以及本期出版两年前，她在洛杉矶一家夜总会当众打架的经历。翻阅杂志，还能看到“丛林雇佣兵：前进步人民联盟突击队员的生活”和“为何选择合成女孩，以及如何挑选”等标题。"

//boots magazine
/obj/item/prop/magazine/boots
	name = "《新兵！》杂志"
	desc = "殖民地陆战队唯一的官方杂志！"

/obj/item/prop/magazine/boots/n054
	name = "《新兵！》第54期：阿玛特反击战"
	desc = "本期据说讨论那桩关于 M41A 被宣传为可自动清洁的旧诉讼，具体来说，是阿玛特对相关指控的回应。"

/obj/item/prop/magazine/boots/n055
	name = "《新兵！》第55期：老飞行员的诀窍"
	desc = "副标题写着“让你的 UD4 驾驶舱更安全、更舒适的十条诀窍”。随手一翻，大部分都在胡扯。除了一个提高 M3 护甲舒适度的小窍门，本期其他内容也没多大意思。"

/obj/item/prop/magazine/boots/n056
	name = "《新兵！》第56期：聪明地使用智能机枪"
	desc = "这一期颇有些臭名昭著。可惜这本是再版，惹出争议的“薄饼丑闻”页面已被删去，换成了智能机枪保养指南。"

/obj/item/prop/magazine/boots/n067
	name = "《新兵！》第67期：随遇而安"
	desc= "第57期是陆战队宣传明显有些用力过猛的几期之一，满篇都是教你如何在边境处境中苦中作乐的建议。"

/obj/item/prop/magazine/boots/n117
	name = "《新兵！》第117期：别再往里扔罐了"
	desc = "在“投罐事件”后紧急印制的一期，其中数页专门说明陆战队员把 CN-20 神经毒气扔进浴室恶作剧的危险。它还列了一些替代恶作剧，不过都是给胆小鬼玩的。"

/obj/item/prop/magazine/boots/n150
	name = "《新兵！》第150期：进步人民联盟口粮的真相"
	desc = "短文进一步解释，进步人民联盟的野战口粮并未标准化，而是由地方自行生产。因此，缴获和没收的联盟口粮里出现过一些古怪选择，比如鸭肝、皮蛋、碱渍鳕鱼、腌猪鼻、罐装肚杂和脱水糖渍萝卜零食。"

/obj/item/prop/magazine/boots/n160
	name = "《新兵！》第160期：公司联络员的十年"
	desc = "本期专访一名在陆战队单位任职十年的维兰德-汤谷公司联络员。随刊还附有调查卡，填写后可兑换……一张50美元的 MCX 礼品卡。"

/obj/item/prop/scrap
	name = "废金属"
	icon = 'icons/obj/items/fishing_atoms.dmi'
	icon_state = "sheet-scrap"
	item_state = ""
	desc = "一块生锈的废金属。"
	w_class = SIZE_SMALL

/obj/item/prop/rock
	name = "石头"
	icon = 'icons/obj/items/plush.dmi'
	icon_state = "rock"
	item_state = ""
	force = 30
	throwforce = 25
	desc = "最古老的工具。"
	w_class = SIZE_TINY
	hitsound = 'sound/weapons/genhit3.ogg'

/obj/item/prop/deviltrap
	name = "恶魔陷阱"
	icon = 'icons/obj/items/misc.dmi'
	icon_state = "deviltrap"
	item_state = ""
	force = 0.5
	throwforce = 0.5
	desc = "用树枝、细枝和麻绳制成的物件，看起来像个微型金字塔，让你有种不祥的预感。"
	w_class = SIZE_LARGE
