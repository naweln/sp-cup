# -*- coding: UTF-8 -*-
"""
First Steps Towards Camera Model Identification with Convolutional Neural Networks
@author: Luca Bondi (luca.bondi@polimi.it)
"""

import os
os.environ['GLOG_minloglevel'] = '2'
import argparse
from caffe_wrapper import extract_features_scores
from patch_extractor import patch_extractor, mid_intensity_high_texture
import cv2
import numpy as np
import time

from params import caffe_root,caffe_mean_path,caffe_best_model_path, patch_num, patch_dim, patch_stride, caffe_best_model_path, caffe_txt_path_generator

from save_features_to_file import load_models_features,save_clf_on_disk,load_clf

from sklearn.svm import SVC
from sklearn import svm

from collections import Counter

flatten = lambda l: [item for sublist in l for item in sublist]

# Returns the most frequent element in L
def mostFrequent(L):
    return Counter(L).most_common()[0][0]

# Given a classifier clf, and a sample, it votes on the predicted value.
# (The votes are cast for each batch in the sample classified by clf).
def majorityVote(clf, sample):
    batch_predictions = []
    for i in range(0, sample.shape[0]):
        batch_predictions.append(clf.predict(sample[i,:].reshape(1, 128))[0])
    #print(batch_predictions)
    return(mostFrequent(batch_predictions))

# Loads the features for the models stored in memory
# It does so by grouping in each model in a list, and then packing for each sample, all the corresponding patches together
# E.g. model_feature_data[k] == Samples for kth model
# model_feature_data[k][i] == The matrix feature of the patches corresponding to the i'th sample of the kth model
def get_model_data(models):

    models_features = load_models_features(models)
    total_patches = models_features[0].shape[0] # total number of patches
    nb_samples = total_patches / patch_num # total samples is total patches over patches per sample
    model_feature_data = []
    
    for model_f in models_features:
        single_model_features_data = [model_f[i*patch_num:i*patch_num+patch_num, :] for i in range(0, nb_samples)]
        # Shuffle data 
        np.random.shuffle(single_model_features_data)
        model_feature_data.append(single_model_features_data)

    return model_feature_data

# Turns the model data, as structured in get_model_data, and returns the corresponding X and y matrices for
# SVM training
def training_data_to_Xy_format(training_data):
    nb_samples = len(training_data[0])

    X = [np.vstack(flatten(td)) for td in training_data]
    X = np.vstack(X)

    y = np.vstack([np.full((nb_samples*patch_num, 1), model_id, dtype=int) for model_id in range(0, len(training_data))])
    y.ravel()

    return X, y.reshape(y.shape[0],)

# Given a classifier clf, a list of models, and the corresponding feature data v_data, displays statistics on accuracy.
def evaluate_model(clf, models, v_data):

    nb_samples = len(v_data[0])  
    predictions = []
    for model_data in v_data:
        model_predictions = []
        for sample in model_data:
            model_predictions.append(majorityVote(clf, sample))

        predictions.append(model_predictions)

    for model_id in range(0, len(models)):
        model = models[model_id]
        print(" Prediction accuracy for {}: ".format(model))
        print("Out of {} samples:".format(nb_samples))
        nb_correct_pred = sum([int(pred == model_id) for pred in predictions[model_id]])
        accuracy = nb_correct_pred / (1.0*nb_samples) * 100
        print("Correctly predicted: {} out of {} samples, for {}% accuracy.".format(nb_correct_pred, nb_samples, accuracy))

        counter = Counter(predictions[model_id])
        for i in range(0, len(models)):
            nb_pred_m = counter.get(i) if counter.get(i) is not None else 0
            if (nb_pred_m != 0 and i != model_id):
                accuracy_error = nb_pred_m / (1.0 * nb_samples) * 100
                print("Incorrectly predicted model {}, {} times, for {}% error accuracy.".format(models[i], nb_pred_m, accuracy_error))

        print("- - -")


# Split data into training and evaluation data based on desired lengths for each.
def split_data(model_feature_data, training_length, eval_length):
    if (len(model_feature_data[0]) < training_length + eval_length):
        raise ValueError('Not enough data for split data')

    training_data = []
    eval_data = []
    for dt in model_feature_data:
        training_data.append(dt[:training_length])
        eval_data.append(dt[training_length:training_length+eval_length])

    return training_data, eval_data

# “one-against-one” approach (Knerr et al., 1990) for multi- class classification
def train_clf(X, y):
    print('Training classifier. . . ')
    clf = svm.SVC(decision_function_shape='ovo')
    clf.fit(X, y) 
    return clf

def main():
  
    # Inputs
    models = ['HTC-1-M7', 'iPhone-4s', 'iPhone-6', 'LG-Nexus-5x', 'Motorola-Droid-Maxx', 'Motorola-Nexus-6', 'Motorola-X', 'Samsung-Galaxy-Note3', 'Samsung-Galaxy-S4', 'Sony-NEX-7']

    training_length = 100
    eval_length = 100
    model_feature_data = get_model_data(models) 
    clf_name = 'clf_test'

    training_data, eval_data = split_data(model_feature_data, training_length, eval_length)
    X,y = training_data_to_Xy_format(training_data)

    # Save classifier
    #clf = train_clf(X, y)
    #save_clf_on_disk(clf, clf_name)

    # Use saved one
    # Load classifier
    clf = load_clf(clf_name)
      
    print ('Evaluating classifier. . .')
    evaluate_model(clf, models, eval_data)

    # Note that the training data was randomly shuffled, so evaluating it will as currently is, based on a previously
    # stored clf is not very accurate since evaluation data might have been fed into the training one (new instance, new shuffle).
    # Need to seprate training and evaluation data before hand for this, for example.




if __name__=='__main__':
    main()
