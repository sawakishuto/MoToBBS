//
//  Mypageview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct Mypageview: View {
    
    @ObservedObject private var viewModel = ViewModel()
    
    let  usersname:String
    init(viewModel: ViewModel = ViewModel(), usersname: String) {
        self.viewModel = viewModel
        self.usersname = usersname
    }
   
    
    
    var body: some View {
        VStack{
            Text(usersname)
            NavigationView{
//                List(viewModel.datamodel){datas in
//                NavigationLink(destination: detail(textname: datas.textname, whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig: datas.dateString, how: datas.how,id:datas.id)
//                               , label: {
//                    row(textname: datas.textname, whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig:datas.dateString, how: datas.how)
//                })
//            }
        }
            
        }.onAppear(){
            self.viewModel.getUser()
            print(viewModel)
            
            
            
        }
    }
    }
        
            


struct Mypageview_Previews: PreviewProvider {
    static var previews: some View {
        Mypageview(usersname: "tekisuto")
    }
}
