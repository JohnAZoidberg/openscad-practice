// USB-C Tofu Brick with US/Taiwan Type-A wallplug
// NOT proportional, no measurements were done.
//
// Alison Chu & Daniel Schaefer 2022

$fn=60;

height =15; // z-len
width  =6;  // x-len
depth  =10; // y-len

// Shift below axes
shift=-20;

// Rotate and animate
// Use 60 FPS and 360 Steps
$vpt = [0,0,shift]; // Move to focus on object
$vpr = [60, 180, 360 * $t]; // Flip around(180) and rotate around it
$vpd = 100;

// Shift to the origin
translate([-width/2, -depth/2, shift])
difference() {
    tofu_usb_c();

    // Text engraving
    translate([0,depth/2,5])
    rotate([-90,0,90])
    linear_extrude(0.5)
    text("A+D", size=2.5, valign="center", halign="center");
}

module brick_with_prongs() {
  // Brick with rounded edges
  minkowski(){
      cube([width,depth,height/2]);
      cylinder(h=height/2, r=0.5);
  };
  
  // Prongs
  prong_height=4;
  translate([width/2,3,height+prong_height/2]) {
    difference() {
      // Both prongs
      union() {
        cube([2,0.5,prong_height], center=true);   
        translate([0,4,0])
        cube([2,0.5,prong_height], center=true);
      }

      // Cut through both with a long cylinder
      translate([0,0,0.75])
      rotate([90,0,0])
      cylinder(h=10,r=0.5,center=true);
    }
  }
}

module tofu_usb_c() {
  difference() {
    brick_with_prongs();
  
    // Cut out USB-C hole
    translate([width/2, depth/2, 0]) {
      minkowski(){
          cube([0.1,1.5,2], center=true);
          cylinder(h=0.5, r=0.5);
      };
    }
  }
  
  // Add USB-C prong in the middle
  translate([width/2, depth/2-0.5, 0.25])
  minkowski(){
      cube([0.1,1,2]);
      cylinder(h=0.5, r=0.125);
  };
};
