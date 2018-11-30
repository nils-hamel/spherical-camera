## Overview

This repository holds the definition and developments around an experimental spherical camera and its specific pose estimation algorithm. The camera and its algorithm were designed for the _ScanVan_ FNS project proposal (PNR 76 _Big Data_) won by the DHLAB (EPFL) and the Institut des Systèmes Industriels (HES-SO Valais) - Project FNS 167151.

The goal of the _ScanVan_ project is to design a methodology for cities and environement scanning through structure from motion allowing a constant survey to take place. The objective is to develop a way of obtaining centimetric cities 3D scans on a daily basis, leading to 4D representations. Such 4D objects open the way to new systematic temporal evolution analysis of cities and their structures.

In this context, a spherical camera was designed along with a pose estimation algorithm allowing to take advantage of the camera specifications toward robust structure from motion pipelines. The spherical camera was designed to solve the problem of narrow fields of views of most devices usually considered for structure from motion leading to simpler and robust acquisition strategies.

## Spherical Camera

The design of the proposed camera is made to address the problem of narrow fields of views of traditional camera in the context of structure from motion and 3D models computation. The design allows the camera to see everything within a single shot. This allows to consider wider distribution of features leading to more stable and robust pose estimation. It then allows to reduce the complexity of image acquisition, as everything is viewed on each camera capture. The proposed camera design brings researches on paraboloid [1] and hyperboloid [2] cameras a step forward allowing central four _pi_ field of view capability.

In addition to the field of view, the design of the proposed camera also ensures that all the collected light is focused on a single and common focal point. This property is crucial from the structure from motion point of view, as it allows to consider simple and robust algorithms for pose estimation.

The camera is based on a central two-sided hyperbolic mirror allowing to ensure capture of the entire surrounding sphere and the focusing on a single common focal point. Three parameters describe the camera design and can be modulated to obtain different configurations and sizes. The following images give an illustration of the camera design for a specific sets of parameters :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-1a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-1b.jpg?raw=true" width="384">
<br />
<i>Examples of camera designs obtained using different sets of parameters - Images : Nils Hamel</i>
</p>
<br />

Changing the parameter allows to modulate the size of the mirror, its thickness, the distance of the sensors to the mirror center and the size of the sensor themselves.

Indeed, the proposed design is theoretical and ideal. The light reflected by the principal mirror can not be collected by a sensor directly. The sensors can be replaced by standard small cameras to produce the camera captures. This solution was adopted in collaboration with the HES-SO Valais to produce a first prototype of the camera based on the proposed design. The following image gives a view of the built prototype :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-2a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-2b.jpg?raw=true" width="384">
<br />
<i>Spherical camera prototype made by Charles Papon & Marcelo Kaihara, HES-SO Valais - Images : Marcelo Kaihara</i>
</p>
<br />

As the sensors are replaced by traditional cameras, the device has to be calibrated in order to obtain the desired ideal images. The calibration procedure proposed in [3] is considered for the _scanvan_ project prototype. The following image gives an example of the obtained capture using the built prototype :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-3.jpg?raw=true" width="480">
<br />
<i>Example of device capture in equirectangular mapping - Image : Charles Papon & Marcelo Kaihara</i>
</p>
<br />

Of course, the design of the mirror and the mounting system of the two standard cameras used to capture the mirror reflection induce reduction of the four _pi_ field of view. Nevertheless, this prototype is able to considerably increase the field of view according to standard cameras and other omnidirectional devices. In addition, the presented image offers a perfect four _pi_ images without any parallax effects.

## Spherical Algorithm

The algorithm is designed to take advantage of the spherical configuration of the camera, and more specifically of the absence of intrinsic parameters. The absence of intrinsic parameters allows to simplify the pose estimation problem, reducing it to the simple estimation of one rotation matrix and one translation vector.

Because the spherical camera is free of intrinsic parameter, the captures it produces can be identified to a simple projection on a unit sphere of the surrounding selected points. As for any pose estimation algorithm, _matched features_ are considered for the pose estimation between two spherical captures. A _matched feature_ is then understood as a common scene point projected on the two unit spheres representing two camera captures. The input of the pose estimation algorithm is then a collection of point projected on the two considered unit spheres.

