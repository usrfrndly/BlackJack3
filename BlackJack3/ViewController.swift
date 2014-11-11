//
//  ViewController.swift
//  Blckjack
//
//  Created by Jaclyn May on 9/9/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   // var blackJack = BlackjackModel()
    var bj: BlackjackModel!
    var blackJack: BlackjackModel!
    var playerLabels:[UILabel] = []
    var playerBets: [UITextField] = []
    var playerFunds: [UITextField] = []
    var playerCardsImageViews:[UIImageView] = []
    var aiCardsImageViews:[UIImageView] = []
    var dealerCardsImageViews:[UIImageView] = []

    @IBOutlet weak var dealButton: UIButton!
    var playerResults:[UITextField] = []
    var activePlayerIndex = 0
    var tableData = ["Player1", "AI", "Dealer"]
    
    // Cards View Containers
    @IBOutlet weak var playerCardView: UIView!
    @IBOutlet weak var aiCardView: UIView!
    @IBOutlet weak var dealerCardView: UIView!
    
    // TO DO: these dont do anything.
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet var gameOverField : UITextView!


    @IBOutlet weak var AIBet: UITextField!
    @IBOutlet weak var AIFunds: UITextField!
    
    
    @IBOutlet weak var playerBet: UITextField!
    @IBOutlet weak var playerFund: UITextField!
    
    
    func refreshUI(){
        playerBet.text = String(blackJack.players[0].playerBet.description)
        playerFund.text = String(blackJack.players[0].funds.description)
        gameOverField.text = String(blackJack.players[0].gameOverMess)
        AIBet.text = String(blackJack.players[1].playerBet.description)
        AIFunds.text = String(blackJack.players[1].funds.description)
        gameOverField.text = gameOverField.text + String(blackJack.players[1].gameOverMess) + String(blackJack.dealer.gameOverMess)
        self.getPlayerCardImages(blackJack.players[0])
        self.getPlayerCardImages(blackJack.players[1])
        self.getPlayerCardImages(blackJack.dealer)
       print(blackJack)
        if (activePlayerIndex < blackJack.players.count) && (blackJack.players[0].gameover || blackJack.players[1].gameover){
            stay()
        }
        else if blackJack.dealer.gameover{
            gameOver()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blackJack = bj
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    @IBAction func newGame(sender:AnyObject){
//        if validate_bets_and_deck_num(){
//            deckCountStepper.hidden = true
//            deckCountTextField.enabled = false
//            blackJack.newGame(deckNum: deckCountTextField.text.toInt()!)
//            var p1funds = blackJack.players[0].funds
//            var aifund = blackJack.players[1].funds
//            playerFund.text = NSString(format:"%.2f",p1funds)
//            playerFund.userInteractionEnabled = false
//            AIFunds.text = NSString(format:"%.2f",aifund)
//            AIFunds.userInteractionEnabled = false
//            //playersFunds = [playerFund,AIFunds]
//            //playersBets = [playerBet, AIBet]
//            blackJack.play()
//            placeBetButton.hidden = true
//            hitButton.hidden = false
//            stayButton.hidden = false
//            //dealerLabel.hidden = false
//            dealerCardView.hidden = false
//            activePlayerIndex = 0
//            playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
//            blackJack.deal()
//            gameOverField.text = ""
//        }
//        refreshUI()
//    }

    
    @IBAction func deal(sender: UIButton) {
        blackJack.deal()
        dealButton.hidden = true
        hitButton.hidden = false
        stayButton.hidden = false
        refreshUI()
    }
    
    // Only applies to player
    @IBAction func hit(sender:AnyObject){
        if activePlayerIndex < blackJack.players.count{
            blackJack.playerHit(blackJack.players[activePlayerIndex])
        }
        refreshUI()
    }
    
    
    // Always call stay when a players turn is over or if a player lost or gets bj. This function calls the next players turn.
    func stay(){
        //playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 1.0, green: 1.0, blue:1.0, alpha: 1.0)
        activePlayerIndex++
        //Generate AI turn
        if activePlayerIndex == 1{
            hitButton.hidden = true
            stayButton.hidden = true
            blackJack.generateAITurn()
            refreshUI()
        }
        //dealerTurn
        else if activePlayerIndex >= blackJack.players.count{
            blackJack.dealerTurn()
            refreshUI()
        }else{
            refreshUI()
            //playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
        }
    }
    @IBAction func stay(sender:AnyObject){
        stay()
    }

    func getPlayerCardImages(player: Player){
        var playerContainerView:UIView
        var imageViewArray:[UIImageView]
        switch player.player_name{
        case "Dealer":
            playerContainerView = self.dealerCardView
            imageViewArray = self.dealerCardsImageViews
        case "Player":
            playerContainerView = self.playerCardView
            imageViewArray = self.playerCardsImageViews
        case "AI":
            playerContainerView = self.aiCardView
            imageViewArray = self.aiCardsImageViews
        default:
            playerContainerView = self.aiCardView
            imageViewArray = self.aiCardsImageViews
            
        }
        var playerHand = player.hand
        var cardHeight = CGFloat(100)
        var cardWidth = CGFloat(100)
        var cardX:CGFloat
        var cardY:CGFloat
        var addCard:Card
        var name:String
        
        cardY = playerContainerView.frame.minY
        var cardView:UIImageView
        while imageViewArray.count < playerHand.count{
            if imageViewArray.isEmpty{
                cardX = playerContainerView.frame.minX
                if player.player_name == "Dealer" && playerHand.count == 2{
                    name = "card-back"
                }
                else{
                    addCard = playerHand[0]
                    name = "\(addCard.name)_of_\(addCard.suit)"
                }
            }
            else{
                cardX = imageViewArray.last!.frame.maxX
                addCard = playerHand[imageViewArray.count]
                name = "\(addCard.name)_of_\(addCard.suit)"
            }
            cardView = UIImageView(frame: CGRectMake(cardX,cardY, cardWidth,cardHeight))
            cardView.image = UIImage(named:name)
        
            cardView.contentMode = UIViewContentMode.ScaleAspectFill
            imageViewArray.append(cardView)
            view.addSubview(cardView)
        }
    }


    func gameOver(){
        activePlayerIndex=0
        gameOverField.text = blackJack.gameOverMessage
        placeBetButton.setTitle("Play Again", forState: UIControlState.Normal)
        hitButton.hidden = true
        stayButton.hidden = true
        placeBetButton.hidden = false
        ResetButton.hidden = false
        for (index,player) in enumerate(blackJack.players){
            playerBets[index].userInteractionEnabled=true
        }
        
        
    }

//    @IBAction func resetGame(sender: AnyObject) {
//        placeBetButton.hidden = true
//        blackJack = BlackjackModel()
//
//        deckCountStepper.hidden = false
//        deckCountTextField.enabled = true
//        ResetButton.hidden = true
//        placeBetButton.setTitle("Place Bet", forState: UIControlState.Normal)
//        var activePlayerIndex = 0
//        
//    }
}



