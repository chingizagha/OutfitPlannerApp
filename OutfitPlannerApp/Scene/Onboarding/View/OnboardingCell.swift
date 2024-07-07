//
//  OnboardingCell.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 30.06.24.
//

import UIKit
import Lottie

class OnboardingCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCell"
    
    var nextButtonDidTap: (() -> Void)?
    var skipButtonDidTap: (() -> Void)?
    
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.backgroundColor = .systemBackground
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var titleLabel = TitleLabel(textAlignment: .left, fontSize: 32)
    private var bodyLabel = BodyLabel(textAlignment: .center)
    
    private var skipButton = CustomButton(backgroundColor: .clear, titleColor: .label, title: "Skip Now")
    private var nextButton = CustomButton(backgroundColor: .label, titleColor: .systemBackground, icon: "arrowtriangle.right.fill")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(didTapSkip), for: .touchUpInside)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    private func didTapNext() {
        nextButtonDidTap?()
    }
    
    @objc
    private func didTapSkip() {
        skipButtonDidTap?()
    }
    
    private func layoutUI(){
        
        contentView.addSubviews(animationView, titleLabel, bodyLabel, skipButton, nextButton)
        
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            animationView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            animationView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: animationView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: animationView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            skipButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            skipButton.widthAnchor.constraint(equalTo: skipButton.widthAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor)
        ])
    }
    
    func configure(with slide: Slide) {
        titleLabel.text = slide.title
        bodyLabel.text = slide.text
        animationView.animation = LottieAnimation.named(slide.animationName)
        animationView.loopMode = .loop
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}
