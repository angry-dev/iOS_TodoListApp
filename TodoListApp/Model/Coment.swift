//
//  Coment.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/19.
//

import Foundation
import RealmSwift

class Coment: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var coment: String = ""
    
}



