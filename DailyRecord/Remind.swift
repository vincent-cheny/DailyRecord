//
//  Remind.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/29.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import Foundation
import RealmSwift

class Remind: Object {
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    dynamic var id = 0
    dynamic var enable = false
    dynamic var hour = 0
    dynamic var minute = 0
    dynamic var monday = false
    dynamic var tuesday = false
    dynamic var wednesday = false
    dynamic var thursday = false
    dynamic var friday = false
    dynamic var saturday = false
    dynamic var sunday = false
    dynamic var content = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    //Incrementa ID
    func incrementaId() -> Int{
        let realm = try! Realm()
        let retNext: NSArray = Array(realm.objects(Remind).sorted("id"))
        let last = retNext.lastObject
        if retNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
    
    func resetRemind() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Remind))
        }
    }
    
    func getRepeatDescription() -> String {
        var description = ""
        if monday {
            description += "周一 "
        }
        if tuesday {
            description += "周二 "
        }
        if wednesday {
            description += "周三 "
        }
        if thursday {
            description += "周四 "
        }
        if friday {
            description += "周五 "
        }
        if saturday {
            description += "周六 "
        }
        if sunday {
            description += "周日 "
        }
        if description == "" {
            return "不重复"
        } else {
            return description
        }
    }
}
