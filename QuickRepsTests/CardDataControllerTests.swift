//
//  CardDataControllerTests.swift
//  QuickRepsTests
//
//  Created by nkakkar on 06/10/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import XCTest
@testable import QuickReps


class CardDataControllerTests: XCTestCase {
    private var cardDataController: CardDataController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            try FileManager().removeItem(at: CardDataController.ArchiveURL)
            try FileManager().removeItem(at: CardDataController.DailyArchiveURL)
        } catch {
            print("Couldn't delete or doesn't exist ", error)
        }
        
        cardDataController = CardDataController.shared
        cardDataController.cards = [Card]()
        cardDataController.dailyCards = [Card]()
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialization() {
        
        // default 2 cards - no saved cards
        // How to check for the default cards?

        XCTAssert(cardDataController.cards.count == 0)
        
        // default 0 daily reminder cards
        dump(cardDataController.dailyCards)
        XCTAssert(cardDataController.dailyCards.isEmpty)
    }
    
    func testCreateNewAddend() {
        
    }
    
    func testTutorialOutput() {
        
        UserManager.shared.setFirstLaunch()
        
        let cards = cardDataController.getTodaysQueue()
        
        XCTAssertFalse(cards.isEmpty())
        
        XCTAssert(cards.top()!.top == "Welcome to QuickReps.\n Tap this card!")
        
    }
    
    func testIntervalSetting() {
        let currentDate = Date()
        let card = Card(top: "a", bottom: "b", dateAdded: currentDate, dueDate: currentDate, interval: Card.Time.oneDay, easinessFactor: 1.4, reps: 12, cardType: .learning)
        
        cardDataController.setNextRevision(card: card, time: -12)
        
        XCTAssert(card.interval == Card.Time.oneDay*6)
        
        // card data controller sets the next interval considering "now"
        XCTAssert(fabs(card.dueDate.timeIntervalSince(Date(timeIntervalSinceNow: card.interval))) < 0.1)
        XCTAssert(card.easinessFactor == 1.4)
        
        card.interval = Card.Time.oneDay*3.1415
        card.dueDate = Date() // to remove the extra reference time
        
        cardDataController.setNextRevision(card: card, time: 1)
        
        XCTAssert(card.interval.isLessThanOrEqualTo(ceil(Card.Time.oneDay*3.1415 / card.easinessFactor)*1.1))
        
        // card data controller sets the next interval considering "now"
        XCTAssert(fabs(card.dueDate.timeIntervalSince(Date(timeIntervalSinceNow: card.interval))) < 0.1)
        // min possible easiness factor
        XCTAssert(card.easinessFactor == 1.3)
        
        
        card.interval = Card.Time.oneDay*3.1415
        card.cardType = .learning
        cardDataController.setNextRevision(card: card, time: -12)

        XCTAssert(fabs(card.interval - ceil(Card.Time.oneDay*3.1415*1.3)) < 0.1)
        
        // card data controller sets the next interval considering "now"
        XCTAssert(fabs(card.dueDate.timeIntervalSince(Date(timeIntervalSinceNow: card.interval))) < 0.1)
        // min possible easiness factor
        XCTAssert(card.easinessFactor == 1.3)
        
        //BUG: Easiness factor never increases, but goes down with each wrong answer, till it stabilizes at 1.3!
        
        card.cardType = .learning
        cardDataController.setNextRevision(card: card, time: -4)

        XCTAssert(card.easinessFactor > 1.3)
        
    }

    func testCardLoadPerformance() {
        // This is an example of a performance test case.
        
        addCards(to: cardDataController, count: 10000)
        
        cardDataController.saveCards()
        
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = cardDataController.loadCards()
        }
    }
    
    private func addCards(to: CardDataController, count: Int) {
        for index in 0..<count {
            let card = Card(top: String(index), bottom: String(index+1))
            to.addCard(card: card)
        }
    }

}
