Export
```html
<script src="https://yandex.ru/games/sdk/v2"></script>
<script>
YaGames.init().then(ysdk => { window.ysdk = ysdk; });

function ShowAd(callback) {
  window.ysdk.adv.showFullscreenAdv({
    callbacks: {
      onClose: function(wasShown) {
        callback(true);
        console.log('Ad!');
      },
      onError: function(error) {
        callback(false);
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
        isRewarded = true;
        callback(isRewarded);
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
</script>
```
Global
```gdscript
var coins = 0
var callback_rewarded_ad = JavaScriptBridge.create_callback(_rewarded_ad)
var callback_ad = JavaScriptBridge.create_callback(_ad)
var callback_audio = JavaScriptBridge.create_callback(_on_audio)
@onready var win = JavaScriptBridge.get_interface("window")

func _ready() -> void:
	js_music_init()

func js_music_init():
	if not win:
		return
	win.InitVisibilityChange(callback_audio)
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, false)

func js_show_ad():
	if not win:
		return
	win.ShowAd(callback_ad)
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, true)

func js_show_rewarded_ad():
	win.ShowAdRewardedVideo(callback_rewarded_ad)
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, true)

func _rewarded_ad(args):
	print(args[0])
	coins += 10
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, false)

func _ad(args):
	print(args[0])
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, false)

func _on_audio(args):
	# Возобновляем все звуки
	var state = args[0]
	var bus_index = AudioServer.get_bus_index("Master")
	if state:
		AudioServer.set_bus_mute(bus_index, false)
	else:
		AudioServer.set_bus_mute(bus_index, true)


```
