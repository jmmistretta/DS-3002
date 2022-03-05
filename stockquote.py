import json
import sys
import requests


url = "https://yfapi.net/v6/finance/quote"

stocks = sys.argv[1]

querystring = {"symbols":"sys.argv[1]"}

headers = {
    'x-api-key': "8CfZcsiift2axMqGLWoAN39Wls3isIEBasbVgwtX"
    }

response = requests.request("GET", url, headers=headers, params=querystring)

data = json.loads(response.text)

try:
    stockName = data['quoteResponse']['result'][0]["longName"]
    price = data['quoteResponse']['result'][0]["regularMarketPrice"]
    print(stockName,":",price)
except IndexError:
    print("Error: Stock Not Found")


print(response.text)



#stock_json = response.json()
#print(stock_json]'quoteResponse'][


stname = input("Enter ticker symbols, separated by commas and no space: ")