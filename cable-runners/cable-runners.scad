/* [Shape] */
// Internal square space for each tube
internal_space = 15;
// Perimeter thickness for each tube
thickness  = 0.9;
// Tube length, halved for curved tubes
length = 50;
// Increase thickness by 0.5mm and is slow
rounded = false;

/* [Build plate] */
line_tubes = 1; // [0,1,2,3,4]
t_tubes = 1; // [0,1,2,3,4]
curved_tubes = 1; // [0,1,2,3,4]
curved_tubes_with_left_cut = 1; // [0,1,2,3,4]

/* [Rendering] */
// The number of faces to draw for the curved shape
$fn = 120; // [30, 60, 90, 120]

/* [Hidden] */
cutw = internal_space/2;

// makeTube creates a simple tube using the specified length
// and global thickness.
module makeTube(length = 50) {
    w = internal_space + 2*thickness;
    difference() {
        cube([w, length, w]);
        translate([thickness, -1, thickness])
            cube([internal_space, length+2, internal_space]);
    }
}

// tube creates a tube shape with the specified length and 
module tube(length=50, cut=true) {
    if (cut) {
        difference() {
            makeTube(length);
            // Corte traseiro para passar fios
            translate([cutw/2+thickness, -1, -1])
                cube([cutw, length+2, 2*thickness+2]);
        }
    } else {
        makeTube(length);
    }
}

// tube_t makes a T shaped tube
module tube_t(length = 50) {
    y = length/2 - internal_space/2;
    l = cutw;
    difference() {
        tube(length=length);
        translate([internal_space/2, y, -1])
            cube([internal_space, internal_space, internal_space+thickness+1]);
    }
    translate([internal_space + cutw + thickness*2, y-thickness, 0]) 
        rotate([0, 0, 90])
        tube(length=l);
    
    innerCorner = (internal_space - cutw)/2;
    translate([internal_space-cutw/2+thickness, length/2-innerCorner*2, 0])
        cube([innerCorner+thickness, innerCorner, thickness]);
    translate([internal_space-cutw/2+thickness, length/2+innerCorner, 0])
        cube([innerCorner+thickness, innerCorner, thickness]);
}

// tube_90 makes a curved tube with 90 degrees rotation. length is halved
// and cutLeft, if specified, switches the cut from bottom to the inner of the
// curve.
module tube_90(length = 50, cutLeft=false) {
    c1 = length/2;
    difference() {
        $v = cutLeft ? [length+thickness, length/2+thickness+2, cutw] : [0, 0, 0];
        union() {
            // tubes laterais
            tube(length=c1, cut=!cutLeft);
            translate([c1+internal_space+thickness, c1-thickness, 0])
                rotate([0, 0, 90])
                tube(length=c1, cut=!cutLeft);
            
            // Cantoneira
            difference() {
                translate([internal_space+thickness*2, c1-thickness, 0])
                    rotate([0, 0, 90])
                    rotate_extrude(angle=360)
                    difference() {
                        square(internal_space + 2*thickness);
                        translate([thickness, thickness, 0]) square(internal_space);
                        translate([cutw/2 + thickness, 0, 0]) square(cutw);
                    }
                translate([0,0,-1])
                    cube([length, c1, internal_space+thickness*2+2]);
                translate([internal_space+thickness*2,0,-1])
                    cube([length, length, internal_space+thickness*2+2]);
            }
        }
        translate([thickness*2, -1, cutw/2+thickness])
            cube($v);
    }
}

module applyRounded() {
    if (rounded) {
        minkowski() {
            children();
            sphere(0.25, $fn=6);
        }
    } else {
        children();
    }
}

// Draw all shapes on build plate

offSet = thickness*2 + internal_space + 10;

if(line_tubes > 0) {
    for (i=[0:line_tubes-1]) {
        color("white")
            translate([i*offSet, 0, 0])
            applyRounded()
            tube(length = length);
    }
}

if(t_tubes > 0) {
    for (i=[0:t_tubes-1]) {
        color("white")
            translate([i*offSet, length+20, 0])
            applyRounded()
            tube_t(length = length);
    }
}

if(curved_tubes > 0) {
    for(i=[0:curved_tubes-1]) {
        $x = line_tubes*offSet + 10 + 2 * i * offSet;
        color("white")
            translate([$x, 0, 0])
            applyRounded()
            tube_90(length=length);
    }
}

if(curved_tubes_with_left_cut>0) {
    for(i=[0:curved_tubes_with_left_cut-1]) {
        $x = t_tubes*offSet + 10 + 2 * i * offSet;
        color("white")
            translate([$x, length+20, 0])
            applyRounded()
            tube_90(length=length, cutLeft = true);
    }
}