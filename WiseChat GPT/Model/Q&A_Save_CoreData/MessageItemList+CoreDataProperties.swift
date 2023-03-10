//
//  MessageItemList+CoreDataProperties.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 8/3/23.
//
//

import Foundation
import CoreData


extension MessageItemList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageItemList> {
        return NSFetchRequest<MessageItemList>(entityName: "MessageItemList")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var question: String?
    @NSManaged public var answer: String?

}

extension MessageItemList : Identifiable {
    
}
