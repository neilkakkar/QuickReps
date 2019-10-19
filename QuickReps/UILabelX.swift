//
//  UILabelX.swift
//  QuickReps
//
//  Created by nkakkar on 28/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

class UILabelX: UILabel {

    private var originalText: String = ""

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
    
    func setClozeableText(text: String) {
        self.originalText = text
    }
    
    func showHiddenClozeableText() {
        if self.originalText == "" {
            return
        }
        self.text = self.originalText.removingRegexMatches(pattern: "\\{\\{[^{}]+\\}\\}", replaceWith: "____")
        // text with underscores instead of values in {{...}}
    }
    
    func showTrueClozeableText() {
        if self.originalText == "" {
            return
        }
        let newtext = self.originalText.replacingOccurrences(of: "{{", with: "").replacingOccurrences(of: "}}", with: "")
        let shouldAnimate = self.text?.contains("____") ?? false
        if shouldAnimate {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.2}, completion: {(completion: Bool) in
                    self.text = newtext
                    UIView.animate(withDuration: 0.1) {
                        self.alpha = 1
                    }
            })
        } else {
            self.text = newtext
        }
        // text without double brackets
    }
}
