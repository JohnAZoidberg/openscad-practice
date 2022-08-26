// Daniel Schaefer 2022

// How tall the block is
height = 3;
// How many columns of knobs
cols = 4;
// Wall strength
wall = 2;
// x distance between centers of bottom pins
pin_dist=3;
// Radius of pins in the middle on the bottom
pin_middle=sqrt((pin_dist/2)^2 + (pin_dist/2)^2)-1;


label = "ALLIECHU";

brick();

// Bottom pins on the top to check that they fit perfectly
// translate([0,0,3])
// mid_pins();

// Pins in the middle on the bottom
module mid_pins() {
    for (i = [0 : 2]) {
        translate([i * pin_dist + 3.5, 3.5, 0])
        difference() {
            cylinder(h=2, r=pin_middle, $fn=60);
            cylinder(h=2, r=0.8, $fn=60);
        }
    }
}

module top_pins() {
    // Top pins, two rows
    for (i = [0 : cols - 1]) {
        // First row
        translate([i * 3 + 2, 2, height]) {
            translate([0, 0, 1])
                linear_extrude(0.25)
                text(label[cols + i], size=1, halign="center", valign="center");
            cylinder(h=1, r=1, $fn = 60);
        }
    
        // Second row
        translate([i * 3 + 2, 5, height]) {
            translate([0, 0, 1])
                linear_extrude(0.25)
                    text(label[i], size=1, halign="center", valign="center");
            cylinder(h=1, r=1, $fn = 60);
        }
    }
}

module brick() {
    // Brick base
    difference() {
        cube([13,7,height]);
        translate([wall/2, wall/2, 0])
            cube([13 - wall, 7 - wall,height - 1]);
    };

    top_pins();
    
    mid_pins();
}
