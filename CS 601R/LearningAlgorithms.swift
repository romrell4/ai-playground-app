//
//  LearningAlgorithms.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/21/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class LearningAlgorithms {
    
    var playerID = 0
    
    func chooseAlgorithm(given algorithmTitle: String, and actions: [Action], and gameMatrix: Array<Array<(Int, Int)>>) -> Action{
        
        var action = Action()
        action.a = 0
        
        switch algorithmTitle {
        case "titForTat":
            return titForTat(given: actions)
        case "fictitiousPlay":
            return fictitiousPlay(given: actions, and: gameMatrix)
        case "Bully":
            return bully(given: gameMatrix)
        case "WoLF":
            return WoLF(for: actions)
        case "Random":
            return random()
        default:
            //return titForTat(given: actions)
            print("No algorithm found: ", algorithmTitle)
            action.a = -1
            return action
        }
    }
    
    func titForTat(given actions: [Action]) -> Action {
        var action = Action()
        
        if actions.count == 0 {
            action.a = 0
            return action
        }
        
        if let a = actions.last {
            action = a
        }
        
        return action
    }
    
    func random() -> Action {
        var action = Action()
        action.a = Int.random(in: 0...1)
        return action
    }
    
    func bully(given matrix: Array<Array<(Int, Int)>>) -> Action {
        var action = Action()
        
        let row1Max: Int
        let row2Max: Int
        
        if playerID == 0{
            let upperLeft = matrix[0][0].0
            let upperRight = matrix[0][1].0
            row1Max = max(upperLeft, upperRight)
        
            let lowerLeft = matrix[1][0].0
            let lowerRight = matrix[1][1].0
            row2Max = max(lowerLeft, lowerRight)
        } else {
            let upperLeft = matrix[0][0].1
            let lowerLeft = matrix[1][0].1

            row1Max = max(upperLeft, lowerLeft)
            
            let upperRight = matrix[0][1].1
            let lowerRight = matrix[1][1].1
            row2Max = max(upperRight, lowerRight)
        }
        
        if row1Max > row2Max {
            action.a = 0
        } else {
            action.a = 1
        }
        
        //print(playerID, upperLeft, upperRight, lowerLeft, lowerRight)
        
//        print("action: ", action.a, "\n")
        return action
    }

    func fictitiousPlay(given actions: [Action], and matrix: Array<Array<(Int, Int)>>)-> Action {
        var action = Action()
        
        if actions.count == 0 {
            action.a = 0
            return action
        }
        
        let gamma = calcGamma(of: actions)
        
        
        let upperLeft: Int
        let upperRight: Int
        let lowerLeft: Int
        let lowerRight: Int
        
        if playerID == 0 {
            upperLeft = matrix[0][0].0
            upperRight = matrix[0][1].0
            lowerLeft = matrix[1][0].0
            lowerRight = matrix[1][1].0
        
        } else {
            upperLeft = matrix[0][0].1
            upperRight = matrix[0][1].1
            lowerLeft = matrix[1][0].1
            lowerRight = matrix[1][1].1
        }
        
        let expectedVal0 = gamma.0 * Double(upperLeft) + gamma.1 * Double(upperRight)
        let expectedVal1 = gamma.0 * Double(lowerLeft) + gamma.1 * Double(lowerRight)
        
        if expectedVal0 > expectedVal1 {
            action.a = 0
        } else {
            action.a = 1
        }
        
        return action
    }
    
    //probabilities over time for fictitious play
    
    func calcGamma(of actions: [Action]) -> (Double, Double) {

        let k = calcK(for: actions)
        
        let percentA: Double = k.0 / (k.0 + k.1)
        let percentB: Double = k.1 / (k.0 + k.1)
        
        return (percentA, percentB)
    }
    
    func calcK(for actions: [Action]) -> (Double, Double) {
        var num0: Double = 0
        var num1: Double = 0
        
        for action in actions {
            if action.a == 0 {
                num0 += 1
            } else {
                num1 += 1
            }
        }
        
        return (num0, num1)
    }
    
    func WoLF(for actions: [Action]) -> Action {
        var action = Action()
        
        return action
    }
    
    
    //need to get the gamma = K[left], K[left],
    //need to get K = probability of left or right.
    //K also starts with a prior.
    //
}


