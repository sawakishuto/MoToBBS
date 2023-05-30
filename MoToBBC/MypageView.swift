//
//  Mypageview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct Mypageview: View {
    
    @ObservedObject private var viewModel = ViewModel()
    
    let username:String
    let usercomment:String
    let bikename:String
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    init(whereis:String,detail:String,title:String,dateStrig:String,how:String,username:String,usercomment:String,bikename:String){
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        self.username = username
        self.usercomment = usercomment
        self.bikename = bikename
        
    }
    
    var body: some View {
        
            VStack{
                Text("現在募集中のイベント")
                    .fontWeight(.bold)
                NavigationView{
                    List(viewModel.datamodeluser){datas in
                        NavigationLink(destination:MytoringView(eventid:datas.eventid,whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig: datas.dateString, how: datas.how)                               , label: {
                            row(whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig:datas.dateString, how: datas.how)
                        })
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing:-18))
                    .listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                    .background(Color.white) // 背景色を透明に設定
                    
                    
                    
                    
                }.navigationTitle(Text("募集中のイベント"))
                
            }
            .onAppear(){
                
                self.viewModel.getUser()
                print(viewModel.datamodeluser)
            }
        
        
    }
}


struct Mypageview_Previews: PreviewProvider {
    static var previews: some View {
        Mypageview(whereis: "", detail:"", title: "", dateStrig: "", how: "",username: "",usercomment: "",bikename: "")
    }
}
