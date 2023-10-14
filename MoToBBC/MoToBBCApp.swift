//
//  MoToBBCApp.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
class AppDelegate: NSObject, UIApplicationDelegate {
func application(_ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    return true
}
}
@main

struct MoToBBCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
         LoginView()
        }
    }
}
