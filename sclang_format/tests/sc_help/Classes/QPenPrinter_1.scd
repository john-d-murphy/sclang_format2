// Source: Classes/QPenPrinter.schelp block 1
QPenPrinter.print {
    // first page
    Pen.moveTo(100@100);
    Pen.lineTo(300@300);
    Pen.stroke;

    // second page
    p.newPage;
    Pen.addRect(p.pageSize.asRect);
    Pen.stroke;
}
