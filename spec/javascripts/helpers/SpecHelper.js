beforeEach(function() {
  this.addMatchers({
    toBePlaying: function(expectedSong) {
      var player = this.actual;
      return player.currentlyPlayingSong === expectedSong
          && player.isPlaying;
    },
    
    toBeKindOf: function(expectedKlass) {
      var klass = this.actual;
      return klass && klass.isKindOf && klass.isKindOf(expectedKlass);
    },
    
    toBeTrue: function() {
      return !!this.actual;
    }
  });
});