import {Stack, StackProps } from 'aws-cdk-lib/core';
import * as s3 from 'aws-cdk-lib/aws-s3'
import { Construct } from 'constructs';

export class HelloCdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    new s3.Bucket(this, 'MyCDKBucket');

  }
}