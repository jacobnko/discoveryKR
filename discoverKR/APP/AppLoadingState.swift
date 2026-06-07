//
//  AppLoadingState.swift
//  DiscoverKR
//
//  RemoteImage 에서 첫 이미지 로드 완료 시 splash dismiss 트리거
//

import Combine
import Foundation

final class AppLoadingState: ObservableObject {
    static let shared = AppLoadingState()
    private init() {}

    @Published private(set) var firstImageLoaded = false

    func markFirstImageLoaded() {
        guard !firstImageLoaded else { return }
        DispatchQueue.main.async { self.firstImageLoaded = true }
    }
}
