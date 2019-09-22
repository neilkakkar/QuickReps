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
    var forgettingCurve: [(Int, Bool)]
    var dateAdded: Date
    
    //MARK: Properties
    struct PropertyKey {
        static let top = "top"
        static let bottom = "bottom"
        static let forgettingCurve = "forgettingCurve"
        static let dateAdded = "dateAdded"
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cards")
    
    init(top: String, bottom: String) {
        self.dateAdded = Date()
        self.forgettingCurve = []
        self.top = top
        self.bottom = bottom
        super.init()
    }
    
    init(top: String, bottom: String, forgettingCurve:[(Int, Bool)], dateAdded: Date) {
        self.top = top
        self.bottom = bottom
        self.forgettingCurve = forgettingCurve
        self.dateAdded = dateAdded
        super.init()
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.top, forKey: PropertyKey.top)
        aCoder.encode(self.bottom, forKey: PropertyKey.bottom)
        aCoder.encode(self.forgettingCurve, forKey: PropertyKey.forgettingCurve)
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
        self.init(top: top, bottom: bottom)
    }
}
