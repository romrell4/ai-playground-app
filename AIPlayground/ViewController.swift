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
	private var game: Game! {
        didSet {
			resetGame()
        }
    }
	private var fast = true {
		didSet {
			speedButton.setTitle("Speed: \(fast ? "fast" : "slow")", for: .normal)
		}
	}
    private var numberOfRounds = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		rowPlayer = Random()
		colPlayer = Random()
		game = PrisonersDilemma()
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
		
		//Update the game's states
		for (state, (rowTitle, colTitle)) in zip(game.states, zip(rowStateTitles, colStateTitles)) {
			rowTitle.text = state.uppercased()
			colTitle.text = state.uppercased()
		}
		
		//Update the reward values
		topLeftRowScoreLabel.text = "\(game.rewards[0][0].0)"
		topLeftColScoreLabel.text = "\(game.rewards[0][0].1)"
		topRightRowScoreLabel.text = "\(game.rewards[0][1].0)"
		topRightColScoreLabel.text = "\(game.rewards[0][1].1)"
		bottomLeftRowScoreLabel.text = "\(game.rewards[1][0].0)"
		bottomLeftColScoreLabel.text = "\(game.rewards[1][0].1)"
		bottomRightRowScoreLabel.text = "\(game.rewards[1][1].0)"
		bottomRightColScoreLabel.text = "\(game.rewards[1][1].1)"
		
        updateUI()
    }
    
    @IBAction func changeGameTapped(_ sender: Any) {
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
    

	@IBOutlet weak var gameGridView: UIView! {
		didSet {
			gameGridView.layer.borderWidth = 1
			gameGridView.layer.borderColor = UIColor.gray.cgColor
			gameGridView.layer.cornerRadius = 4
		}
	}
	@IBOutlet private var rowStateTitles: [UILabel]!
	@IBOutlet private var colStateTitles: [UILabel]!
	@IBOutlet private weak var topLeftRowScoreLabel: UILabel!
	@IBOutlet private weak var topLeftColScoreLabel: UILabel!
	@IBOutlet private weak var topRightRowScoreLabel: UILabel!
	@IBOutlet private weak var topRightColScoreLabel: UILabel!
	@IBOutlet private weak var bottomLeftRowScoreLabel: UILabel!
	@IBOutlet private weak var bottomLeftColScoreLabel: UILabel!
	@IBOutlet private weak var bottomRightRowScoreLabel: UILabel!
	@IBOutlet private weak var bottomRightColScoreLabel: UILabel!
	
    //Bottom Bib ============================================================
    
    @IBOutlet weak var numRoundsTextField: UITextField!
    
    @IBAction func speedButtonTapped(_ sender: UIButton) {
		fast = !fast
    }
    
    @IBOutlet weak var speedButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.layer.cornerRadius = 4
        }
    }
    
    @IBAction func startTapped(_ sender: Any) {
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
		let actionSheet = UIAlertController(title: "Select Strategy", message: nil, preferredStyle: .actionSheet)
		
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
		
        rowPlayerTotalScore.text = "TOTAL: \(rowPlayer.score)"
        colPlayerTotalScore.text = "TOTAL: \(colPlayer.score)"
		
		rowPlayerAvgScore.text = String(format: "%.3f", Double(rowPlayer.score) / Double(numberOfRounds))
        colPlayerAvgScore.text = String(format: "%.3f", Double(colPlayer.score) / Double(numberOfRounds))
    }
}
