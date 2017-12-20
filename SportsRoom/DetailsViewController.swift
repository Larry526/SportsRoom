//
//  DetailsViewController.swift
//  SportsRoom
//
//  Created by Javier Xing on 2017-12-15.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    var currentGame: Game!
    
    enum ButtonState: String {
        case joined = "Leave Game"
        case hosted = "Cancel Game"
        case search = "Join Game"
    }
    
    @IBOutlet weak var gameActionBtn: UIButton!
    
    var btnText : ButtonState? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonState(buttonState: btnText!)
        setLabels()
    }
    
    func setLabels(){
        gameTitleLabel.text = currentGame.title
        sportLabel.text = currentGame.sport
        dateLabel.text = currentGame.date
        locationLabel.text = currentGame.address
        skillLabel.text = currentGame.skillLevel
        costLabel.text = currentGame.cost
        notesLabel.text = currentGame.notes
    }
    
    func setButtonState(buttonState : ButtonState) {
        switch buttonState {
        case .joined:
            gameActionBtn.setTitle(ButtonState.joined.rawValue, for: UIControlState.normal)
            gameActionBtn.backgroundColor = UIColor.red
        case .hosted:
            gameActionBtn.setTitle(ButtonState.hosted.rawValue, for: UIControlState.normal)
            gameActionBtn.backgroundColor = UIColor.red
        case .search:
            gameActionBtn.setTitle(ButtonState.search.rawValue, for: UIControlState.normal)
            gameActionBtn.backgroundColor = UIColor.green
        }
    }
    
    //    Mark: - DataSource Properties
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.textLabel?.text = "Player One"
        return cell
    }
    
    
    @IBAction func gameActionPressed(_ sender: UIButton) {
        if btnText == DetailsViewController.ButtonState(rawValue: "Leave Game") {
            leaveGame()
        }
        if btnText == DetailsViewController.ButtonState(rawValue: "Cancel Game") {
            cancelGame()
        }
        if btnText == DetailsViewController.ButtonState(rawValue: "Join Game") {
            joinGame()
        }
    }
    
    func joinGame () {
      let userID = Auth.auth().currentUser?.uid
      let gameKey = currentGame.gameID
        let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames")
        let joinedGamesKey = gameKey
        refUser.updateChildValues([joinedGamesKey:"true"])
    }
    
    func leaveGame () {
    let userID = Auth.auth().currentUser?.uid
    let gameKey = currentGame.gameID
    let refUser = Database.database().reference().child("users").child(userID!).child("joinedGames").child(gameKey)
        refUser.removeValue()
    }
    
    func cancelGame () {
    let userID = Auth.auth().currentUser?.uid
    let gameKey = currentGame.gameID
    let refGame = Database.database().reference().child("games").child(gameKey)
    refGame.removeValue()

    let refUserHosted = Database.database().reference().child("users").child(userID!).child("hostedGames").child(gameKey)
    refUserHosted.removeValue()
        
//    let refUserJoined = Database.database().reference().child("users").child(userID!).child("joinedGames").child(gameKey)
//        refUserJoined.removeValue()
    }
}
