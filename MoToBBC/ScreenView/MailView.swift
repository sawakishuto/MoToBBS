//
//  MailView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/10/17.
//

import SwiftUI
import MessageUI
import SwiftUI
import UIKit

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation

    var address: [String]

    var subject: String

    var messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode

        init(
            presentation: Binding<PresentationMode>
        ) {
            _presentation = presentation
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            $presentation.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation)
    }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients(address)
        viewController.setSubject(subject)
        viewController.setMessageBody(messageBody, isHTML: false)
        return viewController
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {}
}

