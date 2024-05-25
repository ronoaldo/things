/* [Pallete Internal Size] */
width=120;
depth=100;
height=14;

/* [Settings] */
thickness=1.2;
clearance=0.4;

/* [Preview Before Print] */
preview=false;

/* [Hidden] */
rounded_offset=0.5;
spacing=2*thickness;

module box(w, d, h, t) {
    spacing=2*t;
    cut = 0.01;
    difference() {
        cube([w + spacing, d + spacing, h + t]);
        translate([t, t, t+cut]) cube([w, d, h]);
    }
}

module pallete() {
    minkowski() {
        sphere(r=0.5, $fn=16);
        box(width, depth, height, thickness-rounded_offset);
    }
}

module lid() {
    lid_w = width-rounded_offset*2;
    lid_d = depth-rounded_offset*2;
    lid_h = thickness;
    dxdy = clearance/2;
    translate([0, 0, height+spacing/2+4])
        minkowski() {
            sphere(r=0.5, $fn=16);
            
            union() {
                cube([lid_w+spacing, lid_d+spacing, lid_h]);
                
                translate([thickness+dxdy, thickness+dxdy, -thickness])
                    cube([lid_w-clearance, lid_d-clearance, thickness*2]);
            }
        }
}

pallete();
if (!preview) {
    // the height where the lid is originaly positioned
    dz = height+ (spacing/2) + 4 + thickness;
    rotate([180, 0, 0])
        translate([width+10, -depth-thickness, -(dz)])
            lid();
} else {
    lid();
}
