/* 
*    http://lesscss.org/ 
*    A dynamic stylesheet language. The following plugins will be needed for LESS files to work with visual studio.   
*    Web Essentials 2012: http://visualstudiogallery.msdn.microsoft.com/07d54d12-7133-4e15-becb-6f451ea3bea6
*    Web Tools 2012.2: http://go.microsoft.com/fwlink/?LinkId=282650
*/
/* Supporting */
/****************************************
    Rounded Corners 
    Custom Border Radius
    Box Shadow 
    Transition
    Transform
    Sizes (width/height/square/background)
    Gradient
    REM Font Size
    RGBa
    Opacity
    IE7 inline-block
******************************************/
/* Rounded Corners 
================================================== */
/* Implementation 
#somediv { .border-radius(20px); } */
/* Custom Border Radius 
================================================== */
/* Implementation 
#somediv { .border-radius-custom(20px, 20px, 0px, 0px); } */
/* Box Shadow 
================================================== */
/* Implementation 
#somediv { .box-shadow(5px, 5px, 6px, 0.3); } */
/* Transition 
================================================== */
/* Implementation 
#somediv { .transition(all, 0.5s, ease-in); }
#somediv:hover { opacity: 0; } */
/* Transform 
================================================== */
/* Implementation 
#someDiv { .transform(5deg, 0.5, 1deg, 0px); } */
/* Linear Gradient 
================================================== */
/* Implementation 
#someDiv { .gradient(left, #663333, #333333); } */
/* Sizes
================================================== */
/* Implementation 
#someDiv { .size(30px, 50px); } 
#someDiv { .square(30px); } */
/* Gradient
================================================== */
/* Tablet Portrait */
/* Phone Landscape and Portrait */
@media only screen and (max-width: 767px) {
  .span-sm-6 {
    width: 48%!important;
    float: left!important;
  }
  .span-sm-6:first-child {
    margin-right: 4%!important;
  }
}
@font-face {
  font-family: 'CA Sans Web';
  src: url('fonts/CASansWebRegular/ca_sans_web-regular.eot');
  src: url('fonts/CASansWebRegular/ca_sans_web-regular.eot?#ieﬁx') format('embedded-opentype'), /* IE6-IE8 */ url('fonts/CASansWebRegular/ca_sans_web-regular.woff') format('woff'), /* Modern Browsers */ url('fonts/CASansWebRegular/ca_sans_web-regular.svg#svgFontName') format('svg');
  font-weight: normal;
  font-style: normal;
  
  /* IE9 */
  /* Legacy iOS */
}
@font-face {
  font-family: 'CA Sans Web Bold';
  src: url('fonts/CASansWebBold/ca_sans_web-bold.eot');
  src: url('fonts/CASansWebBold/ca_sans_web-bold.eot?#ieﬁx') format('embedded-opentype'), /* IE6-IE8 */ url('fonts/CASansWebBold/ca_sans_web-bold.woff') format('woff'), /* Modern Browsers */ url('fonts/CASansWebBold/ca_sans_web-bold.svg#svgFontName') format('svg');
  font-weight: bold;
  font-style: normal;
  
  /* IE9 */
  /* Legacy iOS */
}
@font-face {
  font-family: 'CA Sans Web Light';
  src: url('fonts/CASansWebLight/ca_sans_web-light.eot');
  src: url('fonts/CASansWebLight/ca_sans_web-light.eot?#ieﬁx') format('embedded-opentype'), /* IE6-IE8 */ url('fonts/CASansWebLight/ca_sans_web-light.woff') format('woff'), /* Modern Browsers */ url('fonts/CASansWebLight/ca_sans_web-light.svg#svgFontName') format('svg');
  font-weight: normal;
  font-style: normal;
  
  /* IE9 */
  /* Legacy iOS */
}
/* CA Colors */
head {
  font-family: "D";
}
body:after {
  content: "D";
  display: none;
}
/* Table of Content
==================================================
	#Site-Wide Styles
    #Additional Helpers
	#Module Styles
	#Media Queries 
*/
/* #Site-Wide Styles
================================================== */
html {
  font-size: 62.5%;
}
body {
  padding-top: 113px;
  padding-bottom: 40px;
  font-size: 12px;
  font-size: 1.2rem;
}
body.main {
  padding-top: 0;
}
a:hover,
a:focus {
  color: #00b0ca;
  text-decoration: underline;
}
a {
  color: #00b0ca;
  text-decoration: none;
}
.dark,
a.dark,
a.darkonlight {
  color: #333333;
  text-decoration: none;
}
a.dark:hover {
  color: #00b0ca;
  text-decoration: underline;
}
a.darkonlight:hover {
  text-decoration: underline;
}
b,
strong {
  font-weight: bold;
}
h1,
h2,
h3,
h4,
h5,
h6,
.casans {
  font-weight: normal;
  font-family: 'CA Sans Web', Verdana, Geneva, 'DejaVu Sans', sans-serif;
}
h1 b,
h2 b,
h3 b,
h4 b,
h5 b,
h6 b,
.casans b {
  font-family: 'CA Sans Web Bold', Verdana, Geneva, 'DejaVu Sans', sans-serif;
}
.casansbold {
  font-family: 'CA Sans Web Bold', Verdana, Geneva, 'DejaVu Sans', sans-serif;
  font-weight: normal;
}
.casanslight {
  font-family: 'CA Sans Web Light', Verdana, Geneva, 'DejaVu Sans', sans-serif;
  font-weight: normal;
}
h1 {
  font-size: 42px;
  font-size: 4.2rem;
  color: #0064af;
  font-weight: normal;
}
h2 {
  font-size: 34px;
  font-size: 3.4rem;
  color: #0064af;
  font-weight: normal;
}
h3 {
  font-size: 26px;
  font-size: 2.6rem;
  line-height: 28px;
  line-height: 2.8rem;
  color: #0064af;
  font-weight: normal;
}
h4 {
  font-size: 14px;
  font-size: 1.4rem;
  line-height: 18px;
  line-height: 1.8rem;
  color: #444444;
  font-weight: normal;
  font-family: Verdana, Geneva, 'DejaVu Sans', sans-serif;
}
h5 {
  font-size: 26px;
  font-size: 2.6rem;
  line-height: 28px;
  line-height: 2.8rem;
  color: #444444;
  font-weight: normal;
}
hr,
.hr {
  clear: both;
  border: 0;
  height: 1px;
  background: url("{!$Resource.bdr_dotted_png}") repeat-x left top;
  margin: 20px 0;
}
.row hr,
.row .hr {
  margin-left: 20px;
}
.mart10 {
  margin-top: 10px;
}
.mart15 {
  margin-top: 15px;
}
.mart20 {
  margin-top: 20px;
}
.mart30 {
  margin-top: 30px;
}
.mart40 {
  margin-top: 40px;
}
.marb70 {
  margin-bottom: 70px;
}
.marb50 {
  margin-bottom: 50px;
}
.marb30 {
  margin-bottom: 0px;
}
.marb40 {
  margin-bottom: 30px;
}
.marb20 {
  margin-bottom: 20px;
}
.marb10 {
  margin-bottom: 10px;
}
.marcenter {
  margin-left: auto;
  margin-right: auto;
}
.marb0 {
  margin-bottom: 0 !important;
}
.marl20 {
  margin-left: 20px;
}
.marr10 {
  margin-right: 10px;
}
.nomar {
  margin: 0 !important;
}
.padb10 {
  padding-bottom: 10px;
}
.padb20 {
  padding-bottom: 20px;
}
.padb30 {
  padding-bottom: 30px;
}
.padb40 {
  padding-bottom: 40px;
}
.padt5 {
  padding-top: 5px;
}
.padt10 {
  padding-top: 10px;
}
.padt20 {
  padding-top: 20px;
}
.padt40 {
  padding-top: 40px;
}
.padt80 {
  padding-top: 80px;
}
.padl30 {
  padding-left: 30px;
}
.padr30 {
  padding-right: 30px;
}
.marl0 {
  margin-left: 0 !important;
}
.sec a:hover,
.sec a:focus {
  color: #0064af;
}
.sec,
.sec a {
  color: #333333;
  font-size: 13px;
  font-size: 1.3rem;
  line-height: 18px;
  line-height: 1.8rem;
  text-decoration: none;
  list-style: none;
  margin-left: 0;
  display: block;
}
.sec a {
  background: url("{!$Resource.arrows_png}") no-repeat -64px -112px;
  padding-left: 20px;
}
.sec li {
  margin-left: 12px;
}
.sec.spaced li {
  margin-bottom: 16px;
  margin-bottom: 1.6rem;
}
.intro {
  font-size: 14px;
  font-size: 1.4rem;
  line-height: 24px;
  line-height: 2.4rem;
  color: #444444;
}
.intro2 {
  font-size: 19px;
  font-size: 1.9rem;
  line-height: 35px;
  line-height: 3.5rem;
}
.cta1 {
  display: block;
  color: #0064af;
  text-decoration: none;
}
.cta1:hover,
.cta1:active {
  text-decoration: none;
}
.cta2 {
  display: block;
  text-decoration: none;
  padding: 20px 20px 20px 40px;
  color: #ffffff;
  background: url("{!$Resource.arrows_png}") no-repeat -95px -40px;
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 20px;
  line-height: 2rem;
}
.cta2:hover,
.cta2:active {
  color: #ffffff;
}
.cta3 {
  color: #00b0ca;
  text-decoration: none;
  font-weight: bold;
}
.cta3:hover {
  color: #00b0ca;
}
a.unstyled {
  text-decoration: none;
}
a.unstyled:hover {
  text-decoration: underline;
}
/* header start */
.header-fixed-top {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background: #ffffff;
  -webkit-box-shadow: 0 3px 4px rgba(0, 0, 0, 0.06);
  -moz-box-shadow: 0 3px 4px rgba(0, 0, 0, 0.06);
  box-shadow: 0 3px 4px rgba(0, 0, 0, 0.06);
  padding: 15px 0 15px;
  height: 83px;
  z-index: 99;
}
.main .header-fixed-top {
  background: url("{!$Resource.trans_white_png}");
  background: rgba(255, 255, 255, 0.8);
  -webkit-transition: all 0.5s ease;
  -moz-transition: all 0.5s ease;
  -o-transition: all 0.5s ease;
  -ms-transition: all 0.5s ease;
  transition: all 0.5s ease;
}
.main .header-fixed-top.solid {
  background: #fff;
}
.no-boxshadow .header-fixed-top {
  border-bottom: 1px solid #dfdfdf;
}
.header.container {
  position: relative;
}
.brand-logo {
  width: 94px;
  height: 78px;
  background: url("{!$Resource.bw_logo_png}") no-repeat;
  display: block;
  -ms-zoom: 1;
  zoom: 1;
  *display: inline;
  text-indent: -3000px;
  position: absolute;
  top: 0;
  left: 0;
}
.nav-utility {
  position: absolute;
  top: 0;
  right: 0;
  font-size: 11px;
  font-size: 1.1rem;
}
.nav-utility a {
  margin-left: 10px;
  color: #444444;
  text-decoration: none !important;
}
.nav-utility a:hover {
  color: #00b0ca;
  text-decoration: none;
}
.nav-utility .phone {
  margin-left: 10px;
}
input[type="text"].nav-search,
.nav-search {
  position: absolute;
  right: 0;
  top: 53px;
  width: 160px;
  -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  border: 0;
  font-size: 12px;
  font-size: 1.2rem;
  padding: 7px 10px 7px 30px;
  background: url("{!$Resource.search_png}") no-repeat left bottom;
  font-weight: bold;
  -webkit-border-radius: 0px;
  -moz-border-radius: 0px;
  border-radius: 0px;
  line-height: normal;
  height: auto;
}
.no-boxshadow .nav-search,
.no-boxshadow input[type="text"].nav-search {
  border: 1px solid #c2d1d4;
}
.innercontent-width {
  width: 12% !important;
  margin-top: -5px !important;
}
.current {
  color: #95a0a9;
}
/*M*/
/* CA Colors */
/* Tablet and Desktops */
.header-fixed-top a {
  color: #444444;
  text-decoration: underline;
}
.header-fixed-top .nav-menuwrapper {
  margin: 57px 220px 0 0;
}
.header-fixed-top .nav-menuwrapper ul {
  padding: 0;
  list-style: none;
  font-size: 11px;
  font-size: 1.1rem;
}
.header-fixed-top .nav-menu > li {
  float: left;
  margin: 0 10px 0 25px;
  font-size: 14px;
  font-size: 1.4rem;
}
.header-fixed-top .nav-menu a:hover {
  color: #0064af;
  text-decoration: none;
}
.header-fixed-top .nav-menuwrapper li.nav-back:after {
  left: 10px;
  color: rgba(212, 204, 198, 0.3);
  -moz-transform: rotate(180deg);
  -webkit-transform: rotate(180deg);
  transform: rotate(180deg);
}
.header-fixed-top .currentarea,
.header-fixed-top .active-area {
  border-bottom: 5px solid #00b0ca;
  padding-bottom: 5px;
  zoom: 1;
}
.header-fixed-top .nav-top {
  cursor: pointer;
}
.nav-dropdown-wrap {
  position: fixed;
  top: 113px;
  z-index: 3;
  left: 0;
  right: 0;
}
.nav-dropdown-wrap a {
  color: #333;
}
.nav-dropdown-wrap a:hover {
  color: #00b0ca;
  text-decoration: none;
}
.nav-dropdown-wrap .header {
  font-weight: bold;
  background: url("{!$Resource.bdr_dotted_png}") repeat-x bottom left;
  padding-bottom: 15px;
  display: block;
  margin-bottom: 5px;
  max-width: 600px;
}
.nav-dropdown-wrap .two-three .header {
  *margin-left: -15px;
}
.nav-dropdown-wrap .subheader {
  font-weight: bold;
}
.nav-dropdown-wrap .nav-dropdown-item li {
  list-style: none;
  padding: 0 0 10px;
  padding: 0 0 1rem;
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
}
.nav-dropdown-wrap .build-menu-wide ul,
.nav-dropdown-wrap .build-menu ul {
  margin: 0;
}
.nav-dropdown-wrap .nav-dropdown-item {
  margin: 0 auto;
  background: #f8f8f8;
  display: none;
  position: relative;
  overflow: hidden;
  padding: 40px 40px 10px;
  -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}
