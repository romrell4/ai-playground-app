//
//  Player 1.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/21/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class Player: Player {
    
    var learningAlgos: LearningAlgorithms = LearningAlgorithms()
    
    var chosenAlgo = "titForTat"
    
    init(_ chosenAlgo: String) {
        chosenAlgo
    }
    
    var totalScore = 0
    var averageScore = 0
    var opponentActionMemory: [Action] = []

    func performAction() -> Action {
        var action = Action()
        
        action = learningAlgos.chooseAlgorithm(chosenAlgo, opponentActionMemory)
        
        return action
    }
}
