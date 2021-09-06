import pandas as pd
from tqdm import tqdm
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import re, string, unicodedata
import nltk
import sys
import os
import inflect
from nltk import word_tokenize, sent_tokenize
import re
import plotly

def remove_URL(sample):
    """Remove URLs from a sample string"""
    return re.sub(r"http\S+", "", sample)

def remove_non_ascii(words):
    """Remove non-ASCII characters from list of tokenized words"""
    new_words = []
    for word in words:
        new_word = unicodedata.normalize('NFKD', word).encode('ascii', 'ignore').decode('utf-8', 'ignore')
        new_words.append(new_word)
    return new_words

def to_lowercase(words):
    """Convert all characters to lowercase from list of tokenized words"""
    new_words = []
    for word in words:
        new_word = word.lower()
        new_words.append(new_word)
    return new_words

def remove_punctuation(words):
    """Remove punctuation from list of tokenized words"""
    new_words = []
    for word in words:
        new_word = re.sub(r'[^\w\s]', '', word)
        if new_word != '':
            new_words.append(new_word)
    return new_words

def replace_numbers(words):
    """Replace all interger occurrences in list of tokenized words with textual representation"""
    p = inflect.engine()
    new_words = []
    for word in words:
        if word.isdigit():
            new_word = p.number_to_words(word)
            new_words.append(new_word)
        else:
            new_words.append(word)
    return new_words


def normalize(words):
    words = remove_non_ascii(words)
    words = to_lowercase(words)
    words = remove_punctuation(words)
    return words

def preprocess(sample):
    sample = remove_URL(sample)
    # Tokenize
    words = nltk.word_tokenize(sample)

    # Normalize
    return normalize(words)

def tag_keyword_row(row, column, keyword):
    if pd.isna(row[column]):
        return False
    else:
        search = keyword.split(",")
        text = " ".join(preprocess(str(row[column])))        
        find = [k in text for k in search]
        if any(find):
#             print(find)
            return True
        else:
            return False
    
def tag_keyword_row_w_spaces(row, column, keyword):
    if pd.isna(row[column]):
        return False
    else:
        search = keyword.split(",")
        text = " ".join(preprocess(str(row[column])))        
        find = [k in text for k in search]
        if any(find):
            # print(find)
            return True
        else:
            return False
        
        
def write_to_excel(df, file):
    writer = pd.ExcelWriter(
        file, engine="xlsxwriter", options={"strings_to_urls": False}
    )
    df.to_excel(writer)
    writer.close()


def main():
    print(sys.argv)
    if len(sys.argv) != 4:
        print("Error: Please run the script in the following format:\n")
        print("\tpython main.py <data filename> <data column name> <keyword filename>")
        print("Example: ``python main.py headlines.xlsx Title keywords.txt''")
        print("(Note: the first keyword in the each line of keyword file will be the column name prefixed with 'is_')")
        return
    
    path = sys.argv[1]
    column = sys.argv[2]
    keyword_file = sys.argv[3]

    tqdm.pandas()
    if not os.path.isfile(path):
        print("Error: data file not found in " + path)
        return
    
    if not path.endswith(".xlsx") and not path.endswith(".csv"):
        print("Please select an excel (.xlsx) or csv (.csv) data file")
        return

    print("Reading data...")
    if path.endswith(".xlsx"):
        data = pd.read_excel(path)
    else:
        data = pd.read_csv(path)
    # print(data)

    if column not in data.columns:
        print("Error: please enter valid column name. '" + column + "' was entered.")
        return
    print(column)

    if not os.path.isfile(keyword_file):
        print("Error: keyword file not found in " + keyword_file)
        return
    
    if not keyword_file.endswith(".txt"):
        print("Please select an text (.txt) data file")
        return

    with open(keyword_file) as kf:
        readings = kf.readlines()
    
    keywords = [line.lower().rstrip('\n') for line in readings]
    for keyword in tqdm(keywords):
        col = "is_" + keyword.split(",")[0].lower()
        print("\n" + col)
        data[col] = data.progress_apply(tag_keyword_row_w_spaces, column=column, keyword=keyword, axis=1)  

    data.drop(columns=["Unnamed: 0"], inplace=True)

    if path.endswith(".xlsx"):
        write_to_excel(data, path[:-5] + "_keywordtagged.xlsx")
    else:
        data.to_csv(path[:-4] + "_keywordtagged.csv")


if __name__ == "__main__":
    main()