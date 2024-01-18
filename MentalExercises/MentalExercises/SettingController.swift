//
//  SettingController.swift
//  MentalExercises
//
//  Created by Grace Chen on 2022-08-23.
//

import Foundation
import UIKit

class SettingController: UIViewController {
    
    @IBOutlet var timeSelector: UISlider!
    @IBOutlet var lowerBound: UITextField!
    @IBOutlet var upperBound: UITextField!
    @IBOutlet var addition: UIButton!
    @IBOutlet var multiplication: UIButton!
    @IBOutlet var subtraction: UIButton!
    @IBOutlet var division: UIButton!
    @IBOutlet var operation: UILabel!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var timeText: UILabel!
    @IBOutlet var rangeText: UILabel!
    @IBOutlet var toText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        timeSelector.minimumValue = 1
        timeSelector.maximumValue = 180
        addition.tintColor = UIColor.blue
        subtraction.tintColor = UIColor.blue
        multiplication.tintColor = UIColor.gray
        division.tintColor = UIColor.gray
        
        addition.isSelected = true
        subtraction.isSelected = true
        addition.setTitleColor(UIColor.blue, for: UIControl.State.selected)
        subtraction.setTitleColor(UIColor.blue, for: UIControl.State.selected)
        lowerBound.text = "2"
        upperBound.text = "100"
        
        operation.text = NSLocalizedString("Operations", comment: "")
        rangeText.text = NSLocalizedString("Range of Values", comment: "")
        timeText.text = NSLocalizedString("Amount of Time Allotted Per Question", comment: "")
        titleText.text = NSLocalizedString("Welcome to the Mental Exercises App!", comment: "")
        toText.text = NSLocalizedString("To", comment: "")
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton){
        if !sender.isSelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.blue, for: UIControl.State.selected)
            sender.tintColor = UIColor.blue
        }
        else {
            sender.isSelected = false
            sender.setTitleColor(UIColor.gray, for: UIControl.State.normal)
            sender.tintColor = UIColor.gray
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameController: MathController = segue.destination as? MathController {
            print("I am ere")
            gameController.timeAllotted = Int(timeSelector.value)
            
            if let low = lowerBound.text {
                if low.isNumeric {
                    let value: Int = Int(low)!
                    gameController.bounds[0] = value
                }
            }
            
            if let high = upperBound.text {
                if high.isNumeric {
                    let value: Int = Int(high)!
                    gameController.bounds[1] = value
                }
            }

            gameController.usedOperator = []
            if addition.isSelected {
                gameController.usedOperator.append("+")
            }
            if subtraction.isSelected {
                gameController.usedOperator.append("-")
            }
            if multiplication.isSelected {
                gameController.usedOperator.append("*")
            }
            if division.isSelected {
                gameController.usedOperator.append("/")
            }
            
            if gameController.usedOperator.isEmpty {
                gameController.usedOperator.append("+")
            }
        }
    }
}
