//
//  RecipleDataModel.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/02.
//

import Foundation

struct RecipeDataModel {
    var title : String
    var chefName : String
    var heartPeople : [String]
    var level : String
    var time : String
    var date : String
    var url : String
    var category : String
    var documentID : String
}

struct DetailRecipeModel {
    var urlArray : [String]
    var contentsArray : [String]
    var ingredients : String
    var userNickName : String
    var userUID : String
    var comments : Int
}
