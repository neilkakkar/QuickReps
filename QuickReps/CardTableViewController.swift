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
    var cards = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedCards = loadCards() {
            cards += savedCards
        } else {
            loadSampleCards()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CardTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let card = self.cards[indexPath.row]
        // Configure the cell...
        cell.textLabel!.text = card.top
//        cell.detailTextLabel!.text = card.bottom

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
            cards.remove(at: indexPath.row)
            saveCards()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
            
            let selectedCard = cards[indexPath.row]
            editCardViewController.card = selectedCard
            editCardViewController.navigationItem.title = "Edit Card"
            
        default:
            fatalError("Unexpected segue identifier")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Actions
    @IBAction func unwindToCardList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EditCardViewController, let card = sourceViewController.card {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                cards[selectedIndexPath.row] = card
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row: cards.count, section: 0)
                cards.append(card)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveCards()
        }
    }
    
    //MARK: Private
    private func loadSampleCards() {
        if !cards.isEmpty {
            return
        }
        let card1 = Card(top: "top", bottom: "bottom")
        let card2 = Card(top: "up", bottom: "down")
        let card3 = Card(top: "Something useful? or just super super super looong! What now, iOS!?", bottom: "No")
        
        self.cards += [card1, card2, card3]
    }
    
    private func saveCards() {
        let codedData = try! NSKeyedArchiver.archivedData(withRootObject: cards, requiringSecureCoding: false)
        
        do {
            try codedData.write(to: Card.ArchiveURL)
        } catch {
            os_log("Couldn't write to save file.", type: .debug)
        }
    }
    
    private func loadCards() -> [Card]? {
        guard let codedData = try? Data(contentsOf: Card.ArchiveURL) else { return nil }
        
        let cards = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? [Card]
        return cards
    }

}
