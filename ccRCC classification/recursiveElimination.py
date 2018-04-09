import pandas
import numpy
from sklearn.feature_selection import RFE
from sklearn.linear_model import LogisticRegression

# load data
names = []
numFeatures = 38
for i in range(numFeatures):
    colName = 'var' + str(i)
    names.append(colName)
names.append('output')
dataframe = pandas.read_csv('Assets\\featureMatrix.csv', names=names)
array = dataframe.values

X = array[:,0:-1]
Y = array[:,-1]

model = LogisticRegression()

while numFeatures>9:
##    rfe = RFE(model, numFeatures)
    rfe = RFE(model, 1)
    fit = rfe.fit(X, Y)
    X = rfe.transform(X)
    print(rfe.ranking_)

##    fileName = 'Output\\RFE\\imMat_' + str(numFeatures) + '.csv'    
##    finalArray = numpy.hstack((X,Y[:,None]))
##    index = ['Row'+str(i) for i in range(1, len(finalArray)+1)]
##    finalDF = pandas.DataFrame(finalArray, index=index)
##    finalDF.to_csv(fileName)
    

##    numFeatures = numFeatures - numFeatures/10
    numFeatures = 1
    
