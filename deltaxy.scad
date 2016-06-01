use <Modules/Pulley_T-MXL-XL-HTD-GT2_N-tooth.scad>
use <Modules/ISOThread.scad>
use <Modules/Bearings.scad>
use <Modules/EndStoppers.scad>
use <Modules/Write.scad/Write.scad>
include <Modules/MCAD/stepper.scad>
use <Modules/HotEnds.scad>
use <Modules/LCD.scad>
use <Modules/Profiles.scad>
use <Modules/BezierScad.scad>
use <Modules/Belt_Generator.scad>
use <Modules/RAMPS.scad>
use <ZPlatform.scad>
use <Modules/Misc.scad>
include <Modules/dimlines.scad>
include <Modules/TextGenerator.scad>

drawArray = [];//[1,2,3,4,5];//[1,7,8];


// visualization
// https://jsfiddle.net/PavloG/9L42z9he/
//$t = 0;
//echo($t);
animY = abs(sin($t*180))*100;
animX = cos($t*180*4)*50;

animX = 50;
animY = 0;//85;
// 85 seems to be max
//echo(animY);
echo(animX);
Target_X = 0+animX;
Target_Y = (82)+animY;

ArmALen = 50;
ArmAX = -15;
EndPointMountOffset=20;
EndPointMountAngle=35;

ArmBLen=50;
ArmBX = 15;

ArmAXReal = -65;
ArmBXReal = 65;


RodsCarretOffset= -10;
RodsBottom=0;
RodsLen=200;

BedW=100;
BedH=150;
//BedTestH ReachabilityBottomOffset
BedBottom  = 0;

la = ArmALen;
lb = ArmBLen;
ax = ArmAX;
bx = ArmBX;

//    var SCARA_RAD2DEG=57.2957795;  // to convert RAD to degrees
    //var EndPointMountAngleRad = (EndPointMountAngle/SCARA_RAD2DEG);
EX = EndPointMountOffset*cos(EndPointMountAngle)+la;
EY = EndPointMountOffset*sin(EndPointMountAngle);
   	//out("RodsBottom",RodsBottom);
   	//out("RodsLen",RodsLen);
   	//out("RodsLen",RodsLen);
lHp2 = (EX)*(EX)+EY*EY;
lH = sqrt(lHp2);

// first pass
tx1 = Target_X;
ty1 = Target_Y;

echo(lH);
//res1 = cal_delta(tx1,ty1,lH,lb,ax,bx);
ba1 = (ax-tx1);
BA1=-2*ty1;
CA1 = ty1*ty1+ba1*ba1-lH*lH;
DA1 = BA1*BA1-4*CA1;
ay1=(-BA1-sqrt(DA1))/2;
echo(ay1);
//tx1 = 
//function circle_circle_intersection(x0, y0, r0,x1, y1, r1,d)
x0 = tx1;
y0=ty1;
r0=EndPointMountOffset;
x1=ax;
y1=ay1;
r1=la;
d = lH;

dx = x1 - x0;
dy = y1 - y0;
a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;
x2 = x0 + (dx * a/d);
y2 = y0 + (dy * a/d);
h = sqrt((r0*r0) - (a*a));
rx = -dy * (h/d);
ry = dx * (h/d);

tx = x2 + rx;
ty = y2 + ry;

//function cal_delta(tx,ty,la,lb,ax,bx)
//{
ba = (ax-tx);
BA=-2*ty;
CA = ty*ty+ba*ba-la*la;
DA = BA*BA-4*CA;
ay=(-BA-sqrt(DA))/2;
bb = (bx-tx);
BB=-2*ty;
CB = ty*ty+bb*bb-lb*lb;
DB = BB*BB-4*CB;
by=(-BB-sqrt(DB))/2;

echo("ay by");
echo(ay);
echo(by);

HotEndZ = 11;

bDrawHotEnd = 1;//0;

	dxx = (tx-ax);
	dyy = (ty-ay);
	angleArmA = atan2(dyy/la,dxx/la);


module E3DV6ShortClamp(partIndex)
{
	angle = angleArmA-60;
	intersection()
	{
		difference()
		{
				hull()
				{
					translate([Target_X,Target_Y,arm1H/2]) rotate([0,0,angle]) translate([-(16+6+3)/2,-(16+2)/2,0]) cube([16+6+3,16+2,3+3]);
					translate([Target_X,Target_Y,arm1H/2]) rotate([0,0,angle]) translate([-(16+4)/2,-(16+2)/2,0]) cube([16+4,16+2,3+3+7]);
				}
				translate([Target_X,Target_Y,-arm1H/2+3]) rotate([0,0,angle]) cylinder(d=8.6,h=40,$fn=32);
				//
				translate([Target_X,Target_Y,arm1H/2]) rotate([0,0,angle]) cylinder(d=12.2,h=4,$fn=32);
				translate([Target_X,Target_Y,arm1H/2+4]) rotate([0,0,angle]) cylinder(d=16.4,h=3+0.5,$fn=32);
				// holes
				translate([Target_X,Target_Y,arm1H/2+4]) rotate([90,0,angle]) translate([16/2+1.5,0,-20]) cylinder(d=3,h=40,$fn=32);
				translate([Target_X,Target_Y,arm1H/2+4]) rotate([90,0,angle]) translate([-16/2-1.5,0,-20]) cylinder(d=3,h=40,$fn=32);
			
				translate([Target_X,Target_Y,arm1H/2+4.5+5]) rotate([90,0,angle]) translate([16/2,0,-20]) cylinder(d=3,h=40,$fn=32);
				translate([Target_X,Target_Y,arm1H/2+4.5+5]) rotate([90,0,angle]) translate([-16/2,0,-20]) cylinder(d=3,h=40,$fn=32);
				//
				//translate([Target_X,Target_Y,arm1H/2]) rotate([0,0,angle]) translate([-(16+6+3)/2,7,0]) cube([8,20,20]);
		}

		if( partIndex==0 )
		{
			translate([Target_X,Target_Y,arm1H/2-1]) rotate([0,0,180+angle]) translate([-20,0,0]) cube([40,20,20]);
		}
		else
		{
			translate([Target_X,Target_Y,arm1H/2-1]) rotate([0,0,0+angle]) translate([-20,0,0]) cube([40,20,20]);
		}
}
}
if( bDrawHotEnd )
{
	color("green") E3DV6ShortClamp(0);
	color("magenta") E3DV6ShortClamp(1);
	translate([Target_X,Target_Y,HotEndZ]) rotate([180,0,180]) heatsinkE3DV6Short();
}

