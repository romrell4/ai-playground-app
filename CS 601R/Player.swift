//
//  Player.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/25/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

//class Player {
//    var id: Int
//
//    let gameMatrix = Game(set: "")
//
//    var chosenAlgo = ""
//
//    var learningAlgos: LearningAlgorithms = LearningAlgorithms()
//
//    var totalScore = 0
//    var averageScore: Double = 0
//
//    var myActionMemory: [Action] = []
//    var opponentActionMemory: [Action] = []
//
//    var WoLFClass: WOLF_PHC
//
//    var matrixPayoffs = [
//        [(0,0),(0,0)],
//        [(0,0),(0,0)]
//    ]
//
//    init(_ chosenAlgo: String, id identifier: Int) {
//        self.chosenAlgo = chosenAlgo
//        self.id = identifier
//        WoLFClass = WOLF_PHC(matrix: gameMatrix.matrixPayoffs, playerID: id)
//    }
//
//    func performAction(given matrix: Array<Array<(Int, Int)>>) -> Action {
//
//        if chosenAlgo == "WoLF" {
//            return performActionWithWoLF()
//        }
//
//        var action = Action()
//
//        learningAlgos.playerID = id
//
//        action = learningAlgos.chooseAlgorithm(given: chosenAlgo, and: opponentActionMemory, and: matrix)
//
//        return action
//    }
//
//    func performActionWithWoLF() -> Action {
//        return WoLFClass.play()
//    }
//
//    func resetPlayer() {
//        averageScore = 0
//        totalScore = 0
//
//        myActionMemory = []
//        opponentActionMemory  = []
//        
//        WoLFClass.reset()
//        WoLFClass.matrix = gameMatrix.matrixPayoffs
//    }
//}

class Player {
	let title: String
	var score = 0
	var playHistory = [Int]()
	let play: ((Player, Game) -> Int)
	
	init(title: String, playBlock: @escaping ((Player, Game) -> Int)) {
		self.title = title
		self.play = playBlock
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
			return Int.random(in: 0...game.states.count - 1)
		}
	}
}
