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
    let cardDataController = CardDataController.shared
    var todaysQueue: Queue<Card>?
    var currentCard: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        todaysQueue = cardDataController.getTodaysQueue()
        if todaysQueue == nil {
            currentCard = CardDataController.noNewDataCard
        } else {
            currentCard = todaysQueue!.dequeue()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cardData = currentCard {
            cardStackView.resetViewWithNewData(cardData: cardData)
        }
        super.viewWillAppear(animated)
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view as! CardStackView
        let point = sender.translation(in: self.view)
        
        if initialCardCenter == nil {
            initialCardCenter = card.center
        }
        card.center = CGPoint(x: initialCardCenter!.x + point.x, y: initialCardCenter!.y + point.y)
        
        if sender.state == .ended {
            resetOrRemoveCard(card: card)
        }
        
    }
    
    //MARK: Private Methods
    private func resetOrRemoveCard(card: CardStackView) {
        if card.center.x < 75 {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y)
                    card.alpha = 0
            },
                completion: {(finished: Bool) in
                    if self.currentCard!.cardType != Card.CardType.system {
                        self.currentCard!.reps += 1
                        self.cardDataController.setNextRevision(card: self.currentCard!, ease: 1)
                        self.currentCard!.cardType = Card.CardType.revising
                        self.todaysQueue?.enqueue(item: self.currentCard!)
                    }
                    self.getNewCardData(card: card)
            })
        } else if card.center.x > self.view.frame.width - 75 {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y)
                    card.alpha = 0
            },
                completion: {(finished: Bool) in
                    if self.currentCard!.cardType != Card.CardType.system {
                        self.currentCard!.reps += 1
                        self.currentCard!.cardType = Card.CardType.learning
                        self.cardDataController.setNextRevision(card: self.currentCard!, ease: 4)
                    }
                    self.getNewCardData(card: card)
            })
        } else {
            resetCard(card: card)
        }
    }
    
    private func resetCard(card: CardStackView) {
        guard let cardCenter = self.initialCardCenter
            else {
                return
        }
        UIView.animate(withDuration: 0.2) {
                card.center = cardCenter
        }
        self.initialCardCenter = nil
    }
    
    
    private func getNewCardData(card: CardStackView) {
        guard let cardCenter = self.initialCardCenter
            else {
                return
        }
        card.center = cardCenter
        
        if let newCard = todaysQueue?.dequeue() {
            card.resetViewWithNewData(cardData: newCard)
            self.currentCard = newCard
        } else {
            if let newQueue = cardDataController.getTodaysQueue() {
                todaysQueue = newQueue
                card.resetViewWithNewData(cardData: CardDataController.refreshQueueDataCard)
                self.currentCard = CardDataController.refreshQueueDataCard
            } else {
                card.resetViewWithNewData(cardData: CardDataController.noNewDataCard)
                self.currentCard = CardDataController.noNewDataCard
            }
        }
        UIView.animate(withDuration: 0.2) {
            card.alpha = 1
        }
        self.initialCardCenter = nil
    }
}

