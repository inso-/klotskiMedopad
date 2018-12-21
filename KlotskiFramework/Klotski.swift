//
//  Klotski.swift
//  KlotskiFramework
//
//  Created by inso on 19/12/2018.
//  Copyright © 2018 Thomas Moussajee. All rights reserved.
//

import Foundation

public typealias Coordinate = (x: Int, y: Int)

public class Klotski {
	public static let main = Klotski()
	public var height = 5
	public var width = 4
	public var board: [[Int]] = []
	public var typeBoard: [[CellType]] = []
	var encodedBoard: String = ""
	public var pieces : [Piece] = []
	
	var boardTried: [String: Bool] = [:]
	var movesNumber: [String: Int] = [:]
	
	var codeAt: [Int: String] = [:]
	
	var st: [String: Int] = [:]
	var ts: [Int: String] = [:]
	
	var numberOfBoardTried: Int = 0
	
	var queue = SwiftyQueue<String>()
	
	var parents: [Int] = Array(repeating: 0, count: 100000)
	
	var cells: [Cell] = []
	
	var backtrackSteps: [[(Int, Int)]] = []
	
	var charArr = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
	
	public func initBoard() {
		cells = []
		self.encodedBoard = ""
		self.resetBoard()
		for piece in pieces {
			let new = Cell(width: piece.width,
						   height: piece.height, coordinate: piece.coordinate,
						   id: piece.id)
			cells.append(new)
			new.set(coordinate: piece.coordinate)
		}
	}
	
	func resetBoard() {
		self.board = Array(repeating: Array(repeating: -1, count: self.width), count: self.height)
		self.typeBoard = Array(repeating: Array(repeating: CellType.empty, count: self.width), count: self.height)
		
	}
	
	func encode() {
		self.encodedBoard = ""
		for x in 0..<self.height {
			for y in 0..<self.width {
				self.encodedBoard.append("\(typeBoard[x][y].rawValue)")
				if self.board[x][y] > 0 {
					self.encodedBoard += String(board[x][y])
				} else {
					self.encodedBoard += "0"
				}
			}
		}
	}
	
	public func printBoard() {
		for x in 0..<self.height {
			for y in 0..<self.width {
				print(((board[x][y] >= 0 ? charArr[board[x][y]] : " ") + " "), terminator: "")
			}
			print(" ")
		}
		print(" ")
	}
	
	func typeBoardFrom(encodedBoard: String) -> String {
		var typeBoard = ""
		for (index, char) in encodedBoard.enumerated() {
			if index % 2 == 0 {
				typeBoard.append(char)
			}
		}
		return typeBoard
	}
	
	func setBoardFrom(encodedBoard: String) {
		var nextBoard = typeBoardFrom(encodedBoard: encodedBoard)
		self.resetBoard()
		
		var a = 0
		var b = 0
		
		for y in 0..<self.height {
			for x in 0..<self.width {
				var width = 0
				var height = 0
				let id = Int(encodedBoard[2 * b + 1])!
				switch nextBoard[b] {
				case "1":
					width = 1
					height = 1
					cells[a] = Cell(width: width,
									  height: height,
									  coordinate: (x, y),
									  id: id)
					cells[a].set(coordinate: (x, y))
					a += 1
				case "2":
					width = 1
					height = 2
					cells[a] = Cell(width: width,
									  height: height,
									  coordinate: (x, y),
									  id: id)
					nextBoard = nextBoard.replace(StringAtIndex: b + self.width,
														 with: "X")
					cells[a].set(coordinate: (x, y))
					a += 1
				case "3":
					width = 2
					height = 1
					cells[a] = Cell(width: width,
									  height: height,
									  coordinate: (x, y),
									  id: id)
					nextBoard = nextBoard.replace(StringAtIndex: b + 1,
														with: "X")
					cells[a].set(coordinate: (x, y))
					a += 1
				case "4":
					width = 2
					height = 2
					cells[a] = Cell(width: width,
									  height: height,
									  coordinate: (x, y),
									  id: id)
					nextBoard = nextBoard.replace(StringAtIndex: b + 1,
														with: "X")
					nextBoard = nextBoard.replace(StringAtIndex: b + self.width,
														with: "X")
					nextBoard = nextBoard.replace(StringAtIndex: b + self.height,
														with: "X")
					cells[a].set(coordinate:(x, y))
					a += 1
				default:
					width = 0
					height = 0
				}
				b += 1
			}
		}
	}
	
	func updateCurrent(subBoard: String, currentBoard: String) {
		queue.enqueue(subBoard)
		boardTried[subBoard] = true
		movesNumber[subBoard] = movesNumber[currentBoard]! + 1
		ts[numberOfBoardTried] = subBoard
		codeAt[numberOfBoardTried] = self.encodedBoard
		st[subBoard] = numberOfBoardTried
		numberOfBoardTried += 1
		parents[st[subBoard]!] = st[currentBoard]!
	}
	
