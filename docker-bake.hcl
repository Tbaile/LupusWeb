variable "TAG" {
    default = "develop"
}

variable "REPOSITORY" {
    default = "tbaile/lupus-api"
}

# Docker Metadata Action Placeholder
target "docker-metadata-action" {}

target "base" {
    inherits = ["docker-metadata-action"]
    target = "production"
    context = "."
}

target "app" {
    dockerfile = "containers/php/Containerfile"
}

target "app-release" {
    inherits = ["base", "app"]
    cache-from = [
        "type=registry,ref=${REPOSITORY}-app:${TAG}",
        "type=registry,ref=${REPOSITORY}-app:${TAG}-cache"
    ]
}

target "app-develop" {
    inherits = ["app-release"]
    tags = ["${REPOSITORY}-app:develop"]
    output = ["type=docker"]
}

target "web" {
    dockerfile = "containers/nginx/Containerfile"
}

target "web-release" {
    inherits = ["base", "web"]
    cache-from = [
        "type=registry,ref=${REPOSITORY}-web:${TAG}",
        "type=registry,ref=${REPOSITORY}-web:${TAG}-cache"
    ]
}

target "web-develop" {
    inherits = ["web-release"]
    tags = ["${REPOSITORY}-web:develop"]
    output = ["type=docker"]
}

target "testing" {
    inherits = ["app-release"]
    target = "testing"
}

group "develop" {
    targets = ["app-develop", "web-develop"]
}

group "default" {
    targets = ["develop"]
}
