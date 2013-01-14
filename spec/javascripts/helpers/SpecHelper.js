beforeEach(function() {
  this.addMatchers({
    toBePlaying: function(expectedSong) {
      var player = this.actual;
      return player.currentlyPlayingSong === expectedSong
        && player.isPlaying;
    }
  });

  this.addMatchers({
    toHaveFocus: function() {
      return (this.actual.attr('id') == document.activeElement.id);
    }
  });
});

function mockGetTime() {
  spyOn(Date.prototype, 'getTime').andReturn(1);
}

function pressKeyTabOnId(id) {
  var evt = document.createEvent("KeyboardEvent");
  evt.initKeyEvent("keypress", true, true, null, false, false, false, false, 9, 0);
  document.getElementById(id).dispatchEvent(evt);
  return true;
}

String.prototype.trim = function() {
  return this.replace(new RegExp('\n| ','g'), '');
}