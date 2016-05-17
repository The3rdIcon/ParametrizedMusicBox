/*
 * Fully Printed Parametric Music Box With Exchangeable Song-Cylinders
 * Copyright (C) 2013  Philipp Tiefenbacher <wizards23@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * The latest version can be found here:
 * https://github.com/wizard23/ParametrizedMusicBox
 *
 * contibutions welcome! please send me pull requests!
 *
 * This project was started for the Thingiverse Customizer challenge
 * and is online customizable here:
 * http://www.thingiverse.com/thing:53235/
 *
 *
 * Changelog:
 *
 * 2013-03-09, wizard23
 * added name of song using write.scad
 * fixed pulley position on print plate
 *
 */



use <MCAD/involute_gears.scad>
use <write/Write.scad>

// model config
// Is this to generate models for 3D printing or for the assembled view?
FOR_PRINT=1; // [0:Assembled, 1:PrintPlate]
// Should the MusicCylinder be generated?
GENERATE_MUSIC_CYLINDER=1; // [1:yes, 0:no]
// Should the Transmission Gear be generated?
GENERATE_MID_GEAR=1; // [1:yes, 0:no]
// Should the CrankGear be generated?
GENERATE_CRANK_GEAR=1; // [1:yes, 0:no]
// Should the Case (including the vibrating teeth) be generated?
GENERATE_CASE=1; // [1:yes, 0:no]
// Should the Crank be generated?
GENERATE_CRANK=1; // [1:yes, 0:no]
// Should the Pulley for the Crank be generated?
GENERATE_PULLEY=1; // [1:yes, 0:no]


// cylinder config
// this text will be put on top of the music cylinder
MusicCylinderName="test song";
// What font do you want to use for the text?
MusicCylinderNameFont="write/Letters.dxf"; //["write/Letters.dxf":Basic,"write/orbitron.dxf":Futuristic,"write/BlackRose.dxf":Fancy]
// how large should the font be
MusicCylinderNameFontSize = 8;
// how deep should the name be carved in?
MusicCylinderNameDepth=0.6;
// should the text be on the top or on the bottom of the music cylinder?
MusicCylinderNamePosition=0; // [0:top, 1:bottom]

// the width of all the walls in the design.
wall_width=2;


// Teeth config
// how many vibrating teeth should there be? (also number of available notes)
// You can use the output of the generator for this field:
// http://www.wizards23.net/projects/musicbox/musicbox.html
notes_count = 13;

// what should the notes on the teeth be? Each note is encoded by 3 characters:
// note (C,D,E,F,G,A,B), then the accidental (#, b or blank), and then the a
// one digit octave. You can use the output of the generator for this field:
// http://www.wizards23.net/projects/musicbox/musicbox.html
teethNotes="C 0C#0D 0D#0E 0F 0F#0G 0G#0A 0A#0B 0C 1C#1D 1D#1E 1F 1";

// how many time slots should there be? (If you make this much higher you
// should also increase musicCylinderGearTeeth) You can use the output of the
// generator for this field:
// http://www.wizards23.net/projects/musicbox/musicbox.html
time_slot_count = 35;

// the actual song. each time slot has notes_count characters.
// X marks a pin everything else means no pin.
// You can use the output of the generator for this field:
// http://www.wizards23.net/projects/musicbox/musicbox.html
pins="XoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooooooooooooXoooXooXoooooooooooooooooooXoooXooXoooooooooooooooooooXoooXooXoooooooooooooooooooXoooXooXoooooooooooooooooooXoooXooXoooooooooooooooooooXoooXooXoooooooooooooXooXoooXoooooooooooooooooooXooXoooXoooooooooooooooooooXooXoooXoooooooooooooooooooXooXoooXoooooooooooooooooooXooXoooXoooooooooooooooooooXooXoooX";


