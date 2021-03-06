//
//  CGPoint.swift
//  LXExtension
//
//  Created by Minh Luan Tran on 9/18/17.
//
//

import CoreGraphics

func *(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

func /(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}
