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
            WebImageViewer(url: url, isDarkMode: isDarkMode)

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
        .background(Color.black)
    }
}

struct WebImageViewer: UIViewRepresentable {
    let url: URL
    let isDarkMode: Bool

    func makeUIView(context: Context) -> UIWebImageViewerView {
        let view = UIWebImageViewerView(url: url, isDarkMode: isDarkMode)
        return view
    }

    func updateUIView(_ uiView: UIWebImageViewerView, context: Context) {}
}

class UIWebImageViewerView: UIView {
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let isDarkMode: Bool

    init(url: URL, isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
        super.init(frame: .zero)

        scrollView.delegate = self
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesZoom = true
        addSubview(scrollView)

        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        activityIndicator.color = .white
        activityIndicator.startAnimating()
        addSubview(activityIndicator)

        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                switch result {
                case .success(let value):
                    var image = value.image
                    if self.isDarkMode {
                        if let ciImage = CIImage(image: image),
                           let filter = CIFilter(name: "CIColorInvert") {
                            filter.setValue(ciImage, forKey: kCIInputImageKey)
                            let context = CIContext()
                            if let outputImage = filter.outputImage,
                               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                                image = UIImage(cgImage: cgImage)
                            }
                        }
                    }
                    self.imageView.image = image
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
