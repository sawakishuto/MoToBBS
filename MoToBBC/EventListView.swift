//
//  textandview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import SwiftUI
import FirebaseCore

struct textandview: View {
    @State var bikename:String = ""
    @State private var showsheet = false
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        ZStack(alignment:.bottomTrailing ){
            VStack{
                ZStack(alignment:.top){
                    
                    Image("Image 1").frame(width:420,height: 0,alignment: .leading).padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    
                    
                }
                .padding(EdgeInsets(top: 70, leading: 40, bottom: 0, trailing: 0))
                .background(Color(red: 0.9, green: 0
                                  , blue: 0))
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
                .zIndex(10)
                .edgesIgnoringSafeArea(.bottom)
                
                
                
                NavigationView{
                    List(viewModel.datamodel){data in
                        NavigationLink(destination: detail( eventid:data.eventid, whereis: data.whereis, detail: data.detail, title: data.title, dateStrig: data.dateString, how: data.how,documentinfo: data.eventid, username: "", usercomment: "", bikename: "", userid: "")
                                       , label: {
                            row(whereis: data.whereis, detail: data.detail, title: data.title, dateStrig:data.dateString, how: data.how)
                        })
                    }.listRowInsets(EdgeInsets())
                    .listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                    .background(Color.white)
                    .padding(EdgeInsets(top: 0, leading: 23, bottom: 10, trailing:0))
                    .edgesIgnoringSafeArea(.top)
                    
                    // 背景色を透明に設定
                   
                } 
                .edgesIgnoringSafeArea(.top)
                 
            }
                //            .navigationBarTitle("現在募集中の掲示板")
                Button(action: {
                    self.showsheet.toggle()
                }, label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(  Color(red: 30, green: 10 / 255, blue: 10 / 255))
                    
                        .frame(width: 100,height: 60)
                        .font(.title)
                        .background(Circle().fill(  Color(red: 90, green: 90 , blue: 90)))
                        .shadow(color: .gray, radius: 3, x: 3, y: 3)
                        
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 20.0))
                           
                    
                        
                    
                })
                .sheet(isPresented: $showsheet) {
                    RecruitView()
                }
        }.edgesIgnoringSafeArea(.top)
           
        .onAppear() {
                        self.viewModel.fetchData()
                }

    }
    
}
    




struct textandview_Previews: PreviewProvider {
    static var previews: some View {
        textandview()
    }
}
