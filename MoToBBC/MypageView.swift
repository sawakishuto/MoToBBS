//
//  Mypageview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct Mypageview: View {
    
    @ObservedObject private var viewModel = ViewModel()
    
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    init(whereis:String,detail:String,title:String,dateStrig:String,how:String){
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        
    }
    
    var body: some View {
        VStack{
            
            NavigationView{
                List(viewModel.datamodel){datas in
                    NavigationLink(destination:MoToBBC.detail(eventid:datas.eventid,whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig: datas.dateString, how: datas.how)                               , label: {
                        row(whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig:datas.dateString, how: datas.how)
                    })
                }
              
                
            }.onAppear(){
                self.viewModel.getUser()
                print(viewModel)
                
                
                
                
            }
        }
    }
    
}


struct Mypageview_Previews: PreviewProvider {
    static var previews: some View {
        Mypageview(whereis: "", detail:"", title: "", dateStrig: "", how: "")
    }
}