// Gear Config
// the number of teeth on the music cylinder gear
musicCylinderGearTeeth = 24;
// nr of teeth on small transmission gear
midSmallTeeth = 8;
// nr of teeth on big transmission gear (for highest gear ratio this should be comparable but slightly smaller than musicCylinderGearTeeth)
midBigTeeth = 20;
// nr of teeth on crank gear
crankTeeth = 8;
// the angle of the teeth relative to the cylinder
// (0 would be normal to cylinder, should be some small (<10) positive angle)
cylinderGearTeethAngle = 5;
// the transmission gears angle
// (to help get the music cylinder out easily this should be negative)
midGearAngle = -5;
// should be positive but the gear must still be held by the case...
// TODO: calculate this automagically from heigth and angle...
crankGearAngle = 15;
// diametral pitch of the gear (if you make it smaller the teeth become bigger
//  (the addendum becomes bigger) I think of it as teeth per unit :)
diametral_pitch = 0.6;
// the height of all the gears
gearHeight = 3;
// higher tolerance makes the teeth thinner and they slip, too low tolerance jams the gears
gear_tolerance = 0.1;
// used for the distance between paralell gears that should not touch
// (should be slightly larger than your layer with)
gear_gap = 1;
gear_min_gap = 0.1;
gear_hold_R = 4;


// direction that crank hast to be turned it to play the song
// (has a bug: music is played backwards in clockwise mode so better leave it
// counter clockwise)
// [1:Clockwise, 0:CounterClockwise]
crankDirection = 0;

// HoldderH is the height of the axis kegel
// how far should the snapping axis that holds the crank gear be?
// (should smaller than the other two because its closer to the corner
// of the case)
crankAxisHolderH = 1.55;

// how far should the snapping axis that holds the transmission gear be?
midAxisHolderH = 3.3;

// how far should the snapping axis that holds the music cylinder be?
musicAxisHolderH = 3.4;




// for extra distance from axis to gears
snapAxisSlack = 0.35;
// for crank gear axis to case
axisSlack = 0.3;

// used for clean CSG operations
epsilonCSG = 0.1;

// reduce this for faster previews
$fn=32;

// Replace Gears with Cylinders to verify gear alignment
DEBUG_GEARS=0; // [1:yes, 0:no]

// Crank
crankSlack = 0.2;
crankAxisR = 3;
crankAxisCutAway = crankAxisR*0.8;
crankLength = 18;
crankAxisCutAwayH = 4;
crankExtraH=4;
crankH=crankExtraH+2*crankAxisCutAwayH;

// pulley
pulleySlack = 0.4;
pulleyH = 10;
pulleyR = crankAxisR+wall_width;
// cutout to get Pulley in
pulleySnapL=1.2;

// Constants
// the density of PLA (or whatever plastic you are using) in kg/m3
// ((( scientiffically derived by me by taking the average of the density values
// I could find onthe net scaled a little bit to take into account that the
// print is not super dense (0.7 * (1210 + 1430)/2) )))
ro_PLA = 924;
// elasticity module of the plastic you are using in N/m2 ((( derived by this
// formula I hope I got the unit conversion right 1.6*   1000000 *(2.5+7.8)/2 )))
E_PLA = 8240000;
// the gamma factor for the geometry of the teeth (extruded rectangle),
// use this to tune it if you have a finite state modell of the printed teeth :)
// taken from
// http://de.wikipedia.org/wiki/Durchschlagende_Zunge#Berechnung_der_Tonh.C3.B6he
gammaTooth = 1.875;
// the frequency of C0 (can be used for tuning if you dont have a clue about
// the material properties of you printing material :)
baseFrequC0 = 16.3516;

// This controls the size of the pins on the cylinder
pinHeight = 3;
pteethMinD = 1.5;
pinD=1.5;

// Comb Config
teethHeight = 3 * 0.3;
teethGap = pinHeight;
teethHolderW=5;
teethHolderH=5;

boltHoleInnerRadius = 5 * 0.65;
boltHoleOuterRadius = 5;


circular_pitch = 180/diametral_pitch;
addendum = 1/diametral_pitch;
// The height of the song cylinder
musicH=notes_count*(wall_width+teethGap);

