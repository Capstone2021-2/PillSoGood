//
//  SurveyResultViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/11.
//

import UIKit

class SurveyResultViewController: UIViewController {
    
    @IBOutlet weak var userConstitutionLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstOrgan: UILabel!
    @IBOutlet weak var firstDescription: UILabel!
    @IBOutlet weak var foodForFirst: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondOrgan: UILabel!
    @IBOutlet weak var secondDescription: UILabel!
    @IBOutlet weak var foodForSecond: UILabel!
    var firstConstitution: String?
    var secondConstitution: String?
    
    var constitutionInfo = [String : AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()

        userConstitutionLabel.text = "1순위 : " + firstConstitution! + "\n2순위 : " + secondConstitution!
        firstLabel.text = firstConstitution
        firstOrgan.text = constitutionInfo[firstConstitution!]!["강약배열"] as! String
        firstDescription.text = constitutionInfo[firstConstitution!]!["체질설명"] as! String
        foodForFirst.text = constitutionInfo[firstConstitution!]!["음식"] as! String
        
        secondLabel.text = secondConstitution
        secondOrgan.text = constitutionInfo[secondConstitution!]!["강약배열"] as! String
        secondDescription.text = constitutionInfo[secondConstitution!]!["체질설명"] as! String
        foodForSecond.text = constitutionInfo[secondConstitution!]!["음식"] as! String
    }
    
