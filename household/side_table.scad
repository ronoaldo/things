/* [Base Dimensions] */
width = 280;
depth = 280;

/* [Top] */
top_furniture = true;
top_height = 280;

/* [Middle] */
middle_furniture = true;
middle_height = 100;

/* [Bottom] */
bottom_furniture = true;
bottom_height = 220;

/* [Settings] */
thickness = 25;
corner_radius = 20;
tolerance = 0.2;

module rounded_cube(width, depth, height, corner_radius) {
    $fn = 120;
    
    h = height - 2*corner_radius;
    w = width  - 2*corner_radius;
    r = corner_radius;
    
    
    translate([0, depth, 0])
    rotate([90, 0, 0])
    linear_extrude(depth)
    hull() {
        translate([r,   r,   0]) circle(corner_radius);
        translate([r+w, r,   0]) circle(corner_radius);
        translate([r+w, r+h, 0]) circle(corner_radius);
        translate([r,   r+h, 0]) circle(corner_radius);
    }
}

module texture(tolerance=0) {
    texh = 3;
    texw = 10;
    texr = 1;
    
    start = thickness;
    end = width - thickness;
    increment = 2*texw;
    
    for(dx=[start: increment: end]) {
        translate([dx, 0, 0])
        union() {
            rounded_cube(texw, depth-tolerance, texh, texr);
            cube([texw, depth-tolerance, texr]);
        }
    }
}

module furniture(w, d, h) {
    union() {
        translate([0, tolerance/2, h])
            minkowski() {
                texture(tolerance=tolerance);
                sphere(r=tolerance/2, $fn=12);
            }
        difference() {
            rounded_cube(w, d, h,
                         corner_radius);
            
            translate([thickness/2, -thickness/2, thickness/2])
            rounded_cube(w - thickness, d + thickness, h - thickness,
                         corner_radius*0.75);
            
            minkowski() {
                texture();
                sphere(r=tolerance, $fn=12);
            }
        }
    }
}

union() {
    color("white")
    if(bottom_furniture)
        furniture(width, depth, bottom_height);
    
    color("gray")
    if(middle_furniture) {
        th = (bottom_furniture ? bottom_height : 0);
        translate([0, 0, th])
        furniture(width, depth, middle_height);
    }
    
    color("white")
    if(top_furniture) {
        th = (bottom_furniture ? bottom_height : 0)
            + (middle_furniture ? middle_height : 0);
        translate([0, 0, th])
        furniture(width, depth, top_height);
    }
}