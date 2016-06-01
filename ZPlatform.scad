// Author: Pavlo Gryb (psg416@gmail.com)

use <Modules/Pulley_T-MXL-XL-HTD-GT2_N-tooth.scad>
use <Modules/ISOThread.scad>
use <Modules/Bearings.scad>
use <Modules/EndStoppers.scad>
use <Modules/Write.scad/Write.scad>
include <Modules/MCAD/stepper.scad>
use <Modules/HotEnds.scad>
use <Modules/LCD.scad>
use <Modules/Misc.scad>
use <Modules/Profiles.scad>
include <Modules/dimlines.scad>
include <Modules/TextGenerator.scad>
use <Modules/BezierScad.scad>

drawArray = [];//[1,2,3,4,5];//[1,7,8];


DIM_LINE_WIDTH = 1;
DIM_HEIGHT = 0.1;
DIM_TEXT_RENDER = 1;

$fn=32;

holes = 2.5;

module BearingHolderFull()
{
union()
{
	difference()
	{
		union()
		{
		translate([-5-3-2,0,0]) cube([10+3+3+2+2,7,13]);
		translate([8,7/2,0])	cylinder(d=8,h=13);
		translate([-8,7/2,0])	cylinder(d=8,h=13);
		}
		translate([0,-1,5])  rotate([-90,0,0]) cylinder(d=10.2,h=10);
		translate([-5-3/2-0.5,7/2,-5])  cylinder(d=3.5,h=50);
		translate([5+3/2+0.5,7/2,-5])  cylinder(d=3.5,h=50);
	}
}
}


module BearingHolder(partIndex)
{
	if( partIndex==-1 || partIndex==1 )
	{
		color("green") intersection()
		{
			BearingHolderFull();
			translate([-15,-15,0]) cube([30,30,5]);
		}
	}
	if( partIndex==-1 || partIndex==2 )
	{
		color("blue") intersection()
		{
			BearingHolderFull();
			translate([-15,-15,5]) cube([30,30,20]);
		}
	}
}


module plateMount()
{
	difference()
	{
	union()
	{
		hull()
		{
	translate([0,0,5]) rotate([-90,0,0]) cylinder(d=9.5,h=10);
	translate([-1,0,5]) rotate([-90,0,0]) cylinder(d=9.5,h=10);
		}
	hull()
	{
	translate([0,0,4]) rotate([-90,0,0]) cylinder(d=7.5,h=10);
	translate([-12,0,4]) rotate([-90,0,0]) cylinder(d=7.5,h=10);
	}
}
		translate([0,-1,5]) rotate([-90,0,0]) cylinder(d=3.5,h=50);
		translate([-4,-1,0]) mirror([1,0,0]) cube([20,20,3.5]);
		//translate([-24,0,0]) cube([20,20,3.5]);
		translate([-8,5,0]) rotate([0,0,0]) cylinder(d=3,h=50);

}

}

module plateMount2()
{
	difference()
	{
	union()
	{
		hull()
		{
	translate([0,0,5]) rotate([-90,0,0]) cylinder(d=8.5,h=10);
	//translate([1,7,5]) rotate([-90,0,0]) cylinder(d=7,h=10);
	//#translate([0,7,5]) rotate([-90,0,0]) cylinder(d=7,h=10);
		}
	hull()
	{
	translate([0,0,7]) rotate([-90,0,0]) cylinder(d=7,h=10);
	translate([12,0,7]) rotate([-90,0,0]) cylinder(d=7,h=10);
	translate([-0.5,0,10]) rotate([-90,0,0]) cylinder(d=7,h=10);
	translate([-0.5,0,7]) rotate([-90,0,0]) cylinder(d=7,h=10);
	translate([12,0,10]) rotate([-90,0,0]) cylinder(d=7,h=10);
	}
}
		translate([0,-1,5]) rotate([-90,0,0]) cylinder(d=3.5,h=50);
		translate([4,-1,7.5+3]) mirror([0,0,0]) cube([20,20,3.5]);
		//translate([4,0,0]) mirror([0,0,0]) cube([20,20,3.5]);
		translate([8,5,0]) rotate([0,0,0]) cylinder(d=3,h=50);

}

}

