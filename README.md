HDRoutes
========

[![Platforms](https://img.shields.io/cocoapods/p/HDRoutes.svg?style=flat)](http://cocoapods.org/pods/HDRoutes)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/HDRoutes.svg)](http://cocoapods.org/pods/HDRoutes)
[![Build Status](https://travis-ci.org/wangwanjie/HDRoutes.svg?branch=master)](https://travis-ci.org/wangwanjie/HDRoutes)

### What is it? ###

> *Notice*
> 
[HDRoutes](https://github.com/wangwanjie/HDRoutes) is a translation version for [JLRoutes](https://github.com/joeldev/JLRoutes) in Swift 5, all copyrights belong to origin author.

HDRoutes is a URL routing library with a simple block-based API. It is designed to make it very easy to handle complex URL schemes in your application with minimal code.

### Installation ###
HDRoutes is available for installation using [CocoaPods](https://cocoapods.org/pods/HDRoutes)

```
pod 'HDRoutes'
```

### Requirements ###
HDRoutes require iOS 10.0+.

### Getting Started ###

[Configure your URL schemes in Info.plist.](https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html#//apple_ref/doc/uid/TP40007072-CH6-SW2)

```swift
func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let routes = HDRoutes.globalRoutes()
        
        routes?.addRoute(pattern: "/user/view/:userID", handler: { (params) -> Bool in
            let userID = params["userID"] // defined in the route by specifying ":userID"
            
            // present UI for viewing user with ID 'userID'
            
            return true // return true to say we have handled the route
        })
        
        HDRoutes.verboseLoggingEnabled = true

        HDRoutes.routesForScheme("ViPay")?.addRoute(pattern: "/test/:opt(/a)(/b)(/c)", priority: 10, handler: { (params) -> Bool in
            print("打开测试页面\(params)")
            return true
        })

        HDRoutes.globalRoutes()?.addRoute(pattern: "/test1", handler: { (params) -> Bool in
            print("打开测试1页面\(params)")
            return true
        })

        HDRoutes.routesForScheme("ViPay")?.unmatchedURLHandler = { _, _, _ in
            print("无法识别的 ViPay 路由")
        }

        HDRoutes.globalRoutes()?.unmatchedURLHandler = { _, _, _ in
            print("无法识别的路由")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            _ = HDRoutes.routeURL(URL(string: "ViPay://test/:opt?a=6")!, parameters: ["name": "wangwanjie", "number": 5_201_314])

            _ = HDRoutes.routeURL(URL(string: "/test1?age=27#topic")!, parameters: ["name": "wangwanjie", "number": 5_201_314])

            _ = HDRoutes.routeURL(URL(string: "ViPay://8978998798q")!)
            _ = HDRoutes.routeURL(URL(string: "jhkhjkkk")!)
        }

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return HDRoutes.routeURL(url)
    }
```

Routes can also be registered with subscripting syntax:

```swift
HDRoutes.globalRoutes()?.setHandlerBlock({ (params) -> Bool in
    // ...
            
    return true
}, forKeyedSubscript: "/user/view/:userID")
```

After adding a route for `/user/view/:userID`, the following call will cause the handler block to be called with a dictionary containing `@"userID": @"wangwanjie"`:

```swift
let viewUserURL = URL(string: "myapp://user/view/wangwanjie")!
_ = HDRoutes.routeURL(viewUserURL)
```

### The Parameters Dictionary ###

The parameters dictionary always contains at least the following three keys:

```json
{
  "HDRoutesURL":  "(the NSURL that caused this block to be fired)",
  "HDRoutesPattern": "(the actual route pattern string)",
  "HDRoutesNamespace": "(the route scheme, defaults to HDRoutesGlobalNamespace)"
}
```

The HDRoutesNamespace key refers to the scheme that the matched route lives in. [Read more about schemes.](https://github.com/wangwanjie/HDRoutes#scheme-namespaces)

See HDRoutes.swift for the list of constants.

### Handler Block Chaining ###

The handler block is expected to return a boolean for if it has handled the route or not. If the block returns `false`, HDRoutes will behave as if that route is not a match and it will continue looking for a match. A route is considered to be a match if the pattern string matches **and** the block returns `true`.

It is also important to note that if you pass nil for the handler block, an internal handler block will be created that simply returns `true`.

### Global Configuration ###

There are multiple global configuration options available to help customize HDRoutes behavior for a particular use-case. All options only take affect for the next operation.

```swift
/// Configures verbose logging. Defaults to false.
public static var verboseLoggingEnabled: Bool = false

/// Configures if '+' should be replaced with spaces in parsed values. Defaults to true.
public static var shouldDecodePlusSymbols: Bool = true
```

### More Complex Example ###

```swift
HDRoutes.globalRoutes()?.addRoute(pattern: "/:object/:action/:primaryKey", handler: { (params) -> Bool in
    let object = params["object"]
    let action = params["action"]
    let primaryKey = params["primaryKey"]
    // stuff
    
    return true
})
```

This route would match things like `/user/view/wangwanjie` or `/post/edit/123`. Let's say you called `/post/edit/123` with some URL params as well:

```swift
let editPost = URL(string: "myapp://post/edit/123?debug=true&foo=bar")!
_ = HDRoutes.routeURL(editPost)
```

The parameters dictionary that the handler block receives would contain the following key/value pairs:

```json
{
  "object": "post",
  "action": "edit",
  "primaryKey": "123",
  "debug": "true",
  "foo": "bar",
  "HDRoutesURL": "myapp://post/edit/123?debug=true&foo=bar",
  "HDRoutesPattern": "/:object/:action/:primaryKey",
  "HDRoutesNamespace": "HDRoutesGlobalNamespace"
}
```

### Schemes ###

HDRoutes supports setting up routes within a specific URL scheme. Routes that are set up within a scheme can only be matched by URLs that use a matching URL scheme. By default, all routes go into the global scheme.

```swift
HDRoutes.globalRoutes()?.addRoute(pattern: "/foo", handler: { (params) -> Bool in
    // This block is called if the scheme is not 'thing' or 'stuff' (see below)
    return true
})
    
HDRoutes.routesForScheme("thing")?.addRoute(pattern: "/foo", handler: { (params) -> Bool in
    // This block is called for thing://foo
    return true
})
    
HDRoutes.routesForScheme("stuff")?.addRoute(pattern: "/foo", handler: { (params) -> Bool in
    // This block is called for stuff://foo
    return true
})
```

This example shows that you can declare the same routes in different schemes and handle them with different callbacks on a per-scheme basis.

Continuing with this example, if you were to add the following route:

```swift
HDRoutes.globalRoutes()?.addRoute(pattern: "/global", handler: { (params) -> Bool in
    return true
})
```

and then try to route the URL `thing://global`, it would not match because that route has not been declared within the `thing` scheme but has instead been declared within the global scheme (which we'll assume is how the developer wants it). However, you can easily change this behavior by setting the following property to `true`:

```swift
HDRoutes.routesForScheme("thing")?.shouldFallbackToGlobalRoutes = true
```

This tells HDRoutes that if a URL cannot be routed within the `thing` scheme (aka, it starts with `thing:` but no appropriate route can be found), try to recover by looking for a matching route in the global routes scheme as well. After setting that property to `true`, the URL `thing://global` would be routed to the `/global` handler block.


### Wildcards ###

HDRoutes supports setting up routes that will match an arbitrary number of path components at the end of the routed URL. An array containing the additional path components will be added to the parameters dictionary with the key `kHDRoutesWildcardComponentsKey`.

For example, the following route would be triggered for any URL that started with `/wildcard/`, but would be rejected by the handler if the next component wasn't `joker`.

```swift
HDRoutes.globalRoutes()?.addRoute(pattern: "/wildcard/*", handler: { (params) -> Bool in
    let pathComponents = params[kHDRoutesWildcardComponentsKey]
    if let pathComponents = pathComponents as? [String], pathComponents.count > 0, pathComponents[0] == "joker" {
        // the route matched; do stuff
        return true
    }
    
    // not interested unless 'joker' is in it
    return false
})
```

### Optional Routes ###

HDRoutes supports setting up routes with optional parameters. At the route registration moment, JLRoute will register multiple routes with all combinations of the route with the optional parameters and without the optional parameters. For example, for the route `/the(/foo/:a)(/bar/:b)`, it will register the following routes:

- `/the/foo/:a/bar/:b`
- `/the/foo/:a`
- `/the/bar/:b`
- `/the`

### Querying Routes ###

There are multiple ways to query routes for programmatic uses (such as powering a debug UI). There's a method to get the full set of routes across all schemes and another to get just the specific list of routes for a given scheme. One note, you'll have to import `JLRRouteDefinition.h` as it is forward-declared.

```swift
/// All registered routes, keyed by scheme
static func allRoutes() -> String
```

### License ###
BSD 3-clause. See the [LICENSE](LICENSE) file for details.

