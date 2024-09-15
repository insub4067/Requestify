# 🛜 Requestify

![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)

`Requestify` is a flexible and reusable network request utility built using Alamofire. It allows developers to easily construct and send HTTP requests with customizable methods, headers, parameters, and logging options.

## Features
- Simple, chainable interface to set URL, HTTP method, headers, and parameters.
- Supports request and response logging for easier debugging.
- Handles both JSON-encoded parameters and decodable responses.
- Utilizes Swift's async/await pattern for modern concurrency support.
- Supports multiple HTTP methods (GET, POST, PUT, DELETE, etc.).
- Allows for raw HTTP responses without decoding.
- Easily customizable for different API configurations.
- Supports multipart form data uploads, including images and JSON objects.

## Usage
### Creating a Request
To create a request, use the RequestBuilder struct by chaining configuration methods:
```swift
import Requestify

let requestify = Requestify()
    .setURL("https://jsonplaceholder.typicode.com/posts")
    .setMethod(.get)
    .setApiLog(printLog: true, printResponse: true)
```

### Sending a Request
Once your request is configured, send the request and handle the response using Swift's async/await:
```swift
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

Task {
    do {
        let posts: [Post] = try await requestify.request([Post].self)
        print("Posts: \(posts)")
    } catch {
        print("Error: \(error)")
    }
}
```

### Customizing Headers and Parameters
You can send custom headers and parameters with your request:
```swift
let customHeaders: HTTPHeaders = [
    "Authorization": "Bearer token"
]

let parameters = Params()
    .add("userId", value: 1)
    .build()

let requestify = Requestify()
    .setURL("https://jsonplaceholder.typicode.com/posts")
    .setMethod(.post)
    .setHeaders(customHeaders)
    .setParameters(parameters)
    .setApiLog(printLog: true, printResponse: true)
```

### Handling Raw HTTP Responses
If you need a raw HTTPURLResponse without decoding the body, use:
```swift
Task {
    do {
        let response = try await requestify.requeust()
        print("Response status code: \(response.statusCode)")
    } catch {
        print("Error: \(error)")
    }
}
```

### Multipart Uploads (iOS only)
For uploading files or images, Requestify provides an easy interface for creating multipart requests:
```swift
import UIKit

let post = Post()

let requestify = Requestify()
    .setURL("https://yourapi.com/upload")
    .setMethod(.post)
    .addObject(post, withName: "post")
    .addImages([UIImage(named: "example")], withName: "file")
    .setApiLog(printLog: true, printResponse: true)

Task {
    do {
        let response: YourResponseType = try await requestify.upload(YourResponseType.self)
        print("Upload successful: \(response)")
    } catch {
        print("Error: \(error)")
    }
}
```

### Logging
You can control the request and response logging using setApiLog:
```swift
.setApiLog(printLog: true, printResponse: false)
```
