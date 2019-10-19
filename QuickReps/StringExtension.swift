//
//  StringExtension.swift
//  QuickReps
//
//  Created by nkakkar on 19/10/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import Foundation

extension String {
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return ""
        }
    }
}
