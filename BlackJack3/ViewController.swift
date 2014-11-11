//
//  ViewController.swift
//  Blckjack
//
//  Created by Jaclyn May on 9/9/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bj:BlackjackModel!
    var playerLabels:[UILabel] = []
    var playerBets: [UITextField] = []
    var playerFunds: [UITextField] = []
    var playerCardsImageViews =  [UIImageView]()
    var aiCardsImageViews = [UIImageView]()
    var dealerCardsImageViews = [UIImageView]()
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)
        
    }
  
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
        var playerd: Player = bj.players[0]
        var ai: Player = bj.players[1]
        playerBet.text = String(playerd.playerBet.description)
        playerFund.text = String(playerd.funds.description)
        AIBet.text = String(ai.playerBet.description)
        AIFunds.text = String(ai.funds.description)
        gameOverField.text = gameOverField.text + playerd.gameOverMess + ai.gameOverMess + bj.dealer.gameOverMess
//        self.getPlayerCardImages(playerd)
//        self.getPlayerCardImages(ai)
//        self.getPlayerCardImages(bj.dealer)
        if (activePlayerIndex < bj.players.count) && (playerd.gameover){
            stay()
        }
        else if bj.dealer.gameover{
            gameOver()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bj.deal()
        var i = 0
        hitButton.hidden = false
        stayButton.hidden = false
        
        
        var playerHand = bj.players[0].hand
        var aiHand = bj.players[1].hand
        var dealerHand = bj.dealer.hand
        var cardHeight = CGFloat(150)
        var cardWidth = CGFloat(105)
        var cardPlayerY = self.playerCardView.frame.minY
        var cardAiY = self.aiCardView.frame.minY
        var cardDealerY = self.dealerCardView.frame.minY
        var cardPlayerX:CGFloat!
        var cardAiX:CGFloat!
        var cardDealerX:CGFloat!
        var dealerCardName:String!
        while i < 2{
            if i == 0{
                cardPlayerX = self.playerCardView.frame.minX
                cardAiX = self.aiCardView.frame.minX
                cardDealerX = self.dealerCardView.frame.minX
                dealerCardName = "card-back"
            }
            else if i == 1{
                cardPlayerX = self.playerCardsImageViews.last!.center.x
                cardAiX = self.aiCardsImageViews.last!.center.x
                cardDealerX = self.dealerCardsImageViews.last!.center.x
                var addDealerCard = dealerHand[i]
                dealerCardName = "\(addDealerCard.name)_of_\(addDealerCard.suit)"
            }
            var addPlayerCard = playerHand[i]
            var addAiCard = aiHand[i]
            var playerCardname = "\(addPlayerCard.name)_of_\(addPlayerCard.suit)"
            var aiCardname = "\(addAiCard.name)_of_\(addAiCard.suit)"
            var playercardView = UIImageView(frame: CGRectMake(cardPlayerX,cardPlayerY, cardWidth,cardHeight))
            var aicardView = UIImageView(frame: CGRectMake(cardAiX,cardAiY, cardWidth,cardHeight))
            var dealercardView = UIImageView(frame: CGRectMake(cardDealerX,cardDealerY, cardWidth,cardHeight))
            playercardView.image = UIImage(named:playerCardname)
            aicardView.image = UIImage(named:aiCardname)
            dealercardView.image = UIImage(named:dealerCardName)
            playercardView.contentMode = UIViewContentMode.ScaleToFill
            aicardView.contentMode = UIViewContentMode.ScaleToFill
            dealerCardView.contentMode = UIViewContentMode.ScaleToFill
            self.playerCardsImageViews.append(playercardView)
            self.aiCardsImageViews.append(aicardView)
            self.dealerCardsImageViews.append(dealercardView)
            view.addSubview(playercardView)
            view.addSubview(aicardView)
            view.addSubview(dealercardView)
            i++
        }

    
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    @IBAction func newGame(sender:AnyObject){
//        if validate_bets_and_deck_num(){
//            deckCountStepper.hidden = true
//            deckCountTextField.enabled = false
//            bj.newGame(deckNum: deckCountTextField.text.toInt()!)
//            var p1funds = bj.players[0].funds
//            var aifund = bj.players[1].funds
//            playerFund.text = NSString(format:"%.2f",p1funds)
//            playerFund.userInteractionEnabled = false
//            AIFunds.text = NSString(format:"%.2f",aifund)
//            AIFunds.userInteractionEnabled = false
//            //playersFunds = [playerFund,AIFunds]
//            //playersBets = [playerBet, AIBet]
//            bj.play()
//            placeBetButton.hidden = true
//            hitButton.hidden = false
//            stayButton.hidden = false
//            //dealerLabel.hidden = false
//            dealerCardView.hidden = false
//            activePlayerIndex = 0
//            playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
//            bj.deal()
//            gameOverField.text = ""
//        }
//        refreshUI()
//    }

    
//    @IBAction func deal(sender: UIButton) {
//        bj.deal()
//        dealButton.hidden = true
//        hitButton.hidden = false
//        stayButton.hidden = false
//        refreshUI()
//    }
    
    // Only applies to player
    @IBAction func hit(sender:AnyObject){
        if activePlayerIndex < bj.players.count{
            bj.playerHit(bj.players[0])
            var numCards = self.playerCardsImageViews.count
            var cardX = playerCardsImageViews.last!.center.x
            var cardY = playerCardView.frame.minY
            var addCard = bj.players[0].hand.last
            var name = "\(addCard!.name)_of_\(addCard!.suit)"
            var cardHeight = CGFloat(150)
            var cardWidth = CGFloat(105)
            var cardView = UIImageView(frame: CGRectMake(cardX,cardY, cardWidth,cardHeight))
            cardView.image = UIImage(named:name)
            cardView.contentMode = UIViewContentMode.ScaleAspectFill
            playerCardsImageViews.append(cardView)
            view.addSubview(cardView)
        }
        //refreshUI()
    }
    
    
    // Always call stay when a players turn is over or if a player lost or gets bj. This function calls the next players turn.
    func stay(){
        //playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 1.0, green: 1.0, blue:1.0, alpha: 1.0)
        ++activePlayerIndex
        //Generate AI turn
        if activePlayerIndex == 1{
            hitButton.hidden = true
            stayButton.hidden = true
            bj.generateAITurn()
            refreshUI()
        }
        //dealerTurn
        else if activePlayerIndex >= bj.players.count{
            bj.dealerTurn()
            refreshUI()
        }
            //playerLabels[activePlayerIndex].backgroundColor = UIColor( red: 0.0, green: 0.0, blue:1.0, alpha: 1.0 )
        
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
        var cardHeight = CGFloat(150)
        var cardWidth = CGFloat(105)
        var cardX:CGFloat
        var cardY:CGFloat
        var addCard:Card
        var name:String
        
        cardY = playerContainerView.frame.minY
        var cardView:UIImageView
        while imageViewArray.count < playerHand.count{
            if imageViewArray.isEmpty{
                cardX = playerContainerView.frame.minX
                if player.player_name == "Dealer" && playerHand.count == 2 && !bj.dealer.gameover{
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
        placeBetButton.setTitle("Play Again", forState: UIControlState.Normal)

        placeBetButton.hidden = false
        ResetButton.hidden = false
        for (index,player) in enumerate(bj.players){
            playerBets[index].userInteractionEnabled=true
        }
        
        
    }

//    @IBAction func resetGame(sender: AnyObject) {
//        placeBetButton.hidden = true
//        bj = bjModel()
//
//        deckCountStepper.hidden = false
//        deckCountTextField.enabled = true
//        ResetButton.hidden = true
//        placeBetButton.setTitle("Place Bet", forState: UIControlState.Normal)
//        var activePlayerIndex = 0
//        
//    }
}



