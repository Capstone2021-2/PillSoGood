//
//  ReviewFormCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/26.
//

import UIKit


class ReviewFormCell: UITableViewCell {

    
    @IBOutlet weak var view: UIView! {
        didSet {
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 0.7).cgColor
            view.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var review: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
