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
        NavigationView {
                  List(events, id: \.eventid) { event in
                      Text(event.title)
                      Text("開催場所:" + event.whereis)
                      Text("詳細:" + event.detail)
                      Text(event.how + "人程度募集")
                      Text("開催予定日"+event.dateString)
                      
                      Text("ツーリング終了").onTapGesture {
                          print(eventid)
                          self.viewModel.deleteEvent(eventid: event.eventid)
                      }
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
        joinview(eventid: "", whereis: "", detail: "", title: "", dateStrig: "", how: "")
    }
}
