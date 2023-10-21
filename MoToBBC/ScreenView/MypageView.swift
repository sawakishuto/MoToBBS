//
//  Mypageview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI
import CoreData

struct Mypageview: View {
    // swiftlint:disable line_length
    @State private var showsheet = false
    @ObservedObject private var viewModel = ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: BlockList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "blockList", ascending: false)],
        animation: .default
    ) var fetchedInfomation: FetchedResults<BlockList>

    @State  var image: UIImage? = nil
    @State var fetchusername: String = ""
    @State var fetchusercomment: String = ""
    @State var fetchbikename: String = ""
    let userid: String
    let  username: String
    let usercomment: String
    let bikename: String
    let  whereis: String
    let detail: String
    let title: String
    let dateString: String
    let how: String
    init(
        whereis: String,
        detail: String,
        title: String,
        dateStrig: String,
        how: String,
        username: String,
        usercomment: String,
        bikename: String,
        userid: String
    ) {
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        self.username = username
        self.usercomment = usercomment
        self.bikename = bikename
        self.userid = userid
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(fetchusername)
                            .font(.system(size: 30))
                            .fontWeight(.heavy)
                        Spacer()
                        Button("車種変更") {
                            self.showsheet.toggle()
                        }
                        .fontWeight(.bold)
                        .sheet(isPresented: $showsheet) {
                            ProfileSetView(username: fetchusername, bikename: fetchbikename)
                        }
                    }
                    HStack {
                        Text("車種:" + fetchbikename)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Spacer()
                        Text(fetchusercomment)
                    }
                    .font(.system(size: 20))
                }
                .foregroundColor(Color(red: 0.8, green: 0, blue: 0))
                .padding(.horizontal, 12)
                Rectangle()
                    .frame(height: 5)
                    .foregroundColor(Color.red)
                    .cornerRadius(40)
                    .opacity(0.5)
                    .padding(.horizontal, 3)
                Text(fetchusername + "が募集中")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                if viewModel.datamodeluser.isEmpty {
                    Text("現在募集中のイベントはありません。")
                        .fontWeight(.black)
                        .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        ForEach(viewModel.datamodeluser) {datas in
                            NavigationLink(destination: MytoringView(
                                eventid: datas.eventid,
                                whereis: datas.whereis,
                                detail: datas.detail,
                                title: datas.title,
                                dateStrig: datas.dateString,
                                how: datas.how
                            ), label: {
                                RowView(
                                    eventid: datas.eventid,
                                    whereis: datas.whereis,
                                    detail: datas.detail,
                                    title: datas.title,
                                    dateStrig: datas.dateString,
                                    how: datas.how,
                                    getimages: self.image
                                )
                            })
                        }
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity)
                        .background(Color.white) // 背景色を透明に設定
                    }
                    .refreshable {
                        viewModel.getUser()
                    }
                }
                Divider()
                NavigationLink {
                    SettingView()
                } label: {
                    Text("アカウント設定")
                        .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            // ViewController内の適切な位置に以下のコードを配置
            self.viewModel.fetchUserinfo {fetchedUsername, fetchedUsercomment, fetchedBikename in
                DispatchQueue.main.async {
                    fetchusername = fetchedUsername
                    fetchusercomment = fetchedUsercomment
                    fetchbikename = fetchedBikename
                }
            }
            viewModel.getUser()
        }
    }
    private func deleteBlock(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedInfomation[index])
        }
        // 保存を忘れない
        try? viewContext.save()
    }
}

struct Mypageview_Previews: PreviewProvider {
    static var previews: some View {
        Mypageview(
            whereis: "",
            detail: "",
            title: "",
            dateStrig: "",
            how: "",
            username: "",
            usercomment: "",
            bikename: "",
            userid: ""
        )
    }
}
