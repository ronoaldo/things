
height = 50;

module blade_shape(h, w, e) {
    linear_extrude(height=h, scale=scaling_factor)
        hull() {
            translate([-w/2, 0, 0]) circle(r=e, $fn=8);
            translate([ w/2, 0, 0]) circle(r=e, $fn=8);
        }
}

module blade(h, w, e) {
    difference() {
        blade_shape(h, w, e);
        
        translate([0, 0, -1])
        blade_shape(h+2, w-thickness, e-thickness);
    }
}

nblades = 3; // TODO(ronoaldo): calculate from the factor

width = 35;
edge = 6;
thickness = 0.4;
spacing = 0.4;
scaling_factor = 0.9;

for (i=[0 : nblades-1]) {
    let(w = width-(i*thickness)-(i*spacing), e = edge-(i*thickness)-(i*spacing)) {
        blade(height, w, e);
    }
}