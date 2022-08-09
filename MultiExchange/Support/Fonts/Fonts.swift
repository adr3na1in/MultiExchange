import UIKit

final class Fonts {
    enum `Type`: String {
       case neon = "Neonblitz"
//       case sfpro = "SF-Pro-Display-Semibold"

    }
    enum Size: Int {
        case small = 12
        case semiMedium = 14
        case medium = 32
        case large = 50

    }

    static func font(type: `Type`, size: Size) -> UIFont {
        return UIFont(name: type.rawValue, size: CGFloat(size.rawValue))!

    }

}
