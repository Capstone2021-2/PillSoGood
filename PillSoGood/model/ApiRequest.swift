//
//  ApiRequest.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/10.
//

import UIKit

func getRequest(url: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: url) else {return}
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error)
            return
        }
        guard let data = data else {
            print("no data")
            return
        }
        completion(data)
    }.resume()
}

func getSupplementRequest(pk: Int, completion: @escaping (supplement?) -> Void) {
    let decoder = JSONDecoder()
    guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/" + pk.description) else {return}
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error)
            return
        }
        if let data = try? decoder.decode(supplement.self, from: data!) {
            completion(data)
        }
    }.resume()
}

func getSupplementsRequest(pk: Int, completion: @escaping ([supplement]?) -> Void) {
    let decoder = JSONDecoder()
    guard let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/supplements/" + pk.description) else {return}
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error)
            return
        }
        if let data = try? decoder.decode([supplement].self, from: data!) {
            completion(data)
        }
    }.resume()
}

func deleteRequest(url: String, accessToken: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: url) else {return}
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.addValue(accessToken, forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print(error)
            return
        }
        if let response = response as? HTTPURLResponse {
            print(response.statusCode)
        }
        guard let data = data else {
            print("no data")
            return
        }
        completion(data)
    }.resume()
}