// Derived Music stuff
pinStepX = musicH/notes_count;
pinStepY = 360/time_slot_count;

teethW = pinStepX-teethGap;
maxTeethL = TeethLen(0); // convention index 0 is lowest note

///////////////////////

musicCylinderRadius = (musicCylinderGearTeeth/diametral_pitch)/2;
midSmallR = (midSmallTeeth/diametral_pitch)/2;
midBigR = (midBigTeeth/diametral_pitch)/2;
crankR = (crankTeeth/diametral_pitch)/2;
centerForCrankGearInsertion=(midBigR+crankR)/2;
noteExtend = teethHolderW + maxTeethL + pteethMinD;
midGearDist = musicCylinderRadius+midSmallR;
crankDist = midBigR+crankR;
midGearXPos = cos(midGearAngle)*midGearDist;
midGearZPos = sin(midGearAngle)*midGearDist;
crankGearXPos = midGearXPos + cos(crankGearAngle)*crankDist;
crankGearZPos = midGearZPos + sin(crankGearAngle)*crankDist;
maxMusicAddendum = 1.5*max(addendum, pinHeight);
frameH = max(musicCylinderRadius, -midGearZPos+midBigR) + maxMusicAddendum;
gearBoxW = 2 * (gearHeight+gear_gap+wall_width) + gear_gap;
songH = musicH+teethGap+teethGap;
frameW = gearBoxW + songH;

// noteExtend in alpha angle projected to y and x-axis
noteExtendY = sin(cylinderGearTeethAngle)*noteExtend;
noteExtendX = cos(cylinderGearTeethAngle)*noteExtend;
echo(noteExtendY/musicCylinderRadius);
noteBeta = asin(noteExtendY/musicCylinderRadius);

echo("Note Extend");
echo(noteExtendX);

// musicCylinderRadius to intersection with noteExtend
musicCylinderRadiusX = cos(noteBeta)*musicCylinderRadius;

negXEnd = -(noteExtendX+musicCylinderRadiusX);
posXEnd = crankGearXPos + crankR + 1.5*addendum + wall_width;

posYEnd = tan(cylinderGearTeethAngle)*(noteExtendX + musicCylinderRadiusX+posXEnd);


// Controls the axel cutout on the cylinder and large gear
module MyAxisSnapCutout(h, z=0, mirr=0,extra=epsilonCSG) {
	translate([0,0,z])
	mirror([0,0,mirr])
	translate([0,0,-extra])
	{
		cylinder(h=h+extra+snapAxisSlack, r1=h+extra+snapAxisSlack, r2=0, center=false);
	}
}

// Controls the holder on the side of the wall
module MyAxisSnapHolder(h, x=0, y=0, z=0, mirr=0,extra=wall_width, h2=0) {
	rotate([-90,0,0])
	mirror([0,0,mirr])
	translate([x,-z,-extra-y])
	{
		cylinder(h=h+extra, r1=h+extra, r2=0, center=false);
		intersection()
		{
			cylinder(h=h+extra+gear_hold_R, r1=h+extra+gear_hold_R, r2=0, center=false);
			translate([0, 0, -50 + extra -gear_min_gap])
				cube([100, 100, 100], center=true);
		}
	}
}

// The red gear.
module MyGear(n, hPos, hNeg, mirr=0) {
	if (DEBUG_GEARS) {
		translate([0,0,-hNeg]) cylinder(r=(n/diametral_pitch)/2, h=hPos+hNeg, center = false);
	}
	if (!DEBUG_GEARS) {
		HBgearWithDifferentLen(n=n, mirr=mirr, hPos=hPos, hNeg=hNeg, tol=gear_tolerance);
	}
}


/* based on Emmet's herringbone gear taken from thing: http://www.thingiverse.com/thing:34778 */

