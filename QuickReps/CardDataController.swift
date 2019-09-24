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
    static let shared = CardDataController()
    static let noNewDataCard = Card(top: "No more cards today", bottom: "Great job!")

    private init() {
        if let savedCards = loadCards() {
            cards = savedCards
        } else {
            loadSampleCards()
        }
    }

    func getNextCardToRemember() -> Card? {
        // super inefficient compared to a one pass queue?
        let number = Int.random(in: 0 ..< cards.count)
        for card in cards {
            if card.dueDate < Date() {
                return card
            }
        }
        return nil
        
//        return cards[number]
    }
    
    func setNextRevision(card: Card, ease: Int) {
        if ease < 3 {
            card.interval = 1*24*60 // 1 day
        } else if card.reps == 1 {
            card.interval = 6*24*60 // 6 days
        } else {
            let newInterval = ceil(card.interval * card.easinessFactor)
            card.interval = newInterval
            print(card.interval, newInterval)
            let addend = 0.1 // -((5 - ease)*(0.08 + (5 - ease)*0.02))
            let newEasinessFactor = card.easinessFactor + addend
            card.easinessFactor = newEasinessFactor
            card.easinessFactor = max(1.3, card.easinessFactor)
        }
        card.dueDate = Date(timeIntervalSinceNow: card.interval)
        dump(card)
    }
    
    func addCard(card: Card) {
        cards.append(card)
    }
    
    func deleteCard(at: Int) {
        cards.remove(at: at)
        
    }
    
    func getAllCards() -> [Card] {
        return cards
    }
    
    //MARK: Private
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
    
    private func saveCards() {
        let codedData = try! NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: false)
        
        do {
            try codedData.write(to: Card.ArchiveURL)
        } catch {
            os_log("Couldn't write to save file.", type: .debug)
        }
    }
    
    private func loadCards() -> [Card]? {
        print(Card.ArchiveURL.absoluteString)
        guard let codedData = try? Data(contentsOf: Card.ArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        dump(cards)
        return cards
    }
}
