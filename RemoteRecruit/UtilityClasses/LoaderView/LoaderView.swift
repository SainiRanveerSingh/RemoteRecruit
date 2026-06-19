//
//  LoaderView.swift
//  RemoteRecruit
//
//  Created by RV on 19/06/26.
//

import Foundation
import UIKit

final class LoaderView: UIView {
    
    static let shared = LoaderView()
    
    private let containerView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingLabel = UILabel()
    
    private init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Dimmed background
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        // Container box
        containerView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Activity indicator
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        
        // Label
        loadingLabel.text = ""
        loadingLabel.textColor = .white
        loadingLabel.font = .systemFont(ofSize: 14, weight: .medium)
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 120),
            containerView.heightAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            loadingLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    func show(in view: UIView, message: String = "") {
        DispatchQueue.main.async {
            self.loadingLabel.text = message
            self.frame = view.bounds
            self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Avoid duplicate overlays if show() is called twice
            if self.superview == nil {
                view.addSubview(self)
            }
            self.activityIndicator.startAnimating()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
        }
    }
}

/*
 To Call it
 LoaderView.shared.show(in: self.view)
 
 To Dismiss it
 LoaderView.shared.hide()
 
 */