// The teeth on the sides of the different gears
module HBgearWithDifferentLen(n,hPos,hNeg,mirr=0, tol=0.25) {
twistScale=50;
mirror([mirr,0,0])
translate([0,0,0])
union() {
	mirror([0,0,1])
	gear(number_of_teeth=n,
		diametral_pitch=diametral_pitch,
		gear_thickness=hNeg,
		rim_thickness=hNeg,
		hub_thickness=hNeg,
		bore_diameter=0,
		backlash=2*tol,
		clearance=2*tol,
		pressure_angle=20,
		twist=hNeg*twistScale/n,
		slices=10);

	gear(number_of_teeth=n,
		diametral_pitch=diametral_pitch,
		gear_thickness=hPos,
		rim_thickness=hPos,
		hub_thickness=hPos,
		bore_diameter=0,
		backlash=2*tol,
		clearance=2*tol,
		pressure_angle=20,
		twist=hPos*twistScale/n,
		slices=10);
	}
}


echo("Testing NoteToFrequ, expected freq is 440");
echo(NoteToFrequ(9, 4, 0));


//// SPECFIC functions
function TeethLen(x) =
	1000 * LengthOfTooth(
		NoteToFrequ(
			LetterToNoteIndex(teethNotes[x*3]),
			LetterToDigit(teethNotes[x*3+2]),
			AccidentalToNoteShift(teethNotes[x*3+1])),
			teethHeight/1000,
			E_PLA,
			ro_PLA
		);



//// PLATONIC functions
// http://de.wikipedia.org/wiki/Durchschlagende_Zunge#Berechnung_der_Tonh.C3.B6he
// f [Hz]
// h m
// E N/m2
// ro kg/m3
function LengthOfTooth(f, h, E, ro) =
	sqrt((gammaTooth*gammaTooth*h/(4*PI*f))*sqrt(E/(3*ro)));

function NoteToFrequ(note, octave, modification) =
	baseFrequC0*pow(2, octave)*pow(2, (note+modification)/12);

/*
	Apparently we have to use the ternary operator in functions.
	This returns the accidental shift given what the character in the note string
	says it should be.
	Written with switch statement it would be
		switch(char) {
			case "#":
				return 1
			case "b"
				return -1
			case " "
				return 0
			default
				return INVALID_NOTE_CHECK_teethNotes()
		}
*/
function AccidentalToNoteShift(char) =
	char == "#" ? 1 :
	char == "b" ? -1 :
	char == " " ? 0 :
	INVALID_ACCIDENTAL_CHECK_teethNotes();

// allow B and H why??
// todo allow big and small letters
function LetterToNoteIndex(char) =
	char == "C" ? 0 :
	char == "D" ? 2 :
	char == "E" ? 4 :
	char == "F" ? 5 :
	char == "G" ? 7 :
	char == "A" ? 9 :
	char == "H" ? 11 :
	char == "B" ? 11 :
	INVALID_NOTE_CHECK_teethNotes();

function LetterToDigit(char) =
	char == "0" ? 0 :
	char == "1" ? 1 :
	char == "2" ? 2 :
	char == "3" ? 3 :
	char == "4" ? 4 :
	char == "5" ? 5 :
	char == "6" ? 6 :
	char == "7" ? 7 :
	char == "8" ? 8 :
	char == "9" ? 9 :
	INVALID_DIGIT_IN_OCTAVE_CHECK_teethNotes();

pinColor = [.8, .3, .7];
module Pin() {
	difference()
	{
		translate([-pinStepX/2,-pinD/2,-pinHeight])
		color(pinColor)cube([pinStepX+4*teethGap, pinD, 2*(pinHeight+0.15)],center=false);
		translate([pinStepX/2,0,0])
		rotate([0,-35,0]) translate([4.0*pinStepX,0,0]) color(pinColor)cube([8*pinStepX,8*pinStepX,8*pinStepX],center=true);
	}
}



