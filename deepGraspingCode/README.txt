Code for Deep Learning for Detecting Robotic Grasps, Ian Lenz, Honglak Lee,
Ashutosh Saxena. In Robotics: Science and Systems (RSS), 2013.

Intended to be a simple codebase which will allow you to load the grasping
dataset, process and whiten it, train a network, and perform grasp
detection. Currently does not contain more advanced evaluation code
(cross-validation, scoring, etc.), or code for the two-pass system.

Works with the data available at:
http://pr.cs.cornell.edu/grasping/rect_data/data.php


=== Folders: ===

loadData:    Functions for loading grasping rectangle data into MATLAB form.
             loadAllGraspingDataImYUVNormals(...) is probably the only 
             function you need to use directly - it loads grasping 
             rectangle data from the given directory into MATLAB format.

processData: Functions and scripts for post-processing grasping rectangle 
             data. This includes splitting the data into training and 
             testing sets, and whitening the data (very important to get 
             correct results!)
             
             processGraspData is the main script here, and probably the only
             one you'll need to use

recTraining: Functions and scripts for training a network for grasp
             recognition, whose weights can also be used for detection.

             trainGraspRecMultiSparse is the main script. However, there are
             a few other scripts/functions with tunable parameters. See the
             README in that folder for more details.

detection:   Functions for using the learned network to perform detection. 
             See the README there for more details.


=== Getting started: ===

--- Dataset: ---

Download the data from:

http://pr.cs.cornell.edu/grasping/rect_data/data.php

Extract each .tar.gz file into the same directory, so you have one folder
that contains all the pcd* files for the dataset. If you put each subset
of the dataset into its own folder, this code won't be able to find the data.

For best results, you should download the whole dataset. If you just want
to get something running quickly, you can use less data, but results won't
be as good.

You'll also need the background images, which you can find at:

http://pr.cs.cornell.edu/grasping/rect_data/backgrounds.zip


--- This code: ---

Once you have the dataset set up, this package should contain everything 
you need to get started. All external libraries used are included.

loadProcessAndTrain.m will load the grasping dataset from the given folder,
process the loaded data (splitting it into train/test sets and whitening
it), and then train a network for recognition. Be sure to set the dataset
directory in loadProcessAndTrain.m to the folder containing the pcd* files
that you set up above.

Then, you can use the functions in the detection folder to perform detection,
either on images from the dataset, or your own RGB-D images with backgrounds.
The README file in the detection folder has more information on this code.

The default-params versions of the functions there will let you run detection
with a default search space, and will automatically load the learned weights.
These take very few arguments, and are probably a good starting point. 

If you want to play with the training parameters for the deep network, you
can look at the README in recTraining. 

If you want to play with the search space, you can look at the appropriate 
functions in detection/detectionFrom[Data / Kinect]


=== Disclaimers, licenses, and what-not: ===

Although the author has made every attempt to test it, this code is released
with no warranty or guarantee of functionality. All use of this code is 
entirely at the user's own risk. 

Please report any discovered issues to ianlenz at cs.cornell.edu. Any
other questions or problems with the code can be directed there as well.
Of course, if you do anything cool with the code, Ian would love to hear
about it :)

Permission is granted to use, copy, distribute, and modify this code for 
non-commercial purposes, as long as Ian Lenz is credited and this notice is
retained. Linking to our website at http://pr.cs.cornell.edu/deepgrasping, as
well as a citation to:

Deep Learning for Detecting Robotic Grasps, Ian Lenz, Honglak Lee, Ashutosh
Saxena. In Robotics: Science and Systems (RSS), 2013.

if used for any paper, would be appreciated. 

=== External code used: ===

--- MATLAB packages: ---

This code uses and includes the latest (at time of posting) version of the
minFunc unconstrained optimization package, also available here:

http://www.di.ens.fr/~mschmidt/Software/minFunc.html


It also makes use of the excellent imSelectROI MATLAB package, included in
this release, but also available from:

http://www.mathworks.com/matlabcentral/fileexchange/15717-image-select-roi

in case you want to use it in your own work.


And last, but not least, the getkey package, not as impressive but
nevertheless useful, is also included where needed, but can be found at:

http://www.mathworks.com/matlabcentral/fileexchange/7465-getkey

--- Other codebases: ---

Some of this code, mostly network pre-training, was adapted from code by 
Quoc Le, associated with the paper:

Q.V. Le, A. Karpenko, J. Ngiam, A.Y. Ng. ICA with Reconstruction Cost for 
Efficient Overcomplete Feature Learning. NIPS 2011.

and available at:

http://cs.stanford.edu/~quocle/rica_release.zip 


Other portions of this code, namely the back-propagation parts, are based on 
Ruslan Salakhutdinov and Geoff Hinton's code, associated with:

Hinton, G. E. and Salakhutdinov, R. R. (2006)
Reducing the dimensionality of data with neural networks.
Science, Vol. 313. no. 5786, pp. 504 - 507, 28 July 2006.

which comes with the following notice:

Permission is granted for anyone to copy, use, modify, or distribute this
program and accompanying programs and documents for any purpose, provided
this copyright notice is retained and prominently displayed, along with
a note saying that the original programs are available from our
web page.
The programs and documents are distributed without any warranty, express or
implied.  As the programs were written for research purposes only, they have
not been tested to the degree that would be advisable in any important
application.  All use of these programs is entirely at the user's own risk.

The original Salakhutdinov/Hinton code is available at:

http://www.cs.toronto.edu/~hinton/MatlabForSciencePaper.html