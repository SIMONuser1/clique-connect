
# data analysis and wrangling
import pandas as pd
import numpy as np
import random as rnd

# visualization
import seaborn as sns
import matplotlib.pyplot as plt
get_ipython().magic(u'matplotlib inline')
from scipy import stats

# machine learning
from sklearn.linear_model import LogisticRegressionCV
from sklearn.svm import SVC, LinearSVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.linear_model import Perceptron
from sklearn.linear_model import SGDClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn import preprocessing
from sklearn.model_selection import train_test_split
from sklearn.metrics import recall_score
from sklearn.metrics import precision_score

# acquire data
attributes = pd.read_csv('attributes.csv', sep=';')
daily_metrics = pd.read_csv('daily_metrics.csv', sep=';')


# converting gender to numerical values
attributes['gender'] = attributes['gender'].map( {'female': 1, 'male': 0, '': 0} ).astype(str).astype(float)
a = attributes.country_iso2.value_counts()
b = []
for x in attributes.country_iso2.unique():
    if a[x] < 1000:
        b.append(x)

for iso in b:
    attributes.loc[(attributes['country_iso2'] == iso, 'country_iso2')] = 'ROW'
for iso in ['BE', 'NL']:
    attributes.loc[(attributes['country_iso2'] == iso, 'country_iso2')] = 'BENELUX'
for iso in ['DK', 'NO', 'SE']:
    attributes.loc[(attributes['country_iso2'] == iso, 'country_iso2')] = 'SCANDINAVIE'
for iso in ['ES', 'PT']:
    attributes.loc[(attributes['country_iso2'] == iso, 'country_iso2')] = 'IBERE'
for iso in ['CO', 'CL']:
    attributes.loc[(attributes['country_iso2'] == iso, 'country_iso2')] = 'CO/CL'

# converting country to numerical values
for iso in attributes.country_iso2.unique():
        attributes['is_' + iso + '?'] = attributes['country_iso2'].map( {iso: 1.0} ).astype(str).astype(float)
# replacing NaN values by 0
attributes = attributes.fillna(0)

# rename column
attributes.columns = attributes.columns.str.replace(' ','')

# merge dataframes
dataset = pd.merge(attributes, daily_metrics, how='inner', on='id')
dataset = dataset.drop(['Unnamed: 0', 'row', 'country_iso2', 'id'], axis=1)
dataset = dataset[(np.abs(stats.zscore(dataset)) < 10).all(axis=1)]
dataset = dataset.fillna(0)
dataset.reset_index(inplace=True, drop=True)
dataset.head(2)

# create Y
columns = ["d_7__n_open", "d_7__n_timeline_scrolled", "d_7__n_timeline_refreshed","d_8__n_open", "d_8__n_timeline_scrolled", "d_8__n_timeline_refreshed","d_9__n_open", "d_9__n_timeline_scrolled", "d_9__n_timeline_refreshed"]
Y = pd.DataFrame({"churner" : pd.DataFrame(dataset, columns=columns).sum(axis=1)})
Y.loc[(Y["churner"]>0,"churner")] = 2
Y.loc[(Y["churner"]==0,"churner")] = 1
Y.loc[(Y["churner"]>1,"churner")] = 0
Y.head(3)

# create X
X = dataset[dataset.columns[0:97]]
X.describe().T.sort_values('std')


X_train, X_test, Y_train, Y_test = train_test_split(X.copy(), Y["churner"], test_size=0.30)
X_train.shape, Y_train.shape, X_test.shape

# standardize dataset
x_train = X_train.values # returns a numpy array
x_test = X_test.values
scaler = preprocessing.StandardScaler()
x_train_scaled = scaler.fit_transform(x_train)
x_test_scaled = scaler.transform(x_test)
X_train = pd.DataFrame(x_train_scaled, columns=dataset[dataset.columns[0:97]].columns.values)
X_test = pd.DataFrame(x_test_scaled, columns=dataset[dataset.columns[0:97]].columns.values)
for iso in attributes.country_iso2.unique():
        X_train['is_' + iso + '?'] = dataset['is_' + iso + '?']
for iso in attributes.country_iso2.unique():
        X_test['is_' + iso + '?'] = dataset['is_' + iso + '?']


# Logistic Regression

