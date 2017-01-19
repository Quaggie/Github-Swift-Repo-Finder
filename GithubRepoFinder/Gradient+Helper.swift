//
//  Gradient.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

protocol Gradientable: class {}

extension Gradientable where Self: UIView {
  private func getCGPoints (for position: GradientPosition, start at: StartAt) -> (CGPoint, CGPoint)? {
    switch position{
    case .diagonal:
      if at == .lowerRight {
        return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
      } else if at == .lowerLeft {
        return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
      } else if at == .upperRight {
        return (CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0))
      } else if at == .upperLeft {
        return (CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 0))
      } else {
        print("Position doesn't accept diagonal type")
        return nil
      }
    case .horizontal:
      if at == .right {
        return (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
      } else if at == .left {
        return (CGPoint(x: 1, y: 0.5), CGPoint(x: 0, y: 0.5))
      } else {
        print("Position doesn't accept horizontal type")
        return nil
      }
    case .vertical:
      if at == .top {
        return (CGPoint(x: 0.5, y: 1), CGPoint(x: 0.5, y: 0))
      } else if at == .bottom {
        return (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
      } else {
        print("Position doesn't accept verticla type")
        return nil
      }
    }
  }
  
  func applyGradient (colors: [UIColor], position: GradientPosition, startAt: StartAt) {
    let gradientLayer = CAGradientLayer()
    if let (startPoint, endPoint) = getCGPoints(for: position, start: startAt) {
      gradientLayer.startPoint = startPoint
      gradientLayer.endPoint = endPoint
      gradientLayer.frame = self.bounds
      gradientLayer.locations = [0.0]
      gradientLayer.colors = colors.map { $0.cgColor as CGColor }
      self.layer.insertSublayer(gradientLayer, at: 0)
    }
  }
  
  func applyGradient (colors: [UIColor], position: GradientPosition, startAt: StartAt, locations: [NSNumber]?) {
    let gradientLayer = CAGradientLayer()
    if let (startPoint, endPoint) = getCGPoints(for: position, start: startAt) {
      gradientLayer.startPoint = startPoint
      gradientLayer.endPoint = endPoint
      gradientLayer.frame = self.bounds
      gradientLayer.locations = locations
      gradientLayer.colors = colors.map { $0.cgColor as CGColor }
      self.layer.insertSublayer(gradientLayer, at: 0)
    }
  }
}

enum GradientPosition {
  case vertical
  case horizontal
  case diagonal
}

enum StartAt {
  // Vertical
  case top
  case bottom
  // Horizontal
  case left
  case right
  // Diagonal
  case upperRight
  case upperLeft
  case lowerRight
  case lowerLeft
}