module MusicCylinder(extra=0)
{
	translate([0,0,-extra]) cylinder(r = musicCylinderRadius, h = teethGap+musicH+extra, center=false, $fn=128);
    // controls where the pins are placed
	translate([0,0,teethGap])
	for (x = [0:notes_count-1], y = [0:time_slot_count-1])	{
		assign(index = y*notes_count + x)
		{
			if (pins[index] == "X")
			{

				rotate([0,0, y * pinStepY])
					translate([musicCylinderRadius, 0, (0.5+x)*pinStepX]) rotate([0,90,0])
							Pin();
			}
		}
	}
}

module BoltHole()
{
difference()
    {
        hull()
        {
        cylinder(teethHolderH, r = boltHoleOuterRadius);
        translate([0,-teethHolderW,0]) cube([teethHolderH, teethHolderW, teethHolderH]);
        }
	cylinder(teethHolderH, r = boltHoleInnerRadius);
    }
}

module MusicBox()
{
    // the comb
	translate([teethHolderW+maxTeethL,0,0])

	rotate([180,0,0])
	for (x = [0:notes_count-1])
	{
		assign(ll = TeethLen(x))
		{
			translate([-maxTeethL, x * pinStepX + teethGap, 0])
			{
				// teeth holder
				assign (leftAdd = (x == 0) ? gearBoxW : 0, rightAdd = (x == notes_count-1) ? wall_width/2+gear_gap : 0)
				{
				translate([-(teethHolderW), epsilonCSG-leftAdd, 0])
					cube([teethHolderW+maxTeethL-ll, pinStepX+2*epsilonCSG+leftAdd+rightAdd, teethHolderH]);
				}


				// teeth
				translate([-teethHolderW/2, teethGap,0])
				color([0,1,0])cube([maxTeethL+teethHolderW/2, teethW, teethHeight]);
			}
		}
	}
    translate([2.5*wall_width,17,-teethHolderH])
    BoltHole();
    translate([2.5*wall_width,-74,-teethHolderH])
    mirror([0,1,0])
    BoltHole();
}

module slide()
{
difference()
{
hull()
{
//translate([2.5*wall_width,5*gearHeight+wall_width,-teethHolderW])
cylinder(5, r = boltHoleOuterRadius);
translate([40,0,0])
cylinder(5, r = boltHoleOuterRadius);
}
hull()
{
//translate([2.5*wall_width,5*gearHeight+wall_width,-teethHolderW])
cylinder(6, r = boltHoleInnerRadius);
translate([40,0,0])
cylinder(6, r = boltHoleInnerRadius);
}
}
}


