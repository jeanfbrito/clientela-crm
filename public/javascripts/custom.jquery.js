function supports_input_placeholder() {
  var input = document.createElement('input');
  return 'placeholder' in input;
}

function add_input_placeholder_for_old_browsers() {
  if (!supports_input_placeholder()) {
    $("[placeholder]").focus(function() {
      var input = $(this);
      if (input.val() == input.attr("placeholder")) {
        input.val("");
        input.removeClass("placeholder");
      }
    }).blur(function() {
      var input = $(this);
      if (input.val() == "" || input.val() == input.attr("placeholder")) {
        input.addClass("placeholder");
        input.val(input.attr("placeholder"));
      }
    }).blur();
  }
}


$(document).ready(function() {
  add_input_placeholder_for_old_browsers();

  $(".hide-show-weekend").click(function(){
    $(".weekend").toggle();
    return false;
  });

  $(".fancybox-ajax").fancybox({
    'scrolling' : 'no',
    'onComplete' : function(){$("#task_content").focus();}
  });

  $(".fancybox-iframe").fancybox({
    'width'	: '100%',
    'height' : '100%',
    'type' : 'iframe'
  });

  $("a.note-image-show-link").fancybox({
    'transitionIn'  : 'elastic',
    'transitionOut' : 'elastic'
  });

  $(".extensible").live('keypress', function(){
    textarea = $(this);
    var lenght = textarea.width() / 8;
    textarea.height((parseInt(textarea.val().length / lenght) + 1) * 17)
  })

  $("a.quick-show-link").fancybox();

  $("#duration").hide();  
  if($("#deal_value_type option:selected").val() != "fixed") {
    $(".duration_span").hide();
    $("#duration").show();
    $("#" + $("#deal_value_type option:selected").val()).show();
  }

  $("#deal_value_type").change( function(){
    var selected_value = $("#deal_value_type option:selected").val();
    if(selected_value != "fixed"){
      $(".duration_span").hide();
      $("#duration").show(); 
      $("#" + selected_value).show();
    } else {
      $("#duration").hide();
    } 
  });

  $("form").submit(function() {
    $(this).find(".spinner").not('img[id$="_spinner"]').show().delay(5000).fadeOut();
    $(this).find("input[name='commit']").hide().delay(5000).fadeIn();
  });

  $("input[data-autocomplete]").keyup(function(){
    id = "#" + $(this).attr("id") + "_spinner";
    $(id).show().delay(700).fadeOut();
  });

  $(".notification a.close").click(function () {
    $(this).parent().fadeTo(400, 0, function () {
      $(this).slideUp(200);
    });
    return false;
  });
});
