//
//  Utilities.swift
//  ManageCoupon
//
//  Created by Singh, Abhay on 7/5/17.
//  Copyright © 2017 SHC. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class utilities: NSObject {
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    class func superScript(_ textToWrite:String, locationInt:Int, length:Int, font1:UIFont, font2:UIFont) -> NSAttributedString{
        let font:UIFont? = font1
        let fontSuper:UIFont? = font2
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: textToWrite, attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:10], range: NSRange(location:locationInt,length:length))
        return attString;
    }
    
    class func loadJSON(filename:String) -> NSDictionary {
        let bundle = Bundle(for: object_getClass(self))
        let path = bundle.path(forResource: filename, ofType: "JSON")
        
        var response = try? String(contentsOfFile:path!, encoding: String.Encoding.utf8)
        response = response?.replacingOccurrences(of: "\n", with: "", options: [])
        
        let responseData = response?.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        return (try! JSONSerialization.jsonObject(with: responseData!, options:[])) as! NSDictionary
    }
    
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func heightForItem(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    class func convertDateFromString(date: String) -> Date
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"//this your string date format
        let date = dateFormatter.date(from: date)
        return date ?? Date()
    }
    
    class func convertDateFormatter(date: String? = nil,fromFormat:String,toFormat:String) -> String
    {
        if(date != nil && date != ""){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFormat//this your string date format
            let date = dateFormatter.date(from: date!)
            dateFormatter.dateFormat = toFormat///this is what you want to convert format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let timeStamp = dateFormatter.string(from: date!)
            return timeStamp
        }
        return ""
    }
    
    class func formatePhoneNumber(phoneNumber: String) -> String
    {
        var strUpdated = phoneNumber
        if phoneNumber.characters.count == 10 {
            strUpdated.insert("(", at: strUpdated.startIndex)
            strUpdated.insert(")", at: strUpdated.index(strUpdated.startIndex, offsetBy: 4))
            strUpdated.insert(" ", at: strUpdated.index(strUpdated.startIndex, offsetBy: 5))
            strUpdated.insert("-", at: strUpdated.index(strUpdated.startIndex, offsetBy: 9))
        }
        return strUpdated
    }
    
    class func resizedImage(image:UIImage, newSize:CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = newSize.width  / image.size.width
        let heightRatio = newSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio,height: size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,height: size.height * widthRatio)
        }
        let rect = CGRect(x:0, y:0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func icon(_ imageSymbol:String, color:UIColor? = nil, fontSize: CGFloat? = 21)  -> NSAttributedString {
        let selectFont = UIFont(name: "shc-app-font", size:fontSize!)
        let imageColor = color
        let stringAttributes = [NSFontAttributeName : selectFont, NSForegroundColorAttributeName: imageColor!]
        let stringIcon = NSAttributedString(string: imageSymbol, attributes:stringAttributes)
        return stringIcon
    }
}

extension String {
    func index(of target: String) -> Int? {
        if let range = self.range(of: target) {
            return characters.distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func lastIndex(of target: String) -> Int? {
        if let range = self.range(of: target, options: .backwards) {
            return characters.distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
}


extension UIColor {
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}

