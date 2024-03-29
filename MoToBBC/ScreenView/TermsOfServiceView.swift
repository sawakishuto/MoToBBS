//
//  TermsOfService.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/07/14.
//

import SwiftUI
// swiftlint:disable line_length
struct TermsOfService: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("【MoToBBS】バイクツーリング募集アプリ \n利用規約").fontWeight(.bold).padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                Text("この利用規約（以下「本規約」といいます）は、バイクツーリング募集アプリ（以下「本アプリ」といいます）の利用条件を定めるものです。本アプリを利用することにより、以下の条件に同意したものとみなされます。本規約は、利用者（以下「ユーザー」といいます）と本アプリ運営者との間の契約を構成します。")
                Text("利用者の責任\n1.1 ユーザーは、本アプリを利用する際に提供する情報が正確かつ正当であることを保証するものとします。\n1.2 ユーザーは、本アプリを利用する際に適用される法律および規制に従う責任を負います。\n1.3 ユーザーは、他のユーザーや第三者の権利を侵害しないように注意し、公序良俗に反する行為を行わないものとします。")
                Spacer()
                Text("コンテンツの投稿\n2.1 ユーザーが本アプリ上に投稿するコンテンツ（テキスト、画像、リンクなど）については、ユーザー自身がその内容に責任を持つものとします。\n2.2 ユーザーは、著作権や商標権などの第三者の知的財産権を侵害しないように注意し、許可のないコンテンツの使用は避けるものとします。\n2.3 本アプリ運営者は、ユーザーが投稿したコンテンツについて、必要に応じて修正、削除、非表示化する権利を有します。")
                Text("ユーザー間の関係\n3.1 本アプリは、ユーザー間のコミュニケーションの手段を提供するものであり、本アプリ運営者はユーザー間の関係や取引において一切の責任を負わないものとします。\n3.2 ユーザーは、自己の責任において他のユーザーとのやり取りを行い、ツーリングの計画や取引に関して十分な注意を払うものとします。")
                Text("免責事項\n4.1 本アプリ運営者は、本アプリの利用により生じたいかなる損害に対しても一切の責任を負わないものとします。\n4.2 ユーザーは、本アプリ上の情報やコンテンツの利用に関して自己の判断と責任によるものとし、その結果について一切の責任を負うものとします。")
                Text(" 利用規約の変更\n 5.1 本アプリ運営者は、必要に応じて本規約を変更する権利を有します。変更後の規約は、本アプリ上での掲示をもって告知されたものとみなされます。")
                Text("その他\n6.1 本規約は、日本法に基づき解釈されるものとします。\n 6.2 本規約に定めのない事項や本規約の解釈に疑義が生じた場合は、本アプリ運営者の合理的な判断により解決されるものとします。")
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 0, trailing: 30))
        }
    }
}

struct TermsOfService_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfService()
    }
}
