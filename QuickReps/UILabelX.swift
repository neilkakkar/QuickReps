//
//  UILabelX.swift
//  QuickReps
//
//  Created by nkakkar on 28/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

class UILabelX: UILabel {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        super.drawText(in: rect.inset(by: insets))
    }
}
