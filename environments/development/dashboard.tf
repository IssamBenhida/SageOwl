resource "opensearch_index" "sageowl_index" {
  name               = "sageowl_index"
  number_of_shards   = "1"
  number_of_replicas = "0"

  mappings = jsonencode({
    "properties" : {
      "timestamp" : { "type" : "date" },
      "http_version" : { "type" : "text" },
      "user_agent" : { "type" : "text" },
      "request" : { "type" : "text" },
      "client_ip" : { "type" : "text" },
      "bytes" : { "type" : "integer" },
      "http_method" : { "type" : "text" },
      "response_code" : { "type" : "integer" }
    }
  })

  aliases = jsonencode(
    {
      "sageowl" : {}
    }
  )

  depends_on = [module.opensearch]
}