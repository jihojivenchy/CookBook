//
//  NaverResponse.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/19.
//

import Foundation

struct NaverResponse : Decodable {
    let resultcode : String
    let message : String
    let response : Response
}

struct Response : Decodable {
    let name : String
    let email : String
}
