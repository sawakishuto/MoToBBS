//
//  Alltabview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var viewModel = ViewModel()
    init() {
      UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().backgroundColor = UIColor(red: 0.9, green: 0 , blue: 0, alpha: 1)
    }
    var body: some View {
        TabView {
            // --- ここから ---
            // タブ内に表示するビュー
            textandview()
            // 実際には Text を使うのではなく、カスタムビューとなる
                .tabItem {
                    VStack{
                        Image(systemName:"person.3.fill"
                        )
                        Text("掲示板").foregroundColor(.white)
                    }
                    // タブのラベル部分のビュー
                    
                }
            joinview()
                .tabItem{
                    VStack{
                        Image(systemName: "figure.wave")
                        Text("参加予定").foregroundColor(.white)
                    }
                }
            // --- ここまで ---
            // --- ここから ---
            // タブ内に表示するビュー
            Mypageview(whereis: "", detail: "", title: "", dateStrig: "", how: "",username: "",usercomment: "",bikename: "", userid: "")
                .tabItem {VStack{
                    // タブのラベル部分のビュー
                    Image(systemName:"person.crop.circle.fill")
                    Text("マイページ").foregroundColor(.white)
                }
                    
                }
                }.accentColor(Color.black)
        }
            
    }



struct Alltabview_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
