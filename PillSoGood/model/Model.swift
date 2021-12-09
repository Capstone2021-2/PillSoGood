//
//  Model.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/10/28.
//

import Foundation

struct nutrient: Codable {
    let nutrient_pk: Int    // pk
    let name: String    // 영양소 이름
}

struct nutrient2: Codable {
    let pk: Int
    let name: String
    let upper: Float
    let lower: Float
    let unit: String
}

struct nutrientForSupp {
    let pk: Int
    let name: String
    let unit: String
    var amount: Float
    let upper: Float
    let lower: Float
}

struct nutrientInfo: Codable {
    let supplement: Int
    let nutrient: Int
    let nutrient_name: String
    var amount: Float
    let upper: Float
    let lower: Float
    let unit: String
}

struct organ: Codable {
    let organ: String   // 기능별 이름
}

struct supplement: Codable {
    let pk: Int  // pk
    let name: String    // 이름
    let company: String // 브랜드
    let exp_date: String?   // 유통기한
    let dispos: String? // 섭취방법
    let sug_use: String?
    let warning: String?    // 주의사항
    let pri_func: String?   // 주요기능
    let raw_material: String?   // 원재료
    let avg_rating: Float  // 평점
    let review_num: Int // 리뷰 수
    let tmp_id: String  // 이미지 파일이름
    let taking_num: Int // 복용하는 사람 수
}

struct nutrientFacts: Codable {
    let supplement: Int
    let nutrient: Int
    let amount: Float
}

struct brand: Codable {
    let name: String
}

struct goodForOrgan: Codable {
    let organ: String
    let nutrient: String
}

struct goodForLifeStyle: Codable {
    let life_style: String
    let nutrient: String
}

struct takingSupp: Codable {
    let id: Int
    let user_pk: Int
    let supplement_pk: Int
    let name: String
    let company: String
    let tmp_id: String
}

struct userReview: Codable {
    let pk: Int
    let user_pk: Int
    let nickname: String
    let tmp_id: Int
    let supplement_pk: Int
    let supplement: String
    let company: String
    let bodytype_pk: Int
    let gender: String
    let bodytype: String
    let age_pk: Int
    let age: String
    let height: Float?
    let weight: Float?
    let rating: Int
    let text: String
}

struct result: Codable {
    let type: Int
    let pk: Int
    let name : String
}

struct supplementForViews: Codable {
    let pk: Int
    let tmp_id: String
    let name: String
    let company: String
    let avg_rating: Float
    let taking_num: Int
}

struct nutrientForViews: Codable {
    let nutrient_pk: Int
    let nutrient: String
}

struct caution: Codable {
    let name: String
    let caution: String
}
