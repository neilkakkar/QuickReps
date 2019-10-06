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
            bottomBackground = UIColor(named: "Blue2B")!
            
            placeholderText = UIColor.placeholderText
            border = UIColor(named: "Blue2")!
            
            buttonTint = UIColor(named: "Blue3")!
            
        } else {
            // No Dark mode
            topLabelText = UIColor.black
            bottomLabelText = UIColor.white
            
            topBackground = UIColor.white
            bottomBackground = UIColor(named: "Blue2B")!
            
            placeholderText = UIColor.lightGray
            border = UIColor(named: "Blue2")!
            
            buttonTint = UIColor(named: "Blue3")!
        }
    }
}
