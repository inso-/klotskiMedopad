//
//  Utils.swift
//  KlotskiFramework
//
//  Created by inso on 21/12/2018.
//  Copyright © 2018 Thomas Moussajee. All rights reserved.
//

import Foundation

extension String {
	func replace(StringAtIndex: Int, with newChar: Character) -> String {
		var modifiedString = ""
		for (i, char) in self.enumerated() {
			modifiedString += String((i == StringAtIndex) ? newChar : char)
		}
		return modifiedString
	}
	
	subscript(idx: Int) -> String {
		guard let strIdx = index(startIndex, offsetBy: idx, limitedBy: endIndex)
			else { fatalError("String index out of bounds") }
		return "\(self[strIdx])"
	}
	
}

public struct LinkedList<T> {
	private var head: Node<T>?
	private var tail: Node<T>?
	
	public init() { }
	
	public var isEmpty: Bool {
		return head == nil
	}
	
	public var first: Node<T>? {
		return head
	}
	
	public mutating func append(_ value: T) {
		let newNode = Node(value: value)
		if let tailNode = tail {
			newNode.previous = tailNode
			tailNode.next = newNode
		} else {
			head = newNode
		}
		tail = newNode
	}
	
	public mutating func remove(_ node: Node<T>) -> Void {
		let prev = node.previous
		let next = node.next
		
		if let prev = prev {
			prev.next = next
		} else {
			head = next
		}
		next?.previous = prev
		
		if next == nil {
			tail = prev
		}
		
		node.previous = nil
		node.next = nil
		
		return
	}
}

public class Node<T> {
	public var value: T
	public var next: Node<T>?
	public var previous: Node<T>?
	
	public init(value: T) {
		self.value = value
	}
}

public struct SwiftyQueue<T> {
	
	fileprivate var list = LinkedList<T>()
	
	public var isEmpty: Bool {
		return list.isEmpty
	}
	
	public mutating func enqueue(_ element: T) {
		list.append(element)
	}
	
	public mutating func dequeue() -> T? {
		guard !list.isEmpty, let element = list.first else { return nil }
		
		list.remove(element)
		
		return element.value
	}
	
	public func peek() -> T? {
		return list.first?.value
	}
}
