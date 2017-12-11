# -*- coding: UTF-8 -*-
"""
sp-cup
"""


import scipy.io
import numpy as np
import os
from random import shuffle
from sklearn.svm import SVC
from sklearn import svm

rootdir = './parameters'

X_acc = []

flatten = lambda l: [item for sublist in l for item in sublist]

# “one-against-one” approach (Knerr et al., 1990) for multi- class classification
def train_clf(X, y):
    print('Training classifier. . . ')
    clf = svm.SVC(decision_function_shape='ovo')
    clf.fit(X, y) 
    return clf

def train_linear_clf(X, y):
    lin_clf = svm.LinearSVC()
    lin_clf.fit(X, y)   
    return lin_clf

for subdir, dirs, files in os.walk(rootdir):
    X_model = []
    if 'DS_Store' not in files[0]:
        for file in files:
            path = os.path.join(subdir, file)
            mat = scipy.io.loadmat(path)
            tmp = np.vstack(mat['param'][0][1].flatten()).flatten()

            if not np.any(np.isnan(tmp)):
                X_model.append(tmp)

        X_acc.append(X_model)


X_train = []
X_eval = []

flag = 0
for X_model in X_acc:
    shuffle(X_model)
    split = int(np.floor(len(X_model) * 0.6))
    cap = 0
    if flag == 0:
        cap = 90
        flag = 1
    X_train.append(X_model[:split - cap])

    X_eval.append(X_model[split:])

index = 0
Y_train = []
for X_model in X_train:
    Y_train.append(np.full((len(X_model),1), index))
    index += 1


X_train_tmp = X_train
Y_train = np.ravel(np.vstack(Y_train))
X_train = np.vstack(flatten(X_train))


clf = train_linear_clf(X_train, Y_train)

predicted = []
index = 0
for X_model in X_eval:
    counter = 0
    for X_sample in X_model:
        pred_sample = clf.predict(X_sample.reshape(1, X_sample.shape[0]))
        counter += int(pred_sample == index)
    predicted.append((counter * 1.0) / float(len(X_model)))

    index += 1

print predicted

    

#mat = scipy.io.loadmat('./parameters/HTC-1-M7/100_1.mat')
#res = np.vstack(mat['param'][0][1].flatten())
#print(res.flatten().shape)