mirror ([0, FOR_PRINT?crankDirection:0,0])
{
// case shape

if (GENERATE_CASE)
{
	translate([0,20,FOR_PRINT?-negXEnd*sin(cylinderGearTeethAngle):0])
	intersection()
	{
		if (FOR_PRINT)
		{
			//translate([0,0, 500+negXEnd*sin(cylinderGearTeethAngle)]) cube([1000, 1000, 1000], center=true);

			assign(maxX = max(posXEnd, -negXEnd))
			translate([0,0, 2*frameH+negXEnd*sin(cylinderGearTeethAngle)]) cube([3*maxX, 2*frameW, 4*frameH], center=true);
		}
	rotate([FOR_PRINT?180:0, FOR_PRINT?-cylinderGearTeethAngle:0,0])
	{

	difference()
	{
		union()
		{

		// PIANO :)

		translate([-(noteExtendX+musicCylinderRadiusX),-(gearHeight/2+gear_gap+teethGap),0])
			rotate([0,-cylinderGearTeethAngle*1,0]){


				//MusicBox();

                   // translate([0,2*gearHeight+wall_width,-teethHolderW]) cube([-negXEnd,teethHolderW,teethHolderW]);
                translate([2.5*wall_width,5*gearHeight+wall_width,-teethHolderW])
                {
                slide();
                translate([0,-frameW - wall_width - 5,0])
                slide();
                }
        }
		// snapaxis for crank
		MyAxisSnapHolder(h=crankAxisHolderH, x=crankGearXPos, y =gearHeight/2+gear_gap, z=crankGearZPos, mirr=0, extra=gear_gap+epsilonCSG);



		// snapaxis for music cylinder
		MyAxisSnapHolder(h=musicAxisHolderH, y =gearHeight/2-gear_gap, mirr=1, extra=gearHeight+2*gear_gap+wall_width/2);
		MyAxisSnapHolder(h=musicAxisHolderH, y =gearHeight/2 +1*gear_gap +songH, extra=gear_gap+epsilonCSG, mirr=0);

		// snapaxis for mid gear
		MyAxisSnapHolder(h=midAxisHolderH, y =1.5*gearHeight, x=midGearXPos, z=midGearZPos, mirr=1);
		MyAxisSnapHolder(h=midAxisHolderH, y =gearHeight/2+gear_gap, x=midGearXPos, z=midGearZPos, mirr=0);

		difference()
		{
			// side poly extruded and rotated to be side
			rotate([-90,0,0]){
				translate([0,0,-frameW+1.5*gearHeight + gear_gap+wall_width])
					linear_extrude(height=frameW)
						polygon(points=
[[negXEnd,0],[posXEnd,-posYEnd],[posXEnd,frameH], [negXEnd,frameH]], paths=[[0,1,2,3]]);


			}

// cutout, wall_width then remain
		linear_extrude(height=4*frameH, center=true)
					polygon(points=[
[negXEnd+wall_width,-(0.5*gearHeight+2*gear_gap+songH)],
[musicCylinderRadius+maxMusicAddendum,-(0.5*gearHeight+songH+2*gear_gap)],
[musicCylinderRadius+maxMusicAddendum,-(0.5*gearHeight+2*gear_gap)],
[posXEnd-wall_width,-(0.5*gearHeight+2*gear_gap)],
[posXEnd-wall_width,(1.5*gearHeight+gear_gap)],
 [negXEnd+wall_width,(1.5*gearHeight+gear_gap)]
], paths=[[0,1,2,3,4,5,6]]);


		}
	}

		// cutout, make sure gears can rotate
		linear_extrude(height=4*frameH, center=true)
					polygon(points=[
[0+1*crankAxisR,(1.5*gearHeight+gear_gap)],
[0+1*crankAxisR,-(songH/2)],
[musicCylinderRadius+maxMusicAddendum,-(songH/2)],
[musicCylinderRadius+maxMusicAddendum,(1.5*gearHeight+gear_gap)]], paths=[[0,1,2,3]]);


// cutout because of narrow smallgear
			linear_extrude(height=4*frameH, center=true)
					polygon(points=[
[musicCylinderRadius+maxMusicAddendum+wall_width,-(0.5*gearHeight+2*gear_gap+wall_width)],
[musicCylinderRadius+maxMusicAddendum+wall_width,-frameW],
[posXEnd+1,-frameW],
[posXEnd+1,-(0.5*gearHeight+2*gear_gap+wall_width)]], paths=[[0,1,2,3]]);


			// Crank Gear Cutouts
			translate([crankGearXPos,0,crankGearZPos])
			{
				rotate([-90,0,0])
					cylinder(h=100, r=crankAxisR+axisSlack, center=false);


				rotate([0,-90-max(crankGearAngle,45+cylinderGearTeethAngle),0])
				{

					*translate([-(crankAxisR-axisSlack),0,0]) cube([2*(crankAxisR),100, centerForCrankGearInsertion]);


rotate([-90,0,0])
linear_extrude(height=musicH/2, center=false)
					polygon(points=[
[-(crankAxisR+axisSlack),-centerForCrankGearInsertion],
[(crankAxisR+axisSlack),-centerForCrankGearInsertion],
[(crankAxisR),0],
[-(crankAxisR),0]],
paths=[[0,1,2,3]]);


					translate([0*(crankR+addendum*1.5),0,centerForCrankGearInsertion])
					rotate([90,0,0])
					cylinder(h=100, r=(crankR+addendum*1.5), center=false);

					translate([0*(crankR+addendum*1.5),0,centerForCrankGearInsertion])
					mirror([0,1,0])
					rotate([90,0,0])
					cylinder(h=100, r=crankAxisR+axisSlack, center=false);

				}
			}

	}

	}
}
}
}

