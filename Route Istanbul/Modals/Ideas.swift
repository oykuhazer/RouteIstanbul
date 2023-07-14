//
//  Ideas.swift
//  Route Istanbul
//
//  Created by Öykü Hazer Ekinci on 20.06.2023.
//

import Foundation

class Ideas {
    private(set) var userName:String!
    private(set) var addedDate: Date!
    private(set) var ideasText: String!
    private(set) var commentNumbers: Int!
    private(set) var commentPlace:String!
    private(set) var documentId: String!
    
    init(userName: String, addedDate: Date, ideasText: String, commentNumbers: Int,  commentPlace: String, documentId: String) {
        self.userName = userName
        self.addedDate = addedDate
        self.ideasText = ideasText
        self.commentNumbers = commentNumbers
        self.commentPlace = commentPlace
        self.documentId = documentId
    }
}
