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
<i>Examples of camera designs obtained using different sets of parameters. Images : Nils Hamel</i>
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
<i>Spherical camera prototype made by Charles Papons & Marcelo Kaihara - HES-SO Valais. Image : Marcelo Kaihara</i>
</p>
<br />

As the sensors are replaced by traditional cameras, the device has to be calibrated in order to obtain the desired ideal images. The calibration procedure proposed in [3] is considered for the _scanvan_ project prototype. The following image gives an example of the obtained capture using the built prototype :

<br />
<p align="center">
<img src="https://github.com/nils-hamel/spherical-camera/blob/master/doc/image/camera-3.jpg?raw=true" width="384">
<br />
<i>Example of device capture in equirectangular mapping. Image : Charles Papons & Marcelo Kaihara</i>
</p>
<br />

Of course, the design of the mirror and the mounting system of the two standard cameras used to capture the mirror reflection induce reduction of the four _pi_ field of view. Nevertheless, this prototype is able to considerably increase the field of view according to standard cameras and other omnidirectional devices. In addition, the presented image offers a perfect four _pi_ images without any parallax effects.


## Spherical Algorithm

## ScanVan project Teams

The _ScanVan_ FNS project (PNR 76 _Big Data_, 167151) was won and conducted by the DHLAB of EFPL and the Institut des Systèmes Industriels of the HES-SO Valais with the following teams :

**EPFL**
Nils Hamel, Scientist
Vincent Buntinx, Scientist
Frédéric Kaplan, Professor

**HES-SO Valais**
Charles Papon, Scientist
Marcelo Kaihara, Scientist
Pierre-André Mudry, Professor

The EPFL team was responsible of the theoretical camera and algorithm design and the HES-SO team was in charge of the prototype development and the onboard implementation of the algorithm.

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