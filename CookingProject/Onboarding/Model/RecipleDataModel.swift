//
//  RecipleDataModel.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/02.
//

import Foundation

struct ShowRecipeDataModel {
    var foodName : String
    var userName : String
    var heartPeople : [String]
    var foodLevel : String
    var foodTime : String
    var url : String
    var documentID : String
}

struct PopularRecipeDataModel {
    var foodName : String
    var userName : String
    var heartPeople : [String]
    var foodLevel : String
    var foodTime : String
    var url : String
    var documentID : String
}

struct MyRecipeDataModel {
    var foodName : String
    var heartPeopleCount : Int
    var commentCount : Int
    var writedDate : String
    var url : String
    var foodCategory : String
    var documentID : String
}

struct DetailRecipeModel {
    var foodName : String
    var foodLevel : String
    var foodTime : String
    var foodCategory : String
    var ingredients : String
    var contents : [String]
    var userName : String
    var userUID : String
    var heartPeople : [String]
    var imageFile : [String]
    var urlArray : [String]
    var commentCount : Int
}

struct DetailRecipeHeaderModel {
    var foodName : String
    var foodLevel : String
    var foodTime : String
    var foodCategory : String
    var heartPeopleCount : Int
    var commentCount : Int
    var ingredients : String
    var url : String
    var userName : String
}

struct ModifyRecipeDataModel {
    var foodName : String
    var foodCategory : String
    var foodLevel : String
    var foodTime : String
    var contents : [String]
    var ingredients : String
    var urlArray : [String]
    var documentID : String
}
