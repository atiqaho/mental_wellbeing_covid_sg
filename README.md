Mental Wellbeing

This repository includes the data preprocessing steps carried out in the research article: [ ].

The input can be an .xlsx or .csv file containing the respective social media data (eg. Facebook or Twitter). 

1) Obtaining Mental Wellbeing dataset from Facebook data

Steps to install python packages and run script

- Install the latest version of python (>=3.6) or create a conda virtual environment.

- Open Command Prompt or Terminal depending on operating system (Windows, Linux or Mac OS)

- Navigate to desired directory using cd based on where the script and data files are

- Type in "python main_filtering.py <datafile> <column_name> <keywordfile> 
	
	-> <datafile> can be .xlsx or .csv, 
	
	-> <column_name> should be a valid column in the data file,
	
	-> each row in <keywordfile> represents a single type of topic i.e. whether the keywords in the dataset match this filter, hence forming a single filter/topic
	
	-> there should be no spaces between the keywords in the keywordfile)

	-> Example: python main_filtering.py fb_data.csv entry_text "FB MW keywords.txt"



Citation:
If you use this script and find it useful for your research, please cite the source as: 

For correspondence, please contact yangyp@ihpc.a-star.edu.sg
