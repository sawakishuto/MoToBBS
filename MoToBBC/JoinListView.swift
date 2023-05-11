//
//  joinview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct joinview: View {
    @ObservedObject private var viewModel = ViewModel()
    @State var events: [Events] = []
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
        self.how = how}
    
    var body: some View {
        NavigationView {
                  List(events, id: \.eventid) { event in
                      Text(event.title)
                  }
                  .navigationTitle("参加予定のイベント")
                  .onAppear {
                      self.viewModel.fetchJoinedData { (events) in
                          self.events = events
                      }
                  }
              }
          }
    }


struct joinview_Previews: PreviewProvider {
    static var previews: some View {
        joinview(whereis: "", detail: "", title: "", dateStrig: "", how: "")
    }
}
