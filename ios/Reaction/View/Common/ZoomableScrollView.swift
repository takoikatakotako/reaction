import SwiftUI
import Combine

struct ZoomableScrollView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    @State var doubleTap = PassthroughSubject<Void, Never>()

    var body: some View {
        ZoomableScrollViewImpl(content: content, doubleTap: doubleTap.eraseToAnyPublisher())
            .onTapGesture(count: 2) {
                doubleTap.send()
            }
    }
}

private struct ZoomableScrollViewImpl<Content: View>: UIViewControllerRepresentable {
    let content: Content
    let doubleTap: AnyPublisher<Void, Never>

    func makeUIViewController(context: Context) -> ViewController {
        return ViewController(coordinator: context.coordinator, doubleTap: doubleTap)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: self.content))
    }

    func updateUIViewController(_ viewController: ViewController, context: Context) {
        viewController.update(content: self.content, doubleTap: doubleTap)
    }

    class ViewController: UIViewController, UIScrollViewDelegate {
        let coordinator: Coordinator
        let scrollView = UIScrollView()

        var doubleTapCancellable: Cancellable?
        var updateConstraintsCancellable: Cancellable?

        private var hostedView: UIView { coordinator.hostingController.view! }

        private var contentSizeConstraints: [NSLayoutConstraint] = [] {
            willSet { NSLayoutConstraint.deactivate(contentSizeConstraints) }
            didSet { NSLayoutConstraint.activate(contentSizeConstraints) }
        }

        required init?(coder: NSCoder) { fatalError() }
        init(coordinator: Coordinator, doubleTap: AnyPublisher<Void, Never>) {
            self.coordinator = coordinator
            super.init(nibName: nil, bundle: nil)
            self.view = scrollView

            scrollView.delegate = self
            scrollView.maximumZoomScale = 5
            scrollView.minimumZoomScale = 1
            scrollView.bouncesZoom = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.contentInsetAdjustmentBehavior = .never

            coordinator.hostingController.safeAreaRegions = []
            let hostedView = coordinator.hostingController.view!
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            hostedView.backgroundColor = .clear
            scrollView.addSubview(hostedView)
            NSLayoutConstraint.activate([
                hostedView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
                hostedView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
                hostedView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                hostedView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            ])

            updateConstraintsCancellable = scrollView.publisher(for: \.bounds).map(\.size).removeDuplicates()
                .sink { [unowned self] _ in
                    view.setNeedsUpdateConstraints()
                }
            doubleTapCancellable = doubleTap.sink { [unowned self] in handleDoubleTap() }
        }

        func update(content: Content, doubleTap: AnyPublisher<Void, Never>) {
            coordinator.hostingController.rootView = content
            scrollView.setNeedsUpdateConstraints()
            doubleTapCancellable = doubleTap.sink { [unowned self] in handleDoubleTap() }
        }

        func handleDoubleTap() {
            if scrollView.zoomScale > scrollView.minimumZoomScale {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            } else {
                scrollView.setZoomScale(2.5, animated: true)
            }
        }

        override func updateViewConstraints() {
            super.updateViewConstraints()
            let hostedContentSize = coordinator.hostingController.sizeThatFits(in: CGSize(
                width: view.bounds.width,
                height: UIView.layoutFittingExpandedSize.height
            ))
            contentSizeConstraints = [
                hostedView.widthAnchor.constraint(equalToConstant: max(hostedContentSize.width, view.bounds.width)),
                hostedView.heightAnchor.constraint(equalToConstant: hostedContentSize.height),
            ]
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            scrollView.contentOffset = .zero
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostedView
        }
    }

    class Coordinator: NSObject {
        var hostingController: UIHostingController<Content>

        init(hostingController: UIHostingController<Content>) {
            self.hostingController = hostingController
        }
    }
}
