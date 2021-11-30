//
//  ReviewPageViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class ReviewPageViewController: UIViewController {
    
    @IBOutlet weak var reviewTableView: UITableView!
    
    var noReviewSupp = [takingSupp]()
    var reviewSupp = [userReview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        reviewTableView.register(UINib(nibName: "ReviewXCell", bundle: nil), forCellReuseIdentifier: "ReviewXCell")
        reviewTableView.register(UINib(nibName: "ReviewOCell", bundle: nil), forCellReuseIdentifier: "ReviewOCell")
        
        getData()
    }
    
    func getData() {
        let decoder = JSONDecoder()
        let user_pk = UserDefaults.standard.integer(forKey: "pk").description
        let getReviewUrl = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/reviews/user/" + user_pk
        getRequest(url: getReviewUrl) { data in
            if let data = try? decoder.decode([userReview].self, from: data!) {
                self.reviewSupp = data
                let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/user/" + user_pk
                getRequest(url: url) { data2 in
                    if let data2 = try? decoder.decode([takingSupp].self, from: data2!) {
                        for item in data2 {
                            var haveReview = 0
                            for temp in data {
                                if temp.supplement_pk == item.supplement_pk {
                                    haveReview = 1
                                    break
                                }
                            }
                            if haveReview == 0 {
                                DispatchQueue.main.async {
                                    self.noReviewSupp.append(item)
                                    self.reviewTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension ReviewPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return noReviewSupp.count
        } else {
            return reviewSupp.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewXCell", for: indexPath) as! ReviewXCell
            cell.selectionStyle = .none
            
            let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + noReviewSupp[indexPath.row].tmp_id + ".jpg"
            cell.supplementImageView.image = UIImage(named: "default")
            if let image = Cache.imageCache.object(forKey: url as NSString) {
                cell.supplementImageView.image = image
            } else {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: URL(string: url)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.supplementImageView.image = image
                                Cache.imageCache.setObject(image, forKey: url as NSString)
                            }
                        }
                    }
                }
            }
            cell.supplementName.text = noReviewSupp[indexPath.row].name
            cell.brand.text = noReviewSupp[indexPath.row].company
            
            cell.actionBlock = {
                if indexPath.section == 0 {
                    tableView.deselectRow(at: indexPath, animated: true)
                    if let detailVC = self.storyboard!.instantiateViewController(identifier: "WriteReviewViewController") as? WriteReviewViewController {
                        detailVC.title = "리뷰 작성"
                        detailVC.delegate = self
                        detailVC.supplementInfo = self.noReviewSupp[indexPath.row]
                        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                        backBarButtonItem.tintColor = .lightGray
                        self.navigationItem.backBarButtonItem = backBarButtonItem

                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewOCell", for: indexPath) as! ReviewOCell
        cell.selectionStyle = .none
        
        let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + reviewSupp[indexPath.row].tmp_id.description + ".jpg"
        cell.supplementImageView.image = UIImage(named: "default")
        if let image = Cache.imageCache.object(forKey: url as NSString) {
            cell.supplementImageView.image = image
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: url)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.supplementImageView.image = image
                            Cache.imageCache.setObject(image, forKey: url as NSString)
                        }
                    }
                }
            }
        }
        cell.supplementName.text = reviewSupp[indexPath.row].supplement
        cell.brand.text = reviewSupp[indexPath.row].company
        cell.review.text = reviewSupp[indexPath.row].text
        let rating = reviewSupp[indexPath.row].rating
        for index in 0...5 {
            if let starImage = cell.ratingStackView.viewWithTag(index) as? UIImageView {
                if index <= rating {
                    starImage.tintColor = UIColor(red: 255/255, green: 224/255, blue: 95/255, alpha: 1)
                } else {
                    starImage.tintColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
                }
            }
        }
        
        cell.actionBlock = {
            let alert = UIAlertController(title: "리뷰 삭제", message: "리뷰를 삭제하시겠습니까?", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "삭제", style: .cancel) { UIAlertAction in
                let removeItem = self.reviewSupp.remove(at: indexPath.row)
                let accessToken = "jwt " + UserDefaults.standard.string(forKey: "token")!
                let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/reviews/" + removeItem.pk.description + "/"
                deleteRequest(url: url, accessToken: accessToken) { data in
                    let appendItem = takingSupp(id: -1, user_pk: removeItem.user_pk, supplement_pk: removeItem.supplement_pk, name: removeItem.supplement, company: removeItem.company, tmp_id: removeItem.tmp_id.description)
                    DispatchQueue.main.async {
                        self.noReviewSupp.append(appendItem)
                        self.reviewTableView.reloadData()
                    }
                }
            }
            alert.addAction(closeAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "리뷰를 작성하지 않은 영양제"
        }
        return "작성된 리뷰"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
}

extension ReviewPageViewController: ReviewPageReloadDelegate {
    func reloadReviewPage() {
        self.noReviewSupp = [takingSupp]()
        self.reviewSupp = [userReview]()
        self.getData()
    }
}
