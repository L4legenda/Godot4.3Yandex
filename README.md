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
<style>
html, body {
	overflow: hidden;
}
</style>
```
Global
```gdscript
var coins = 0
var callback_rewarded_ad = JavaScriptBridge.create_callback(_rewarded_ad)
var callback_ad = JavaScriptBridge.create_callback(_ad)
var callback_audio = JavaScriptBridge.create_callback(_on_audio)
@onready var win = JavaScriptBridge.get_interface("window")


func _ready() -> void:
	GlobalData.setting_resource.load_resource()
	GlobalData.js_music_init()
	GlobalData.js_show_ad()

func js_music_init():
	if not setting_resource.sound_mute:
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, false)
		print("js_music_init, sound true")
	if not win:
		return
	win.InitVisibilityChange(callback_audio)
	

func js_show_ad():
	if not win:
		return
	win.ShowAd(callback_ad)
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, true)
	print("js_show_ad, sound false")

func js_show_rewarded_ad():
	win.ShowAdRewardedVideo(callback_rewarded_ad)
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, true)
	print("js_show_rewarded_ad, sound false")

func _rewarded_ad(args):
	print(args[0])
	coins += 10
	if not setting_resource.sound_mute:
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, false)
		print("_rewarded_ad, sound true")

func _ad(args):
	print(args[0])
	if not setting_resource.sound_mute:
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, false)
		print("_ad, sound true")

func _on_audio(args):
	# Возобновляем все звуки
	var state = args[0]
	var bus_index = AudioServer.get_bus_index("Master")
	if state and not setting_resource.sound_mute:
		AudioServer.set_bus_mute(bus_index, false)
		print("_on_audio, sound true")
	else:
		AudioServer.set_bus_mute(bus_index, true)
		print("_on_audio, sound false")

func _close():
	if not win:
		return
	win.close()

var setting_resource: SettingResource = SettingResource.new()


```

```gdscript
extends Resource

class_name SettingResource

const save_path = "user://setting_prefs.tres"

@export var sound_mute: bool = false: 
	set(value):
		var bus_index = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_index, value)
		sound_mute = value
		save()

func save() -> void:
	ResourceSaver.save(self, save_path)

func load_resource():
	var res: SettingResource = load(save_path) as SettingResource
	if res:
		sound_mute = res.sound_mute

```

