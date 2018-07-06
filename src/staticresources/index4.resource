<!DOCTYPE HTML>
<!--[if IE 8]><html class="lt-ie9"  lang="en" dir="ltr" xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"><![endif]-->
<!--[if (gte IE 9)|(gt IEMobile 7)]><!-->
<html lang="en" dir="ltr" prefix="content: http://purl.org/rss/1.0/modules/content/ dc: http://purl.org/dc/terms/ foaf: http://xmlns.com/foaf/0.1/ og: http://ogp.me/ns# rdfs: http://www.w3.org/2000/01/rdf-schema# sioc: http://rdfs.org/sioc/ns# sioct: http://rdfs.org/sioc/types# skos: http://www.w3.org/2004/02/skos/core# xsd: http://www.w3.org/2001/XMLSchema#" class="js flexbox no-touch postmessage cssanimations cssgradients csstransforms csstransforms3d csstransitions localstorage svg svgclippaths object-fit"><!--<![endif]-->

<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=5; IE=EDGE; IE=Edge,chrome=1"/>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1 txt"/>     

<html xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">
    <head>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
        <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css">
        
        <script type="text/javascript" src="/resource/1430503428000/TCReference/TimeCircles.js"></script>
        <script src="https://html5shiv.googlecode.com/svn/trunk/html5.js"></script>

        <link rel="stylesheet" href="/resource/1430503428000/TCReference/TimeCircles.css" />
      
   
        
<style type="text/css">
  
<!--
body {
    background-image: url(/resource/1430503428000/TCReference/Double-Bubble-Countdown.jpg);
    background-repeat: no-repeat;

}
-->
</style>
    
</head>
    <body>
        <div class="container">
          
            <div id="DateCountdown" data-date="2015-05-31 23:59:59" style="width: 500px; height: 125px; padding: 0px; box-sizing: border-box; position:absolute; left: 314px; top: 14px;"></div>
    
            
        <script>
            $("#DateCountdown").TimeCircles();
            $("#CountDownTimer").TimeCircles({ time: { Days: { show: false }, Hours: { show: false } }});
            $("#PageOpenTimer").TimeCircles();
            
            var updateTime = function(){
                var date = $("#date").val();
                var time = $("#time").val();
                var datetime = date + ' ' + time + ':00';
                $("#DateCountdown").data('date', datetime).TimeCircles().start();
            }
            $("#date").change(updateTime).keyup(updateTime);
            $("#time").change(updateTime).keyup(updateTime);
           
        </script>  
    </body>
</html><head>
<!--[if gte mso 9]><xml>
<mso:CustomDocumentProperties>
<mso:ContentType msdt:dt="string">Document</mso:ContentType>
<mso:RecordType_CA msdt:dt="string">Secondary</mso:RecordType_CA>
</mso:CustomDocumentProperties>
</xml><![endif]-->
<title></title></head><!--[if (gte IE 9)|(gt IEMobile 7)]>