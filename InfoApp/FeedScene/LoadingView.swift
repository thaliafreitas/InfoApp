//
//  LoadingView.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import Foundation
import UIKit

class LoadingView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large) // ou .medium, dependendo do tamanho que você deseja
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .red // Defina a cor aqui
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.5) // Fundo semitransparente
        addSubview(activityIndicator)
        
        // Configurar as restrições para centralizar o activityIndicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func startLoading() {
        isHidden = false
        activityIndicator.startAnimating()
        layoutIfNeeded()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        isHidden = true
        layoutIfNeeded() // Atualiza a interface do usuário
    }
}
