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
    @ObservedObject private var viewModel = ViewModels()
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
    let endTimeString: String
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
        userid: String,
        endTimeString: String

    ) {
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.endTimeString = endTimeString
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
                        Text(fetchusercomment)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .padding(.trailing, 20)
                    }
                    HStack {
                        Text("車種:" + fetchbikename)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Spacer()

                        Button("車種変更") {
                            self.showsheet.toggle()
                        }
                        .foregroundStyle(.white)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        .background(.red)
                        .cornerRadius(20)
                        .fontWeight(.bold)
                        .shadow(radius: 4)
                        .sheet(isPresented: $showsheet) {
                            ProfileSetView(username: fetchusername, bikename: fetchbikename)
                        }
                    }

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
                                endTimeString: datas.endTimeString,
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

                }
                AdMobBannerView()
                    .frame(height: 60)
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
            print(viewModel.datamodeluser.count)
        }
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
            userid: "",
            endTimeString: ""
        )
    }
}
