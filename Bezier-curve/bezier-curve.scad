// Bézier curve, see https://en.wikipedia.org/wiki/B%C3%A9zier_curve
$fa = 12;                 // minimum angle
$fs = 2;                  // minimum size
$fn = $preview ? 12 : 64; // number of fragments

// Define constants
micron = 0.001;           // for showing nicely on-screen in OpenSCAD
printMargin = 0.3;        // print-margin for plastic expansion and some free room

// Linear Bézier curve, simply a straight line between two points
// B(t) is the point on the curve at parameter t (ranging from 0 to 1).
// P0 is the starting point (the curve's origin).
// P1 is the ending point (where the curve terminates).
function LinearBezier(P0, P1, t) = (1 - t) * P0 + t * P1;

// Quadratic Bézier curve, a curve with 3 control points
// B(t) is the point on the curve at parameter t (ranging from 0 to 1).
// P0 is the starting point (the curve's origin).
// P1 is the control point that influences the shape of the curve.
// P2 is the ending point (where the curve terminates).
function QuadraticBezier(P0, P1, P2, t) = (1 - t)^2 * P0 + 2 * (1 - t) * t * P1 + t^2 * P2;

// Cubic Bézier curve, a curve with 4 control points
// B(t) is the point on the curve at parameter t (ranging from 0 to 1).
// P0 is the starting point (the curve's origin).
// P1 and P2 are the control points that influence the shape of the curve.
// P3 is the ending point where the curve terminates.
function CubicBezier(P0, P1, P2, P3, t) = (1 - t)^3 * P0 + 3 * (1 - t)^2 * t * P1 + 3 * (1 - t) * t^2 * P2 + t^3 * P3;

// Create vector of points on the Bézier curve
// number of points:
STEPS = 50;
STEPSIZE = 1 / STEPS;

function RecursiveLinearBezier(P0, P1, t=0, points=[]) =
 (t>=1) ? [P1] : concat([LinearBezier(P0, P1, t)], RecursiveLinearBezier(P0, P1, t+STEPSIZE, points));

function RecursiveQuadraticBezier(P0, P1, P2, t=0, points=[]) =
 (t>=1) ? [P2] : concat([QuadraticBezier(P0, P1, P2, t)], RecursiveQuadraticBezier(P0, P1, P2, t+STEPSIZE, points));

function RecursiveCubicBezier(P0, P1, P2, P3, t=0, points=[]) =
 (t>=1) ? [P3] : concat([CubicBezier(P0, P1, P2, P3, t)], RecursiveCubicBezier(P0, P1, P2, P3, t+STEPSIZE, points));

// Examples
module ShowSpheres(points)
{
  for(point = points) { translate(concat(point, [0])) sphere(d=1); }
}

module ExampleLinearBezier()
{
  P0 = [5, -5];     // start
  P1 = [30, -15];   // end
  ShowSpheres(RecursiveLinearBezier(P0, P1));   
}

module ExampleQuadraticBezier()
{
  P0 = [5, 15];     // start
  P1 = [10, 5];     // control point
  P2 = [30, 20];    // end
  color("blue") ShowSpheres(RecursiveQuadraticBezier(P0, P1, P2));
}

module ExampleCubicBezier()
{
  P0 = [0, -5];     // start
  P1 = [-15, 25];   // control point 1
  P2 = [35, -15];   // control point 2
  P3 = [30, -5];    // end
  color("red") ShowSpheres(RecursiveCubicBezier(P0, P1, P2, P3));
}

ExampleLinearBezier();
ExampleQuadraticBezier();
ExampleCubicBezier();
