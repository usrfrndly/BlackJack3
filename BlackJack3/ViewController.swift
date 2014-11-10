//
//  ViewController.swift
//  Blckjack
//
//  Created by Jaclyn May on 9/9/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var blackJack = BlackjackModel()
    var playerLabels:[UILabel] = []
    var playerBets: [UITextField] = []
    var playerFunds: [UITextField] = []
    var playerHands:[UITextField] = []
    var playerCardsImageViews:[UIImageView] = []
    var playerResults:[UITextField] = []
    var dealerHand:UITextField!
    var activePlayerIndex = 0
    var tableData = ["Player1", "AI", "Dealer"]
    
    @IBOutlet weak var playerCardView: UIView!
    
    @IBOutlet weak var aiCardView: UIView!
    @IBOutlet weak var dealerCardView: UIView!
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet var gameOverField : UITextView!
    @IBOutlet var deckCountTextField: UITextField!
    @IBOutlet weak var deckCountStepper: UIStepper!

    @IBOutlet weak var AIFunds: UITextField!
    
    
    @IBOutlet weak var playerBet: UITextField!
    @IBOutlet weak var playerFund: UITextField!
    
    @IBOutlet weak var AIBet: UITextField!
    @IBAction func deckStepper(sender: UIStepper) {
        deckCountTextField.text = String(Int(sender.value))
    }
    
    func refreshUI(){
        playerFund.text = String(blackJack.players[0].funds.description)
        
        playerResults[0].text = String(blackJack.players[0].gameOverMess)
        AIFunds.text = String(blackJack.players[1].funds.description)
        
        playerResults[1].text = String(blackJack.players[1].gameOverMess)
        
        if blackJack.dealer.hand.count == 2 && activePlayerIndex < blackJack.players.count{
            dealerHand.text = "[HoleCard, \(blackJack.dealer.hand[1].description) ]"
        }
        else{
            dealerHand.text = blackJack.dealer.hand.description
        }
        if activePlayerIndex < blackJack.players.count && !blackJack.players[activePlayerIndex].gameOverMess.isEmpty{
            stay()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


func validate_bets_and_deck_num() -> Bool{
    for (index,betTextField) in enumerate(playerBets){
        var betAmount = NSString(string: betTextField.text).doubleValue
        
        // If bet > 1  and less than playerTotal, sets player bet
        if !blackJack.players[index].bet(betAmount){
            gameOverField.text = "Your bet must be at least $1 and not exceed your funds"
            return false
        }

        else{
            betTextField.userInteractionEnabled = false
        }
    }
    var deckCount = deckCountTextField.text.toInt()!
    if deckCount < 1{
        gameOverField.text = "You must select at least one deck"
        return false
    }
    return true
}

@IBAction func newGame(sender:AnyObject){
    if validate_bets_and_deck_num(){
        deckCountStepper.hidden = true
        deckCountTextField.enabled = false
        blackJack.newGame(deckNum: deckCountTextField.text.toInt()!)
        var p1funds = blackJack.players[0].funds
        var aifund = blackJack.players[1].funds
        playerFund.text = NSString(format:"%.2f",p1funds)
        playerFund.userInteractionEnabled = false
        AIFunds.text = NSString(format:"%.2f",aifund)
        AIFunds.userInteractionEnabled = false
        //playersFunds = [playerFund,AIFunds]
        //playersBets = [playerBet, AIBet]
        blackJack.play()
        placeBetButton.hidden = true
        hitButton.hidden = false
        stayButton.hidden = false
        //dealerLabel.hidden = false
        dealerHand.hidden = false
        activePlayerIndex = 0
        playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
        blackJack.deal()
        gameOverField.text = ""
    }
    refreshUI()
}



@IBAction func hit(sender:AnyObject){
    if activePlayerIndex < blackJack.players.count{
        blackJack.playerHit(blackJack.players[activePlayerIndex])
    }
    refreshUI()
}

func stay(){
    playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 1.0, green: 1.0, blue:1.0, alpha: 1.0)
    activePlayerIndex++
    if activePlayerIndex == 1{
        blackJack.generateAITurn()
    }
    else if activePlayerIndex >= blackJack.players.count{
        blackJack.dealerTurn()
        refreshUI()
        gameOver()
    }else{
        refreshUI()
        playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
    }
}
@IBAction func stay(sender:AnyObject){
    stay()
}

    func getPlayerCardImages(hand:[Card]){
    var playerHand = hand
    var cardHeight = CGFloat(50)
    var cardWidth = CGFloat(50)
    var cardX:CGFloat
    var cardY:CGFloat
    var addCard:Card
    cardY = playerCardView.frame.minY
    var cardView:UIImageView
    while self.playerCardsImageViews.count < playerHand.count{
        if playerCardsImageViews.isEmpty{
            cardX = playerCardView.frame.minX
            addCard = playerHand[0]
        }
        else{
            cardX = playerCardsImageViews.last!.frame.maxX
            addCard = playerHand[playerCardsImageViews.count]
        }
        cardView = UIImageView(frame: CGRectMake(cardX,cardY, cardWidth,cardHeight))
        var name = "\(addCard.name)_of_\(addCard.suit)"
        cardView.image = UIImage(named:name)
        cardView.contentMode = UIViewContentMode.ScaleAspectFit
        playerCardsImageViews.append(cardView)
        self.playerCardView.addSubview(cardView)
    }
}


func gameOver(){
    activePlayerIndex=0
    dealerHand.text = String(blackJack.dealer.hand.description)
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

@IBAction func resetGame(sender: AnyObject) {
    placeBetButton.hidden = true
    blackJack = BlackjackModel()

    deckCountStepper.hidden = false
    deckCountTextField.enabled = true
    ResetButton.hidden = true
    placeBetButton.setTitle("Place Bet", forState: UIControlState.Normal)
    var activePlayerIndex = 0
    
}
}



