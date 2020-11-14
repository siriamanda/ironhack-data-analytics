Python

Tips: Use shift and tab for suggestions of how to complete a function

```python
# Check in which directory you are with the module os

import os
cwd = os.getcwd()

print(cwd)
```

Python 'ingredients':

```python
import pandas as pd
import numpy as np
pd.set_option('display.max_columns', None)
import warnings
warnings.filterwarnings('ignore')
import matplotlib.pyplot as plt
import seaborn as sns 
%matplotlib inline
```

Import file:

```python
# CSV:

df = pd.read_csv('file1.csv')        # with pandas

# Excel:

df = pd.read_excel('file3.xlsx')

# Text file:
  
# read in a .txt file by using "space" (\t) as a seperator with function sep

file2 = pd.read_csv('file2.txt', sep='\t')

# SQL:
  
data = pd.read_sql(query, db_url)


```

Save to CSV file:

```python
df.to_csv('sirinewfile.csv')
```

Useful commands for DATA EXPLORATION

```python
# Use display.max_rows to set up hos many rows of a dataframe to show

# Return the first rows of a dataframe with panda function head

head()

# Return the last rows of a dataframe with panda function head

tail()

# number of rows and columns in a dataframe

df.shape

# Entries, columns, column-names, data type etc.

df.info()

# count, mean, std, min, max etc. for each column

df.describe()

# Filter data columns. Examples:

data[data['Income'] <= 0]

data[(data["state"]=="FL") & (data["gender"]=='M')]

# Filtering dataset with query

data.query('gender=="M" & state=="FL" ')

# the datatypes of columns

df.dtypes

# Detect missing values.Check whether a cell in empty (True/False)

df.isna()

# Remove null values with 'dropna'

# Count null values in a column

len(df[df['column'].isna()==True])

# Find out the percentage of missing values in each column

nulldf = round(file1.isna().sum()/len(file1),4) * 100

# The nunique() function is used to count distinct observations over requested axis.Return Series with number of distinct observations. Can ignore NaN values.

df.nunique(self, axis=0, dropna=True)

# Count how many times a value occur. The value_counts() function is used to get a Series containing counts of unique values.The resulting object will be in descending order so that the first element is the most frequently-occurring element. Excludes NA values by default.

df.value_counts(self, normalize=False, sort=True, ascending=False, bins=None, dropna=True)

# View specified rows

df[1:15]

# View specified rows and columns

df[['gender', 'state', 'hvp1']][1:15]

# iloc: is primarily integer position based (from 0 to length-1 of the axis), but may also be used with a boolean array.

filtered_reindex.iloc[0:15,[1,2,4]]

# Return columns of a specific datatype

df.select_dtypes('float64', 'int32')

```

Useful commands for DATA CLEANING

```python
# Rename columns

df_1 = df.rename(columns={"ST": "State", "GENDER": "Gender"})

# Standardise header names (lower case)

column_names = column_names.str.lower()

# Standardise header names (lower case and replace ' ' with '_')

df.columns = [e.lower().replace(' ', '_') for e in df.columns]

# dataframe columns

column_names = df.columns

# Change order of columns

df = df[['Customer', 'State', 'Customer Lifetime Value', 'Education', 'Gender', 'Income', 'Monthly Premium Auto', 'Number of Open Complaints','Policy Type', 'Total Claim Amount', 'Vehicle Class']]

# pd.DataFrame. Create a two-dimensional size-mutable, potentially heterogeneous tabular data structure with labeled axes (rows and columns). A Data frame is a two-dimensional data structure, i.e., data is aligned in a tabular fashion in rows and columns. Pandas DataFrame consists of three principal components, the data, rows, and columns.

# First adding columns

df = pd.DataFrame(columns = column_names_1)

# Concanate tables either horizontally (axis=0) or vertically (axis=1)

df = pd.concat([df, df_1], axis = 0)

# Resetting the index
# When brinigng multiple tables together, you might find that the index is only for the first file you brought in
# To make sure you can see the whole dataset you might have to do an index reset

data = data.reset_index(drop=True)

# Drop duplicates

df = df.drop_duplicates()

# Drop or delete column

df = df.drop(['Education'], axis = 1)

# Drop repeted columns (duplicates): pass the list of duplicate column's names returned by our user defines function getDuplicateColumns() to the Dataframe. drop()method.

temp_df = df.loc[:,~df.columns.duplicated()]

# Copy dataframe
# It can be useful to create a temporary dataset before deleting or changing datatype in the original dataset

tempdataset = df.copy()

# Change data type to numeric (add error to enforce command)

df['Column_name'] = pd.df(tempdataset['Column_name'], errors = 'coerce')

# Change column to 'datetime' format

df['effective_to_date'] = pd.to_datetime(df['effective_to_date'], errors = 'coerce')

# Return a set that contains all items from both sets, duplicates are excluded:

x = {"apple", "banana", "cherry"}
y = {"google", "microsoft", "apple"}

z = x.union(y)

```

DATA VISUALISATION

