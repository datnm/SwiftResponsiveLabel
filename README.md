# This was forked from <a href="https://github.com/hsusmita/SwiftResponsiveLabel">hsusmita/SwiftResponsiveLabel</a>
A UILabel subclass which responds to touch on specified patterns. It has the following features:
1. It can detect pattern specified by regular expression and apply style such as font, color etc.
2. It allows to replace default ellipse with tappable attributed string to mark truncation
3. Convenience methods are provided to detect hashtags, username handler and URLs

# Datnm Fixed:
the original of SwiftResponsiveLabel is not good when use in UITableViewCell with autolayout and AutoDimension in UITableView
and with a dynamic Label height (not fix height), so, i fix this.
1. correct truncation token with new line string
2. correct truncation token when use in UITableViewCell with autolayout and AutoDimension in UITableView

# Screenshot fixed
<img src="https://github.com/datnm/SwiftResponsiveLabel/blob/master/datnmfix.png" width="800" display="inline-block">

#Installation

Add following lines in your pod file  
```
pod 'SwiftResponsiveLabel', '2.1'
```

#Usage

The following snippets explain the usage of public methods. These snippets assume an instance of ResponsiveLabel named "customLabel". 
```
import SwiftResponsiveLabel
```

In interface builder, set the custom class of your UILabel to SwiftResponsiveLabel. 

#### Username Handle Detection

```
let userHandleTapAction = PatternTapResponder{ (tappedString)-> (Void) in
let messageString = "You have tapped user handle:" + tappedString
self.messageLabel.text = messageString
}
let dict = [NSForegroundColorAttributeName: UIColor.greenColor(), 
NSBackgroundColorAttributeName: UIColor.blackColor()]
self.customLabel.enableUserHandleDetection([NSForegroundColorAttributeName:UIColor.grayColor(),
RLHighlightedAttributesDictionary: dict, RLTapResponderAttributeName:userHandleTapAction])
```   

#### URL Detection 

```
let URLTapAction = PatternTapResponder{(tappedString)-> (Void) in
let messageString = "You have tapped URL: " + tappedString
self.messageLabel.text = messageString
}
self.customLabel.enableURLDetection([NSForegroundColorAttributeName:UIColor.blueColor(), RLTapResponderAttributeName:URLTapAction])
```

#### HashTag Detection 

```
let hashTagTapAction = PatternTapResponder { (tappedString)-> (Void) in
let messageString = "You have tapped hashTag:" + tappedString
self.messageLabel.text = messageString
}
let dict = [NSForegroundColorAttributeName: UIColor.redColor(), NSBackgroundColorAttributeName: UIColor.blackColor()]
customLabel.enableHashTagDetection([RLHighlightedAttributesDictionary : dict, NSForegroundColorAttributeName: UIColor.cyanColor(),
RLTapResponderAttributeName:hashTagTapAction])
```
#### Custom Truncation Token
##### Set attributed string as truncation token

```
let action = PatternTapResponder {(tappedString)-> (Void) in
print("You have tapped token string")
}
let dict = [RLHighlightedBackgroundColorAttributeName:UIColor.blackColor(),
RLHighlightedForegroundColorAttributeName:UIColor.greenColor(), RLTapResponderAttributeName:action]
let token = NSAttributedString(string: "...More", attributes: [NSFontAttributeName: customLabel.font, 
NSForegroundColorAttributeName:UIColor.brownColor(), RLHighlightedAttributesDictionary: dict])
customLabel.attributedTruncationToken = token
```
##### Set image as truncation token

The height of image size should be approximately equal to or less than the font height. Otherwise the image will not be rendered properly
```
let action = PatternTapResponder {(tappedString)-> (Void) in
print("You have tapped token image")
}
self.customLabel.setTruncationIndicatorImage(UIImage(named: "check")!, withSize: CGSize(width: 20.0, height: 20.0), andAction: action)
```

##### Set from interface builder
<img src="https://cloud.githubusercontent.com/assets/3590619/8694465/df3c1bce-2afc-11e5-9409-78e82e1f294c.png" display="inline-block">

# Screenshots
<img src="https://cloud.githubusercontent.com/assets/3590619/7828584/f7ba853a-0452-11e5-9d6a-c9923d89ee8a.png" width="400" display="inline-block">
<img src="https://cloud.githubusercontent.com/assets/3590619/7828632/b0425196-0453-11e5-911a-79d56e7a8539.png" width="400" display="inline-block">

# References

The underlying implementation of SwiftResponsiveLabel is based on KILabel(https://github.com/Krelborn/KILabel).
SwiftResponsiveLabel is made flexible to enable detection of any pattern specified by regular expression.

The following articles were helpful in enhancing the functionalities. 

* http://www.cocoanetics.com/2015/03/customizing-uilabel-hyperlinks/
* http://www.cocoanetics.com/2015/03/tappable-uilabel-hyperlinks/