.no-boxshadow .nav-dropdown-wrap .nav-dropdown-item {
  border: 1px solid #e0eaf2;
  border-top: none;
}
.nav-dropdown-wrap .large li {
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 20px;
  line-height: 2rem;
}
.nav-dropdown-wrap .larger li {
  font-size: 21px;
  font-size: 2.1rem;
  line-height: 25px;
  line-height: 2.5rem;
}
.nav-dropdown-wrap .build-menu {
  max-width: 920px;
}
.nav-dropdown-wrap .build-menu .b-column-1,
.nav-dropdown-wrap .build-menu .b-column-2 {
  float: left;
  width: 29%;
  margin-right: 6%;
}
.nav-dropdown-wrap .build-menu .b-column-r {
  width: 30%;
}
.nav-dropdown-wrap .build-menu-wide {
  max-width: 1400px;
}
.nav-dropdown-wrap .build-menu-wide .b-column-1,
.nav-dropdown-wrap .build-menu-wide .b-column-2,
.nav-dropdown-wrap .build-menu-wide .b-column-3 {
  float: left;
  width: 22%;
  margin-right: 4%;
}
.b-column-2-3 {
  width: 48%;
  float: left;
}
.b-column-2-3 .b-column-2 {
  width: 45% !important;
  margin: 0 !important;
}
.b-column-2-3 .b-column-3 {
  width: 49% !important;
  margin: 0 0 0 4% !important;
}
.nav-dropdown-wrap .b-column-r {
  width: 25%;
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  background: #fff;
  margin: 0;
  border-left: 1px solid #e0eaf2;
}
.nav-dropdown-wrap .b-column-r .img-spacing {
  margin: 20px 0;
}
.nav-dropdown-wrap .nav-dropdown-item .b-column-r-pad {
  padding: 40px 40px 10px;
}
.nav-dropdown-wrap .nav-dropdown-item .b-column-r-pad.lower {
  padding: 10px 40px;
}
.nav-dropdown-wrap a.nav-action {
  color: #00b0ca;
  font-weight: bold;
}
.nav-dropdown-wrap a.nav-action:hover {
  text-decoration: underline;
}
.nav-dropdown-wrap .spacer-top {
  margin-top: 20px;
}
.nav-dropdown-wrap .spacer-bottom {
  margin-bottom: 20px;
}
@media only screen and (min-width: 768px) and (max-width: 979px) {
  .nav-utility {
    right: 190px;
  }
  input[type="text"].nav-search,
  .nav-search {
    top: 0;
  }
  .header-fixed-top .nav-menuwrapper {
    margin: 57px 0 0 0;
  }
  .header-fixed-top .nav-menu > li {
    float: left;
    margin: 0 0 0 35px;
    font-size: 14px;
    font-size: 1.4rem;
  }
  .nav-dropdown-wrap .header {
    max-width: 95%;
  }
  .nav-dropdown-wrap .b-column-r {
    display: none;
  }
  .nav-dropdown-wrap .build-menu-wide .b-column-1,
  .nav-dropdown-wrap .build-menu-wide .b-column-2,
  .nav-dropdown-wrap .build-menu-wide .b-column-3 {
    width: 30%;
  }
  .nav-dropdown-wrap .build-menu-wide .b-column-3 {
    margin-right: 0;
  }
  .b-column-2-3 {
    width: 63%;
  }
  .nav-dropdown-wrap .build-menu .b-column-1,
  .nav-dropdown-wrap .build-menu .b-column-2 {
    width: 45%;
  }
  .nav-dropdown-wrap .build-menu .b-column-2 {
    margin-right: 0;
  }
}
@media only screen and (max-width: 767px) {
  .nav-menuwrapper {
    overflow: hidden;
    -moz-perspective: 1000px;
    -webkit-perspective: 1000px;
    perspective: 1000px;
    -moz-perspective-origin: 50% 200%;
    -webkit-perspective-origin: 50% 200%;
    perspective-origin: 50% 200%;
    position: absolute;
    top: 55px;
    left: 0;
    width: 100%;
    z-index: 9;
    background: #ffffff;
  }
  .nav-menuwrapper ul {
    -moz-transform-style: preserve-3d;
    -webkit-transform-style: preserve-3d;
    transform-style: preserve-3d;
    margin: 0;
    padding: 0;
    list-style: none;
  }
  .nav-menuwrapper li {
    position: relative;
    margin: 0;
    padding: 0;
    background: url("{!$Resource.bdr_dotted_gif}") repeat-x center bottom;
  }
  .nav-menuwrapper li a {
    display: block;
    padding: 10px 20px 18px 25px;
    outline: none;
    color: #000;
    font-weight: 300;
    font-size: 16px;
    line-height: 20px;
    text-decoration: none;
  }
  /*.nav-menuwrapper li.nav-back > a { padding-left: 30px; background: rgba(0,0,0,0.1); }*/
  .nav-menuwrapper li.nav-back:after,
  .nav-menuwrapper li > a:not(:only-child):after {
    speak: none;
    position: absolute;
    top: -6px;
    width: 8px;
    background: url("{!$Resource.arrows_nav_png}") no-repeat center left;
    color: #ffffff;
    content: ".";
    text-indent: 700px;
    line-height: 50px;
  }
  .nav-menuwrapper li.nav-back:after {
    left: 10px;
    background: url("{!$Resource.arrows_nav_png}") no-repeat center right;
  }
  .nav-menuwrapper li > a:after {
    right: 10px;
  }
  .nav-menuwrapper .nav-menu {
    -moz-backface-visibility: hidden;
    -webkit-backface-visibility: hidden;
    backface-visibility: hidden;
    margin: 5px 0 -5px 0;
    padding-top: 5px;
    width: 100%;
    height: 0;
    opacity: 0;
    -moz-transform: translateY(10px);
    -webkit-transform: translateY(10px);
    transform: translateY(10px);
    pointer-events: none;
  }
  .nav-menuwrapper .nav-menu.nav-menu-toggle {
    -moz-transition: all 0.3s ease;
    -webkit-transition: all 0.3s ease;
    transition: all 0.3s ease;
  }
  .nav-menuwrapper .nav-menu.nav-menuopen {
    overflow: hidden;
    height: auto !important;
    opacity: 1;
    -moz-transform: translateY(0px);
    -webkit-transform: translateY(0px);
    transform: translateY(0px);
    pointer-events: auto;
  }
  .nav-menuwrapper li .nav-submenu {
    display: none;
  }
  .nav-menu.nav-subview li,
  .nav-menu.nav-subview li.nav-subviewopen > a,
  .nav-menu.nav-subview li.nav-subview > a {
    display: none;
  }
  .nav-menu.nav-subview li.nav-subview,
  .nav-menu.nav-subview li.nav-subview .nav-submenu,
  .nav-menu.nav-subview li.nav-subviewopen,
  .nav-menu.nav-subview li.nav-subviewopen > .nav-submenu,
  .nav-menu.nav-subview li.nav-subviewopen > .nav-submenu > li {
    display: block;
  }
  /* Dynamically added submenu outside of the menu context */
  .nav-menuwrapper > .nav-submenu {
    position: absolute;
    top: 0;
    left: 0;
    margin: 0;
    width: 100%;
  }
  /* Animation classes for moving out and in */
  .nav-menu.nav-animate-out {
    -moz-animation: MenuAnimOut 0.3s 0 ease-in-out forwards;
    -webkit-animation: MenuAnimOut 0.3s 0 ease-in-out forwards;
    animation: MenuAnimOut 0.3s 0 ease-in-out forwards;
  }
  .nav-menu.nav-animate-in {
    -moz-animation: MenuAnimIn 0.3s ease-in-out forwards;
    -webkit-animation: MenuAnimIn 0.3s ease-in-out forwards;
    animation: MenuAnimIn 0.3s ease-in-out forwards;
  }
  .nav-menuwrapper > .nav-submenu.nav-animate-in {
    -moz-animation: SubMenuAnimIn 0.3s ease-in-out forwards;
    -webkit-animation: SubMenuAnimIn 0.3s ease-in-out forwards;
    animation: SubMenuAnimIn 0.3s ease-in-out forwards;
  }
  .nav-menuwrapper > .nav-submenu.nav-animate-out {
    -moz-animation: SubMenuAnimOut 0.3s ease-in-out forwards;
    -webkit-animation: SubMenuAnimOut 0.3s ease-in-out forwards;
    animation: SubMenuAnimOut 0.3s ease-in-out forwards;
  }
  /* No JS Fallback */
  .no-js .nav-menuwrapper .nav-menu {
    position: relative;
    opacity: 1;
    -moz-transform: none;
    -webkit-transform: none;
    transform: none;
  }
  .no-js .nav-menuwrapper li .nav-submenu {
    display: block;
  }
  .no-js .nav-menuwrapper li.nav-back {
    display: none;
  }
  .no-js .nav-menuwrapper li > a:not(:only-child) {
    background: rgba(0, 0, 0, 0.1);
  }
  .no-js .nav-menuwrapper li > a:not(:only-child):after {
    content: '';
  }
  /* styles */
  .nav-menuwrapper button,
  .nav-menuwrapper button:hover,
  .nav-menuwrapper button.nav-active,
  .nav-menuwrapper ul {
    background: #ffffff;
  }
  .nav-menuwrapper .mm-desc,
  .nav-menuwrapper .nav-promo,
  .nav-menuwrapper img,
  #nav-promo {
    display: none;
  }
}
/* header end */
.resource-label {
  position: relative;
  padding: 0 0 0 40px;
  font-size: 22px;
  font-size: 2.2rem;
  line-height: 32px;
  line-height: 3.2rem;
  color: #0064af;
  overflow: hidden;
}
.icon {
  width: 32px;
  height: 32px;
  display: inline-block;
  zoom: 1;
  *display: inline;
  position: absolute;
  top: 0;
  left: 0;
}
.img-icon {
  position: absolute;
}
.blogs .icon {
  background: url("{!$Resource.icns_png}") no-repeat -32px 0;
}
.learning-paths .icon,
.role-based .icon,
.process-maps .icon {
  background: url("{!$Resource.icns_png}") no-repeat -32px -64px;
}
.success-stories .icon {
  background: url("{!$Resource.icns_png}") no-repeat -96px -64px;
}
.webcasts .icon,
.recorded-webcasts .icon {
  background: url("{!$Resource.icns_png}") no-repeat 0 -96px;
}
.demos .icon,
.technology-initiatives .icon {
  background: url("{!$Resource.icns_png}") no-repeat -128px 0;
}
.ebooks .icon,
.flipboards .icon {
  background: url("{!$Resource.icns_png}") no-repeat -160px 0;
}
.industry-research .icon {
  background: url( "{!$Resource.icns_png}") no-repeat 0 -32px;
}
.podcasts .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -192px -32px;
}
.awards .icon,
.product-announcements .icon,
.industry-analyst-recognition .icon,
.special-offers .icon,
.industry-certifications .icon {
  background: url( "{!$Resource.icns_png}") no-repeat 0 0;
}
.trials .icon,
.presentations .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -192px -64px;
}
.technology-partnerships .icon,
.partner-testimonials .icon,
.quotes .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -160px -32px;
}
.industry-analyst-reports .icon,
.industry-trends .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -32px -32px;
}
.product-briefs .icon,
.service-briefs .icon,
.services-briefs .icon,
.tech-briefs .icon,
.technology-briefs .icon,
.solution-briefs .icon,
.education-briefs .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -64px 0;
}
.service-offerings .icon,
.education-offerings .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -64px -64px;
}
.data-sheets .icon,
.executive-briefs .icon,
.press-releases .icon,
.newsletters .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -96px 0;
}
.articles .icon,
.news-articles .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -32px -96px;
}
.partners .icon,
.hosting-partners .icon,
.executive-profiles .icon,
.user-communities .icon,
.service-partners .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -160px -32px;
}
.white-papers .icon,
.brochures .icon,
.technical-documents .icon,
.fact-sheets .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -32px -96px;
}
.videos .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -224px -64px;
}
.roi-calculator .icon {
  background: url( "{!$Resource.icns_png}") no-repeat 0px -64px;
}
.best-practices-programs .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -96px -64px;
}
.faqs .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -64px -32px;
}
.infographic .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -128px -64px;
}
.add-on-services-components .icon {
  background: url( "{!$Resource.icns_png}") no-repeat 0 -96px;
}
.product-inventory .icon {
  background: url( "{!$Resource.icns_png}") no-repeat 0 -32px;
}
.licensing .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -64px -96px;
}
.compatibility-tables .icon {
  background: url( "{!$Resource.icns_png}") no-repeat -32px -32px;
}
.footer a {
  text-decoration: none;
  margin-right: 20px;
  color: #444444;
}
.footer a:hover {
  color: #00b0ca;
}
.news {
  margin-top: -15px;
  margin-bottom: -15px;
}
.news p,
.news-list {
  margin: 0;
}
.news-list dt {
  color: #00b0ca;
  text-transform: uppercase;
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 30px;
  line-height: 3rem;
  float: left;
  margin-right: 5px;
}
.news-list dt a {
  color: #00b0ca;
}
.news-list dd {
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 20px;
  line-height: 2rem;
  margin: 0;
  padding-top: .45em;
  overflow: hidden;
}
.news-list a {
  text-decoration: none;
  color: #666666;
}
.news-list a:hover {
  color: #00b0ca;
  text-decoration: underline;
}
/* Removes headlines by feedburner Logo start */
div#creditfooter {
  display: none;
}
/* Removes headlines by feedburner Logo end */
.eight-four {
  background: #f9f9f9;
  min-height: 334px;
}
.eight-four .pad {
  padding: 35px 20px 5px;
}
.ef-main {
  font-size: 24px;
  font-size: 2.4rem;
  line-height: 26px;
  line-height: 2.6rem;
}
/* Social Media*/
.follow-list {
  margin: 4px 0 3px;
  line-height: 0px;
}
.follow-list li {
  padding-left: 0 !important;
  padding-right: 0 !important;
  display: inline-block;
  margin: 0 0 0 6px;
}
.follow {
  display: block;
  overflow: hidden;
  width: 23px;
  height: 23px;
  background-image: url("{!$Resource.icns_social_png}");
  background-repeat: no-repeat;
  text-indent: 3000px;
}
.follow.googleplus {
  background-position: 0 0;
}
.follow.twitter {
  background-position: -25px 0;
}
.follow.facebook {
  background-position: -50px 0;
}
.follow.linkedin {
  background-position: -75px 0;
}
.follow.youtube {
  background-position: -100px 0;
}
.news .span4 .follow-text {
  font-size: 10px;
  font-size: 1rem;
  line-height: 30px;
  line-height: 3rem;
  display: inline;
  margin-right: 5px;
  margin-top: 4px;
  line-height: 23px;
  line-height: 2.3rem;
}
.extended-footer a:link {
  color: #444444;
}
.extended-footer a:hover {
  color: #00b0ca;
}
.tab-group {
  position: relative;
  vertical-align: middle;
  white-space: nowrap;
  *margin-left: .3em;
  margin: 0;
  padding: 0;
}
.tab-group:first-child {
  *margin-left: 0;
}
.tab-group li {
  position: relative;
  -webkit-border-radius: 0;
  -moz-border-radius: 0;
  border-radius: 0;
  display: inline-block;
  *display: inline;
  /* IE7 inline-block hack */
  *zoom: 1;
  background: #ccc;
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 40px;
  line-height: 4rem;
}
.tab-group li + li {
  margin-left: -1px;
}
.tab-group li:first-child {
  margin-left: 0;
  -webkit-border-radius: 20px 0 0 20px;
  -moz-border-radius: 20px 0 0 20px;
  border-radius: 20px 0 0 20px;
}
.tab-group li:last-child {
  -webkit-border-radius: 0 20px 20px 0;
  -moz-border-radius: 0 20px 20px 0;
  border-radius: 0 20px 20px 0;
}
.tab-group li:hover,
.tab-group li:focus,
.tab-group li:active,
.tab-group li.active {
  z-index: 2;
}
.tab-group a {
  padding: 0 40px;
}
@media only screen and (max-width: 767px) {
  .tab-group a {
    padding: 0 20px;
  }
}
.three-col-feature {
  background: #58676e;
}
.three-col-feature.inverse {
  background: #ffffff;
}
.three-col-feature h5 {
  font-size: 30px;
  font-size: 3rem;
  line-height: 32px;
  line-height: 3.2rem;
}
.three-col-feature h6 {
  font-size: 20px;
  font-size: 2rem;
  line-height: 22px;
  line-height: 2.2rem;
}
.three-col-feature .tab-group {
  margin-bottom: 30px;
}
.three-col-feature .tab-group a {
  display: block;
  color: #fff;
}
.three-col-feature .tab-group a:hover {
  text-decoration: none;
}
.three-col-feature .tab-group li {
  background: #435259;
  cursor: pointer;
}
.three-col-feature .tab-group li.active {
  background: #fff;
  cursor: default;
}
.three-col-feature .tab-group li.active a {
  color: #435259;
  cursor: default;
}
.three-col-feature .tab-pane {
  display: none;
}
.three-col-feature .tab-pane.active {
  display: block;
}
.three-col-feature .area {
  background: #6e8089;
  padding: 40px 30px;
  height: 210px;
  position: relative;
  margin-bottom: 20px;
}
.three-col-feature .area .action {
  position: absolute;
  bottom: 0px;
  right: 0px;
  left: 0;
  padding: 5px 20px;
  text-align: right;
  border-top: 1px solid #8ea1a8;
  font-weight: bold;
}
.explore-carousel-wrap {
  overflow: hidden;
  width: 960px;
  margin: 0 auto;
  position: relative;
  margin-top: 50px;
}
.explore-carousel {
  width: 1920px;
  background: #ededed;
  height: 570px;
  position: relative;
  margin: 0;
  padding: 0;
}
.explore-carousel li {
  list-style: none;
  float: left;
}
.explore-carousel-item {
  width: 640px;
  position: absolute;
  top: 0;
}
.explore-carousel-item .pad {
  padding: 70px 45px;
}
.explore-carousel-number {
  display: block;
  margin: 125px 0 40px;
}
.explore-carousel-primary {
  width: 50%;
  height: 570px;
  float: left;
  color: #fff;
  padding: 0;
  font-size: 26px;
  font-size: 2.6rem;
  line-height: 28px;
  line-height: 2.8rem;
  text-transform: uppercase;
  list-style: none;
  overflow: hidden;
  position: relative;
  background-color: #666;
}
.explore-bg {
  display: none;
}
.explore-carousel-secondary {
  width: 50%;
  height: 570px;
  float: left;
  padding: 0;
  list-style: none;
  background: #ededed;
  position: relative;
}
.explore-carousel-item-asset {
  border: 1px solid #666;
  border-left: none;
  border-right: none;
  padding: 10px 0 0;
  width: 75%;
  margin-bottom: 15px;
}
.explore-control-prev {
  position: absolute;
  bottom: 10px;
  left: 10px;
  height: 65px;
  width: 35px;
  display: block;
  background: url("{!$Resource.next_prev_png}") no-repeat left top;
  text-indent: -3000px;
}
.explore-control-next {
  position: absolute;
  bottom: 10px;
  right: 10px;
  height: 65px;
  width: 35px;
  display: block;
  background: url("{!$Resource.next_prev_png}") no-repeat right top;
  text-indent: -3000px;
}
.explore-control-pag {
  text-align: center;
  margin: 10px 0 0;
}
.panel1,
.panel2 {
  display: inline-block;
  *zoom: 1;
  *display: inline;
  height: 12px;
  width: 12px;
  background: url("{!$Resource.next_prev_png}") no-repeat right bottom;
  margin: 0 2px;
  text-indent: -2000px;
  cursor: pointer;
}
.panel1.active,
.panel2.active {
  background: url("{!$Resource.next_prev_png}") no-repeat left bottom;
  cursor: default;
}
.explore-close {
  display: block;
  float: right;
  padding: 7px 10px;
  color: #fff;
  background: #cad1d7;
  font-size: 24px;
  font-size: 2.4rem;
  position: absolute;
  top: 10px;
  right: 10px;
  font-weight: bold;
  z-index: 0;
}
.explore-close:hover {
  text-decoration: none;
  color: #fff;
}
@media (min-width: 1390px) {
  .explore-carousel-wrap {
    overflow: hidden;
    width: 1365px;
    margin: 0 auto;
  }
  .explore-carousel {
    background: #ededed;
    height: 570px;
    position: relative;
  }
  .explore-carousel li {
    list-style: none;
    float: left;
  }
  .explore-carousel-item {
    width: 910px;
    position: absolute;
    top: 0;
  }
  .explore-carousel-item .pad {
    padding: 70px 45px;
  }
}
@media only screen and (min-width: 768px) and (max-width: 991px) {
  .explore-carousel-wrap {
    overflow: hidden;
    width: 724px;
    margin: 0 auto;
  }
  .explore-carousel {
    background: #ededed;
    height: 570px;
    position: relative;
  }
  .explore-carousel li {
    list-style: none;
    float: left;
  }
  .explore-carousel-item {
    width: 482px;
    position: absolute;
    top: 0;
  }
  .explore-carousel-item .pad {
    padding: 70px 45px;
  }
}
@media only screen and (max-width: 767px) {
  .explore-carousel-wrap,
  .explore-carousel {
    width: auto;
    height: auto;
  }
  .explore-carousel-item {
    width: 100%;
    position: static;
  }
  .explore-carousel-item .pad {
    padding: 70px 45px;
  }
  .explore-carousel-primary {
    background: #ededed!important;
    color: #333;
  }
  .explore-carousel-primary .pad {
    padding: 0 40px;
  }
  .explore-carousel-primary .explore-carousel-number {
    margin-top: 0;
  }
  .explore-carousel-primary,
  .explore-carousel-secondary {
    width: auto;
    height: auto;
    float: none;
  }
  .explore-control-prev,
  .explore-control-next,
  .explore-control-pag {
    display: none;
  }
}
/* button start */
.button {
  background-color: #e05206;
  background-image: -webkit-linear-gradient(#e98300, #e05206, #e98300);
  background-image: -moz-linear-gradient(#e98300, #e05206, #e98300);
  background-image: -o-linear-gradient(#e98300, #e05206, #e98300);
  background-image: -ms-linear-gradient(#e98300, #e05206, #e98300);
  background-image: linear-gradient(#e98300, #e05206, #e98300);
  background: #e98300;
  background: -webkit-gradient(linear, left bottom, left top, color-stop(0, #e05206), color-stop(1, #e98300));
  background: -ms-linear-gradient(bottom, #e05206, #e98300);
  background: -moz-linear-gradient(center bottom, #e05206 0%, #e98300 100%);
  background: -o-linear-gradient(#e98300, #e05206);
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#e98300', endColorstr='#e05206', GradientType=0);
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 40px;
  line-height: 4rem;
  color: #ffffff;
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  border-radius: 5px;
  padding: 0 12px;
  white-space: nowrap;
  text-decoration: none;
  margin: 0 10px 10px 0;
  display: inline-block;
  *zoom: 1;
  *display: inline;
  cursor: pointer;
}
.button span {
  padding: 0 25px 0 0;
  background: url(img/arrow-rt-white.png) no-repeat right center;
  letter-spacing: -1px;
  display: inline-block;
  *zoom: 1;
  *display: inline;
}
.button:last-child {
  margin-right: 0;
}
.button:hover,
.button:focus {
  background: #e05206;
  text-decoration: none;
  color: #ffffff;
}
.button.small {
  line-height: 32px;
  line-height: 3.2rem;
  margin-left: 10px;
  position: relative;
  top: -2px;
}
.button-action {
  font-size: 16px;
  font-size: 1.6rem;
  padding: 15px 20px;
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  border-radius: 5px;
  color: #333333;
  border: 1px solid #333333;
  display: inline-block;
  *zoom: 1;
  *display: inline;
}
.button-action.light {
  color: #ffffff;
  border: 1px solid #ffffff;
}
.button-action.small {
  font-size: 12px;
  font-size: 1.2rem;
  padding: 10px 15px;
  font-weight: bold;
}
/* button start */
/* dotted lines start */
.dotted-top {
  background: url(img/bdr-dotted.png) repeat-x center top;
}
.dotted-right {
  background: url(img/bdr-dotted.png) repeat-y right top;
}
.dotted-right > * {
  padding-right: 20px;
}
.dotted-bottom {
  background: url(img/bdr-dotted.png) repeat-x center bottom;
}
.dotted-left {
  background: url(img/bdr-dotted.png) repeat-y left top;
}
/* dotted lines end */
/* tab menu start */
.menu-tabs {
  overflow: hidden;
  margin: 0 0 15px;
  min-height: 40px;
  padding: 0;
  background: url(img/bdr-dotted.png) repeat-x center top;
  list-style: none;
}
.menu-tab {
  float: left;
  margin: 0;
  padding: 0 !important;
}
.menu-tab-item,
.menu-tab-item:link {
  display: block;
  padding: 10px 15px;
  text-decoration: none;
  font-size: 14px;
  font-size: 1.4rem;
  line-height: 14px;
  line-height: 1.4rem;
  color: #444444;
}
.menu-tab.active .menu-tab-item {
  background-color: #00b0ca;
  background-image: -webkit-linear-gradient(top, #00b0ca, #0064af);
  background-image: -moz-linear-gradient(top, #00b0ca, #0064af);
  background-image: -o-linear-gradient(top, #00b0ca, #0064af);
  background-image: -ms-linear-gradient(top, #00b0ca, #0064af);
  background-image: linear-gradient(top, #00b0ca, #0064af);
  background: top;
  background: -webkit-gradient(linear, left bottom, left top, color-stop(0, #00b0ca), color-stop(1, #0064af));
  background: -ms-linear-gradient(bottom, #00b0ca, #0064af);
  background: -moz-linear-gradient(center bottom, #00b0ca 0%, #0064af 100%);
  background: -o-linear-gradient(#0064af, #00b0ca);
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#0064af', endColorstr='#00b0ca', GradientType=0);
  color: #ffffff;
  text-decoration: none;
  -ms-zoom: 1;
  zoom: 1;
}
.menu-tab-item:hover {
  color: #00b0ca;
}
/* tab menu end */
/* upper-menu start */
.tools {
  display: block;
  float: left;
  text-decoration: none;
  color: #00b0ca;
  background-image: url(img/icns-tools.png);
  background-repeat: no-repeat;
  background-position: 0 0;
  line-height: 30px;
  padding-left: 25px;
  text-transform: uppercase;
}
.tools.phone {
  background-position: 0 4px;
}
.tools.call-me {
  background-position: 0 -29px;
}
.tools.chat {
  background-position: 0 -60px;
}
.tools.email {
  background-position: 0 -91px;
  padding-left: 30px;
}
.tools.share {
  background-position: 0 -120px;
}
.tools.contact {
  background: none;
  padding-left: 0;
  display: inline-block !important;
}
.upper-tools {
  margin: -50px 0 20px;
}
.lower-tools {
  margin: 20px 0 -20px;
}
.upper-tools img,
.lower-tools img {
  max-width: none;
}
.tools:hover {
  color: #00b0ca;
}
.visible-phone.inline {
  display: inline-block !important;
}
/* upper-menu end */
/* documents and resources start */
.document {
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
  display: block;
  margin: 0 0 20px 12px;
  padding: 8px 0 0 40px;
  text-transform: uppercase;
  text-decoration: none;
  cursor: pointer;
  color: #00b0ca;
  position: relative;
  width: 36%;
}
.document .icon,
.resource .icon {
  position: absolute;
  top: 0;
  left: 0;
  overflow: hidden;
  padding: 0;
}
/* documents end */
.resource {
  position: relative;
}
.resource dt,
.resource dd {
  padding: 0 0 0 40px;
  margin: 0;
}
.rr-list li {
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
  border-radius: 5px;
  font-size: 22px;
  font-size: 2.2rem;
  line-height: 22px;
  line-height: 2.2rem;
  background-color: #dfdfdf;
}
.rr-list li a,
.rr-list li a:hover {
  color: #0064af;
}
.more-items {
  margin-top: 20px;
  margin-left: -20px !important;
}
.more-items li {
  padding-bottom: 10px;
}
.drop-search {
  background: #ffffff;
  position: absolute;
  right: 0;
  border: 1px solid #c2d1d4;
  padding: 0 10px;
  top: 84px;
  display: none;
  overflow: hidden;
}
.drop-search div {
  margin-top: -2px;
  padding: 5px 0;
}
#videos {
  -ms-word-wrap: break-word;
  word-wrap: break-word;
}
#creditfooter {
  display: none;
}
/* text colors */
.darkblue,
.darkblue:hover {
  color: #02076a;
}
.blue,
.blue:hover {
  color: #0064af;
}
.green,
.green:hover {
  color: #14aa13;
}
.cool-gray,
.cool-gray:hover {
  color: #444444;
}
.white,
.white:hover {
  color: #ffffff;
}
.light-gray,
.light-gray:hover {
  color: #c2d1d4;
}
/* Left Navigation */
.left-nav {
  padding: 0;
  margin: 35px 10px 0 -10px;
  list-style: none;
}
.left-nav a {
  text-decoration: none;
}
.left-nav a:hover {
  color: #00b0ca;
}
.left-nav ul {
  padding: 0;
  margin: 0;
  list-style: none;
}
.left-nav ul > li {
  margin: 0;
  padding: 0;
}
.left-nav > li a {
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 18px;
  line-height: 1.8rem;
  color: #333333;
  padding: 0 0 10px 10px;
  display: block;
}
.l2 > li a {
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
  color: #333333;
  padding: 10px 0 10px 10px;
  background: url("{!$Resource.bdr_dotted_png}") repeat-x left top;
  display: block;
}
.l3 > li a,
.l3 > li span {
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
  color: #333333;
  padding: 10px 0 10px 20px;
  background: none;
}
li.on a,
li.on span {
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
  color: #fff;
  background-color: #00b0ca;
  background-image: -webkit-linear-gradient(#0064af, #00b0ca, #0064af);
  background-image: -moz-linear-gradient(#0064af, #00b0ca, #0064af);
  background-image: -o-linear-gradient(#0064af, #00b0ca, #0064af);
  background-image: -ms-linear-gradient(#0064af, #00b0ca, #0064af);
  background-image: linear-gradient(#0064af, #00b0ca, #0064af);
  background: #0064af;
  background: -webkit-gradient(linear, left bottom, left top, color-stop(0, #00b0ca), color-stop(1, #0064af));
  background: -ms-linear-gradient(bottom, #00b0ca, #0064af);
  background: -moz-linear-gradient(center bottom, #00b0ca 0%, #0064af 100%);
  background: -o-linear-gradient(#0064af, #00b0ca);
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#0064af', endColorstr='#00b0ca', GradientType=0);
  text-decoration: none;
  display: block;
}
.controller {
  background: url("{!$Resource.arrows_png}") 0px -180px no-repeat;
  display: block;
  width: 12px;
  height: 17px;
  cursor: pointer;
  top: -25px;
  position: relative;
  margin: 0 0 -22px;
  float: right;
}
.ctrl-on {
  background: url("{!$Resource.arrows_png}") 0 -212px no-repeat;
}
.controller.hover {
  background: url("{!$Resource.arrows_png}") 0 -180px no-repeat;
}
.ctrl-on.hover {
  background: url("{!$Resource.arrows_png}") 0 -212px no-repeat;
}
.section-gradient1 {
  background: url("{!$Resource.bg_gradient1_jpg}") repeat-x top center #f2f2f2;
  padding-bottom: 15px;
}
.section-gradient2 {
  background: url("{!$Resource.bg_gradient2_jpg}") repeat-x top center #cad1d7;
  padding: 30px 0 10px;
  margin-bottom: 30px;
}
.section-gradient2 h5 {
  font-size: 22px;
  font-size: 2.2rem;
}
.section-gradient3 {
  background: url("{!$Resource.gradient_to_trans_png}") repeat-x top center #ffffff;
  padding: 30px 0 0;
}
/* #Additional Helpers
================================================== */
.img-responsive {
  display: inline-block;
  height: auto;
  max-width: 100%;
}
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
}
.pull-clear {
  clear: both;
}
.nowrap {
  white-space: nowrap;
}
.modal-body {
  height: auto;
  max-height: 3000px;
  padding: 0;
  overflow: hidden;
}
.modal {
  background: #333333;
  overflow: hidden;
  width: 700px;
  margin-left: -350px;
  border: none;
  -webkit-border-radius: 0px;
  -moz-border-radius: 0px;
  border-radius: 0px;
  -webkit-box-shadow: 0 0 0 rgba(0, 0, 0, 0);
  -moz-box-shadow: 0 0 0 rgba(0, 0, 0, 0);
  box-shadow: 0 0 0 rgba(0, 0, 0, 0);
}
#BCLcontainingBlock {
  width: 100%;
  margin: 0;
}
.BCLvideoWrapper {
  height: 405px;
  position: relative;
}
.modal .close {
  color: #ffffff;
  position: absolute;
  right: 5px;
  top: 5px;
  -moz-opacity: 0.9;
  -khtml-opacity: 0.9;
  -webkit-opacity: 0.9;
  opacity: 0.9;
  -ms-filter: progid:DXImageTransform.Microsoft.Alpha(opacity=90);
  filter: alpha(opacity=90);
  z-index: 99;
  -webkit-text-shadow: none;
  text-shadow: none;
}
.lpPoweredBy,
.lpEmtStarRating {
  display: none;
}
.login-overlay {
  padding: 10px 0 !important;
  width: 980px !important;
  height: 310px !important;
  display: none;
  margin-left: -490px !important;
}
.login-overlay .close {
  color: #333333;
  position: absolute;
  right: 10px;
  top: 15px;
  -moz-opacity: 0.9;
  -khtml-opacity: 0.9;
  -webkit-opacity: 0.9;
  opacity: 0.9;
  -ms-filter: progid:DXImageTransform.Microsoft.Alpha(opacity=90);
  filter: alpha(opacity=90);
  z-index: 99;
  -webkit-text-shadow: none;
  text-shadow: none;
}
.print-only {
  display: none;
}
.brightcove-area {
  max-width: 780px;
}
.brightcove-wrap {
  position: relative;
  padding-bottom: 56%;
  height: 0;
}
.brightcove-wrap div,
.brightcove-wrap embed,
.brightcove-wrap object,
.BrightcoveExperience {
  position: absolute;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
}
.flitem {
  position: relative;
}
.flitem input {
  width: 100%;
  padding: 4px 0;
  text-indent: 10px;
  *text-indent: 5px;
}
.flitem select {
  width: 100%;
  *position: relative;
  *left: 5px;
}
.frequired {
  display: none;
}
.formitemname {
  position: absolute;
  top: 5px;
  left: 10px;
  *left: 10px;
}
.small-text {
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 15px;
  line-height: 1.5rem;
}
/* #Module Styles
================================================== */
/* main carousel - start */
.mc-slides-wrap {
  position: relative;
}
.mc-slides-wrap h1 {
  font-size: 38px;
  font-size: 3.8rem;
  line-height: 3.8rem;
}
.mc-slides-wrap h5 {
  font-size: 24px;
  font-size: 2.4rem;
}
.mc-slides {
  position: relative;
  list-style: none;
  overflow: hidden;
  width: 100%;
  padding: 0;
  margin: 0;
  background: #333;
  height: 600px;
}
.mc-slides.disabled {
  overflow: auto;
  height: auto;
}
.mc-slides .mc-slide {
  -webkit-backface-visibility: hidden;
  position: absolute;
  display: none;
  width: 100%;
  left: 0;
  top: 0;
  height: 425px;
  background-repeat: no-repeat;
  background-position: top center;
  padding-top: 175px;
}
.mc-slides .mc-slide:first-child {
  position: relative;
  display: block;
  float: left;
}
.mc-slides.disabled .mc-slide {
  position: static;
  display: block;
  float: none;
}
.mc_nav {
  width: 36px;
  height: 66px;
  text-indent: -3000px;
  display: block;
  position: absolute;
  top: 266px;
  z-index: 5;
  display: none;
}
.mc_tabs {
  margin: -475px auto 455px;
  z-index: 4;
  width: 960px;
  text-align: right;
  position: relative;
}
.mc_tabs li {
  display: inline-block;
  *zoom: 1;
  *display: inline;
  height: 12px;
  width: 12px;
  margin-left: 8px;
  list-style: none;
}
.mc_tabs li a {
  display: inline-block;
  height: 12px;
  width: 12px;
  font-size: 0;
  background: url("{!$Resource.next_prev_png}") no-repeat bottom right;
}
.mc_here a {
  background: url("{!$Resource.next_prev_png}") no-repeat bottom left !important;
}
.mc_nav.next {
  background: url("{!$Resource.next_prev_png}") no-repeat right top;
  right: 15px;
}
.mc_nav.prev {
  background: url("{!$Resource.next_prev_png}") no-repeat left top;
  left: 15px;
}
.drawer-toggle {
  display: none;
  width: 140px;
  height: 25px;
  margin: 0 0 0 -70px;
  background: url("{!$Resource.carrot_down_sm_png}") no-repeat center center #cad1d7;
  z-index: 4;
  position: relative;
  bottom: -30px;
  left: 50%;
  -webkit-border-radius: 2px;
  -moz-border-radius: 2px;
  border-radius: 2px;
  text-indent: -3000px;
}
.drawer-toggle.opened {
  display: block;
  width: 140px;
  height: 25px;
  margin: 0 0 0 -70px;
  background: url("{!$Resource.carrot_up_sm_png}") no-repeat center center #ffffff;
  z-index: 4;
  position: relative;
  bottom: -12px;
  left: 50%;
}
/* main feature - start */
.main-feature-background {
  background-position: center center;
  background-repeat: no-repeat;
  -webkit-background-size: auto 100%;
  -moz-background-size: auto 100%;
  -o-background-size: auto 100%;
  background-size: auto 100%;
  padding: 30px 0;
  margin-bottom: 30px;
}
.main-feature-background .text-center,
.sub-feature-background .text-center {
  margin: 0 15%;
}
.main-feature-background h1 {
  margin-bottom: 20px;
}
.main-feature-background h5 {
  margin-bottom: 20px;
}
.alignment-right {
  text-align: right;
}
.alignment-left {
  text-align: left;
}
.main-feature-background .alignment-right h1 {
  margin-bottom: 20px;
}
.main-feature-background .alignment-right h5 {
  margin-bottom: 20px;
}
.main-feature-background .alignment-left {
  margin-right: 47%;
  margin-left: 3%;
}
.main-feature-background .alignment-left h1 {
  margin-bottom: 20px;
}
.main-feature-background .alignment-left h5 {
  margin-bottom: 20px;
}
.main-feature-background .standard {
  font-size: 20px;
  font-size: 2rem;
  color: #00b0ca;
  text-decoration: underline;
}
.main-feature-background .standard:hover {
  text-decoration: underline;
}
/* main feature - end */
/*Quarters*/
.quarters {
  width: 100%;
  max-width: 1360px;
  margin: 0 auto;
  overflow: hidden;
  text-align: center;
  border-bottom: 1px solid #ffffff;
}
.quarter {
  width: 25%;
  height: 340px;
  float: left;
  background-position: center center;
  background-repeat: no-repeat;
  position: relative;
  color: #ffffff;
  list-style: none;
}
.q-action {
  color: #ffffff;
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  -webkit-transition: all 0.2s linear;
  -moz-transition: all 0.2s linear;
  -o-transition: all 0.2s linear;
  -ms-transition: all 0.2s linear;
  transition: all 0.2s linear;
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 26px;
  line-height: 2.6rem;
  padding: 0 15%;
}
.q-action:hover {
  color: #ffffff;
  text-decoration: none;
  background-image: url();
  background-color: rgba(0, 0, 0, 0.3);
}
.q-title {
  color: #ffffff;
  font-size: 36px;
  font-size: 3.6rem;
  line-height: 36px;
  line-height: 3.6rem;
  display: block;
  margin: 100px 0 20px;
}
.c-quote-area {
  background: #e2e2e2;
}
.c-quotes {
  background: #ffffff;
  padding: 20px;
  margin: 30px 0;
  cursor: pointer;
}
.c-quote {
  display: none;
}
.c-quote:first-child {
  display: block;
}
.c-item {
  position: relative;
  padding: 20px 150px;
  font-size: 16px;
  font-size: 1.6rem;
  line-height: 21px;
  line-height: 2.1rem;
}
.quote-open {
  position: absolute;
  top: 0;
  left: 0;
}
.quote-close {
  position: absolute;
  top: 0;
  right: 0;
}
.quote-open,
.quote-close {
  color: #e2e2e2;
  font-size: 280px;
  font-size: 28rem;
  display: block;
  height: 0px;
  padding-top: 100px;
}
.highlightarea {
  font-size: 21px;
  font-size: 2.1rem;
  line-height: 32px;
  line-height: 3.2rem;
  margin-top: 20px;
  margin-bottom: 10px;
}
.highlightarea span {
  color: #333333;
  text-transform: uppercase;
}
.highlightarea-title {
  font-size: 50px;
  font-size: 5rem;
  line-height: 50px;
  line-height: 5rem;
  color: #333333;
}
.banner {
  font-size: 60px;
  font-size: 6rem;
  line-height: 64px;
  line-height: 6.4rem;
  padding: 113px 0 113px;
  color: #fff;
  background: #fff;
  background-position: center center;
  background-repeat: no-repeat;
  text-shadow: 2px 2px 20px #333333;
}
.banner2 {
  height: 250px;
  padding: 110px 0 50px;
  margin-bottom: 40px;
  color: #fff;
  background: #fff;
  background-position: center center;
  background-repeat: no-repeat;
  text-shadow: 2px 2px 20px #333;
  position: relative;
}
.banner2 h1 {
  font-size: 60px;
  font-size: 6rem;
  line-height: 60px;
  line-height: 6rem;
  color: #ffffff;
}
.banner2 h2 {
  font-size: 29px;
  font-size: 2.9rem;
  line-height: 30px;
  line-height: 3rem;
  color: #ffffff;
}
.banner2 .anchor {
  position: absolute;
  left: 50%;
  margin-left: -65px;
  bottom: 20px;
}
/* Phone Portriat and Landscape */
@media only screen and (max-width: 767px) {
  .banner2 {
    height: auto;
    padding: 100px 0;
  }
}
.view-more {
  padding: 10px 10px 30px;
  display: inline-block;
  font-size: 14px;
  font-size: 1.4rem;
  background: url("{!$Resource.caret_down_png}") no-repeat center bottom;
}
.view-more.white {
  background: url("{!$Resource.caret_down_white_png}") no-repeat center bottom;
}
#pfilters {
  margin-top: 80px;
  z-index: 1;
  position: relative;
}
.pfilters {
  border: 1px solid #333;
  z-index: 1;
  position: relative;
  margin-bottom: 30px;
}
.pfilter {
  border-right: 1px solid #333;
  width: 33%;
  float: left;
  position: relative;
}
.pfilter span,
#pfilter-clear {
  display: block;
  padding: 15px 25px;
  cursor: pointer;
}
.pfilter span {
  background: url("{!$Resource.caret_down_sm_png}") no-repeat 95% center;
}
.pfilter-dropdown {
  position: absolute;
  left: -1px;
  right: -1px;
  background: #fff;
  border: 1px solid #333;
  padding: 20px 20px 0 20px;
  display: none;
  -webkit-box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.1);
  -moz-box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.1);
  box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.1);
}
.pfilter-dropdown a {
  margin-bottom: 17px;
  color: #333333;
  display: block;
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 14px;
  line-height: 1.4rem;
}
.pfilter-item {
  width: 298px;
  height: 353px;
  float: left;
  margin: 0 0 20px 20px;
  border: 1px solid #848484;
  list-style: none;
  position: relative;
  -webkit-box-shadow: 0px 1px 1px rgba(0, 0, 0, 0.1);
  -moz-box-shadow: 0px 1px 1px rgba(0, 0, 0, 0.1);
  box-shadow: 0px 1px 1px rgba(0, 0, 0, 0.1);
  z-index: 1;
}
.pfilter-item.featured {
  height: 300px;
}
.pfilter-center {
  position: absolute;
  top: -1px;
  left: -1px;
  right: -1px;
  padding: 5px 20px;
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 13px;
  line-height: 1.3rem;
  color: #fff;
  background: #58676d;
  min-height: 13px;
}
.pfilter-cat {
  position: absolute;
  top: 45px;
  left: 20px;
  right: 20px;
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 13px;
  line-height: 1.3rem;
  color: #666;
}
.pfilter-title {
  position: absolute;
  top: 80px;
  left: 20px;
  right: 20px;
  font-size: 24px;
  font-size: 2.4rem;
  line-height: 26px;
  line-height: 2.6rem;
}
.pfilter-title.featured {
  font-size: 45px;
  font-size: 4.5rem;
  line-height: 40px;
  line-height: 4rem;
  max-width: 510px;
}
.pfilter-desc {
  position: absolute;
  top: 185px;
  left: 20px;
  right: 20px;
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
  color: #666;
}
.pfilter-desc.featured {
  font-size: 20px;
  font-size: 2rem;
  line-height: 22px;
  line-height: 2.2rem;
  font-family: 'CA Sans Web', Verdana, Geneva, 'DejaVu Sans', sans-serif;
  top: 160px;
  max-width: 510px;
}
.pfilter-plat {
  position: absolute;
  top: 265px;
  left: 20px;
  right: 20px;
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 13px;
  line-height: 1.3rem;
  background: #d8d8d8;
  padding: 10px;
}
.pfilter-plat.featured {
  max-width: 360px;
  top: 245px;
}
.pfilter-plat-label {
  text-transform: uppercase;
}
.pfilter-link {
  position: absolute;
  bottom: 18px;
  right: 20px;
  margin: 0;
  font-size: 14px;
  font-size: 1.4rem;
}
.pfilter-link a {
  color: #333333;
}
.pfilter-link a:hover {
  color: #00b0ca;
}
.pfilter-link.featured {
  bottom: 28px;
  left: 425px;
}
.pfilter-image {
  margin: 40px 20px;
  height: 240px;
}
.pfilter-plat-items {
  overflow: hidden;
  padding-left: 10px;
  display: block;
}
.load-more {
  height: 41px;
  background: url("{!$Resource.caret_down_png}") no-repeat center bottom #ffffff;
  text-align: center;
  list-style: none;
  padding-top: 20px;
  cursor: pointer;
  clear: both;
}
.intellicenter {
  background: #76417c;
}
.opscenter {
  background: #2a7a6e;
}
.devcenter {
  background: #397e97;
}
.securecenter {
  background: #ae5b0f;
}
#results,
#pfilter-featured {
  margin-left: -20px;
  position: relative;
  z-index: 0;
  overflow: hidden;
}
.pfilter-featured .pfilter-item {
  float: none;
  width: auto;
}
#pfilter-area {
  text-transform: capitalize;
}
.valid.more {
  display: none;
}
@media only screen and (min-width: 768px) and (max-width: 991px) {
  .pfilter-item {
    width: 229px;
    margin: 0 0 15px 15px;
  }
  .pfilter-title {
    font-size: 22px;
    font-size: 2.2rem;
    line-height: 22px;
    line-height: 2.2rem;
  }
  .pfilter-title.featured {
    font-size: 32px;
    font-size: 3.2rem;
    line-height: 32px;
    line-height: 3.2rem;
    max-width: 430px;
  }
  .pfilter-desc.featured {
    font-size: 20px;
    font-size: 2rem;
    line-height: 26px;
    line-height: 2.6rem;
    max-width: 430px;
  }
  .pfilter-plat.featured {
    max-width: 530px;
    top: 245px;
  }
  .pfilter-link.featured {
    bottom: 28px;
    left: 580px;
    text-align: right;
  }
  .pfilter-image {
    margin: 40px 20px;
    height: 200px;
  }
}
/* Phone Portriat and Landscape */
@media only screen and (max-width: 767px) {
  .pfilter-item {
    width: 90%;
    margin: 0 0 20px;
    height: auto;
    overflow: hidden;
    padding: 20px;
  }
  .pfilter-item.featured {
    height: auto;
  }
  .pfilter-cat {
    position: static;
    margin-top: 20px;
  }
  .pfilter-title {
    position: static;
  }
  .pfilter-title.featured {
    font-size: 30px;
    font-size: 3rem;
    line-height: 30px;
    line-height: 3rem;
  }
  #results,
  #pfilter-featured {
    margin-left: 0;
  }
  .pfilter span,
  #pfilter-clear {
    display: block;
    padding: 10px 10px;
    font-size: 12px;
    font-size: 1.2rem;
  }
  #pfilter-clear {
    text-align: center;
  }
  .pfilter-dropdown {
    width: 398px;
  }
  .pfilter-plat {
    position: static;
  }
  .pfilter-plat.featured {
    top: 210px;
    max-width: none;
  }
  .pfilter-link {
    position: static;
    text-align: right;
  }
  #pfilter-plat {
    position: static;
  }
}
@media (max-width: 380px) {
  .pfilter-dropdown {
    width: 238px;
  }
}
.back-to-top {
  display: none;
  position: fixed;
  bottom: 0;
  right: 30px;
  height: 30px;
  width: 40px;
  -webkit-border-radius: 10px 10px 0 0;
  -moz-border-radius: 10px 10px 0 0;
  border-radius: 10px 10px 0 0;
  background: url("{!$Resource.back_to_top_png}") no-repeat center center #ffffff;
  -webkit-box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.2);
  box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.2);
}
/* multi features start */
.multi-feature {
  background: #ffffff;
  -webkit-box-shadow: 0px 3px 5px rgba(0, 0, 0, 0.5);
  -moz-box-shadow: 0px 3px 5px rgba(0, 0, 0, 0.5);
  box-shadow: 0px 3px 5px rgba(0, 0, 0, 0.5);
  margin-top: -30px;
  z-index: 4;
  position: relative;
  padding: 10px 20px;
}
.multi-feature a {
  color: #333;
  display: block;
}
.multi-feature a:hover {
  color: #00b0ca;
}
/* multi features end */
/* mosaic start */
.mosaic-c {
  min-height: 310px;
  -webkit-background-size: 100% auto;
  -moz-background-size: 100% auto;
  -o-background-size: 100% auto;
  background-size: 100% auto;
}
.mosaic-c1 {
  overflow: hidden;
  width: 295px;
  height: 339px;
  -webkit-background-size: auto 100%;
  -moz-background-size: auto 100%;
  -o-background-size: auto 100%;
  background-size: auto 100%;
  background-color: #00b0ca;
  background-repeat: no-repeat;
  float: left;
  margin-right: 20px;
}
.mosaic-c1v2 {
  overflow: hidden;
  width: 100%;
  height: auto;
  min-height: 195px;
  -webkit-background-size: auto 100%;
  -moz-background-size: auto 100%;
  -o-background-size: auto 100%;
  background-size: auto 100%;
  background-image: url("{!$Resource.gradient_blue_jpg}");
  background-repeat: no-repeat;
  background-color: #00b0ca;
  float: left;
  margin-right: 20px;
}
.mosaic-c2 {
  width: 245px;
  height: 339px;
  float: left;
  margin-right: 20px;
}
.mosaic-c2-item {
  overflow: hidden;
  width: 245px;
  height: 159px;
  background-color: #00b0ca;
  -webkit-background-size: 100% auto;
  -moz-background-size: 100% auto;
  -o-background-size: 100% auto;
  background-size: 100% auto;
}
.mosaic-c3 {
  width: 360px;
  height: 339px;
  float: left;
}
.mosaic-c3-top {
  overflow: hidden;
  background-color: #00b0ca;
  width: 360px;
  height: 234px;
}
.mosaic-c3-white-top {
  overflow: hidden;
  background-color: #ffffff;
  width: 360px;
  height: 234px;
}
.mosaic-c3-bottom {
  overflow: hidden;
  -webkit-background-size: 100% auto;
  -moz-background-size: 100% auto;
  -o-background-size: 100% auto;
  background-size: 100% auto;
  background-image: url("{!$Resource.gradient_blue_jpg}");
  background-repeat: no-repeat;
  background-color: #00b0ca;
  width: 360px;
  height: 84px;
}
.mosaic-c3-bottom .cta2 {
  padding: 11px 20px 20px 40px;
  background: url("{!$Resource.arrows_png}") no-repeat -95px -50px;
}
/* mosaic end */
/* two-thirds mosaic start */
.mosaic-2-3-one {
  width: 245px;
  float: left;
  margin-right: 10px;
}
.mosaic-2-3-one-top {
  width: 245px;
  height: 159px;
  background: #00b0ca;
  overflow: hidden;
}
.mosaic-2-3-one-bottom {
  width: 245px;
  height: 159px;
  background: #00b0ca;
  overflow: hidden;
}
.mosaic-2-3-two {
  width: 360px;
  float: left;
}
.mosaic-2-3-two-top {
  width: 360px;
  height: 234px;
  overflow: hidden;
  background: #00b0ca;
}
.mosaic-2-3-two-bottom {
  width: 360px;
  height: 84px;
  -webkit-background-size: 100% auto;
  -moz-background-size: 100% auto;
  -o-background-size: 100% auto;
  background-size: 100% auto;
  background-image: url("{!$Resource.gradient_blue_jpg}");
  background-repeat: no-repeat;
  background-color: #00b0ca;
}
.mosaic-2-3-two-bottom .cta2 {
  padding: 11px 20px 20px 40px;
  background: url("{!$Resource.arrows_png}") no-repeat -95px -50px;
}
/* two-thirds mosaic end */
.ss-features {
  background: #ffffff;
  padding: 20px 0;
}
.ss-features li {
  margin-bottom: 10px;
  max-width: 45%;
  position: relative;
}
.ss-features a img {
  -moz-opacity: 1;
  -khtml-opacity: 1;
  -webkit-opacity: 1;
  opacity: 1;
  -ms-filter: progid:DXImageTransform.Microsoft.Alpha(opacity=100);
  filter: alpha(opacity=100);
  -webkit-transition: all 0.2s linear;
  -moz-transition: all 0.2s linear;
  -o-transition: all 0.2s linear;
  -ms-transition: all 0.2s linear;
  transition: all 0.2s linear;
}
.ss-features a:hover img,
.ss-features a:active img {
  -moz-opacity: 0.4;
  -khtml-opacity: 0.4;
  -webkit-opacity: 0.4;
  opacity: 0.4;
  -ms-filter: progid:DXImageTransform.Microsoft.Alpha(opacity=40);
  filter: alpha(opacity=40);
  -webkit-transition: all 0.2s linear;
  -moz-transition: all 0.2s linear;
  -o-transition: all 0.2s linear;
  -ms-transition: all 0.2s linear;
  transition: all 0.2s linear;
}
.lt-ie9 .grayscale {
  background: #fff;
}
.region-text {
  color: #666;
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 14px;
  line-height: 1.4rem;
  margin-top: -20px;
}
.region-text span {
  font-size: 17px;
  font-size: 1.7rem;
  line-height: 20px;
  line-height: 2rem;
  color: #0064af;
}
/* callout start */
.callout-outer {
  padding: 20px 0;
}
.callout-inner {
  background-color: #ffffff;
  background-color: rgba(255, 255, 255, 0.8);
  padding: 1px 10px;
  width: 70%;
}
.lt-ie9 .callout-inner {
  -ms-zoom: 1;
  zoom: 1;
  background-color: transparent\9;
  -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#ccffffff, endColorstr=#ccffffff)";
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#ccffffff, endColorstr=#ccffffff);
}
/* callout end */
/* numbers to know start */
.ntk {
  background: #00b0ca;
  font-size: 15px;
  font-size: 1.5rem;
  line-height: 25px;
  line-height: 2.5rem;
  padding: 15px;
  color: #ffffff;
  min-height: 298px;
}
.ntk .large {
  font-size: 20px;
  font-size: 2rem;
}
.ntk a {
  color: #ffffff;
  text-decoration: none;
}
.ntk a:hover,
.ntk a:active {
  color: #ffffff;
  text-decoration: underline;
}
/* numbers to know end */
.popover {
  z-index: 9;
}
.careers-search-area {
  margin: 37px 0 0;
  overflow: hidden;
}
input[type="text"].search-box {
  -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  border: 0;
  font-size: 12px;
  font-size: 1.2rem;
  padding: 7px 10px;
  background: #fff;
  font-weight: bold;
  -webkit-border-radius: 0px;
  -moz-border-radius: 0px;
  border-radius: 0px;
  line-height: normal;
  height: auto;
}
.no-boxshadow input[type="text"].search-box {
  border: 1px solid #c2d1d4;
}
.careers-search {
  width: 185px;
}
.careers-location {
  width: 125px;
}
.careers-btn {
  background: url("{!$Resource.btn_search_gray_gif}") no-repeat;
  height: 30px;
  width: 42px;
  display: inline-block;
  margin: -10px 0 0 5px;
  vertical-align: middle;
  font-size: 0;
  text-indent: 2000px;
  text-decoration: none;
}
.no-boxshadow .search-box {
  border: 1px solid #c2d1d4;
}
.marb27 {
  margin-bottom: 27px;
}
.top-fullwidth-color {
  background: url("{!$Resource.shaded_top_png}") no-repeat #00b0ca;
  -moz-background-size: 100% 100%;
  -o-background-size: 100% 100%;
  -webkit-background-size: 100% 100%;
  background-size: 100% 100%;
  padding: 20px 0;
  margin: 0;
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 18px;
  line-height: 1.8rem;
}
.type-assist {
  background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyBpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBXaW5kb3dzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjBFQTk1NTUyQUVDRDExRTM4N0ExQTlBQjBCNkZEMEJEIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjBFQTk1NTUzQUVDRDExRTM4N0ExQTlBQjBCNkZEMEJEIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MEVBOTU1NTBBRUNEMTFFMzg3QTFBOUFCMEI2RkQwQkQiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MEVBOTU1NTFBRUNEMTFFMzg3QTFBOUFCMEI2RkQwQkQiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7hXJ2WAAAAEElEQVR42mL4//9/A0CAAQAJfAN+6DKEMgAAAABJRU5ErkJggg==);
  background: rgba(255, 255, 255, 0.5);
  padding: 10px;
  position: relative;
  margin-bottom: 30px;
  width: 105%;
}
.ta {
  position: relative;
  margin-bottom: 10px;
}
.type-assist .custom-combobox,
.ta .custom-combobox {
  display: block;
  border: 1px solid #ccc;
  *height: 30px;
  *overflow: hidden;
  padding: 0;
}
.type-assist .custom-combobox-input,
.ta .custom-combobox-input {
  line-height: 30px;
  display: block;
  width: 100%;
  padding: 0;
  text-indent: 10px;
  height: 30px;
  *height: 31px;
  border-width: 0;
  margin: 0;
  *margin-top: -2px;
}
.type-assist .combobox-toggle,
.ta .combobox-toggle {
  height: 30px;
  width: 30px;
  background: url("{!$Resource.down_arrow_png}") no-repeat center center #e05206;
  position: absolute;
  top: 11px;
  right: 11px;
  display: block;
  cursor: pointer;
}
.ta .combobox-toggle {
  top: 1px;
  right: 1px;
}
.type-assist .ui-helper-hidden-accessible,
.ta .ui-helper-hidden-accessible {
  display: none;
}
.ui-autocomplete {
  background: #ffffff;
  margin: 0;
  padding: 5px;
  max-width: 600px;
  border: 1px solid #dfdfdf;
  -webkit-box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.4);
  -moz-box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.4);
  box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.4);
}
.ui-autocomplete li {
  list-style: none;
  padding: 0;
  margin: 0;
}
.ui-menu-item {
  cursor: pointer;
}
.time-right {
  overflow: hidden;
  display: block;
  padding-left: 5px;
  font-size: 14px;
  font-size: 1.4rem;
  line-height: 18px;
  line-height: 1.8rem;
}
.product-search {
  background: url("{!$Resource.shaded_top_png}") no-repeat #00b0ca;
  -moz-background-size: 100% 100%;
  -o-background-size: 100% 100%;
  -webkit-background-size: 100% 100%;
  background-size: 100% 100%;
  padding: 10px 10px 0;
  margin-bottom: 15px;
  overflow: hidden;
}
.product-search input {
  width: 60%;
}
.product-search .popover {
  background: #ededed;
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 14px;
  line-height: 1.4rem;
}
.product-search .popover .arrow:after {
  border-top-color: #ededed;
}
.product-search-tab {
  display: inline-block;
  width: 140px;
  padding: 10px 0;
  text-align: center;
  background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyBpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBXaW5kb3dzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjk5RDcwMzUzQjE3QjExRTM5MEU0RkE5NUJENzA5QjE4IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjk5RDcwMzU0QjE3QjExRTM5MEU0RkE5NUJENzA5QjE4Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6OTlENzAzNTFCMTdCMTFFMzkwRTRGQTk1QkQ3MDlCMTgiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6OTlENzAzNTJCMTdCMTFFMzkwRTRGQTk1QkQ3MDlCMTgiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz5psgL1AAAAEElEQVR42mL4//9/A0CAAQAJfAN+6DKEMgAAAABJRU5ErkJggg==);
  background: rgba(255, 255, 255, 0.5);
  color: #333;
}
.product-search-tab:hover {
  color: #333;
}
.product-search-tab.active {
  background: #fff;
  color: #0064af;
}
#news-list ul {
  display: none;
}
#news-list ul:first-child {
  display: block;
}
#news-list ul li,
#list-pager ul li {
  margin-bottom: 10px;
  font-size: 11px;
  font-size: 1.1rem;
  line-height: 13px;
  line-height: 1.3rem;
}
#list-pager li {
  cursor: pointer;
}
#list-pager li.active {
  background: #00b0ca;
  color: #ffffff;
  cursor: default;
}
.brd-btm {
  border-bottom: 1px solid #ccc;
}
.current-filters {
  color: #95a0a9;
  padding: 15px 0;
  position: relative;
  z-index: 1;
}
.current-filters .clear {
  color: #95a0a9;
}
.filter {
  padding: 0 3px;
  margin-left: 3px;
  color: #00b0ca;
}
.remove {
  display: inline-block;
  background: url("{!$Resource.remove_png}") no-repeat;
  width: 13px;
  height: 13px;
  text-indent: -3000px;
  top: 3px;
  *top: -3px;
  position: relative;
}
.ps-area {
  display: none;
  position: relative;
  z-index: 2;
}
.ps-area:first-child {
  display: block;
}
.ps-area > li {
  float: left;
  width: 16.5%;
  text-align: center;
  position: relative;
  cursor: pointer;
}
.ps-area span {
  padding-bottom: 5px;
  display: inline-block;
}
.ps-area ul {
  position: absolute;
  left: 0;
  *top: 25px;
  display: none;
  background: #ededed;
  text-align: left;
  white-space: nowrap;
  padding: 10px;
  z-index: 1;
  border: 1px solid #bac1c7;
  -webkit-box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
  -moz-box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
  box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
  z-index: 99;
}
.ps-area a {
  color: #333;
  line-height: 18px;
  line-height: 1.8rem;
}
.ps-scroll {
  max-height: 150px;
  overflow: hidden;
  border: 1px solid #c2d1d4;
  white-space: nowrap;
  display: inline-block;
  min-width: 200px;
}
.ps-scroll .content {
  padding: 5px;
  *height: 150px;
}
.ps-scroll .content label {
  font-size: 12px;
  font-size: 1.2rem;
  line-height: 16px;
  line-height: 1.6rem;
}
.notice {
  color: #e05206;
}
textarea.input-field,
input[type="text"].input-field {
  width: 100%;
  -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  -moz-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
  font-size: 12px;
  font-size: 1.2rem;
  padding: 7px;
  -webkit-border-radius: 0px;
  -moz-border-radius: 0px;
  border-radius: 0px;
  line-height: normal;
  height: auto;
  border: 1px solid #c2d1d4;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  *margin-left: -20px;
  *width: 97%;
}
select.input-field {
  -webkit-border-radius: 0px;
  -moz-border-radius: 0px;
  border-radius: 0px;
  border: 1px solid #c2d1d4;
  width: 100%;
  *zoom: 1;
}
.property-item input {
  *margin: 3px 0 0 0!important;
  *width: 200px!important;
}
.property-item.first .rm {
  display: none!important;
}
.additional-property {
  width: 30px;
  height: 30px;
  font-size: 22px;
  font-size: 2.2rem;
  line-height: 25px;
  line-height: 2.5rem;
  color: #0064af;
  font-weight: bold;
}
.additional-property:hover {
  text-decoration: none;
}
.default {
  width: auto !important;
}
.content-frame {
  border: none;
  outline: none;
  width: 100%;
  min-height: 500px;
  *height: 500px;
}
/** initial setup **/
.nano {
  position: relative;
  overflow: hidden;
}
.nano > .content {
  position: absolute;
  overflow: scroll;
  overflow-x: hidden;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
}
.nano > .content:focus {
  outline: thin dotted;
}
.nano > .content::-webkit-scrollbar {
  visibility: hidden;
}
.has-scrollbar > .content::-webkit-scrollbar {
  visibility: visible;
}
.nano > .pane {
  position: absolute;
  width: 10px;
  right: 3px;
  top: 4px;
  bottom: 4px;
  visibility: hidden\9;
  /* Target only IE7 and IE8 with this hack */
  opacity: .01;
  -webkit-transition: .2s;
  -moz-transition: .2s;
  -o-transition: .2s;
  transition: .2s;
  -moz-border-radius: 5px;
  -webkit-border-radius: 5px;
  border-radius: 5px;
}
.nano > .pane > .slider {
  background: #444;
  background: rgba(0, 0, 0, 0.5);
  position: relative;
  margin: 0 1px;
  -moz-border-radius: 3px;
  -webkit-border-radius: 3px;
  border-radius: 3px;
}
.nano:hover > .pane,
.pane.active,
.pane.flashed {
  visibility: visible\9;
  /* Target only IE7 and IE8 with this hack */
  opacity: 0.99;
}
/* #Media Queries
================================================== */
/* Tablet Landscape and Large Screens */
/* Tablet Portrait */
@media only screen and (min-width: 768px) and (max-width: 991px) {
  head {
    font-family: "T";
  }
  body:after {
    content: "T";
    display: none;
  }
  input[type="text"].nav-search,
  .nav-search {
    width: 130px;
  }
  .left-nav {
    margin-left: -10px;
  }
  .left-nav > li a {
    padding-left: 5px;
  }
  .l2 > li a {
    padding-left: 5px;
  }
  .l3 > li a,
  .l3 > li span {
    padding-left: 15px;
  }
  .main-feature-background {
    -webkit-background-size: auto 100%;
    -moz-background-size: auto 100%;
    -o-background-size: auto 100%;
    background-size: auto 100%;
  }
  .mc-slides-wrap h1 {
    font-size: 34px;
    font-size: 3.4rem;
    line-height: 34px;
    line-height: 3.4rem;
    padding-bottom: 10px;
  }
  .mc-slides-wrap h5 {
    font-size: 20px;
    font-size: 2rem;
    padding-bottom: 10px;
  }
  .mc_tabs {
    width: 724px;
  }
  #results {
    margin-left: -15px;
  }
  /* mosaic start */
  .mosaic-c1 {
    width: 227px;
    height: 261px;
    -webkit-background-size: auto 100%;
    -moz-background-size: auto 100%;
    -o-background-size: auto 100%;
    background-size: auto 100%;
  }
  .mosaic-c2 {
    width: 188px;
    height: 261px;
  }
  .mosaic-c2-item {
    width: 188px;
    height: 120px;
  }
  .mosaic-c3 {
    width: 269px;
    height: 261px;
  }
  .mosaic-c3-top {
    width: 269px;
    height: 174px;
  }
  .mosaic-c3-white-top {
    width: 269px;
    height: 174px;
  }
  .mosaic-c3-bottom {
    width: 269px;
    height: 67px;
  }
  .mosaic-c1 .cta2,
  .mosaic-c3 .cta2 {
    font-size: 13px;
    font-size: 1.3rem;
    line-height: 15px;
    line-height: 1.5rem;
    padding: 11px 20px 11px 40px;
  }
  /* mosaic end */
  /* two-thirds mosaic start */
  .mosaic-2-3-one {
    width: 190px;
    float: left;
    margin-right: 10px;
  }
  .mosaic-2-3-one-top {
    width: 190px;
    height: 123px;
    background: #00b0ca;
    overflow: hidden;
  }
  .mosaic-2-3-one-bottom {
    width: 190px;
    height: 123px;
    background: #00b0ca;
    overflow: hidden;
  }
  .mosaic-2-3-two {
    width: 276px;
    float: left;
  }
  .mosaic-2-3-two-top {
    width: 276px;
    height: 179px;
    overflow: hidden;
  }
  .mosaic-2-3-two-bottom {
    width: 276px;
    height: 66px;
  }
  .mosaic-2-3-two-bottom .cta2 {
    font-size: 15px;
    font-size: 1.5rem;
    line-height: 15px;
    line-height: 1.5rem;
    padding: 11px 20px 11px 40px;
  }
  /* two-thirds mosaic end */
  /* numbers to know start */
  .ntk {
    font-size: 13px;
    font-size: 1.3rem;
    line-height: 16px;
    line-height: 1.6rem;
    padding: 10px;
    min-height: 235px;
  }
  .ntk .large {
    font-size: 16px;
    font-size: 1.6rem;
  }
  /* numbers to know end */
  .ss-features a img {
    -moz-opacity: 1;
    -khtml-opacity: 1;
    -webkit-opacity: 1;
    opacity: 1;
    -ms-filter: progid:DXImageTransform.Microsoft.Alpha(opacity=100);
    filter: alpha(opacity=100);
  }
  .document {
    width: 32%;
  }
  .follow-list {
    float: none !important;
    clear: both;
    text-align: left;
  }
  .follow-list li {
    margin-bottom: 3px;
  }
  .follow-list li:first-child {
    margin-left: 0;
  }
  .quarter {
    height: 240px;
  }
  .q-title {
    margin: 40px 0 20px;
    font-size: 25px;
    font-size: 2.5rem;
    line-height: 25px;
    line-height: 2.5rem;
  }
  .q-action {
    font-size: 14px;
    font-size: 1.4rem;
    line-height: 20px;
    line-height: 2rem;
  }
}
/* Phone Portriat and Landscape */
@media only screen and (max-width: 767px) {
  head {
    font-family: "P";
  }
  body:after {
    content: "P";
    display: none;
  }
  body {
    padding: 60px 0 10px;
  }
  .container {
    padding: 0 20px;
  }
  .main {
    padding-top: 100px;
  }
  h1 {
    font-size: 20px;
    font-size: 2rem;
    line-height: 20px;
    line-height: 2rem;
    color: #0064af;
  }
  h2 {
    font-size: 18px;
    font-size: 1.8rem;
    line-height: 24px;
    line-height: 2.4rem;
    color: #0064af;
  }
  .intro {
    font-size: 15px;
    font-size: 1.5rem;
    line-height: 20px;
    line-height: 2rem;
  }
  .header-fixed-top {
    padding: 10px 20px;
    height: 40px;
  }
  .no-boxshadow .header-fixed-top {
    height: 47px;
  }
  .main .header-fixed-top {
    background: #fff;
  }
  .brand-logo {
    width: 47px;
    height: 39px;
    background: url("{!$Resource.bw_logo_sm_png}") no-repeat;
  }
  .drop-search {
    background: #ffffff;
    width: 100%;
    padding: 0 10px;
    top: 50px;
    display: none;
    overflow: hidden;
    -webkit-box-shadow: inset 0 3px 4px rgba(0, 0, 0, 0.06);
    -moz-box-shadow: inset 0 3px 4px rgba(0, 0, 0, 0.06);
    box-shadow: inset 0 3px 4px rgba(0, 0, 0, 0.06);
    position: fixed;
    left: -1px;
  }
  .banner {
    background-size: cover;
    padding: 30px 0;
  }
  #results {
    margin-left: 0px;
  }
  .navbar-toggle {
    float: right;
    width: 43px;
    height: 35px;
    padding: 5px;
    margin: 3px 12px 5px 5px;
    background-color: transparent;
    border: none;
  }
  .navbar-toggle .icon-bar {
    display: block;
    width: 33px;
    height: 4px;
    background-color: #00b0ca;
    -webkit-border-radius: 1px;
    -moz-border-radius: 1px;
    border-radius: 1px;
  }
  .navbar-toggle .icon-bar + .icon-bar {
    margin-top: 6px;
  }
  .nav-collapse {
    overflow: hidden !important;
    height: 0px;
    top: 50px;
    left: 0;
    position: absolute;
    margin-right: 0;
    margin-left: -20px;
    width: 100%;
    -webkit-box-shadow: 0 3px 4px rgba(0, 0, 0, 0.06);
    -moz-box-shadow: 0 3px 4px rgba(0, 0, 0, 0.06);
    box-shadow: 0 3px 4px rgba(0, 0, 0, 0.06);
    text-align: right;
  }
  nav-submenu .nav {
    list-style: none;
    margin: 0;
  }
  nav-submenu .nav li {
    float: none;
    margin: 0;
  }
  nav-submenu .nav > li > a {
    padding: 10px 20px;
    color: #444444;
    float: none;
    background: #ffffff;
    display: block;
  }
  nav-submenu .nav > li > a + a {
    border-bottom: 1px solid #444444;
  }
  nav-submenu .nav li > a:hover {
    text-decoration: none;
  }
  .nav-dropdown {
    display: none !important;
  }
  .nav-main {
    margin: 0;
    float: none !important;
  }
  input[type="text"].nav-search,
  .nav-search {
    position: absolute;
    top: 2px;
    right: 90px;
    width: 40% !important;
    margin: 5px 0 0 50px !important;
  }
  .left-nav {
    margin: 35px 0 0 0;
  }
  .news {
    margin-top: 0;
    margin-bottom: 0;
  }
  .news-list {
    text-align: center;
    padding: 0;
    margin: 0;
    font-size: 14px;
    font-size: 1.4rem;
    line-height: 20px;
    line-height: 2rem;
  }
  .news-list dt,
  .news-list dd {
    float: none;
    display: inline;
    font-size: 14px;
    font-size: 1.4rem;
    line-height: 16px;
    line-height: 1.6rem;
  }
  .news-list dt a {
    color: #00b0ca;
  }
  .news-list .hide {
    display: none !important;
  }
  .follow-list {
    text-align: center;
    display: block;
  }
  .follow-list li {
    margin-left: 15px;
  }
  .follow-list li:first-child {
    margin-left: 0;
  }
  .follow-text {
    font-size: 12px;
    font-size: 1.2rem;
    display: block !important;
  }
  .news .span4 .follow-text {
    margin-top: 0;
  }
  .hr,
  .row .hr {
    margin: 20px -20px;
  }
  .menu-tab-item,
  .menu-tab-item:link {
    padding: 10px 10px;
  }
  .upper-tools {
    margin: -50px 0 0 0;
  }
  .row-fluid.marl20 {
    margin-left: 0;
  }
  .row.marb30,
  .row.marb50 {
    margin-bottom: 0 !important;
  }
  .rr-list li {
    margin-bottom: 10px;
  }
  .button.sm {
    font-size: 15px;
    font-size: 1.5rem;
    line-height: 30px;
    line-height: 3rem;
    padding: 0 10px;
  }
  .mc-slides-wrap h1 {
    font-size: 24px;
    font-size: 2.4rem;
    line-height: 26px;
    line-height: 2.6rem;
    padding-bottom: 0;
    color: #ffffff !important;
  }
  .mc-slides-wrap h5 {
    font-size: 18px;
    font-size: 1.8rem;
    line-height: 22px;
    line-height: 2.2rem;
    color: #ffffff !important;
  }
  .mc-slides-wrap .button {
    margin: 0 auto;
  }
  .mc-slides {
    height: 450px;
  }
  .mc-slides .mc-slide {
    top: 60px;
    height: auto;
    -moz-background-size: auto 150px;
    -o-background-size: auto 150px;
    -webkit-background-size: auto 150px;
    background-size: auto 150px;
    padding-top: 110px;
  }
  .mc_nav {
    top: 130px;
  }
  .mc_tabs {
    z-index: 4;
    position: absolute;
    top: 70px;
    right: 10px;
    margin: 0;
  }
  /* main feature start */
  .main-feature-background {
    -webkit-background-size: auto 100%;
    -moz-background-size: auto 100%;
    -o-background-size: auto 100%;
    background-size: auto 100%;
    padding: 25px 20px;
  }
  .main-feature-background h1 {
    font-size: 30px;
    font-size: 3rem;
    line-height: 30px;
    line-height: 3rem;
    margin-bottom: 30px;
    margin-bottom: 3rem;
  }
  .main-feature-background h5 {
    font-size: 20px;
    font-size: 2rem;
    line-height: 20px;
    line-height: 2rem;
  }
  .main-feature-background .text-center {
    margin: 0;
  }
  .alignment-right {
    text-align: right;
  }
  .alignment-right h1 {
    margin-bottom: 10px;
  }
  .alignment-right h5 {
    margin-bottom: 10px;
  }
  .alignment-left h1 {
    margin-bottom: 10px;
  }
  .alignment-left h5 {
    margin-bottom: 10px;
  }
  .phone-full-width {
    margin: 0;
    padding: 0;
  }
  .main-feature-background.sub-feature .alignment-right {
    padding-right: 20px;
  }
  .main-feature-background.sub-feature .alignment-left {
    padding-left: 20px;
  }
  .c-item {
    position: relative;
    padding: 20px;
    font-size: 16px;
    font-size: 1.6rem;
    line-height: 21px;
    line-height: 2.1rem;
  }
  .quote-open,
  .quote-close {
    font-size: 40px;
    font-size: 4rem;
    line-height: 0px;
    line-height: 0rem;
    position: relative;
    top: 10px;
    padding: 0;
    display: inline;
  }
  .c-quote-area {
    background: #fff;
  }
  .c-quotes {
    margin: 20px 0;
    padding: 0;
  }
  .highlightarea-title {
    font-size: 25px;
    font-size: 2.5rem;
    line-height: 25px;
    line-height: 2.5rem;
  }
  /* main feature end */
  .mosaic-c1 {
    overflow: hidden;
    width: auto;
    height: auto;
    float: none;
    margin: 0 0 20px;
    -webkit-background-size: 100% auto;
    -moz-background-size: 100% auto;
    -o-background-size: 100% auto;
    background-size: 100% auto;
  }
  .mosaic-c2 {
    width: auto;
    height: auto;
    float: none;
    margin: 0;
    overflow: hidden;
  }
  .mosaic-c2-item {
    overflow: hidden;
    width: 48%;
    height: auto;
    float: left;
    text-align: center;
  }
  .mosaic-c2-item:first-child {
    margin-right: 4%;
  }
  .generic-c2 {
    float: none;
    width: 100%;
    margin-bottom: 20px;
  }
  .mosaic-c3 {
    width: auto;
    height: auto;
    float: none;
    clear: both;
  }
  .mosaic-c3-top {
    overflow: hidden;
    width: auto;
    height: auto;
    text-align: center;
  }
  .mosaic-c3-white-top {
    overflow: hidden;
    width: auto;
    height: auto;
    text-align: center;
  }
  .mosaic-c3-bottom {
    overflow: hidden;
    width: auto;
    height: auto;
    -webkit-background-size: 100% auto;
    -moz-background-size: 100% auto;
    -o-background-size: 100% auto;
    background-size: 100% auto;
  }
  /* two-thirds mosaic start */
  .mosaic-2-3-one {
    width: auto;
    float: none;
    margin-right: 0;
    text-align: center;
  }
  .mosaic-2-3-one-top {
    width: auto;
    height: auto;
    background: none;
  }
  .mosaic-2-3-one-bottom {
    width: auto;
    height: auto;
    background: none;
  }
  .mosaic-2-3-two {
    width: auto;
    float: none;
  }
  .mosaic-2-3-two-top {
    width: auto;
    height: auto;
    background: none;
    text-align: center;
  }
  .mosaic-2-3-two-bottom {
    width: auto;
    height: auto;
  }
  /* two-thirds mosaic end */
  /* multi features start */
  .multi-feature {
    background: #ffffff;
    padding: 20px !important;
    margin: 0 -20px;
  }
  .multi-feature .mart20 {
    margin-top: 0;
  }
  .multi-feature div {
    position: relative;
  }
  .multi-feature img {
    position: absolute;
    top: 0px;
    left: 0px;
    max-width: 25%;
  }
  .multi-feature h2,
  .multi-feature p {
    margin: 0 0 10px 30%;
    text-align: left;
  }
  .multi-feature a {
    background: none;
    padding: 0;
    margin: 0;
  }
  .multi-feature div:first-child {
    margin-bottom: 20px;
    margin-right: 3% !important;
    clear: both;
  }
  .multi-feature div:nth-child(2) {
    margin-bottom: 20px;
    background: none;
  }
  .multi-feature div:nth-child(3) {
    clear: both;
  }
  .multi-feature div:nth-child(4) {
    margin-right: 3% !important;
    background: none;
  }
  /* multi features end*/
  /* mosaic start*/
  .mosaic-c {
    min-height: 0;
    -webkit-background-size: 100% auto;
    -moz-background-size: 100% auto;
    -o-background-size: 100% auto;
    background-size: 100% auto;
  }
  .mosaic-c .span-sm-6 {
    margin-left: 4%;
  }
  /* mosaic end*/
  /*Quarters*/
  .quarters {
    width: 100%;
    max-width: 1360px;
    margin: 0 auto;
    background: #ccc;
    overflow: hidden;
    text-align: center;
  }
  .quarter {
    width: 100%;
    height: 240px;
    float: none;
    background-size: cover;
  }
  .q-action {
    font-size: 16px;
    font-size: 1.6rem;
    line-height: 26px;
    line-height: 2.6rem;
  }
  .q-title {
    font-size: 34px;
    font-size: 3.4rem;
    line-height: 36px;
    line-height: 3.6rem;
    margin-top: 60px;
  }
  .ss-features a img {
    -moz-opacity: 1;
    -khtml-opacity: 1;
    -webkit-opacity: 1;
    opacity: 1;
    -ms-filter: progid:DXImageTransform.Microsoft.Alpha(opacity=100);
    filter: alpha(opacity=100);
  }
  /* numbers to know start */
  .ntk {
    min-height: 1px;
  }
  /* numbers to know end */
  .more-items {
    margin-top: 20px;
    margin-left: 0 !important;
  }
  .more-items li:nth-child(2n+3) {
    clear: both;
    margin-right: 4% !important;
  }
  .mosaic-large {
    height: 120px;
    min-height: 120px;
    margin-bottom: 10px;
  }
  /* expand/collapse start */
  .mobile-expand {
    position: relative;
    padding-right: 20px;
    margin-top: 0;
  }
  .mobile-expand .control {
    position: absolute;
    top: 13px;
    right: 15px;
    background: url("{!$Resource.arrows_nav_down_png}") no-repeat center top;
    width: 13px;
    height: 8px;
  }
  .mobile-expand .control.collapse {
    background: url("{!$Resource.arrows_nav_down_png}") no-repeat center bottom;
  }
  /* expand/collapse end */
  .clear-left-sm {
    clear: left;
  }
  .clear-pull-sm {
    float: none;
  }
  .clear-float-sm {
    float: none;
  }
  .text-center-sm {
    text-align: center !important;
  }
  .text-left-sm {
    text-align: left;
  }
  .nobkgnd {
    background: none;
  }
  .dotted-right {
    background: none;
  }
  .dotted-right > * {
    padding-right: 0;
  }
  .dotted-right.sm,
  .dotted-right-sm {
    background: url("{!$Resource.bdr_dotted_png}") repeat-y right top;
  }
  .dotted-top {
    padding-top: 10px;
  }
  ul.inline.upper-tools > li.visible-phone,
  ul.inline.lower-tools > li.visible-phone {
    display: inline-block !important;
  }
  .type-assist {
    width: auto;
  }
  .ui-autocomplete {
    max-width: 80%;
  }
  .product-search-tab {
    display: block;
    width: 100%;
    padding: 10px 0;
    color: #333;
    margin-bottom: 5px;
  }
  .ps-area ul {
    position: static;
    width: 90%;
    margin: 0 auto;
    text-align: center;
  }
  .ps-area > li {
    float: none;
    width: 100%;
    text-align: center;
  }
  .ps-scroll {
    width: 100%;
  }
}
/* Landscape phones and down */
@media (max-width: 480px) {
  .alignment-right {
    text-align: right;
    margin-left: 25%;
  }
  .alignment-left {
    margin-right: 25%;
    text-align: left;
  }
  .main-feature-background.sub-feature .alignment-right {
    padding-left: 20px;
  }
  .main-feature-background.sub-feature .alignment-left {
    padding-right: 20px;
  }
  .mc-slides .alignment-right {
    margin-left: 0;
  }
  .mc-slides .alignment-left {
    margin-right: 0;
  }
}
/* Portrait phones */
@media (max-width: 380px) {
  .alignment-right {
    text-align: right;
    margin-left: 0;
  }
  .alignment-left {
    margin-right: 0;
    text-align: left;
  }
  .mosaic-c3-bottom {
    -webkit-background-size: auto 100%;
    -moz-background-size: auto 100%;
    -o-background-size: auto 100%;
    background-size: auto 100%;
  }
  .multi-feature h2 {
    font-size: 20px;
    font-size: 2rem;
    line-height: 20px;
    line-height: 2rem;
  }
  .upper-tools {
    margin: -55px -12px 0 0;
  }
  .upper-tools .tools.share,
  .upper-tools .tools.chat,
  .upper-tools .tools.phone {
    font-size: 0;
  }
}
@media print {
  body {
    padding: 0;
  }
  .header-fixed-top {
    position: static;
    -webkit-box-shadow: 0 0 0 rgba(0, 0, 0, 0);
    -moz-box-shadow: 0 0 0 rgba(0, 0, 0, 0);
    box-shadow: 0 0 0 rgba(0, 0, 0, 0);
    padding: 0;
    margin: 0;
  }
  .nav-utility,
  .nav-main {
    display: none;
  }
  .print-only {
    display: block;
  }
  .screen-only {
    display: none;
  }
  .brand-logo {
    position: static;
  }
}
