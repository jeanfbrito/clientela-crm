function f(str, obj) {
  var a = arguments, obj = obj || window || this;
  return str.replace(/(\\\$)|(\$\$)|\$([0-9])|\$(\w+)|\$\{(\w+)\}/g,
    function() {
      var q = arguments;
      return (q[1] || q[2]) ? '$' : q[3] ? a[q[3]] : q[4] ? obj[q[4]] : obj[q[5]];
  });
}

var CustomTextBoxList = {
  configure_for: function(model) {
    try {
      var tagList = new $.TextboxList(f("#$1_tag_list", model), {unique: true, plugins: {autocomplete: {placeholder: ''}}});
      tagList.plugins['autocomplete'].setValues(tags);

      $('div.sample-tags span').click(function() {
        tagList.add($(this).html());
      });
    } catch(err) {}
  }
}

var Key = {
  TAB: 9,
  OTHER: 0,
  
  tab: function(event) {
    return (event.keyCode == Key.TAB);  
  },
  
  shiftTab: function(event) {
    return event.shiftKey && (event.keyCode == Key.TAB);  
  }
};

function clearUnclearOnDefaultValue(element_id) {
  $(element_id).focus(function() {
    if (this.value == this.defaultValue) {
      this.value = '';
    }
  });
  $(element_id).blur(function() {
    if (this.value == '') {
      this.value = this.defaultValue;
    }
  });
}

var Form = {
  elements: function(element) {
    var form = $(element).closest("form");
    return form.find(":input:not(div.template :input):not(input[type=hidden])");
  },
  
  previousElement: function(element) {
    var elements = Form.elements(element);
    var index = elements.index(element);
    return elements[index-1];
  },

  nextElement: function(element) {
    var elements = Form.elements(element);
    var index = elements.index(element);
    return elements[index+1];
  },

  Nested: function(element) {    
    this.element = $(element);
    this.elements = this.element.closest("div.fields").find(":input:not(input[type=hidden])");
  
    this.lastElement = function() {
      return (this.index() == (this.elements.size()-1));
    }
    
    this.firstElement = function() {
      return (this.index() == 0);
    }
    
    this.allBlank = function() {
      var isBlank = true;
      this.element.closest("div.fields").find(":input:not(input[type=hidden]):not(select)").each(function(i, item){
        var element = $(item);
        if(!((element.val() == '') || (element.attr("data-default") == element.val()))) {
          isBlank = false;
        }
      });
      return isBlank;
    }
    
    this.index = function() {
      return this.elements.index(this.element);
    }
    
    this.nested = function() {
      return (this.index() != -1);
    }
  },

  hideFieldsIfBlank: function(event) {
    var fields = new Form.Nested(event.target);
    if (!fields.nested()) return;

    if (((Key.shiftTab(event) && fields.firstElement()) || fields.lastElement()) && fields.allBlank()) {
      $(event.target).parent().hide();
    }
  },
  
  focusOnNextOrPrevious: function(event) {
    var input;
    if(Key.shiftTab(event)) {
      input = Form.previousElement(event.target);
    } else {
      input = Form.nextElement(event.target);
    }
    
    if(!input) return;
    $(input).closest('div.fields').show();
    input.focus();
  },

  keydown: function(event) {
    if(!Key.tab(event)) return;
    Form.hideFieldsIfBlank(event);
    Form.focusOnNextOrPrevious(event);
    return false;
  }
}

function fixSearchFormSize(field_id, padding) {
  new_width = $("#" + field_id).parent("form").width() - padding;
  return $("#" + field_id).css("width", new_width + "px");
}

$(function() {
  fixSearchFormSize("inline-search-input", 40);

  $("#inline-search-input").focus(function() {
    $(this).addClass("hover");
  }).blur(function() {
    $(this).removeClass("hover");
  });
});

$(window).resize(function() {
  fixSearchFormSize("inline-search-input", 40);
});