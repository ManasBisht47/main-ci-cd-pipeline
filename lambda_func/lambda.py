import json
import boto3
import pandas as pd
import urllib.request as u

s3=boto3.client("s3")


def lambda_handler(event, context):


    url="https://dummy-json.mock.beeceptor.com/users"
    response=u.urlopen(url)
    data=json.loads(response.read())
    df=pd.json_normalize(data)

    df['photo']=df['photo'].fillna("No photo")
    df["First_name"]=df['name'].str.split(" ").str[0]
    df["Last_name"]=df["name"].str.split(" ").str[1]
    df["Full_Address"]=df["address"]+","+df["state"]+","+df["country"]
    df['Country_is_USA']=df['country']=="USA"

    cleaned_data= df.to_json(orient="records")

    
    s3.put_object(
        Bucket="manabh",
        Key="cleaned_data.json",
        Body=cleaned_data
    )
    s3.put_object(
        Bucket="manabh",
        Key="raw_data.json",
        Body=json.dumps(data))

        
    




    return {
        'statusCode': 200,
        'body': 'Hello from Lambda to S3!'
    }


