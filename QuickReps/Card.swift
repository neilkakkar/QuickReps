//
//  Card.swift
//  QuickReps
//
//  Created by nkakkar on 01/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import Foundation

class Card {
    
    //MARK: Properties
    var top: String
    var bottom: String
    var forgettingCurve: [(Int, Bool)]
    var dateAdded: Date
    
    init(top: String, bottom: String) {
        self.dateAdded = Date()
        self.forgettingCurve = []
        self.top = top
        self.bottom = bottom
    }
    
    init(top: String, bottom: String, forgettingCurve:[(Int, Bool)], dateAdded: Date) {
        self.top = top
        self.bottom = bottom
        self.forgettingCurve = forgettingCurve
        self.dateAdded = dateAdded
    }
}
