boxHeight = 135;
boxSize = 100;
thickness = 2; // [4:20]
rotation = 90; // [15:45]

if(thickness > 0) {
    difference() {
        linear_extrude(height=boxHeight, center=true, twist=rotation, slices=boxHeight)
        square(boxSize, center=true);

        rotate([0, 0, -thickness*(rotation/boxHeight)])
        translate([0, 0, thickness])
        linear_extrude(height=boxHeight, center=true, twist=rotation, slices=boxHeight)
        square(boxSize-(2*thickness), center=true);
    }
} else {
    linear_extrude(height=boxHeight, center=true, twist=rotation, slices=boxHeight)
    square(boxSize, center=true);
}