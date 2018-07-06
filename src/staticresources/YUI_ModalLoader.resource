var $j = jQuery.noConflict(true);
        function YUIShowLoading() 
        {
            try 
            {
                $j.blockUI({ message: '<h1>Please wait...</h1>', css: { 
                    border: 'none', 
                    padding: '15px', 
                    backgroundColor: '#000', 
                    '-webkit-border-radius': '10px', 
                    '-moz-border-radius': '10px',              
                    opacity: .5, 
                    color: '#fff' 
                } }); 
                
            } 
            catch(ex)
            {
                alert(ex);
            }
        }
        function YUIHideLoading()
        {
            try
            {   
              
                $j.unblockUI(); 
            }
            catch(ex)
            {
                alert(ex);
            }
        }    