	func move(cell: Cell, currentBoard: String, direction: Int, and completion: (String) -> ()) -> Bool {
		switch direction {
		case 0:
			if cell.canGoLeft {
				cell.goLeft()
			} else {
				return false
			}
		case 1:
			if cell.canGoRight {
				cell.goRight()
			} else {
				return false
			}
		case 2:
			if cell.canGoUp {
				cell.goUp()
			} else {
				return false
			}
		case 3:
			if cell.canGoDown {
				cell.goDown()
			} else {
				return false
			}
		default:
			return false
		}
		
		encode()
		let nextBoard = self.typeBoardFrom(encodedBoard: self.encodedBoard)
		if boardTried[nextBoard] == nil {
			updateCurrent(subBoard: nextBoard, currentBoard: currentBoard)
			if self.isWinningState() {
				completion(nextBoard)
				print("Solution Find!")
				return true
			}
		}
		
		switch direction {
		case 0:
			cell.goRight()
		case 1:
			cell.goLeft()
		case 2:
			cell.goDown()
		case 3:
			cell.goUp()
		default:
			break
		}
		return false
	}
	
	func isWinningState() -> Bool {
		return (self.typeBoard[3][1].rawValue == self.typeBoard[3][2].rawValue &&
			self.typeBoard[3][2].rawValue == self.typeBoard[4][1].rawValue &&
			self.typeBoard[4][1].rawValue == self.typeBoard[4][2].rawValue &&
			self.typeBoard[4][1].rawValue == 4)
	}
	
	private func resetSearch() {
		self.ts = [:]
		self.st = [:]
		self.codeAt = [:]
		self.movesNumber = [:]
		self.boardTried = [:]
		self.numberOfBoardTried = 0
		self.parents = Array(repeating: 0, count: 100000)
		self.backtrackSteps = []
		while (self.queue.isEmpty == false) {
			self.queue.dequeue()
		}
	}
	
	public func search(completion: (String) -> ()) {
		self.initBoard()
		self.resetSearch()
		self.encode()
		
		let p = self.typeBoardFrom(encodedBoard: self.encodedBoard)
		
		queue.enqueue(p)
		boardTried[p] = true
		movesNumber[p] = 0
		
		ts[numberOfBoardTried] = p
		codeAt[numberOfBoardTried] = self.encodedBoard
		
		st[p] = numberOfBoardTried
		numberOfBoardTried += 1
		
		parents[0] = 0

		while queue.isEmpty != true {
			let curent = queue.dequeue()
			self.setBoardFrom(encodedBoard: codeAt[st[curent!]!]!)
			self.encode()
			
			for cell in cells {
				
				for direction in 0..<4 {
					if move(cell: cell, currentBoard: curent!, direction: direction, and: completion) {
						return
					}
				}
			}
		}
	}
	
	func decode(string: String) {
		var emptyArr = Array(repeating: (-1, -1), count: 10)
		for (index, _) in string.enumerated() {
			
			if index % 2 == 0 {
				
				let cursor = Int(string[index + 1])!
				if string[index] != "0" && emptyArr[cursor].0 == -1 && emptyArr[cursor].1 == -1 {
					emptyArr[cursor].0 = (index / 2) % 4
					emptyArr[cursor].1 = (index / 2 - emptyArr[cursor].0) / 4
				}
			}
		}
		backtrackSteps.append(emptyArr)
	}
	
	public func printSolution(encodedBoard: String) {
		if st[encodedBoard] == 0 {
			setBoardFrom(encodedBoard: codeAt[st[encodedBoard]!]!)
			printBoard()
			return
		}
		printSolution(encodedBoard: ts[parents[st[encodedBoard]!]]!)
		setBoardFrom(encodedBoard: codeAt[st[encodedBoard]!]!)
		print("moves number :\(movesNumber[encodedBoard]!)")
		printBoard()
	}
	
	public func getSolution(encodedBoard: String, solution: [Int: ([[CellType]], [[Int]])]) -> [Int: ([[CellType]], [[Int]])] {
		if st[encodedBoard] == 0 {
			setBoardFrom(encodedBoard: codeAt[st[encodedBoard]!]!)
			return solution
		}
		var solution = solution
		
		setBoardFrom(encodedBoard: codeAt[st[encodedBoard]!]!)
		solution[movesNumber[encodedBoard]!] = (self.typeBoard, self.board)
		
		solution = getSolution(encodedBoard: ts[parents[st[encodedBoard]!]]!, solution: solution)
		return solution
		
	}


}
