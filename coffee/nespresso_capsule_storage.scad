height = 160;
thickness = 3;

debug = false;

/* [Hidden] */

// Calculate proportions based roughtly on the capsule shape.
bottom = height * 0.60;
middle = height * 0.83;
top = height * 1.11;
h2 = height * 0.9;
h1 = height * 0.1;

lid_h = height * 0.05;
lid_diam = height * 1.30;

c = 0.3; // clearance

$fn = 256;

module apply_color(color_string) {
    if (!debug) {
        color(color_string) children();
    } else {
        children();
    }
}

module capsule_body() {
    t = thickness;

    apply_color("#4F4A4A")
    difference() {
        union() {
            cylinder(h = h1, r1 = bottom/2, r2 = middle/2);
            translate([0, 0, h1]) cylinder(h = h2, r1 = middle/2, r2 = top/2);
        }
        translate([0, 0, t/2])
        union() {
            cylinder(h = h1, r1 = (bottom-t)/2, r2 = (middle-t)/2);
            translate([0, 0, h1]) cylinder(h = h2, r1 = (middle-t)/2, r2 = (top-t)/2);
        }
    }
}

module capsule_lid() {
    t = thickness;
    
    r = 3; // "rounding factor"
    d = r/2; // diameter offset to account for the rounding factor
    lid_flange_h = 3;
    lid_flange_r2 = (top-t)/2-c;
    lid_flange_r1 = lid_flange_r2 * (1 - (lid_flange_h/height));
    
    apply_color("gray")
    union() {
        minkowski() {
            cylinder(h=lid_h-d, r1=(lid_diam-d)/2, r2=(lid_diam-d)/2, $fn=128);
            sphere(r=r, $fn=128);
        }
        translate([0, 0, -r-lid_flange_h+0.01])
        cylinder(h=lid_flange_h, r1=lid_flange_r1, r2=lid_flange_r2);
    }
}

module design() {
    capsule_body();
    translate([0, 0, height+4]) capsule_lid();
}

if (debug) {
    difference() {
        design();
        cube(2*height);
    }
 } else {
    design();
 }