//
//  AttendList+CoreDataProperties.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/16.
//
//

import Foundation
import CoreData


extension AttendList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttendList> {
        return NSFetchRequest<AttendList>(entityName: "AttendList")
    }

    @NSManaged public var attendId: String?

}
