//
//  ViewController.swift
//  QuickReps
//
//  Created by nkakkar on 01/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var cardStackView: CardStackView!
    var initialCardCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: self.view)
        
        if initialCardCenter == nil {
            initialCardCenter = card.center
        }
        card.center = CGPoint(x: self.view.center.x + point.x, y: self.view.center.y + point.y)
        
        if sender.state == .ended {
            resetCard(card: card)
        }
        
    }
    
    //MARK: Private Methods
    private func resetCard(card: UIView) {
        guard let cardCenter = self.initialCardCenter
            else {
                return
        }
        UIView.animate(withDuration: 0.2) {
            card.center = cardCenter
        }
        self.initialCardCenter = nil
    }
}

