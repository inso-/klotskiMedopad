//
//  Cell.swift
//  KlotskiFramework
//
//  Created by inso on 21/12/2018.
//  Copyright © 2018 Thomas Moussajee. All rights reserved.
//

import Foundation

public enum CellType: Int {
	case empty = 0
	case small = 1
	case vertical = 2
	case horizontal = 3
	case square = 4
}

class Cell {
	let width: Int
	let height: Int
	let id: Int
	var coordinate: Coordinate = (0, 0)
	
	var type: CellType {
		if width == 1 {
			if height == 1 {
				return .small
			}
			if height == 2 {
				return .vertical
			}
		}
		if width == 2 {
			if height == 1 {
				return .horizontal
			}
			if height == 2 {
				return .square
			}
		}
		return .empty
	}
	
	init(width: Int, height: Int, coordinate: Coordinate, id: Int) {
		self.width = width
		self.height = height
		self.coordinate = coordinate
		self.id = id
	}
	
	
	
	func set(coordinate: Coordinate) -> Cell {
		self.coordinate = coordinate
		for y in self.coordinate.y..<self.coordinate.y + height {
			for x in self.coordinate.x..<self.coordinate.x + width {
				Klotski.main.typeBoard[y][x] = type
				Klotski.main.board[y][x] = id
			}
		}
		return self
	}
	
	var canGoLeft: Bool {
		get {
			if coordinate.x == 0 {
				return false
			}
			if Klotski.main.typeBoard[coordinate.y][coordinate.x - 1] == .empty &&
				Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x - 1] == .empty {
				return true
			}
			return false
		}
	}
	
	var canGoRight: Bool {
		get {
			if coordinate.x + width - 1 == 3 {
				return false
			}
			if  Klotski.main.typeBoard[coordinate.y][coordinate.x + width] == .empty &&
				Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x + width] == .empty {
				return true
			}
			return false
		}
	}
	
	var canGoUp: Bool {
		get {
			if coordinate.y == 0 {
				return false
			}
			if  Klotski.main.typeBoard[coordinate.y - 1][coordinate.x] == .empty &&
				Klotski.main.typeBoard[coordinate.y - 1][coordinate.x + width - 1] == .empty {
				return true
			}
			return false
		}
		
	}
	
	var canGoDown: Bool {
		get {
			if coordinate.y + height - 1 == 4 {
				return false
			}
			if  Klotski.main.typeBoard[coordinate.y + height][coordinate.x] == .empty &&
				Klotski.main.typeBoard[coordinate.y + height][coordinate.x + width - 1] == .empty {
				return true
			}
			return false
		}
	}
	
	func goLeft() {
		if !canGoLeft {
			return
		}
		Klotski.main.typeBoard[coordinate.y][coordinate.x + width - 1] = .empty
		Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x + width - 1] = .empty
		Klotski.main.board[coordinate.y][coordinate.x + width - 1] = -1
		Klotski.main.board[coordinate.y + height - 1][coordinate.x + width - 1] = -1
		Klotski.main.typeBoard[coordinate.y][coordinate.x - 1] = type
		Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x - 1] = type
		Klotski.main.board[coordinate.y][coordinate.x - 1] = id
		Klotski.main.board[coordinate.y + height - 1][coordinate.x - 1] = id
		coordinate.x -= 1;
	}
	
	func goRight() {
		if !canGoRight {
			return
		}
		Klotski.main.typeBoard[coordinate.y][coordinate.x] = .empty
		Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x] = .empty
		Klotski.main.board[coordinate.y][coordinate.x] = -1
		Klotski.main.board[coordinate.y + height - 1][coordinate.x] = -1
		Klotski.main.typeBoard[coordinate.y][coordinate.x + width] = type
		Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x + width] = type
		Klotski.main.board[coordinate.y][coordinate.x + width] = id
		Klotski.main.board[coordinate.y + height - 1][coordinate.x + width] = id
		coordinate.x += 1;
		
	}
	
	func goUp() {
		if !canGoUp {
			return
		}
		Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x] = .empty
		Klotski.main.typeBoard[coordinate.y + height - 1][coordinate.x + width - 1] = .empty
		Klotski.main.board[coordinate.y + height - 1][coordinate.x] = -1
		Klotski.main.board[coordinate.y + height - 1][coordinate.x + width - 1] = -1
		Klotski.main.typeBoard[coordinate.y - 1][coordinate.x] = type
		Klotski.main.typeBoard[coordinate.y - 1][coordinate.x + width - 1] = type
		Klotski.main.board[coordinate.y - 1][coordinate.x] = id
		Klotski.main.board[coordinate.y - 1][coordinate.x + width - 1] = id
		coordinate.y -= 1
		
	}
	
	func goDown() {
		if !canGoDown {
			return
		}
		Klotski.main.typeBoard[coordinate.y][coordinate.x] = .empty
		Klotski.main.typeBoard[coordinate.y][coordinate.x + width - 1] = .empty
		Klotski.main.board[coordinate.y][coordinate.x] = -1
		Klotski.main.board[coordinate.y][coordinate.x + width - 1] = -1
		Klotski.main.typeBoard[coordinate.y + height][coordinate.x] = type
		Klotski.main.typeBoard[coordinate.y + height][coordinate.x + width - 1] = type
		Klotski.main.board[coordinate.y + height][coordinate.x] = id
		Klotski.main.board[coordinate.y + height][coordinate.x + width - 1] = id
		coordinate.y += 1
	}
	
}
