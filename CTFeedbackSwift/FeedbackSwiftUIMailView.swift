//
//  FeedbackMailView.swift
//  TopChurch
//
//  Created by minghui on 2022/9/29.
//

import SwiftUI
import MessageUI

@available(iOS 13.0, *)
struct MailView: UIViewControllerRepresentable {
    
    var username: String
    @Binding var isPresented: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isPresented,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        // TODO: Configure mail content
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

@available(iOS 13.0, *)
struct MailViewDemo: View {
    @State var isPresented = false
    @State var username = "demo"
    @State var result: Result<MFMailComposeResult, Error>?
    
    var body: some View {
        VStack {
            Button {
                isPresented.toggle()
            } label: {
                Text("Mail")
            }
            .sheetMailView(isPresented: $isPresented, username: username)
        }
    }
}

@available(iOS 13.0, *)
struct MailViewDemo_Preview: PreviewProvider {
    static var previews: some View {
        MailViewDemo()
    }
}

@available(iOS 13.0, *)
extension View {
    func sheetMailView(isPresented: Binding<Bool>, username: String,
                             result: Binding<Result<MFMailComposeResult, Error>?> = .constant(nil),
                             _ onDismiss: (()->Void)? = nil) -> some View {
        self
            .sheet(isPresented: isPresented) {
                onDismiss?()
            } content: {
                MailView(username: username, isPresented: isPresented, result: result)
            }
    }
}

