function AjaxRequestManager(options) {
  this.ratings_dropdowns = options.ratings_dropdowns;
  this.data_url = options.data_url;
  this.data_method = options.data_method;
  this.data_product_id = options.data_product_id;
  this.response_flash = options.response_flash;
  this.loader_class = options.loader_class_name;
  this.border_green_class = options.border_green_class;
}

AjaxRequestManager.prototype.init = function() {
  var _this = this;
  this.ratings_dropdowns.change(function() {
    _this.rating_changes_handler($(this));
  });
};

AjaxRequestManager.prototype.rating_changes_handler = function(rating_dropdown) {
  var url = rating_dropdown.data(this.data_url),
    method_type = rating_dropdown.data(this.data_method),
    data_product_id = rating_dropdown.data(this.data_product_id);
    selected_rating = rating_dropdown.val(),
    _this = this;

  $.ajax({
    url : url,
    data : { product_id: data_product_id, score: selected_rating },
    type : method_type,
    dataType : 'json',
    beforeSend : function() {
      _this.response_flash.addClass(_this.loader_class);
    },
    success : function(response) {
      _this.response_flash.removeClass(_this.loader_class).addClass(_this.border_green_class).html(response.message);
    },
    error : function(xhr, status) {
      _this.response_flash.removeClass(_this.loader_class, _this.border_green_class).html(status);
    }
  });
};

$(function() {
  var options = {
    ratings_dropdowns : $('.ratings'),
    data_url : 'url',
    data_method : 'method',
    data_product_id : 'product-id',
    response_flash : $('[data-flash="response_msg"]'),
    loader_class_name: 'loader',
    border_green_class: 'border-green'
  },
    ajaxRequestManagerObject = new AjaxRequestManager(options);
    ajaxRequestManagerObject.init();
});
