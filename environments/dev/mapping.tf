resource "opensearch_index" "sageowl_index" {
  name               = "sageowl_index"
  number_of_shards   = "1"
  number_of_replicas = "0"

  mappings = jsonencode({
    "properties" : {
      "timestamp" : {
        "type" : "date"
      },
      "http.flavor" : {
        "type" : "keyword"
      },
      "http.request.url" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.response.bytes" : {
        "type" : "integer"
      },
      "http.request.method" : {
        "type" : "keyword"
      },
      "http.referrer" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.response.code" : {
        "type" : "integer"
      },
      "http.ip.address" : {
        "type" : "ip"
      },
      "http.ip.country" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.ip.city" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.ip.region" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.ip.location" : {
        "type" : "geo_point"
      },
      "http.ip.org" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.user_agent.browser" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.user_agent.os" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.user_agent.platform" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      },
      "http.user_agent.details" : {
        "type" : "text",
        "fields" : {
          "keyword" : { "type" : "keyword" }
        }
      }
    }
  })

  aliases = jsonencode(
    {
      "sageowl" : {}
    }
  )

  depends_on = [module.opensearch]
}
