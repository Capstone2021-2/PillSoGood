//
//  ReviewCell.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/25.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var reviewTableView: UITableView!
    var reviewList = [userReview]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        reviewTableView.register(UINib(nibName: "ReviewFormCell", bundle: nil), forCellReuseIdentifier: "ReviewFormCell")
        
    }

}

extension ReviewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewFormCell", for: indexPath) as! ReviewFormCell
        cell.isSelected = false
        cell.userInfo.text = reviewList[indexPath.row].gender + "성 | " + reviewList[indexPath.row].age + "세 | " + reviewList[indexPath.row].bodytype
        cell.review.text = reviewList[indexPath.row].text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
