//
//  ViewController.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/20/19.
//  Copyright © 2019 IS543. All rights reserved.


import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

	private var rowPlayer: Player! {
		didSet {
			rowStrategyBtn.setTitle(rowPlayer.title, for: .normal)
		}
	}
	private var colPlayer: Player! {
		didSet {
			colStrategyBtn.setTitle(colPlayer.title, for: .normal)
		}
	}
    
	private var game: Game = PrisonersDilemma() {
        didSet {
			rowPlayer.reset()
			colPlayer.reset()
            updateUI()
        }
    }
    
    var fast = true
    
    var numberOfRounds = 1000
    var totalRounds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		rowPlayer = Random()
		colPlayer = Random()
    }
	
	//TextFieldDelegate ===================================
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
    //Nav bar ============================================================
 
    @IBAction func resetBtn(_ sender: Any) {
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
        
        if let text = numRoundsTextField.text, let num = Int(text) {
            numberOfRounds = num
        }
        
        totalRounds += numberOfRounds
        
        runGame()
    }
    
    //Player Info ============================================================
    
    @IBOutlet weak var rowPlayerAvgScore: UILabel!
    @IBOutlet weak var colPlayerAvgScore: UILabel!
    
    @IBOutlet weak var rowPlayerTotalScore: UILabel!
    @IBOutlet weak var colPlayerTotalScore: UILabel!
    
    @IBOutlet weak var rowPlayerLabel: UILabel!
    
    //Strategy btn outlets
	@IBOutlet weak var rowStrategyBtn: UIButton!
    @IBOutlet weak var colStrategyBtn: UIButton!
    
    //Strategy btn actions
    @IBAction func rowPlayerStrategyBtn(_ sender: UIButton) {
		selectStrategy { player in
			self.rowPlayer = player
			sender.setTitle(player.title, for: .normal)
		}
    }
    
    @IBAction func colPlayerStrategyBtn(_ sender: UIButton) {
		selectStrategy { player in
			self.colPlayer = player
			sender.setTitle(player.title, for: .normal)
		}
    }
	
	private func selectStrategy(callback: @escaping (Player) -> Void) {
		let actionSheet = UIAlertController(title: "Select Strategy for Row Player", message: nil, preferredStyle: .actionSheet)
		
		Player.choices.forEach { player in
			actionSheet.addAction(UIAlertAction(title: player.title, style: .default, handler: { (_) in
				callback(player)
			}))
		}
		
		actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(actionSheet, animated: true)
	}
	
    //Run Game Logic ============================================================
    
    public func runGame() {
		game.play(numRounds: numberOfRounds, player1: rowPlayer, player2: colPlayer) {
			updateUI()
		}
		updateUI()
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
	
    //Update UI ============================================================
	
    private func updateUI() {
		title = game.name
		gameImg.image = game.image
		
        rowPlayerTotalScore.text = "TOTAL: \(rowPlayer.score)"
        colPlayerTotalScore.text = "TOTAL: \(colPlayer.score)"
		
		rowPlayerAvgScore.text = String(format: "%.3f", Double(rowPlayer.score) / Double(numberOfRounds))
        colPlayerAvgScore.text = String(format: "%.3f", Double(colPlayer.score) / Double(numberOfRounds))
    }
}
