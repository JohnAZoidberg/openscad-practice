// A shelf
//
// The shelf that came with my tiny house wooden set. I measured it and tried
// to rebuild it in OpenSCAD.
//
// Daniel Schaefer 2022

// Thickness of the wood sheets
thickness = 0.15;
// Strength of the frame
strength = 0.4;

 // How far a plank is away from the next
plank_dist = 0.18;
// Horizontal plank width
plank_width = 0.5;
// Orthogonal plank width
ortho_plank_width = 0.3;

// Width (X-Size) of the entire structure
width = 6;
// Y-Size of the different layers
first_y = 4;
second_y = 2.2;
third_y = 1.7;
// Heights of the different layers
first_height = 2.7;
second_height = 3.2;
third_height = 2;

shelf();

module shelf() {
    translate([0, 0, first_height])
        floor(width, first_y);
    translate([0, 0, first_height+second_height])
        floor(width, second_y);
    translate([0, 0, first_height+second_height+third_height])
        floor(width, third_y);

    // Left and right side
    side();
    translate([width-thickness, 0, 0])
        side();
}

module floor(xlen, ylen) {
    planks = floor(ylen / (plank_width + plank_dist));

    for (i = [0 : planks - 1]) {
        translate([0, (plank_width + plank_dist) * i, 0])
            cube([xlen, plank_width, thickness]);
    }
    // One more plank to fit the remaining space
    last_p_width = ylen - planks * (plank_width + plank_dist);
    translate([0, (plank_width + plank_dist) * planks, 0])
        cube([xlen, last_p_width, thickness]);

    // Orthogonal planks. One on each side
    translate([0.6, 0, 0])
        cube([ortho_plank_width, ylen, thickness]);
    translate([xlen - ortho_plank_width - 0.6, 0, 0])
        cube([ortho_plank_width, ylen, thickness]);
}

module side() {
    side_piece(first_y, first_height, true, true);

    translate([0,0,first_height])
        side_piece(second_y, second_height, false, true);

    translate([0,0,first_height + second_height])
        side_piece(third_y, third_height, true, false);
}

module side_piece(width, height, fw_diag, bw_diag)  {
    // Side square with cutout (turns into frame)
    difference() {
        cube([thickness, width, height]);

        translate([0, strength, 0])
        cube([thickness, width-strength*2, height-strength]);

    };

    if (fw_diag)
        diagonal(width, height, forward=true);
    if (bw_diag)
        diagonal(width, height, forward=false);
}

module diagonal(width, height, forward) {
    // Put center of bar in the middle of square and then
    // rotate as the diagonal (hypotenuse of the triangle)
    hypotenuse = sqrt(width^2 + height^2);
    angle = forward ? -asin(width/hypotenuse) : asin(width/hypotenuse);
    translate([0.5*thickness, width / 2, height/2])
    rotate([angle, 0, 0])
        // Need to make it a bit shorter than the hypotenuse, so it doesn't protrude on the sides
        cube([thickness, strength, hypotenuse-strength*1.5], center=true);
}
