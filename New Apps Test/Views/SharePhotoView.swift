//
//  SharePhotoView.swift
//  New Apps Test
//
//  Created by Michel-Andre Chirita on 28/06/2024.
//

/*
 --------------------------------------------------
 -- Voodoo New Apps Tech Test
 -- BOOSTRAP FILE
 -- Feel free to modify or dismiss it as you like !
 --------------------------------------------------
 */

import SwiftUI
import PhotosUI

struct ChallengeSubmissionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var imageData: Data?
    private let completionAction: (Data) -> Void
    
    init(onSubmit: @escaping (Data) -> Void) {
        self.completionAction = onSubmit
    }
    
    var body: some View {
        VStack(spacing: 24) {
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            Spacer()
            
            if selectedImage == nil {
                PhotosPicker("Prendre une photo", selection: $pickerItem, matching: .images)
                    .buttonStyle(.bordered)
            }
            
            Button(action: submitPhoto) {
                Label("Valider ma participation", systemImage: "checkmark")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(selectedImage == nil)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .onChange(of: pickerItem) { loadSelectedPhoto() }
    }
    
    private func loadSelectedPhoto() {
        Task {
            selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            
            if let data = try await pickerItem?.loadTransferable(type: Data.self) {
                imageData = data
            }
        }
    }
    
    private func submitPhoto() {
        guard let data = imageData else { return }
        completionAction(data)
        dismiss()
    }
}

#Preview {
    ChallengeSubmissionView { _ in }
}
