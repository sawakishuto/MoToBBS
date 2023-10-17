//
//  ReportDetailView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/17.
//

import SwiftUI

struct ReportDetailView: View {
    @State private var selectReport: String = ""
    @State private var isShowMailView:Bool = false
    @State var eventid: String = ""
    var body: some View {
        Button {
            isShowMailView = true
        } label: {
            Text("送信")
        }
        .sheet(isPresented: $isShowMailView) {
            MailView(
                address: ["swkshuto0208@icloud.com"],
                subject: "【MoToBB】報告",
                messageBody: "このメールはそのまま送信してください。\nID：\(eventid)のユーザについて\nこのユーザーの投稿には、の内容が見られたため報告します。"
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ReportDetailView()
}
