//
//  WoLF.swift
//  CS 601R
//
//  Created by Reed Perkins on 2/27/19.
//  Copyright © 2019 IS543. All rights reserved.
//

import Foundation

class WOLF_PHC {
    
    var myActionMemory = [Action]()
    var opponentActionMemory = [Action]()
    
    var playerID = 0
    var count = 0
    var matrix = Array<Array<(Int,Int)>>()
    var Q = [0.0, 0.0]
    var policy = [0.5,0.5]
    var avg_policy = [0.5,0.5]
    var alpha = 0.5
    var gamma = 0.9
    var learningRate = 0.01
    var delta_win = 0.01
    var delta_lose = 0.02
    var numActionsICanTake = 2
    var epsilon = 0.5

    init(matrix: Array<Array<(Int,Int)>>, playerID: Int ) {
        self.playerID = playerID
        count = 0
        self.matrix = matrix
    }
    
    func reset(){
        Q = [0.0, 0.0]
        policy = [0.5,0.5]
        avg_policy = [0.5,0.5]
        myActionMemory = [Action]()
        opponentActionMemory = [Action]()    }
    
    func maxQ() -> Int {
        if Q[0] > Q[1] {
            return 0
        } else {
            return 1
        }
    }

    //I need to know the action I took and the reward that I got.
    func observe() {
        
        //This is the reward of the player
        //What was my last reward given my last action given what the opponent did
        
        //Python
        //reward = rewards[id]
        
        
        //Swift
        var reward: Double = 0
        
        if myActionMemory.count > 0 {
            if playerID == 0 {
                reward = Double(matrix[myActionMemory.last!.a][opponentActionMemory.last!.a].0)
            } else {
                reward = Double(matrix[opponentActionMemory.last!.a][myActionMemory.last!.a].1)
            }
        }
        
        print("mylastaction: ", myActionMemory.last?.a, " oppLastAction: ", opponentActionMemory.last?.a)
        print("Player id: ", playerID, " reward: ", reward)
    
        //Python
        //This is the action of the player
        //action = actions[id]
        
        //Swift
        let action = myActionMemory.last
        
        //Python
//        next_action = maxQ()
//        a = alpha
//        g = gamma
//        Q = Q
        
        //Swift
        let next_action = maxQ()
        let a = alpha
        let g = gamma

        //Python
//        Q[action] = ((1 - a) * Q[action]) + (a * (reward + (g * Q[next_action])))
        
        //Swift
        Q[action!.a] = ((1 - a) * Q[action!.a]) + (a * (reward + (g * Q[next_action])))

        //    # update estimate of average policy
        count += 1
        
        //Python
//        for a in range(len(avg_policy)) { //Original
//              avg_policy[a] += ((policy[a] - avg_policy[a]) / count)
//        }
        
        //Swift For loop
        for index in avg_policy.indices {
            avg_policy[index] += ((policy[index] - avg_policy[index]) / Double(count))
        }

        //Python
        //    # update policy and constrain to a legal probability distribution
//        if np.dot(policy, Q) > np.dot(avg_policy, Q) {
//            delta = delta_win
//        } else {
//            delta = delta_lose
//        }
        
        //Swift For Loop
        var delta: Double //This is the learning rate
        if getDotProduct(of: policy, and: Q) > getDotProduct(of: avg_policy, and: Q) {
            delta = delta_win
        } else {
            delta = delta_lose
        }

        

        //Python
//        for a in range(len(policy)) {
//
//            if a == next_action {
//                policy[a] = min(1, policy[a] + delta)
//            } else {
//                policy[a] = max(0, (policy[a] - ((delta) / (actions.size -1))))
//            }
//        }
        
        
        //Swift
        for index in avg_policy.indices {
            if index == next_action {
                policy[index] = min(1, policy[index] + delta)
            } else {
                policy[index] = max(0, (policy[index] - ((delta) / Double(numActionsICanTake - 1))))
            }
        }
    }

    func play() -> Action {
        
        var action = Action()
        
        let randomDouble = Double.random(in: 0...1)
        
        if randomDouble < epsilon {
            action = chooseFromProbabilityDistribution(policy: policy)
            //Python: return np.random.choice(actions, p = policy)
            return action
        } else {
            //Python: return np.random.choice(actions)
            let randomInt = Int.random(in: 0...1)
            action.a = randomInt
            return action
        }
    }
    
    func chooseFromProbabilityDistribution(policy: Array<Double>)-> Action {
        var action = Action()
        
        let randomDouble = Double.random(in: 0...1) //Dart
        
        let actionOneProbability = policy[0]
        
        if randomDouble < actionOneProbability {
            action.a = 0
        } else {
            action.a = 1
        }
        
        return action
    }
    
    func getDotProduct(of policy: Array<Double>, and Q: Array<Double>) -> Double {
        //only for vectors of 2
        return policy[0] * Q[0] + policy[1] * Q[1]
    }
}