// music cylinder and gear
if (GENERATE_MUSIC_CYLINDER)

{
	translate([FOR_PRINT?-1.5*(musicCylinderRadius+addendum):0,FOR_PRINT?(crankDirection ? -1 : 1)*-((musicCylinderRadius+addendum)+gearBoxW):0, FOR_PRINT?gearHeight/2-gear_gap:0])
	rotate([FOR_PRINT?180:-90,0,0])
		translate([0,0,-(gear_gap)])
		difference() {
			union() {
				    color([.5,.1,1])MyGear(n=musicCylinderGearTeeth, hPos = gearHeight/2, hNeg=gearHeight/2+gear_gap);
				translate([0,0,-gearHeight/2-gear_gap/2]) cylinder(h=gear_gap+epsilonCSG, r2=musicCylinderRadius-addendum, r1=musicCylinderRadius-addendum+gear_gap);
				rotate([0, 180,0])
translate([0,0,teethGap+gearHeight/2])
{
rotate([0,0,27]) MusicCylinder(extra=teethGap+epsilonCSG);
}
				// PINS :)
			}
			union()
			{
				MyAxisSnapCutout(h=musicAxisHolderH, z=-(gearHeight/2)-songH, mirr=0);
				MyAxisSnapCutout(h=musicAxisHolderH, z=gearHeight/2, mirr=1);

				// text
				translate([0,0,MusicCylinderNamePosition == 1 ? gearHeight/2+1: -(songH+gearHeight/2-MusicCylinderNameDepth)])
					scale([1,1,MusicCylinderNameDepth+1])
						writecylinder(text=MusicCylinderName, where=[0,0,0], radius=musicCylinderRadius, height=1, face="bottom", space=1.3, center=true, h=MusicCylinderNameFontSize, font=MusicCylinderNameFont);
			}
		}
}

// midGear
color([1,0,0])
if (GENERATE_MID_GEAR)
{
	translate([FOR_PRINT?1.5*(musicCylinderRadius+addendum):0,FOR_PRINT?(crankDirection ? -1 : 1)*-((musicCylinderRadius+addendum)+gearBoxW):0, FOR_PRINT?1.5*gearHeight:0])

	translate([FOR_PRINT?0:midGearXPos,0,FOR_PRINT?0:midGearZPos])
		rotate([FOR_PRINT?180:-90,0,0])
			difference()
			{
			union() {
				translate([0,0,gearHeight])
				{
					difference(){
						MyGear(n=midBigTeeth, hPos = gearHeight/2, hNeg=gearHeight/2,mirr=1);

					}
				}
				translate([0,0,-gear_gap])
				difference()
				{
					MyGear(n=midSmallTeeth, hPos = gearHeight/2+gear_gap+epsilonCSG, hNeg=gearHeight/2, mirr=1);
				}

			}
			translate([0,0,-gear_gap])
					MyAxisSnapCutout(h=midAxisHolderH, z=-(gearHeight/2), mirr=0);
			translate([0,0,gearHeight]) MyAxisSnapCutout(h=midAxisHolderH, z=(gearHeight/2), mirr=1);
			}
}



if (GENERATE_CRANK_GEAR)
{
	// crank gear
	translate([FOR_PRINT?0:crankGearXPos, FOR_PRINT?(crankDirection ? -1 : 1)*-(gearBoxW/2+wall_width/2+gearHeight+crankR+addendum):0, FOR_PRINT?(0.5*gearHeight+gear_gap):crankGearZPos])


	//translate([crankGearXPos,0,crankGearZPos])
		rotate([FOR_PRINT?0:-90,0,0])
		union() {
			translate([0,0,gearHeight])
			difference()
			{
				union() {
					difference() {
						cylinder(h=gearHeight/2+wall_width+2*gear_gap+2*crankAxisCutAwayH, r=crankAxisR, center=false);
						translate([0,50+crankAxisR-crankAxisCutAway,gearHeight/2+wall_width+gear_gap+2*crankAxisCutAwayH])cube([100,100,crankAxisCutAwayH*2], center=true);
					}
					cylinder(h=gearHeight/2+gear_gap-gear_min_gap, r=crankR-addendum, center=false);
					MyGear(n=crankTeeth, hPos = gearHeight/2, hNeg=1.5*gearHeight+gear_gap, mirr=0);
				}
				MyAxisSnapCutout(h=crankAxisHolderH, z=-1.5*gearHeight-gear_gap);
			}
		}
}