//translate([ArmAX,0,0]) rotate([-90,0,0])cylinder(d=1,h=RodsLen);
//translate([ArmBX,0,0]) rotate([-90,0,0])cylinder(d=1,h=RodsLen);

color("gray")
{
	translate([ArmAXReal,RodsBottom,0]) rotate([-90,0,0])cylinder(d=6,h=RodsLen);
	translate([ArmBXReal,RodsBottom,0]) rotate([-90,0,0])cylinder(d=6,h=RodsLen);
}

arm1D = 15;
arm1H = 10;
arm2D = 15;

module ArmA(H,W,W1)
{
	linear_extrude(height = H) 
	BezLine([
			[0,0], [la*0.5,-30], [la*0.95,40] ,[la, 0]
		], width = [W, W1,W1,W1], resolution = 5, centered = true);
}

color("blue")
{
	dxx = (tx-ax);
	dyy = (ty-ay);
	angle = atan2(dyy/la,dxx/la);
	echo(dxx);
	echo(dyy);
		hotEndMountH = arm1H;//+6;
		//hotEndMountHFitting = arm1H+6;

	difference()
	{
		union()
		{
			translate([ax,ay,-arm1H/2]) rotate([0,0,0]) cylinder(d=arm1D+14,h=arm1H,$fn=64);
			hull()
			{
				translate([ax,ay,-arm1H/2]) rotate([0,0,angle]) translate([0,-2,0]) cylinder(d=arm1D+10,h=arm1H);
				translate([ax,ay,-arm1H/2]) rotate([0,0,angle]) translate([15,-4,0]) cylinder(d=arm1D,h=arm1H);
			}

			hull()
			{
				translate([ax,ay,-arm1H/2]) rotate([0,0,angle]) translate([15,-4,0]) cylinder(d=arm1D,h=arm1H);
				translate([ax,ay,-arm1H/2]) rotate([0,0,angle]) translate([50,0,0]) cylinder(d=arm1D+3,h=arm1H);
			}

			hull()
			{
				translate([tx,ty,-arm1H/2]) rotate([0,0,0]) cylinder(d=arm1D+3,h=arm1H);
				translate([Target_X,Target_Y,-arm1H/2]) rotate([0,0,0]) cylinder(d=16+6,h=arm1H);
			}
			translate([Target_X,Target_Y,-arm1H/2]) rotate([0,0,0]) cylinder(d=16+6,h=hotEndMountH,$fn=64);
			//translate([Target_X,Target_Y,-arm1H/2]) rotate([0,0,angle-50]) translate([0,-5,0]) cube([17,10,hotEndMountH]);
		}
		translate([tx,ty,-arm1H/2-1]) rotate([0,0,0]) cylinder(d=3,h=arm1H+2,$fn=64);
		translate([Target_X,Target_Y,-arm1H/2-1]) rotate([0,0,0]) cylinder(d=16,h=hotEndMountH+2,$fn=64);
		//translate([Target_X,Target_Y,-arm1H/2-1]) rotate([0,0,angle-50]) translate([0,-0.5,0]) cube([18,1,hotEndMountH+2]);
		translate([Target_X,Target_Y,0]) rotate([90,0,angle-50]) translate([13,0,0]) translate([0,0,-10]) cylinder(d=3,h=30,$fn=16);
		translate([ax,ay,-arm1H/2-1]) cylinder(d=3,h=arm1H+2,$fn=16);
	}
}


module ArmB(index)
{
	dxx = (tx-bx);
	dyy = (ty-by);
	angle = atan2(dyy/lb,dxx/lb);
	echo(dxx);
	echo(dyy);
	hotEndMountH = arm1H;//+6;
		//hotEndMountHFitting = arm1H+6;

