//
//  CardDataController.swift
//  QuickReps
//
//  Created by nkakkar on 21/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import Foundation
import os.log

class CardDataController {
    
    var cards = [Card]()
    var editCount: Int = 0
    static let shared = CardDataController()
    static let noNewDataCard = Card.createSystemCard(top: "No more cards today", bottom: "Great job!")
    static let refreshQueueDataCard = Card.createSystemCard(top: "Getting more cards for today", bottom: "Good going!")
    var tutorialQueue: Queue<Card>

    private init() {
        tutorialQueue = Queue<Card>()
        
        if let savedCards = loadCards() {
            cards = savedCards
        } else {
            loadSampleCards()
        }
        
        setupTutorialQueue()
    }
    
    func getTodaysQueue() -> Queue<Card>? {
        if UserManager.shared.getFirstLaunch() {
            return tutorialQueue
        }
        
        let dailyLimit = UserManager.shared.getDailyLimit()
        var count = 0
        
        var todaysQueue = Queue<Card>()
        for card in cards {
            if card.dueDate < Date() {
                todaysQueue.enqueue(item: card)
                count += 1
                
                if count >= dailyLimit {
                    break
                }
            }
        }
        
        if todaysQueue.isEmpty() {
            return nil
        }
        return todaysQueue
    }

    func getNextCardToRemember(isTutorial: Bool = false) -> Card? {
        // super inefficient compared to a one pass queue?
        for card in cards {
            if card.dueDate < Date() {
                return card
            }
        }
        return nil
    }
    
    func setNextRevision(card: Card, ease: Int) {
        if card.cardType == Card.CardType.revising {
            if ease >= 3 {
                card.cardType = Card.CardType.learning
            }
            return
        }

        if ease < 3 {
            card.interval = 1*24*60 // 1 day
            card.cardType = Card.CardType.revising
        } else if card.interval == 1*24*60 {
            card.interval = 6*24*60 // 6 days
        } else {
            let newInterval = ceil(card.interval * card.easinessFactor)
            card.interval = newInterval
            let addend = createNewAddend(ease)
            let newEasinessFactor = card.easinessFactor + addend
            card.easinessFactor = newEasinessFactor
            card.easinessFactor = max(1.3, card.easinessFactor)
        }
        card.dueDate = Date(timeIntervalSinceNow: card.interval)
        dump(card)
    }
    
    func addCard(card: Card) {
        cards.append(card)
        editCount += 1
    }
    
    func deleteCard(at: Int) {
        cards.remove(at: at)
        editCount += 1
        
    }
    
    func updateCard(at: Int, card: Card) {
        cards[at] = card
        editCount += 1
    }
    
    func resetEditCount() {
        editCount = 0
    }
    
    func hasUpdates() -> Bool {
        print(editCount, "edits")
        return editCount > 0
    }
    
    func getAllCards() -> [Card] {
        return cards
    }
    
    func saveCards() {
        let codedData = try! NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: false)
        
        do {
            try codedData.write(to: Card.ArchiveURL)
        } catch {
            os_log("Couldn't write to save file.", type: .debug)
        }
    }
    
    func setupTutorialQueue() {
        let step1 = Card.createSystemCard(top: "Welcome to QuickReps.\n Tap this card!", bottom: "This is the core activity.\n Swipe left or right.")
        let step2 = Card.createSystemCard(top: "Generally, this card is for a question you're trying to recollect", bottom: "This place is where the answer shows up. Again, the answer as you deem fit. ")
        let step3 = Card.createSystemCard(top: "What's the swiping for?", bottom: "Well, a right swipe means you remember the answer, while a left swipe means you don't.")
        let step4 = Card.createSystemCard(top: "In either case, it's okay. Do you know what's the goal here?", bottom: "To help you learn better. A left swiped card shows up again more frequently than a right swiped card.")
        let step5 = Card.createSystemCard(top: "Curious to know more?", bottom: "Check out www.<a cheap domain name when I find it>.com")
        let step6 = Card.createSystemCard(top: "For now, let's get started. How to add more cards?", bottom: "Press the button on the top-right corner, and then the +")
        tutorialQueue = Queue<Card>()
        tutorialQueue += [step1, step2, step3, step4, step5, step6]
    }
    
    //MARK: Private
    private func createNewAddend(_ ease: Int) -> Double {
        let v1 = Double(5 - ease)
        let v2 = 0.08 + v1*0.02
        return 0.1 - v1*v2
    }
    
    private func getNewInterval(card: Card) {
        
    }

    private func loadSampleCards() {
        if !cards.isEmpty {
            return
        }
        let card1 = Card(top: "top", bottom: "bottom")
        let card2 = Card(top: "up", bottom: "down")
        let card3 = Card(top: "Something useful? or just super super super looong! What now, iOS!?", bottom: "No")
        
        self.cards += [card1, card2, card3]
    }
    
    private func loadCards() -> [Card]? {
        print(Card.ArchiveURL.absoluteString)
        guard let codedData = try? Data(contentsOf: Card.ArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        return cards
    }
}
