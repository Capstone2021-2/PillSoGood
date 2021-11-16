//
//  WriteReviewViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

class WriteReviewViewController: UIViewController {
    
    @IBOutlet weak var supplementImageView: UIImageView!
    @IBOutlet weak var supplementName: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var userReview: UITextView!
    
    var supplementInfo:supplement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
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
        let supplement_pk = supplementInfo!.pk
        let rating = Int(ratingLabel.text!)!
        let text = userReview.text!
        let param = "user_pk=\(user_pk)&supplement_pk=\(supplement_pk)&rating=\(rating)&text=\(text)"
        let paramData = param.data(using: .utf8)
//        let param = ["user_pk" : user_pk, "supplement_pk" : supplement, "rating" : rating!, "text" : text!] as [String : Any]
//        let paramData = try! JSONSerialization.data(withJSONObject: param, options: [])

        guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/reviews/") else {
            print("api is down")
            return
        }

        // URLRequest 객체 정의
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramData
        request.addValue("jwt " + UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")

        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let err = error {
                print("An error has occured: \(err.localizedDescription)")
                return
            }
            print(response!)
        }.resume()  // POST 전송!
        self.navigationController?.popViewController(animated: true)
    }
    
    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
