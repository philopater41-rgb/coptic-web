// audio_helper.js
// Uses a single, persistent HTMLAudioElement to avoid Safari's media element limit.
// Safari refuses to play audio after ~5-6 AudioContext/HTMLAudioElement instances.
// By reusing one element and just swapping `src`, we stay within the limit forever.

var _audioEl = null;

function getAudioEl() {
  if (!_audioEl) {
    _audioEl = new Audio();
    _audioEl.preload = 'auto';
  }
  return _audioEl;
}

function webPlayAudio(url) {
  try {
    var el = getAudioEl();
    el.pause();
    el.currentTime = 0;
    el.src = url;
    el.load();
    var playPromise = el.play();
    if (playPromise !== undefined) {
      playPromise.catch(function(e) {
        console.warn('webPlayAudio error:', e);
      });
    }
  } catch(e) {
    console.warn('webPlayAudio exception:', e);
  }
}

function webStopAudio() {
  try {
    var el = getAudioEl();
    el.pause();
    el.currentTime = 0;
  } catch(e) {}
}

function webIsPlaying() {
  if (!_audioEl) return false;
  return !_audioEl.paused && !_audioEl.ended;
}

function webOnAudioEnded(callback) {
  var el = getAudioEl();
  el.onended = callback;
}
