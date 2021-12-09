//
//  MainPage.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/09/29.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        self.tabBar.tintColor = UIColor(red: 133/255, green: 177/255, blue: 248/255, alpha: 1)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

class MainPage: UIViewController {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementName: UILabel!
    @IBOutlet weak var supplementCompany: UILabel!
    @IBOutlet weak var supplementAvgRating: UILabel!
    @IBOutlet weak var supplementTakingNum: UILabel!
    @IBOutlet weak var nutrientsStackView: UIStackView!
    @IBOutlet weak var ageAndGenderLabel: UILabel!
    @IBOutlet weak var ageAndGenderStackView: UIStackView!
    @IBOutlet weak var constitutionLabel: UILabel!
    @IBOutlet weak var constitutionStackView: UIStackView!
    @IBOutlet weak var supplementView: UIView!
    var alotOfViewsInSupplements: supplementForViews?
    var nutrientsList = [Int : nutrientForViews]()
    var nowPage: Int = 0
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        getALotOfViews()
        goodForAgeAndGender()
        goodForConstitution()
        supplementView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToDetailView)))
        bannerTimer()
    }
    
    // 화면 클릭 시 탭바 아이템 수정
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "홈"
        self.navigationController?.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // 화면 내려갈 시 탭바 아이템 수정
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = nil
    }
    
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { Timer in
            self.bannerMove()
        }
    }
    
    func bannerMove() {
        if nowPage == 1 {
            bannerCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            bannerPageControl.currentPage = 0
            nowPage = 0
            return
        }
        nowPage += 1
        bannerCollectionView.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
        bannerPageControl.currentPage = 1
    }
    
    func getALotOfViews() {
        let nutUrl = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/nutrients_top_search"
        let suppUrl = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/top_search"
        getRequest(url: nutUrl) { data in
            if let data = try? self.decoder.decode([nutrientForViews].self, from: data!) {
                DispatchQueue.main.async {
                    for (index, item) in data.enumerated() {
                        if let nameButton = self.nutrientsStackView.viewWithTag(index+1) as? UIButton {
                            self.nutrientsList[index+1] = item
                            nameButton.setTitle(item.nutrient, for: .normal)
                        }
                    }
                }
            }
        }
        getRequest(url: suppUrl) { data in
            if let data = try? self.decoder.decode(supplementForViews.self, from: data!) {
                self.alotOfViewsInSupplements = data
                DispatchQueue.main.async {
                    let url = "https://pillsogood.s3.ap-northeast-2.amazonaws.com/" + data.tmp_id + ".jpg"
                    self.supplementImageView.image = UIImage(named: "default")
                    if let image = Cache.imageCache.object(forKey: url as NSString) {
                        self.supplementImageView.image = image
                    } else {
                        DispatchQueue.global().async {
                            if let data2 = try? Data(contentsOf: URL(string: url)!) {
                                if let image = UIImage(data: data2) {
                                    DispatchQueue.main.async {
                                        self.supplementImageView.image = image
                                        Cache.imageCache.setObject(image, forKey: url as NSString)
                                    }
                                }
                            }
                        }
                    }
                    self.supplementName.text = data.name
                    self.supplementCompany.text = data.company
                    self.supplementAvgRating.text = data.avg_rating.description
                    self.supplementTakingNum.text = data.taking_num.description
                }
            }
        }
    }
    
    func goodForAgeAndGender() {
        let age = UserDefaults.standard.string(forKey: "age") ?? "19~29"
        let gender = UserDefaults.standard.string(forKey: "gender") ?? "남"
        ageAndGenderLabel.text = age + "대 " + gender + "성에게 추천하는 영양소"
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_ages/" + age + "/" + gender
        getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
            if let data = try? self.decoder.decode([nutrientForViews].self, from: data!) {
                DispatchQueue.main.async {
                    for (index, item) in data.enumerated() {
                        if let nameButton = self.ageAndGenderStackView.viewWithTag(index+5) as? UIButton {
                            self.nutrientsList[index+5] = item
                            nameButton.setTitle(item.nutrient, for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func goodForConstitution() {
        let constitution = UserDefaults.standard.string(forKey: "constitution") ?? "열태양"
        constitutionLabel.text = constitution + "에게 추천하는 영양소"
        let url = "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/good_for_body_types/" + constitution
        getRequest(url: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { data in
            if let data = try? self.decoder.decode([nutrientForViews].self, from: data!) {
                DispatchQueue.main.async {
                    for (index, item) in data.enumerated() {
                        if let nameButton = self.constitutionStackView.viewWithTag(index+9) as? UIButton {
                            self.nutrientsList[index+9] = item
                            nameButton.setTitle(item.nutrient, for: .normal)
                        }
                    }
                }
            }
        }
    }
                                                                   
    @objc func moveToDetailView() {
        getSupplementRequest(pk: alotOfViewsInSupplements!.pk) { supplement in
            DispatchQueue.main.async {
                if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "SupplementDetailViewController") as? SupplementDetailViewController {
                    detailVC.title = "세부정보"
                    detailVC.supplementInfo = supplement!
                    let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                    backBarButtonItem.tintColor = .gray
                    self.navigationItem.backBarButtonItem = backBarButtonItem
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func moveToNutrientCategory(_ sender: UIButton) {
        let index = sender.tag
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailViewController") as? CategoryDetailViewController {
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            detailVC.pk = nutrientsList[index]?.nutrient_pk
            detailVC.title = nutrientsList[index]?.nutrient
            detailVC.name = nutrientsList[index]?.nutrient
            detailVC.categoryType = 0
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @IBAction func movesurvey(_ sender: UIButton) {
        if let surveyVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "SurveyViewController") as? SurveyViewController {
            surveyVC.title = "체질 검사"
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .lightGray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationController?.pushViewController(surveyVC, animated: true)
        }
        
    }
    
    @IBAction func moveToMyPage(_ sender: Any) {
        if let myPage = self.storyboard!.instantiateViewController(withIdentifier: "TapBarController") as? UITabBarController {
            myPage.modalPresentationStyle = .fullScreen
            myPage.selectedIndex = 3
            self.present(myPage, animated: true, completion: nil)
        }
    }
    

    @IBAction func moveToLifeStyle(_ sender: Any) {
        if let lifeVC = UIStoryboard(name: "MainPage", bundle: nil).instantiateViewController(withIdentifier: "LifeStyleViewController") as? LifeStyleViewController {
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .gray
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationController?.pushViewController(lifeVC, animated: true)
        }
    }
}

extension MainPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCollectionViewCell", for: indexPath) as! SurveyCollectionViewCell
            return cell
        } else {
            let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "LifeStyleCollectionViewCell", for: indexPath) as! LifeStyleCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bannerCollectionView.frame.size.width, height: bannerCollectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        bannerPageControl.currentPage = nowPage
    }
    
    
}
