//
//  textandview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import SwiftUI
import FirebaseCore
import AudioToolbox
import CoreData

struct EventListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: BlockList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "blockList", ascending: false)],
        animation: .default
    ) var fetchedInfomation: FetchedResults<BlockList>
    @FetchRequest(
        entity: LoginInfo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "haveAccount", ascending: false)],
        animation: .default
    ) var fetchedInfo: FetchedResults<LoginInfo>
    // swiftlint:disable line_length
    @State private var eventExist: Bool = false
    @State var filterLocation: String = ""
    @State  var image: UIImage? = nil
    @State var bikename: String = ""
    @State var goodAlert = false
    @State private var showsheet = false
    @ObservedObject private var viewModel = ViewModels()
    @State private var filterText: String = ""
    init() {
        viewModel.fetchEvntList()
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing ) {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .top) {
                            Image("Image 1")
                                .frame(width: 420, height: 0, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                        }
                        .padding(EdgeInsets(top: 70, leading: 40, bottom: 0, trailing: 0))
                        .background(Color(red: 0.9, green: 0, blue: 0))
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .zIndex(10)
                        .edgesIgnoringSafeArea(.bottom)
                        ScrollView {
                            TextField("タイトル検索(アメリカン,SS)", text: $filterText)
                                .padding(.horizontal, 20)
                                .frame(width: 330, height: 33)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 3)
                                )
                                .overlay(content: {
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 300)
                                        .onTapGesture {
                                            filterText = ""
                                        }
                                })
                                .padding(.top, 20)
                            if viewModel.datamodel.filter({ data in
                                filterText.isEmpty ? data.title != "" : data.title.contains(filterText)
                            }).isEmpty {
                                VStack {
                                    Text("投稿が見つかりません")
                                        .fontWeight(.black)
                                        .frame(maxHeight: .infinity)
                                        .frame(maxWidth: .infinity)
                                    mobCard
                                }
                            } else {
                                VStack {
                                    cardList
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                                        .edgesIgnoringSafeArea(.top)
                                    mobCard
                                        .padding(.bottom, 30)

                                }
                                // 背景色を透明に設定
                            }

                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .edgesIgnoringSafeArea(.top)
                    .zIndex(100)
                    createPostButton
                        .zIndex(1000000)
                        .padding(.trailing, 30)
                        .alert(isPresented: $goodAlert, content: {
                            Alert(
                                title: Text("現在募集中のイベントを終了しましたか？"),
                                message: Text(""),
                                primaryButton: .destructive(Text("いいえ"),
                                                            action: {goodAlert = false}),
                                secondaryButton: .default(Text("はい"), action: {showsheet = true})
                            )
                        })
                        .sheet(isPresented: $showsheet) {
                            RecruitView(eventid: viewModel.getLoginUserCollectionDocId())
                        }
                }
            }
            //            .navigationBarTitle("現在募集中の掲示板")

            if fetchedInfo.first?.haveAccount == false {
                TutorialView()
                    .background(.gray.opacity(0.7))
            }
        }
        .onAppear {
            fetchedBlockList()
            viewModel.fetchEvntList()
            eventExist = viewModel.comformEvent()
           }


        .edgesIgnoringSafeArea(.top)
    }
    private func fetchedBlockList() {
        if fetchedInfomation.isEmpty {
            return
        } else {
            for value in fetchedInfomation {
                viewModel.blockedList.append(value.blockList ?? "None")
            }
        }
    }
}

extension EventListView {
    var cardList: some View {
        ForEach(viewModel.datamodel.filter(
            filterText.isEmpty ? {$0.title != ""}: {$0.title.contains(filterText)}
        )) { data in
            NavigationLink(
                destination: Detail(
                    eventid: data.eventid,
                    whereis: data.whereis,
                    detail: data.detail,
                    title: data.title,
                    dateStrig: data.dateString,
                    how: data.how,
                    documentinfo: data.eventid,
                    username: "",
                    usercomment: "",
                    bikename: "",
                    userid: "",
                    endTimeString: data.endTimeString
                ), label: {
                    RowView(
                        eventid: data.eventid,
                        whereis: data.whereis,
                        detail: data.detail,
                        title: data.title,
                        dateStrig: data.dateString,
                        how: data.how,
                        getimages: self.image
                    )
                }
            )
        }
    }
    var createPostButton: some View {
        Button(action: {
            eventExist = viewModel.comformEvent()
            if eventExist {
                goodAlert = true
            } else {
                showsheet = true
            }
        }, label: {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color(red: 30, green: 10 / 255, blue: 10 / 255))
                .frame(width: 100, height: 60)
                .font(.title)
                .background(Circle().fill(Color(red: 90, green: 90, blue: 90)))
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 5.0))
        }
        )
    }
    var mobCard: some View {
        AdMobBannerView()
            .frame(width: 350, height: 300)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.8), radius: 10)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red, lineWidth: 4))
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
