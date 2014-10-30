    //
    //  HumanPlayer.swift
    //  BlackJack3
    //
    //  Created by Jaclyn May on 10/30/14.
    //  Copyright (c) 2014 NYU. All rights reserved.
    //

import Foundation
    
class HumanPlayer:Player{
    /// Player money
    var funds:Double

    /// The player's bet this round
    var playerBet:Double


    init(){
        self.funds = 100.00
        self.playerBet=0.0
        //self.lost=false
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

}

