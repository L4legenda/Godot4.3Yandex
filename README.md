Export
```html
<script src="https://yandex.ru/games/sdk/v2"></script>
<script>
YaGames.init().then(ysdk => { 
window.ysdk = ysdk;
window.isDesktop = YaGames.deviceInfo.isDesktop();
window.isMobile = YaGames.deviceInfo.isMobile();

});

function ShowAd(callback) {
  window.ysdk.adv.showFullscreenAdv({
    callbacks: {
      onClose: function(wasShown) {
        callback(true);
        console.log('Ad!');
      },
      onError: function(error) {
        callback(true);
        console.log('Ad Error:', error);
      }
    }
  })
}

function ShowAdRewardedVideo(callback) {
  window.ysdk.adv.showRewardedVideo({
    callbacks: {
      onOpen: () => { console.log('Video ad open.'); },
      onRewarded: () => {
        callback(true);
        console.log('Reward!');
      },
      onClose: () => { console.log('Video ad closed.'); },
      onError: (e) => { console.log('Error while open rewarded ad:', e); }
    }
  });
}

function InitVisibilityChange(callback) {
    document.addEventListener("visibilitychange", function() {
		console.log(document.hidden);
        if (document.hidden) {
            callback(false);
        } else {
            callback(true);
        }
    });
}
function InitDeviseInfo(callback) {
	console.log("window.isDesktop, window.isMobile", window.isDesktop, window.isMobile)
	callback(window.isDesktop, window.isMobile)
}

function InitLoadingAPI(callback) {
	console.log("InitLoadingAPI")
	window.ysdk.features.LoadingAPI?.ready()
	callback(!!window.ysdk)
}

</script>
<style>
html, body {
	overflow: hidden;
}
</style>
```
Global
```gdscript
var coins := 0
var callback_rewarded_ad := JavaScriptBridge.create_callback(_rewarded_ad)
var callback_ad := JavaScriptBridge.create_callback(_ad)
var callback_audio := JavaScriptBridge.create_callback(_on_audio)
var callback_devise_info := JavaScriptBridge.create_callback(_devise_info)
var callback_yandex_init := JavaScriptBridge.create_callback(_yandex_init)
@onready var win := JavaScriptBridge.get_interface("window")

var isDesctop := false
var isMobile := false 
var isYandex := false

func is_web() -> bool:
	return OS.get_name() == "Web"

func is_mobile() -> bool:
	return OS.get_name() == "Android" or OS.get_name() == "iOS"

func _ready() -> void:
	js_music_init()
	initDeviseInfo()
	initLoadingAPI()

func js_music_init() -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, false)
	
	if not win:
		return
	win.InitVisibilityChange(callback_audio)


func js_show_ad() -> void:
	if not win or not isYandex:
		return
	win.ShowAd(callback_ad)
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, true)
	get_tree().paused = true
	print("js_show_ad, sound false")


func js_show_rewarded_ad() -> void:
	if not win or not isYandex:
		return
	win.ShowAdRewardedVideo(callback_rewarded_ad)
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, true)
	print("js_show_rewarded_ad, sound false")


func _rewarded_ad(args) -> void:
	coins += 40
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, false)
	print("_rewarded_ad, true")


func _ad(args) -> void:
	var bus_index := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, false)
	get_tree().paused = false
	print("_ad, true")


func _on_audio(args: Array[bool]) -> void:
	# Возобновляем все звуки
	var state := args[0]
	var bus_index := AudioServer.get_bus_index("Master")
	if state:
		AudioServer.set_bus_mute(bus_index, false)
		print("_on_audio, sound true")
	else:
		AudioServer.set_bus_mute(bus_index, true)
		print("_on_audio, sound false")

func _close() -> void:
	if not win:
		return
	win.close()

func _devise_info(data) -> void:
	isDesctop = data[0]
	isMobile = data[1]

func initDeviseInfo() -> void:
	if not win:
		return
	win.InitDeviseInfo(callback_devise_info)

func initLoadingAPI() -> void:
	if not win:
		return
	win.InitLoadingAPI(callback_yandex_init)

func _yandex_init(data) -> void:
	isYandex = data[0]
	print("iaYandex: ", isYandex)


```

