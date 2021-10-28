//
//  InformationCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/25.
//

import UIKit

class InformationCell: UICollectionViewCell {
    
    @IBOutlet weak var sugUse: UILabel!
    @IBOutlet weak var expDate: UILabel!
    @IBOutlet weak var priFunc: UILabel!
    @IBOutlet weak var rawMaterial: UILabel!
    @IBOutlet weak var warning: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
