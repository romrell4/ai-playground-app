//
//  Player.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/25/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class Player {
	static var choices: [Player] { return [/*Human(), */Random(), TitForTat(), FictitiousPlay(), Godfather(), Bully()] }
	
	let title: String
	var score = 0
	var playHistory = [Int]()
	let play: ((Player, Player, Game) -> Int)
	
	init(title: String, playBlock: @escaping ((Player, Player, Game) -> Int)) {
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
		super.init(title: "Human") { (me, opponent, game) -> Int in
			//TODO: Implement UI for human playing a game
			return 0
		}
	}
}

class Random: Player {
	init() {
		super.init(title: "Random") { (me, opponent, game) -> Int in
			return Int.random(in: 0..<game.states.count)
		}
	}
}

class TitForTat: Player {
	init() {
		super.init(title: "Tit-for-Tat") { (me, opponent, game) -> Int in
			return opponent.playHistory.last ?? Int.random(in: 0..<game.states.count)
		}
	}
}

class FictitiousPlay: Player {
	init() {
		super.init(title: "Fictitious Play") { (me, opponent, game) -> Int in
			let myRewards = game.rewards.map { $0.map { $0[0] } }
			//Only look at the last chunk of plays (for performance reasons)
			let distribution = opponent.playHistory.suffix(100).distribution(size: game.states.count)
			return myRewards.dot(vector: distribution).argmax()
		}
	}
}

class Leader: Player {
	private let offer: Array<Int>
	private let punishment: Array<Int>
	private var currentPunishment = [Int]()
	
	init(title: String, offer: Array<Int>, punishment: Array<Int>) {
		self.offer = offer
		self.punishment = punishment
		
		super.init(title: title) { (me, opponent, game) -> Int in
			guard let me = me as? Leader else { fatalError("Leader playing without a leader 'me' variable") }
			
			// If they reject the offer, extend their punishment
			if me.playHistory.count > 0 && opponent.playHistory.last != me.offer[0] {
				me.currentPunishment = me.punishment
			}
			
			if me.currentPunishment.count > 0 {
				return me.currentPunishment.remove(at: 0)
			} else {
				return me.offer[1]
			}
		}
	}
}

class Godfather: Leader {
	init() {
		//NOTE: This will only work if the first choice is cooperative, and the other is competitive
		super.init(title: "Godfather", offer: [0, 0], punishment: [1, 1, 1])
	}
}

class Bully: Leader {
	init() {
		//NOTE: This will only work if the first choice is cooperative, and the other is competitive
		super.init(title: "Bully", offer: [0, 1], punishment: [1, 1, 1])
	}
}
