// audio_helper.js
// Uses a single, persistent HTMLAudioElement to avoid Safari's media element limit.
// By reusing one element and just swapping `src`, we stay within the limit forever.

var _audioEl = null;
var _speed = 1.0;

function getAudioEl() {
  if (!_audioEl) {
    _audioEl = new Audio();
    _audioEl.preload = 'auto';
  }
  return _audioEl;
}

function webPlayAudio(url, speed) {
  try {
    var el = getAudioEl();
    el.pause();
    el.currentTime = 0;
    el.src = url;
    if (speed !== undefined) {
      _speed = speed;
    }
    el.defaultPlaybackRate = _speed;
    el.playbackRate = _speed;
    el.load();
    
    // Set playback rate again on play/canplay to be safe
    el.oncanplay = function() {
      el.playbackRate = _speed;
    };
    
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

function webPauseAudio() {
  try {
    var el = getAudioEl();
    el.pause();
  } catch(e) {
    console.warn('webPauseAudio error:', e);
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

function webSetAudioSpeed(speed) {
  _speed = speed;
  try {
    var el = getAudioEl();
    el.playbackRate = speed;
    el.defaultPlaybackRate = speed;
  } catch(e) {
    console.warn('webSetAudioSpeed error:', e);
  }
}

function webGetAudioPosition() {
  if (!_audioEl) return 0.0;
  return _audioEl.currentTime;
}

function webGetAudioDuration() {
  if (!_audioEl) return 0.0;
  if (isNaN(_audioEl.duration)) return 0.0;
  return _audioEl.duration;
}
