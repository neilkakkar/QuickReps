//
//  CardStackView.swift
//  QuickReps
//
//  Created by nkakkar on 01/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

@IBDesignable
class CardStackView: UIStackView {
    
    var tapGestureRecognizer: UITapGestureRecognizer
    var top: UILabelX
    var bottom: UILabelX
    var cardData: Card = Card(top: "Tap card to reveal answer", bottom: "Swipe left if you don't remember, right if you do.")
    let colorManager = ColorManager.shared
    
    //MARK: Initialization
    override init(frame: CGRect) {
        
        self.tapGestureRecognizer = UITapGestureRecognizer()
        self.top = UILabelX()
        self.bottom = UILabelX()

        super.init(frame: frame)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        
        self.tapGestureRecognizer = UITapGestureRecognizer()
        self.top = UILabelX()
        self.bottom = UILabelX()

        super.init(coder: coder)
        
        setupView()
    }
    
    //MARK: Actions
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.3)  {
                self.bottom.alpha = 1
                self.bottom.backgroundColor = self.colorManager.bottomBackground
                self.bottom.textColor = self.colorManager.bottomLabelText
                self.top.showTrueClozeableText()
            }
        }
    }
    
    func resetViewWithNewData(cardData: Card) {
        self.cardData = cardData
        setupCardView()
    }
    
    func resetView() {
        print("Reset called!")
        setupCardView()
    }
    
    //MARK: Private Methods
    private func setupBaseView() {
        // both labels = part of a Card data model. This will just render the card, and add pan / tap gesture control.
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizer.addTarget(self, action: #selector(CardStackView.cardTapped(sender:)))
        
        self.addGestureRecognizer(self.tapGestureRecognizer)
        
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
        
        self.top.numberOfLines = 0
        self.bottom.numberOfLines = 0
        
        self.bottom.alpha = 0
        
        self.top.font = UIFont.systemFont(ofSize: 17)
        self.bottom.font = UIFont.systemFont(ofSize: 17)
        
        addArrangedSubview(self.top)
        addArrangedSubview(self.bottom)
    }
    
    private func setupCardView() {
        
        self.top.setClozeableText(text: self.cardData.top)
        self.top.showHiddenClozeableText()
        self.bottom.text = self.cardData.bottom
        self.bottom.alpha = 0
        
        if self.bottom.text == "" {
            self.bottom.isHidden = true
        } else {
            self.bottom.isHidden = false
        }
    }
    
    private func setupView() {
        setupBaseView()
        setupCardView()
    }

}
