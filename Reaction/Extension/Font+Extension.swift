import SwiftUI

extension Font {
    static func mPlus2Bold(size: CGFloat) -> Font {
        return Font.custom("M PLUS 2", size: size).weight(.bold)
    }
    
    static func mPlus2Medium(size: CGFloat) -> Font {
        return Font.custom("M PLUS 2", size: size).weight(.semibold)
    }
    
    
    static func mPlus2Regular(size: CGFloat) -> Font {
        return Font.custom("M PLUS 2", size: size).weight(.regular)
    }
}
