//
//  WriteReviewViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

protocol ReviewPageReloadDelegate: AnyObject {
    func reloadReviewPage()
}

class WriteReviewViewController: UIViewController {
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementName: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var userReview: UITextView!
    
    var supplementInfo:takingSupp?
    weak var delegate: ReviewPageReloadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
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
        supplementName.text = supplementInfo?.name
        brand.text = supplementInfo?.company
        
    }
    
    @IBAction func slideRatingStackView(_ sender: UISlider) {
        let value = round(sender.value)
        
        for index in 0...5 {
            if let starImage = ratingStackView.viewWithTag(index) as? UIImageView {
                if index <= Int(value) {
                    starImage.tintColor = UIColor(red: 255/255, green: 224/255, blue: 95/255, alpha: 1)
                } else {
                    starImage.tintColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
                }
            }
        }
        ratingLabel.text = Int(value).description
    }
    
    @IBAction func registerReview(_ sender: Any) {
        let user_pk = UserDefaults.standard.integer(forKey: "pk")
        let supplement_pk = supplementInfo!.supplement_pk
        let rating = Int(ratingLabel.text!)!
        let text = userReview.text!
        let param = "user_pk=\(user_pk)&supplement_pk=\(supplement_pk)&rating=\(rating)&text=\(text)"
        let paramData = param.data(using: .utf8)
        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/reviews/") else {
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
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 || response.statusCode == 201 {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: nil, message: "리뷰가 작성되었습니다", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "닫기", style: .default) { UIAlertAction in
                            self.delegate?.reloadReviewPage()
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else if response.statusCode == 500 {
                    let alert = UIAlertController(title: "리뷰 작성 실패", message: "개인정보수정에서 선택정보를 설정해주세요.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "닫기", style: .default) { UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }.resume()  // POST 전송!
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
