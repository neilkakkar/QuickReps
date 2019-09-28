//
//  UserManager.swift
//  QuickReps
//
//  Created by nkakkar on 27/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import Foundation


class UserManager {
    
    static let shared = UserManager()
    var dailyLimitDefault = 20
    
    private init() {
    }
    
    func getFirstLaunch() -> Bool {
        let LAUNCH_KEY = "launchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: LAUNCH_KEY)
        if launchedBefore {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: LAUNCH_KEY)
            return true
        }
    }
    
    func getDailyLimit() -> Int {
        let DAILY_LIMIT_KEY = "dailyCardLimit"
        let dailyLimit = UserDefaults.standard.integer(forKey: DAILY_LIMIT_KEY)
        if dailyLimit != 0 {
            return dailyLimit
        } else {
            UserDefaults.standard.set(dailyLimitDefault, forKey: DAILY_LIMIT_KEY)
            return dailyLimitDefault
        }
    }
    
    func setDailyLimit() {
        
    }
}
