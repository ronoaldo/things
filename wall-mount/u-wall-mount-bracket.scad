/* [Design] */
// Internal diameter for the mount
inner_diameter = 27;
// The thickness of the outer wall
thickness = 2;
// The total height of the mount
height = 20;
// If we must cut at "top" of the circle, to facilitate passing objects over it
top_cut = true;

$fn = 64;

module circular_mount() {
    _cut_width = inner_diameter+(2*thickness);
    _cut_height = height+thickness;
    _plate_height = inner_diameter * 1.2;
    _plate_width = inner_diameter * 1.6;
    union() {
        difference() {
            cylinder(h=height, d=inner_diameter + (2*thickness));
            translate([0, 0, thickness])
                cylinder(h=height, d=inner_diameter);
            if(top_cut) {
                translate([-(_cut_width*1.1), -(_cut_width/2), -0.01])
                cube([_cut_width, _cut_width, _cut_height]);
            }
        }
        translate([ -_plate_height/3, -_plate_width/2, 0])
        cube([_plate_height, _plate_width, thickness]);
    }
}

translate([0, 0, height/2]) rotate([0, 90, -90])
circular_mount();