To estimate the pose between the two captures, the algorithm uses an iterative application of the least-squares fitting of 3D point sets described in [4]. The following assumption is made : the point depth being lost after projection on unit spheres, it is assumed that the structure of the projection is sufficient to compute a first approximation of the rotation and translation to match the two point set. With the knowledge of a first estimated rotation and translation, it is possible to correct the radii of the projection on the unit sphere through best intersection estimation between the _matched features_. In other words, the projections of the points are pushed away from the unit sphere to iteratively retrieve the depth information. After each radii correction, a new rotation and translation is computed applying the [4] method. At the end of the iteration, the correct depth of the point is expected to be known, leading to a good estimation of the rotation and translation between the two camera captures. The following images give an illustration of the situation at the last iteration of two theoretical cases :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-1a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-1b.jpg?raw=true" width="384">
<br />
<i>Last algorithm iteration state on theoretical cases. The yellow line gives the vector between the two camera center while the grey lines link the camera center to the estimated position of matched features - Images : Nils Hamel</i>
</p>
<br />

The iteration stop condition is deduced from a characteristic of the algorithm design. As each _matched feature_ has a projection on each sphere, two sets of radii are corrected at each iteration. The convergence condition is that, considering the estimated rotation and translation, that the radii of one _matched features_ should lead to the same location, that is the position of the _feature_ in space. The distances between the two position defined by the two radii of a _feature_ can be used as an error function. Considering the largest error on a set of _matched features_, the algorithm stops is this value variation over two iteration goes below a tolerance value.

The following plots illustrate the convergence behavior of the algorithm on a simulated case using _32 features_. The plot on the left gives the maximum separation according to the iterations showing how _features_ get closer to their reciprocal along with the iterations. The plot on the right shows the error measures made on the estimated rotation and translation according to iteration :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-2a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-2b.jpg?raw=true" width="384">
<br />
<i>Left : feature maximum separation according to iterations - Right : error measure on the estimated rotation (orange) and translation (blue) - Images : Nils Hamel</i>
</p>
<br />

The error measure on rotation is computed by multiplying the estimated matrix with the transposed of the true matrix. The identity is subtracted to the result before to consider the Frobenius norm. The error measure on translation is more complicated as the scale factor is not known. The error is computed by taking one minus the dot product between the estimated translation and the true translation converted as unit vectors.


## ScanVan Project Teams

The _ScanVan_ FNS project (PNR 76 _Big Data_, 167151) was won and conducted by the _DHLAB_ of EFPL and the _Institut des Systèmes Industriels_ of the HES-SO Valais with the following teams :

**EPFL** <br />
Nils Hamel, Scientist <br />
Vincent Buntinx, Scientist <br />
_Frédéric Kaplan, Professor_

**HES-SO Valais** <br />
Charles Papon, Scientist <br />
Marcelo Kaihara, Scientist <br />
_Pierre-André Mudry, Professor_

The EPFL team was responsible of the theoretical camera and algorithm design and the HES-SO team was in charge of the prototype development and the onboard implementation of the algorithm. The sources of the project can be accessed [here](https://github.com/ScanVan).

## Dependencies

The _spherical-camera_ repository comes with the following package dependencies (Ubuntu 16.04 LTS) :

* octave

The code documentation is available in source files.

## Copyright and License

**spherical-camera** - Nils Hamel <br >
Copyright (c) 2016-2018 DHLAB, EPFL

This program is licensed under the terms of the GNU GPLv3.

## References

[1] Shree K Nayar. Catadioptric omnidirectional camera. In Computer Vision and Pattern Recognition, 1997. Proceedings., 1997 IEEE Computer Society Conference on, pages 482–488. IEEE, 1997

[2] GANDHI, Tarak et TRIVEDI, Mohan. Parametric ego-motion estimation for vehicle surround analysis using an omnidirectional camera. Machine Vision and Applications, 2005, vol. 16, no 2, p. 85-95.

[3] Christopher Mei, Patrick Rives. Single View Point Omnidirectional Camera Calibration from Planar Grids. IEEE International Conference on Robotics and Automation (ICRA), Apr 2007, Rome, Italy. IEEE, pp.3945-3950, 2007

[4] ARUN, K. Somani, HUANG, Thomas S., et BLOSTEIN, Steven D. Least-squares fitting of two 3-D point sets. IEEE Transactions on Pattern Analysis & Machine Intelligence, 1987, no 5, p. 698-700.