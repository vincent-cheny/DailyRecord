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
    dynamic var title = ""
    dynamic var type = ""
    dynamic var content = ""
    
    func resetTemplate() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(RecordTemplate))
            realm.add(RecordTemplate())
            realm.add(RecordTemplate(value: ["杀生", "黑业", "杀生"]))
            realm.add(RecordTemplate(value: ["偷盗", "黑业", "偷盗"]))
            realm.add(RecordTemplate(value: ["邪淫", "黑业", "邪淫"]))
            realm.add(RecordTemplate(value: ["妄语", "黑业", "妄语"]))
            realm.add(RecordTemplate(value: ["绮语", "黑业", "绮语"]))
            realm.add(RecordTemplate(value: ["两舌", "黑业", "两舌"]))
            realm.add(RecordTemplate(value: ["恶口", "黑业", "恶口"]))
            realm.add(RecordTemplate(value: ["贪欲", "黑业", "贪欲"]))
            realm.add(RecordTemplate(value: ["嗔恚", "黑业", "嗔恚"]))
            realm.add(RecordTemplate(value: ["愚痴", "黑业", "愚痴"]))
            realm.add(RecordTemplate(value: ["放生", "白业", "放生"]))
            realm.add(RecordTemplate(value: ["布施", "白业", "布施"]))
            realm.add(RecordTemplate(value: ["梵行", "白业", "梵行"]))
            realm.add(RecordTemplate(value: ["诚实语", "白业", "诚实语"]))
            realm.add(RecordTemplate(value: ["和诤语", "白业", "和诤语"]))
            realm.add(RecordTemplate(value: ["爱软语", "白业", "爱软语"]))
            realm.add(RecordTemplate(value: ["质直语", "白业", "质直语"]))
            realm.add(RecordTemplate(value: ["无贪", "白业", "无贪"]))
            realm.add(RecordTemplate(value: ["无嗔", "白业", "无嗔"]))
            realm.add(RecordTemplate(value: ["无痴", "白业", "无痴"]))
            NSLog(realm.path)
        }
    }
}
