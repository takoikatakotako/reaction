import SwiftUI

struct CommonImageViewer: View {
    let imageName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topLeading) {
            ImageViewer(imageName: imageName)
                .padding(8)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.top, 16)
                    .padding(.leading, 16)
            }
        }
    }
}

// if support iOS17 later Only, use this.
// https://www.hackingwithswift.com/quick-start/swiftui/how-to-handle-pinch-to-zoom-for-views

struct ImageViewer: UIViewRepresentable {
    let imageName: String

    func makeUIView(context: Context) -> UIImageViewerView {
        let view = UIImageViewerView(imageName: imageName)
        return view
    }

    func updateUIView(_ uiView: UIImageViewerView, context: Context) {}
}

import UIKit

public class UIImageViewerView: UIView {
    private let imageName: String
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: UIImageView = UIImageView()

    required init(imageName: String) {
        self.imageName = imageName
        super.init(frame: .zero)

        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        // if you want to disable indicater
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)

        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        imageView.frame = scrollView.frame
    }
}

extension UIImageViewerView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
