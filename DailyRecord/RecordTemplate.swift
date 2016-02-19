//
//  RecordTemplate.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/14.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import Foundation
import RealmSwift

class RecordTemplate: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var id = 0
    dynamic var title = ""
    dynamic var type = ""
    dynamic var content = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    func resetTemplate() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(RecordTemplate))
            realm.add(RecordTemplate(value: [1, "杀生", "黑业", "杀生"]))
            realm.add(RecordTemplate(value: [2, "偷盗", "黑业", "偷盗"]))
            realm.add(RecordTemplate(value: [3, "邪淫", "黑业", "邪淫"]))
            realm.add(RecordTemplate(value: [4, "妄语", "黑业", "妄语"]))
            realm.add(RecordTemplate(value: [5, "绮语", "黑业", "绮语"]))
            realm.add(RecordTemplate(value: [6, "两舌", "黑业", "两舌"]))
            realm.add(RecordTemplate(value: [7, "恶口", "黑业", "恶口"]))
            realm.add(RecordTemplate(value: [8, "贪欲", "黑业", "贪欲"]))
            realm.add(RecordTemplate(value: [9, "嗔恚", "黑业", "嗔恚"]))
            realm.add(RecordTemplate(value: [10, "愚痴", "黑业", "愚痴"]))
            realm.add(RecordTemplate(value: [11, "放生", "白业", "放生"]))
            realm.add(RecordTemplate(value: [12, "布施", "白业", "布施"]))
            realm.add(RecordTemplate(value: [13, "梵行", "白业", "梵行"]))
            realm.add(RecordTemplate(value: [14, "诚实语", "白业", "诚实语"]))
            realm.add(RecordTemplate(value: [15, "和诤语", "白业", "和诤语"]))
            realm.add(RecordTemplate(value: [16, "爱软语", "白业", "爱软语"]))
            realm.add(RecordTemplate(value: [17, "质直语", "白业", "质直语"]))
            realm.add(RecordTemplate(value: [18, "无贪", "白业", "无贪"]))
            realm.add(RecordTemplate(value: [19, "无嗔", "白业", "无嗔"]))
            realm.add(RecordTemplate(value: [20, "无痴", "白业", "无痴"]))
        }
    }
}
