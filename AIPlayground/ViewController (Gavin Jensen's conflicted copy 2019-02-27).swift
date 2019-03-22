//
//  ViewController.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/20/19.
//  Copyright © 2019 IS543. All rights reserved.


import UIKit

class ViewController: UIViewController {

    //game object
    //Accept objects that accept the players
    //keep AI object in the player objects
    //player1.whatIsYourAction
    
    var player1 = Player("Random", id: 0)
    var player2 = Player("FictitiousPlay", id: 1)
    
    var gameName = "PrisonersDilemma" {
        didSet {
            updateUI()
        }
    }
    
    var fast = true
    
    lazy var game = Game(set: gameName)
    
    var numberOfRounds = 1000
    var totalRounds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
    }
    
    //Game Circles ============================================================
    
    
    
    //Nav bar ============================================================
 
    @IBAction func resetBtn(_ sender: Any) {
        resetGame()
        updateUI()
    }
    
    @IBAction func changeGameBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Matrix Game", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let prisonersDilemma = UIAlertAction(title: "Prisoner's Dilemma", style: .default) { action in
            self.game.setPrisonersDilemma()
            self.title = "Prisoner's Dilemma"
            self.gameImg.image = #imageLiteral(resourceName: "game-prisoners-dilemma")
        }
        
        let stagHunt = UIAlertAction(title: "Stag Hunt", style: .default) { action in
            self.game.setStagHunt()
            self.title = "Stag Hunt"
            self.gameImg.image = #imageLiteral(resourceName: "game-stag-hunt")
        }
        
        let battle = UIAlertAction(title: "Battle of the Sexes", style: .default) { action in
            self.game.setBattle()
            self.title = "Battle of the Sexes"
            self.gameImg.image = #imageLiteral(resourceName: "game-battle-sexes")
        }
        
        let chicken = UIAlertAction(title: "Chicken", style: .default) { action in
            self.game.setChicken()
            self.title = "Chicken"
            self.gameImg.image = #imageLiteral(resourceName: "game-chicken")
        }
        
        actionSheet.addAction(prisonersDilemma)
        actionSheet.addAction(stagHunt)
        actionSheet.addAction(battle)
        actionSheet.addAction(chicken)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //Image ============================================================
    
    @IBOutlet weak var gameImg: UIImageView! {
        didSet{
            switch gameName {
            case "PrisonersDilemma":
                gameImg.image = #imageLiteral(resourceName: "game-prisoners-dilemma")
            case "StagHunt":
                gameImg.image = #imageLiteral(resourceName: "game-stag-hunt")
            case "Chicken":
                gameImg.image = #imageLiteral(resourceName: "game-chicken")
            case "Battle":
                gameImg.image = #imageLiteral(resourceName: "game-battle-sexes")
            default:
                break
            }
        }
    }
    
    
    //Bottom Bib ============================================================
    
    @IBOutlet weak var numRoundsTextField: UITextField!
    
    @IBAction func btnSpeedAction(_ sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Speed: fast" {
                btnSpeedOutlet.setTitle("Speed: slow", for: .normal)
                fast = false
            } else {
                btnSpeedOutlet.setTitle("Speed: fast", for: .normal)
                fast = true
            }
        }
    }
    
    @IBOutlet weak var btnSpeedOutlet: UIButton!
    
    @IBOutlet weak var btnStartOutlet: UIButton! {
        didSet {
            btnStartOutlet.layer.cornerRadius = 4
        }
    }
    
    @IBAction func btnStart(_ sender: Any) {
        view.endEditing(true)
        
        if let num = Int(numRoundsTextField.text!) {
            numberOfRounds = num
        }
        
        totalRounds += numberOfRounds
        
        runGame()
    }
    
    func configureTextField() {
        numRoundsTextField.delegate = self as UITextFieldDelegate
    }
    
    //Player Info ============================================================
    
    @IBOutlet weak var rowPlayerAvgScore: UILabel!
    @IBOutlet weak var colPlayerAvgScore: UILabel!
    
    @IBOutlet weak var rowPlayerTotalScore: UILabel!
    @IBOutlet weak var colPlayerTotalScore: UILabel!
    
    @IBOutlet weak var rowPlayerLabel: UILabel!
    
    //Strategy btn outlets
    @IBOutlet weak var colStrategyBtn: UIButton!

    @IBOutlet weak var rowStrategyBtn: UIButton!
    
    //Strategy btn actions
    @IBAction func rowPlayerStrategyBtn(_ sender: Any) {
        setStrategyActionSheet(for: player1, with: rowStrategyBtn)
    }
    
    @IBAction func colPlayerStrategyBtn(_ sender: Any) {
        setStrategyActionSheet(for: player2, with: colStrategyBtn)
    }
    
    private func setStrategyActionSheet(for player: Player, with btn: UIButton) {
        
        var actionSheetTitle = "Select Strategy"

        if player.id == 0 {
            actionSheetTitle = "Select Strategy for Row Player"
        } else if player.id == 1 {
            actionSheetTitle = "Select Strategy for Column Player"
        }

        let actionSheet = UIAlertController(title: actionSheetTitle, message: nil, preferredStyle: .actionSheet)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let TitForTat = UIAlertAction(title: "Tit for Tat", style: .default) { action in
            self.setPlayerStrategy(for: player, with: "titForTat")
            btn.setTitle("Tit for Tat", for: .normal)
        }

        let fictitiousPlay = UIAlertAction(title: "Fictitious Play", style: .default) { action in
            self.setPlayerStrategy(for: player, with: "fictitiousPlay")
            btn.setTitle("Fictitious Play", for: .normal)
        }

        let bully = UIAlertAction(title: "Bully", style: .default) { action in
            self.setPlayerStrategy(for: player, with: "Bully")
            btn.setTitle("Bully", for: .normal)
        }

        let WoLF = UIAlertAction(title: "WoLF", style: .default) { action in
            self.setPlayerStrategy(for: player, with: "WoLF")
            btn.setTitle("WoLF", for: .normal)
        }

        let random = UIAlertAction(title: "Random", style: .default) { action in
            self.setPlayerStrategy(for: player, with: "Random")
            btn.setTitle("Random", for: .normal)
        }

        actionSheet.addAction(TitForTat)
        actionSheet.addAction(fictitiousPlay)
        actionSheet.addAction(bully)
        actionSheet.addAction(WoLF)
        actionSheet.addAction(random)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true, completion: nil)
    }
    
    func setPlayerStrategy(for player: Player, with strategy: String) {
        player.chosenAlgo = strategy
    }
    
    //Run Game Logic ============================================================
    
    private func runGame() {
        
        var timeDelay = 2.0
        
        for _ in stride(from: 0, to: numberOfRounds, by: 1) {
            
            let playerOneAction = player1.performAction(given: game.matrixPayoffs)
            let playerTwoAction = player2.performAction(given: game.matrixPayoffs)

            givePlayersRememberance(with: playerOneAction, and: playerTwoAction)
            
            let scoresInRound = calculateTotalScores(with: playerOneAction, and: playerTwoAction)
        
            updateScores(with: scoresInRound)
            
            updateUI()
            
//            if fast == false {
//                
//            } else {
//                updateUI()
//            }
            
//            delay(delay: timeDelay) {
//                self.
//            }
//
//
//            timeDelay += 2.0
            
        }
    }
    
    func delay(delay: Double, closure: @escaping () -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    private func givePlayersRememberance(with player1Action: Action, and player2Action: Action ) {
        player1.opponentActionMemory.append(player2Action)
        player2.opponentActionMemory.append(player1Action)
        
        print("player1Action: ", player1Action.a)
        print("player2Action: ", player2Action.a, "\n")
    }
    
    //Run Game Logic ============================================================
    
    private func updateScores(with scores: (Int, Int)) {
        
        player1.totalScore += scores.0
        player1.averageScore = Double(player1.totalScore) / Double(totalRounds)
        
        player2.totalScore += scores.1
        player2.averageScore = Double(player2.totalScore) / Double(totalRounds)
    }
    
    func calculateTotalScores(with playerAction1: Action, and playerAction2: Action) -> (Int, Int) {
    
        let playerOneScore = game.matrixPayoffs[playerAction1.a][playerAction2.a].0
        let playerTwoScore = game.matrixPayoffs[playerAction1.a][playerAction2.a].1
        
        return (playerOneScore, playerTwoScore)
    }
    
    //Update UI ============================================================
    
    func updateUI() {
        rowPlayerTotalScore.text = "TOTAL: \(player1.totalScore)"
        colPlayerTotalScore.text = "TOTAL: \(player2.totalScore)"
    
        rowPlayerAvgScore.text = String(format: "%.3f", player1.averageScore)
        colPlayerAvgScore.text = String(format: "%.3f", player2.averageScore)
    }
    
    func resetGame() {
        player1.averageScore = 0
        player1.totalScore = 0
        
        player2.averageScore = 0
        player2.totalScore = 0
        
        totalRounds = 0
    }
    
    //Touching Helpers ============================================================
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numRoundsTextField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
