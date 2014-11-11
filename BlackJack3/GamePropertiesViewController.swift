//
//  GamePropertiesViewController.swift
//  BlackJack3
//
//  Created by Jaclyn May on 11/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import Foundation
import UIKit

class GamePropertiesViewController: UIViewController{
    
    @IBOutlet weak var deckUIStepper: UIStepper!
    @IBOutlet weak var deckNumberField: UITextField!
    
    @IBOutlet weak var totalFundsField: UITextField!
    @IBOutlet weak var betAmountField: UITextField!
    
    @IBOutlet weak var gameMessageField: UITextView!
    
    
    var blackJack:BlackjackModel = BlackjackModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "toGameViewSegue" {
            if (!validate_bets_and_deck_num()) {
                return false
            }
                
            else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
   
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "toGameViewSegue") {
            blackJack.newGame(deckNum: deckNumberField.text.toInt()!)
            var svc = segue!.destinationViewController as ViewController;
            svc.bj = blackJack
        }
    }
    
    // Deck Stepper action
    @IBAction func deckStepper(sender: UIStepper) {
        deckNumberField.text = String(Int(sender.value))
    }


    
    func validate_bets_and_deck_num() -> Bool{
        var betAmount:Double = NSString(string: betAmountField.text).doubleValue
        // If bet > 1  and less than playerTotal, sets player bet
        if !blackJack.players[0].bet(betAmount){
            gameMessageField.text = "Your bet must be at least $1 and not exceed your funds"
            return false
        }
            
        else{
            betAmountField.userInteractionEnabled = false
        }
        
        var deckCount = deckNumberField.text.toInt()
        if deckCount! < 1{
            gameMessageField.text = "You must select at least one deck"
            return false
        }
        return true
    }

}