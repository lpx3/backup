version 1.0

import "gs://evilbucket/sub.wdl" as sub

workflow Hello {
  input {
    String name = "world"
  }
  call sub.Greet { input: name = name }
  output {
    String greeting = Greet.greeting
  }
}


task Greet {
  input {
    String name
  }
  command <<<
    echo "Hello, ~{name}"
  >>>
  output {
    String greeting = read_string(stdout())
  }
  runtime {
    docker: "debian:stable-slim"
  }
}

