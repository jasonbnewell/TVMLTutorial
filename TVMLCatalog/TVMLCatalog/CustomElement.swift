import Foundation
import TVMLKit

class CustomElement: TVViewElement {
    // All methods are optional
//    override var elementName: String {
//        return "customElement"
//    }

    internal override func resetProperty(resettableProperty: TVElementResettableProperty) {
        print("Reset property: \(resettableProperty)")
        
        super.resetProperty(resettableProperty)
    }

    internal override func dispatchEventOfType(type: TVElementEventType, canBubble: Bool, cancellable isCancellable: Bool, extraInfo: [String : AnyObject]?, completion: ((Bool, Bool) -> Void)?) {
        print("Dispatch event : \(type)")
        super.dispatchEventOfType(type, canBubble: canBubble, cancellable: isCancellable, extraInfo: extraInfo, completion: completion)
    }

    internal override func dispatchEventWithName(eventName: String, canBubble: Bool, cancellable isCancellable: Bool, extraInfo: [String : AnyObject]?, completion: ((Bool, Bool) -> Void)?) {
        print("Dispatch event (w/ name): \(eventName)")
    }
}