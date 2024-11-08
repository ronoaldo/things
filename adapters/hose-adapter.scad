adapt_from=122;
adapt_to=156;
adapter_height=50;
edge_height=20;
thickness=2;

/* [Hidden] */
$fn = 64;

module duct(h, r1, r2) {
    difference() {
        // Outer
        cylinder(h=h, r1=r1, r2=r2);
        // Inner
        cylinder(h=h, r1=r1-thickness, r2=r2-thickness);
    }
}

module adapter() {
    r1 = adapt_from/2;
    r2 = adapt_to/2;
    union() {
        translate([0, 0, adapter_height]) duct(edge_height, r2, r2);
        duct(adapter_height, r1, r2);
        translate([0, 0, -20]) duct(edge_height, r1, r1);
    }
}

color("white")
adapter();