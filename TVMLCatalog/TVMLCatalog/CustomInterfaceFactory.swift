import UIKit
import TVMLKit

class CustomInterfaceFactory: TVInterfaceFactory {
    override func viewForElement(element: TVViewElement, existingView: UIView?) -> UIView? {
        // Examine the element each time this is called
        print("View for element: \((element as? TVTextElement)) \(element.elementName) \(element.elementIdentifier), existingView: \(existingView)")
        
        if element.elementName == "title" || element.elementName == "subtitle" || element.elementName == "description" {
            let textElement = element as! TVTextElement
            if (textElement.attributedText!.length > 0) {
                print("Element text: \(textElement.attributedText?.string)")
//                print("Highlight style: \(element.style?.textHighlightStyle)") // An important style attribute
                
                let label = UILabel(frame: CGRectMake(0, 0, 1000.0, 1000.0))
                
                var font: UIFont!
                let fontSize: CGFloat! = (element.style?.fontSize == 0 ? 24 : element.style?.fontSize) // Provide default
                
                if (textElement.textStyle == TVTextElementStyle.Title || element.style?.fontWeight == "bold") { //
                    font = UIFont.boldSystemFontOfSize(fontSize)
                } else {
                    font = UIFont.systemFontOfSize(fontSize)
                }

                label.lineBreakMode = .ByTruncatingTail
                label.numberOfLines = 2;
            
                label.minimumScaleFactor = 0.5
                
                label.font = font
                
                label.textColor = element.style?.color?.color ?? UIColor(white: 0.15, alpha: 1.0)
                label.backgroundColor = UIColor.redColor()
                label.text = textElement.attributedText!.string
                
                return label
            }
        }
        
        // return nil when we do not want to override a view
        return nil
    }
}