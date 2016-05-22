function radius_to_balls(r_ball, r) = 180 / asin(r_ball / r);
function ball_to_radius(n, r) = r * sin(180 / n);

sphereFn = 6;//45
cylinderFn = 18;//45
genPin = 0;
module Bearing(outer, inner, attempt, gap, hole, height) 
{
	n = round(radius_to_balls(attempt, inner));
	r = ball_to_radius(n, inner);
	theta = 360 / n;
	pinRadius = 0.5 * r;
	// The pins:
	for(i = [0 : n])
		rotate(a = [0, 0, theta * i])
			translate([inner, 0, 0])
				union() 
    {
					sphere(r = r - 0.5*gap, center = true, $fn = sphereFn);
					assign(rad = pinRadius - gap)
	if( genPin )
	{
		cylinder(r1 = rad, r2 = rad, h = height, center = true, $fn = cylinderFn);
	}
	}
	// The inner race:
	difference() 
	{
		assign(rad = inner - pinRadius - gap)
			cylinder(r1 = rad, r2 = rad, h = height, center = true, $fn = cylinderFn);
		rotate_extrude(convexity = 10)
			translate([inner, 0, 0])
				circle(r = r + gap, $fn = 30);
		cylinder(r1 = hole, r2 = hole, h = height + 5, center = true, $fn = cylinderFn);
	}
	// The outer race:
	difference() 
	{
		cylinder(r1 = outer, r2 = outer, h = height, center = true, $fn = cylinderFn);
		assign(rad = inner + pinRadius + gap)
			cylinder(r1 = rad, r2 = rad, h = height + 5, center = true, $fn = cylinderFn);
		rotate_extrude(convexity = 10)
			translate([inner, 0, 0])
				circle(r = r + gap, $fn = 45);
	}
}
module Bearing625()
{
  color ("silver") difference()
  {
		cylinder(d = Bearing625Diameter(), h = Bearing625Height(),$fn=cylinderFn);
		translate([0,0,-0.1]) cylinder(d = 8, h = Bearing625Height()+0.3,$fn=cylinderFn);
  }
}

function Bearing625Height() = 5;
function Bearing625Diameter() = 16;

module Bearing623()
{
  color ("silver") difference()
  {
		cylinder(d = Bearing623Diameter(), h = Bearing623Height(),$fn=cylinderFn);
		translate([0,0,-0.1]) cylinder(d = 3, h = Bearing623Height()+0.3,$fn=cylinderFn);
  }
}

function Bearing623Height() = 4;
function Bearing623Diameter() = 10;

module Bearing624()
{
  color ("silver") difference()
  {
		cylinder(d = Bearing624Diameter(), h = Bearing624Height(),$fn=cylinderFn);
		translate([0,0,-0.1]) cylinder(d = 4, h = Bearing624Height()+0.3,$fn=cylinderFn);
  }
}

function Bearing624Height() = 5;
function Bearing624Diameter() = 13;
module Bearing608()
{
  color ("silver") difference()
  {
		cylinder(d = Bearing608Diameter(), h = Bearing608Height(),$fn=cylinderFn);
		translate([0,0,-0.1]) cylinder(d = 8, h = Bearing608Height()+0.3,$fn=cylinderFn);
  }
}
function Bearing608Height() = 7;
function Bearing608Diameter() = 22;

module Bearing688()
{
  color ("silver") difference()
  {
		cylinder(d = Bearing688Diameter(), h = Bearing688Height(),$fn=cylinderFn);
		translate([0,0,-0.1]) cylinder(d = 8, h = Bearing688Height()+0.3,$fn=cylinderFn);
  }
}
function Bearing688Height() = 5;
function Bearing688Diameter() = 16;

module Bearing6800()
{
  translate ([0,0,2.5]) color ("silver") Bearing(outer = Bearing608Diameter()/2, inner = 8, attempt = 2, gap = 0.2, height = Bearing6800Height(), hole = 5);
}
function Bearing6800Height() = 5;
function Bearing6800Diameter() = 19;

module BearingLM6UU()
{
  color ("silver") 
	{
		difference()
	{
		cylinder(d=BearingLM6UUDiameter(),h=BearingLM6UUHeight());
		translate([0,0,-1]) cylinder(d=6,h=19+2);
	}
	}
}
function BearingLM6UUHeight() = 19;
function BearingLM6UUDiameter() = 12;

module BearingF512M()
{
  color ("silver") 
	{
		difference()
		{
			union()
			{
				cylinder(d=12,h=1.5);
				translate([0,0,2.5]) cylinder(d=12,h=1.5);
			}
			translate([0,0,-1]) cylinder(d=5,h=4+2);
		}
	}
}
function BearingF512MHeight() = 4;
function BearingF512MDiameter() = 12;

Bearing625();
translate ([0,0,20]) Bearing623();
translate ([0,0,40]) Bearing608();
translate ([0,0,60]) Bearing6800();
translate ([0,0,80]) BearingLM6UU();
translate ([0,0,120]) BearingF512M();
translate ([0,0,140]) Bearing688();
translate ([0,0,160]) Bearing624();

