//
//  Industry.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/22.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import Foundation
import RealmSwift

class Industry: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var id = 0
    dynamic var type = ""
    dynamic var content = ""
    dynamic var time = NSTimeInterval()
    dynamic var bind_id = 0
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    //Incrementa ID
    func incrementaId() -> Int{
        let realm = try! Realm()
        let retNext: NSArray = Array(realm.objects(Industry).sorted("id"))
        let last = retNext.lastObject
        if retNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
    
    func resetIndustry() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Industry))
        }
    }
}