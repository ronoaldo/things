include <../third_party/BOSL2/std.scad>
include <../third_party/BOSL2/threading.scad>

// Number of blades
nblades = 6;

// Starting blade bottom radius (mm)
r = 14.6;

// Height of all blades (mm)
h = 138.0;

/* [Advanced] */
// Delta between bottom and top of blade radius (mm)
delta = 1.4;
// Thickness of each blade (mm)
t = 0.8;
// Thickness of the handle (mm)
ht = 2.2;
// Tolerance between blades (mm)
tolerance = 0.6;
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
    
    topHeight = 2;
    bh = fillTop ? height - topHeight : height;

    echo("Creating blade with", bh, r1, r2, thickness, fillTop);
    difference() {
        cylinder(h=bh, r1=r1, r2=r2);
        translate([0, 0, -1])
            cylinder(h=bh+2, r1=r1-thickness, r2=r2-thickness);
    }
    if(fillTop) {
        translate([0, 0, height-topHeight])
            cylinder(h=topHeight, r1=r2, r2=r2-0.5);
    }
}

module handle() {
    $fn=60;
    
    height = rounded ? h-1 : h;
    r1 = r + ht;
    r2 = r1-delta;
    d1 = 2*r1;
    d2 = 2*r2;
    
    //color("gray")
    translate([0, 0, rounded ? 0.5 : 0])
    difference() {
        union() {
            minkowski() {
                union() {
                    // Base
                    cylinder(height, r1, r1);
                    
                    // Bottom
                    translate([0, 0, 8]) cylinder(5, r1, r1+4);
                    translate([0, 0, 13]) cylinder(5, r1+4, r1+3);
                    translate([0, 0, 18]) cylinder(3, r1+3, r1);
                    
                    // Middle
                    for(i=[0: 4: 24]) {
                        translate([0, 0, height-30-i]) cylinder(2, r1+2, r1);
                        translate([0, 0, height-32-i]) cylinder(2, r1, r1+2);
                    }
                    // Button
                    difference() {
                        translate([r-4, -5, height-85]) cube([9, 10, 20]);
                        translate([r+8, -5, height-72])
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
            translate([0, 0, 3])
                threaded_rod(d=[d1, d1+2, d1+2], l=6, pitch=6);
        }
        translate([0, 0, -1])
            cylinder(height+2, r1-ht+tolerance+0.5, r2-ht+tolerance+0.5);
    }
}

module handleLid(r) {
    $fn = 80;
    r1 = r + ht;
    d1 = 2*r1;
    lidThickness = 3.2;
    
    //color("gray")
    translate( expand ? [0, 0, -1.5] : [0, 4*r, 0])
    difference() {
        cylinder(8, r1+lidThickness, r1+lidThickness+1);
        
        translate([0, 0, 1.1])
        cylinder(7, r1+1, r1+1);
        
        translate([0, 0, 5.01])
            threaded_rod(d=[d1+1, d1+3, d1+3], l=6, pitch=6, internal=true);
    }
}

function m(n) =  n<0 ? 0 : (1-2*abs($t-0.5))*n;

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
                //color("lightgreen")
                blade(h, r1, r2, t, (i==nblades-1? true : false) );
            }
        }
        
        handleLid(r);
    }
    
    // Cut in half to see the internals
    if (previewInside) {
        translate([0, -100, -600])
        cube([200, 200, (nblades+2)*h+600]);
    }
}
