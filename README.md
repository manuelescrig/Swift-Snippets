# Learning Swift
Learning Swift - A collection of Swift language snippets.

## Logging

```swift
    func log(message: String,
             function: String = #function,
             file: String = #file,
             line: Int = #line) {
        
        print("Message \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
    }
    
    log("Some message")
```
