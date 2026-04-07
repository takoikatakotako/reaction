import SwiftUI
import Kingfisher

struct CommonWebImageViewer: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        return colorScheme == .dark
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            WebImageViewer(url: url)
                .colorInvert(isDarkMode)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.white, .black.opacity(0.5))
                    .padding(.top, 16)
                    .padding(.leading, 16)
            }
        }
        .background(isDarkMode ? Color.black : Color.white)
    }
}

private extension View {
    @ViewBuilder
    func colorInvert(_ apply: Bool) -> some View {
        if apply {
            self.colorInvert()
        } else {
            self
        }
    }
}

struct WebImageViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> UIWebImageViewerView {
        let view = UIWebImageViewerView(url: url)
        return view
    }

    func updateUIView(_ uiView: UIWebImageViewerView, context: Context) {}
}

class UIWebImageViewerView: UIView {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(url: URL) {
        super.init(frame: .zero)

        backgroundColor = .white

        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesZoom = true
        addSubview(scrollView)

        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        addSubview(activityIndicator)

        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                    self.setNeedsLayout()
                case .failure:
                    break
                }
            }
        }

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        imageView.frame = scrollView.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let point = gesture.location(in: imageView)
            let size = CGSize(
                width: scrollView.bounds.width / 2.5,
                height: scrollView.bounds.height / 2.5
            )
            let origin = CGPoint(
                x: point.x - size.width / 2,
                y: point.y - size.height / 2
            )
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }
}

extension UIWebImageViewerView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
