
import json
from logging import exception
from re import search
import boto3
import os



# Merge 2 arrays using binary sort

## Function B

    
    

def get_fflag_from_ssm(FFLAG_NAME):

    client = boto3.client('ssm')
    print("getting SSM parameter with value " + FFLAG_NAME)

    response = client.get_parameter(Name=FFLAG_NAME)
    feature_flag_value=response['Parameter']['Value']

    print ("The value of the feature flag for {} is {}".format(FFLAG_NAME, feature_flag_value))


    return feature_flag_value


def  handle_subscriptions(sns_topic_arn, feature_flag, sqs_arn)   :
    
    client = boto3.client('sns')
    subscriptionArn = get_subscriptionArn(sns_topic_arn, sqs_arn, client)
    print ("the subscriptionARN is: " + subscriptionArn)

    if feature_flag == "yes":
        # handle subscribing
        print ("subscribing...")

        # operatins:
        try:
            response = client.subscribe(TopicArn=sns_topic_arn, Protocol='sqs',Endpoint= sqs_arn)


            print ("successfully subscribed to SNS topic {}".format(sns_topic_arn))
        except Exception as error:
            print ("Error subscribing to SNS topic {}".format(sns_topic_arn))
            print (error)
            

    if feature_flag == "no" and subscriptionArn !="": 
        # handle unsubscribing 
        print ("Unsubscribing...")

        # operatins:
        try:
            
            client.unsubscribe(
                SubscriptionArn= subscriptionArn
            )
            print ("successfully unsubscribed to SNS topic {}".format(sns_topic_arn))
        except Exception as error:
            print ("Error Unsubscribing to SNS topic {}".format(sns_topic_arn))
            print (error)


        

def get_subscriptionArn(sns_topic_arn, sqs_arn, client):

    subscriptionArn = ""
    subscription_response = client.list_subscriptions()
    all_subscriptions = subscription_response.get('Subscriptions')
    # print (all_subscriptions)
    next_token = subscription_response.get('NextToken', None)
    while next_token != None:
        subscription_response = client.list_subscriptions(NextToken=next_token)
        all_subscriptions = all_subscriptions + subscription_response.get('Subscriptions',[])
        next_token = subscription_response.get('NextToken', None)



    subscriptionArnAll = [s.get('SubscriptionArn') for s in all_subscriptions if s.get('TopicArn')==sns_topic_arn and s.get('Protocol')=='sqs' and s.get('Endpoint')==sqs_arn]
    if len(subscriptionArnAll)> 0 :
        subscriptionArn = subscriptionArnAll[0]
    return subscriptionArn

def lambda_handler(event, context):


    # The Environment variable names:

    SNS_TOPIC_ARN = 'SNS_TOPIC_ARN'
    FFLAG_NAME = 'FFLAG_NAME'
    SQS_ARN = 'SQS_ARN'

    # Get Env. Variable names form Lambda Env.:

    SNS_TOPIC_ARN = os.environ[SNS_TOPIC_ARN]
    FFLAG_NAME = os.environ[FFLAG_NAME]
    SQS_ARN= os.environ[SQS_ARN]


    new_ssm_parameter_value = ""
    if  event.get('detail', None) !=None:
        if event['detail'].get('value', None) != None:

            new_ssm_parameter_value = event.get('detail').get('value')
            if new_ssm_parameter_value.lower() not in ["yes", "no"]:
                raise Exception ("Wrong input Parameter for SSM Pareameter Store...Aborting operation")
    else:
        raise Exception ('SSM parameter value is not set in the store')
        
    print("SSM Parameter value is : " + new_ssm_parameter_value)

  
    fflag = get_fflag_from_ssm(FFLAG_NAME)

    handle_subscriptions(SNS_TOPIC_ARN, fflag.lower(), SQS_ARN)


   
  
    return
    



    
    
