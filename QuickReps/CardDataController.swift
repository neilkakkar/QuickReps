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
    static let refreshDailyQueueDataCard = Card.createSystemCard(top: "Refreshing daily reminder queue", bottom: "Swipe to refresh")
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
            print("Saved cards not found!")
            loadSampleCards()
        }
        
        if let savedDailyCards = loadDailyCards() {
            dailyCards = savedDailyCards
        }
        
        setupTutorialQueue()
    }
    
    func getDailyQueue() -> Queue<Card> {
        var dailyQueue = Queue<Card>()
        dailyQueue += dailyCards
        return dailyQueue
    }
    
    func getTodaysQueue() -> Queue<Card> {
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
    
    func setNextRevision(card: Card, time: TimeInterval) {
        if card.cardType == .daily || card.cardType == .revising {
            return
        }
        
        let ease = getEaseFromTime(time: time)
        // let current interval = old interval + extra time spent after due date
        let newInterval = getNewInterval(interval: card.interval + getTimeDelta(dueDate: card.dueDate), ease: ease, easinessFactor: card.easinessFactor)
        
        card.interval = fuzzInterval(interval: newInterval)
        
        let addend = createNewAddend(ease)
        let newEasinessFactor = card.easinessFactor + addend
        card.easinessFactor = newEasinessFactor
        card.easinessFactor = max(1.3, card.easinessFactor)
    
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
        print("Saving cards!")
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
        let step1 = Card.createTutorialCard(top: "Welcome to QuickReps.\n Tap this card!", bottom: "This is the core activity. We'll be doing a lot of tapping and swiping.\n Speaking of, go ahead and swipe: left or right.")
        let step2 = Card.createTutorialCard(top: "Generally, this card is for a question you're trying to recollect", bottom: "This place is where the answer shows up.")
        let step3 = Card.createTutorialCard(top: "What's the swiping for?", bottom: "Well, a right swipe means you remember the answer, while a left swipe means you don't.")
        let step4 = Card.createTutorialCard(top: "In either case, it's okay. Do you know what's the goal here?", bottom: "To help you learn better.\n A left swiped card shows up more frequently than a right swiped card.")
        let step5 = Card.createTutorialCard(top: "For now, let's get started.\n How to add more cards?", bottom: "Press the + button below")
        let step6 = Card.createTutorialCard(top: "There's two kinds of cards.", bottom: "The normal cards follow the most optimal schedule, while the reminder cards are shown everyday. These are excellent for building habits of mind. Switch modes by pressing the bottom right button.")
        let step7 = Card.createTutorialCard(top: "Curious to know more?", bottom: "Check out www.<a cheap domain name when I find it>.com")
        
        tutorialQueue = Queue<Card>()
        tutorialQueue += [step1, step2, step3, step4, step5, step6]
    }
    
    func loadCards() -> [Card]? {
        guard let codedData = try? Data(contentsOf: CardDataController.ArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        return cards
    }
    
    func loadDailyCards() -> [Card]? {
        guard let codedData = try? Data(contentsOf: CardDataController.DailyArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        return cards
    }
    
    //MARK: Private
    private func createNewAddend(_ ease: Int) -> Double {
        let v1 = Double(5 - ease)
        let v2 = 0.08 + v1*0.02
        return 0.1 - v1*v2
    }
    
    private func getNewInterval(interval: TimeInterval, ease: Int, easinessFactor: Double) -> TimeInterval {
        var newInterval: TimeInterval
        if ease < 3 {
            newInterval = max(Card.Time.oneDay, ceil(interval / easinessFactor))
        } else if interval.isLessThanOrEqualTo(Card.Time.oneDay*3) {
            newInterval = Card.Time.oneDay*6 // 6 days
        } else {
            newInterval = min(Card.Time.oneYear, ceil(interval * easinessFactor))
        }
        return newInterval
    }
    
    private func fuzzInterval(interval: TimeInterval) -> TimeInterval {
        let values = [-Card.Time.oneDay*2, -Card.Time.oneDay, 0, Card.Time.oneDay, Card.Time.oneDay*2]
        if interval > Card.Time.oneDay*6 {
            return interval + values.randomElement()!
        }
        return interval
    }
    
    private func getEaseFromTime(time: TimeInterval) -> Int {
        let value = -time
        if value < 0 {
            return 1 // default ease for wrong answer
        }
        
        if value < 5 {
            return 5 // answered within 5 seconds, strong recall.
        } else if value < 20 {
            return 4
        }
        return 3
    }
    
    private func getTimeDelta(dueDate: Date) -> TimeInterval {
        let val = dueDate.timeIntervalSinceNow
        if val > 0 {
            return 0
        }
        return fabs(val)
    }

    private func loadSampleCards() {
        if !cards.isEmpty {
            return
        }
        let card1 = Card(top: "Here's an example. What's the best way to get things into long term memory?", bottom: "Spaced Repetition.")
        let card2 = Card(top: "Why does Spaced Repetition work so well for memory?", bottom: "because it figures out the most optimal time to remember something: right before you forget it.")

        self.cards += [card1, card2]
    }
}
