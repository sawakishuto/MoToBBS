//
//  MoToBBCApp.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleMobileAds
class AppDelegate: NSObject, UIApplicationDelegate {
func application(_ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
    let handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        if let user = user {
            // ユーザーがログイン済み
            print("Automatic sign-in succeeded: \(user.uid)")
            
            // ログイン済みユーザー用の画面を表示
        } else {
            // ユーザーは未ログイン
            print("No user is signed in")


            // 未ログインユーザー用の画面を表示
        }
    }
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
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
