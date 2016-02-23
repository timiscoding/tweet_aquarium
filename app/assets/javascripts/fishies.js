tweets = []; // stores tweet JSON data
page = 1; // first page of the JSON data

// animates fishContainer left to right and vice versa
var moveFish = function( fishContainer ) {
  var $fishContainer = $( fishContainer );
  var duration = 15000 + Math.random() * 10000; // how long the fish takes to swim to the end of the page in ms
  var prop;
  if ( $fishContainer.data("dir") === "right" ) {
    prop = { "left": innerWidth + "px" }; // set animation end position to be window width
    $fishContainer.find('img').css('transform', 'scaleX(1)'); // fish faces right
  } else {
      prop = { "left": "-430px" }; // set the animation end position to be -fishContainer width
      $fishContainer.find('img').css('transform', 'scaleX(-1)'); // fish faces left
  }
  $fishContainer.animate( prop, {
    duration: duration,
    easing: 'linear',
    complete: function() {
      $( this ).trigger('fish:doneSwimming');
    }
  });
};

// randomly change the size of fishContainer
var randFishSize = function( fishContainer ){
    var randSize = 0.6 + ( Math.random() * 0.4 );
    $( fishContainer ).css('transform', 'scale(' + randSize + ',' + randSize + ')');
};

// randomly change vertical position of fishContainer
var randFishPos = function( fishContainer ) {
  var $fishContainer = $( fishContainer );
  var fishContainerHeight = $fishContainer.outerHeight(true);
  var windowHeight = innerHeight;
  var maxY = windowHeight - fishContainerHeight;
  var randY = Math.random() * maxY;
  $fishContainer.css('top', randY + 'px');
};

// get tweets json data from server
var getNewData = function( asyncFlag ) {
  if ( asyncFlag === undefined ) { asyncFlag = true; }
  var link = '/pages/' + page + '.json';
  return $.ajax({
    url: link,
    dataType: 'json',
    async: asyncFlag
  }).done( function( data ){
    tweets = tweets.concat(data.tweets);
    if ( data.page < data.pages ) {
      page++;
    } else { // loop back to first page of JSON data
      page = 1;
    }
  });
};

$(document).ready(function() {
  var fishTemplate = _.template( $('#fishTemplate').html() );
  var fishies = 6;

  getNewData(false); // get tweet data and wait until it's done
  for ( var i = 0; i < fishies; i++ ){
    // put tweet inside fishContainer element
    var fish = fishTemplate({ tweet_text: tweets.shift().post });
    $('#main').append( fish );
    $fish = $('.fishContainer').last();
    randFishSize( $fish );
    randFishPos( $fish );
    moveFish( $fish );
  }

  // listen for when fish reaches end of screen
  $('.fishContainer').on('fish:doneSwimming', function() {
    // get more tweets from server if tweets array running low
    if ( tweets.length <= 2 ) {
      getNewData();
    }

    // only change a fish's tweet if there's data available inside the tweets array
    // if none avail (ie. server down), just use current tweet
    if ( tweets.length !== 0 ) {
      $( this ).find('.tweet').text( tweets.shift().post );
    }

    randFishSize( this );
    randFishPos( this );

    // switch swim direction for fish
    if ( $( this ).data( "dir" ) === "left" ) {
      $( this ).data( "dir", "right" );
    } else {
      $( this ).data( "dir", "left" );
    }
    moveFish( this );
  });

  // pause animation if mouse enters fish
  $('.fishContainer').on('mouseenter', function() {
    $( this ).stop();
    $('.fishContainer').css('zIndex', '0'); // bring other fish to background
    $( this ).css('zIndex', '1'); // bring this fish to foreground

  });

  // resume animation when mouse leaves fish
  $('.fishContainer').on('mouseleave', function() {
    moveFish( this );
  });
});