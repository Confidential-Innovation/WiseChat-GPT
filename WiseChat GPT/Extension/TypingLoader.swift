//
//  TypingLoader.swift
//  WiseChat GPT
//
//  Created by Md Murad Hossain on 4/3/23.
//

import UIKit

class DotsAnimation {

    func stopDotsAnimation(dots: UIView?) {
        if dots != nil {
            for subview in (dots?.subviews)! {
                subview.removeFromSuperview()
            }
            dots?.removeFromSuperview()
        }
    }

    func startDotsAnimation(superView: UIView, dotsColor: UIColor) -> UIView {
        let dots = self.buildView(superView: superView, dotsColor: dotsColor)

        animateWithKeyframes(dotToAnimate: dots.subviews[0], delay: 0.0)
        animateWithKeyframes(dotToAnimate: dots.subviews[1], delay: 0.3)
        animateWithKeyframes(dotToAnimate: dots.subviews[2], delay: 0.6)
        return dots
    }

    private func buildView(superView: UIView, dotsColor: UIColor) -> UIView {
        let dots = UIView(frame: superView.frame)

        dots.backgroundColor = UIColor(white: 1, alpha: 0)

        let numberDots = CGFloat(3)

        let width = CGFloat(dots.frame.width/7)
        let dotDiameter = (dots.frame.height < width) ? dots.frame.height : width
        let dotTotalWidth = (dotDiameter * numberDots) + (0.6 * dotDiameter * numberDots+2)
        var frame = CGRect(origin: CGPoint(x: (superView.frame.width - dotTotalWidth)/2, y: (superView.frame.height-dotDiameter)/2),
                           size: CGSize(width: dotDiameter, height: dotDiameter))
        let cornerRadiusLocal = dotDiameter / 2
        for _ in 0...Int(numberDots-1) {
            let dot: UIView = UIView(frame: frame)
            dot.layer.cornerRadius = cornerRadiusLocal
            dot.backgroundColor = dotsColor
            dots.addSubview(dot)
            frame.origin.x += (2.0 * dotDiameter)
        }
        return dots
    }

    private func animateWithKeyframes(dotToAnimate: UIView, delay: Double) {
        UIView.animateKeyframes(
            withDuration: 0.9,
            delay: delay,
            options: [UIView.KeyframeAnimationOptions.repeat],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: .infinity,
                    animations: {
                        dotToAnimate.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.33333333333,
                    relativeDuration: 0.66666666667,
                    animations: {
                        dotToAnimate.transform = CGAffineTransform.identity
                    }
                )
            }
        )
    }
}