	color("orange")
	{
		difference()
		{
			height = 8;
			union()
			{
			if( index==2 || index==-1 )
				{
					color("orange")
					{
						difference()
						{
							translate([tx,ty,arm1H/2]) rotate([0,0,angle-45+180]) cylinder(d=Bearing623Diameter()+3+3,height);
							translate([tx,ty,arm1H/2-1]) rotate([0,0,angle-45+180]) translate([-(Bearing623Diameter()+3+3+3)/2,0,0])  cube([Bearing623Diameter()+3+3+3,20,height+2]);
						}
						translate([tx,ty,arm1H/2]) rotate([0,0,angle-45]) translate([-(Bearing623Diameter()+3+3+3)/2,0,0])  cube([Bearing623Diameter()+3+3+3,7,height]);
					}
				}
				if( index==3 || index==-1 )
				{
				hull()
				{
					translate([tx,ty,arm1H/2]) rotate([0,0,angle-45+180]) translate([-(Bearing623Diameter()+3+3+3)/2,0,0])  cube([Bearing623Diameter()+3+3+3,height,height]);
					translate([bx,by,arm1H/2]) rotate([0,0,angle]) translate([40,-13,0]) cylinder(d=arm1D-1,h=height);
					translate([bx,by,arm1H/2]) rotate([0,0,angle]) translate([28,-6,0]) cylinder(d=arm1D-2,h=height);
					translate([bx,by,arm1H/2]) rotate([0,0,angle]) translate([43,-14.8,0]) cylinder(d=arm1D-2,h=height);
				}
				}
			}
			translate([tx,ty,arm1H/2+4]) rotate([90,0,angle-45]) translate([Bearing623Diameter()/2+1.5,0,-20]) cylinder(d=3,h=100,$fn=16);
			translate([tx,ty,arm1H/2+4]) rotate([90,0,angle-45]) translate([-Bearing623Diameter()/2-1.5,0,-20]) cylinder(d=3,h=100,$fn=16);
	//			if( index==2 || index==-1 )
	//			{
					translate([tx,ty,-30]) cylinder(d=Bearing623Diameter(),h=50,$fn=64);
	//			}
			// holes
						translate([bx,by,-arm1H/2-1]) rotate([0,0,angle]) translate([41,-14,0]) cylinder(d=3,h=arm1H+20,$fn=32);
			translate([bx,by,-arm1H/2-1]) rotate([0,0,angle]) translate([35,-10,0]) cylinder(d=3,h=arm1H+20,$fn=32);
			translate([bx,by,-arm1H/2-1]) rotate([0,0,angle]) translate([28,-5,0]) cylinder(d=3,h=arm1H+20,$fn=32);
		}
	}
	color("green")
	{
		if( index==1 || index==-1 )
		{
			difference()
			{
				union()
				{
					translate([bx,by,-arm1H/2]) rotate([0,0,0]) cylinder(d=arm1D+14,h=arm1H,$fn=64);
					hull()
					{
						translate([bx,by,-arm1H/2]) rotate([0,0,angle]) translate([2,7.1,0]) cylinder(d=arm1D,h=arm1H);
						translate([bx,by,-arm1H/2]) rotate([0,0,angle]) translate([18,1,0]) cylinder(d=arm1D-2,h=arm1H);
					}
					hull()
					{
						translate([bx,by,-arm1H/2]) rotate([0,0,angle]) translate([18,1,0]) cylinder(d=arm1D-2,h=arm1H);
						translate([bx,by,-arm1H/2]) rotate([0,0,angle]) translate([40,-13,0]) cylinder(d=arm1D-1,h=arm1H);
					}
					hull()
					{
						translate([bx,by,-arm1H/2]) rotate([0,0,angle]) translate([40,-13,0]) cylinder(d=arm1D-1,h=arm1H);
						translate([bx,by,-arm1H/2]) rotate([0,0,angle]) translate([43,-14.8,0]) cylinder(d=arm1D-2,h=arm1H);
					}
				}
				//
				//
				translate([tx,ty,-arm1H/2-1]) rotate([0,0,0]) cylinder(d=3,h=arm1H+2,$fn=64);
				//translate([Target_X,Target_Y,-arm1H/2-1]) rotate([0,0,0]) cylinder(d=16,h=hotEndMountH+2,$fn=64);
				//translate([Target_X,Target_Y,-arm1H/2-1]) rotate([0,0,angle-50]) translate([0,-0.5,0]) cube([18,1,hotEndMountH+2]);
				// holes
				translate([bx,by,-arm1H/2-1]) rotate([0,0,angle]) translate([41,-14,0]) cylinder(d=3,h=arm1H+20,$fn=32);
				translate([bx,by,-arm1H/2-1]) rotate([0,0,angle]) translate([35,-10,0]) cylinder(d=3,h=arm1H+20,$fn=32);
				translate([bx,by,-arm1H/2-1]) rotate([0,0,angle]) translate([28,-5,0]) cylinder(d=3,h=arm1H+20,$fn=32);

				//
				translate([Target_X,Target_Y,0]) rotate([90,0,angle-50]) translate([13,0,0]) translate([0,0,-10]) cylinder(d=3,h=30,$fn=16);
				translate([bx,by,-arm1H/2-1]) cylinder(d=3,h=arm1H+2,$fn=32);
			}
		}
	}
}

ArmB(-1);

translate([ArmAXReal,ay+RodsBottom,0]) rotate([-90,0,0]) BearingLM6UU();
translate([ArmAXReal,ay+RodsBottom+BearingLM6UUHeight(),0]) rotate([-90,0,0]) BearingLM6UU();
translate([ArmBXReal,by+RodsBottom,0]) rotate([-90,0,0]) BearingLM6UU();
translate([ArmBXReal,by+RodsBottom+BearingLM6UUHeight(),0]) rotate([-90,0,0]) BearingLM6UU();


blockH = BearingLM6UUDiameter()+4+6;
dd = sqrt((ArmAX-ArmAXReal)*(ArmAX-ArmAXReal)+(1*1));
//echo(dd);
ddx = (RodsCarretOffset-4)/dd;
ddy = (ArmAX-ArmAXReal)/dd;
angleA = atan2(ddx,ddy)+180;

