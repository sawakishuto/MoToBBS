//
//  ReportDetailView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/17.
//

import SwiftUI

struct ReportDetailView: View {
    @State private var selectReport: String = ""
    @State private var isShow:Bool = false
    @State var eventid: String = ""
    var body: some View {
        VStack(spacing: 20) {
            Text("どのような内容について報告しますか")
                .fontWeight(.black)
                .font(.title2)
            Divider()
            Text("スパム・宣伝目的")
                .onTapGesture {
                    selectReport = "スパム・宣伝目的"
                }
            Divider()
            Text("性的嫌がらせ・出会い目的")
                .onTapGesture {
                    selectReport = "性的嫌がらせ・出会い目的"
                }
            Divider()
            Text("他人に対して迷惑となる")
                .onTapGesture {
                    selectReport = "他人に対して迷惑となる"
                }
            Divider()
            Text("その他")
                .onTapGesture {
                    selectReport = "その他"
                }
            Divider()
            if selectReport.isEmpty {
                Text("上記から当てはまるものを選んでください")
                    .foregroundStyle(.black)
                    .fontWeight(.black)
                    .padding(.top, 62)
            } else {
                Button {
                    isShow = true
                } label: {
                    VStack{
                        Text(selectReport + "について報告")
                            .foregroundStyle(.black)
                            .fontWeight(.black)
                            .padding(.top, 40)
                        Text("送信")
                            .foregroundStyle(.red)
                            .fontWeight(.black)
                    }
                }
                .sheet(isPresented: $isShow) {
                    MailView(
                        address: ["swkshuto0208@icloud.com"],
                        subject: "【MoToBBS】報告",
                        messageBody: "このメールはそのまま送信してください。\nID：\(eventid)のユーザについて\nこのユーザーの投稿には、\(selectReport)の内容が見られたため報告します。"
                    )
                    .edgesIgnoringSafeArea(.all)
                }
            }

        }
    }
}

#Preview {
    ReportDetailView()
}
