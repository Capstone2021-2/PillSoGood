//
//  ReviewFormCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/26.
//

import UIKit


class ReviewFormCell: UITableViewCell {

    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var review: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
