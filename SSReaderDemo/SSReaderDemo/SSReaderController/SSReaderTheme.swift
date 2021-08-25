//
//  SSReaderTheme.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/10.
//

import Foundation
import UIKit


public protocol SSReaderTheme {
    var contentBackgroudColor: UIColor? { get }
    var contentTextColor: UIColor? { get }
    var toolBackgroudColor: UIColor? { get }
    var toolControlTextColor: UIColor? { get }
    var toolControlBorderUnSelectColor: UIColor? { get }
    var toolLineColor: UIColor? { get }
}

struct WhiteTheme: SSReaderTheme {
    var contentBackgroudColor: UIColor? = UIColor.white
    var contentTextColor: UIColor? = UIColor.black
    var toolBackgroudColor: UIColor? = UIColor.white
    var toolControlTextColor: UIColor? = UIColor.black
    var toolControlBorderUnSelectColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
    var toolLineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
}

struct DarkTheme: SSReaderTheme {
    var contentBackgroudColor: UIColor? = UIColor.black
    var contentTextColor: UIColor? = UIColor.white
    var toolBackgroudColor: UIColor? = UIColor.black
    var toolControlTextColor: UIColor? = UIColor.white
    var toolControlBorderUnSelectColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
    var toolLineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
}

struct YellowTheme: SSReaderTheme {
    var contentBackgroudColor: UIColor? = UIColor(red: 0.89, green: 0.87, blue: 0.79, alpha: 1)
    var contentTextColor: UIColor? = UIColor.black
    var toolBackgroudColor: UIColor? = UIColor(red: 0.89, green: 0.87, blue: 0.79, alpha: 1)
    var toolControlTextColor: UIColor? = UIColor.black
    var toolControlBorderUnSelectColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
    var toolLineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
}


struct GreenTheme: SSReaderTheme {
    var contentBackgroudColor: UIColor? = UIColor(red: 0.87, green: 0.91, blue: 0.82, alpha: 1)
    var contentTextColor: UIColor? = UIColor.black
    var toolBackgroudColor: UIColor? = UIColor(red: 0.87, green: 0.91, blue: 0.82, alpha: 1)
    var toolControlTextColor: UIColor? = UIColor.black
    var toolControlBorderUnSelectColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
    var toolLineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
}

struct PinkTheme: SSReaderTheme {
    var contentBackgroudColor: UIColor? = UIColor(red: 1, green: 0.89, blue: 0.91, alpha: 1)
    var contentTextColor: UIColor? = UIColor.black
    var toolBackgroudColor: UIColor? = UIColor(red: 1, green: 0.89, blue: 0.91, alpha: 1)
    var toolControlTextColor: UIColor? = UIColor.black
    var toolControlBorderUnSelectColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
    var toolLineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
}


struct BlueTheme: SSReaderTheme {
    var contentBackgroudColor: UIColor? = UIColor(red: 0.8, green: 0.84, blue: 0.89, alpha: 1)
    var contentTextColor: UIColor? = UIColor.black
    var toolBackgroudColor: UIColor? = UIColor(red: 0.8, green: 0.84, blue: 0.89, alpha: 1)
    var toolControlTextColor: UIColor? = UIColor.black
    var toolControlBorderUnSelectColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
    var toolLineColor: UIColor? = UIColor.lightGray.withAlphaComponent(0.5)
}
