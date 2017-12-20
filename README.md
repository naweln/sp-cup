# Signal Processing Cup

[Competition Page](http://signalprocessingsociety.org/get-involved/signal-processing-cup)

Team Members:
Undergraduate - Thierry Bossy, Aditya Garga, Nawel Naas
Graduate - Ignacio Alemàn
Supervisor - Dr. Francesca De Simone

To access the [registration page](https://www2.securecms.com/SPCup/SPCRegistration.asp) use the following information:
Application ID: 25997
Access code: DF5AD4A9

#### Note: All 3 undergrads need to get IEEE memberships in order to be able to participate!


# Implementations:

## camera-model-identification-with-cnn

This implementation is based on the following paper:

L. Bondi; L. Baroffio; D. Guera; P. Bestagini; E. J. Delp; S. Tubaro, "First Steps Towards Camera Model Identification with Convolutional Neural Networks" in IEEE Signal Processing Letters , vol.PP, no.99, pp.1-1. [IEEE](http://ieeexplore.ieee.org/document/7786852/)

* [bitbucket](https://bitbucket.org/polimi-ispl/camera-model-identification-with-cnn/src) - The original code
* [caffe](http://caffe.berkeleyvision.org) - Deep learning library used

In essence they trained on a large data base of various camera models to identify features via deep netowrks to be then classified via traditional SVM. 

In the ```camera-model-identification-with-cnn``` I have used their trained feature extractor to then train a SVM classifier based on our image data base.

#### Technical details 

Your data file (i.e. the file containing the various samples from the different models) should be located on the sp-cup root folder.
Two methods have been added to extend the classifier to the competition. 

```
sp-cup_save_features_to_file.py
```

This first method essentially computes and stores the features for all the models. They are in matrix format using numpy. They are stored in data_features. (They have been already precomputed, so unless the data is expanded this functions does not need to be used).

```
sp-cup_extract_features.py 
```

This second methods does the classification. It extracts the aforementioned features to then train a classifier. It can also store the trained classifier (into the ```SVM_classifier``` folder).


A classifier has been pre-trained, so by running ```sp-cup_extract_features.py``` you can see the performance for that particular trained classifier.

Note that for the sample classifier, ```SVM_classifier``` you must not unzip it to use it.


#### Note (Update: We have permission!!!!)

We need to ask permission to use a modified version of the code since they state that:

Redistribution: This code, in whole or in part, will not be further distributed, published, copied, or disseminated in any way or form whatsoever, whether for profit or not.

If not, we will use a similar approach to train our own method from scratch, since the above code has shown to be very effective.

## interpolation

This implementation is based on the following paper:

Ashwin Swaminathan, Min Wu, and K. J. Ray Liu. 2007. Nonintrusive Component Forensics of Visual Sensors Using Output Images. Trans. Info. For. Sec. 2, 1 (March 2007), 91-106. [IEEE](http://ieeexplore.ieee.org/document/4100631/)

This method focuses on finding the CFA pattern and estimating the interpolation coefficients by assuming a different linear interpolation algorithm is applied on the different regions (smooth, horizontal gradient, and vertical gradient) and different color channels of the image. These estimated interpolation coefficients are found by minimizing the error between the estimated image and the original image. They can be used as "features" unique to the camera model and thus can be used to classify different camera models.

#### Technical details

The MATLAB script ```dataCollection.m``` will collect the relevant interpolation data (CFA pattern and interpolation coefficients) and save them in ```interpolation/parameters```.

The python script ```train_classifier.py``` trains a linear SVM classifier with this data and prints the accuracy rate for each camera model.