ddB = sqrt((ArmBX-ArmBXReal)*(ArmBX-ArmBXReal)+(1*1));
//echo(dd);
ddBx = (RodsCarretOffset-4)/ddB;
ddBy = (ArmBX-ArmBXReal)/ddB;
angleB = atan2(ddBx,ddBy)+180;

module SliderArmParamsHoles(XReal,ArmX,Y,angleZ,dir,d=3,fn=32)
{
	translate([0,0,-blockH/2-55])
	{
		color("red") translate([XReal+dir*(BearingLM6UUDiameter()/2+2),Y+6+RodsBottom-1,0]) rotate([0,0,90]) cylinder(d=d,h=100,$fn=fn);
		color("green") translate([XReal+dir*(BearingLM6UUDiameter()/2+2),Y+2+RodsBottom+BearingLM6UUHeight()-2,0]) rotate([0,0,90])  cylinder(d=d,h=100,$fn=fn);
		color("blue") translate([XReal+dir*(BearingLM6UUDiameter()/2+2),Y+RodsBottom+BearingLM6UUHeight()+BearingLM6UUHeight()-2,0]) rotate([0,0,90])  cylinder(d=d,h=100,$fn=fn);
		color("magenta") translate([XReal+dir*(BearingLM6UUDiameter()/2+11),Y+2+RodsBottom+BearingLM6UUHeight()-11,0]) rotate([0,0,90])  cylinder(d=d,h=100,$fn=fn);
		color("red") translate([XReal-dir*(BearingLM6UUDiameter()/2+2),Y+2+RodsBottom,0]) rotate([0,0,90])  cylinder(d=d,h=100,$fn=fn);
		color("green") translate([XReal-dir*(BearingLM6UUDiameter()/2+2),Y+2+RodsBottom+BearingLM6UUHeight()-2,0]) rotate([0,0,90])  cylinder(d=d,h=100,$fn=fn);
		color("blue") translate([XReal-dir*(BearingLM6UUDiameter()/2+2),Y+RodsBottom+BearingLM6UUHeight()+BearingLM6UUHeight()-2,0]) rotate([0,0,90])  cylinder(d=d,h=100,$fn=fn);
	}
}

module SliderArmParams(XReal,ArmX,Y,angleZ,dir=1)
{
	//#translate([ArmAXReal,ay+RodsBottom,-(blockH)/2]) rotate([0,0,angle2]) rotate([90,0,0]) translate([0,0,-20])  cylinder(r=10,h=100);
	difference()
	{
		union()
		{
			translate([XReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2,-(blockH)/2]) cubeRoundedXY([BearingLM6UUDiameter()+10,BearingLM6UUHeight()*2+4,blockH],r=4,corners=[1,1,1,0]);
			translate([ArmX,Y+RodsBottom,-(blockH)/2]) cylinder(d=BearingLM6UUDiameter()+10,h=blockH);
			translate([ArmX,Y+RodsBottom,-(blockH)/2]) rotate([0,0,angleZ]) translate([-10,-13,0]) cube([55,26,blockH]);
		}
		//
		SliderArmParamsHoles(XReal,ArmX,Y,angleZ,dir);
		//
		color("red") translate([ArmX-dir*(21),Y+5+RodsBottom-6,-blockH/2-5]) cylinder(d=3,h=blockH+10,$fn=32);
		color("red") translate([ArmX-dir*(17),Y+2+RodsBottom+10,-blockH/2-5]) cylinder(d=3,h=blockH+10,$fn=32);
		//
		color("red") translate([ArmX,Y,-blockH/2-4]) cylinder(d=Bearing623Diameter()+0.3,h=blockH+8,$fn=32);
		color("red") translate([ArmX,Y,-arm1H/2]) cylinder(d=35,h=arm1H,$fn=32);
		color("red") translate([ArmX-dir*(5),Y,-arm1H/2]) scale([0.5,1,1]) rotate([0,0,0]) cylinder(d=45,h=arm1H,$fn=32);
		if( dir<0 )
		{
		//color("red") translate([ArmX-dir*(5),Y,-arm1H/2]) rotate([0,0,-20]) scale([0.5,1,1]) translate([-10,9,0]) cylinder(d=45,h=arm1H,$fn=32);
		color("red") translate([ArmX-dir*(5),Y,-arm1H/2]) rotate([0,0,-58]) scale([0.4,1,1]) translate([-38,20,0]) cylinder(d=45,h=arm1H,$fn=32);
		}
		//
		translate([XReal,Y+RodsBottom-5,0]) rotate([-90,0,0])cylinder(d=9,h=BearingLM6UUHeight()*2+10,$fn=64);
		translate([XReal,Y+RodsBottom-0.2,0]) rotate([-90,0,0]) cylinder(d=BearingLM6UUDiameter()+0.6,h=BearingLM6UUHeight()*2+0.4,$fn=64);
		// holes
		translate([ArmX,Y+RodsBottom,-blockH/2+3]) 
		rotate([90,0,angleZ+90])
		{
			translate([10,0,-16]) cylinder(d=3,h=100,$fn=32);
			translate([-10,0,-16]) cylinder(d=3,h=100,$fn=32);

			if( dir>0 )
			{
				color("red")  translate([10,0,57.5]) cylinder(d=6,h=100,$fn=32);
				color("green") translate([-10,0,63])  cylinder(d=6,h=100,$fn=32);
			}
			else
			{
				color("red")  translate([10,0,64]) cylinder(d=6,h=100,$fn=32);
				color("green") translate([-10,0,57.5])  cylinder(d=6,h=100,$fn=32);
			}
		}
		// top
		translate([ArmX,Y+RodsBottom,blockH/2-3]) 
		rotate([90,0,angleZ+90])
		{
			translate([10,0,-16]) cylinder(d=3,h=100,$fn=32);
			translate([-10,0,-16]) cylinder(d=3,h=100,$fn=32);
			
			if( dir>0 )
			{
				color("red") translate([10,0,57.5]) cylinder(d=6,h=20,$fn=32);
				color("green") translate([-10,0,63])  cylinder(d=6,h=20,$fn=32);
			}
			else
			{
				color("red") translate([10,0,64]) cylinder(d=6,h=20,$fn=32);
				color("green") translate([-10,0,57.5])  cylinder(d=6,h=20,$fn=32);
			}
		}
	}
}

