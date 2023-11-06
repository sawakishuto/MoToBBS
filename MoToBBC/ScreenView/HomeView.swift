//
//  Alltabview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI
import UIKit
// swiftlint:disable line_length
struct HomeView: View {
    @ObservedObject private var viewModel = ViewModel()
    init() {
        let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 1)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        appearance.stackedLayoutAppearance.normal.iconColor = .white // 未選択のアイコンの色
               appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    var body: some View {
        TabView {
            // --- ここから ---
            // タブ内に表示するビュー
            EventListView()
            // 実際には Text を使うのではなく、カスタムビューとなる
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("掲示板").foregroundColor(.white)
                    }
                    // タブのラベル部分のビュー
                }
            JoinListView()
                .tabItem {
                    VStack {
                        Image(systemName: "figure.wave")
                        Text("参加予定").foregroundColor(.white)
                    }
                }
            // --- ここまで ---
            // --- ここから ---
            // タブ内に表示するビュー
            Mypageview(whereis: "",
                       detail: "",
                       title: "",
                       dateStrig: "",
                       how: "",
                       username: "",
                       usercomment: "",
                       bikename: "",
                       userid: "",
                       endTimeString: "")
                .tabItem {
                    VStack {
                    // タブのラベル部分のビュー
                    Image(systemName: "person.crop.circle.fill")
                    Text("マイページ")
                            .foregroundColor(.white)
                    }
                }
                }
        .accentColor(Color.black)
        }
    }

struct Alltabview_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
