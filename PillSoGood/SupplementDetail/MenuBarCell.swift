//
//  MenuBarCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/25.
//

import UIKit

class MenuBarCell: UICollectionViewCell {

    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            self.label.textColor = isSelected ? UIColor(red: 131/255, green: 177/255, blue: 248/255, alpha: 1) : .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
