import json
import boto3
import pandas as pd
import urllib.request as u

s3=boto3.client("s3")


def lambda_handler(event, context):


    url="https://jsonplaceholder.typicode.com/todos/1"
    response=u.urlopen(url)
    data=json.loads(response.read())
    df=pd.json_normalize(data)
    df['photo']=df['photo'].fillna("No photo")
    df["First_name"]=df['name'].str.split(" ").str[0]
    df["Last_name"]=df["name"].str.split(" ").str[1]
    df["Full_Address"]=df["address"]+","+df["state"]+","+df["country"]
    df['Country_is_USA']=df['country']=="USA"

    df.to_json("cleaned_data.json", orient="records", lines=True)

    s3=boto3.client('s3')
    s3.put_object(
        bucket="manabh",
        key="cleaned_data.json",
        Body=open("cleaned_data.json", "rb")
    )
    s3.put_object(
        bucket="manabh",
        key="raw_data.json",
        Body=json.dumps(data))

        
    




    return {
        'statusCode': 200,
        'body': 'Hello from Lambda to S3!'
    }


