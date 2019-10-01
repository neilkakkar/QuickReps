//
//  Queue.swift
//  QuickReps
//
//  Created by nkakkar on 27/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import Foundation

class Node<T> {
    var value: T
    var next: Node?
    
    init(item: T) {
        value = item
    }
}

struct Queue<T> {
    private var head: Node<T>!
    private var tail: Node<T>!
    
    init() {
        head = nil
        tail = nil
    }
    
    static func +=(lhs: inout Queue<T>, rhs: [T]) {
        lhs.enqueue(items: rhs)
    }
    
    mutating func enqueue(item: T) {
        let newNode = Node(item: item)
        
        if head == nil {
            head = newNode
            tail = newNode
            return
        }
        
        tail.next = newNode
        tail = newNode
    }
    
    mutating func enqueue(items: [T]) {
        for item in items {
            self.enqueue(item: item)
        }
    }
    
    mutating func dequeue() -> T? {
        if let first = head {
            if let second = head.next {
                head = second
            } else {
                head = nil
                tail = nil
            }
            return first.value
        }
        return nil
    }
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    func top() -> T? {
        if isEmpty() {
            return nil
        }
        return head.value
    }
    
}
