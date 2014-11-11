//
//  Player.swift
//  Blackjack
//
//  Created by Jaclyn May on 9/15/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import Foundation

/**
*  Class representing the Blackjack player
*/
class Player{
    /// Player money
    var funds:Double
    
    /// The player's bet this round
    var playerBet:Double
    
    /// An array of card objects
    var hand:[Card]
    /// Sum of the value of the cards in player's han
    var totaledHand:Int
    var aces:Int
    var subtractAces:Int
    var player_name:String { get { return "Player" } } 
    
    //var lost:Bool
    var gameOverMess:String
    
    init(){
        self.hand=[]
        self.totaledHand = 0
        self.aces = 0
        self.subtractAces = 0
        self.funds = 100.00
        self.playerBet=1.0
        //self.lost=false
        self.gameOverMess=""
    }
    
    /**
    Adds a new card to the player's hand
    :param: card Card
    */
    func addCard(card:Card){
        // Determine value of ace
        if(card.isAce()){
            aces++
//            if totaledHand >= 11 {
//                card.makeSmallAce()
//            }
//            else {
//                card.makeBigAce()
//            }
        }
        hand.append(card)
        totaledHand+=card.value
        // If previous ace was set to 11 and should be reset to 1
        if totaledHand > 21 && aces>=1 && aces >= subtractAces{
            var index:Int?
            for i in 0..<hand.count{
                if hand[i].value==11{
                    index = i
                    break
                }
            }
            if index != nil{
                hand[index!].makeSmallAce()
                totaledHand-=10
                subtractAces++
            }
        }
    }
    
    
    func hasBlackjack() -> Bool{
        if totaledHand == 21{
            return true
        }else{
            return false
        }
    }
    
    func bet(amount:Double) -> Bool{
        if amount > funds ||  amount < 1.0{
            return false
        }
        else{
            playerBet=amount
            return true
        }
        
    }

    func isHardHand() -> Bool{
        for card in hand{
            if card.isAce() && card.value == 11{
                return false
            }
        }
        return true
    }
    
    
    /**
    Resets player hand, card total, and bet for a new round
    */
    func clear(){
        //lost=false
        gameOverMess=""
        hand=[]
        totaledHand=0
        //playerBet=0
    }
    
    
    
}