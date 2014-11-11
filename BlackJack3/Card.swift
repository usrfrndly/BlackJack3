//
//  Card.swift
//  Blackjack
//
//  Created by Jaclyn May on 9/15/14.
//  Copyright (c) 2014 iOSProgramming. All rights reserved.
//

import Foundation

/**
*  Class representing a card in the deck
*/
class Card:NSObject{
    /// String representation of the card
    var name:String
    /// Numeric value of the card
    var value:Int
    var suit:String

    /// Dictionary mapping face cards' initial value to their string equivalent
    let faceList:[Int:String] = [11:"jack",12:"queen",13:"king",14:"ace"]
    /// Dictionary mapping card name to value
    let faceValue:[String:Int] = ["jack":10,"queen":10,"king":10,"ace":11]
    
    /**
    Initialize card object
    
    :param: cardInitialVal The initial value of the card, ranging from 2 to 14
    
    :returns:
    */
    init(cardInitialVal:Int, suitString:String){
        // cards greater than 10 are face cards
        if(cardInitialVal > 10){
            self.name = faceList[cardInitialVal]!
            self.value = faceValue[name]!
        }else{
            self.name = String(cardInitialVal)
            self.value = cardInitialVal
            
        }
        self.suit = suitString
    }
    
    override  var description: String {
        return name
    }
    
    /**
    Checks if card is an ace
    
    :returns: True if card is an ace
    */
    func isAce() -> Bool{
        if name == "ace"{
            return true
        }
        else{
            return false
        }
    }
    
    /**
    Turns the value of an ace card to 1
    */
    func makeSmallAce(){
        if isAce(){
            value=1
        }
    }
    
    /**
    Turns the value of an ace card to 11
    */
    func makeBigAce(){
        if isAce(){
            value=11
            
        }
    }
    
}
