//
//  EditCardViewController.swift
//  QuickReps
//
//  Created by nkakkar on 19/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit
import os.log

class EditCardViewController: UIViewController, UITextFieldDelegate {

    var card: Card?
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editCardView: EditCardStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editCardView.top.delegate = self
        editCardView.bottom.delegate = self

        if let card = card {
            editCardView.top.text = card.top
            editCardView.bottom.text = card.bottom
        }

        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let topText = editCardView.top.text ?? ""
        let bottomText = editCardView.bottom.text ?? ""
        
        saveButton.isEnabled = !(topText.isEmpty || bottomText.isEmpty)
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
    }
}
