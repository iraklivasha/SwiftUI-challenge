//
//  WebImageOptions.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//


import SwiftUI
import SDWebImageSwiftUI
public struct WebImageOptions: OptionSet {

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int

    public static let cancelOnDisappear = WebImageOptions(rawValue: 1 << 0)
    public static let templateRendering = WebImageOptions(rawValue: 1 << 1)
}

public struct WebImage<P: View>: View {

    private let url: URL
    private let contentMode: ContentMode
    private let alignment: Alignment
    private let options: WebImageOptions
    private let onSuccess: () -> Void
    @ViewBuilder private let placeholder: () -> P
    @Environment(\.displayScale) private var scale
    @State private var viewSize: CGSize?
    public init(
        url: URL,
        contentMode: ContentMode,
        alignment: Alignment = .center,
        size: CGSize? = nil,
        options: WebImageOptions = [],
        onSuccess: @escaping () -> Void = { /* no-op */ },
        @ViewBuilder placeholder: @escaping () -> P
    ) {
        self.url = url
        self.contentMode = contentMode
        self.alignment = alignment
        if let size {
            self._viewSize = State(initialValue: size)
        }
        self.options = options
        self.onSuccess = onSuccess
        self.placeholder = placeholder
    }
    public init(
        url: URL,
        contentMode: ContentMode,
        alignment: Alignment = .center,
        size: CGSize? = nil,
        options: WebImageOptions = [],
        onSuccess: @escaping () -> Void = { /* no-op */ }
    ) where P == Color {
        self.url = url
        self.contentMode = contentMode
        self.alignment = alignment
        if let size {
            self._viewSize = State(initialValue: size)
        }
        self.options = options
        self.onSuccess = onSuccess
        self.placeholder = { .secondary }
    }

    public var body: some View {
        Rectangle()
            .fill(.clear)
            .background {
                if viewSize == nil {
                    GeometryReader { proxy in
                        SwiftUI.Color.clear
                            .onAppear {
                                viewSize = proxy.size
                            }
                    }
                }
            }
            .overlay(alignment: alignment) {
                if let viewSize {
                    SDWebImageSwiftUI.WebImage(
                        url: url,
                        content: { image in
                            switch contentMode {
                            case .fit:
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .onAppear(perform: onSuccess)
                            case .fill:
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .onAppear(perform: onSuccess)
                            }
                        },
                        placeholder: placeholder
                    )
                }
            }
    }
}
