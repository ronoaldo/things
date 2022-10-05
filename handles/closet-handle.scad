espessura = 10;
tamanho = 138;
distFuros = 128;

module soften() {
    minkowski() {
        $fn=32;
        sphere(0.5);
        children();
    }
}

module puxador() {
    difference() {
        cube([tamanho, 2*espessura, espessura ]);
        translate([espessura, 0, 0]) {
            cube([tamanho-2*espessura, espessura, espessura]);
        }
    }
}

module furos() {
    $fn = 128;
    holeDiameter = 3;
    holeDepth = 6;

    
    x1 = (tamanho-distFuros) / 2;
    x2 = x1 + distFuros;
    y = holeDepth-1;
    z = espessura/2;
    
    translate([x1, y, z])
    rotate([90, 0, 0])
        cylinder(h=holeDepth, d=holeDiameter);
    
    translate([x2, y, z])
    rotate([90, 0, 0])
        cylinder(h=holeDepth, d=holeDiameter);
}

difference() {
    soften() puxador();
    furos();
}