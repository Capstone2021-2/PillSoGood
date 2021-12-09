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
        constitutionInfo["한태음"] = ["강약배열" : "간>신>비>폐", "체질설명" : """
        - 말이 없고 과묵한 형이다.
        - 현실적이며 상황판단이 빠르고, 대인관계가 넓은 편이다.
        - 땀을 많이 흘리는 운동이나 사우나가 건강에 유익하다.
        - 혈압이 평균보다 약간 높아야 건강하고 의욕도 왕성하다.
        - 소고기가 건강에 좋으며, 해물이 해로워 섭취하면 많은 병의 원인이 된다.
        - 건강할 때는 땀이 많이 나고, 쇠약할 때는 오히려 땀이 없다.
        - 온수욕과 등산이 건강 증진에 도움이 된다.
        - 쇠고기와 뿌리 야채가 좋은 음식이 된다.
        """, "음식" : "모든육식, 쌀, 메주콩, 밀가루, 수수, 모든 근채류(무우,당근,도라지,연근,토란), 커피, 우유, 마늘, 호박, 버섯류, 설탕, 민물장어, 미꾸라지, 메기, 알칼리성음료, 배, 사과, 수박, 모든 견과류(호두,밤, 잣), 녹용, 인삼, 비타민 A,B,C,D"] as AnyObject
        constitutionInfo["열태음"] = ["강약배열" : "간>비>신>폐", "체질설명" : """
        - 관대하고 사교적인 성격으로 대인관계가 넓고 사회생활에 적응이 빠르다.
        - 해물은 많은 병의 원인이 되며, 건강이 상하면 관대함이 없어지며 부정적인 집착과 불안감으로 불면증이 생긴다.
        - 육식과 땀을 내는 것이 건강에 유익하다.
        - 해산물, 맥주, 찬 음식을 먹으면 하복부의 불편과 만성 설사의 원인이 되므로 주의가 필요하다.
        - 아랫배를 따뜻하게 하는 것이 좋다. 쇠고기와 뿌리 야채가 좋은 음식이 된다.
        """, "음식" : "쇠고기, 돼지고기, 쌀, 대두콩, 밀가루, 수수, 모든 근채류, 커피, 우유, 율무, 마늘, 호박, 버섯류, 설탕, 견과류, 민물장어, 미구라지, 알칼리성음료, 배, 멜론, 녹용, 비타민 A,B,C,D,E"] as AnyObject
        constitutionInfo["열태양"] = ["강약배열" : "폐>비>신>간", "체질설명" : """
- 창의적이고 사려가 깊어 실수가 적고 철저하다.
- 주관이 뚜렷하여 매사에 일관성과 전문성을 나타낸다.
- 육식을 하면 아토피성 피부질환 등 알레르기성 질환이 생긴다.
- 약이 부작용이 나기 쉬운 체질이다.
- 간 기능이 약하기 때문에 무슨 약을 쓰던 효과보다 해가 더 많다.
- 육식을 피하고 채식과 바다 생선을 섭취하는 것이 좋다.
""", "음식" : "모든 바다생선, 게, 조개류, 쌀, 보리, 메밀, 팥, 녹두, 참쑥, 오이, 가지, 배추, 양배추, 상추, 기타 푸른채소, 고사리, 젓갈, 포도당, 코코아, 초콜릿, 바나나, 딸기, 복숭아, 체리, 감, 참외, 모과, 얼음, 산성수, 포도당주사, 비타민 E"] as AnyObject
        constitutionInfo["한태양"] = ["강약배열" : "폐>신>비>간", "체질설명" : """
- 사려가 깊고 일관성이 있어 전문성을 나타낸다.
- 건강이 상하면 의심이 많아지고 자기주장이 강해진다.
- 지나친 육식과 약물복용은 파킨슨병 같은 난치근육질환을 가 져온다.
- 땀을 많이 내면 만성피로감이 쉽게 온다.
- 스트레스와 땀 흘리는 것을 주의하고 육식보다 채식이 이롭다.
- 해산물이 유익한 음식이며 약에 대한 부작용을 주의해야 한다.
""", "음식" : "메밀, 쌀, 포도당, 모든 바다생선과 게, 패류, 모든 푸른채소, 오이, 고사리, 김, 젓갈, 포도, 복숭아, 감, 앵두, 파인애플, 딸기, 파, 겨자, 생강, 후추, 코코아, 초콜릿, 산성수, 오가피"] as AnyObject
        constitutionInfo["한소양"] = ["강약배열" : "비>간>폐>신", "체질설명" : """
        - 긍정적이고 활동적이며 센스가 빠르다.
        - 일과 말에 서두르는 경향이 있어 실수를 하는 경우가 많다.
        - 췌장과 위 장의 기능이 왕성하다.
        - 매운 음식, 닭고기 등을 즐기면 당뇨병 등 여러 질환의 원인이 된다.
        - 백반증은 이 체질 과 연관성이 깊은 질환이다.
        - 체질적으로 강한 소화력을 가졌으나, 맵고 자극적인 음식은 피해야 한다.
        - 항상 여유 있는 마음으로 서두르지 않는 것이 건강에 좋다.
        """, "음식" : "보리, 쌀, 계란, 밀가루, 팥, 돼지고기, 쇠고기, 모든 채소, 대부분의 바다생선, 복요리, 민물고기, 배, 참외, 수박, 멜론, 딸기, 바나나, 비타민 E, 얼음, 구기자차, 영지버섯, 두릅, 아말감"] as AnyObject
        constitutionInfo["열소양"] = ["강약배열" : "비>폐>간>신", "체질설명" : """
        - 드문 체질로 그 수가 매우 적다.
        - 정직하고 활동적이며 매사에 긍정적이고 섬세하다.
        - 위장이 지나치게 강하고 예민해서 오히려 소화불량이 빈번하다.
        - 페니실린 쇼크를 받는 체질로 추정된다.
        - 매운 음식, 닭고기 등이 해로 운 체질이다.
        - 약이나 음식의 부작용으로 인해 소화장애가 일어나기 쉬운 체질이다.
        - 음식은 늘 시원하고 신선한 것을 먹는 것이 유익하다.
        """, "음식" : "보리, 쌀, 팥, 녹두, 오이 및 대부분의 푸른야채, 모든 바다생선 및 패류, 복요리, 돼지고기, 수박, 감, 참외, 파인애플, 포도, 딸기, 바나나, 얼음, 초콜릿, 비타민 E, 아말감"] as AnyObject
        constitutionInfo["열소음"] = ["강약배열" : "신>폐>간>비", "체질설명" : """
- 침착하고 인내심이 강하며 조직적이다.
- 세밀하고 의심이 많다.
- 변비증이 흔히 있으나 힘들어하지 않는다.
- 건강하면 땀이 없고 약하면 땀이 나며 일사병이 생기기 쉽다.
- 냉한음식이 좋지 않아서 만성 소화불량의 원인이 된다.
- 체질적으로 땀을 많이 흘리면 안 되는 체질이기 때문에 추운 계절에 더 건강하다.
- 더운 계절에는 냉수욕이나 냉수마찰을 즐기는 것이 땀을 방지하고 건강을 유지하는 방법이다.
""", "음식" : "현미, 찹쌀, 개고기, 닭고기, 염소고기, 쇠고기, 미역, 다시마, 계피, 생강, 파, 겨자, 후추, 고추, 참기름, 감자, 사과, 망고, 귤, 오렌지, 토마토, 인삼, 벌꿀, 대추, 비타민 B군, 산성수"] as AnyObject
        constitutionInfo["한소음"] = ["강약배열" : "신>간>폐>비", "체질설명" : """
- 부드럽고 동시에 냉철하고 강단이 있다.
- 차분하고 세심하다.
- 건강이 나빠지면 매사에 부정적이 되어, 냉정하고 폐쇄적인 모습이 되기 쉽다.
- 냉한 음식은 위장기능을 저하 시켜 위무력과 위하수 같은 만성질환을 일으킨다.
- 더운 음식과 소식이 건강에 이롭다.
- 찬 음식을 섭취하거나, 과식했을 때 위장장애가 발생하기 쉽다.
- 평소 따뜻한 음식과 함께 소식하는 습관을 기르는 것이 좋다.
""", "음식" : "현미, 찹쌀, 감자, 옥수수, 참기름, 미역, 다시마, 닭고기, 염소고기, 개고기, 쇠고기, 후추, 겨자, 계피, 고추, 카렉, 파, 생강, 사과, 귤, 오렌지, 토마토, 망고, 인삼, 대추, 벌꿀, 산성음료수, 눌은밤, 비타민 A,B,C,D"] as AnyObject
    }

}
