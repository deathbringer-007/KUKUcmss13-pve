
//*********************MANUALS (BOOKS)***********************/

//Oh god what the fuck I am not good at computer
/obj/item/book/manual
	/// Game time in 1/10th seconds
	due_date = 0
	/// 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	unique = 1


/obj/item/book/manual/engineering_construction
	name = "《设施维修与建造》"
	icon_state ="book_engineering"
	author = "工程百科全书"
	title = "设施维修与建造"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="https://cm-ss13.com/wiki/Guide_to_construction" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/engineering_hacking
	name = "《入侵技术》"
	icon_state ="book_hacking"
	author = "工程百科全书"
	title = "入侵技术"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="https://cm-ss13.com/wiki/Guide_to_Engineering#Hacking" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/ripley_build_and_repair
	name = "《APLU“里普利”建造与操作手册》"
	icon_state ="book_engineering"
	author = "Randall Varn，爱因斯坦引擎公司高级机械师"
	title = "APLU“里普利”建造与操作手册"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ul.a {list-style-type: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<center>
				<br>
				<b style='font-size: 12px;'>维兰德-汤谷——建设更美好的世界</b>
				<h1>自主动力装载机“里普利”</h1>
				</center>
				<h2>技术规格：</h2>
				<ul class="a">
				<li><b>类别：</b>自主动力装载机</li>
				<li><b>用途：</b>物流与建造</li>
				<li><b>重量：</b>820千克（不含操作员，货舱为空）</li>
				<li><b>高度：</b>2.5米</li>
				<li><b>宽度：</b>1.8米</li>
				<li><b>最高速度：</b>5千米／小时</li>
				<li><b>真空／恶劣环境作业：</b>支持</b>
				<li><b>气罐容量：</b>500升</li>
				<li><b>设备：</b>
					<ul class="a">
					<li>液压夹具</li>
					<li>高速钻头</li>
					</ul>
				</li>
				<li><b>驱动装置：</b>电池供电的电液系统</li>
				<li><b>电池容量：</b>依配置而定</li>
				</ul>

				<h2>组装步骤：</h2>
				<ol>
					<li>将所有外骨骼部件连接到底盘框架上。</li>
					<li>连接所有液压接头，并用扳手拧紧。</li>
					<li>用螺丝刀调整伺服液压系统。</li>
					<li>为底盘布线（电缆需自备）。</li>
					<li>如有需要，用剪线钳剪去多余电缆。</li>
					<li>安装中央控制模块（需自备，可用随附数据磁盘制作）。</li>
					<li>用螺丝刀固定主板。</li>
					<li>安装外设控制模块（需自备，可用随附数据磁盘制作）。</li>
					<li>用螺丝刀固定外设控制模块。</li>
					<li>安装内部装甲板（依维兰德-汤谷规定，需自备；可用5块金属板制作）。</li>
					<li>用扳手固定内部装甲板。</li>
					<li>将内部装甲板焊接到底盘上。</li>
					<li>安装外部强化装甲板（依维兰德-汤谷规定，需自备；可用5块强化金属板制作）。</li>
					<li>用扳手固定外部强化装甲板。</li>
					<li>将外部强化装甲板焊接到底盘上。</li>
				</ol>

				<h2>补充说明：</h2>
				<ul>
					<li>消防型的组装方式与此类似。</li>
					<li>必须将消防服连接到消防型底盘上，提供隔热防护。</li>
					<li>内部装甲使用塑钢，以提高强度。</li>
					<li>外部装甲需分两部分安装，共需10块板材。</li>
					<li>完工的机甲耐火性能更强，整体也更耐用。</li>
					<li>维兰德-汤谷致力于保障其<s>投资</s>员工的安全。</li>
				</ul>
				</body>
			</html>
			"}


/obj/item/book/manual/research_and_development
	name = "《研究与开发入门》"
	icon_state = "book_white"
	author = "L. Ight博士"
	title = "研究与开发入门"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="https://cm-ss13.com/wiki/Researcher" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/security_space_law
	name = "《标准操作规程》"
	desc = "美国殖民地海军陆战队用于维护舰上法律与秩序的规章手册。"
	icon_state = "book_sop"
	author = "USCM最高指挥部"
	title = "标准操作规程"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="https://cm-ss13.com/wiki/Standard_Operating_Procedure" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/marine_law
	name = "《陆战队军法》"
	desc = "维护军舰上法律与秩序的规章手册。"
	icon_state = "book_law"
	author = "USCM最高指挥部"
	title = "陆战队军法"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="http://cm-ss13.com/wiki/Marine_Law" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/surgery
	name = "《外科手术参考手册》"
	desc = "手术操作快速参考手册。"
	icon_state = "book_medical"
	author = "维兰德-汤谷医疗部"
	title = "外科手术参考手册"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="https://cm-ss13.com/wiki/Surgery" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/medical_diagnostics_manual
	name = "《维兰德-汤谷医疗诊断手册》"
	desc = "首先，不造成伤害。一本详尽的医师指南。"
	icon_state = "book_medical"
	author = "维兰德-汤谷医疗部"
	title = "维兰德-汤谷医疗诊断手册"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				<h1>医师誓言</h1>

				<i>受雇于维兰德-汤谷的合格医务人员所宣读的医学誓词</i><br>

				<ol>
					<li>如今，作为一名新晋医师，我郑重承诺：我将竭尽所能服务人类，照顾病患、促进健康，并减轻疼痛与苦难。</li>
					<li>我明白行医是一项伴随重大责任的特权，绝不滥用自己的地位。</li>
					<li>我将以正直、谦逊、诚实与同情心行医，与医师同仁及其他同事协作，满足患者的需求。</li>
					<li>我绝不故意采取或施予任何总体上有害于患者的措施。</li>
					<li>我不会让性别、种族、宗教、政治立场、性取向、国籍或社会地位影响我的照护职责。</li>
					<li>我将反对侵犯人权的政策，绝不参与其中。我将努力推动修改违背医德的法律，并致力于更加公平地分配医疗资源。</li>
					<li>我将帮助患者作出符合其价值观与信仰的知情决定，并恪守患者保密原则。</li>
					<li>我将承认自身知识的局限，在整个职业生涯中不断保持和提升理解与技能。我会承认并努力弥补自己的错误，也会诚实地评估和回应他人的错误。</li>
					<li>我将通过教学与研究推动医学知识进步。</li>
					<li>我自愿以个人荣誉，郑重作出以上宣誓。</li>
				</ol><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				<iframe width='100%' height='100%' src="http://cm-ss13.com/wiki/Guide_to_Medicine" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>

		"}


/obj/item/book/manual/engineering_guide
	name = "《工程学教材》"
	icon_state ="book_engineering"
	author = "工程百科全书"
	title = "工程学教材"

	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='100%' src="https://cm-ss13.com/wiki/Guide_to_Engineering" frameborder="0" id="main_frame"></iframe> </body>

		</html>

		"}


/obj/item/book/manual/chef_recipes
	name = "《厨师食谱》"
	icon_state = "book_white"
	author = "Victoria Ponsonby"
	title = "厨师食谱"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>烹饪入门</h1>
				本指南介绍基础食谱，也教你如何避免意外毒倒顾客。

				<h3>基础：</h3>
				将一个鸡蛋与面粉揉成面团。烤制可做成面包胚，也可以压平后切开。

				<h3>汉堡：</h3>
				将面包胚和肉放入微波炉，启动后等待即可。

				<h3>面包：</h3>
				将面团和一个鸡蛋放入微波炉，等待即可。

				<h3>华夫饼：</h3>
				将两块面团和10单位糖放入微波炉，等待即可。

				<h3>爆米花：</h3>
				将一根玉米放入微波炉，等待即可。

				<h3>肉排：</h3>
				将一片肉、1单位盐和1单位胡椒放入微波炉，等待即可。

				<h3>肉馅饼：</h3>
				将一块压平的面团和肉放入微波炉，等待即可。

				<h3>水煮意大利面：</h3>
				将意大利面（由面粉加工制成）和5单位水放入微波炉，等待即可。

				<h3>甜甜圈：</h3>
				将面团和5单位糖放入微波炉，等待即可。

				<h3>薯条：</h3>
				将一个土豆放入食品加工机，再用微波炉烤制。


				</body>
			</html>
			"}


/obj/item/book/manual/barman_recipes
	name = "《酒保配方》"
	icon_state = "book_purple"
	author = "John Rose爵士"
	title = "酒保配方"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>调饮入门</h1>
				本指南介绍一些基础饮品的调制方法。

				<h3>黑俄罗斯：</h3>
				在玻璃杯中混合伏特加与甘露咖啡利口酒。

				<h3>拿铁咖啡：</h3>
				在玻璃杯中混合牛奶与咖啡。

				<h3>经典马天尼：</h3>
				在玻璃杯中混合味美思与金酒。

				<h3>金汤力：</h3>
				在玻璃杯中混合金酒与汤力水。

				<h3>格罗格：</h3>
				在玻璃杯中混合朗姆酒与水。

				<h3>爱尔兰奶油酒：</h3>
				在玻璃杯中混合奶油与威士忌。

				<h3>硬汉矮人：</h3>
				在玻璃杯中混合艾尔啤酒与啤酒。

				<h3>蜂蜜酒：</h3>
				在玻璃杯中混合酶、水与糖。

				<h3>螺丝刀：</h3>
				在玻璃杯中混合伏特加与橙汁。

				</body>
			</html>
			"}


/obj/item/book/manual/detective
	name = "《黑色电影：规范调查程序》"
	icon_state ="book_black"
	author = "维兰德-汤谷"
	title = "黑色电影：规范调查程序"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>侦探工作</h1>

				在自言自语和啜饮加冰威士忌的间隙，你或许会接到一两桩案子。<br>
				想提高破案机会，就按以下步骤行动：
				<p>
				<ol>
					<li>前往犯罪现场。</li>
					<li>拿起扫描仪，扫描所有东西（没错，门、桌子，连狗也别放过）。</li>
					<li>当你基本确定收齐了所有可用证据后，再找出并扫描所有可能的出入口。</li>
					<li>返回办公室。</li>
					<li>用法证扫描计算机读取扫描仪，将所有证据上传到数据库。</li>
					<li>浏览生成的卷宗，寻找指纹最完整，或接触过最多可疑物品的对象。</li>
					<li>如果指纹完整度达到80%或以上（能够显示指纹），跳到第10步；否则继续第8步。</li>
					<li>从嫌疑人留下的衣物纤维中寻找线索，利用新信息继续搜证，随时进行扫描。</li>
					<li>设法取得嫌疑人的指纹卡。在计算机上使用后，就能补全卷宗中的指纹。</li>
					<li>如果指纹已足够完整，选取最大的一块完整片段，在安保记录中进行搜索。</li>
					<li>现在你既有卷宗，也知道此人的姓名。将两者打印为证据，让安保人员抓住罪犯。</li>
					<li>给自己一点鼓励，再来一瓶舰上最好的伏特加。你成功了！</li>
				</ol>
				<p>
				事情就是这么简单！祝你好运！

				</body>
			</html>"}


/obj/item/book/manual/nuclear
	name = "《裂变未遂：核破坏入门》"
	icon_state ="book_sop"
	author = "殖民地解放阵线"
	title = "裂变未遂：核破坏入门"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>核爆炸物入门</h1>
				你好，感谢你选择殖民地解放阵线获取核装置信息。今天的速成课程将介绍维兰德-汤谷制造的聚变级核装置的操作方式。<br><br>

				首先，也是最重要的一点：炸弹就位前，不要碰任何按钮。按下收拢状态炸弹上的任意按钮，都会使其展开并固定在原地。此后若要解除固定，就必须完成登录，而你当时未必能够做到。<br>

				<h2>启用核装置</h2>
				<ul>
					<li>将核装置放到指定引爆区域。</li>
					<li>通过操作界面展开并固定核装置。</li>
					<li>将核授权磁盘插入插槽。</li>
					<li>在键盘上输入事先提供的数字授权码。<br>
					<b>注意：</b>如果输错，按R重置装置。
					<li>按E按钮登录装置。</li>
				</ul><br>

				现在装置已经启用。随时取出授权磁盘，或按下键盘上的R，都可以停用按钮；例如完成引爆准备后就应如此操作。<br><br>
				炸弹只能通过计时器引爆，无法手动引爆。关闭保险。<br>
				<b>注意：</b>你根本想不到有多少拿着博士学位的辛迪加特工忘了这一步。<br><br>

				使用- -和+ +将引爆时间设为5秒至10分钟，再按计时器切换按钮开始倒计时。随后取出授权磁盘，停用按钮。<br>
				<b>注意：</b>炸弹仍处于待引爆状态，倒计时结束后依然会爆炸。<br><br>

				如果需要移动炸弹，可以在取出磁盘前解除固定，移动后再重新固定。<br><br>

				记住操作顺序：<br>
				<b>插磁盘、输密码、关保险、开计时、拔磁盘、快跑！</b><br><br>
				情报分析员认为，按照维兰德-汤谷的常规程序，核授权磁盘应由指挥官或舰长保管。<br><br>

				祝你好运！
				</body>
			</html>
			"}


/obj/item/book/manual/atmospipes
	name = "《管道与你：认识那些吓人的工具》"
	icon_state = "book_piping"
	author = "Maria Crash，高级大气技师"
	title = "管道与你：认识那些吓人的工具"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">目录</a></h1>
				<ol>
					<li><a href="#Foreword">作者前言</a></li>
					<li><a href="#Basic">基础管道</a></li>
					<li><a href="#Insulated">隔热管道</a></li>
					<li><a href="#Devices">大气设备</a></li>
					<li><a href="#HES">热交换系统</a></li>
					<li><a href="#Final">最终检查</a></li>
				</ol><br>

				<h1><a name="Foreword"><U><B>如何让你的大气技术不再那么烂</B></U></a></h1><BR>
				<I>又名：这破“被动阀”究竟是干什么的？</I><BR><BR>

				好吧，我发现许多人连“管道”是什么、能干什么都没弄清楚。
				大家似乎对这些神秘装置和其中的“气体”有着莫名的恐惧。真可怕，真可怕。所以，
				本手册会介绍大气部门普通管道分配器能够制造的每种设备究竟有什么作用。
				你不会从这里学到如何靠它们成为绝世高手，也学不到怎么拿被动阀弹吉他，
				或诸如此类的把戏。这里只讲设备用途。<BR><BR>


				<h1><a name="Basic"><B>基础管道</B></a></h1>
				<I>那些无聊的玩意儿。</I><BR>
				大多数普通管道都很简单。它们容纳气体。如果气体因某种原因向一个方向流动，它就会沿管道流向那里。
				仅此而已。即便如此，还是来看看你能选择的各种精妙管道吧。<BR>

				<ul>
				<li><b>直管：</b>就是管道。一米一段，笔直，简单易懂。几乎所有管道与设备都采用
				这一米的标准尺寸，因此大多数设备占用的空间都和一段直管差不多。</li>
				<li><b>弯管：</b>在半米处转了90度弯的管道。真是了不起。</li>
				<li><b>管道歧管：</b>基本呈T形的管道，让你能在同一点连接三个方向。</li>
				<li><b>四通歧管：</b>四个方向的连接点。</li>
				<li><b>封头：</b>封住管道末端。由于管道的组装方式，敞开的管口其实不会漏气。所以，呃，拿它装饰房间什么的也行。</li>
				<li><b>手动阀：</b>转动后可以截断气流的阀门。AI和机器人没法用，因为它们没有手。</li>
				<li><b>手动三通阀：</b>类似手动阀，但位于歧管中心，而非直管中间。</li><BR><BR>
				</ul>

				<h1><a name="Insulated"><B>隔热管道</B></a></h1>
				<li><I>弯管：</I>在半米处转了90度弯的管道。真是了不起。</li>
				<li><I>管道歧管：</I>基本呈T形的管道，让你能在同一点连接三个方向。</li>
				<li><I>四通歧管：</I>四个方向的连接点。</li>
				<li><I>封头：</I>封住管道末端。由于管道的组装方式，敞开的管口其实不会漏气。所以，呃，拿它装饰房间什么的也行。</li>
				<li><I>手动阀：</I>转动后可以截断气流的阀门。AI和机器人没法用，因为它们没有手。</li>
				<li><I>手动三通阀：</I>类似手动阀，但位于歧管中心，而非直管中间。</li><BR><BR>

				<h1><a name="Insulated"><B>隔热管道</B></a></h1><BR>
				<I>特别公共服务通告。</I><BR>
				我们的普通管道本来就隔热。这些东西完全没用。看见有人用就揍他。<BR><BR>

				<h1><a name="Devices"><B>设备：</B></a></h1>
				<I>这些东西确实能干点活。</I><BR>
				看到这里，大家往往就开始惊慌，向神明求助，或吓得缩成一团。没错，我看见你现在就在这么干。
				停下，太不像样了。这些设备大多很好理解。<BR>

				<ul>
				<li><b>气泵：</b>猜猜它干什么。它会把气体送往自身指向的方向（一端的红线为方向标记）。它按压力工作，最高输出压力为4500 kPa（千帕）。
				作为比较，标准大气压为101.3 kPa；室温纯氧的最低压力需达到16 kPa，才不至于让人在几分钟内窒息
				（不过出于种种原因，使用内置供气时建议保持18 kPa）。</li>
				<li><b>容积泵：</b>这种泵按体积而非压力工作，因此接收端管道的最高压力可达到普通气泵的两倍，
				高达惊人的9000 kPa。若连接的管道受损或被毁，这种高压气体一旦泄漏，危险程度会随充气管网的规模而剧增。
				别把它接到配气循环上，否则你会把小孩吓哭，还会被轮机长痛揍。</li>
				<li><b>被动阀：</b>它的作用基本是限制某一方向上气流的压力。
				开启后，它不会主动泵送气体，而是测量流经气体的压力。你设置的压力就是上限，达到后便会限制气流。
				此外，它只允许气体单向流动。气流方向与红色手柄相反，习惯用气泵红线判断方向的人往往会搞糊涂。</li>
				<li><b>单口通风口：</b>房间使用的基础通风口。它向室内泵入气体，却无法将气体抽回，由房间的空气警报系统控制。</li>
				<li><b>空气洗涤器：</b>房间大气设备的另一半。它能过滤空气，也能通过所谓的“紧急抽气”将空气全部抽走。没有充分理由就开启紧急抽气会害死人，别这么做。</li>
				<li><b>压力计：</b>带有仪表与数字的小盒子。装在任意管道或歧管上，就能读取内部压力，非常实用。</li>
				<li><b>气体混合器：</b>两端输入，一端输出，按设定比例混合泵入的气体。供参考：与另外两端垂直的一端为“节点2”。
				输出压力范围为0—4500 kPa。</li>
				<li><b>气体过滤器：</b>基本与气体混合器相反，一端输入，两端输出。其中一种气体会被分离到垂直的输出管道中，
				其余气体从另一端流出。输出压力同样为0—4500 kPa。</li>
				</ul>

				<h1><a name="HES"><B>热交换系统</B></a></h1>
				<I>不会把你点着。</I><BR>
				这些系统仅在两根管道之间传递热量，不会转移气体或其他物质，但最终会使温度趋于一致。请记住气体的性质（还记得pv=nRt吗）：
				温度升高会使压力上升，温度降低则会使压力下降。<BR>

				<li><I>热交换管：</I>与周围大气交换热量的管道。放进火中可强力加热，放到太空可强力冷却。</li>
				<li><I>热交换弯管：</I>猜猜看。</li>
				<li><I>转换接头：</I>连接普通管道与热交换管道的位置。热交换器不需要它，但热交换直管和弯管需要。</li>
				<li><I>热交换器：</I>这些模样古怪的零件装在敞开的管口上。在正对面再装一个，就能让两根管道交换热量，而无需让内部气体接触。
				虽然完全暴露在外，它通常也不会与周围空气交换热量。别问为什么……</li><BR>

				管道的知识差不多就这些。带着新知识出发吧，尽量别弄坏、烧毁或弄死任何东西。拜托了。

				</body>
			</html>
			"}


/obj/item/book/manual/evaguide
	name = "《出舱装备与你：别整天待在室内》"
	icon_state = "book_engineering"
	author = "Maria Crash，高级大气技师"
	title = "出舱装备与你：别整天待在室内"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Foreword">出舱装备与你：别整天待在室内</a></h1>
				<I>又名：如何避免因为鞋上有个洞而窒息</I><BR>

				<h2><a name="Contents">目录</a></h2>
				<ol>
					<li><a href="#Foreword">出舱装备使用前言</a></li>
					<li><a href="#Civilian">穿戴民用太空服</a></li>
					<li><a href="#Hardsuit">穿戴硬式防护服</a></li>
					<li><a href="#Final">最终检查</a></li>
				</ol>
				<br>

				出舱装备，用起来真不错。采矿、工程作业都用得上；情况足够糟时，它甚至只是用来保命。大多数人接受过出舱训练，
				但空间站上显然也有没学过的人。本指南会介绍安全使用这些装备的基本方法，分为两部分：
				民用太空服与硬式防护服。<BR><BR>

				<h2><a name="Civilian">民用太空服</a></h2>
				<I>半人马座阿尔法星这边最臃肿的玩意儿</I><BR>
				就是存放在出舱准备区的灰色太空服。穿戴较简单，但也更加臃肿，对辐射、物理冲击等环境危害的防护较弱。
				医疗、工程、安保与采矿部门都有各自的硬式防护服，所以这类服装用得不多，但学会穿戴仍然很有用。<BR><BR>

				首先取出太空服。它应分为三部分：上衣、下装和头盔。先穿下装，鞋子等物品可以包在里面。如果穿磁力靴，
				则要套在太空服的足部外面。接着像穿衬衫一样穿上上衣。服装结构可能让穿戴稍显笨拙，
				但它们能在一定程度上适应你的体形。找到上下两部分在腰间连接处的搭扣与密封件，扣紧后再次检查牢固程度。
				操作正确时，下装腰间的红色指示灯会变绿。接着戴好防毒面具或呼吸面罩等呼吸装置，确保氧气软管已连接牢固。
				然后戴上头盔，确认软管穿过专供内置供气使用的小孔。再次扣紧颈部密封件；全部固定后，头盔内侧的小指示灯应由红色变为熄灭。
				太空服侧面有一个小插槽，可放入应急氧气罐或加大型应急氧气罐，
				不过进行出舱作业时，建议背上标准大小的氧气罐。<BR><BR>

				<h2><a name="Hardsuit">硬式防护服</a></h2>
				<I>沉重、不舒服，却仍是最佳选择。</I><BR>
				工程部、采矿部与军械库都配有这类防护服。出舱准备区也存有几套医疗硬式防护服。它们提供的防护远优于标准太空服。<BR><BR>

				与其他太空服一样，它们也分为三部分。下装与上衣的固定方式大体相同，只是稍重一些，
				却没那么臃肿。头盔的安装方式不同：气管先接入服装，再从左肩附近的小孔穿出；头盔先逆时针转90度戴上，
				然后顺时针旋转一又四分之一圈拧紧，使面罩正对前方。头盔右侧有一个小按钮，可开启头盔灯。
				侧面的插槽既可固定应急氧气罐，也能固定标准大小的氧气罐，这样背部就能留给背包或挎包。<BR><BR>

				<h2><a name="Final">最终检查</a></h2>
				<ul>
					<li>所有密封件都已正确扣紧吗？</li>
					<li>太空服内穿了鞋，或在外面套了磁力靴吗？</li>
					<li>戴好面罩，并在太空服上或背部携带供气装置了吗？</li>
					<li>出现意外时，有办法与空间站通信吗？</li>
					<li>如果正在训练，有另一人在旁观察吗？</li><BR>
				</ul>

				如果没有其他问题，就出舱完成必要的工作吧。

				</body>
			</html>
			"}


/obj/item/book/manual/hydroponics_beekeeping
	name = "《养蜂的门道：一门精细技艺》"
	icon_state ="book_green"
	author = "养蜂人Dave"
	title = "养蜂的门道：一门精细技艺"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>养蜂</h1>

				蜜蜂友善，却也喜怒无常。别乱动蜂箱，远离聚集的蜂群，就能避免惹怒它们。
				不过，有时你需要伸手进去，取出美味的甜蜜收获。这时务必穿上密封防护装备，
				带上灭火器或熏蜂器。追逐你的蜜蜂平静下来后，就可以用网捕捉，安全送回蜂箱。<br.
				<br>
				蜂安灵（BeezEez）对蜜蜂而言是包治百病的灵药，但用得太多，蜂群可能繁殖到灾难般的规模。除此之外，蜜蜂是全家都能饲养的好宠物，
				也是花园的优秀看护者：附近有一两个蜂箱，就能延长植物寿命、加快生长，
				并帮助植物抵抗毒素与疾病。

				</body>
			</html>
			"}


/obj/item/book/manual/orbital_cannon_manual
	name = "《美国殖民地海军陆战队轨道轰炸系统手册》"
	icon_state = "book_dark"
	author = "USCM研发部"
	title = "美国殖民地海军陆战队轨道轰炸系统手册"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>美国殖民地海军陆战队轨道轰炸系统指南</h1>

				<h2>操作步骤：</h2>
				<ol>
					<li>将弹头装入轨道炮托盘（需要动力装载机）。</li>
					<li>向轨道炮托盘装入所需数量的固体燃料<b>（参见轨道炮控制台）</b>。</li>
					<li>打开轨道炮控制台界面。</li>
					<li>将托盘装入轨道炮。</li>
					<li>将托盘中的弹药推入炮膛。<b>（此操作无法撤销！）</b></li>
					<li>作战情报中心人员现在可以通过任意战场监控控制台发射轨道炮。</li>
					<li>发射后，从轨道炮中退出托盘。</li>
					<li>检查托盘，确保其已清空并能正常工作。</li>
				</ol>

				<h2>故障排查：</h2>

				<ul>
					<li>如果托盘装错了弹药，只要尚未推入炮膛，就仍可将其卸下。</li>
					<li>如果错误弹药已推入炮膛，就只能通过发射将其排出。</li>
					<li>如果轨道炮控制台未通电，请检查武器控制室的区域电力控制器。</li>
					<li>如果轨道炮控制台损坏，请联系USCM总部更换。</li>
					<li>如果轨道炮本体直接受损，不要尝试使用或维修。</li>
					<li>如果发生船体破损或火灾，务必卸下炮内弹药，并转移到安全地点。</li>
					<li>如果轨道炮托盘卡住，请为传送带涂抹润滑剂。</li>
					<li>如果轨道炮系统电缆被切断，请联系USCM总部更换。</li>
					<li>如果轨道炮电缆接头损坏，请关闭轨道炮控制台，并联系USCM总部更换。</li>
				</ul>

			</body>
			</html>
			"}


/obj/item/book/manual/orbital_cannon_manual/New()
	. = ..()

	LAZYADD(GLOB.objects_of_interest, src)

/obj/item/book/manual/orbital_cannon_manual/Destroy()
	. = ..()

	LAZYREMOVE(GLOB.objects_of_interest, src)
