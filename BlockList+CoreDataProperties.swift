//
//  BlockList+CoreDataProperties.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/20.
//
//

import Foundation
import CoreData


extension BlockList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockList> {
        return NSFetchRequest<BlockList>(entityName: "BlockList")
    }

    @NSManaged public var blockList: String?


}

extension BlockList : Identifiable {

}
