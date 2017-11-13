//
//  CustomSearchBar.swift
//  ManageCoupon
//
//  Created by Singh, Abhay on 7/7/17.
//  Copyright © 2017 SHC. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    var prefferedFont: UIFont!
    var prefferedtextColor: UIColor!
    
    init(frame: CGRect, font: UIFont, textColor: UIColor){
        super.init(frame: frame)
        
        self.frame = frame
        prefferedFont = font
        prefferedtextColor = textColor
        searchBarStyle = UISearchBarStyle.prominent
        isTranslucent = false
    }
    
    func indexOfSearchFieldInSubviews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0] 
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i].isKind(of: UITextField.self){
                index = i
                break
            }
        }
        
        return index
    }
    
    override func draw(_ rect: CGRect) {
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = subviews[0].subviews[index] as! UITextField
            
            // Set its frame.
            //searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 20.0, height: frame.size.height - 20.0)
            
            // Set the font and text color of the search field.
            searchField.font = prefferedFont
            searchField.textColor = prefferedtextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor = barTintColor
        }
        
        super.draw(rect)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
