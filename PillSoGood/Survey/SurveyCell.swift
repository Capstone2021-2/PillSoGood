//
//  SurveyCell.swift
//  PillSoGood
//
//  Created by haesung on 2021/10/28.
//

import UIKit

protocol CellDelegate: class {
    func CellButtonTapped(key: Int, value: Int)
}

class SurveyCell: UITableViewCell{
    // 설문지 셀
    @IBOutlet weak var questionLabel: UILabel!
    weak var delegate: CellDelegate?
    @IBOutlet var radioButtons: [UIButton]!
    
    var indexPathRow: Int = -1
    var indexOfOneAndOnly: Int?
    // 이게뭐람...
    //test44
    @IBAction func touchButton(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                resetButton()
                sender.isSelected = true
                indexOfOneAndOnly = radioButtons.firstIndex(of: sender)
                delegate?.CellButtonTapped(key: indexPathRow, value: indexOfOneAndOnly!)
            } else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
                delegate?.CellButtonTapped(key: indexPathRow, value: -1)
            }
        } else {
            sender.isSelected = true
            indexOfOneAndOnly = radioButtons.firstIndex(of: sender)
            delegate?.CellButtonTapped(key: indexPathRow, value: indexOfOneAndOnly!)
        }
    }
    
    func resetButton() {
        for index in radioButtons.indices {
            radioButtons[index].isSelected = false
        }
    }
    
}