///*
module SliderArmA(index=-1)
{
	intersection()
	{
		SliderArmParams(ArmAXReal,ArmAX,ay,angleA,1);
		//translate([ArmAXReal-50,ay-50,-(blockH)/2]) cube([150,100,blockH/2]);
		if( index==1 )
		{
			// part 1
			translate([ArmAX,ay+RodsBottom,-(blockH)/2]) rotate([0,0,angleA]) translate([30,-50,0]) cube([150,100,blockH/2]);
		}
		if( index==2 )
		{
			// part 2
			translate([ArmAX,ay+RodsBottom,-(blockH)/2]) rotate([0,0,angleA-180]) translate([-30,-50,0]) cube([30,100,blockH/2]);
		}
		if( index==3 )
		{
			// part3
			//translate([ArmAX,ay+RodsBottom,-(blockH)/2]) rotate([0,0,angle-180]) translate([0,-50,0]) cube([150,100,blockH/2]);
		}
		// top
		//translate([ArmAXReal-50,ay-50,0]) cube([150,100,blockH/2]);
		if( index==4 )
		{
			// part 1 (top)
			translate([ArmAX,ay+RodsBottom,0]) rotate([0,0,angleA]) translate([30,-50,0]) cube([150,100,blockH/2]);
		}
		if( index==5 )
		{
			// part 2 (top)
			translate([ArmAX,ay+RodsBottom,0]) rotate([0,0,angleA-180]) translate([-30,-50,0]) cube([30,100,blockH/2]);
		}
		if( index==6 )
		{
			// part3 (top)
			translate([ArmAX,ay+RodsBottom,0]) rotate([0,0,angleA-180]) translate([0,-50,0]) cube([150,100,blockH/2]);
		}
	}
}

module SliderArmB(index=-1)
{
	intersection()
	{
		SliderArmParams(ArmBXReal,ArmBX,by,angleB,-1);
		// bottom
		//translate([ArmAXReal-50,ay-50,-(blockH)/2]) cube([150,100,blockH/2]);
		if( index==1 )
		{
			//part 1
			translate([ArmBX,by+RodsBottom,-(blockH)/2]) rotate([0,0,angleB]) translate([30,-50,0]) cube([150,100,blockH/2]);
		}
		if( index==2 )
		{
			// part 2
			translate([ArmBX,by+RodsBottom,-(blockH)/2]) rotate([0,0,angleB-180]) translate([-30,-50,0]) cube([30,100,blockH/2]);
		}
		if( index==3 )
		{
			// part3
			translate([ArmBX,by+RodsBottom,-(blockH)/2]) rotate([0,0,angleB-180]) translate([0,-50,0]) cube([150,100,blockH/2]);
		}
		// top
		//translate([ArmAXReal-50,ay-50,0]) cube([150,100,blockH/2]);
		if( index==4 )
		{
			// part 1 (top)
			translate([ArmBX,by+RodsBottom,0]) rotate([0,0,angleB]) translate([30,-50,0]) cube([150,100,blockH/2]);
		}
		if( index==5 )
		{
			// part 2 (top)
			translate([ArmBX,by+RodsBottom,0]) rotate([0,0,angleB-180]) translate([-30,-50,0]) cube([30,100,blockH/2]);
		}
		if( index==6 )
		{
			// part3 (top)
			translate([ArmBX,by+RodsBottom,0]) rotate([0,0,angleB-180]) translate([0,-50,0]) cube([150,100,blockH/2]);
		}
	}
}

union()
{
	SliderArmA(-1);
	SliderArmB(-1);
}

