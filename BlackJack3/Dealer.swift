//
//  Dealer.swift
//  Blackjack
//
//  Created by Jaclyn May on 9/15/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import Foundation

/**
*  Represents a Dealer
*/
class Dealer:Player{
 
    /// The face down card
    var holeCard:Card? = nil
    var faceUpCard:Card? = nil
    init(){
        
    }
    
    /**
    Adds a card to the dealer's hand
    
    :param: card card
    */
    func addCard(card:Card){
        // The first card in the dealers hand is the holeCard, whose value is hidden
        if hand.isEmpty{
            holeCard = card
        }else{
            if hand.count == 1{
                faceUpCard = card
            }
            // Evaluate ace cards
            if(card.isAce()){
                aces++
            }
            hand.append(card)
            totaledHand+=card.value
            // If previous ace was set to 11 and should be reset to 1
            if totaledHand > 21 && aces>=1 && aces >= subtractAces{
                var index:Int?
                for i in 0..<len(hand){
                    if hand[i].value==11{
                        index = i
                        break
                    }
                }

                if index!=nil{
                    hand[index].makeSmallAce()
                    totaledHand-=10
                    subtractAces++
                }
            }
        }
    }
    
    
    func calculateHoleCard(){
        if holeCard != nil{
            if(holeCard!.isAce()){
                if totaledHand >= 11 {
                    holeCard!.makeSmallAce()
                }
                else {
                    holeCard!.makeBigAce()
                }
            }
        }
    }

    func hasBlackjack()->Bool{
        if holeCard != nil{
            calculateHoleCard()
            if totaledHand+holeCard!.value == 21{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func revealHoleCard() -> Card?{
        if holeCard != nil{
            calculateHoleCard()
            totaledHand+=holeCard!.value
            return holeCard!
        }else{
            return holeCard
        }
    }
    
    func clear(){
        holeCard = nil
        hand=[]
        totaledHand=0
    }
    
}
