# Predicting public mental health needs

This repository includes the data preprocessing steps carried out in the research article: Predicting public mental health needs in a crisis using social media indicators: A Singapore big data study

The input can be an .xlsx or .csv file containing the social media data. 

Steps 1-4 are done in Python, whereas step 5 is done in R.

**1.Preprocessing datasets**

In running the code for preprocessing **Twitter** data, ideally it would be done in the following order: 
1. Dropping duplicates
2. Troll removal
   (removing duplicated comments, comments with troll-related keywords, email addresses and 1-character comments)
3. Twitter influencer tagging 
4. Adding emotion category
5. Get relevant date

**2.Obtaining daily aggregates**

Run the code in "grouping by date" folder to obtain data categorized by date rather than by comment.

**3.Clean time series data**
 
The time series data (daily aggregates) was pre-processed further by normalizing Z-score, first using difference to ensure stationarity, removing volatility by dividing by monthly standard deviation and removing seasonality by subtracting monthly means as a prerequisite to running time series analysis. (This code is not ours and is taken from https://github.com/ritvikmath/Time-Series-Analysis/blob/master/Time%20Series%20Data%20Preprocessing.ipynb)

**4.Applying Granger Causality**

In applying granger causality on the dataset,
1. Run the code "VAR model - granger causality LATEST 26APR2022.ipynb" to check for stationarity and to obtain p-values of Granger causality scores across all variables. The test used here is the chi-square test. (This code is not ours and is taken from https://www.machinelearningplus.com/time-series/vector-autoregression-examples-python/)
2. Run the code "Granger causality test scores LATEST 26APR2022.ipynb" to obtain the no. of lags for the respective p-values, after manually sifting out significant values/interactions on your own based on earlier code. (This code is not ours and is taken from https://github.com/ritvikmath/Time-Series-Analysis/blob/master/Granger%20Causality.ipynb)

**5.Applying ARIMA models**
Carry out ARIMA models on the factors that were found significant earlier (from the Granger Causality model) as a multivariate model, to see which model performs the best and which variables contribute to such a model.

Credit:
Apart from the authors/references mentioned above, the code in this project is written by Ajay Vishwanath, Brandon Loh Siyuan, Zhang Mila and Nur Atiqah Othman, either individually or collaboratively.

For correspondence, please contact yangyp@ihpc.a-star.edu.sg<br />
