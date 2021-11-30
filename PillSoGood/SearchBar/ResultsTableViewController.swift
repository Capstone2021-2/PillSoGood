//
//  ResultsTableViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/25.
//

import UIKit

class ResultsCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

class ResultsTableViewController: UITableViewController {
    
    var results = [result]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell

        switch results[indexPath.row].type {
        case 0:
            cell.typeLabel.text = "[영양소]"
        case 1:
            cell.typeLabel.text = "[영양제]"
        case 2:
            cell.typeLabel.text = "[브랜드]"
        default: break
        }

        cell.nameLabel.text = results[indexPath.row].name

        return cell
    }

}
