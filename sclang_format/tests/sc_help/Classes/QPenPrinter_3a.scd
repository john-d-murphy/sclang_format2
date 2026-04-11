// Source: Classes/QPenPrinter.schelp block 3 (part 1/2)
p.showDialog {
    p.print {
        // first page
        Pen.moveTo(100@100);
        Pen.lineTo(300@300);
        Pen.stroke;

        // second page
        p.newPage;
        Pen.addRect(p.pageSize.asRect);
        Pen.stroke;
    }
}
