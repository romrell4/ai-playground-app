//
//  Game.swift
//  CS 601R
//
//  Created by Eric Romrell.
//  Copyright © 2019. All rights reserved.
//
import Foundation

class Game {
	static var choices: [Game] { return [PrisonersDilemma(), StagHunt(), Chicken(), BattleOfTheSexes(), HighLow()] }
	
	let name: String
	let states: [String]
	let rewards: [[[Int]]]
	
	var gameTimer: Timer?
	
	init(name: String, states: [String], rewards: [[[Int]]]) {
		self.name = name
		self.states = states
		self.rewards = rewards
	}
	
	func play(numRounds: Int, player1: Player, player2: Player, delay: TimeInterval, onFinishedRound: @escaping (Int) -> Void) {
		//Reset the scores and play history
		[player1, player2].forEach { $0.reset() }
		
		var playedRounds = 0
		
		gameTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { (_) in
			//Allow each player to play, and add to their hisories
			let (p1Index, p2Index) = (player1.play(player1, player2, self), player2.play(player2, player1, self))
			player1.playHistory.append(p1Index)
			player2.playHistory.append(p2Index)
			
			//Determine their rewards
			let reward = self.rewards[p1Index][p2Index]
			player1.score += reward[0]
			player2.score += reward[1]
			
			//Check if we're finished
			playedRounds += 1
			if playedRounds >= numRounds {
				self.gameTimer?.invalidate()
			}
			
			//Allow the caller to exeucte some code when the round finishes
			onFinishedRound(playedRounds)
		}
	}
}

class PrisonersDilemma: Game {
	init() {
		super.init(name: "Prisoner's Dilemma", states: ["Cooperate", "Defect"], rewards: [
			[[3, 3], [0, 4]],
			[[4, 0], [1, 1]]
		])
	}
}

class StagHunt: Game {
	init() {
		super.init(name: "Stag Hunt", states: ["Stag", "Hare"], rewards: [
			[[4, 4], [1, 3]],
			[[3, 1], [2, 2]]
		])
	}
}

class Chicken: Game {
	init() {
		super.init(name: "Chicken", states: ["Swerve", "Straight"], rewards: [
			[[3, 3], [2, 4]],
			[[4, 2], [1, 1]]
		])
	}
}

class BattleOfTheSexes: Game {
	init() {
		super.init(name: "Battle of the Sexes", states: ["Opera", "Football"], rewards: [
			[[3, 2], [0, 0]],
			[[0, 0], [2, 3]]
		])
	}
}

class HighLow: Game {
	init() {
		super.init(name: "High Low", states: ["High", "Low"], rewards: [
			[[2, 2], [0, 0]],
			[[0, 0], [1, 1]]
		])
	}
}
