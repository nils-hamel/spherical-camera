## Overview

This repository holds the design definition and developments around an experimental spherical camera and its specific pose estimation algorithm. The camera and its algorithm were designed for the _ScanVan_ FNS project proposal (PNR 76 _Big Data_) won by the DHLAB (EPFL) and the Institut des Systèmes Industriels (HES-SO Valais) - Project FNS 167151.

The goal of the _ScanVan_ project is to design a methodology for cities and environment scanning through structure from motion allowing a constant survey to take place. The objective is to develop a way of obtaining centimetric cities 3D scans on a daily basis, leading to 4D representations. Such 4D objects open the way to new systematic temporal evolution analysis of cities and their structures.

In this context, a spherical camera was designed along with a pose estimation algorithm allowing to take advantage of the camera specifications toward robust structure from motion pipelines. The spherical camera was designed to solve the problem of narrow fields of views of most devices usually considered for structure from motion, leading to simple and robust acquisition strategies.

## Spherical Camera

The design of the proposed camera is made to address the problem of narrow fields of views of traditional cameras in the context of structure from motion and 3D models computation. The design allows the camera to see everything within a single shot. This allows to consider wider distribution of features leading to more stable and robust pose estimation. It then allows to reduce the complexity of image acquisition, as everything is viewed on each camera capture. The proposed camera design brings researches on paraboloid [1] and hyperboloid [2] cameras a step forward allowing four _pi_ field of view capability.

In addition to the field of view, the design of the proposed camera also ensures that all the collected light is focused on a single and common focal point. This property is crucial from the structure from motion point of view, as it allows to consider simple and robust algorithms for pose estimation.

The camera is based on a central two-sided hyperbolic mirror allowing to ensure capture of the entire surrounding sphere and the focusing on a single common focal point. Three parameters describe the camera design and can be modulated to obtain different configurations and sizes. The following images give an illustration of the camera design for a specific sets of parameters :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-1a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-1b.jpg?raw=true" width="384">
<br />
<i>Examples of spherical camera designs obtained using different sets of parameters. The mirror is represented in gray as the two side sensors that capture the reflected light shown in orange - Images : Nils Hamel</i>
</p>
<br />

Changing the parameter allows to modulate the size of the mirror, its thickness, the distance of the sensors to the mirror center and the size of the sensor themselves.

The proposed design is theoretical and ideal. Indeed, the light reflected by the principal mirror can not be collected by a sensor directly. The sensors can then be replaced by standard small cameras to produce the image captures. This solution was adopted in collaboration with the HES-SO Valais to produce a first prototype of the spherical camera based on the proposed design. The following images give a view of the built prototype :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-2a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-2b.jpg?raw=true" width="384">
<br />
<i>Spherical camera prototype built by Charles Papon & Marcelo Kaihara (HES-SO Valais) - Images : Marcelo Kaihara</i>
</p>
<br />

As the sensors are replaced by traditional cameras, the device has to be calibrated in order to obtain the desired ideal images. The calibration procedure proposed in [3] is considered for the _scanvan_ project prototype. The following image gives an example of the obtained capture using the calibrated prototype :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-3.jpg?raw=true" width="480">
<br />
<i>Example of device capture in equirectangular mapping - Image : Charles Papon & Marcelo Kaihara</i>
</p>
<br />

Of course, the manufacture of the mirror and the mounting elements for the two side cameras used to capture the mirror reflected light induce reduction of the four _pi_ field of view. Nevertheless, this prototype is able to considerably increase the field of view according to standard cameras and other omnidirectional devices, toward robust structure from motion pipelines. As a last element, the images captured by the camera produce _perfect_ four _pi_ panoramas without parallax effects within single shots.

## Spherical Algorithm

The algorithm is designed to take advantage of the spherical configuration of the camera, and more specifically of the absence of intrinsic parameters. The absence of intrinsic parameters allows to simplify the pose estimation problem, reducing it to the simple estimation of one rotation matrix and one translation vector.

Because the spherical camera is free of intrinsic parameters, the captures it produces can be identified to a simple projection on a unit sphere of the surrounding selected points. As for any pose estimation algorithm, _matched features_ are considered for the pose estimation between two spherical captures. A _matched feature_ is understood as a common scene point projected on the two unit spheres representing two camera captures. The input of the pose estimation algorithm is then a collection of points projected on the two unit spheres corresponding to the two cameras.

