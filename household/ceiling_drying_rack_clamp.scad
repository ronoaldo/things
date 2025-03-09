diameter = 16.5;
clearance = 3;
width = 15;
thickness = 2;
brace_length = 15;
brace_hole_diameter = 5;
detail_level = 64;

inner_diameter = diameter + clearance;

module donut(radius=5, border=1) {
    rotate_extrude(convexity=10, $fn=detail_level)
        translate([radius-border/2, 0, 0])
            circle(d=border, $fn=16);
}

module rounded_cube(x, y, z, rounded_corner) {
    _x = x - rounded_corner;
    _y = y - rounded_corner;
    _z = z - rounded_corner;
    hull() {
        for(pos = [
           // Front-face
           [ 0,  0,  0],
           [ 0,  0, _z],
           [_x,  0, _z],
           [_x,  0,  0],
           // Back-face
           [0,  _y,  0],
           [0,  _y, _z],
           [_x, _y, _z],
           [_x, _y,  0]
        ]) {
            translate(pos) sphere(d=rounded_corner, $fn=16);
        }
    }
}

module clamp() {
    rounded_corner=0.5;
    radius = inner_diameter/2 + thickness - rounded_corner;

    union() {
        difference() {
            hull() {
                donut(radius=radius, border=rounded_corner);

                translate([0, 0,  width])
                donut(radius=radius, border=rounded_corner);
            }
            translate([0, 0, -2*rounded_corner], $fn=detail_level)
            cylinder(h=width+4*rounded_corner, d=inner_diameter);

            translate([0, 0, -thickness])
            cube([inner_diameter+2*thickness, inner_diameter+2*thickness, width+2*thickness]);
        }

        translate([0, inner_diameter/2, 0])
        rotate([0, 0, 45])
            rounded_cube(brace_length, thickness, width+rounded_corner, rounded_corner);

        // h^2 = a^2 + b^2, solve for a when b=a
        cat = sqrt( (pow(thickness, 2)) / 2 );
        translate([inner_diameter/2+cat-rounded_corner/2, -cat+rounded_corner, 0])
        rotate([0, 0, 45])
            rounded_cube(brace_length, thickness, width+rounded_corner, rounded_corner);
    }
}

difference() {
    rotate([0, 0, -45])
    clamp();


    cut_length = inner_diameter+thickness;
    brace_start = sqrt( pow(inner_diameter/2, 2) / 2 ) ;

    translate([brace_start+brace_length/2, -cut_length/2, width/2])
    rotate([0, 90, 90])
    cylinder(d=brace_hole_diameter, h=cut_length, $fn=detail_level);
}