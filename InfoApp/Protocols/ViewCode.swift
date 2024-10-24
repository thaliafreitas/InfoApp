//
//  ViewCode.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import Foundation

protocol ViewCode {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension ViewCode {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration() {
    }
}
