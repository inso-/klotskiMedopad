//
//  Piece.swift
//  KlotskiFramework
//
//  Created by inso on 21/12/2018.
//  Copyright © 2018 Thomas Moussajee. All rights reserved.
//

import Foundation

public class Piece {
	let id: Int
	var width: Int
	var height: Int
	
	var coordinate: Coordinate
	
	public init(width: Int, height: Int, coordinate: Coordinate, id: Int) {
		self.width = width
		self.height = height
		self.coordinate = coordinate
		self.id = id
	}
	
}
