@page{
    margin-left: 1cm;
    margin-right: 1cm;
    margin-top: 2.54cm;
    margin-bottom: 2.54cm;
   
    @bottom-left {
        content: element(footer);
    }
}


div.footer {
    padding: 5px;
    position: running(footer);
}

.pagenumber:before {
    content: counter(page);
}

.pagecount:after {
    content: counter(pages);
}
