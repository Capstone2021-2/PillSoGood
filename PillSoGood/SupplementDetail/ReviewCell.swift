//
//  ReviewCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/25.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        reviewTableView.register(UINib(nibName: "ReviewFormCell", bundle: nil), forCellReuseIdentifier: "ReviewFormCell")
        
    }

}

extension ReviewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewFormCell", for: indexPath) as! ReviewFormCell
        cell.isSelected = false
        cell.userInfo.text = "여성 | 15~29세 | 태음인"
        cell.review.text = "강추"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
