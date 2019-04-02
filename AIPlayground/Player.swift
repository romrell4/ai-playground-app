//
//  Player.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/25/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class Player {
	static var choices: [Player] { return [Human(), Random(), TitForTat(), FictitiousPlay()] }
	
	let title: String
	var score = 0
	var playHistory = [Int]()
	let play: ((Player, Game) -> Int)
	
	init(title: String, playBlock: @escaping ((Player, Game) -> Int)) {
		self.title = title
		self.play = playBlock
	}
	
	func reset() {
		score = 0
		playHistory = []
	}
}

class Human: Player {
	init() {
		super.init(title: "Human") { (opponent, game) -> Int in
			//TODO: Implement UI for human playing a game
			return 0
		}
	}
}

class Random: Player {
	init() {
		super.init(title: "Random") { (opponent, game) -> Int in
			return Int.random(in: 0..<game.states.count)
		}
	}
}

class TitForTat: Player {
	init() {
		super.init(title: "Tit-for-Tat") { (opponent, game) -> Int in
			return opponent.playHistory.last ?? Int.random(in: 0..<game.states.count)
		}
	}
}

class FictitiousPlay: Player {
	init() {
		super.init(title: "Fictitious Play") { (opponent, game) -> Int in
			let myRewards = game.rewards.map { $0.map { $0.0 } }
			let distribution = opponent.playHistory.distribution(size: game.states.count)
			return myRewards.dot(vector: distribution).argmax()
		}
	}
}
