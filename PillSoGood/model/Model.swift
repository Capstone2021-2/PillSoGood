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
    let avg_rating: Float?  // 평점
}

struct nutrientFacts: Codable {
    let supplement: Int
    let nutrient: Int
}

struct brand: Codable {
    let name: String
}

struct goodForOrgan: Codable {
    let organ: String
    let nutrient: String
}
