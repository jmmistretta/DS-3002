import requests
import json
import csv
import sqlite3
import pandas as pd

# This section describes the purpose of the processor and the data to the user.
print("This ETL pipeline pulls information from a TV show API to provide information about the show 'Friends'.")
print("The processor outputs detailed, organized information about every 'Friends' episode, in order of airing.")
print("The original data source from the API is in JSON format and can be converted to CSV or a SQL database table.")
input("Press Enter to continue.")

# This section allows the user to input their desired data format.
print("") #spacer
print("Choose the format to which you would like the data to be converted.")
print("Type CSV for a CSV file, or type SQL for a SQL database table. Then, press Enter.")
format = input("You can also produce the original JSON file by typing JSON. ")

# This section prevents the user from inputting an invalid data format.
# The user cannot continue until they properly select either CSV, SQL, or JSON format.
while format != "CSV" and format != "SQL" and format != "JSON":
    print("") #spacer
    print("Invalid input. Make sure there are no spaces, quotes, or other characters.")
    format = input("Type CSV for a CSV file, or SQL for a SQL database table, or JSON for the original JSON file. ")

# This section retrieves the API data in JSON format.
try:
    response = requests.get("https://api.tvmaze.com/shows/431/episodes")
    data = response.json()
except:
    print("Error: Unable to get API information from link using requests module.")

# The following section formats the JSON file as a data frame, allowing conversion into either CSV or SQL
df=pd.DataFrame(data)
# Converts all categories to str for simplified conversion to SQL
df=df.applymap(str)
# Takes an initial count of the rows and columns
rows = df.shape[0]
cols1 = df.shape[1]

# Reduces the number of columns by removing columns with unnecessary or irrelevant information.
df = df.drop('url',1)
df = df.drop('type',1)
df = df.drop('airstamp',1)
df = df.drop('image',1)
df = df.drop('_links',1)
cols2 = df.shape[1]

# Removes unusual characters for easier readability.
df = df.replace('<p>','', regex=True)
df = df.replace('</p>','', regex=True)
df = df.replace("{'average': ",'', regex=True)
df = df.replace("}",'', regex=True)

# This section converts the data to a SQL database table, if specified by the user.
if format == "SQL":
    try:
        # Connects to a SQLite database
        conn = sqlite3.connect('friends_episodes.db')
    except:
        print("Error: Unable to create database.")
    try:
        # Specifies the SQL table
        df.to_sql("EPISODES",conn)
    except:
        print("Error: Unable to create table; or, a table with this name may already exist.")
    conn.close()

# This section converts the data to a CSV file, if specified by the user.
elif format == "CSV":
    try:
        # Writes the data frame to a local CSV file
        df.to_csv('friends_episodes.csv')
    except:
        print("Error: Unable to write CSV file.")

# This section saves the data to as a JSON file, if specified by the user.
elif format == "JSON":
    try:
        # Writes the JSON data to a local file
        with open("friends_episodes", "w") as outfile:
            json.dump(data, outfile)
    except:
        print("Error: Unable to save JSON file.")

# Generates a brief summary of the data file ingestion.
print("") #spacer
print("Processing finished. Data file ingestion summary:")
print("     Number of records: " + str(rows-1)) # Does not count the header row
print("     Number of columns before modification: " + str(cols1))
print("     Number of columns after modification: " + str(cols2))
