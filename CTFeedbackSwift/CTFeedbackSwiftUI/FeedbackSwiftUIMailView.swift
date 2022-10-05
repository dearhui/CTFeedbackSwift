//
//  FeedbackSwiftUIMailView.swift
//  TopChurch
//
//  Created by minghui on 2022/9/29.
//

import SwiftUI
import MessageUI

@available(iOS 13.0, *)
public struct FeedbackSwiftUIMailView: UIViewControllerRepresentable {
    var feedback: Feedback
    @Binding var isPresented: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    public func makeUIViewController(context: UIViewControllerRepresentableContext<FeedbackSwiftUIMailView>) -> MFMailComposeViewController {
        // Configure mail content with feedback
        // Copy Form FeedbackWireframe.swift
        let controller: MFMailComposeViewController = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setToRecipients(feedback.to)
        controller.setCcRecipients(feedback.cc)
        controller.setBccRecipients(feedback.bcc)
        controller.setSubject(feedback.subject)
        controller.setMessageBody(feedback.body, isHTML: feedback.isHTML)
        if let jpeg = feedback.jpeg {
            controller.addAttachmentData(jpeg, mimeType: "image/jpeg", fileName: "screenshot.jpg")
        } else if let mp4 = feedback.mp4 {
            controller.addAttachmentData(mp4, mimeType: "video/mp4", fileName: "screenshot.mp4")
        }
        
        return controller
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<FeedbackSwiftUIMailView>) {
        // do nothing
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isPresented, result: $result)
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
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
}

