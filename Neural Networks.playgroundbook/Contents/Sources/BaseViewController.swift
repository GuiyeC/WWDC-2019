//
//  BaseViewController.swift
//  Neural Networks
//
//  Created by Guillermo Cique on 23/03/2019.
//


import UIKit
import PlaygroundSupport

@objc(Book_Sources_BaseViewController)
open class BaseViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        view.tintColor = .defaultTintColor
    }
}
