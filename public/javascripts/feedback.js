MixPanel = {}

MixPanel.track_new_interface= function(kind, account, user){
	var data = {};
	data['survey'] = {'interface': 'new'};
	
	$.ajax({
	   type: "PUT",
	   url: "/users/survey",
	   data: data,
	   success: function(){
				mpmetrics.track( kind, { 'account': account, 'user': user, 'interface': 'new'});
				$(".notification").slideUp(200);
			}
	 });
}