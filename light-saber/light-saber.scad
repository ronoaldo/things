// Number of blades
nblades = 5;

// Starting blade bottom radius (mm)
r = 12.6;

// Height of all blades (mm)
h = 120.0;

/* [Advanced] */
// Delta between bottom and top of blade radius (mm)
delta = 1.4;
// Thickness of each blade (mm)
t = 0.8;
// Thickness of the handle (mm)
ht = 3;
// Tolerance between blades (mm)
tolerance = 0.4;
// If the handle should have edges rounded (recommended)
rounded = true;

/* [Use this for preview] */
// Expand the blades for preview
expand = false;
// Check this to preview how is the inside of the build.
previewInside = false;
// How much expanded blades touch each other when rendering. Use this to preview if they will overlap properly.
bladePreviewOffset = 20;

module blade(height, r1, r2, thickness, fillTop=false) {
    $fn=60;
    
    echo("Creating blade with", height, r1, r2, thickness, fillTop);
    difference() {
        cylinder(h=height, r1=r1, r2=r2);
        translate([0, 0, -1])
            cylinder(h=height+2, r1=r1-thickness, r2=r2-thickness);
    }
    if(fillTop) {
        translate([0, 0, h-thickness])
            cylinder(h=thickness, r1=r2, r2=r2);
    }
}

module handle() {
    $fn=40;
    
    height = rounded ? h-1 : h;
    r1 = r + ht;
    r2 = r1-delta;
    
    color("gray")
    translate([0, 0, rounded ? 0.5 : 0])
    difference() {
        minkowski() {
            union() {
                // Base
                cylinder(height, r1, r1);
                
                // Bottom
                translate([0, 0, 4]) cylinder(5, r1, r1+4);
                translate([0, 0, 9]) cylinder(5, r1+4, r1+3);
                translate([0, 0, 14]) cylinder(3, r1+3, r1);
                
                // Middle
                for(i=[0: 6: 32]) {
                    translate([0, 0, height-30-i]) cylinder(3, r1+2, r1);
                    translate([0, 0, height-33-i]) cylinder(3, r1, r1+2);
                }
                difference() {
                    translate([r-4, -5, 35]) cube([8, 10, 20]);
                    translate([r+4, -5, 50])
                        rotate([0, -45, 0])
                        cube([8, 10, 20]);
                }
                
                // Top
                translate([0, 0, height- 5.0]) cylinder(5, r1+4, r1+4);
                translate([0, 0, height- 8.0]) cylinder(3, r1+2, r1+4);
                translate([0, 0, height-14.0]) cylinder(6, r1+2, r1+2);
                translate([0, 0, height-16.0]) cylinder(2, r1, r1+2);
            }
            if (rounded) {
                sphere(0.5, $fn=12);
            }
        }
        translate([0, 0, -1])
            cylinder(height+2, r1-ht+tolerance+1, r2-ht+tolerance+1);
    }
}

module handleLid(r) {
    r1 = r + ht;
    
    color("gray")
    translate([expand ? 0 : 4*r, 0, 0])
    difference() {
        cylinder(8, r1+2.5, r1+2.9);
        
        translate([0, 0, 1.1])
        cylinder(7, r1+0.8, r1+0.8);
    }
}

function m(n) = expand ? (n<0 ? 0 : n) : 0;

module rotateToPrint() {
    vec = expand ? [0, 0, 0] : [180, 0, 0];
    off = expand ? [0, 0, 0] : [0, 0, -h];
    rotate(vec) translate(off) children();
}

difference() {
    union() {
        rotateToPrint()
        handle();
        
        // Blades
        rotateToPrint()
        for (i = [0 : nblades-1]) {
            let (r1 = r-(i*delta)-(i*tolerance), r2 = r1-delta) {
                translate([0, 0, m(i+1)*(h - bladePreviewOffset)])
                color("lightgreen")
                blade(h, r1, r2, t, (i==nblades-1? true : false) );
            }
        }
        
        handleLid(r);
    }
    
    // Cut in half to see the internals
    if (previewInside) {
        translate([0, -100, -1])
        cube([200, 200, (nblades+2)*h]);
    }
}
