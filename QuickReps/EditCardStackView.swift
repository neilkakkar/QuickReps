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

//    var toptapGestureRecognizer: UITapGestureRecognizer
//    var bottomtapGestureRecognizer: UITapGestureRecognizer
    var top: UITextView
    var bottom: UITextView
    
    //MARK: Initialization
    override init(frame: CGRect) {
        
//        self.toptapGestureRecognizer = UITapGestureRecognizer()
//        self.bottomtapGestureRecognizer = UITapGestureRecognizer()
        
        self.top = UITextView()
        self.bottom = UITextView()
        
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        
//        self.toptapGestureRecognizer = UITapGestureRecognizer()
//        self.bottomtapGestureRecognizer = UITapGestureRecognizer()
        
        self.top = UITextView()
        self.bottom = UITextView()
        
        super.init(coder: coder)
        
        setupView()
    }
    
    func setPlaceholder() {
        self.top.text = "Question / Reminder"
        self.top.textColor = UIColor.lightGray
        self.bottom.text = "Answer"
        self.bottom.textColor = UIColor.lightGray
    }

    //MARK: Private Methods
    private func setupView() {
        self.top.layer.masksToBounds = true
        self.top.layer.cornerRadius = 8.0
        
        self.top.layer.borderColor = UIColor.gray.cgColor
        self.top.layer.borderWidth = 1.0
        
        self.top.backgroundColor = UIColor.white
        self.bottom.backgroundColor = UIColor.gray
        self.bottom.textColor = UIColor.white
        
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
