//
//  SplashScreen.swift
//  DiscoverKR
//

import SwiftUI

struct SplashScreen: View {
    @Binding var showSplashScreen: Bool

    @State private var contentVisible = false
    @State private var minimumTimePassed = false

    var body: some View {
        ZStack {
            Color(red: 0.42, green: 0.35, blue: 0.55)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)

                VStack(spacing: 6) {
                    Text("Discover KR")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Explore Beautiful Korea")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                }
            }
            .scaleEffect(contentVisible ? 1 : 0.82)
            .opacity(contentVisible ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // 다음 런루프에서 애니메이션 실행 (레이아웃 완료 후)
            DispatchQueue.main.async {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.72)) {
                    contentVisible = true
                }
            }
            // 최소 표시 시간 0.8초
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                minimumTimePassed = true
                if AppLoadingState.shared.firstImageLoaded {
                    showSplashScreen = false
                }
            }
        }
        .onReceive(AppLoadingState.shared.$firstImageLoaded) { loaded in
            guard loaded, minimumTimePassed else { return }
            showSplashScreen = false
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(showSplashScreen: .constant(true))
    }
}
