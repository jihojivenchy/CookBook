//
//  Model.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/26.
//

import UIKit

struct UserInformationData {
    var name : String
    var email : String
    var login : String
}

struct HeartClikedUserDataModel {
    var name : String
    var uid : String
}

struct BlockUserModel {
    var userUID : String
    var userName : String
    var documentID : String
}
