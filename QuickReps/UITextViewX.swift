//
//  UITextViewX.swift
//  QuickReps
//
//  Created by nkakkar on 01/10/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

class UITextViewX: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var isPlaceholder: Bool
    var identifier: String?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        isPlaceholder = false
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        isPlaceholder = false
        super.init(coder: coder)
    }
    
}