// sizes from scs_uu.png in this directory
module SCSxUU(D=8,L=30,W=34,T=6,G=18,F=22,h=11,B=24,C=18,S1=4,L1=8,bHolesOnly=0)
{
	translate([-W/2,0,-h])
	{
		if( bHolesOnly )
		{
			// mount holes
			translate([W/2-B/2,L/2-C/2,-50]) cylinder(d=S1,h=50,$fn=32);
			// mount holes
			translate([W/2+B/2,L/2-C/2,-50]) cylinder(d=S1,h=50,$fn=32);
			// mount holes
			translate([W/2-B/2,L/2+C/2,-50]) cylinder(d=S1,h=50,$fn=32);
			// mount holes
			translate([W/2+B/2,L/2+C/2,-50]) cylinder(d=S1,h=50,$fn=32);
		}
		else
		{
			difference()
			{
				union()
				{
					cube([W,L,T]);
					translate([1,0,0]) cube([W-2,L,G]);
					translate([1,0,0]) cube([W-2,L,G]);
					translate([W/2-D,0]) cube([D*2,L,F]);
				}
				translate([W/2,-1,h]) rotate([-90,0,0]) cylinder(d=D,h=W+2);
				// mount holes
				translate([W/2-B/2,L/2-C/2,-1]) cylinder(d=S1-1,h=G+2,$fn=12);
				translate([W/2-B/2,L/2-C/2,-1]) cylinder(d=S1,h=h,$fn=12);
				// mount holes
				translate([W/2+B/2,L/2-C/2,-1]) cylinder(d=S1-1,h=G+2,$fn=12);
				translate([W/2+B/2,L/2-C/2,-1]) cylinder(d=S1,h=h,$fn=12);
				// mount holes
				translate([W/2-B/2,L/2+C/2,-1]) cylinder(d=S1-1,h=G+2,$fn=12);
				translate([W/2-B/2,L/2+C/2,-1]) cylinder(d=S1,h=h,$fn=12);
				// mount holes
				translate([W/2+B/2,L/2+C/2,-1]) cylinder(d=S1-1,h=G+2,$fn=12);
				translate([W/2+B/2,L/2+C/2,-1]) cylinder(d=S1,h=h,$fn=12);
			}
		}
	}
}

module SCS8UU(bHolesOnly=0)
{
	color("silver") SCSxUU(D=8,L=30,W=34,T=6,G=18,F=22,h=11,B=24,C=18,S1=4,L1=8,bHolesOnly=bHolesOnly);
}

translate([50,0,0]) SCS8UU();

module SCS6UU(bHolesOnly=0)
{
	color("silver") SCSxUU(D=6,L=25,W=30,T=6,G=15,F=18,h=9,B=20,C=15,S1=4,L1=8,bHolesOnly=bHolesOnly);
}

translate([50,0,30]) SCS6UU();
color("red") translate([90,0,0]) SCS6UU(bHolesOnly=1);

module shf8(bHolesOnly=0)
{
	if( bHolesOnly==1 )
	{
		translate([-16,0,-25.1]) cylinder(d=5.5,h=50);
		translate([16,0,-25.1]) cylinder(d=5.5,h=50);
		translate([0,0,-25.1]) cylinder(d=8,h=50);
	}
	else if( bHolesOnly==2 )
	{
		translate([-16,0,-25.1]) cylinder(d=5.5,h=50);
		translate([16,0,-25.1]) cylinder(d=5.5,h=50);
	}
	else
	{
		difference()
		{
			union()
			{
				hull()
				{
					translate([-16,0,0]) cylinder(d=10,h=10);
					translate([0,0,0]) cylinder(d=20,h=10);
					translate([16,0,0]) cylinder(d=10,h=10);
				}
				translate([-10,0,0]) cube([20,13,10]);
			}
			translate([-16,0,-0.1]) cylinder(d=5.5,h=50);
			translate([16,0,-0.1]) cylinder(d=5.5,h=50);
			translate([0,0,-0.1]) cylinder(d=8,h=50);
			translate([-12,10,5]) rotate([0,90,0]) cylinder(d=4,h=24);
		}
	}
}

translate([120,0,0]) shf8();

module kfl08(bHolesOnly=0)
{
	if( bHolesOnly==1 )
	{
		translate([-36.5/2,0,-25.1]) cylinder(d=5,h=50);
		translate([36.5/2,0,-25.1]) cylinder(d=5,h=50);
		translate([0,0,-25.1]) cylinder(d=8,h=50);
	}
	else if( bHolesOnly==2 )
	{
		translate([-36.5/2,0,-25.1]) cylinder(d=5,h=50);
		translate([36.5/2,0,-25.1]) cylinder(d=5,h=50);
	}
	else
	{
		difference()
		{
			union()
			{
				hull()
				{
					translate([-36.5/2,0,0]) cylinder(r=5.5,h=4);
					translate([0,0,0]) cylinder(r=13.5,h=4);
					translate([36.5/2,0,0]) cylinder(r=5.5,h=4);
				}
				translate([0,0,0]) cylinder(r=13,h=10);
				translate([0,0,0]) cylinder(d=8+4,h=13);
			}
			translate([-36.5/2,0,-25.1]) cylinder(d=5,h=50);
			translate([36.5/2,0,-25.1]) cylinder(d=5,h=50);
			translate([0,0,-25.1]) cylinder(d=8,h=50);
		}
	}
}

translate([180,0,0]) kfl08();

