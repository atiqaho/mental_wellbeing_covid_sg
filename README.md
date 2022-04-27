# Mental Wellbeing

This repository includes the data preprocessing steps carried out in the research article: [ ].

The input can be an .xlsx or .csv file containing the respective social media data (eg. Facebook or Twitter). 

**1.Preprocessing datasets**

For both the datasets of Facebook and Twitter, we applied the following data preprocessing steps: 
- Timezone conversion (from Unixtime to UTC to SGT)
- Removal of name at mentions for both Twitter and Facebook
- Attempt at troll removal by removing duplicated comments, comments with troll-related keywords, email addresses and 1-character comments 
- Other text preprocessing: digits replacement, removal of accented, non-ASCII characters, lowercase conversion, punctuation removal, URL removal, stopwords removal, tokenization, lemmatization

In running the code for preprocessing **Facebook** data, ideally it would be done in the following order: 
1. Getting SG pages only 
2. Dropping duplicates
3. Troll removal
4. Timezone conversion
5. Preprocessing FB data
6. Removing name tags (this should be last step as it requires more processing time)<br />

In running the code for preprocessing **Twitter** data, ideally it would be done in the following order: 
1. Dropping duplicates
3. Troll removal
4. Timezone conversion
5. Twitter influencer tagging and adding emotion category
6. Preprocessing Twitter data 

**2.Obtaining daily aggregates**

Run the code in "grouping by date" folder to obtain data categorized by date rather than by comment.

**3.Clean time series data**
 
The time series data (daily aggregates) was pre-processed further by normalizing Z-score, first using difference to ensure stationarity, removing volatility by dividing by monthly standard deviation and removing seasonality by subtracting monthly means as a prerequisite to running Granger causality test. (This code is not ours and is taken from https://github.com/ritvikmath/Time-Series-Analysis/blob/master/Time%20Series%20Data%20Preprocessing.ipynb)

**4.Applying Granger Causality**

In applying granger causality on the dataset,
1. Run the code "VAR model - granger causality LATEST 26APR2022.ipynb" to check for stationarity and to obtain p-values of Granger causality scores across all variables. The test used here is the chi-square test. (This code is not ours and is taken from https://www.machinelearningplus.com/time-series/vector-autoregression-examples-python/)
2. Run the code "Granger causality test scores LATEST 26APR2022.ipynb" to obtain the no. of lags for the respective p-values, after manually sifting out significant values/interactions on your own based on earlier code. (This code is not ours and is taken from https://github.com/ritvikmath/Time-Series-Analysis/blob/master/Granger%20Causality.ipynb)


Credit:
Apart from the authors/references mentioned above, the code in this project is written by Ajay Vishwanath, Brandon Loh Siyuan, Zhang Mila and Nur Atiqah Othman, either individually or collaboratively.

Citation:
If you use this script and find it useful for your research, please cite the source as: 

For correspondence, please contact yangyp@ihpc.a-star.edu.sg<br />
