//
//  ViewController.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/20/19.
//  Copyright © 2019 IS543. All rights reserved.


import UIKit

class ViewController: UIViewController {

    var rowPlayer = Random()
    var colPlayer = Random()
    
	var game: Game = PrisonersDilemma() {
        didSet {
			resetGame()
            updateUI()
        }
    }
    
    var fast = true
    
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
			self.game = PrisonersDilemma()
        }
        
        let stagHunt = UIAlertAction(title: "Stag Hunt", style: .default) { action in
			self.game = StagHunt()
        }

		//TODO: Implement these games
//        let battle = UIAlertAction(title: "Battle of the Sexes", style: .default) { action in
//            self.game.setBattle()
//            update()
//            self.title = "Battle of the Sexes"
//            self.gameImg.image = #imageLiteral(resourceName: "game-battle-sexes")
//        }
//
//        let chicken = UIAlertAction(title: "Chicken", style: .default) { action in
//            self.game.setChicken()
//            self.resetGame()
//            self.updateUI()
//            self.title = "Chicken"
//            self.gameImg.image = #imageLiteral(resourceName: "game-chicken")
//        }
		
        func update() {
            resetGame()
            updateUI()
        }
        
        actionSheet.addAction(prisonersDilemma)
        actionSheet.addAction(stagHunt)
