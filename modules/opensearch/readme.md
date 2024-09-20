## Resources


| Name                                                                                                                        | Type     |
|-----------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_opensearch_domain.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/opensearch_domain) | resource |

## Inputs

| Name                                                                                              | Free Tier | Description                                               | Type          | Default                                                                                       | Required |
|---------------------------------------------------------------------------------------------------|-----------|-----------------------------------------------------------|---------------|-----------------------------------------------------------------------------------------------|:--------:|
| [domain_name]()                                                                                   | false     | OpenSearch domain name.                                   | `String`      | `""`                                                                                          |   yes    |
| [engine_version]()                                                                                | NA        | OpenSearch engine version.                                | `String`      | `OpenSearch_2.11`                                                                             |    no    |
| [instance_type]()                                                                                 | false     | OpenSearch cluster instance type.                         | `String`      | `m3.meduim.search`                                                                            |    no    |
| [instance_count]()                                                                                | false     | OpenSearch cluster data nodes count for high performance. | `number`      | `3`                                                                                           |    no    |
| [availability_zones]()                                                                            | false     | OpenSearch cluster availability zones count.              | `number`      | `3`                                                                                           |    no    |
| [ebs_options]()                                                                                   | false     | Opensearch configuration block for EBS related options.   | `any`         | <pre>{<br>  "ebs_enabled": true,<br>  "volume_size": 10,<br>  "volume_type": "gp3"<br>}</pre> |    no    |
| [tags]()                                                                                          | false     | A map of tags to assign to the OpenSearch domain.         | `map(string)` | `{}`                                                                                          |    no    |
| [auto\_tune](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/auto-tune.html) | false     | false                                                     | `any`         | `{}`                                                                                          |    no    |


## Outputs


| Name               | Description                                  |
|--------------------|----------------------------------------------|
| [domain_endpoin]() | Opensearch domain endpoint.                  |
| [engine_version]() | Opensearch domain arn.                       |
| [instance_type]()  | OpenSearch cluster availability zones count. |