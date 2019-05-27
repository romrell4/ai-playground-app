//
//  ViewController.swift
//  CS 601R
//
//  Created by Gavin Jensen on 2/20/19.
//  Copyright © 2019 IS543. All rights reserved.


import UIKit

private let SLOW_PLAY_DELAY = 0.25

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Mark: - Properties
    
	private var rowPlayer: Player! {
		didSet {
            rowStrategyBtn.setTitle("Strategy: \(rowPlayer.title)", for: .normal)
		}
	}
	private var colPlayer: Player! {
		didSet {
			colStrategyBtn.setTitle("Strategy: \(colPlayer.title)", for: .normal)
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
        
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
		
    //Nav bar ============================================================
 
    
	@IBAction func resetGame(_ sender: Any? = nil) {
		rowPlayer.reset()
		colPlayer.reset()
		game.gameTimer?.invalidate()
		
		//Update the game's states
		for (state, (rowTitle, colTitle)) in zip(game.states, zip(rowStateTitles, colStateTitles)) {
			rowTitle.text = state.uppercased()
			colTitle.text = state.uppercased()
		}
		
		//Update the reward values
		topLeftRowScoreLabel.text = "\(game.rewards[0][0][0])"
		topLeftColScoreLabel.text = "\(game.rewards[0][0][1])"
		topRightRowScoreLabel.text = "\(game.rewards[0][1][0])"
		topRightColScoreLabel.text = "\(game.rewards[0][1][1])"
		bottomLeftRowScoreLabel.text = "\(game.rewards[1][0][0])"
		bottomLeftColScoreLabel.text = "\(game.rewards[1][0][1])"
		bottomRightRowScoreLabel.text = "\(game.rewards[1][1][0])"
		bottomRightColScoreLabel.text = "\(game.rewards[1][1][1])"
		
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
    
    //Game Info ============================================================
    
    @IBOutlet private weak var fullGameBox: UIView! {
        didSet {
            fullGameBox.layer.borderWidth = 1
            fullGameBox.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            fullGameBox.layer.cornerRadius = 16
            fullGameBox.backgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
	@IBOutlet private weak var gameGridView: UIView! {
		didSet {
			gameGridView.layer.borderWidth = 1
			gameGridView.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
			gameGridView.layer.cornerRadius = 8
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
    
    @IBOutlet weak var topLeftNashLabel: UILabel!
    @IBOutlet weak var topRightNashLabel: UILabel!
    @IBOutlet weak var bottomLeftNashLabel: UILabel!
    @IBOutlet weak var bottomRightNashLabel: UILabel!
    
    @IBOutlet var nashLabels: [UILabel]!
    
    //Bottom Bib ============================================================
    
    @IBOutlet weak var roundsBtn: UIButton!
    
    @IBAction func roundsBtn(_ sender: Any) {
        selectRounds()
    }
    
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
		
		//Default
        
		game.play(numRounds: numberOfRounds, player1: rowPlayer, player2: colPlayer, delay: fast ? 0 : SLOW_PLAY_DELAY) {
			self.updateUI(round: $0)
		}
    }
    
    private func selectRounds() {
        let actionSheet = UIAlertController(title: "Select Rounds", message: nil, preferredStyle: .actionSheet)
        
        let ten = UIAlertAction(title: "10", style: .default) { action in
            self.changeRounds(to: 10)
        }
        
        let hundred = UIAlertAction(title: "100", style: .default) { action in
            self.changeRounds(to: 100)
        }
        
        let thousand = UIAlertAction(title: "1,000", style: .default) { action in
            self.changeRounds(to: 1000)
        }
        
        let tenThousand = UIAlertAction(title: "10,000", style: .default) { action in
            self.changeRounds(to: 10000)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(ten)
        actionSheet.addAction(hundred)
        actionSheet.addAction(thousand)
        actionSheet.addAction(tenThousand)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    private func changeRounds(to number: Int) {
        numberOfRounds = number
        roundsBtn.titleLabel?.text = "Rounds: \(number)"
        
    }
    
    //Player Info ============================================================
    
    @IBOutlet private weak var rowPlayerAvgScore: UILabel!
    @IBOutlet private weak var colPlayerAvgScore: UILabel!
    
    @IBOutlet private weak var rowPlayerTotalScore: UILabel!
    @IBOutlet private weak var colPlayerTotalScore: UILabel!
    
    //Strategy btn outlets
    @IBOutlet private weak var rowStrategyBtn: UIButton!
    
    @IBOutlet private weak var colStrategyBtn: UIButton!
    
    //Strategy btn actions
    @IBAction func rowPlayerStrategyBtn(_ sender: UIButton) {
		selectStrategy { player in
			self.rowPlayer = player
			sender.setTitle("Strategy: \(player.title)", for: .normal)
		}
    }
    
    @IBAction func colPlayerStrategyBtn(_ sender: UIButton) {
		selectStrategy { player in
			self.colPlayer = player
			sender.setTitle("Strategy: \(player.title)", for: .normal)
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
    
    @IBOutlet weak var viewRowPlayer: UIView! {
        didSet {
            viewRowPlayer.layer.borderWidth = 1
            viewRowPlayer.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            viewRowPlayer.layer.cornerRadius = 16
            viewRowPlayer.backgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    @IBOutlet weak var viewColPlayer: UIView! {
        didSet {
            viewColPlayer.layer.borderWidth = 1
            viewColPlayer.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
            viewColPlayer.layer.cornerRadius = 16
            viewColPlayer.backgroundColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    //Update UI ============================================================
	
	private func updateUI(round: Int = 0) {
		title = game.name
		
        rowPlayerTotalScore.text = "TOTAL: \(rowPlayer.score)"
        colPlayerTotalScore.text = "TOTAL: \(colPlayer.score)"
		
		rowPlayerAvgScore.text = String(format: "%.3f", round == 0 ? 0 : Double(rowPlayer.score) / Double(round))
		colPlayerAvgScore.text = String(format: "%.3f", round == 0 ? 0 : Double(colPlayer.score) / Double(round))
        
        for n in game.nashEquilibrium.indices {
            if game.nashEquilibrium[n] {
                nashLabels[n].text = "NASH E."
            } else {
                nashLabels[n].text = " "
            }
        }
    }
}
