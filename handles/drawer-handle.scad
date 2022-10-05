$fn=36;

size   = 32;
thick  = 5;
corner = 2;

module rcube(size=[1, 1, 1], radius=0.8) {
    minkowski() {
        cube(size = [
            size[0]-2*radius,
            size[1]-2*radius,
            size[2]-2*radius]
        );
        sphere(r = radius);
    }
}

// Base do puxador, com cantos arredondados
translate([corner, corner, corner])
    rcube([size, size, thick], radius=corner);

// Haste do puxador
translate([size/2, size/2, thick/2])
    difference() {
        union() {
            cylinder(d=10, h=24+thick/2);
            cylinder(r1=14, r2=4, h=10);
        }
        translate([0, 0, 1]) cylinder(d=3.8, h=25+thick/2);
    }