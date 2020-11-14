Monday

```Python
# Create fake data with make_blobs

X, y = make_blobs(n_samples=[100, 1000], cluster_std=4, n_features=2, random_state=42)
```

selecting numerical values

```python
numerical_data = df.select_dtypes(np.number)

```

Selecting categorical values

```python
categorical_data = df.select_dtypes(np.object)

```

Binning:

```Python
# Check for value counts:

data['MDMAUD'].value_counts()

# Create a list with the values you want to group as 'other' (for example)

mdmaud_values = list(np.unique(data['MDMAUD']))
mdmaud_values

mdmaud_values.remove('XXXX')  # Removing the value we want to keep

# Define function for the clean

def clean_MDMAUD(x):
    if x in mdmaud_values:
        return 'other'
    else:
        return x

data['MDMAUD'] = list(map(clean_MDMAUD, data['MDMAUD']))

# Check value counts:

data['MDMAUD'].value_counts()

```

Regular Expressions

```Python
# Regex finding any phone number

pattern2 = re.findall(r'[\+\(]?[1-9][0-9 .\-\(\)]{8,}[0-9]', text)

```

Replace zeros with median

```python
# Example: Replace zeros with median for column 'Income'

median_income=customer_df['income'].median(skipna=True)       
customer_df['income']=customer_df.income.mask(customer_df.income==0,median_income)

# (skipna = True) to exclude NaN values
```

Matplotlib.pyplot.subplots

```python
# Create a figure and a set of subplots
# Makes it convenient to create common layouts of subplots, including the enclosing figure object, in a single call. 

# Example: Create bar chart from categorical dataframe


f, axes = plt.subplots(int(categorical_df.shape[1] / 2), 2, figsize=(18, 50))

for i, col in enumerate(categorical_df):

    sns.barplot(x = categorical_df[col].value_counts().index,
                y = categorical_df[col].value_counts(),
                ax=axes[int(i / 2)][int(i) % 2])  
    axes[int(i / 2)][int(i) % 2].set_title(col, fontsize = 14)
    axes[int(i / 2)][int(i) % 2].set_ylabel("")

plt.show()

```

Function to remove outliers

```python
# Normalisation method

def outliers(column, threshold = 3):
    data = column[abs(column.apply(lambda x: (x - column.mean()) / column.var() ** (1/2))) > threshold]
    return data
```

Binning of categorical variables:

```python
# Bin Master and Doctor as 'Graduate'

clean_customer_df["education"] = clean_customer_df["education"].apply(lambda x: "Graduate" if x in ["Master", "Doctor"] else x) 

```

