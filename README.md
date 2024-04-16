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
