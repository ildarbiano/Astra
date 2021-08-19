import json
import boto3


dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Library')

def lambda_handler(event, context):
    name = event['firstName'] +' '+ event['lastName'] +' '+ event['artName']

    response = table.put_item(
        Item={
            'id': name,
            'LastName': event['lastName'],
            'FirstName': event['firstName'],
            'ArtName' : event['artName']
            })
    return {
        'statusCode': 200,
        'body': json.dumps('Congratulation! The information about > ' + name + ' < just was put to DynamoDb.' )
    }
    