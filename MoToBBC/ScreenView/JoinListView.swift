//  joinview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//
//
//  joinview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct JoinListView: View {
    @ObservedObject private var DataModel = DatasModel()
    @State var events: [Events] = []
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image("Image 1")
                    .frame(width: 420, height: 0, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
            }
            .padding(EdgeInsets(top: 23, leading: 40, bottom: 0, trailing: 0))
            .background(Color(red: 0.9, green: 0, blue: 0))
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.bold)
            .zIndex(10)
            .edgesIgnoringSafeArea(.bottom)
            
            if events.isEmpty {
                Text("参加予定のイベントはありません。")
                    .fontWeight(.black)
                    .frame(maxHeight: .infinity)
            } else {
                SlideView {
                    ForEach(events, id: \.eventid) { event in
                        
                        VStack(alignment: .leading) {
                            JoinListCard(eventid: event.eventid,
                                         whereis: event.whereis,
                                         detail: event.detail,
                                         title: event.title,
                                         dateStrig: event.dateString,
                                         endTimeString: event.endTimeString,
                                         how: event.how)
                        }
                        // カードのサイズを設定
                    }
                }
                .background(Color.white)
            }
        }
        .onAppear {
            self.DataModel.fetchJoinedData { (events) in
                self.events = events
            }
        }
    }
}
struct JoinListView_Previews: PreviewProvider {
    static var previews: some View {
        JoinListView()
        
    }
}
