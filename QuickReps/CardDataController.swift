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
    var dailyCards = [Card]()
    var editCount: Int = 0
    static let shared = CardDataController()
    static let noNewDataCard = Card.createSystemCard(top: "No more cards today", bottom: "Great job!")
    static let refreshQueueDataCard = Card.createSystemCard(top: "Getting more cards for today", bottom: "Good going!")
    static let totalZeroCard = Card.createSystemCard(top: "Add a new card to begin", bottom: "No cards exist, yet.")
    var tutorialQueue: Queue<Card>
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cards")
    static let DailyArchiveURL = DocumentsDirectory.appendingPathComponent("dailyCards")
    

    private init() {
        tutorialQueue = Queue<Card>()
        
        if let savedCards = loadCards() {
            cards = savedCards
        } else {
            loadSampleCards()
        }
        
        if let savedDailyCards = loadDailyCards() {
            dailyCards = savedDailyCards
        }
        
        setupTutorialQueue()
    }
    
    func getDailyQueue() -> Queue<Card>? {
        var dailyQueue = Queue<Card>()
        dailyQueue += dailyCards
        
        if dailyQueue.isEmpty() {
            return nil
        }
        return dailyQueue
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
        if card.cardType == .daily {
            return
        }

        if card.cardType == Card.CardType.revising {
            // normal card revising
            if ease >= 3 {
                // success
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
        if card.cardType == .daily {
            dailyCards.append(card)
        } else {
            cards.append(card)
        }
        editCount += 1
    }
    
    func deleteCard(at: Int, isDaily: Bool = false) {
        if isDaily {
            dailyCards.remove(at: at)
        } else {
            cards.remove(at: at)
        }
        editCount += 1
    }
    
    func updateCard(at: Int, card: Card) {
        if card.cardType == .daily {
            dailyCards[at] = card
        } else {
            cards[at] = card
        }
        editCount += 1
    }
    
//    func updateCardAndMoveTypes(from: Int, card: Card, toDaily: Bool) {
//        addCard(card: card, isDaily: toDaily)
//        deleteCard(at: from, isDaily: !toDaily)
//    }
    
    func resetEditCount() {
        editCount = 0
    }
    
    func hasUpdates() -> Bool {
        return editCount > 0
    }
    
    func getCards(daily: Bool = false) -> [Card] {
        if daily {
            return dailyCards
        }
        return cards
    }
    
    func saveCards() {
        let codedCardsData = try! NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: false)
        let codedDailyData = try! NSKeyedArchiver.archivedData(withRootObject: dailyCards, requiringSecureCoding: false)
        
        do {
            try codedCardsData.write(to: CardDataController.ArchiveURL)
            try codedDailyData.write(to: CardDataController.DailyArchiveURL)
        } catch {
            os_log("Couldn't write to save file.", type: .debug)
        }
    }
    
    func setupTutorialQueue() {
        let step1 = Card.createSystemCard(top: "Welcome to QuickReps.\n Tap this card!", bottom: "This is the core activity. We'll be doing a lot of tapping and swiping.\n Speaking of, go ahead and swipe: left or right.")
        let step2 = Card.createSystemCard(top: "Generally, this card is for a question you're trying to recollect", bottom: "This place is where the answer shows up.")
        let step3 = Card.createSystemCard(top: "What's the swiping for?", bottom: "Well, a right swipe means you remember the answer, while a left swipe means you don't.")
        let step4 = Card.createSystemCard(top: "In either case, it's okay. Do you know what's the goal here?", bottom: "To help you learn better.\n A left swiped card shows up more frequently than a right swiped card.")
        let step5 = Card.createSystemCard(top: "Curious to know more?", bottom: "Check out www.<a cheap domain name when I find it>.com")
        let step6 = Card.createSystemCard(top: "For now, let's get started.\n How to add more cards?", bottom: "Press the button on the top-right corner, and then the +")
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
        print(CardDataController.ArchiveURL.absoluteString)
        guard let codedData = try? Data(contentsOf: CardDataController.ArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        return cards
    }
    
    private func loadDailyCards() -> [Card]? {
        guard let codedData = try? Data(contentsOf: CardDataController.DailyArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        return cards
    }
}
