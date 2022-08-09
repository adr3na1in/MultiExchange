import UIKit

class TouchableView: UIView {
    var tapHandler: (() -> Void)? {
        didSet {
            if tapHandler != nil {
                self.addRecognizer()
            } else {
                self.removeRecognizer()
            }
        }
    }
}

private extension TouchableView {
    func addRecognizer() {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector (self.longPressed( _:)))
        self.isUserInteractionEnabled = true
        recognizer.minimumPressDuration = 0
        self.addGestureRecognizer(recognizer)
    }

    @objc func longPressed( _ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            self.tapHandler?()
         default:
            break
        }
    }

    func removeRecognizer() {
        self.isUserInteractionEnabled = false
        let recognizers = self.gestureRecognizers
        recognizers?.forEach { self.removeGestureRecognizer($0) }
    }
}
