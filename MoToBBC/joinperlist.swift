//
//  joinperlist.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/06/16.
//

import SwiftUI

struct joinperlist: View {
    
    
    @State private var userInfoArray: [[String]] = []
    @State var messa = "ツーリング終了！"
    @ObservedObject private var viewModel = ViewModel()
    
    @State  var datamodel = ViewModel().datamodel
    @State var isgo = false
    @State var pp:Int = 0
    @State var uid:String = ""
    @State var documentId = ""
    
    
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
        self.how = how
    }
    
    
    var body: some View {
        VStack{
            Text("参加予定者").foregroundColor(.red)
                .fontWeight(.bold)
                .font(.title)
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 50, trailing: 0))
            List(userInfoArray, id: \.self) { userInfo in
                Text("名前: \(userInfo[0])\n車種: \(userInfo[2])\n性別: \(userInfo[1])　")
            }.listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
        }       .onAppear(){
            
            self.viewModel.fetchUserInfoFromAttendList(documentinfo: self.eventid) { userInfoArray in
                self.userInfoArray = userInfoArray
            }
        }
    }
    
}




struct joinperlist_Previews: PreviewProvider {
    static var previews: some View {
        joinperlist(eventid: "", whereis: "", detail: "", title: "", dateStrig: "", how: "")
    }
}
