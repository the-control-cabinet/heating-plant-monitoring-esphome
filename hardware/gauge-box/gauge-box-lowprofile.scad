// Low-profile junction box for 4 x WAGO 221-412 (pressure gauge ends)
// Wagos sit at the back, levers up, wire entries facing the front space.
// Cable entries: one on each side wall, in the front space.
// Friction-fit lid with an inner skirt. Two countersunk wall-mount holes.
// Print base and lid flat, no supports, PETG/PLA, 0.2 mm layers.

/* [Wago 221-412 (measure yours)] */
wago_w = 13.1; wago_l = 18.3; wago_h = 8.2; clear = 0.35;
/* [Box] */
n = 4;
inner_h   = 15;     // inside height, base to underside of lid (Wago 8.2 + room for parts)
front_gap = 16;     // space in front of the Wagos for ferrules and bends
wall = 2; base_t = 2; lid_t = 1.8; skirt = 2.5; fit = 0.25;
cable_d = 5.2;      // 5.2 boiler, 5.9 cylinders
cable_z = 5.5;      // height of cable-hole centre above the inside floor
pocket_h = 4.5; rib = 1.6; bump = 0.35;
screw_d = 4.2; csk_d = 8.4;
part = "both";      // "base", "lid" or "both"
$fn = 48;

slot_w = wago_w + 2*clear; slot_l = wago_l + 2*clear;
inner_w = n*slot_w + (n-1)*rib + 4;
inner_d = slot_l + front_gap + 1;
ow = inner_w + 2*wall; od = inner_d + 2*wall; oh = base_t + inner_h;

module base(){
  difference(){
    cube([ow, od, oh]);
    translate([wall, wall, base_t]) cube([inner_w, inner_d, inner_h + 1]);
    // cable entries, in the front space
    for (x=[-1, ow-wall-1]) translate([x, wall + front_gap/2 + 1, base_t + cable_z]) rotate([0,90,0]) cylinder(d=cable_d, h=wall+2);
    // wall-mount holes (countersunk from inside)
    for (x=[wall+10, ow-wall-10]) translate([x, wall + front_gap/2, -1]) {
      cylinder(d=screw_d, h=base_t+2);
      translate([0,0,base_t+1-(csk_d-screw_d)/2]) cylinder(d1=screw_d, d2=csk_d, h=(csk_d-screw_d)/2+0.01);
    }
  }
  // Wago pockets at the back: ribs between slots + back stop, bumps for retention
  y0 = wall + front_gap + 1; // front edge of pockets
  for (i=[0:n]) {
    x = wall + 2 + i*(slot_w + rib) - rib;
    if (i>0 && i<n) translate([x, y0, base_t]) cube([rib, slot_l, pocket_h]);
  }
  for (i=[0:n-1]) {
    x = wall + 2 + i*(slot_w + rib);
    for (yb=[y0 + slot_l*0.35, y0 + slot_l*0.75]) {
      if (i>0) translate([x, yb, base_t + pocket_h - 1.2]) rotate([90,0,0]) cylinder(r=bump, h=4, center=true);
      if (i<n-1) translate([x + slot_w, yb, base_t + pocket_h - 1.2]) rotate([90,0,0]) cylinder(r=bump, h=4, center=true);
    }
  }
  // low front lip per slot (stops the Wago sliding forward, below the wire entries)
  for (i=[0:n-1]) translate([wall + 2 + i*(slot_w + rib), y0 - 1.2, base_t]) cube([slot_w, 1.2, 1.5]);
}

module lid(){
  cube([ow, od, lid_t]);
  translate([wall+fit, wall+fit, lid_t]) difference(){
    cube([inner_w-2*fit, inner_d-2*fit, skirt]);
    translate([1.2,1.2,-1]) cube([inner_w-2*fit-2.4, inner_d-2*fit-2.4, skirt+2]);
  }
}

if (part=="base" || part=="both") base();
if (part=="lid") lid();
if (part=="both") translate([0, od + 8, 0]) lid();
echo(str("Outside: ", ow, " x ", od, " x ", oh + lid_t, " mm (with lid)"));
