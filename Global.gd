extends Node


var coins = 0
var callback_rewarded_ad = JavaScriptBridge.create_callback(_rewarded_ad)
var callback_ad = JavaScriptBridge.create_callback(_ad)
@onready var win = JavaScriptBridge.get_interface("window")

func js_show_ad():
	win.ShowAd(callback_ad)
# Здесь можно приостановить музыку / звуки
func js_show_rewarded_ad():
	win.ShowAdRewardedVideo(callback_rewarded_ad)
# Здесь можно приостановить музыку / звуки
func _rewarded_ad(args):
	print(args[0])
	coins += 10
# Здесь можно возобновить музыку / звуки
func _ad(args):
	print(args[0])
# Здесь можно возобновить музыку / звуки
