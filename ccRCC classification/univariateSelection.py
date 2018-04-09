
import pandas
import numpy
from sklearn.feature_selection import SelectPercentile
from sklearn.feature_selection import chi2
from sklearn.feature_selection import f_classif
from sklearn.feature_selection import mutual_info_classif

# load data
names = []
for i in range(38):
    colName = 'var' + str(i)
    names.append(colName)
names.append('output')
dataframe = pandas.read_csv('Assets\\featureMatrix.csv', names=names)
array = dataframe.values

X = array[:,0:38]
Y = array[:,38]

# feature extraction
for i in range(10):
    percentile=i*10+10
##    test = SelectPercentile(score_func=chi2, percentile=percentile)
##    fit = test.fit(abs(X), Y)
##    test = SelectPercentile(score_func=f_classif, percentile=percentile)
    test = SelectPercentile(score_func=mutual_info_classif, percentile=percentile)
    fit = test.fit(X, Y)

##    fileName = 'Output\\imMat_chi_' + str(percentile) + '.csv'
##    fileName = 'Output\\imMat_anova_' + str(percentile) + '.csv'
    fileName = 'Output\\imMat_MI_' + str(percentile) + '.csv'    

    features = fit.transform(X)
    finalArray = numpy.hstack((features,Y[:,None]))
    index = ['Row'+str(i) for i in range(1, len(finalArray)+1)]
    finalDF = pandas.DataFrame(finalArray, index=index)
    finalDF.to_csv(fileName)


