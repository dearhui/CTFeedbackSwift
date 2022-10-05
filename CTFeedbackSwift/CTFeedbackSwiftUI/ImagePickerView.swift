//
//  ImagePickerView.swift
//  ECO2
//
//  Created by minghui on 2021/8/23.
//

import SwiftUI

@available(iOS 13.0, *)
public struct ImagePickerView: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let allowsEditing: Bool
    private let onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode

    public init(sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = false, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
        self.allowsEditing = allowsEditing
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.allowsEditing = allowsEditing
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            allowsEditing: self.allowsEditing,
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let allowsEditing: Bool
        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void

        init(allowsEditing: Bool, onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.allowsEditing = allowsEditing
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if allowsEditing {
                if let image = info[.editedImage] as? UIImage {
                    self.onImagePicked(image)
                }
            } else {
                if let image = info[.originalImage] as? UIImage {
                    self.onImagePicked(image)
                }
            }
            
            self.onDismiss()
        }

        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }

    }

}
