//
//  CGSize.swift
//  LXExtension
//
//  Created by Minh Luan Tran on 9/18/17.
//
//

import CoreGraphics

func *(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

func /(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: left.width / right, height: left.height / right)
}
