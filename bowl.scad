// rotation step
rs = 360/24;

// radius
r = 10;

// number of rings
nr = 14;

// number of segments
seg = 12;

// base plate radius
br = 4;

// plywood height
layerh = .3;

// delta
delta = .001;

module ring(inner_radius, w=1, s=seg) {
  difference() {
    circle(inner_radius + w, $fn=s);
    circle(inner_radius + delta, $fn=s);
  }
}

module ring_i(i, radius=r, base_radius=br, num_rings=nr, s=seg) {
  w = (radius - base_radius) / num_rings;
  ring(base_radius + i * w, w, s=s);
  echo(w);
}

module ring_i_glue(i, radius=r, base_radius=br, num_rings=nr, s=seg, rotstep=rs) {
  intersection() {
    ring_i(i, radius, base_radius, num_rings, s);
    rotate([0, 0, rotstep])
    ring_i(i+1, radius, base_radius, num_rings, s);
  }
}

module stencil(radius=r, base_radius=br, num_rings=nr, s=seg) {
  for (i = [0:num_rings-1]) {
    ring_i(i, radius=radius, base_radius=base_radius, num_rings=num_rings, s=s);
  }
}

module preview(radius=r, base_radius=br, num_rings=nr, s=seg, rotstep=rs) {
  linear_extrude(layerh)
  circle(base_radius, $fn=s);
  for (i = [0:num_rings-1]) {
    rotate([0, 0, rotstep*(i+1)])
    translate([0, 0, layerh*(i+1)])
    linear_extrude(layerh)
    ring_i(i, radius=radius, base_radius=base_radius, num_rings=num_rings, s=s);
  }
}

module glue_areas(radius=r, base_radius=br, num_rings=nr, s=seg, rotstep=rs) {
  for (i = [-1:num_rings-2]) {
    ring_i_glue(i, radius=radius, base_radius=base_radius, num_rings=num_rings, s=s, rotstep=rotstep);
  }
}

preview();
//stencil();
//glue_areas();