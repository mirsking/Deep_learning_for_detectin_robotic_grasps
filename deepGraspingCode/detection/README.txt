Code for performing grasp detection, once a network has been trained for 
recognition.

=== Subfolders: ===

detectionFromData:   Performs detection for cases in the grasping dataset.

detectionFromKinect: Performs detection for images in the MATLAB workspace. 
                     These are assumed to come from a Kinect (and must have
                     both RGB and depth images). Requires a background 
                     depth image, too. User-friendly functions that let you
                     select multiple objects to search grasps for, and
                     return grasps for all of them.

detectionUtils:      Utility functions shared by both these folders.

=== Getting started: ===

Before you run any of this code, run setupPath.m to add a couple folders
containing utility functions to your MATLAB path.

If you want to run detection on data from the grasping dataset, look at 
onePassDectionForInstDefaultParams.m in detectionFromData, and its display
version.

If you want to run detection on your own images, look at 
getGraspForSelectionDefaultParams in detectionFromKinect. This function
assumes you have an RGB, depth, and depth background image in MATLAB's
workspace. These functions have only been tested with the MATLAB/Kinect
interface available at:

http://www.mathworks.com/matlabcentral/fileexchange/30242-kinect-matlab

Since other Kinect images may be scaled differently, you may need to change
some parameters to get this code to work on your own images. Although depth
data is whitened by case, which should eliminate most scaling issues, you
may have to change MINSTD in caseWiseWhiten.m to compensate for the
different scaling. 

Display versions of all detection functions are provided, as well. These
let you watch the search run, showing you both the current search rectangle
and the best-ranked one found. 

If you'd like to use some search space other than the default, you can look
at the functions that the default-params versions reference, which have
documentation of the inputs which govern the search space.

Always be sure to use only the first column of classifier weights from the
learned weights for recognition, i.e:
w_class = w_class(:,1)

The Baxter code posted on our website can be used to run detected grasps on
a Baxter robot.
