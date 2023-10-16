//
//  PersistanceAttend.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/16.
//
import Foundation

import CoreData
struct PersistenceControllerattend {
    static let shared = PersistenceControllerattend()
    static var preview: PersistenceControllerattend = {
        let result = PersistenceControllerattend(inMemory: true)
        let viewContext = result.containers.viewContext
        // MARK: 下2行はEntityの設定によって違う
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

    let containers: NSPersistentContainer

    init(inMemory: Bool = false) {
        // MARK: 下1行はEntityの設定によって違う
        containers = NSPersistentContainer(name: "AttendList")
        if inMemory {
            containers.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        containers.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        containers.viewContext.automaticallyMergesChangesFromParent = true
    }
}