module SlideBlockClampParam(partIndex,ArmXReal,ArmX,Y,angle,dir)
{
	difference()
	{
		union()
		{
			if( partIndex==-1 || partIndex==1 )
			{
				difference()
				{
					color("blue") translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2,-blockH+3+3]) cubeRoundedXY([BearingLM6UUDiameter()+10,BearingLM6UUHeight()*2+4,5],r=4,corners=[1,1,1,1]);
					if( dir>0 )
					{
						translate([ArmXReal-dir*(BearingLM6UUDiameter()/2-1),Y+RodsBottom-20,-blockH+1+2+0.9+3]) rotate([90,0,90]) scale([1,1.3,1.1]) belting("straight","GT2_2mm", belt_length = 100, belting_width = 9 );
					}
					else 
					{
						translate([ArmXReal-dir*(BearingLM6UUDiameter()/2-11),Y+RodsBottom-20,-blockH+1+2+0.9+3]) rotate([90,0,90]) scale([1,1.3,1.1]) belting("straight","GT2_2mm", belt_length = 100, belting_width = 9 );
					}
					SliderArmParamsHoles(ArmXReal,ArmX,Y,angle,dir,d=7.5,fn=6);
				}
			}
			if( partIndex==-1 || partIndex==2 )
			{
				difference()
				{
					color("green") 
					union()
					{
						translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2,-blockH+3]) cubeRoundedXY([BearingLM6UUDiameter()+10,BearingLM6UUHeight()*2+4,3],r=4,corners=[1,1,1,1]);
						hull()
						{
							translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2+11+2.5,-blockH-9]) cubeRoundedXY([BearingLM6UUDiameter()+10,15,4],r=4,corners=[1,1,1,1]);
							translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2+11-1.5,-blockH-9+12]) cubeRoundedXY([BearingLM6UUDiameter()+10,23,1],r=4,corners=[1,1,1,1]);
						}
					}
					color("red") translate([ArmXReal-BearingLM6UUDiameter()/2+2,Y+RodsBottom-2+19.75,-blockH-9-5]) cube([8,2.5,20]);
					SliderArmParamsHoles(ArmXReal,ArmX,Y,angle,dir);
				}
			}
			if( partIndex==-1 || partIndex==3 )
			{
				difference()
				{
					color("magenta") 
					union()
					{
						//translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2,-blockH+3]) cubeRoundedXY([BearingLM6UUDiameter()+10,BearingLM6UUHeight()*2+4,3],r=4,corners=[1,1,1,1]);
						//hull()
						//{
					translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2+11+2.5,-blockH-9-4]) cubeRoundedXY([BearingLM6UUDiameter()+10,15,5],r=4,corners=[1,1,1,1]);
				//			translate([ArmXReal-BearingLM6UUDiameter()/2-3-2,Y+RodsBottom-2+11-1.5,-blockH-9+12]) cubeRoundedXY([BearingLM6UUDiameter()+10,23,1],r=4,corners=[1,1,1,1]);
						//}
					}
					color("red") translate([ArmXReal-BearingLM6UUDiameter()/2+2,Y+RodsBottom-2+19.75,-blockH-9-5]) cube([8,2.5,20]);
					SliderArmParamsHoles(ArmXReal,ArmX,Y,angle,dir);
				}
			}
		}
	}
}

//SlideBlockClampParam(ArmBXReal,ArmBX,by,angleB,1);

module SlideBlockClampA(partIndex)
{
	SlideBlockClampParam(partIndex,ArmAXReal,ArmAX,ay,angleA,1);
}
SlideBlockClampA(-1);

module SlideBlockClampB(partIndex)
{
	SlideBlockClampParam(partIndex,ArmBXReal,ArmBX,by,angleB,-1);
}
SlideBlockClampB(-1);

