//
//  LoginInfo+CoreDataProperties.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/15.
//
//

import Foundation
import CoreData


extension LoginInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginInfo> {
        return NSFetchRequest<LoginInfo>(entityName: "LoginInfo")
    }

    @NSManaged public var mail: String?
    @NSManaged public var pass: String?

}

