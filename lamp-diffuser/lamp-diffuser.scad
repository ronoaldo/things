/* Hidden */
lamp_outer_diameter = 125;
lamp_spacing = 40;
lamp_border_thickness = 2.8;

lampshade_thickness = 0.4;

$fn = 256;

module mount_clip() {
    hole = lamp_border_thickness/2 + 0.2;
    border = lamp_border_thickness;
    
    cut_x = 2*hole+2*border;
    
    difference() {
        cylinder(
            h=border,
            r=hole+border);
        translate([0, 0, -0.5])
        cylinder(
            h=border+1,
            r=hole);
        translate([-cut_x/2, 0.55*hole, -0.5])
            cube([cut_x, hole + border, border+1]);
    }
}

module lamp_cover() {
    radius = lamp_outer_diameter/2;
    t = lamp_border_thickness/2;
    union() {
        difference() {
            cylinder(
                h = lamp_spacing,
                r1 = radius,
                r2 = radius*0.8);
            translate([0, 0, -0.01])
            cylinder(
                h = lamp_spacing-lampshade_thickness,
                r1 = radius-t,
                r2 = radius*0.8-lampshade_thickness);
        }
        // Clips
        translate([radius-t/2, 0, -t]) rotate([-90, 0, 0]) mount_clip();
        translate([-radius+t/2, 0, -t]) rotate([-90, 0, 0]) mount_clip();
        translate([0, radius-t/2, -t]) rotate([-90, 0, 90]) mount_clip();
        translate([0, -radius+t/2, -t]) rotate([-90, 0, 90]) mount_clip();
    }
}

rotate([180, 0, 0]) lamp_cover();