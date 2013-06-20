function update_filter_targets(event){
  var filter_string = $(event.target).val().toLowerCase();

  if($.trim(filter_string) == ''){
    $('.js-filter_target').show();

  }else{
    $('.js-filter_target').each(function(index, element){
      var filter_matchable = $(element).data('filter_matchable').toLowerCase();

      if(filter_matchable.indexOf(filter_string) > -1){
        $(element).show();
      }else{
        $(element).hide();
      }
    });
  }
}

$(function(){
  $('.js-filter_control').keyup(update_filter_targets);
});
