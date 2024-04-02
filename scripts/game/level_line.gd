## LevelLine.txt
## blue=b,green=g,yellow=y,grey=r
## chiken=c,takara=t,inazuma=i,bask=s
## tai=i,cigrate=ci,diao=d
##
## 
## LINE 1b,1b,2b,2b,3g,3g,3g,1t
## LINE 1b,2g,2g,0,0,0,0,0,0
## LINE 3g,3g,3g,1b,0,0,1b,1g,0
## LINE 1y,1y,1c,0,0,0,0,1g,0
## EVENT 0

class_name LevelLine

enum {
	TYPE_LINE = 1, #一行
	TYPE_EVENT = 2 #事件
}

enum {
	EVENT_SNOW = 0, #雪
	EVENT_ICE = 1, #冰块
	EVENT_INK = 2 #墨水
}

# 类型
var type: int
# 行数据
var line: Array[CrakData]
# 事件
var event: int
