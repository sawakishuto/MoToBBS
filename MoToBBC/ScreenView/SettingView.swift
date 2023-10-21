//
//  SettingView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/17.
//

import SwiftUI
import CoreData

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = ViewModel()
    @ObservedObject private var loginViewModel = LoginViewModel()
    @State private var showsheet:Bool = false
    @FetchRequest(
        entity: AttendList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "attendId", ascending: false)],
        animation: .default
    ) var fetchedInfom: FetchedResults<AttendList>
    @State private var showAlert: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("アカウント設定")
                    .foregroundStyle(.red)
                    .fontWeight(.black)
                    .font(.system(size: 35))
                    .padding(.bottom, 200)
                Divider()
                Button{self.showsheet.toggle()}label: {
                    Text("ブロック一覧")
                    .foregroundStyle(.black)}
                .sheet(isPresented: $showsheet){
                    BlockListView()
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
                                    dismiss()
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
