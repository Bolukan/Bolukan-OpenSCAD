// Distance from a point to a line, see https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
$fa = 12;                 // minimum angle
$fs = 2;                  // minimum size
$fn = $preview ? 12 : 64; // number of fragments

// Define constants
micron = 0.001;           // for showing nicely on-screen in OpenSCAD
printMargin = 0.3;        // print-margin for plastic expansion and some free room

// The distance from a point to a line is the shortest distance from a given point to any point on an infinite straight line.

// The distance of point P0 and line that passes through two points P1 and P2.
function DistanceToLine(P0, P1, P2) =
  abs( (P2[0]-P1[0]) * (P1[1]-P0[1]) - (P2[1]-P1[1]) * (P1[0]-P0[0]) ) / sqrt( (P2[0]-P1[0])^2 + (P2[1]-P1[1])^2 );

// Variant in 2 steps
function DistanceToLineInSteps2(P0, P1, P2, P21, P10) =
  abs( P21[0] * P10[1] - P21[1] * P10[0] ) / sqrt( P21*P21 );

function DistanceToLineInSteps(P0, P1, P2) = DistanceToLineInSteps2(P0, P1, P2, P2-P1, P1-P0);



// The distance from a point to a line segment is the shortest distance from a given point to any point on a bounded line.

function DistanceVector(V) = sqrt(V*V);

function DistancePoints(P0, P1) = DistanceVector(P1-P0);

// P1 + dot_product / length_squared * P21 is the projected point on the line
function DistanceToLineSegment2(P0, P1, P2, P21, P10, P20, length_squared, dot_product) =
  (dot_product <= 0) ? sqrt(P20*P20) : ((dot_product>=length_squared) ? sqrt(P10*P10) :  DistancePoints(P0, P1 + dot_product / length_squared * P21));

function DistanceToLineSegment1(P0, P1, P2, P21, P10, P20) =
  DistanceToLineSegment2(P0, P1, P2, P21, P10, P20, P21*P21, P20*P21);

function DistanceToLineSegment(P0, P1, P2) =
  DistanceToLineSegment1(P0, P1, P2, P2-P1, P1-P0, P2-P0);

// Examples
P0 = [14, 0];
P1 = [1, 11];
P2 = [11, 1];

// Example Distance to Line
echo("To line:", DistanceToLine(P0, P1, P2));
echo("To line:", DistanceToLineInSteps(P0, P1, P2));

// Example Distance to Line Segment
echo("To segment:", DistanceToLineSegment(P0, P1, P2));

polygon([P0, P1, P2]);