//
//  FeedbackView.swift
//  TopChurch
//
//  Created by minghui on 2022/9/29.
//

import SwiftUI

@available(iOS 14.0, *)
public struct FeedbackSwiftUIView: View {
    public init(title: String = "CTFeedback.Feedback") {
        self.title = CTLocalizedString(title)
    }
    
    var title: String
    @State private var topic : Topic = .Question
    @State private var message: String = ""
    @State private var image: UIImage?
    
    enum Topic: String, CaseIterable {
        case Question = "Question"
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
                ListRow(name: "CTFeedback.AttachImageOrVideo", isButton: true)
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
        .toolbar {
            ToolbarItem {
                Button {
                    //
                } label: {
                    Image(systemName: "paperplane")
                }
            }
        }
    }
}

@available(iOS 14.0, *)
extension FeedbackSwiftUIView {
    fileprivate func ListRow(name: String, value: String = "", isButton: Bool = false) -> some View {
        HStack {
            Text(CTLocalizedString(name))
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
            if isButton {
                Image(systemName: "chevron.forward")
                    .foregroundColor(.secondary)
            }
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
