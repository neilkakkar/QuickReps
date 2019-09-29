//
//  CardTableViewController.swift
//  QuickReps
//
//  Created by nkakkar on 18/09/2019.
//  Copyright © 2019 neilkakkar. All rights reserved.
//

import UIKit
import os.log

class CardTableViewController: UITableViewController {

    //MARK: Properties
    var cardDataController = CardDataController.shared
    var cards = [Card]()
    var dailyCards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards = cardDataController.getCards()
        dailyCards = cardDataController.getCards(daily: true)
        cardDataController.resetEditCount()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if cardDataController.hasUpdates() {
            cardDataController.saveCards()
            cardDataController.resetEditCount()
            // Doesn't work when Home button is pressed :$ - AppDelegate.swift handles that
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyCards.count
        }
        return cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        var card: Card
        if indexPath.section == 0 {
            card = dailyCards[indexPath.row]
        } else {
            card = cards[indexPath.row]
        }
        // Configure the cell...
        cell.textLabel!.text = card.top
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // and from tableview
            deleteCard(tableView, at: indexPath)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Daily Reminder Cards"
        } else {
            return "Regular Cards"
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UITableViewHeaderFooterView()
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "addCard":
            os_log("Adding a new card.", log: OSLog.default, type: .debug)
        
        case "showDetail":
            guard let editCardViewController = segue.destination as? EditCardViewController else {
                fatalError("Unexpected destination \(segue.destination)")
            }
            guard let selectedCardCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedCardCell) else {
                fatalError("Select card not displayed")
            }
            
            let selectedCard = getArrayFromSection(indexPath.section)[indexPath.row]
            editCardViewController.card = selectedCard
            editCardViewController.navigationItem.title = "Edit Card"
            
        default:
            fatalError("Unexpected segue identifier")
        }
    }
    
    //MARK: Actions
    @IBAction func unwindToCardList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EditCardViewController, let card = sourceViewController.card {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // edit card view
                
                // check if type change
                let newCardType = card.cardType
                let oldCardType: Card.CardType = selectedIndexPath.section == 0 ? .daily : .learning
                
                if newCardType != oldCardType {
                    updateCardWithSectionChange(tableView, card: card, from: selectedIndexPath)
                } else {
                    updateCard(tableView, card: card, at: selectedIndexPath)
                }
                
            } else {
                addCard(tableView, card: card)
            }
        }
    }
    
    //MARK: Private
    private func getArrayFromSection(_ section: Int) -> [Card] {
        if section == 0 {
            return dailyCards
        } else {
            return cards
        }
    }

    private func addCard(_ tableView: UITableView, card: Card) {
        let cardSection = card.cardType == Card.CardType.daily ? 0 : 1
        let cardRow = cardSection == 0 ? dailyCards.count : cards.count
        let newIndexPath = IndexPath(row: cardRow, section: cardSection)
        
        cardSection == 0 ? dailyCards.append(card) : cards.append(card)
        cardDataController.addCard(card: card)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func deleteCard(_ tableView: UITableView, at indexPath: IndexPath) {
        // assume called from the table slide always, so no chance of modifications from one type to another
        if indexPath.section == 0 {
            dailyCards.remove(at: indexPath.row)
        } else {
            cards.remove(at: indexPath.row)
        }
        cardDataController.deleteCard(at: indexPath.row, isDaily: indexPath.section == 0)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func updateCard(_ tableView: UITableView, card: Card, at indexPath: IndexPath) {
        if indexPath.section == 0 {
            dailyCards[indexPath.row] = card
        } else {
            cards[indexPath.row] = card
        }
        cardDataController.updateCard(at: indexPath.row, card: card)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func updateCardWithSectionChange(_ tableView: UITableView, card: Card, from: IndexPath) {
        deleteCard(tableView, at: from)
        addCard(tableView, card: card)
    }
}
