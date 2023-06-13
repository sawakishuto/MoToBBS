//
//  JoinListView Card.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/05/27.
//

import SwiftUI

import SwiftUI

struct JoinListView_Card: View {
    @State private var userInfoArray: [[String]] = []
    @State private var isShowSelect = false
    @ObservedObject private var viewModel = ViewModel()
    @State var events: [Events] = []
    @State var alerttitle = "タイトル"
    @State var alertmessage = "メッセ"
    
    let eventid:String
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    init(eventid:String,whereis:String,detail:String,title:String,dateStrig:String,how:String){
        self.eventid = eventid
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how}
    
    
    
    var body: some View {
        ZStack(alignment:.bottom){
            
                VStack{
                 
                    ScrollView{
                        Text(title).font(.title)
                            .fontWeight(.bold)
                        
                        
                        Text("出発地点:" + whereis)
                        
                        Divider().background(Color.red)
                           
                        Text("開催日時:" + dateString + "頃")
                        Divider().background(Color.red)
                        
                        
                        
                        Text("募集人数:" + how + "人程度")
                        Divider().background(Color.red)
                        Text(detail)
                        Text("参加予定者").foregroundColor(.red) .fontWeight(.bold)
                        List(userInfoArray, id: \.self) { userInfo in
                            Text("名前: \(userInfo[0])\n車種: \(userInfo[2])\n性別: \(userInfo[1])　")
                                }.listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                            .background(Color.white)
                            .frame(height: 200)
                            .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing:0
                                                ))

                    }
                    
                }.frame(width:350,height:600)
                    .padding()
                    .background(.white)
                    .cornerRadius(18)
                    .clipped()
                    .shadow(color: .gray.opacity(0.7), radius: 10)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.red,lineWidth: 4))
            
            Text("ツーリング終了")
                .zIndex(3)
                .frame(width: 150,height: 60)
               
                .background(Capsule().fill(  Color(red: 50, green: 10 / 255, blue: 10 / 255)))
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing:180))
            
                .onTapGesture {
                    
alerttitle = "ツーリング終了"
alertmessage = "ツーリングを終了します。お疲れ様でした。"
                    isShowSelect.toggle()
                    self.viewModel.deleteEvent(eventid:eventid)
                    self.viewModel.findAndDeleteAttendee(documentInfo: eventid)
                    self.viewModel.fetchJoinedData() { (events) in
                                            self.events = events
                                        }
                }
            Text("キャンセル")
                .zIndex(3)
                .frame(width: 150,height: 60)
             
                .background(Capsule().fill(Color.gray))
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 180, bottom: 30, trailing:0))
                .onTapGesture {
                    alerttitle = "キャンセル"
                    alertmessage = "ツーリングをキャンセルしました。"
                    self.viewModel.findAndDeleteAttendee(documentInfo: eventid);                    isShowSelect.toggle()
                    self.viewModel.deleteEvent(eventid:eventid)
                    self.viewModel.fetchJoinedData() { (events) in
                        self.events = events
                                        }
                }
        }.onAppear(){ self.viewModel.fetchUserInfoFromAttendList(documentinfo: self.eventid) { userInfoArray in
            self.userInfoArray = userInfoArray
        }
        }

        .alert(isPresented: $isShowSelect){
            Alert(title:Text( alerttitle)
                  ,message: Text(alertmessage))
        }
    }
}

struct JoinListView_Card_Preview: PreviewProvider {
    static var previews: some View {
        JoinListView_Card( eventid: "", whereis: "三重県桑名市", detail: "今日は誰でも歓迎ですあああああああああああああああああああああああああああああああああああああああああああ", title: "誰でもツーリング",dateStrig:"Date()", how: "11")
    }
}
