//
//  ViewController.swift
//  KlotskiGame
//
//  Created by inso on 19/12/2018.
//  Copyright © 2018 Thomas Moussajee. All rights reserved.
//

import UIKit
import KlotskiFramework

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
	
	struct FlatColor {
		struct Green {
			static let Fern = UIColor(netHex: 0x6ABB72)
			static let MountainMeadow = UIColor(netHex: 0x3ABB9D)
			static let ChateauGreen = UIColor(netHex: 0x4DA664)
			static let PersianGreen = UIColor(netHex: 0x2CA786)
		}
		
		struct Blue {
			static let PictonBlue = UIColor(netHex: 0x5CADCF)
			static let Mariner = UIColor(netHex: 0x3585C5)
			static let CuriousBlue = UIColor(netHex: 0x4590B6)
			static let Denim = UIColor(netHex: 0x2F6CAD)
			static let Chambray = UIColor(netHex: 0x485675)
			static let BlueWhale = UIColor(netHex: 0x29334D)
		}
		
		struct Violet {
			static let Wisteria = UIColor(netHex: 0x9069B5)
			static let BlueGem = UIColor(netHex: 0x533D7F)
		}
		
		struct Yellow {
			static let Energy = UIColor(netHex: 0xF2D46F)
			static let Turbo = UIColor(netHex: 0xF7C23E)
		}
		
		struct Orange {
			static let NeonCarrot = UIColor(netHex: 0xF79E3D)
			static let Sun = UIColor(netHex: 0xEE7841)
		}
		
		struct Red {
			static let TerraCotta = UIColor(netHex: 0xE66B5B)
			static let Valencia = UIColor(netHex: 0xCC4846)
			static let Cinnabar = UIColor(netHex: 0xDC5047)
			static let WellRead = UIColor(netHex: 0xB33234)
		}
		
		struct Gray {
			static let AlmondFrost = UIColor(netHex: 0xA28F85)
			static let WhiteSmoke = UIColor(netHex: 0xEFEFEF)
			static let Iron = UIColor(netHex: 0xD1D5D8)
			static let IronGray = UIColor(netHex: 0x75706B)
		}
	}
}


class ViewController: UIViewController {
	
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var solveButton: UIButton!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var prevButton: UIButton!
	@IBOutlet weak var moveLabel: UILabel!
	
	let smallColors = [UIColor.FlatColor.Red.Cinnabar, UIColor.FlatColor.Red.TerraCotta, UIColor.FlatColor.Red.Valencia, UIColor.FlatColor.Red.WellRead]
	
	let verticalColors = [UIColor.FlatColor.Blue.BlueWhale, UIColor.FlatColor.Blue.Chambray, UIColor.FlatColor.Blue.CuriousBlue, UIColor.FlatColor.Blue.Denim]

	@IBOutlet weak var gameView: UIView!
	var currentMove = 0 { didSet {
			self.moveLabel.text = "\(currentMove) / \(solution.keys.max()!)"
		}
	}
	var solution: [Int: ([[CellType]], [[Int]])] = [:]
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.initGame()
	}
	
	func initGame() {
		Klotski.main.pieces = [
			Piece(width: 2, height: 2, coordinate: (1, 0), id: 0),
			Piece(width: 2, height: 1, coordinate: (1, 2), id: 5),
			Piece(width: 1, height: 2, coordinate: (0, 0), id: 1),
			Piece(width: 1, height: 2, coordinate: (3, 2), id: 2),
			Piece(width: 1, height: 2, coordinate: (0, 2), id: 3),
			Piece(width: 1, height: 2, coordinate: (3, 0), id: 4),
			Piece(width: 1, height: 1, coordinate: (0, 4), id: 7),
			Piece(width: 1, height: 1, coordinate: (1, 3), id: 8),
			Piece(width: 1, height: 1, coordinate: (2, 3), id: 9),
			Piece(width: 1, height: 1, coordinate: (3, 4), id: 6),
		]
		
		Klotski.main.initBoard()
		self.displayGame(board: Klotski.main.board, typeBoard: Klotski.main.typeBoard)
		self.resetButton.isHidden = true
		self.nextButton.isHidden = true
		self.prevButton.isHidden = true
		self.moveLabel.isHidden = true
		self.solveButton.isHidden = false
	}
	
	func displayGame(board: [[Int]], typeBoard: [[CellType]] = []) {
		for sub in self.gameView.subviews {
			sub.removeFromSuperview()
		}
		let width = self.gameView.frame.width
		let height = self.gameView.frame.height
		
		for x in 0..<Klotski.main.width{
			for y in 0..<Klotski.main.height{
				var color: UIColor = .white
				let cell: CellType = typeBoard[y][x]
				
				switch cell {
				case .empty:
					color = UIColor.white
				case .small:
					color = .black
					color = smallColors[board[y][x] - 6]
				case .square:
					color = .yellow
				case .horizontal:
					color = UIColor.FlatColor.Yellow.Energy
				case .vertical:
					color = .blue
					color = verticalColors[board[y][x] - 1]
				}
				let cellWidht = (width / CGFloat(Klotski.main.width))
				let cellHeight = (height / CGFloat(Klotski.main.height))
				
				let xyCell = UIView(frame: CGRect(x: cellWidht * CGFloat(x),
												  y: cellHeight * CGFloat(y),
												  width: (cellWidht),
												  height: (cellHeight)))
				xyCell.backgroundColor = color
				self.gameView.addSubview(xyCell)

			}
		}
	}
	
	func displayPrevious() {
		let nbMove = solution.keys.max()!
		if currentMove < nbMove && currentMove > 1 {
			self.currentMove -= 1
			self.displayMove()
		} else if currentMove <= 1 {
			self.currentMove -= 1
			self.displayGame(board: Klotski.main.board, typeBoard: Klotski.main.typeBoard)
			self.prevButton.isHidden = self.currentMove == 0
		}
	}
	
	func dispayNext() {
		let nbMove = solution.keys.max()!
		if currentMove < nbMove && currentMove >= 0 {
			self.currentMove += 1
			displayMove()
		}
	}
	
	func displayMove() {
		let (typeboard, board) = solution[self.currentMove]!
		DispatchQueue.main.async {
			UIView.animate(withDuration: 1, animations: {
				self.displayGame(board: board, typeBoard: typeboard)
				self.view.setNeedsDisplay()
			})
		}
		self.nextButton.isHidden = self.currentMove == solution.keys.max()!
		self.prevButton.isHidden = self.currentMove == 0
	}

	@IBAction func resetClicked(_ sender: Any) {
		self.initGame()
	}
	
	@IBAction func solve(_ sender: Any) {
		Klotski.main.search(completion: { result in
			Klotski.main.printSolution(encodedBoard: result)
			self.solution = Klotski.main.getSolution(encodedBoard:result, solution: [:])
			self.solveButton.isHidden = true
			self.nextButton.isHidden = false
			self.resetButton.isHidden = false
			self.currentMove = 0
			self.moveLabel.isHidden = false
		})
	}
	
	@IBAction func displayNextMove(_ sender: Any) {
		self.dispayNext()
	}
	
	@IBAction func displayPreviousMove(_ sender: Any) {
		self.displayPrevious()
	}
	
}

