/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

*/

import UIKit
import TVMLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TVApplicationControllerDelegate {
    // MARK: Properties
    
    var window: UIWindow?
    
    var appController: TVApplicationController?
    
    static let TVBaseURL = "http://localhost:9001/"
    
    static let TVBootURL = "\(AppDelegate.TVBaseURL)js/application.js"

    // MARK: UIApplication Overrides
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        TVInterfaceFactory.sharedInterfaceFactory().extendedInterfaceCreator = CustomInterfaceFactory()
    
        TVElementFactory.registerViewElementClass(CustomElement.self, forElementName: "customElement")
        /*
            Create the TVApplicationControllerContext for this application
            and set the properties that will be passed to the `App.onLaunch` function
            in JavaScript.
        */
        let appControllerContext = TVApplicationControllerContext()
        
        /*
            The JavaScript URL is used to create the JavaScript context for your
            TVMLKit application. Although it is possible to separate your JavaScript
            into separate files, to help reduce the launch time of your application
            we recommend creating minified and compressed version of this resource.
            This will allow for the resource to be retrieved and UI presented to
            the user quickly.
        */
        if let javaScriptURL = NSURL(string: AppDelegate.TVBootURL) {
            appControllerContext.javaScriptApplicationURL = javaScriptURL
        }
        
        appControllerContext.launchOptions["baseURL"] = AppDelegate.TVBaseURL
        
        if let launchOptions = launchOptions as? [String: AnyObject] {
            for (kind, value) in launchOptions {
                appControllerContext.launchOptions[kind] = value
            }
        }

        
        appController = TVApplicationController(context: appControllerContext, window: window, delegate: self)
        
        UITabBar.appearance().backgroundColor = UIColor.redColor()

        // Simple example for calling JS from Swift
        appController!.evaluateInJavaScriptContext({(evaluation: JSContext) -> Void in
            // Simplest method is to pass in a string you want to execute
            evaluation.evaluateScript("console.log('You can see this in the Safari debug console!');")
            
            // Optionally, you can get a JSValue object by retrieving a function or object by name:
            // let someObject = evaluation.objectForKeyedSubscript("someObject")
            // If this object is a function, you can use 'callWithArguments' to call it. Check the JSContext documentation for other features
            }, completion: {(Bool) -> Void in
                print("JavaScript finished running")
        })
        
        return true
    }
    
    // MARK: TVApplicationControllerDelegate
    
    func appController(appController: TVApplicationController, didFinishLaunchingWithOptions options: [String: AnyObject]?) {
        print("\(#function) invoked with options: \(options)")
    }
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        print("\(#function) invoked with error: \(error)")
        
        let title = "Error Launching Application"
        let message = error.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.Alert )
        
        self.appController?.navigationController.presentViewController(alertController, animated: true, completion: { () -> Void in
            // ...
        })
    }
    
    func appController(appController: TVApplicationController, didStopWithOptions options: [String: AnyObject]?) {
        print("\(#function) invoked with options: \(options)")
    }
    
    func appController(appController: TVApplicationController, evaluateAppJavaScriptInContext jsContext: JSContext) {
        // Define a block which can be called as a native function from the TVJS global context
        // Note optional arguments are supported,
        let printXCode: @convention(block) (String) -> Void = {
            (string: String) -> Void in
            // Allow JS debugger lines to be shown in the XCode console instead of Safari
            print(string)
        }
        
        // Callable anywhere in TVJS like 'printXCode("test");'
        jsContext.setObject(unsafeBitCast(printXCode, AnyObject.self), forKeyedSubscript:"printXCode");
        // Note that you can also pass your own objects, and the public methods on those objects can be called using JavaScript's dot syntax e.g. someObject.getSomeValue(); or someObject.setSomeValue('test');
    }
}