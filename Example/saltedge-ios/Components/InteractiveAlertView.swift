//
//  InteractiveAlertView.swift
//  saltedge-ios_Example
//
//  Created by Daniel Marcenco on 8/23/19.
//  Copyright (c) 2019 Salt Edge. All rights reserved.
//

import UIKit
import WebKit

final class InteractiveAlertView: UIView {
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter text from the image:"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()

    private let webView = UIWebView()
    private let indicator = UIActivityIndicatorView()

    private var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Captcha"
        textField.layer.cornerRadius = 4.0
        textField.autocapitalizationType = .none
        textField.layer.borderColor = UIColor.gray.cgColor
        return textField
    }()

    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        return stackView
    }()

    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.buttonColor, for: .normal)
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()

    private var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.buttonColor, for: .normal)
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        return button
    }()

    var cancelPressedClosure: (() -> ())?
    var sendPressedClosure: ((String) -> ())?

    convenience init(html: String) {
        self.init(frame: .zero)
        backgroundColor = .contentViewBackgroundColor
        layer.cornerRadius = 4.0
        clipsToBounds = true
        
        setupTextLabel()
        setupWebView(with: html)
        setupTextField()
        setupButtonsStackView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @objc private func cancelPressed() {
        cancelPressedClosure?()
    }
    
    @objc private func sendPressed() {
        guard let text = textField.text, !text.isEmpty else { return }

        sendPressedClosure?(text)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension InteractiveAlertView {
    func setupTextLabel() {
        addSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0),
            textLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, constant: -8.0),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupWebView(with html: String) {
        webView.delegate = self

        addSubview(webView)
        webView.addSubview(indicator)
        indicator.startAnimating()

        indicator.color = .gray
        webView.contentMode = .scaleAspectFill

        webView.loadHTMLString(html, baseURL: nil)
        webView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8.0),
            webView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10.0),
            webView.heightAnchor.constraint(equalToConstant: 72.0),
            webView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
        ])
    }

    func setupTextField() {
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 5.0),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10.0),
            textField.heightAnchor.constraint(equalToConstant: 24.0),
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupButtonsStackView() {
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(sendButton)

        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8.0),
            buttonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10.0),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 32.0),
            buttonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension InteractiveAlertView: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
    }
}

private extension UIColor {
    static var contentViewBackgroundColor: UIColor {
        return UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    }
    
    static var buttonColor: UIColor {
        return UIColor(red: 46.0/255.0, green: 125.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    }
}
