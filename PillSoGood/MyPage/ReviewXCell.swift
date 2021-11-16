//
//  ReviewXCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class ReviewXCell: UITableViewCell {
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementName: UILabel!
    @IBOutlet weak var brand: UILabel!
    
    var actionBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        actionBlock?()
    }
    
}
