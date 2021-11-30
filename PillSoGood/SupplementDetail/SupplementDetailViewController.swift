//
//  SupplementDetailViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/25.
//

import UIKit

class SupplementDetailViewController: UIViewController, CustomMenuBarDelegate {
    
    var supplementInfo: supplement? = nil
    var nutrientInfo = [nutrientForSupp]()
    var reviewInfo = [userReview]()
    
    var viewList = ["NutrientsCell", "InformationCell", "ReviewCell"]
    
    func customMenuBar(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementTitle: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var theNumOfPeople: UILabel!
    
    
    var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var customMenuBar = MenuBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let rightBarButtonItem = UIBarButtonItem(title: "복용제품 추가", style: .done, target: self, action: #selector(addMySupplement))
        rightBarButtonItem.tintColor = UIColor(red: 0.27, green: 0.51, blue: 0.71, alpha: 1.00)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.isNavigationBarHidden = false
        setupNutrientInfo()
        setupSupplementInfo()
        setupReviewInfo()
        setupCustomTabBar()
        setupPageCollectionView()
    }
    
    @objc func addMySupplement() {
        let user_pk = UserDefaults.standard.integer(forKey: "pk")
        let supplement_pk = supplementInfo!.pk
        let param = "user_pk=\(user_pk)&supplement_pk=\(supplement_pk)"
        let paramData = param.data(using: .utf8)

        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/taking_supplements/") else {
            print("api is down")
            return
        }

        // URLRequest 객체 정의
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")

        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print("An error has occured: \(err.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 201 || response.statusCode == 200 {
                        let alert = UIAlertController(title: nil, message: "내 영양제에 추가가 완료되었습니다!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else if response.statusCode == 500 {
                        let alert = UIAlertController(title: "복용제품 추가 실패", message: "이미 영양제가 추가 되어있습니다!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }.resume()  // POST 전송!
    }
    
    func setupNutrientInfo() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrition_facts/supplement_to_nutrient/" + supplementInfo!.pk.description
        getRequest(url: url) { data in
            if let data = try? decoder.decode([nutrientFacts].self, from: data!) {
                for item in data {
                    let url2 = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrients/" + item.nutrient.description
                    getRequest(url: url2) { data2 in
                        if let data2 = try? decoder.decode(nutrient2.self, from: data2!) {
                            DispatchQueue.main.async {
                                let temp = nutrientForSupp(pk: data2.pk, name: data2.name, unit: data2.unit, amount: item.amount, upper: data2.upper, lower: data2.lower)
                                self.nutrientInfo.append(temp)
                                self.pageCollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setupSupplementInfo() {
        let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + (supplementInfo?.tmp_id ?? "") + ".jpg"
        self.supplementImageView.image = UIImage(named: "default")
        if let image = Cache.imageCache.object(forKey: url as NSString) {
            self.supplementImageView.image = image
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URL(string: url)!) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.supplementImageView.image = image
                            Cache.imageCache.setObject(image, forKey: url as NSString)
                        }
                    }
                }
            }
        }
        self.supplementTitle.text = supplementInfo?.name
        self.brand.text = supplementInfo?.company
        self.score.text = (supplementInfo?.avg_rating.description ?? "0") + " (" + (supplementInfo?.review_num.description ?? "0") + ")"
        self.theNumOfPeople.text = supplementInfo?.taking_num.description
    }
    
    func setupReviewInfo() {
        let decoder = JSONDecoder()
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/reviews/supplements/" + supplementInfo!.pk.description
        getRequest(url: url) { data in
            if let data = try? decoder.decode([userReview].self, from: data!) {
                DispatchQueue.main.async {
                    self.reviewInfo = data
                    self.pageCollectionView.reloadData()
                }
            }
        }
    }
    
    func setupCustomTabBar(){
        self.view.addSubview(customMenuBar)
        customMenuBar.delegate = self
        customMenuBar.translatesAutoresizingMaskIntoConstraints = false
        customMenuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 3
        customMenuBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        customMenuBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        customMenuBar.topAnchor.constraint(equalTo: self.supplementImageView.bottomAnchor, constant: 20).isActive = true
        customMenuBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupPageCollectionView() {
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .white
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(UINib(nibName: "NutrientsCell", bundle: nil), forCellWithReuseIdentifier: "NutrientsCell")
        pageCollectionView.register(UINib(nibName: "InformationCell", bundle: nil), forCellWithReuseIdentifier: "InformationCell")
        pageCollectionView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCell")
        self.view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.customMenuBar.bottomAnchor).isActive = true
    }

}

extension SupplementDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewList[indexPath.row], for: indexPath) as! NutrientsCell
            cell.nutrients = nutrientInfo
            cell.addNutrientLabel()
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewList[indexPath.row], for: indexPath) as! InformationCell
            cell.sugUse.text = self.supplementInfo?.sug_use
            cell.expDate.text = self.supplementInfo?.exp_date
            cell.priFunc.text = self.supplementInfo?.pri_func
            cell.warning.text = self.supplementInfo?.warning
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewList[indexPath.row], for: indexPath) as! ReviewCell
            cell.reviewList = self.reviewInfo
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customMenuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customMenuBar.customBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension SupplementDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
