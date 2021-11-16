//
//  ReviewOCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class ReviewOCell: UITableViewCell {
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementName: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var review: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeReview(_ sender: Any) {
        
    }
    
}
