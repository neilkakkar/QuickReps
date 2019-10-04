//
//  ColorManager.swift
//  QuickReps
//
//  Created by nkakkar on 01/10/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

class ColorManager {
    
    let topLabelText: UIColor
    let bottomLabelText: UIColor
    
    let topBackground: UIColor
    let bottomBackground: UIColor
    
    let placeholderText: UIColor
    let border: UIColor
    
    let buttonTint: UIColor
    
    static let shared = ColorManager()

    private init() {
        if #available(iOS 13.0, *) {
            topLabelText = UIColor.label
            bottomLabelText = UIColor.white
            
            topBackground = UIColor.systemBackground
            bottomBackground = UIColor.systemGray
            
            placeholderText = UIColor.placeholderText
            border = UIColor.opaqueSeparator
            
            buttonTint = UIColor(named: "ButtonTint")!
            
        } else {
            // No Dark mode
            topLabelText = UIColor.black
            bottomLabelText = UIColor.white
            
            topBackground = UIColor.white
            bottomBackground = UIColor.gray
            
            placeholderText = UIColor.lightGray
            border = UIColor.gray
            
            buttonTint = UIColor.blue
        }
    }
}
