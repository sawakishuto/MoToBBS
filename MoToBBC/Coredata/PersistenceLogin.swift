//
//  Persistence.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/15.
//

import Foundation

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // MARK: 下2行はEntityの設定によって違う
        let newLoginInfo = LoginInfo(context: viewContext)
        newLoginInfo.mail = ""
        newLoginInfo.pass = ""
        let newAttendList = AttendList(context: viewContext)
        newAttendList.attendId = ""
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // MARK: 下1行はEntityの設定によって違う
        container = NSPersistentContainer(name: "LoginInfo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
