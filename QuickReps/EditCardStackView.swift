//
//  EditCardStackView.swift
//  QuickReps
//
//  Created by nkakkar on 19/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

@IBDesignable
class EditCardStackView: UIStackView {

    var top: UITextViewX
    var bottom: UITextViewX
    let colorManager = ColorManager.shared
    
    static let topIdentifier = "top"
    static let bottomIdentifier = "bottom"
    static let topPlaceholderText = "Question / Reminder"
    static let bottomPlaceholderText = "Answer"
    
    //MARK: Initialization
    override init(frame: CGRect) {
        self.top = UITextViewX()
        self.bottom = UITextViewX()
        self.top.identifier = EditCardStackView.topIdentifier
        self.bottom.identifier = EditCardStackView.bottomIdentifier
        
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        self.top = UITextViewX()
        self.bottom = UITextViewX()
        self.top.identifier = EditCardStackView.topIdentifier
        self.bottom.identifier = EditCardStackView.bottomIdentifier
        
        super.init(coder: coder)
        
        setupView()
    }
    
    func setPlaceholder() {
        self.top.isPlaceholder = true
        self.bottom.isPlaceholder = true
        self.top.text = EditCardStackView.topPlaceholderText
        self.bottom.text = EditCardStackView.bottomPlaceholderText

        self.top.textColor = self.colorManager.placeholderText
        self.bottom.textColor = self.colorManager.placeholderText
    }

    //MARK: Private Methods
    private func setupView() {
        self.top.layer.masksToBounds = true
        self.top.layer.cornerRadius = 8.0
        self.top.layer.borderWidth = 1.0
        
        self.top.textColor = self.colorManager.topLabelText
        self.top.backgroundColor = self.colorManager.topBackground
        self.top.layer.borderColor = self.colorManager.border.cgColor
        

        self.bottom.textColor = self.colorManager.bottomLabelText
        self.bottom.backgroundColor = self.colorManager.bottomBackground
        self.bottom.layer.borderColor = self.colorManager.border.cgColor
        
        self.bottom.layer.masksToBounds = true
        self.bottom.layer.cornerRadius = 8.0
        
        self.top.translatesAutoresizingMaskIntoConstraints = false
        self.bottom.translatesAutoresizingMaskIntoConstraints = false
        
        self.top.textAlignment = .center
        self.bottom.textAlignment = .center
        
        self.top.font = UIFont.systemFont(ofSize: 17)
        self.bottom.font = UIFont.systemFont(ofSize: 17)
        
        addArrangedSubview(self.top)
        addArrangedSubview(self.bottom)
    }
}
