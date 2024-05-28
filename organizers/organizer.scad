/** [ Dimensions ] **/
// Box width (mm)
width = 90;
// Box height (mm)
height = 100;
// Box depth (mm)
depth = 270;

// Wall thickness (mm)
wall = 3;

/** [Hidden] **/
handle_height = 25;
handle_margin = 8;
handle_width = width - handle_margin*2 - handle_height;
corner_width = 2;

module handle(width, depth, height) {
    offset_x = handle_height/2 + handle_margin;
    offset_y = height - handle_margin - handle_height/2;
    offset_z = -depth-wall;
    
    rotate([90, 0, 0])
    translate([offset_x, offset_y, offset_z])
    linear_extrude(height=depth+3*wall)
    hull() {
        circle(d=handle_height);
        translate([handle_width, 0, 0])
            circle(d=handle_height);
    }
}

module decoration(width, depth, height) {
    decor_diameter = 12;
    spacing = 4;
    
    // Avoid half circles
    inner_depth = depth - 2*wall;
    inner_height = height - 2*wall;
    
    cols = floor((inner_depth)/ (decor_diameter+spacing));
    rows = floor((inner_height-spacing)/ (decor_diameter+spacing));
    
    yused = (cols*decor_diameter + (cols-1)*spacing);
    zused = (rows*decor_diameter + (rows-1)*spacing);
    
    // Center the decoration with an added offset
    yoffset = (inner_depth  - yused)/2 - spacing;
    zoffset = (inner_height - zused)/2 - spacing;
    
    union() {
        for(y = [1:cols]) {
            for (z = [1:rows]) {
                translate([
                    -wall,
                    yoffset + y*decor_diameter + (y-1)*spacing,
                    zoffset + z*decor_diameter + (z-1)*spacing
                ])
                //cube([width+2*t, decor_diameter, decor_diameter]);
                rotate([0, 90, 0])
                cylinder(h=width+2*wall, d=decor_diameter, center=false, $fn=36);
            }
        }
    }
}

module corner() {
    sphere(r=corner_width, $fn=8);
}

module filleted_cube(width, depth, height) {
    x = width - 2*corner_width;
    y = depth - 2*corner_width;
    z = height - 2*corner_width;
    
    translate([corner_width, corner_width, corner_width])
    hull() {
        // front face
        translate([0, 0, 0]) corner();
        translate([x, 0, 0]) corner();
        translate([x, 0, z]) corner();
        translate([0, 0, z]) corner();
        // back face
        translate([0, y, 0]) corner();
        translate([x, y, 0]) corner();
        translate([x, y, z]) corner();
        translate([0, y, z]) corner();
    }
}

module box(width, depth, height) {
    delta = 2*wall;
    difference() {
        difference() {
            // Outer
            filleted_cube(width, depth, height);
            // -Inner
            translate([wall, wall, wall])
                filleted_cube(width-delta, depth-delta, height-wall+corner_width);
        }
        // -Handle
        handle(width, depth, height);
        // Decoration
        decoration(width, depth, height);
    }
}

echo("Generating box", width, "x", height, "x", depth, "\n");
box(width, depth, height);
