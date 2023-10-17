//
//  SettingView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/17.
//

import SwiftUI
import CoreData

struct SettingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = ViewModel()
    @ObservedObject private var loginViewModel = LoginViewModel()
    @FetchRequest(
        entity: AttendList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "attendId", ascending: false)],
        animation: .default
    ) var fetchedInfom: FetchedResults<AttendList>
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                NavigationLink {} label: {
                    Text("ブロック一覧")
                        .foregroundStyle(.black)
                }
                Divider()
                Text("アカウント削除")
                    .foregroundStyle(.red)
                    .onTapGesture {
                        showAlert = true
                    }
                    .alert(isPresented: $showAlert, content: {
                        Alert(
                            title: Text("アカウントを削除しますか？"),
                            message: Text("あなたのアカウントは完全に削除されます"),
                            primaryButton: .destructive(Text("いいえ"), action: {}),
                            secondaryButton: .default(Text("はい"), action: {
                                DispatchQueue.global().async {
                                    viewModel.deleteAccount()
                                }
                                DispatchQueue.main.async {
                                    loginViewModel.allview = false
                                }
                            } )
                        )
                    })
                Divider()
            }
        }
    }
}

#Preview {
    SettingView()
}
