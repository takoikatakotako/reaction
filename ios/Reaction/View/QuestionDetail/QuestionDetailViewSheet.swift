import Foundation

enum QuestionDetailViewSheet: Identifiable {
    var id: Int {
        switch self {
        case .imageViewer(imageName: let imageName):
            return imageName.hashValue
        }
    }
    
    case imageViewer(imageName: String)
}
