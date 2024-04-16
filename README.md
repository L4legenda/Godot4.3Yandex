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

</script>
```

```gdscript
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
```