//        actionSheet.addAction(battle)
//        actionSheet.addAction(chicken)
        actionSheet.addAction(cancel)
		
        present(actionSheet, animated: true, completion: nil)
    }
    
    //Image ============================================================
    
    @IBOutlet weak var gameImg: UIImageView! {
        didSet{
            switch game {
            case is PrisonersDilemma:
                gameImg.image = #imageLiteral(resourceName: "game-prisoners-dilemma")
            case is StagHunt:
                gameImg.image = #imageLiteral(resourceName: "game-stag-hunt")
//            case "Chicken":
//                gameImg.image = #imageLiteral(resourceName: "game-chicken")
//            case "Battle":
//                gameImg.image = #imageLiteral(resourceName: "game-battle-sexes")
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
        setStrategyActionSheet(for: rowPlayer, with: rowStrategyBtn)
    }
    
    @IBAction func colPlayerStrategyBtn(_ sender: Any) {
        setStrategyActionSheet(for: colPlayer, with: colStrategyBtn)
    }
    
    private func setStrategyActionSheet(for player: Player, with btn: UIButton) {
        
        let actionSheetTitle = "Select Strategy"

//        if player.id == 0 {
//            actionSheetTitle = "Select Strategy for Row Player"
//        } else if player.id == 1 {
//            actionSheetTitle = "Select Strategy for Column Player"
//        }

        let actionSheet = UIAlertController(title: actionSheetTitle, message: nil, preferredStyle: .actionSheet)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

//        let TitForTat = UIAlertAction(title: "Tit for Tat", style: .default) { action in
//            self.setPlayerStrategy(for: player, with: "titForTat")
//            btn.setTitle("Tit for Tat", for: .normal)
//        }
//
//        let fictitiousPlay = UIAlertAction(title: "Fictitious Play", style: .default) { action in
//            self.setPlayerStrategy(for: player, with: "fictitiousPlay")
//            btn.setTitle("Fictitious Play", for: .normal)
//        }
//
//        let bully = UIAlertAction(title: "Bully", style: .default) { action in
//            self.setPlayerStrategy(for: player, with: "Bully")
//            btn.setTitle("Bully", for: .normal)
//        }
//
//        let WoLF = UIAlertAction(title: "WoLF", style: .default) { action in
//            self.setPlayerStrategy(for: player, with: "WoLF")
//            btn.setTitle("WoLF", for: .normal)
//        }
//
//        let random = UIAlertAction(title: "Random", style: .default) { action in
//			player = Random()
//            self.setPlayerStrategy(for: player, with: "Random")
//            btn.setTitle("Random", for: .normal)
//        }
//
//        actionSheet.addAction(TitForTat)
//        actionSheet.addAction(fictitiousPlay)
//        actionSheet.addAction(bully)
//        actionSheet.addAction(WoLF)
//        actionSheet.addAction(random)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true, completion: nil)
    }
    
//    func setPlayerStrategy(for player: Player, with strategy: String) {
//        player.chosenAlgo = strategy
//        self.resetGame()
//        self.updateUI()
//    }
	
    //Run Game Logic ============================================================
    
    public func runGame() {
		game.start(numRounds: numberOfRounds, player1: rowPlayer, player2: colPlayer)
        
//        for _ in stride(from: 0, to: numberOfRounds, by: 1) {
//
//            let playerOneAction = rowPlayer.performAction(given: game.matrixPayoffs)
//            let playerTwoAction = colPlayer.performAction(given: game.matrixPayoffs)
//
//            givePlayersRememberance(with: playerOneAction, and: playerTwoAction)
//
//            let scoresInRound = calculateTotalScores(with: playerOneAction, and: playerTwoAction)
//
//            updateScores(with: scoresInRound)
//
////            if fast == false {
////                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
////                    self.updateUI()
////                }
////            } else {
////                updateUI()
////            }
//
//            updateUI()
//        }
    }
    
//    private func givePlayersRememberance(with rowPlayerAction: Action, and colPlayerAction: Action ) {
//
//        rowPlayer.myActionMemory.append(rowPlayerAction)
//        rowPlayer.opponentActionMemory.append(colPlayerAction)
//
//        colPlayer.myActionMemory.append(colPlayerAction)
//        colPlayer.opponentActionMemory.append(rowPlayerAction)
//
//        if rowPlayer.chosenAlgo == "WoLF" {
//            rowPlayer.WoLFClass.myActionMemory = rowPlayer.myActionMemory
//            rowPlayer.WoLFClass.opponentActionMemory = rowPlayer.opponentActionMemory
//            rowPlayer.WoLFClass.observe()
//        }
//
//        if colPlayer.chosenAlgo == "WoLF" {
//            colPlayer.WoLFClass.myActionMemory = colPlayer.myActionMemory
//            colPlayer.WoLFClass.opponentActionMemory = colPlayer.opponentActionMemory
//            colPlayer.WoLFClass.observe()
//        }
//
//        print("rowPlayerAction: ", rowPlayerAction.a)
//        print("colPlayerAction: ", colPlayerAction.a, "\n")
//
//    }
	
//    private func updateScores(with scores: (Int, Int)) {
//
//        rowPlayer.totalScore += scores.0
//        rowPlayer.averageScore = Double(rowPlayer.totalScore) / Double(totalRounds)
//
//        colPlayer.totalScore += scores.1
//        colPlayer.averageScore = Double(colPlayer.totalScore) / Double(totalRounds)
//    }
	
//    func calculateTotalScores(with playerAction1: Action, and playerAction2: Action) -> (Int, Int) {
//
//        let playerOneScore = game.matrixPayoffs[playerAction1.a][playerAction2.a].0
//        let playerTwoScore = game.matrixPayoffs[playerAction1.a][playerAction2.a].1
//
//        return (playerOneScore, playerTwoScore)
//    }
	
    //Update UI ============================================================
    
    func updateUI() {
		title = game.name
		gameImg.image = game.image
		
        rowPlayerTotalScore.text = "TOTAL: \(rowPlayer.score)"
        colPlayerTotalScore.text = "TOTAL: \(colPlayer.score)"
    
//        rowPlayerAvgScore.text = String(format: "%.3f", rowPlayer.averageScore)
//        colPlayerAvgScore.text = String(format: "%.3f", colPlayer.averageScore)
    }
    
    func resetGame() {
//        rowPlayer.resetPlayer()
//        colPlayer.resetPlayer()
		
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
