//
//  AdMobBannerView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/11/03.
//

import SwiftUI
import UIKit // こちらも必要
import GoogleMobileAds // 忘れずに

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = "ca-app-pub-1411335577607360/7475222849" // 自身の広告IDに置き換える
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
      // 特にないのでメソッドだけ用意
    }
}
#Preview {
    AdMobBannerView()
}
