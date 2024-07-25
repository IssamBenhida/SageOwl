### <u>Commands</u>:


Prerequisites:
```bash
pip install awscli-local
pip install terraform-local
```

Creating a lambda function:
```bash
awslocal iam create-role --role-name LambdaSESRole --assume-role-policy-document file://trust-policy.json
```
```bash
zip index.zip index.py
```
```bash
awslocal lambda create-function --function-name mylambda --zip-file fileb://index.zip --handler index.handler --runtime python3.7 --role arn:aws:iam::000000000000:role/LambdaSESRole
```
Invoking a lambda function:
```bash
awslocal lambda invoke --function-name mylambda output.txt
``` 


