# -*- coding: UTF-8 -*-
"""
sp-cup
"""

import os
os.environ['GLOG_minloglevel'] = '2'
import argparse
from caffe_wrapper import extract_features_scores
from patch_extractor import patch_extractor, mid_intensity_high_texture
import cv2
import numpy as np
import pickle

from params import caffe_root,caffe_mean_path,caffe_best_model_path, patch_num, patch_dim, patch_stride, caffe_best_model_path, caffe_txt_path_generator

from collections import Counter

flatten = lambda l: [item for sublist in l for item in sublist]

folder = 'data_features/'
suffix_info = '_features.npy'

classifier_location = 'SVM_classifier/'

# returns the features for model, for samples from start to end 
def extract_features(model, nb_samples):

    # Get file names
    # note that they are not sorted as per Finder in osx.
    # .lower() for .JPG
    directory = "../data/" + model
    images_in_dir = [img for img in os.listdir(directory) if '.jpg' in img.lower()]
    
    if len(images_in_dir) < nb_samples:
        raise ValueError('Not enough images in: {:}'.format(model))

    files = images_in_dir[0:nb_samples]
    

    # Set up (From external project)
    labels_file = caffe_txt_path_generator('labels')
    with open(labels_file,'r') as f:
        labels = f.readlines()
    labels = [i[:-1] for i in labels]

    cnn_model_path = os.path.join(caffe_root,'deploy.prototxt') 

    sample_features = []
    for file_path in files:
        file_path = directory + '/' + file_path

        img = cv2.imread(file_path)
        patches = patch_extractor(img,patch_dim,stride=patch_stride,num=patch_num,function=mid_intensity_high_texture)
        features,_ = extract_features_scores(cnn_model_path, caffe_best_model_path, caffe_mean_path,patches)
        sample_features.append(features)

    return sample_features

def save_on_disk(X, model):
    np.save(folder + model + suffix_info, X)

def save_model_features_on_disk(models, nb_samples):
    
    for model in models:
        print('saving model {} features...'.format(model))
        X = extract_features(model, nb_samples)
        X = flatten(X)
        X = [sample.reshape(1, sample.shape[0]) for sample in X]
        X = np.vstack(X)
        save_on_disk(X, model)


def load_single_model_features(model):
    return np.load(folder + model + suffix_info)

def load_models_features(models):
    
    models_features = []
    for model in models:
        models_features.append(load_single_model_features(model))

    return models_features

def save_clf_on_disk(clf, clf_name):
    with open(classifier_location + clf_name + '.pkl', 'wb') as f:
        pickle.dump(clf, f)

def load_clf(clf_name):
    with open(classifier_location + clf_name + '.pkl', 'rb') as f:
        return pickle.load(f)


def main():
    #models = ['LG-Nexus-5x', 'Motorola-Nexus-6', 'iPhone-4s']
    #models = ['Sony-NEX-7', 'Samsung-Galaxy-S4', 'iPhone-6', 'Motorola-Nexus-6']
    models = ['HTC-1-M7', 'iPhone-4s', 'iPhone-6', 'LG-Nexus-5x', 'Motorola-Droid-Maxx', 'Motorola-Nexus-6', 'Motorola-X', 'Samsung-Galaxy-Note3', 'Samsung-Galaxy-S4', 'Sony-NEX-7']

    #nb_samples = 275
    #save_model_features_on_disk(models, nb_samples)


if __name__=='__main__':
    main()

