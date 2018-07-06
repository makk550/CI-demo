var MapController = Class.create({
	initialize: function(initialAddress,mapElementId){                
		this.initialAddress = initialAddress;
		this.mapElementId = mapElementId;
                var geocoder = new google.maps.Geocoder();
   
         geocoder.geocode( { 'address': this.initialAddress}, function(results, status) {
          if (status == google.maps.GeocoderStatus.OK) {

		var mapOptions = {
			  disableDefaultUI: true,
		   center:new google.maps.LatLng(37.4419, -122.1419),                          
		   mapTypeId: google.maps.MapTypeId.ROADMAP,			
   zoom: 14,

		  }
		this.map = new google.maps.Map(
                           $(mapElementId), mapOptions);

               this.map.setCenter(results[0].geometry.location);
            

            var marker = new google.maps.Marker({
                map: this.map,
                position: results[0].geometry.location,
                draggable: true
            });

            google.maps.event.addListener(marker, "dragend", function() {
              $('p:f:latitude').value = marker.getPosition().lat();
              $('p:f:longitude').value = marker.getPosition().lng();
            });
            $('p:f:latitude').value = marker.getPosition().lat();
            $('p:f:longitude').value = marker.getPosition().lng();
            fireLocationFound();
          } else {
            fireLocationNotFound();

          }
        });
    

    } 
                               		      	
	
});

document.observe('dom:loaded', function() {
	if($('map_canvas') && $('p:f:address')){
		new MapController($F('p:f:address'),'map_canvas');
	}
}, false);
