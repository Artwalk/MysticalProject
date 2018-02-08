//
//  DesignableView.swift
//  SerialNumberScanner
//
//  Created by Art on 2/9/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

@IBDesignable
public class DesignableView: UIView, DesignableXib {
    init() {
        super.init(frame: CGRect.zero)

        xibSetup()
        commonSetup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
        commonSetup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        xibSetup()
        commonSetup()
    }

    init(xibName: String) {
        super.init(frame: CGRect.zero)
        xibSetup(name: xibName)
        commonSetup()
    }

    func commonSetup() {

    }
}

internal protocol DesignableXib {
    func xibSetup(name: String?)
}

extension DesignableXib where Self: UIView {

    internal func xibSetup(name: String? = nil) {

        let nibName = name ?? type(of: self).description().components(separatedBy: ".").last!
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView  else { return }
        addSubviewAnchorZero(view)
        addSubviewCenter(view)
    }

    internal func addSubviewAnchorZero(_ view: UIView) {
        if !subviews.contains(view) {
            insertSubview(view, at: 0)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     topAnchor.constraint(equalTo: view.topAnchor),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }

    internal func addSubviewCenter(_ view: UIView) {
        if !subviews.contains(view) {
            insertSubview(view, at: 0)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}
