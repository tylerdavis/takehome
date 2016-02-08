== SP Takehome

# Data model

`Job` is a container for n nested crawls.

```
Job {
  crawls: []
}

Crawl {
  url
  in_progress: {false|true}
  images: []
  crawls: [crawl...]
}
```

