//
//  FeedbackView.swift
//  TopChurch
//
//  Created by minghui on 2022/9/29.
//

import SwiftUI
import MessageUI

@available(iOS 14.0, *)
public struct FeedbackSwiftUIView: View {
    public init(title: String = "CTFeedback.Feedback") {
        self.title = CTLocalizedString(title)
        self.configuration = FeedbackConfiguration(subject: "Subject",
                                                   additionalDiagnosticContent: "\nAdditional",
                                                   topics: TopicItem.defaultTopics,
                                                   toRecipients: ["to@example.com"],
                                                   ccRecipients: ["cc@example.com"],
                                                   bccRecipients: ["bcc@example.com"],
                                                   usesHTML: false)
    }
    
    var title: String
    var configuration: FeedbackConfiguration
    @State private var topic : Topic = .Question
    @State private var message: String = ""
    @State private var image: UIImage?
    @State private var isMailPresented = false
    @State private var mailResult: Result<MFMailComposeResult, Error>?
//    @State private var alert:
    
    @State private var isActionPresented: Bool = false
    @State private var isImagePickerPresented: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    enum Topic: String, CaseIterable {
        case Question = "Question"
        case Request  = "Request"
        case Bug      = "Bug Report"
        case Others   = "Other"
    }
    
    public var body: some View {
        List {
            Section {
                HStack {
                    Text(CTLocalizedString("CTFeedback.Topic"))
                        .foregroundColor(.primary)
                    Spacer()
                    Picker("", selection: $topic) {
                        ForEach(Topic.allCases, id: \.self) { value in
                            Text(CTLocalizedString(value.rawValue))
                                .tag(value)
                        }
                    }
                }
                
                TextEditor(text: $message)
                    .background(
                        Text(CTLocalizedString("CTFeedback.BodyPlaceholder"))
                            .foregroundColor(.secondary)
                            .opacity(message.isEmpty ? 1 : 0)
                        , alignment: .center
                    )
            } header: {
                Text(CTLocalizedString("CTFeedback.UserDetail"))
            }
            
            Section {
                Button {
                    isActionPresented = true
                } label: {
                    HStack {
                        Text(CTLocalizedString("CTFeedback.AttachImageOrVideo"))
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .actionSheet(isPresented: $isActionPresented) {
                    ActionSheet(title: Text("個人頭像"), buttons: actionButtons)
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePickerView(sourceType: sourceType) { image in
                        self.image = image
                    }
                }
            } header: {
                Text(CTLocalizedString("CTFeedback.AdditionalInfo"))
            }
            
            Section {
                ListRow(name: "CTFeedback.Device", value: DeviceNameItem().deviceName)
                ListRow(name: "CTFeedback.iOS", value: SystemVersionItem().version)
            } header: {
                Text(CTLocalizedString("CTFeedback.DeviceInfo"))
            }
            
            Section {
                ListRow(name: "CTFeedback.Name", value: AppNameItem(isHidden: false).name)
                ListRow(name: "CTFeedback.Version", value: AppVersionItem(isHidden: false).version)
                ListRow(name: "CTFeedback.Build", value: AppBuildItem(isHidden: false).buildString)
            } header: {
                Text(CTLocalizedString("CTFeedback.AppInfo"))
            }
        }
        .navigationTitle(title)
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem {
                mailButton
            }
        }
    }
    
    var mailButton: some View {
        Button {
            guard MFMailComposeViewController.canSendMail() else {
                return
            }
            isMailPresented = true
        } label: {
            Image(systemName: "paperplane")
        }
        .sheet(isPresented: $isMailPresented) {
            FeedbackSwiftUIMailView(feedback: generateFeedback(),
                                    isPresented: $isMailPresented,
                                    result: $mailResult)
        }
    }
    
    func generateFeedback() -> Feedback {
        do {
            let feedback = try FeedbackGenerator.generate(configuration: configuration, repository: configuration.dataSource)
            return feedback
        } catch {
            return Feedback(email: nil, to: [], cc: [], bcc: [], subject: "", body: "", isHTML: false, jpeg: nil, mp4: nil)
        }
    }
    
    var actionButtons: [ActionSheet.Button] {
        
        var buttons:[ActionSheet.Button] = []
        
        let library:ActionSheet.Button = .default(Text("選擇一張圖像")) {
            sourceType = .photoLibrary
            isImagePickerPresented = true
        }
        buttons.append(library)
        
        let photo:ActionSheet.Button = .default(Text("拍照")) {
            sourceType = .camera
            isImagePickerPresented = true
        }
        buttons.append(photo)
        
        if image != nil {
            let del:ActionSheet.Button = .default(Text("取消選取圖像")) {
                    image = nil
                }
            buttons.append(del)
        }
        
        buttons.append(.cancel(Text("取消")))
        
        return buttons
    }
}

@available(iOS 13.0, *)
enum FeedbackAlert {
    case canSendMail
    
    var alert: Alert {
        switch self {
        case .canSendMail:
            return .init(title: Text(CTLocalizedString("CTFeedback.Error")),
                         message: Text(CTLocalizedString("CTFeedback.MailConfigurationErrorMessage")))
        }
    }
}

@available(iOS 14.0, *)
extension FeedbackSwiftUIView {
    fileprivate func ListRow(name: String, value: String = "") -> some View {
        HStack {
            Text(CTLocalizedString(name))
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

@available(iOS 14.0, *)
struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedbackSwiftUIView()
        }
    }
}
