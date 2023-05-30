
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

struct joinview: View {
    
    @ObservedObject private var viewModel = ViewModel()
    @State var events: [Events] = []
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 70) {
                    ForEach(events, id: \.eventid) { event in
                        VStack(alignment: .leading) {
                            JoinListView_Card(eventid: event.eventid, whereis: event.whereis, detail: event.detail, title: event.title, dateStrig: event.dateString, how: event.how)
                        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing:0
                                            ))
                        .frame(width: 350, height: 600) // カードのサイズを設定
                    }
                }
                .padding()
            }
            .background(Color.white)
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
        joinview()
    }
}
