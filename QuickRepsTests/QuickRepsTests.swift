//
//  QuickRepsTests.swift
//  QuickRepsTests
//
//  Created by nkakkar on 01/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import XCTest
@testable import QuickReps

class QuickRepsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQueue() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var queue = Queue<Int>()
        queue.enqueue(item: 1)
        
        XCTAssert(1 == queue.dequeue())
        
        queue.enqueue(item: 1)
        queue.enqueue(item: 2)
        queue.enqueue(item: 3)
        
        XCTAssert(1 == queue.dequeue())
        XCTAssert(2 == queue.dequeue())
        
        XCTAssert(!queue.isEmpty())
        
        queue.enqueue(item: 4)
        
        XCTAssert(3 == queue.dequeue())
        XCTAssert(4 == queue.dequeue())
        XCTAssert(nil == queue.dequeue())
        
        XCTAssert(queue.isEmpty())
        
        queue.enqueue(items: [1, 2, 3, 4])
        
        XCTAssert(1 == queue.dequeue())
        XCTAssert(2 == queue.dequeue())
        XCTAssert(3 == queue.dequeue())
        XCTAssert(4 == queue.dequeue())
        
        queue += [1, 2, 3, 4]
        
        XCTAssert(1 == queue.dequeue())
        XCTAssert(2 == queue.dequeue())
        XCTAssert(3 == queue.dequeue())
        XCTAssert(4 == queue.dequeue())
        
        //empty list test
        queue += []
        XCTAssert(queue.isEmpty())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