logreg = LogisticRegressionCV()
logreg.fit(X_train.as_matrix(), Y_train.as_matrix())
Y_pred = logreg.predict(X_test)
Y_pred_proba = logreg.predict_proba(X_test)
acc_log = round(logreg.score(X_test, Y_test) * 100, 2)
rec_log = round(recall_score(Y_pred, Y_test) * 100, 2)
pre_log = round(precision_score(Y_pred, Y_test) * 100, 2)

print "accuracy: %f" % acc_log
print "recall: %f" % rec_log
print "precision: %f" % pre_log

skplt.plot_precision_recall_curve(Y_test,Y_pred_proba, figsize=(10,10))

coeff_df = pd.DataFrame(X_train.columns)
coeff_df.columns = ['Feature']
coeff_df["Correlation"] = pd.Series(logreg.coef_[0])

# Perceptron

perceptron = Perceptron()
perceptron.fit(X_train, Y_train)
Y_pred = perceptron.predict(X_test)
acc_perceptron = round(perceptron.score(X_test, Y_test) * 100, 2)
rec_perceptron = round(recall_score(Y_pred, Y_test) * 100, 2)
pre_perceptron = round(precision_score(Y_pred, Y_test) * 100, 2)


print "accuracy: %f" % acc_perceptron
print "recall: %f" % rec_perceptron
print "precision: %f" % pre_perceptron

# Linear SVC

linear_svc = LinearSVC()
linear_svc.fit(X_train, Y_train)
Y_pred = linear_svc.predict(X_test)
acc_linear_svc = round(linear_svc.score(X_test, Y_test) * 100, 2)
rec_linear_svc = round(recall_score(Y_pred, Y_test) * 100, 2)
pre_linear_svc = round(precision_score(Y_pred, Y_test) * 100, 2)


print "accuracy: %f" % acc_linear_svc
print "recall: %f" % rec_linear_svc
print "precision: %f" % pre_linear_svc

# Stochastic Gradient Descent

sgd = SGDClassifier()
sgd.fit(X_train, Y_train)
Y_pred = sgd.predict(X_test)
acc_sgd = round(sgd.score(X_test, Y_test) * 100, 2)
rec_sgd = round(recall_score(Y_pred, Y_test) * 100, 2)
pre_sgd = round(precision_score(Y_pred, Y_test) * 100, 2)


print "accuracy: %f" % acc_sgd
print "recall: %f" % rec_sgd
print "precision: %f" % pre_sgd

# Decision Tree

decision_tree = DecisionTreeClassifier()
decision_tree.fit(X_train, Y_train)
Y_pred = decision_tree.predict(X_test)
acc_decision_tree = round(decision_tree.score(X_test, Y_test) * 100, 2)
rec_decision_tree = round(recall_score(Y_pred, Y_test) * 100, 2)
pre_decision_tree = round(precision_score(Y_pred, Y_test) * 100, 2)


print "accuracy: %f" % acc_decision_tree
print "recall: %f" % rec_decision_tree
print "precision: %f" % pre_decision_tree

# Random Forest

random_forest = RandomForestClassifier(n_estimators=100)
random_forest.fit(X_train, Y_train)
Y_pred = random_forest.predict(X_test)
random_forest.score(X_train, Y_train)
acc_random_forest = round(random_forest.score(X_test, Y_test) * 100, 2)
rec_random_forest = round(recall_score(Y_pred, Y_test) * 100, 2)
pre_random_forest = round(precision_score(Y_pred, Y_test) * 100, 2)

print "accuracy: %f" % acc_random_forest
print "recall: %f" % rec_random_forest
print "precision: %f" % pre_random_forest

models = pd.DataFrame({
    'Model': ['Logistic Regression',
              'Random Forest', 'Perceptron',
              'Stochastic Gradient Decent', 'Linear SVC',
              'Decision Tree'],
    'Accuracy': [acc_log,
              acc_random_forest, acc_perceptron,
              acc_sgd, acc_linear_svc, acc_decision_tree],
    'Recall': [rec_log,
              rec_random_forest, rec_perceptron,
              rec_sgd, rec_linear_svc, rec_decision_tree],
    'Precision': [pre_log,
              pre_random_forest, pre_perceptron,
              pre_sgd, pre_linear_svc, pre_decision_tree]})
models = models.reindex_axis(['Model','Accuracy','Recall','Precision'], axis=1)
models.sort_values(by='Accuracy', ascending=False)

