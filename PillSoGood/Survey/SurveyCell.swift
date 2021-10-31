//
//  SurveyCell.swift
//  PillSoGood
//
//  Created by haesung on 2021/10/28.
//

import UIKit

class SurveyCell: UITableViewCell{
    // 설문지 셀
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var radioButtons: [UIButton]!
    
    var indexOfOneAndOnly: Int?
    //test44
    @IBAction func touchButton(_ sender: UIButton) {
        if indexOfOneAndOnly != nil {
            if !sender.isSelected {
                for index in radioButtons.indices {
                    radioButtons[index].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnly = radioButtons.firstIndex(of: sender)
            } else {
                sender.isSelected = false
                indexOfOneAndOnly = nil
            }
        } else {
            sender.isSelected = true
            indexOfOneAndOnly = radioButtons.firstIndex(of: sender)
        }
    }
    
}


