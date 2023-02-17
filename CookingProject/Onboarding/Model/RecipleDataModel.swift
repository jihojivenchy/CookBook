//
//  RecipleDataModel.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/02.
//

import Foundation

struct RecipeDataModel {
    var foodName : String
    var userName : String
    var heartPeople : [String]
    var foodLevel : String
    var foodTime : String
    var writedDate : String
    var url : String
    var foodCategory : String
    var documentID : String
}

struct DetailRecipeModel {
    var imageFile : [String]
    var urlArray : [String]
    var contents : [String]
    var ingredients : String
    var userUID : String
    var commentCount : Int
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
