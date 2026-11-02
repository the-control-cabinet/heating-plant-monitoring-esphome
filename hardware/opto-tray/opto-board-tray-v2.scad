// Snap-in tray v2 for the Hailege 8-channel AC 220V optocoupler board
// (H-1-1832-8CH). One end slides under a fixed lip; the other end snaps
// past a horizontal flexure clip (it bends sideways, in the plane of the
// print layers, so it doesn't snap off like a vertical clip).
// v2 changes: +1 mm width clearance, 0.5 mm extra headroom under the lip and
// hook (PCB measured 1.65 mm), clip redesigned as a horizontal flexure.
// All dimensions in mm. Print flat on the bed, no supports. PETG preferred.

/* [Board] */
board_l   = 138.0;   // long side
board_w   = 56.0;    // short side
board_t   = 1.65;    // PCB thickness (measured)
clear_l   = 0.3;     // clearance each end (long direction)
clear_w   = 0.8;     // clearance each side (width): v1 was 1 mm too tight overall

/* [Tray] */
floor_t   = 2.5;
standoff  = 8.0;     // gap under the PCB
wall_t    = 2.0;
corner_pad = 9;
corner_guide = 12;
end_ledge = 3.0;
headroom  = 0.5;     // vertical gap between PCB top and the lip/hook undersides

/* [Retention] */
lip       = 2.0;     // fixed lip overhang
hook      = 1.5;     // clip hook overhang over the PCB end
flex_len  = 32;      // flexure arm length (longer = softer)
flex_t    = 1.8;     // flexure arm thickness (in the print plane)
hook_len  = 8;       // hook length at the free end of the arm
gap       = 0.8;     // clearance around the flexure arm

/* [Screw tabs] */
tab_l     = 14;
hole_d    = 3.6;
csk_d     = 7.2;
hole_off  = 9;

$fn = 40;

in_l = board_l + 2*clear_l;
in_w = board_w + 2*clear_w;
out_l = in_l + 2*wall_t;
out_w = in_w + 2*wall_t;
pcb_z = floor_t + standoff;
top_z = pcb_z + board_t;
lip_z = top_z + headroom;            // underside of lip and hook
wall_h = lip_z + 1.6;                // end wall height (lip thickness 1.6)

yc = out_w/2;
arm_x0 = out_l - wall_t;             // arm inner face = wall inner face
arm_y0 = yc - flex_len/2;            // root end
arm_y1 = yc + flex_len/2;            // free end

module screw_holes() {
    for (x = [-tab_l/2, out_l + tab_l/2])
        for (y = [hole_off, out_w - hole_off]) {
            translate([x, y, -1]) cylinder(d = hole_d, h = floor_t + 2);
            translate([x, y, floor_t - (csk_d - hole_d)/2])
                cylinder(d1 = hole_d, d2 = csk_d, h = (csk_d - hole_d)/2 + 0.01);
        }
}

module body() {
    // base plate with tabs
    translate([-tab_l, 0, 0]) cube([out_l + 2*tab_l, out_w, floor_t]);
    // corner pads
    for (x = [wall_t, out_l - wall_t - corner_pad])
        for (y = [wall_t, out_w - wall_t - corner_pad])
            translate([x, y, 0]) cube([corner_pad, corner_pad, pcb_z]);
    // short-end ledges (clip end stops short of the arm)
    translate([wall_t, wall_t, 0]) cube([end_ledge, in_w, pcb_z]);
    translate([out_l - wall_t - end_ledge, wall_t, 0]) cube([end_ledge - gap, in_w, pcb_z]);
    // corner guides on the long sides (up to PCB top only)
    for (x = [0, out_l - corner_guide])
        for (y = [0, out_w - wall_t])
            translate([x, y, 0]) cube([corner_guide, wall_t, top_z]);
    // lip end wall + lip
    cube([wall_t, out_w, wall_h]);
    translate([wall_t - 0.01, wall_t, lip_z]) cube([lip, in_w, 1.6]);
    // clip end wall (the flexure is cut out of it below)
    translate([out_l - wall_t, 0, 0]) cube([wall_t, out_w, wall_h]);
}

module flexure_cut() {
    // frees the arm from the floor, the tab and the rest of the wall,
    // leaving it attached only at its root end (arm_y0)
    // outer slot (between arm and tab/base)
    translate([arm_x0 + flex_t, arm_y0, -1]) cube([gap + wall_t, flex_len + gap, wall_h + 2]);
    // slot at the free end
    translate([arm_x0 - 0.01, arm_y1, -1]) cube([wall_t + gap + 0.02, gap, wall_h + 2]);
    // floor under the arm, so the arm stands on the bed and flexes freely
    translate([arm_x0 - gap, arm_y0, -1]) cube([flex_t + 2*gap, flex_len, floor_t + 1.01]);
}

module flexure_arm() {
    // the arm: stands on the bed, bends in x (outwards) as the board goes in
    translate([arm_x0, arm_y0, 0]) cube([flex_t, flex_len, wall_h]);
    // hook at the free end, flat underside at lip_z, ramp above for snap-in
    translate([arm_x0, arm_y1 - hook_len, lip_z])
        rotate([-90, 0, 0]) mirror([0,1,0])
            linear_extrude(hook_len) polygon([[0.01, 0], [-hook, 0], [0.01, 2.4]]);
}

difference() {
    union() {
        difference() { body(); flexure_cut(); }
        flexure_arm();
    }
    screw_holes();
}
