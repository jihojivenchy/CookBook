//
//  CommentsModel.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/04.
//

import Foundation

struct CommentsDataModel {
    var comment : String
    var childComments : [ChildCommentsDataModel]
    var date : String
    var userUID : String
    var userName : String
    var commentDocumentID : String
}

struct ChildCommentsDataModel {
    var comment : String
    var date : String
    var userUID : String
    var userName : String
    var childDocumentID : String
}
