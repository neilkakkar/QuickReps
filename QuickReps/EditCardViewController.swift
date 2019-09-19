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

        // Do any additional setup after loading the view.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        card = Card(top: top, bottom: bottom)
    }
}
