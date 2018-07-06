@page {
@top-center {
    content: element(header);
}

@bottom-left {
    content: element(footer);
}
margin-top:12%;
margin-bottom:10%;

}
 
div.header {
padding: 8px;
position: running(header);
margin-top: 20px; 
margin-bottom: 30px;
}

div.footer {
display: block;
padding: 5px;
position: running(footer);
margin-top: auto; 
margin-bottom: auto;
}

.pagenumber:before {
content: counter(page);
}

.pagecount:before {
content: counter(pages);
}