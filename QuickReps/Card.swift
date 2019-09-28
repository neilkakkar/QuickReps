//
//  Card.swift
//  QuickReps
//
//  Created by nkakkar on 01/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import Foundation
import os.log

class Card: NSObject, NSCoding {
    
    //MARK: Properties
    var top: String
    var bottom: String
    var dateAdded: Date
    var dueDate: Date
    var interval: TimeInterval // in seconds
    var easinessFactor: Double // between 1.3 and 2.5
    var reps: Int
    var cardType: Int
    
    
    //MARK: Properties
    struct PropertyKey {
        static let top = "top"
        static let bottom = "bottom"
        static let dateAdded = "dateAdded"
        static let dueDate = "dueDate"
        static let interval = "interval"
        static let easinessFactor = "easinessFactor"
        static let reps = "reps"
        static let cardType = "cardType"
    }
    
    struct CardType {
        static let system = -1 // system generated cards
        static let new = 0 // new card
        static let learning = 1 // regular queue
        static let revising = 2 // same day re-do
    }

    static func createSystemCard(top: String, bottom: String) -> Card {
        let card = Card(top: top, bottom: bottom)
        card.cardType = CardType.system
        return card
    }
    
    init(top: String, bottom: String) {
        self.dateAdded = Date()
        self.top = top
        self.bottom = bottom
        self.dueDate = Date()
        self.interval = 1*24*60 // 1 day
        self.easinessFactor = 2.5
        self.reps = 0
        self.cardType = CardType.new
        super.init()
    }
    
    init(top: String, bottom: String, dateAdded: Date, dueDate: Date, interval: TimeInterval, easinessFactor: Double, reps: Int, cardType: Int) {
        self.top = top
        self.bottom = bottom
        self.dateAdded = dateAdded
        self.dueDate = dueDate
        self.interval = interval
        self.easinessFactor = easinessFactor
        self.reps = reps
        self.cardType = cardType
        super.init()
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.top, forKey: PropertyKey.top)
        aCoder.encode(self.bottom, forKey: PropertyKey.bottom)
        aCoder.encode(self.dateAdded, forKey: PropertyKey.dateAdded)
        aCoder.encode(self.dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(self.interval, forKey: PropertyKey.interval)
        aCoder.encode(self.easinessFactor, forKey: PropertyKey.easinessFactor)
        aCoder.encode(self.reps, forKey: PropertyKey.reps)
        aCoder.encode(self.cardType, forKey: PropertyKey.cardType)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let top = aDecoder.decodeObject(forKey: PropertyKey.top) as? String else {
            os_log("Unable to decode top string", type: .debug)
            return nil
        }
        guard let bottom = aDecoder.decodeObject(forKey: PropertyKey.bottom) as? String else {
            os_log("Unable to decode bottom string", type: .debug)
            return nil
        }
        guard let dateAdded = aDecoder.decodeObject(forKey: PropertyKey.dateAdded) as? Date else {
            os_log("Unable to decode dateAdded", type: .debug)
            return nil
        }
        guard let dueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDate) as? Date else {
            os_log("Unable to decode due date", type: .debug)
            return nil
        }
        let interval = aDecoder.decodeDouble(forKey: PropertyKey.interval)
        let easinessFactor = aDecoder.decodeDouble(forKey: PropertyKey.easinessFactor)
        let reps = aDecoder.decodeInteger(forKey: PropertyKey.reps)
        let cardType = aDecoder.decodeInteger(forKey: PropertyKey.cardType)
        self.init(top: top, bottom: bottom, dateAdded: dateAdded, dueDate: dueDate,
                  interval: interval, easinessFactor: easinessFactor, reps: reps, cardType: cardType)
    }
}
