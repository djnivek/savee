//
//  ChallengeSubmissionView.swift
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
    @Binding var isPresented: Bool
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var imageData: Data?
    let onSubmit: (Data) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                photoPlaceholder
            }
            
            submitButton
        }
        .padding()
        .onChange(of: pickerItem) { loadSelectedPhoto() }
    }
    
    private var photoPlaceholder: some View {
        PhotosPicker(selection: $pickerItem, matching: .images) {
            VStack(spacing: 16) {
                Image(systemName: "camera.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                
                Text("Tap to take your photo!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var submitButton: some View {
        Button(action: submitPhoto) {
            Label("Submit my masterpiece!", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedImage != nil ? Color.accentColor : .gray.opacity(0.3))
                )
                .foregroundColor(selectedImage != nil ? .white : .secondary)
        }
        .disabled(selectedImage == nil)
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
        onSubmit(data)
        isPresented = false
    }
}

#Preview {
    ChallengeSubmissionView(isPresented: .constant(true)) { _ in }
}
