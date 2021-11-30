//
//  nutrientsCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/25.
//

import UIKit

class NutrientsCell: UICollectionViewCell {

    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var nutrientView: UIView!
    
    var nutrients = [nutrientForSupp]()
    var nutrientsLabel = [UILabel]()
    var lastConstraints: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func addNutrientLabel() {
        lastConstraints?.isActive = false
        for (index, item) in nutrients.enumerated() {
            if nutrientsLabel.count <= index {
                let nameLabel = UILabel()
                nameLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
                nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
                nameLabel.lineBreakMode = .byWordWrapping
                nameLabel.numberOfLines = 0
                nameLabel.text = item.name
                self.addSubview(nameLabel)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let amountStr = item.amount.description + item.unit
                let attributedStr = NSMutableAttributedString(string: item.amount.description + item.unit)
                attributedStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .medium), range: (amountStr as NSString).range(of: item.unit))
                
                let nutAmountLabel = UILabel()
                nutAmountLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
                nutAmountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
                nutAmountLabel.attributedText = attributedStr
                self.addSubview(nutAmountLabel)
                nutAmountLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let appropriateLabel = UILabel()
                appropriateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
                appropriateLabel.layer.masksToBounds = true
                appropriateLabel.layer.cornerRadius = 5
                if item.lower > item.amount {
                    appropriateLabel.backgroundColor = UIColor(red: 1.00, green: 0.95, blue: 0.74, alpha: 1.00)
                    appropriateLabel.textColor = UIColor(red: 0.82, green: 0.74, blue: 0.51, alpha: 1.00)
                    appropriateLabel.text = "   부족   "
                } else if item.upper < item.amount {
                    appropriateLabel.backgroundColor = UIColor(red: 1.00, green: 0.59, blue: 0.60, alpha: 0.5)
                    appropriateLabel.textColor = UIColor(red: 0.76, green: 0.45, blue: 0.47, alpha: 1.00)
                    appropriateLabel.text = "   과다   "
                } else {
                    appropriateLabel.backgroundColor = UIColor(red: 0.51, green: 0.69, blue: 0.97, alpha: 0.5)
                    appropriateLabel.textColor = UIColor(red: 0.26, green: 0.40, blue: 0.57, alpha: 1.00)
                    appropriateLabel.text = "   적정   "
                }
                self.addSubview(appropriateLabel)
                appropriateLabel.translatesAutoresizingMaskIntoConstraints = false
                
                nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
                nutAmountLabel.centerXAnchor.constraint(equalTo: amountLabel.centerXAnchor).isActive = true
                appropriateLabel.centerXAnchor.constraint(equalTo: percentLabel.centerXAnchor).isActive = true
                
                nameLabel.trailingAnchor.constraint(equalTo: nutAmountLabel.leadingAnchor, constant: 20).isActive = true
                
                nutAmountLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
                appropriateLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
                
                if index == 0 {
                    nameLabel.topAnchor.constraint(equalTo: nutrientLabel.bottomAnchor, constant: 20).isActive = true
                } else {
                    nameLabel.topAnchor.constraint(equalTo: nutrientsLabel[index-1].bottomAnchor, constant: 20).isActive = true
                }
                
                if index == (nutrients.count - 1) {
                    lastConstraints = nameLabel.bottomAnchor.constraint(equalTo: nutrientView.bottomAnchor, constant: 50)
                    lastConstraints?.isActive = true
                }
                nutrientsLabel.append(nameLabel)
            }
        }
    }

}
