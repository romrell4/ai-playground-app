//
//  Game.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/25/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class Game {
    
    var matrixPayoffs = [
        [(0,0),(0,0)],
        [(0,0),(0,0)]
    ]
    
    var topLeft = (0,0)
    var topRight = (0,0)
    var bottomLeft = (0,0)
    var bottomRight = (0,0)
    
    init(set current: String) {
        switch current {
        case "PrisonersDilemma":
            setPrisonersDilemma()
        case "Chicken":
            setChicken()
        case "StagHunt":
            setStagHunt()
        case "Battle":
            setBattle()
        default:
            setPrisonersDilemma()
        }
    }

    func setStagHunt() {
        
        topLeft = (4,4)
        topRight = (1,3)
        bottomLeft = (3,1)
        bottomRight = (2,2)
        
        let row1 = [topLeft, topRight]
        let row2 = [bottomLeft, bottomRight]
        
        matrixPayoffs = [row1, row2]
        
        print("setStagHunt called")
        
    }
    
    func setChicken() {
        
        topLeft = (3,3)
        topRight = (2,4)
        bottomLeft = (4,2)
        bottomRight = (1,1)
        
        let row1 = [topLeft, topRight]
        let row2 = [bottomLeft, bottomRight]
        
        matrixPayoffs = [row1, row2]
        
    }
    
    func setPrisonersDilemma() {
        
        topLeft = (3,3)
        topRight = (0,4)
        bottomLeft = (4,0)
        bottomRight = (1,1)
        
        let row1 = [topLeft, topRight]
        let row2 = [bottomLeft, bottomRight]
        
        matrixPayoffs = [row1, row2]
        
    }
    
    func setBattle() {
        
        topLeft = (3,2)
        topRight = (1,1)
        bottomLeft = (0,0)
        bottomRight = (2,3)
        
        let row1 = [topLeft, topRight]
        let row2 = [bottomLeft, bottomRight]
        
        matrixPayoffs = [row1, row2]
        
    }
    
}
