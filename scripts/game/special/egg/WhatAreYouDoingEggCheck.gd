class_name WhatAreYouDoingEggCheck
extends EggCheck


## 检查是否符合要求
## 要求：有背带裤、有篮球
func check(craks: Array[CrackScript])->bool:
	var tools: =CraksTool.new()
	var diao :Dictionary = { "name":"Diao", "num": 1}
	var bask :Dictionary = { "name":"Bask", "num": 1}
	return tools.check_cracks_has(craks,[diao,bask])
