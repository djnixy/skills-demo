data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "./lambda_function.zip"
  source {
    content  = <<EOF

import os
import time
import boto3
import urllib3
import logging
from datetime import datetime

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):

    now = datetime.now()
    TIMESTAMP = now.strftime("%Y-%m-%d_%H-%M")
    PREFIX = event.get('PREFIX', '')
    
    ODOO_DATABASE = event.get('ODOO_DATABASE')
    URL = event.get('URL', ODOO_DATABASE)
    ENVIRONMENT = event.get('ENVIRONMENT')
    AWS_BUCKET_NAME = event.get('AWS_BUCKET_NAME')
    
    logger.info("[DEBUG] ODOO_DATABASE: "+ ODOO_DATABASE)
    logger.info("[DEBUG] URL: "+ URL)
    logger.info("[DEBUG] ENVIRONMENT: "+ ENVIRONMENT)
    logger.info("[DEBUG] AWS_BUCKET_NAME: "+ AWS_BUCKET_NAME)
    
    aws_client = boto3.client('ssm')
    parameter_name = f'/{ENVIRONMENT}/{URL}/odoo/admin_passwd'
    response = aws_client.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    ADMIN_PASSWORD = response['Parameter']['Value']

    try:
        url = f"https://{URL}/web/database/backup"

        # Create a user agent header
        headers = {
            'User-Agent': 'lambda-odoo-backup'
        }

        # Form data for the POST request
        data = {
            'master_pwd': ADMIN_PASSWORD,
            'name': ODOO_DATABASE,
            'backup_format': 'zip'
        }

        http = urllib3.PoolManager()

        # Send the HTTP POST request to the URL
        response = http.request('POST', url, fields=data, headers=headers, preload_content=False)

        # Save the response content (latestbackup file) to the local filesystem
        file_path = f'/tmp/{ODOO_DATABASE}_latest.zip'
        with open(file_path, 'wb') as file:
            file.write(response.data)

        if os.path.getsize(file_path) < 1024 * 1024:
            raise ValueError("The file backed up is less than 1 MB. Triggering an exception.")

        # Upload the file to S3 bucket
        s3_client = boto3.client('s3')
        s3_object_key = f'{ODOO_DATABASE}_latest.zip'
        s3_key = os.path.join(ENVIRONMENT, ODOO_DATABASE, s3_object_key)
        s3_client.upload_file(file_path, AWS_BUCKET_NAME, s3_key)

        # Delete the file from the local filesystem after uploading to S3
        os.remove(file_path)

        logger.info("Backup successful and file uploaded to S3.")
        logger.info("Filename: " + s3_object_key)
        logger.info("Path: " + s3_key)
        
        file_path = f'/tmp/{ODOO_DATABASE}_{TIMESTAMP}.zip'
        with open(file_path, 'wb') as file:
            file.write(response.data)

        # Upload the file to S3 bucket
        s3_client = boto3.client('s3')
        s3_object_key = f'{ODOO_DATABASE}_{TIMESTAMP}{PREFIX}.zip'
        s3_key = os.path.join(ENVIRONMENT, ODOO_DATABASE, s3_object_key)
        s3_client.upload_file(file_path, AWS_BUCKET_NAME, s3_key)

        # Delete the file from the local filesystem after uploading to S3
        os.remove(file_path)

        logger.info("Backup successful and file uploaded to S3.")
        logger.info("Filename: " + s3_object_key)
        logger.info("Path: " + s3_key)
        
        response = {
            "statusCode": 200,
            "body": {
                "message": "Backup successful and file uploaded to S3.",
                "filename": s3_object_key,
                "path": s3_key
            }
        }

    except Exception as e:
        response = {
            "statusCode": 500,
            "body": str(e)
        }

    return response


EOF
    filename = "lambda_function.py"
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"

  function_name = local.lambda_function_name
  description   = "Lambda function to backup odoo database"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  create_role = true
  attach_policy_statements = true
  policy_statements = {
    s3-access = {
      effect    = "Allow",
      actions   = ["s3:PutObject"],
      resources = ["arn:aws:s3:::s3-odoo-database-backup/*"]
    },
    ssm-access =  {
      effect    = "Allow",
      actions   = ["ssm:Get*"]
      resources = ["arn:aws:ssm:*:*:parameter/*"]
    },
    kms-access =  {
      effect    = "Allow",
      actions   = ["kms:Decrypt"]
      resources = ["arn:aws:kms:*:*:key/*"]
    }
  }
  create_package         = false
  local_existing_package = "./lambda_function.zip"

  environment_variables = {
    # ADMIN_PASSWORD = var.odooAdminPassword
    # ODOO_DATABASE = var.odooDatabase
    # ENVIRONMENT = var.odooEnvironment
    # AWS_BUCKET_NAME = var.s3bucket
  }
  timeout         = 600
  memory_size     = 4096
  ephemeral_storage_size = 2048
  create_current_version_allowed_triggers = false
  # allowed_triggers = {
  #   schedule = {
  #     principal  = "events.amazonaws.com"
  #     source_arn = aws_cloudwatch_event_rule.run-at-midnight-SGT.arn
  #   }
  # }
  create_async_event_config = true
  attach_async_event_policy = true

  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 2

  # destination_on_failure = aws_sns_topic.error_reporting.arn
  # destination_on_success = aws_sns_topic.success_reporting.arn

}
