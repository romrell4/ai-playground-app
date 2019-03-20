//
//  Game.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/25/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

//class Game {
//    
//    var matrixPayoffs = [
//        [(0,0),(0,0)],
//        [(0,0),(0,0)]
//    ]
//    
//    var topLeft = (0,0)
//    var topRight = (0,0)
//    var bottomLeft = (0,0)
//    var bottomRight = (0,0)
//    
//    init(set current: String) {
//        switch current {
//        case "PrisonersDilemma":
//            setPrisonersDilemma()
//        case "Chicken":
//            setChicken()
//        case "StagHunt":
//            setStagHunt()
//        case "Battle":
//            setBattle()
//        default:
//            setPrisonersDilemma()
//        }
//    }
//
//    func setStagHunt() {
//        
//        topLeft = (4,4)
//        topRight = (1,3)
//        bottomLeft = (3,1)
//        bottomRight = (2,2)
//        
//        let row1 = [topLeft, topRight]
//        let row2 = [bottomLeft, bottomRight]
//        
//        matrixPayoffs = [row1, row2]
//        
//        print("setStagHunt called")
//        
//    }
//    
//    func setChicken() {
//        
//        topLeft = (3,3)
//        topRight = (2,4)
//        bottomLeft = (4,2)
//        bottomRight = (1,1)
//        
//        let row1 = [topLeft, topRight]
//        let row2 = [bottomLeft, bottomRight]
//        
//        matrixPayoffs = [row1, row2]
//        
//    }
//    
//    func setPrisonersDilemma() {
//        
//        topLeft = (3,3)
//        topRight = (0,4)
//        bottomLeft = (4,0)
//        bottomRight = (1,1)
//        
//        let row1 = [topLeft, topRight]
//        let row2 = [bottomLeft, bottomRight]
//        
//        matrixPayoffs = [row1, row2]
//        
//    }
//    
//    func setBattle() {
//        
//        topLeft = (3,2)
//        topRight = (1,1)
//        bottomLeft = (0,0)
//        bottomRight = (2,3)
//        
//        let row1 = [topLeft, topRight]
//        let row2 = [bottomLeft, bottomRight]
//        
//        matrixPayoffs = [row1, row2]
//        
//    }
//    
//}

import UIKit

class Game {
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
	
	func start(numRounds: Int, player1: Player, player2: Player) {
		//		print("Welcome to {}. The game is simple. Try to maximize your rewards during {} rounds. Here is the reward matrix:".format(self.name, self.num_rounds))
		//		matrix = [["", *self.states]]
		//		[matrix.append([state, *row]) for state, row in zip(self.states, self.rewards)]
		//		for row in matrix: print("".join([str(cell).rjust(10) for cell in row]))
		
		for _ in 0...numRounds {
			//			print("\n{} {}".format(self.player1, self.player2))
			let (p1Index, p2Index) = (player1.play(player2, self), player2.play(player1, self))
			player1.playHistory.append(p1Index)
			player2.playHistory.append(p2Index)
			
			//			let states = playIndices.map { self.states[$0] }
			//			print("{} played {}, {} played {}".format(self.player1.name, p1_state, self.player2.name, p2_state))
			//			reward = self.rewards[p1_index, p2_index]
			let reward = self.rewards[p1Index][p2Index]
			player1.score += reward.0
			player2.score += reward.1
		}
		
		//		print("\nGame Over! Thanks for playing! Here are the scores:\n{} {}".format(self.player1, self.player2))
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
