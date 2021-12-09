//
//  ReviewForm.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/12/02.
//

import UIKit

class ReviewForm: UITableViewCell {

    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var review: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
