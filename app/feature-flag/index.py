
import json
from logging import exception
import boto3
import os


def get_fflag_from_ssm():
    client = boto3.client('ssm')
    print("getting SSM parameter with value " + FFLAG_NAME)
    response = client.get_parameter(Name=FFLAG_NAME)
    feature_flag_value=response['Parameter']['Value']
    print ("The value of the feature flag for {} is {}".format(FFLAG_NAME, feature_flag_value))
    return feature_flag_value

def decode_message(event): 
    return "yes"
def subscribe_topic(topic,client):
    print("subscribing to the topic now.")
    return "OK"
def unsubscribe_topic(topic, client):
    print("un-subscribing to the topic now.")

    return "OK"

def  handle_subscriptions(sns_topic_arn, feature_flag, lambda_arn)   :
    
    client = boto3.client('sns')
    subscriptionArn = get_subscriptionArn(sns_topic_arn, lambda_arn, client)

    print ("the subscriptionARN is: ")
    print (subscriptionArn)
    

    if feature_flag == "yes":
        # handle subscribing
        print ("subscribing...")

        # operatins:
        try:
            response = client.subscribe(TopicArn=sns_topic_arn, Protocol='lambda',Endpoint= lambda_arn)


            print ("successfully subscribed to SNS topic {}".format(sns_topic_arn))
        except Exception as error:
            print ("Error subscribing to SNS topic {}".format(sns_topic_arn))
            print (error)
            

    if feature_flag == "no" and subscriptionArn !="": 
        # handle unsubscribing 
        print ("Unsubscribing...")

        # operatins:
        try:
            response = client.unsubscribe(
                SubscriptionArn= subscriptionArn
            )
            print ("successfully unsubscribed to SNS topic {}".format(sns_topic_arn))
        except Exception as error:
            print ("Error Unsubscribing to SNS topic {}".format(sns_topic_arn))
            print (error)


        

def get_subscriptionArn(sns_topic_arn, lambda_arn, client):

    subscriptionArn = ""
    subscription_response = client.list_subscriptions()
    all_subscriptions = subscription_response.get('Subscriptions')
    # print (all_subscriptions)
    next_token = subscription_response.get('NextToken', None)
    while next_token != None:
        subscription_response = client.list_subscriptions(NextToken=next_token)
        all_subscriptions = all_subscriptions + subscription_response.get('Subscriptions',[])
        next_token = subscription_response.get('NextToken', None)



    subscriptionArnAll = [s.get('SubscriptionArn') for s in all_subscriptions if s.get('TopicArn')==sns_topic_arn and s.get('Protocol')=='lambda' and s.get('Endpoint')==lambda_arn]
    if len(subscriptionArnAll)> 0 :
        subscriptionArn = subscriptionArnAll[0]
    return subscriptionArn

def lambda_handler(event, context):
    new_ssm_parameter_value=""
    if  event.get('detail', None) !=None:
        if event['detail'].get('value', None) != None:

            new_ssm_parameter_value = event.get('detail').get('value')
    else:
        raise Exception ('SSM parameter value is not set in the store')
        
    print("SSM Parameter value is : " + new_ssm_parameter_value)

  
    fflag = get_fflag_from_ssm()

    handle_subscriptions(SNS_TOPIC_ARN, fflag.lower(), LAMBDA_ARN)


   
  
    return
    

payload = '{"version": "0","id": "b1613855-c78b-960c-3639-7e14916eb335", "detail-type": "Parameter Store Change", "source":["aws.ssm"],"account": "539790979880","time": "2021-08-04T00:29:38Z",  "region": "us-east-1",  "resources": [],  "detail": {    "name": "/canaries/ServiceFirst/Active",    "value": "yes"  }} '
# payload = '{"name": "John Smith", "hometown": {"name": "New York", "id": 123}}'
my_message = json.loads(payload)

print('Loading function')


SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']
FFLAG_NAME = os.environ['FFLAG_NAME']
LAMBDA_ARN= os.environ['LAMBDA_ARN']
lambda_handler(my_message, None)



    
    
