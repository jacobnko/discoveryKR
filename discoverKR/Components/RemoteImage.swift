//
//  RemoteImage.swift
//  DiscoverKR
//
//  AsyncImage 대체 - URLSession 직접 사용, NSCache 포함
//

import SwiftUI

// MARK: - Cache
private final class ImageCache: @unchecked Sendable {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() { cache.countLimit = 300 }
    subscript(key: String) -> UIImage? {
        get { cache.object(forKey: key as NSString) }
        set { newValue.map { cache.setObject($0, forKey: key as NSString) } }
    }
}

// MARK: - RemoteImage
struct RemoteImage: View {
    let urlString: String
    var cornerRadius: CGFloat = 0
    var contentMode: ContentMode = .fill

    @State private var img: UIImage?
    @State private var failed = false

    var body: some View {
        ZStack {
            if let img {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity.animation(.easeIn(duration: 0.2)))
            } else if failed {
                ZStack {
                    Color.gray.opacity(0.15)
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.4))
                }
            } else {
                Color.gray.opacity(0.15)
                    .overlay(
                        ProgressView()
                            .tint(.gray.opacity(0.5))
                    )
            }
        }
        .cornerRadius(cornerRadius)
        .task(id: urlString) { await load() }
    }

    @MainActor
    private func load() async {
        img = nil; failed = false

        if let cached = ImageCache.shared[urlString] {
            img = cached; return
        }

        guard let url = URL(string: urlString) else { failed = true; return }

        do {
            var req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            req.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
            let (data, response) = try await URLSession.shared.data(for: req)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { failed = true; return }
            guard let loaded = UIImage(data: data) else { failed = true; return }
            ImageCache.shared[urlString] = loaded
            img = loaded
            AppLoadingState.shared.markFirstImageLoaded()
        } catch {
            failed = true
        }
    }
}
