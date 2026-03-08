aq_width = 500;
aq_depth = 310;
aq_height = 310;

watterfall_depth = 65;
watterfall_hgith = 40;

led_strip_depth = 120;
led_strip_height = 20;

aq_border_min = 10;
aq_border_max = 35;

CUT_OFFSET=100;
DEBUG=false;

module c(rgb, alpha=1) {
    if (DEBUG) {
        children();
    } else {
        color(rgb, alpha=alpha)
        children();
    }
}

module aquarium() {
    difference() {
        cube([
            aq_width+2*aq_border_min,
            aq_depth+2*aq_border_min,
            aq_height+2*aq_border_min
        ]);
        translate([aq_border_min,aq_border_min,aq_border_min+CUT_OFFSET])
        cube([aq_width, aq_depth, aq_height]);
    }
}

module watterfall() {
    cube([aq_width, watterfall_depth, watterfall_hgith]);
}

module led_strip() {
    cube([aq_width, led_strip_depth, led_strip_height]);
}

c("black")
translate([
    aq_border_min,
    aq_depth - watterfall_depth,
    aq_height+2*aq_border_min
])
%watterfall();

c("gray")
translate([
    aq_border_min,
    aq_depth/2 - led_strip_depth/2,
    aq_height+2*aq_border_min
])
%led_strip();

c("blue", alpha=0.6)
%aquarium();