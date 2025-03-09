internal_drawer_width = 310;
internal_drawer_depth = 450;
internal_drawer_height = 90;

drawer_thickness = 12;
plate_thickness = 3;

module drawer() {
    w = internal_drawer_width;
    d = internal_drawer_depth;
    h = internal_drawer_height;
    t = drawer_thickness;
    difference() {
        cube([w+2*t, d+2*t, h+t]);
        translate([t, t, t+0.01])
            cube([w, d, h]);
    }
}

module plate(length) {
    d = plate_thickness;
    fn = 32;
    h1 = internal_drawer_height - d;
    h2 = length - d;
    
    translate([d/2, 0, d/2])
    union() {
        hull() {
            translate([0, 0, 0])
                cylinder(h=h1, d=d, $fn=fn);
            translate([h2, 0, 0])
                cylinder(h=h1, d=d, $fn=fn);
        }
       
        hull() {
            translate([0, 0, 0]) rotate([0, 90, 0])
                cylinder(h=h2, d=d, $fn=fn);
            translate([0, 0, h1]) rotate([0, 90, 0])
                cylinder(h=h2, d=d, $fn=fn);
        }
        
        for(pos = [
            [0,  0, 0],
            [0,  0, h1],
            [h2, 0, h1],
            [h2, 0, 0],
        ]) {
            translate(pos) sphere(d=d, $fn=fn);
        }
    }
}

module silverware() {
}

//color("#FFFFE5")
%drawer();

_off = drawer_thickness;
for (i = [1, 2, 3]) {
    translate([_off, i*100+_off, _off]) plate(250);
}

_off2 = plate_thickness/2;
translate([_off+250-_off2, _off+_off2, _off]) rotate([0, 0, 90])
    plate(300);

