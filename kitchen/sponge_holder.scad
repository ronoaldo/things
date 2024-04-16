/* [Sponge dimensions] */
width=76.0;
depth=110.0;
height=26.0;

// [Holder settings]
// Holder thickness
thickness=2.0;
// Number of inner grid bars
grid_count = 10.0;

/* [Hidden] */
_t = thickness - 0.5;
holder_w = width + (2*_t);
holder_d = depth + (2*_t);
holder_h = height/2 + (2*_t);

cut = 0.1;

// Grid
total_grids = grid_count*2 + 1;
grid_width = width / total_grids;

// Holder
module holder() {
    difference() {
        cube([holder_w, holder_d, holder_h]);
        
        translate([_t, _t, _t])
            cube([width, depth, height]);
        
        translate([_t, _t, -cut])
        union() {
            for (g = [0:total_grids-1]) {
                if (g % 2 == 0) {
                    translate([g*grid_width, 0, 0])
                    cube([grid_width, depth, 3*_t]);
                }
            }
        }
    }
}

minkowski() {
    holder();
    sphere(0.5, $fn=10);
}