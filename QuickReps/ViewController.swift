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
    @IBOutlet weak var toolbar: UIToolbar!

    var initialCardCenter: CGPoint?
    let cardDataController = CardDataController.shared
    var todaysQueue: Queue<Card>?
    var dailyQueue: Queue<Card>?
    var currentCard: Card = CardDataController.totalZeroCard
    var currentCardStartTime = Date()
    var isDailyQueue: Bool = false
    let colorManager = ColorManager.shared
    
    // card margin properties
    var swipeSafeLimit: CGFloat = 75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        todaysQueue = cardDataController.getTodaysQueue()
        dailyQueue = cardDataController.getDailyQueue()

        view.backgroundColor = colorManager.topBackground
        setupQueues()
        setPageTitle()
        
        setButtonColors()
        
        swipeSafeLimit = self.view.frame.width/3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardStackView.resetViewWithNewData(cardData: currentCard)
        currentCardStartTime = Date()
        super.viewWillAppear(animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setButtonColors()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        swipeSafeLimit = size.width/3
    }
    
    @IBAction func addNewCard(_ sender: UIBarButtonItem) {
        let cardTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "CardTableViewController") as! CardTableViewController
        let cardDataController = self.storyboard?.instantiateViewController(withIdentifier: "EditCardViewControllerNavigator") as! UINavigationController
        
        self.navigationController?.pushViewController(cardTableViewController, animated: false)
        self.navigationController?.present(cardDataController, animated: true, completion: nil)
    }
    
    
    @IBAction func toggleMode(_ sender: UIBarButtonItem) {
        isDailyQueue = !isDailyQueue
        setPageTitle()
        setupQueues()
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
        if card.center.x < swipeSafeLimit {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y)
                    card.alpha = 0
            },
                completion: {(finished: Bool) in
                    if [Card.CardType.new, Card.CardType.learning, Card.CardType.revising].contains(self.currentCard.cardType) {
                        self.currentCard.reps += 1
                        self.cardDataController.setNextRevision(card: self.currentCard, time: 1)
                        self.currentCard.cardType = Card.CardType.revising
                        self.todaysQueue!.enqueue(item: self.currentCard)
                    }
                    
                    if self.currentCard == self.dailyQueue?.top() {
                        // this and below case for when type is changed in table view but viewController's queue still has the reference to the card. In this case a daily card will end up in today's Queue, or a regular card will end up in the daily queue (and won't be able to dequeue).
                        // Using this way uniformly means every appropriate card would be dequeued, nothing else.
                        let _ = self.dailyQueue!.dequeue()
                    } else if self.currentCard == self.todaysQueue?.top() {
                        let _ = self.todaysQueue!.dequeue()
                    }
                    self.getNewCardData(card: card)
            })
        } else if card.center.x > self.view.frame.width - swipeSafeLimit {
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y)
                    card.alpha = 0
            },
                completion: {(finished: Bool) in
                    if [Card.CardType.new, Card.CardType.learning, Card.CardType.revising].contains(self.currentCard.cardType) {
                        self.currentCard.reps += 1
                        self.cardDataController.setNextRevision(card: self.currentCard, time: self.currentCardStartTime.timeIntervalSinceNow)
                        self.currentCard.cardType = Card.CardType.learning
                    }
                    
                    if self.currentCard == self.dailyQueue?.top() {
                        // this and below case for when type is changed in table view but viewController's queue still has the reference to the card. In this case a daily card will end up in today's Queue, or a regular card will end up in the daily queue (and won't be able to dequeue).
                        // Using this way uniformly means every appropriate card would be dequeued, nothing else.
                        let _ = self.dailyQueue!.dequeue()
                    } else if self.currentCard == self.todaysQueue?.top() {
                        let _ = self.todaysQueue!.dequeue()
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
        
        if isDailyQueue {
            if let newCard = dailyQueue!.top() {
                card.resetViewWithNewData(cardData: newCard)
                self.currentCard = newCard
            } else {
                let newQueue = cardDataController.getDailyQueue()
                if !newQueue.isEmpty() {
                    dailyQueue = newQueue
                    card.resetViewWithNewData(cardData: CardDataController.refreshDailyQueueDataCard)
                    self.currentCard = CardDataController.refreshQueueDataCard
                } else {
                    card.resetViewWithNewData(cardData: CardDataController.noNewDataCard)
                    self.currentCard = CardDataController.noNewDataCard
                }
            }
        } else {
            if let newCard = todaysQueue!.top() {
                card.resetViewWithNewData(cardData: newCard)
                self.currentCard = newCard
            } else {
                let newQueue = cardDataController.getTodaysQueue()
                if !newQueue.isEmpty() {
                    todaysQueue = newQueue
                    card.resetViewWithNewData(cardData: CardDataController.refreshQueueDataCard)
                    self.currentCard = CardDataController.refreshQueueDataCard
                } else {
                    card.resetViewWithNewData(cardData: CardDataController.noNewDataCard)
                    self.currentCard = CardDataController.noNewDataCard
                }
            }
        }
        UIView.animate(withDuration: 0.2) {
            card.alpha = 1
        }
        self.initialCardCenter = nil
        currentCardStartTime = Date()
    }
    
    private func setPageTitle() {
        self.navigationItem.title = self.isDailyQueue ? "Reminder Mode" : "Normal Mode"
    }
    
    private func setupQueues() {
        // when we toggle queues, too.
        if isDailyQueue {
            if dailyQueue!.isEmpty() {
                dailyQueue = cardDataController.getDailyQueue()
                if  dailyQueue!.isEmpty() {
                    currentCard = CardDataController.noNewDataCard
                } else {
                    currentCard = dailyQueue!.top()!
                }
            } else {
                currentCard = dailyQueue!.top()!
            }
        } else {
            if todaysQueue!.isEmpty() {
                todaysQueue = cardDataController.getTodaysQueue()
                if todaysQueue!.isEmpty() {
                    currentCard = CardDataController.noNewDataCard
                } else {
                    currentCard = todaysQueue!.top()!
                }
            } else {
                currentCard = todaysQueue!.top()!
            }
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.cardStackView.alpha = 0}, completion: {(completion: Bool) in
                self.cardStackView.resetViewWithNewData(cardData: self.currentCard)
                UIView.animate(withDuration: 0.2) {
                    self.cardStackView.alpha = 1
                }
        })
        currentCardStartTime = Date()
    }
    
    private func setButtonColors() {
        navigationController?.navigationBar.tintColor = colorManager.buttonTint
        for item in toolbar.items! {
            item.tintColor = colorManager.buttonTint
        }
    }
}
