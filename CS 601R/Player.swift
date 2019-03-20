//
//  Player.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/25/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class Player {
    var id: Int
    
    let gameMatrix = Game(set: "")
    
    var chosenAlgo = ""
    
    var learningAlgos: LearningAlgorithms = LearningAlgorithms()
    
    var totalScore = 0
    var averageScore: Double = 0
    
    var myActionMemory: [Action] = []
    var opponentActionMemory: [Action] = []
    
    var WoLFClass: WOLF_PHC
    
    var matrixPayoffs = [
        [(0,0),(0,0)],
        [(0,0),(0,0)]
    ]
    
    init(_ chosenAlgo: String, id identifier: Int) {
        self.chosenAlgo = chosenAlgo
        self.id = identifier
        WoLFClass = WOLF_PHC(matrix: gameMatrix.matrixPayoffs, playerID: id)
    }
    
    func performAction(given matrix: Array<Array<(Int, Int)>>) -> Action {
        
        if chosenAlgo == "WoLF" {
            return performActionWithWoLF()
        }
        
        var action = Action()
        
        learningAlgos.playerID = id
        
        action = learningAlgos.chooseAlgorithm(given: chosenAlgo, and: opponentActionMemory, and: matrix)
        
        return action
    }
    
    func performActionWithWoLF() -> Action {
        return WoLFClass.play()
    }
    
    func resetPlayer() {
        averageScore = 0
        totalScore = 0
        
        myActionMemory = []
        opponentActionMemory  = []
        
        WoLFClass.reset()
        WoLFClass.matrix = gameMatrix.matrixPayoffs
    }
}
