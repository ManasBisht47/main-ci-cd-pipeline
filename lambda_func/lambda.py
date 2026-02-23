import json
import boto3
import urllib.request as u

s3=boto3.client("s3")


def lambda_handler(event, context):


    url="https://jsonplaceholder.typicode.com/todos/1"
    response=u.urlopen(url)
    data=json.loads(response.read())

    s3.put_object(
        Bucket="dev-data-pipeline-manas2026",
        Key="cleaned-data-main.json",
        Body=json.dumps(data)
        
    )




    return {
        'statusCode': 200,
        'body': 'Hello from Lambda to S3!'
    }


