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

    private init() {
        if let savedCards = loadCards() {
            cards = savedCards
        } else {
            loadSampleCards()
        }
    }

    func getNextCardToRemember() -> Card {
        let number = Int.random(in: 0 ..< cards.count)
        
        return cards[number]
    }
    
    func addCard(card: Card) {

    }
    
    func deleteCard(card: Card) {
        
    }
    
    //MARK: Private
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
        return cards
    }
}