module StepperAndEndStopper(partIndex)
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	difference()
	{
		translate([ArmAXReal,20,-25-10-2])
		{
			if( partIndex==-1 )
			{
				translate([16,0,0]) rotate([0,90,0]) rotate([0,0,0]) Nema17_shaft24_Stepper(NemaSize=NemaLengthShort);
				translate([+9.5,0,0]) rotate([0,-90,0]) rotate([0,0,0]) GT2_16_Pulley();
			}
			difference()
			{
				translate([0,0,-21])
				{
					union()
					{
						if( partIndex==-1 || partIndex==1 )
						{
							color("blue") 
							{
								hull()
								{
									translate([17,holeDist,+21-holeDist]) rotate([0,-90,0]) cylinder(d=11,h=4,$fn=32);
									translate([17,holeDist,+21+holeDist]) rotate([0,-90,0]) cylinder(d=11,h=4,$fn=32);
									translate([17,-holeDist,+21+holeDist]) rotate([0,-90,0]) cylinder(d=11,h=4,$fn=32);
									translate([17,-holeDist,+21-holeDist]) rotate([0,-90,0]) cylinder(d=11,h=4,$fn=32);
								}
								//translate([17,-21,0]) mirror([1,0,0]) cube([4,42,42]);
								hull()
								{
									translate([17,-21+6,42+4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,-21+8,42+4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,-21+10,42]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,-21+4,42]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);

									translate([17,-21+6,0-4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,-21+8,0-4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,-21+10,0]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,-21+4,0]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);

									translate([17,7+6,0-4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,7+8,0-4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,7+10,5]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,7+4,0]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
								}
								hull()
								{
									translate([17,21-6,42-12]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,21+4,42-6]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,21+4,42-4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
									translate([17,21-4,42-4]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=8,h=4);
								}
							}
						}
						if( partIndex==-1 || partIndex==2 )
						{
							color("orange") 
							{
								translate([17-4,-21,6]) mirror([1,0,0]) cube([28-4,10,42-6]);
								translate([17-4,-21+5,6]) rotate([0,-90,0]) cylinder(d=10,h=28-4);
								translate([17-4,-18.5,42-3]) mirror([1,0,0]) cube([28-4,12,3]);
								translate([17-4,-18.5+2,42-6]) mirror([1,0,0]) cube([28-4,10,2]);
								translate([17-4,-18,42-11]) rotate([20,0,0]) translate([0,2,-0.5]) mirror([1,0,0]) cube([28-4,11.5,6]);
							}
						}
						if( partIndex==-1 || partIndex==3 )
						{
							color("green") 
							{
								translate([17-4,-21,42]) mirror([1,0,0]) cube([28-4,11,8]);
							}
						}
						if( partIndex==-1 || partIndex==4 )
						{
							color("blue") 
							{
								translate([17-4,-21,42+8]) mirror([1,0,0]) cube([28-4,11,8]);
							}
						}
						if( partIndex==-1 || partIndex==5 )
						{
							color("red") 
							{
								translate([17-4,-21,42+16]) mirror([1,0,0]) cube([28-4,11,8]);
							}
						}
						if( partIndex==-1 || partIndex==6 )
						{
							color("magenta") 
							{
								translate([17-4,-21,42+8]) mirror([1,0,0]) cube([28-4,11,2]);
							}
						}
					}
				}
				translate([16,0,0]) rotate([0,90,0]) rotate([0,0,0]) Nema17_shaft24_Stepper(1);
				translate([-6/2-3,-holeDist-1,-100]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
				translate([6/2+3,-holeDist-1,-100]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
			//
				translate([10,-holeDist,-holeDist]) rotate([0,-90,0]) cylinder(d=6.5,h=50,$fn=32);
				translate([10,-holeDist,+holeDist]) rotate([0,-90,0]) cylinder(d=6.5,h=50,$fn=32);
				translate([8,-21.1,-22]) mirror([1,0,0]) cube([28.2,12,33]);
				//#translate([8,-21.1,10]) rotate([90,0,0]) cylinder(d=10,h=20);
				translate([-8+2,-3,15])
				{
					if( partIndex!=3 && partIndex!=4 && partIndex!=5 && partIndex!=6 && partIndex!=7 )
					{
						rotate([20,180,180]) EndSwitchBody20x11(1);
					}
					rotate([20,0,0]) translate([20,-15,-20]) mirror([1,0,0]) translate([0,0,8]) cube([23,18,12]);
				}
				hull()
				{
					translate([12.9,0,0]) rotate([0,90,0]) cylinder(d=23,h=5.1);
					//translate([12.9,0,0]) rotate([0,90,0]) cylinder(d=23,h=5.1);
				}
				translate([50,-21+7.5,42/2+3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				translate([50,21+3.5,42/2-5]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				translate([50,-21+7.5,-42/2-3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				translate([50,14,-42/2-3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				//#translate([50,-21+4,42/2+3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=7,h=200,$fn=6);
			}
			translate([-8+2,-3,15])
			{
					if( partIndex==-1 )
					{
						rotate([20,180,180]) EndSwitchBody20x11();
					}
			}
		}
		translate([ArmAXReal,RodsBottom-0.5,0]) rotate([-90,0,0])cylinder(d=6,h=RodsLen,$fn=32);
	}
}
// part 6 is just a spacer if needed
StepperAndEndStopper(-1);
mirror() StepperAndEndStopper(-1);

module Idler(partIndex)
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	difference()
	{
		translate([ArmAXReal,RodsBottom+RodsLen+10+1,-25-10-2])
		{
			if( partIndex==-1 )
			{
				color("red") translate([+4.5,-30,0]) rotate([0,-90,0]) rotate([0,0,0]) GT2_16_Idler(3);
			}

			difference()
			{
				translate([0,0,-21])
				{
					union()
					{
						if( partIndex==-1 || partIndex==1 )
						{
							color("orange") 
							{
								translate([-11,-21,4]) cube([22,11,38]);
							}
						}
						if( partIndex==-1 || partIndex==2 )
						{
							color("green") 
							{
								translate([-11,-21,42]) cube([22,11,8]);
							}
						}
						if( partIndex==-1 || partIndex==3 )
						{
							color("blue") 
							{
								translate([-11,-21,42+8]) cube([22,11,8]);
							}
						}
						if( partIndex==-1 || partIndex==4 )
						{
							color("red") 
							{
								translate([-11,-21,42+16]) cube([22,11,8]);
							}
						}
						if( partIndex==-1 || partIndex==5 )
						{
							color("magenta") 
							{
								translate([-11,-21,42+8]) cube([22,11,2]);
							}
						}
						if( partIndex==-1 || partIndex==6 )
						{
							color("magenta") 
							{
								translate([-11,-21,-26]) cube([22,11,30]);
							}
						}
					}
				}
				// vert holes
				translate([-6/2-3,-holeDist-1,-100]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
				translate([6/2+3,-holeDist-1,-100]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
				translate([-6/2-3,-holeDist-1,-16-4]) rotate([0,0,90]) cylinder(d=7,h=3.1,$fn=6);
				translate([6/2+3,-holeDist-1,-16-4]) rotate([0,0,90]) cylinder(d=7,h=3.1,$fn=6);
				// horz hole
				translate([50,-21+7.5,42/2+3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				translate([50,-21+7.5,-12]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				//translate([50,-21+7.5,-42/2-3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				//
				translate([0,0,-9]) rotate([90,0,0])  cylinder(d=3,h=250,$fn=16);
				//#translate([-4.5-2,0,0]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				translate([0,0,9]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				//#translate([-4.5-2,0,10]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				//

			}
		}
		translate([ArmAXReal,RodsBottom-0.5,0]) rotate([-90,0,0])cylinder(d=6,h=RodsLen,$fn=32);
	}
}
// part 6 is just a spacer if needed
Idler(-1);
mirror() Idler(-1);

module IdlerStepper(partIndex)
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	difference()
	{
		translate([ArmAXReal,20,-25-10-2])
		{
			difference()
			{
				translate([0,0,-21])
				{
					union()
					{
						if( partIndex==-1 || partIndex==1 )
						{
							color("magenta") 
							{
								difference()
								{
									translate([-11,-21,4]) cube([19,11,28]);
									//translate([-3,-20,15]) cube([16,10,20]);
									translate([-7,-19.5,24]) cube([16,10,20]);
									//#translate([7,-19.5,4]) cube([16,7,20]);
								}
							}
						}
						if( partIndex==-1 || partIndex==2 )
						{
							color("green") 
							{
								difference()
								{
									translate([-11,-21,-26]) cube([22,11,30]);
									//translate([-3,-20,15]) cube([16,10,20]);
									translate([9,-19.5,-4]) cube([7,10,8]);
									//#translate([7,-19.5,4]) cube([16,7,20]);
								}
							}
						}
					}
				}
				// vert holes
				translate([-6/2-3,-holeDist-1,-100]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
				translate([-6/2-3,-holeDist-1,-20]) rotate([0,0,30])  rotate([0,0,90]) cylinder(d=7,h=31,$fn=6);
				translate([6/2+3,-holeDist-1,-100]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
				translate([6/2+3,-holeDist-1,-20]) rotate([0,0,30])  rotate([0,0,90]) cylinder(d=7,h=31,$fn=6);
				translate([-6/2-3,-holeDist-1,8]) rotate([0,0,90]) cylinder(d=7,h=200,$fn=6);
				// horz hole
				translate([50,-21+7.5,42/2+3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				//#translate([50,-21+7.5,-12]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				//translate([50,-21+7.5,-42/2-3]) mirror([1,0,0]) rotate([0,90,0])  cylinder(d=3,h=200,$fn=16);
				//
				translate([0,0,-9]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				//#translate([-4.5-2,0,0]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				//translate([0,0,9]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				//#translate([-4.5-2,0,10]) rotate([90,0,0])  cylinder(d=3,h=50,$fn=16);
				//

			}
		}
		translate([ArmAXReal,RodsBottom-0.5,0]) rotate([-90,0,0])cylinder(d=6,h=RodsLen,$fn=32);
	}
}
// part 6 is just a spacer if needed
IdlerStepper(-1);
mirror() IdlerStepper(-1);

translate([0,-10,-20])
{
translate([0,50,-130]) rotate([90,0,0]) Nema17_shaft24_Stepper(NemaSize=NemaLengthShort);
//translate([0,55,-120]) rotate([0,0,0]) cylinder(d=8,h=100);
}

color("blue") translate([0,-10,-180]) cylinder(d=3,h=190);
color("green") translate([0,80,-200+50]) cylinder(d=3,h=100);

//translate([-15,35,-110]) mirror([0,1,0]) rotate([0,90,0]) rotate([0,0,0]) RAMPS();

//translate([-20,45,-98]) mirror([0,1,0]) rotate([90,0,180]) RAMPS();

zRodsX = 35;

/*
translate([-zRodsX,55,-180]) cylinder(d=6,h=160);
translate([zRodsX,55,-180]) cylinder(d=6,h=160);

translate([0,0,100])
{
translate([zRodsX,55,-175+26]) rotate([90,0,0]) SCS6UU();
translate([zRodsX,55,-175]) rotate([90,0,0]) SCS6UU();

translate([-zRodsX,55,-175+26]) rotate([90,0,0]) SCS6UU();
translate([-zRodsX,55,-175]) rotate([90,0,0]) SCS6UU();
}

*/

#translate([ArmAXReal,RodsBottom+RodsLen+10+1,-180])
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	translate([-6/2-3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
	translate([6/2+3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
}
#mirror([1,0,0]) translate([ArmAXReal,RodsBottom+RodsLen+10+1,-180])
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	translate([-6/2-3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
	translate([6/2+3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
}

#translate([ArmAXReal,20,-180])
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	translate([-6/2-3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
	translate([6/2+3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
}
#mirror([1,0,0]) translate([ArmAXReal,20,-180])
{
	holeDist = lookup(NemaDistanceBetweenMountingHoles, Nema17) * 0.5;
	translate([-6/2-3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
	translate([6/2+3,-holeDist-1,0]) rotate([0,0,90]) cylinder(d=3,h=200,$fn=32);
}


translate([ArmBXReal-3,100,-180+2])rotate([0,0,0]) 
{
	ZPlatformHinge();
	color("black") translate([7,5,25]) rotate([0,0,0]) dimensions(9, DIM_LINE_WIDTH/2, height=DIM_HEIGHT, loc=DIM_OUTSIDE);
}

translate([ArmAXReal-9,94,-180+2])rotate([0,0,-90])
{
	ZPlatformHinge();
}

translate([ArmAXReal-8-2-3,-1,-180])
{
	LProfileWithDimensions(30,30,2,202);
	color("black") translate([0,4,3]) rotate([0,0,0]) dimensions(7, DIM_LINE_WIDTH/2, height=DIM_HEIGHT, loc=DIM_OUTSIDE);
	color("black") translate([0,4-4,3]) rotate([0,0,0]) dimensions(7+12, DIM_LINE_WIDTH/2, height=DIM_HEIGHT, loc=DIM_OUTSIDE);
}
translate([ArmBXReal+8+2+3,-1,-180])
{
	mirror([1,0,0]) LProfileWithDimensions(30,30,2,200);
}
//translate([ArmAXReal-8-2-3,55,0])
//{
//	LProfileWithDimensions(30,30,2,200);
//}
//translate([ArmBXReal-15,0,-180]) cube([30,94,93]);


#translate([-75,70,-155]) cube([150,120,2]);