To estimate the pose between the two cameras, the algorithm uses an iterative application of the least-squares fitting of 3D point sets described in [4]. The following assumption is made : the point depths being lost after projection on camera unit spheres, it is assumed that the structure of the projection is sufficient to compute a first approximation of the rotation and translation to match the two point sets. With the knowledge of a first estimated rotation and translation, it is possible to correct the radii of the projections on the unit sphere through best intersection estimation between the _matched features_. In other words, the projections of the points are pushed away from the unit sphere to iteratively retrieve the depth information. After each radii correction, a new rotation and translation is computed applying the [4] method. At the end of the iterations, the correct depth of the point is expected to be known, leading to a good estimation of the rotation and translation between the two cameras. The following images give an illustration of the situation at the last iteration of two theoretical cases :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-1a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-1b.jpg?raw=true" width="384">
<br />
<i>Last algorithm iteration state on theoretical cases : the blue line gives the vector between the two camera centers while the grey lines link the camera center to the estimated position of the matched features - Images : Nils Hamel</i>
</p>
<br />

The algorithm iterations stop condition is deduced from a characteristic of the algorithm design. As each _matched feature_ has a projection on each camera, two sets of radii are corrected at each iteration. The convergence condition is, considering the estimated rotation and translation, that the radii of one _matched features_ should lead to the same location, that is the position of the _feature_ in space. The distances between the two position defined by the two radii of a _feature_ can be used as an error function. Considering the largest error on a set of _matched features_, the algorithm stops is this value variation over two iteration goes below a tolerance value.

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

The following plots show the ability of the pose estimation algorithm to resist to strong noise on _matched features_. They show how the error on estimated rotations and translations evolve with the addition of noise to the position of the _matched features_. The algorithm is used on random situations on which noise is added on position of the _matched features_. The amplitude of the noise is expressed as a multiplication factor of the norm of the true translation between the two camera captures. In addition, independent noise is added for both camera. The following plot shows the error mean and standard deviation computed on _64_ pose estimation for each noise amplitude using each time _32 matched features_ :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-3a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-3b.jpg?raw=true" width="384">
<br />
<i>Error evolution according to noise amplitude on rotation (left) and tranlsation (right) - Images : Nils Hamel</i>
</p>
<br />

This clearly shows that the algorithm is robust in case on strongly noised data and allows to maintain a constant precision in the estimation on the rotation and translation.

The following plots show how the spherical approach is able to bring more precision on the estimation of the rotation and translation between the camera pose because of the distribution of _features_ on the entire sphere. The experience consists in two cameras that are getting closer to each other considering a set of _features_ grouped in a sphere between the two camera. As the camera are far away from the center of the _features_ sets, the scene is view by the capture through a small angle of view. As the camera get closer to each other, they enter the set of _features_ allowing to, step by step, increasing the angle of view of the _features_. It allows to illustrate how the stability and precision of the pose estimation evolve with the angle of view of the cameras. The following plots shows the evolution of the pose estimation precsion considering _16_ and _32_ _matched features_, _32_ position of the camera and _32_ different distribution of the _features_ in the scene sphere :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-4a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-4b.jpg?raw=true" width="384">
<br />
<i>Evolution of rotation (left) and tranlsation (right) estimation error mean and standard deviation according to the distribution of the features. For each of the 32 points of measure, 32 different sets of 16 features are considered. The light and dark blue lines give the 36x24mm sensors 35mm and 24mm corresponding angles of view - Images : Nils Hamel</i>
</p>
<br />

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-5a.jpg?raw=true" width="384">
&nbsp;
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/algorithm-5b.jpg?raw=true" width="384">
<br />
<i>Evolution of rotation (left) and tranlsation (right) estimation error mean and standard deviation according to the distribution of the features. For each of the 32 points of measure, 32 different sets of 32 features are considered. The light and dark blue lines give the 36x24mm sensors 35mm and 24mm corresponding angles of view - Images : Nils Hamel</i>
</p>
<br />

These results shows how the increase of the angle of view is able to stablilize the estimation of the rotation and translation and to increase their precision. Such stability and precision is mendatory for large scale three-dimensional models computation  to ensure contained drift on the visual odometry and more robust pose estimation algorithm.

This overview of the algorithm expose the main elements that shows how spherical camera and algorithm are able to move structure from motion forward toward robust reconstruction pipeline and large scale models computation.

## ScanVan Teams

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