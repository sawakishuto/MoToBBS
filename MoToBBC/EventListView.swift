//
//  textandview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/19.
//

import SwiftUI
import FirebaseCore

struct textandview: View {
    
    @State private var showsheet = false
    @ObservedObject private var viewModel = ViewModel()
 
    var body: some View {
        VStack{
            NavigationView{
                List(viewModel.datamodel){data in
                    NavigationLink(destination: detail( whereis: data.whereis, detail: data.detail, title: data.title, dateStrig: data.dateString, how: data.how,id:data.id)
                                   , label: {
                        row(whereis: data.whereis, detail: data.detail, title: data.title, dateStrig:data.dateString, how: data.how)
                    })
                }
                //  }
                //            .ignoresSafeArea()
                //            .navigationBarTitle("現在募集中の掲示板")
                Button("募集"){
                    self.showsheet.toggle()
                }.sheet(isPresented:$showsheet){
                    RecruitView()
                }
                
            }
            .onAppear() {
                self.viewModel.fetchData()
                
            }
            
        }
    }
    

}

struct textandview_Previews: PreviewProvider {
    static var previews: some View {
        textandview()
    }
}