module baseMount(width=15,len=70)
{
	z = 5;
	color("blue") difference()
	{
		union()
		{
			difference()
			{
		hull()
		{
			translate([0,0,z]) rotate([-90,0,0]) cylinder(d=9.5,h=width,$fn=32);
			translate([10,0,z]) rotate([-90,0,0]) cylinder(d=9.5,h=width,$fn=32);
		}
			translate([0,0,z]) rotate([-90,0,0]) scale([1,1.2,1]) cylinder(d=10,h=width+1,$fn=32);
	}
		}
		translate([0,-1,z]) rotate([-90,0,0]) cylinder(d=holes,h=width+2,$fn=32);
		translate([10,-1,z]) rotate([-90,0,0]) cylinder(d=holes,h=width+2,$fn=32);
		translate([10-3,width/2,-5]) rotate([0,0,0]) cylinder(d=holes,h=20,$fn=32);
	}
}

module baseMount2(width=15,len=70)
{
	z = 5;
	color("green") difference()
	{
		union()
		{
			hull()
			{
				translate([1,0,5]) rotate([-90,0,0]) cylinder(d=9.5,h=width,$fn=32);
				translate([10,0,5]) rotate([-90,0,0]) cylinder(d=9.5,h=width,$fn=32);
			}
		}
		translate([0,-1,z]) rotate([-90,0,0]) cylinder(d=holes,h=width+2,$fn=32);
		translate([10,-1,z]) rotate([-90,0,0]) cylinder(d=holes,h=width+2,$fn=32);
		translate([10-3,width/2,-5]) rotate([0,0,0]) cylinder(d=holes,h=20,$fn=32);
	}
}


module ZPlatformHinge()
{
	union()
	{
		yOffset = 0;
		//baseMount();
		//translate([0,7+10,0]) baseMount2(10);
		//BearingHolder(-1);
		color("yellow") translate([0,0,0])
		{
			translate([0,0,11]) baseMount(10);
			translate([0,0,0]) baseMount(10);
			//translate([0,0,7]) mirror(0,0,1) baseMount(10);
			plateMount();
			translate([-70,0,0]) mirror([1,0,0]) plateMount();
			translate([0,0,11]) plateMount();
		}
		color("blue") translate([0,10,0])
		{
			translate([0,0,0]) baseMount2(10);
			translate([0,0,11]) baseMount2(10);
			translate([-70,0,0]) plateMount2();
			//translate([-70,0,0]) mirror([1,0,0]) plateMount();
		}
		color("yellow") translate([0,20,0])
		{
			plateMount();
			translate([0,0,0]) baseMount(10);
			translate([0,0,11]) baseMount(10);
			translate([-70,0,0]) mirror([1,0,0]) plateMount();
			translate([0,0,11]) plateMount();
		}
		color("blue") translate([0,30,0])
		{
			translate([0,0,0]) baseMount2(10);
			translate([0,0,11]) baseMount2(10);
			//plateMount();
			translate([-70,0,0]) plateMount2();
		}
		color("yellow") translate([0,40,0])
		{
			plateMount();
			translate([0,0,0]) baseMount(10);
			translate([0,0,11]) baseMount(11);
			translate([-70,0,0]) mirror([1,0,0]) plateMount();
			translate([0,0,11]) plateMount();
			//translate([-70,0,0]) mirror([1,0,0]) plateMount();
		}
		color("blue") translate([0,50,0])
		{
			translate([0,0,0]) baseMount2(10);
			translate([0,0,11]) baseMount2(10);
	//		plateMount();
			translate([-70,0,0]) plateMount2();
		}

		translate([-70+4,0,0.5])
		{
			color("green") cube([70-4-4,60,3]);
		color("black") translate([0,-5,0]) rotate([0,0,0]) dimensions(70-4-4, DIM_LINE_WIDTH, height=DIM_HEIGHT, loc=DIM_OUTSIDE);
		color("black") translate([30,0,3.5]) rotate([0,0,90]) dimensions(60, DIM_LINE_WIDTH, height=DIM_HEIGHT, loc=DIM_OUTSIDE);
		color("black") translate([0,-2,0]) rotate([0,0,0]) dimensions(4, DIM_LINE_WIDTH, height=DIM_HEIGHT, loc=DIM_OUTSIDE);
		}
		#color("green") translate([-66,0,11]) cube([70-4-4,60,3]);
	}
}


ZPlatformHinge();
	

//translate([0,w*6,0]) part4(w,70);

//translate([0,w*5,0]) part2(10,70);