```python
# Seaborn barchart 

sns.countplot(x = 'response', data = file1)
sns.countplot(x = 'sales_channel', hue = 'response', data = file1)

# Seaborn boxplot

sns.boxplot(x = 'response', y = 'total_claim_amount', data = file1)

# matplotlib scatterplot

plt.scatter(x = df['actual_weight'], y = df['actual_height'])

# matplotlib histogram 

data['actual_weight'].hist(bins=20)

# matplotlib boxplot

data[['actual_height']].boxplot()

# Seaborn correlation matrix

sns.heatmap(correlations_matrix, annot = True)
plt.show()

# Correlation matrix 2

mask = np.zeros_like(correlations_matrix)
mask[np.triu_indices_from(mask)] = True
fig, ax = plt.subplots(figsize=(10, 8))
ax = sns.heatmap(correlations_matrix, mask=mask, annot=True)
plt.show()

# matplotlib histogram from random sample
plt.hist(np.random.randn(10000), bins=40)
plt.show()

# Normal curve

from scipy.stats import norm
import math
normal = norm(0, math.sqrt(9)) 
# print(normal.pdf(4))
# print(normal.cdf(2))       
# print(normal.rvs()) 
fig, ax = plt.subplots(1, 1)
x = np.linspace(-3,3,1000)
y = norm.pdf(x)
ax.plot(x,y)
plt.show()
```

Scipy.stats

```python
import scipy.stats as stats
import math

```

Sklearn

```python
from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.model_selection import train_test_split
import sklearn.model_selection as model_selection
```

Machine learning:

```python
# x, y split

y = data_numeric['customer_lifetime_value']
X = data_numeric.drop(['customer_lifetime_value'], axis=1)

# train_test_split

X_train, X_test, y_train, y_test = model_selection.train_test_split(X, y, train_size = 0.67,test_size = 0.33, random_state = 100)

# OLS Regression

import statsmodels.api as sm
from statsmodels.formula.api import ols
Y = data['TARGET_D']
X = data.drop(['TARGET_D'], axis=1)
X = sm.add_constant(X)
model = sm.OLS(Y,X).fit()
print(model.summary())

# Normalize numeric data 

from sklearn.preprocessing import Normalizer
transformer = Normalizer().fit(X)
x_normalized = transformer.transform(X)
print(x_normalized)
x_normalized.shape

# get dummies pandas to change categorical values to numerical

data_categoric = pd.get_dummies(data_categoric.columns, drop_first=True).head()
data_categoric

# Merge numeric and categoric data

data_merged = pd.concat([data_numeric, data_categoric], axis=1)
data_merged

# Applying linear regression sklearn

from sklearn.linear_model import LinearRegression as LinReg
data_linreg = LinReg()                   # Model
data_linreg.fit(X_train, y_train)        # Train the model using the training sets
y_prediction = data_linreg.predict(X_test)    # Make predictions for y using the testing set

# From Sian's workbook

from sklearn import linear_model
from sklearn.metrics import mean_squared_error, r2_score
Y = data['TARGET_D']
X = data.drop(['TARGET_D'], axis=1)
lm = linear_model.LinearRegression()
model = lm.fit(X,Y)
lm.score(X,Y)

# Train model 

import statsmodels.api as sm
from statsmodels.formula.api import ols

X_train_wi = sm.add_constant(X_train)
model = sm.OLS(y_train,X_train_wi).fit()

print(model.summary())

```

Model validation:

```python
# R2

print('train R2: {} -- test R2: {}'.format(data_linreg.score(X_train, y_train),
                                            data_linreg.score(X_test, y_test)))

# MSE

from sklearn.metrics import mean_squared_error as mse


train_mse = mse(data_linreg.predict(X_train), y_train)
test_mse = mse(data_linreg.predict(X_test), y_test)

print ('train MSE: {} -- test MSE: {}'.format(train_mse, test_mse))

# RMSE

print ('train RMSE: {} -- test RMSE: {}'.format(train_mse**.5, test_mse**.5))

# MAE

from sklearn.metrics import mean_absolute_error as mae

train_mae = mae(data_linreg.predict(X_train), y_train)
test_mae = mae(data_linreg.predict(X_test), y_test)

print ('train MAE: {} -- test MAE: {}'.format(train_mse, test_mse))
```



Login to mySQL:

```Python
from sqlalchemy import create_engine
import pandas as pd
import getpass  # To get the password without showing the input
password = getpass.getpass()   # Create variable for password
```

Link MySQL database:

```Python
# this is the general syntax 'dialect+driver://username:password@host:port/database'
# to create the connection string

connection_string = 'mysql+pymysql://root:' + password + '@localhost/bank'
engine = create_engine(connection_string)
data = pd.read_sql_query('SELECT * FROM bank.loan', engine)
data.head()

import pymysql
from sqlalchemy import create_engine
import pandas as pd
import getpass  # To get the password without showing the input
password = getpass.getpass()

db_url = f'mysql+pymysql://root:{password}@localhost/sakila'       # db_url is the variabel you will refer to
```

Read sql dataframe

```python
data = pd.read_sql(query, db_url)

```

