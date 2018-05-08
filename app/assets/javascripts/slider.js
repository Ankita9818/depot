function Slider(options) {
  this.$slideshow = options.$slideshow;
  this.$slideshowItems = this.$slideshow.find('.slider_image');
  this.delay = options.delay;
  this.speed = options.speed;
  this.totalNumberOfItems = this.$slideshowItems.length;
  this.itemNumber = -1
}

Slider.prototype.init = function() {
  if(this.totalNumberOfItems > 1) {
    this.attachIndicators();
    this.initiateSlideshow();
  }
};

Slider.prototype.attachIndicators = function() {
  $('#main').prepend(this.$slideshow);
  this.$slideIndicator = $('<p/>', {
    'class' : 'indicator'
  });
  this.$slideshow.append(this.$slideIndicator);
  this.$slideshowItems.hide();
};

Slider.prototype.initiateSlideshow = function() {
  var _this = this;
  setInterval(function() {
    _this.playSlideshow();
  }, this.delay);
};

Slider.prototype.playSlideshow = function() {
  this.$slideshowItems.eq(this.itemNumber).fadeOut(0);
  this.itemNumber = (this.itemNumber + 1 >= this.totalNumberOfItems) ? 0 : this.itemNumber + 1;
  this.$slideshowItems.eq(this.itemNumber).fadeIn(this.speed);
  this.indicateCurrentSlide(this.itemNumber + 1);
};

Slider.prototype.indicateCurrentSlide = function(num) {
  this.$slideIndicator.text(num + ' / ' + this.totalNumberOfItems);
};

$(function() {
  var options = {
    $slideshow : $("[data-id=slideshow]"),
    delay : 1000,
    speed : 500
  },
    sliderObject = new Slider(options);
  sliderObject.init();
});