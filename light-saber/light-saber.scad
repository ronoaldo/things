// Number of blades
nblades = 5;

// Starting blade bottom radius (mm)
r = 16.0;

// Height of all blades (mm)
h = 130.0;

/* [Advanced] */
// Delta between bottom and top of blade radius (mm)
delta = 0.8;
// Thickness of each blade (mm)
t = 1.1;
// Tolerance between blades; should be less than thickness (mm)
tolerance = 1.0;

/* [Preview only] */
// Expand the blades for preview
expand = false;
// How much expanded blades touch each other when rendering. Use this to preview if they will overlap properly.
contactCheckSize = 20;

/* [Hidden] */
$fn=30;

module blade(height, r1, r2, thickness, fillTop=false) {
    echo("Creating blade with", height, r1, r2, thickness, fillTop);
    difference() {
        $fn=60;
        cylinder(h=height, r1=r1, r2=r2);
        translate([0, 0, -1])
            cylinder(h=height+2, r1=r1-thickness, r2=r2-thickness);
    }
    if(fillTop) {
        translate([0, 0, h-r2])
            cylinder(h=r2, r1=r2, r2=r2);
    }
}

function m(n) = expand ? (n<0?0:n) : 0;

difference() {
    for (i = [0 : nblades]) {
        let (r1 = r-(i*delta)-(i*tolerance),
             r2 = r1-delta) {
            echo("Iteration", i);
            translate([0, 0, m(i)*(h - contactCheckSize)])
            color("lightgreen")
            blade(h, r1, r2, t, (i==nblades? true : false) );
        }
    }
    if (expand) {
        translate([0, -100, -1])
        cube([100, 100, (nblades+1)*h]);
    }
}