// crank
color([0,1,0])
if (GENERATE_CRANK)
{
	translate([FOR_PRINT?-2*wall_width:crankGearXPos, FOR_PRINT?(crankDirection ? -1 : 1)*musicH/2+gearHeight:1.5*gearHeight+2*gear_gap+wall_width+crankH, FOR_PRINT?0:crankGearZPos])

	rotate([FOR_PRINT?0:-90,0,0])
	mirror([0,0,FOR_PRINT?0:1])
	{
		// to gear snapping
		difference() {
			cylinder(h=crankH, r=crankAxisR+crankSlack+wall_width,center=false);
			translate([0,0,crankH-gear_gap])  difference() {
				cylinder(h=4*crankAxisCutAwayH, r=crankAxisR+crankSlack,center=true);
				translate([0,50+crankAxisR+crankSlack-crankAxisCutAway,-2*crankAxisCutAwayH])cube([100,100,crankAxisCutAwayH*2], center=true);
			}
		}

		translate([crankLength,0,0])
			difference() {
				union() {
					// crank long piece
					translate([-crankLength/2,0,wall_width/2])
						cube([crankLength,2*(crankAxisR),wall_width],center=true);
					translate([-crankLength/2,0,crankExtraH/2])
							cube([crankLength,wall_width,crankExtraH],center=true);
					// where puley snaps/axis
					cylinder(h=crankExtraH, r=crankAxisR+pulleySlack+wall_width,center=false);
				}
				cylinder(h=3*crankExtraH, r=crankAxisR+pulleySlack,center=true);
				translate([50,0,0]) cube([100, 2*crankAxisR-2*pulleySnapL, 100], center=true);
			}

	}
}

if (GENERATE_PULLEY)
{
	translate([FOR_PRINT?(musicCylinderRadius+maxMusicAddendum):crankGearXPos, FOR_PRINT?(crankDirection ? -1 : 1)*gearBoxW+pulleyR:1.5*gearHeight+2*gear_gap+wall_width+crankH-crankExtraH, FOR_PRINT?crankExtraH+pulleyH+2*gear_gap:crankGearZPos])
	rotate([FOR_PRINT?180:-90,0,0])
	translate([crankLength,0,0])
	{
		// delta shaped end
		translate([0,0,-wall_width-gear_gap]) cylinder(h=crankAxisR+wall_width+gear_gap, r2=0, r1=crankAxisR+wall_width,center=false);
		// axis
		translate([0,0,-wall_width/2]) cylinder(h=crankExtraH+pulleyH+wall_width/2, r=crankAxisR,center=false);
		// handle
		translate([0,0,crankExtraH+gear_gap]) cylinder(h=pulleyH+gear_gap, r=pulleyR,center=false);
	}
}

translate([0,0, (FOR_PRINT?-negXEnd*sin(cylinderGearTeethAngle):0) -10 ])
	rotate([FOR_PRINT?180:0, FOR_PRINT?-cylinderGearTeethAngle:0,0])
		translate([-(noteExtendX+musicCylinderRadiusX),-(gearHeight/2+gear_gap+teethGap),0])
			rotate([0,-cylinderGearTeethAngle*1,0]){
MusicBox();
            translate([0,2*gearHeight+wall_width,-teethHolderW]) cube([-negXEnd * 0.18,teethHolderW,teethHolderW]);
            }
