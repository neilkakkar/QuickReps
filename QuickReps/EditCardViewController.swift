//
//  EditCardViewController.swift
//  QuickReps
//
//  Created by nkakkar on 19/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit
import os.log
import IQKeyboardManagerSwift

class EditCardViewController: UIViewController, UITextViewDelegate {

    var card: Card?
    let colorManager = ColorManager.shared
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editCardView: EditCardStackView!
    @IBOutlet weak var dailyStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let constraint = NSLayoutConstraint(item: dailyStackView!, attribute: .width, relatedBy: .equal, toItem: editCardView, attribute: .width, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        
        editCardView.top.delegate = self
        editCardView.bottom.delegate = self

        view.backgroundColor = editCardView.colorManager.topBackground
        
        if let card = card {
            editCardView.top.text = card.top
            editCardView.bottom.text = card.bottom
            getDailySwitch().setOn(card.cardType == .daily, animated: false)
            
        } else {
            editCardView.setPlaceholder()
        }

        updateSaveButtonState()
        setButtonColors()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setButtonColors()
    }
    
    //MARK: UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()

        dump(textView.backgroundColor)
        //TK BUG: With iOS 13 and dark mode, gotta figure this out. UIDynamicSystemColor vs UIColor
        let textViewX = textView as! UITextViewX
        
        if textView.text.isEmpty {
            if textViewX.identifier == EditCardStackView.topIdentifier {
                textViewX.text = "Question / Reminder"
                textView.textColor = editCardView.colorManager.placeholderText
            } else {
                textView.text = "Answer"
                textView.textColor = editCardView.colorManager.placeholderText
            }
            textViewX.isPlaceholder = true
        } else {
            textViewX.isPlaceholder = false
        }
        updateSaveButtonState()

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        IQKeyboardManager.shared.toolbarTintColor = ColorManager.shared.buttonTint
        
        let textViewX = textView as! UITextViewX
        if textViewX.isPlaceholder {
            if textViewX.identifier == EditCardStackView.topIdentifier {
                textView.textColor = editCardView.colorManager.topLabelText
            } else {
                textView.textColor = editCardView.colorManager.bottomLabelText
            }
            textView.text = ""
        }
    }
    
    func updateSaveButtonState() {
        let topText = editCardView.top.text ?? ""
        let bottomText = editCardView.bottom.text ?? ""
        
        let topTextIsPlaceholder = editCardView.top.isPlaceholder
        let bottomTextIsPlaceholder = editCardView.bottom.isPlaceholder
        saveButton.isEnabled = !(topText.isEmpty || bottomText.isEmpty || topTextIsPlaceholder || bottomTextIsPlaceholder)
    }
    
    //MARK: Actions

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentinginAddMode = presentingViewController is UINavigationController
        if isPresentinginAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = self.navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("EditCardViewController not inside a navigation controller")
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let top = editCardView.top.text ?? ""
        let bottom = editCardView.bottom.text ?? ""
        
        if card != nil {
            card!.top = top
            card!.bottom = bottom
        } else {
            card = Card(top: top, bottom: bottom)
        }
        
        if isDailyCard() {
            card!.setCardType(type: .daily)
        } else {
            if card!.cardType == .daily {
                card!.setCardType(type: .learning)
            }
        }
    }
    
    //MARK:  Private
    private func getDailySwitch() -> UISwitch {
        return dailyStackView.arrangedSubviews[1] as! UISwitch
    }
    private func isDailyCard() -> Bool {
        return getDailySwitch().isOn
    }
    
    private func setButtonColors() {
        navigationController?.navigationBar.tintColor = colorManager.buttonTint
        IQKeyboardManager.shared.toolbarTintColor = colorManager.buttonTint
    }
}
