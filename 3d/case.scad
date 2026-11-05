use <fillets3d.scad>
height = 28.8;
depth = 13.9;
width = 84.9;

topBottomFillet(b = 0, t = depth, r = 2, s = 200)
cube([width, height, depth]);