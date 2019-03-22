//
//  Game.swift
//  CS 601R
//
//  Created by Eric Romrell.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class Game {
	static var choices: [Game] { return [PrisonersDilemma(), StagHunt()] }
	
	var name: String
	var states: [String]
	var image: UIImage
	var rewards: [[(Int, Int)]]
	
	init(name: String, states: [String], image: UIImage, rewards: [[(Int, Int)]]) {
		self.name = name
		self.states = states
		self.image = image
		self.rewards = rewards
	}
	
	func play(numRounds: Int, player1: Player, player2: Player, onFinishedRound: () -> Void = {}) {
		//Reset the scores and play history
		[player1, player2].forEach { $0.reset() }
		
		for _ in 0...numRounds {
			//Allow each player to play, and add to their hisories
			let (p1Index, p2Index) = (player1.play(player2, self), player2.play(player1, self))
			player1.playHistory.append(p1Index)
			player2.playHistory.append(p2Index)
			
			//Determine their rewards
			let reward = self.rewards[p1Index][p2Index]
			player1.score += reward.0
			player2.score += reward.1
			
			//Allow the caller to exeucte some code when the round finishes
			onFinishedRound()
		}
	}
}

class PrisonersDilemma: Game {
	init() {
		super.init(name: "Prisoner's Dilemma", states: ["Cooperate", "Defect"], image: #imageLiteral(resourceName: "game-prisoners-dilemma"), rewards: [
			[(3, 3), (0, 4)],
			[(4, 0), (1, 1)]
		])
	}
}

class StagHunt: Game {
	init() {
		super.init(name: "Stag Hunt", states: ["Stag", "Hare"], image: #imageLiteral(resourceName: "game-stag-hunt"), rewards: [
			[(4, 4), (1, 3)],
			[(3, 1), (2, 2)]
		])
	}
}
