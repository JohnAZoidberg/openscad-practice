// Framework Computer Screwdriver
// Measured it and roughly tried to rebuild it in OpenSCAD.
//
// Alison Chu & Daniel Schaefer 2022

$fn = 60;
tip_l = 1.5;
length = 10.7;
cut_length = 4;

thick_r = 0.5;
thin_r = 0.4;
triangle_width = sqrt(cut_length^2 - thick_r^2);

tip_thick_r = 1.0 / 2;
tip_thin_r = 0.7 / 2;

long_top_cut = 6.5;

text_height = 0.3;

transition_l = 0.2;

// Tip
difference() {
    translate([-tip_l-transition_l, 0, thick_r])
    rotate([0, 90, 0])
    cylinder(r1=tip_thin_r, r2=tip_thick_r, h=tip_l);

    // Hexagonal hole
    translate([-tip_l-1, 0, thick_r])
    rotate([0, 90, 0])
    cylinder(r=tip_thin_r-0.1, h=tip_l+1, $fn=6);
}

// Transition part between tip and handle
translate([-transition_l, 0, thick_r])
rotate([0, 90, 0])
cylinder(r1=tip_thick_r, r2=thin_r, h=transition_l);

// Handle
difference() {
    union() {
        translate([0, 0, thick_r])
            rotate([0, 90, 0])
            cylinder(r1=thin_r, r2=thick_r, h=length/2);

        translate([length/2, 0, thick_r])
            rotate([0, 90, 0])
            cylinder(r2=thin_r, r1=thick_r, h=length/2);
    }

    translate([length - triangle_width + 0.01, 0, 0])
        triangle();

    rotate([180, 0, 0])
    translate([length - triangle_width + 0.01, 0, -thick_r*2])
        triangle();

    // Bottom flat cut
    translate([length/2, 0, -thick_r+0.06])
    cube([long_top_cut, thick_r*2, thick_r*2], center=true);

    // Top flat cut
    translate([length/2, 0, 3*thick_r-0.06])
    cube([long_top_cut, thick_r*2, thick_r*2], center=true);

    // framework name
    translate([length/2, -thick_r+0.05, thick_r])
    rotate([90, 0, 0])
    linear_extrude(0.1)
        text(text="framework", size=text_height, halign="center", valign="center", spacing=1.1);
}

module triangle() {
    linear_extrude(thick_r*2)
    polygon(points=[
        [triangle_width, 0],
        [triangle_width, thick_r],
        [0, thick_r]],
        paths=[[0,1,2]]);
}