    func setData() {
        constitutionInfo["한태음"] = ["강약배열" : "간>신>비>폐", "체질설명" : "당신이 건강할 때는 귀찮도록 땀이 나고 쇠약할 때는 되려 땀이 없으며 무슨 방법으로든지 땀만 흘리면 몸이 가벼워지는 것을 느끼는 것은 체질적으로 땀이 많이 나야 하기 때문이오니, 항상 온수욕을 즐기는 것은 좋은 건강법이 될 것입니다. 등산이 좋고, 말을 적게 하는 것이 좋습니다. 당신의 혈압은 일반 평균보다 높은 것이 건강한 상태입니다.", "음식" : "모든육식, 쌀, 메주콩, 밀가루, 수수, 모든 근채류(무우,당근,도라지,연근,토란), 커피, 우유, 마늘, 호박, 버섯류, 설탕, 민물장어, 미꾸라지, 메기, 알칼리성음료, 배, 사과, 수박, 모든 견과류(호두,밤, 잣), 녹용, 인삼, 비타민 A,B,C,D"] as AnyObject
        constitutionInfo["열태음"] = ["강약배열" : "간>비>신>폐", "체질설명" : "하복부가 불편하다면 바로 다리가 무겁고 허리가 아프고 통변이 고르지 못하여 정신이 우울하고 몸이 차고 때로 잠이 안드는 원인이 되는 대장의 무력때문입니다. 그러므로 항상 아랫배에 복대를 하여 따뜻하게 하는 것이 좋습니다. 알콜 중독에 걸리기 쉬운 체질이므로 술에 대한 각별한 주의가 필요합니다.", "음식" : "쇠고기, 돼지고기, 쌀, 대두콩, 밀가루, 수수, 모든 근채류, 커피, 우유, 율무, 마늘, 호박, 버섯류, 설탕, 견과류, 민물장어, 미구라지, 알칼리성음료, 배, 멜론, 녹용, 비타민 A,B,C,D,E"] as AnyObject
        constitutionInfo["열태양"] = ["강약배열" : "폐>비>신>간", "체질설명" : "당신이 무슨 약을 쓰던지 효과보다 해가 더 많고 육식 후에 몸이 더 괴로워지는 것은 체질적으로 간기능이 약하기 때문이므로 채식과 바다생선을 주식으로 하고, 항상 허리를 펴고 서는 시간을 많이 갖는 것이 건강의 비결입니다. 일광욕과 땀을 많이 내는 것을 피하십시오.", "음식" : "모든 바다생선, 게, 조개류, 쌀, 보리, 메밀, 팥, 녹두, 참쑥, 오이, 가지, 배추, 양배추, 상추, 기타 푸른채소, 고사리, 젓갈, 포도당, 코코아, 초콜릿, 바나나, 딸기, 복숭아, 체리, 감, 참외, 모과, 얼음, 산성수, 포도당주사, 비타민 E"] as AnyObject
        constitutionInfo["한태양"] = ["강약배열" : "폐>신>비>간", "체질설명" : "이 체질의 건강 제1조는 모든 육식을 끊는 것이고, 제2조는 약을 쓰지 않는 것이며, 제3조는 화내지 않는 것이다. 혹 근육 무력증이 있을 때에는 더욱 주의하고 항상 온수욕보다 냉수욕을 즐겨야 한다.", "음식" : "메밀, 쌀, 포도당, 모든 바다생선과 게, 패류, 모든 푸른채소, 오이, 고사리, 김, 젓갈, 포도, 복숭아, 감, 앵두, 파인애플, 딸기, 파, 겨자, 생강, 후추, 코코아, 초콜릿, 산성수, 오가피"] as AnyObject
        constitutionInfo["한소양"] = ["강약배열" : "비>간>폐>신", "체질설명" : "당신의 건강은 조급한 성품과 직결되므로, 항상 여유있는 마음으로 서둘지 않는 것이 건강법입니다. 체질적으로 강한 소화력을 가졌으나 체질에 맞지 않는 음식은 피해야 합니다. 술과 냉수욕은 해가 많습니다.", "음식" : "보리, 쌀, 계란, 밀가루, 팥, 돼지고기, 쇠고기, 모든 채소, 대부분의 바다생선, 복요리, 민물고기, 배, 참외, 수박, 멜론, 딸기, 바나나, 비타민 E, 얼음, 구기자차, 영지버섯, 두릅, 아말감"] as AnyObject
        constitutionInfo["열소양"] = ["강약배열" : "비>폐>간>신", "체질설명" : "약이나 음식의 부작용으로 인해 소화장애가 나기 쉬운 체질이므로 주의를 요하며, 음식은 늘 시원하고 신선한 것을 취하는 것이 유익합니다.", "음식" : "보리, 쌀, 팥, 녹두, 오이 및 대부분의 푸른야채, 모든 바다생선 및 패류, 복요리, 돼지고기, 수박, 감, 참외, 파인애플, 포도, 딸기, 바나나, 얼음, 초콜릿, 비타민 E, 아말감"] as AnyObject
        constitutionInfo["열소음"] = ["강약배열" : "신>폐>간>비", "체질설명" : "당신이 추운 계절에 더 건강한 것은 체질적으로 땀을 많이 흘리면 안되는 체질이기 때문이므로 냉수욕이나 냉수마찰을 즐기는 것이 땀을 방지하는 유일한 건강법입니다.", "음식" : "현미, 찹쌀, 개고기, 닭고기, 염소고기, 쇠고기, 미역, 다시마, 계피, 생강, 파, 겨자, 후추, 고추, 참기름, 감자, 사과, 망고, 귤, 오렌지, 토마토, 인삼, 벌꿀, 대추, 비타민 B군, 산성수"] as AnyObject
        constitutionInfo["한소음"] = ["강약배열" : "신>간>폐>비", "체질설명" : "온도적으로 그리고 질적으로 냉한 음식을 먹으면 당신의 냉한 위가 더욱 냉각되어 모든 불건강과 불안 속으로 이끌려 마침내는 위하수가 됩니다. 그러므로 이 체질의 건강 제1조는 '소식'하는 것과 더운 음식을 취하는 것입니다.", "음식" : "현미, 찹쌀, 감자, 옥수수, 참기름, 미역, 다시마, 닭고기, 염소고기, 개고기, 쇠고기, 후추, 겨자, 계피, 고추, 카렉, 파, 생강, 사과, 귤, 오렌지, 토마토, 망고, 인삼, 대추, 벌꿀, 산성음료수, 눌은밤, 비타민 A,B,C,D"] as AnyObject
    }

}
