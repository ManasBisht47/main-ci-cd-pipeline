import json
import boto3
import pandas as pd
import urllib.request as u
import snowflake.connector
import os

s3=boto3.client("s3")


def lambda_handler(event, context):


    url="https://dummy-json.mock.beeceptor.com/users"
    response=u.urlopen(url)
    data=json.loads(response.read())
    df=pd.json_normalize(data)

    df['PHOTO']=df['photo'].fillna("No photo")
    df["FIRST_NAME"]=df['name'].str.split(" ").str[0]
    df["LAST_NAME"]=df["name"].str.split(" ").str[1]
    df["FULL_ADDRESS"]=df["address"]+","+df["state"]+","+df["country"]
    df['COUNTRY_IS_USA']=df['country']=="USA"
    df["STATE_AND_COUNTRY"]=df["state"]+","+df["country"]

    cleaned_data= df.to_json(orient="records")

    
    s3.put_object(
        Bucket="main-manas-pipeline-storage",
        Key="cleaned_data.json",
        Body=cleaned_data
    )
    s3.put_object(
        Bucket="main-manas-pipeline-storage",
        Key="raw_data.json",
        Body=json.dumps(data))
    
    conn = snowflake.connector.connect(
        user=os.environ["SF_USER"],
        password=os.environ["SF_PASSWORD"],
        account=os.environ["SF_ACCOUNT"],
        warehouse="MANAS_WH",
        database="MANAS_DB",
        schema="RAW"
    )
    cursor = conn.cursor()
    for index, row in df.iterrows():
        cursor.execute("""
            INSERT INTO CLEAN_USERS (
                ID, NAME, COMPANY, USERNAME, EMAIL, ADDRESS,
                ZIP, STATE, COUNTRY, PHONE,
                STATE_AND_COUNTRY, PHOTO,
                FIRST_NAME, LAST_NAME,
                FULL_ADDRESS, COUNTRY_IS_USA
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            row.get("id"),
            row.get("name"),
            row.get("company"),
            row.get("username"),
            row.get("email"),
            row.get("address"),
            row.get("zip"),
            row.get("state"),
            row.get("country"),
            row.get("phone"),
            row.get("STATE_AND_COUNTRY"),
            row.get("PHOTO"),
            row.get("FIRST_NAME"),
            row.get("LAST_NAME"),
            row.get("FULL_ADDRESS"),
            bool(row.get("COUNTRY_IS_USA"))
        ))

    conn.commit()
    cursor.close()
    conn.close()

    

        
    




    return {
        'statusCode': 200,
        'body': 'Hello from Lambda to S3!'
    }


