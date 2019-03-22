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
			resetGame()
        }
    }
    private var fast = true
    private var numberOfRounds = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		rowPlayer = Random()
		colPlayer = Random()
		updateUI()
    }
	
	//TextFieldDelegate ===================================
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
    //Nav bar ============================================================
 
	@IBAction func resetGame(_ sender: Any? = nil) {
		rowPlayer.reset()
		colPlayer.reset()
        updateUI()
    }
    
    @IBAction func changeGameBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Matrix Game", message: nil, preferredStyle: .actionSheet)
		Game.choices.forEach { game in
			actionSheet.addAction(UIAlertAction(title: game.name, style: .default) { (_) in
				self.game = game
			})
		}
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
        present(actionSheet, animated: true)
    }
    
    //Image ============================================================
    
    @IBOutlet weak var gameImg: UIImageView!
    
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
        
		game.play(numRounds: numberOfRounds, player1: rowPlayer, player2: colPlayer) {
			updateUI()
		}
		updateUI()
    }
    
    //Player Info ============================================================
    
    @IBOutlet weak var rowPlayerAvgScore: UILabel!
    @IBOutlet weak var colPlayerAvgScore: UILabel!
    
    @IBOutlet weak var rowPlayerTotalScore: UILabel!
    @IBOutlet weak var colPlayerTotalScore: UILabel!
    
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
