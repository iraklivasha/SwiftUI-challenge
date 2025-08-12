//
//  MovieListItemView.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import SwiftUI
struct MovieListItemView: View {
    var imageUrl: URL
    var title: String
    var releaseYear: String
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            WebImage.init(
                url: imageUrl,
                contentMode: .fit,
                size: CGSize(width: 60, height: 90),
                placeholder: {
                    Color.gray.opacity(0.1)
                }
            )
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(releaseYear)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
#Preview {
    MovieListItemView(
        imageUrl: URL(string: "https://example.com/poster.jpg")!,
        title: "Inception",
        releaseYear: "2010"
    )
}
