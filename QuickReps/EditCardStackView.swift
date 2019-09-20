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
    var top: UITextField
    var bottom: UITextField
    
    //MARK: Initialization
    override init(frame: CGRect) {
        
//        self.toptapGestureRecognizer = UITapGestureRecognizer()
//        self.bottomtapGestureRecognizer = UITapGestureRecognizer()
        
        self.top = UITextField()
        self.bottom = UITextField()
        
        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        
//        self.toptapGestureRecognizer = UITapGestureRecognizer()
//        self.bottomtapGestureRecognizer = UITapGestureRecognizer()
        
        self.top = UITextField()
        self.bottom = UITextField()
        
        super.init(coder: coder)
        
        setupView()
    }
    
    //MARK: Actions
    @objc func topCardTapped(sender: UITapGestureRecognizer) {
        print("Top!")
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3)  {
                self.top.alpha = 1
                self.bottom.alpha = 0
            }
        }
    }
    
    @objc func bottomCardTapped(sender: UITapGestureRecognizer) {
        print("Bottom!")
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3)  {
                self.bottom.alpha = 1
                self.top.alpha = 0
                
            }
        }
    }
    
    func resetViewWithNewData() {
        setupView()
    }
    
    //MARK: Private Methods
    private func setupView() {

//        self.top.isUserInteractionEnabled = true
//        self.bottom.isUserInteractionEnabled = true

//        self.toptapGestureRecognizer.addTarget(
//            self, action: #selector(EditCardStackView.topCardTapped(sender:)))
//        self.bottomtapGestureRecognizer.addTarget(
//            self, action: #selector(EditCardStackView.bottomCardTapped(sender:)))

        self.top.placeholder = "Question / Reminder"
        self.bottom.placeholder = "Answer"
        
        self.top.layer.masksToBounds = true
        self.top.layer.cornerRadius = 8.0
        
        self.top.layer.borderColor = UIColor.gray.cgColor
        self.top.layer.borderWidth = 1.0
        
        self.bottom.backgroundColor = UIColor.gray
        self.bottom.textColor = UIColor.white
        
        self.bottom.layer.masksToBounds = true
        self.bottom.layer.cornerRadius = 8.0
        
        self.top.translatesAutoresizingMaskIntoConstraints = false
        self.bottom.translatesAutoresizingMaskIntoConstraints = false
        
        self.top.textAlignment = .center
        self.bottom.textAlignment = .center
        
        addArrangedSubview(self.top)
        addArrangedSubview(self.bottom)
        
        
//        self.top.addGestureRecognizer(self.toptapGestureRecognizer)
//        self.bottom.addGestureRecognizer(self.bottomtapGestureRecognizer)
        

    }
    
}
