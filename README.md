# Mental Wellbeing

This repository includes the data preprocessing steps carried out in the research article: [ ].

The input can be an .xlsx or .csv file containing the respective social media data (eg. Facebook or Twitter). 

**1.Preprocessing datasets**
For both the datasets of Facebook and Twitter, we applied the following data preprocessing steps: 
1.	Timezone conversion (from Unixtime to UTC to SGT)
2.	Removal of name at mentions for both Twitter and Facebook
3.	Attempt at troll removal by removing duplicated comments, comments with troll-related keywords, email addresses and 1-character comments 
4.	Other text preprocessing: digits replacement, removal of accented, non-ASCII characters, lowercase conversion, punctuation removal, URL removal, stopwords removal, tokenization, lemmatization

In running the code for preprocessing **Facebook** data, ideally it would be done in the following order: 
1. Getting SG pages only 
2. Dropping duplicates
3. Troll removal
4. Timezone conversion
5. Preprocessing FB data
6. Removing name tags (this should be last step as it requires more processing time)

In running the code for preprocessing **Twitter** data, ideally it would be done in the following order: 
1. Dropping duplicates
3. Troll removal
4. Timezone conversion
5. Twitter influencer tagging and adding emotion category
6. Preprocessing Twitter data 

**2.Obtaining daily aggregates**
Run the code in "grouping by date" folder to obtain data categorized by date rather than by comment.


Afterwards we obtained the daily aggregate or daily mean counts of each variable. 
The data was pre-processed further by normalizing Z-score, first using difference to ensure stationarity, removing volatility by dividing by monthly standard deviation and removing seasonality by subtracting monthly means as a prerequisite to running Granger causality test.


Steps to install python packages and run script

- Install the latest version of python (>=3.6) or create a conda virtual environment.

- Open Command Prompt or Terminal depending on operating system (Windows, Linux or Mac OS)

- Navigate to desired directory using cd based on where the script and data files are

- Type in: "python main.py datafile column_name keywordfile"
	
	-> <datafile> can be .xlsx or .csv, 
	
	-> <column_name> should be a valid column in the data file,
	
	-> each row in <keywordfile> represents a single type of topic i.e. whether the keywords in the dataset match this filter, hence forming a single filter/topic
	
	-> there should be no spaces between the keywords in the keywordfile)

	-> Example: python main.py fb_data.csv entry_text "FB MW keywords.txt"
- Run through 'Keeping relevant MW data' code using Jupyter Notebook to get relevant Mental Wellbeing Facebook dataset<br />


**2. Preprocessing datasets**
- Removing duplications
- Influencer removal for Twitter dataset
- Troll removal including removing comments with email addresses, 1-character comments and comments with punctuation only
- Timezone conversion (from Unixtime to UTC to SGT)<br /> 
	
Citation:
If you use this script and find it useful for your research, please cite the source as: 

For correspondence, please contact yangyp@ihpc.a-star.edu.sg<br />
