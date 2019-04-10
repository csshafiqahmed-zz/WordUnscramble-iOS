import Lottie

extension LOTAnimationView {

    func startAnimation() {
        self.isHidden = false
        self.play()
    }

    func stopAnimation() {
        self.isHidden = true
        self.stop()
    }
}