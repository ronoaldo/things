/* [Design] */
// Internal diameter for the holder
inner_diameter = 27;
// The thickness of the outer wall
thickness = 2;
// The total height of the holder
height = 20;
// If we must cut at "top" of the circle, to facilitate passing objects over it
top_cut = true;

$fn = 64;

module circular_mount() {
    difference() {
        cylinder(h=height, d=inner_diameter + (2*thickness));
        translate([0, 0, thickness])
            cylinder(h=height, d=inner_diameter);
        if(top_cut) {
            _cut_width = inner_diameter+(2*thickness);
            _cut_height = height+thickness;
            translate([-(_cut_width*1.1), -(_cut_width/2), -0.01])
            cube([_cut_width, _cut_width, _cut_height]);
        }
    }
}

circular_mount();