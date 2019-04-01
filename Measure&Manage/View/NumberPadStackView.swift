//
//  NumberPadStackView.swift
//  Measure&Manage
//
//  Created by Macbook Pro on 9/1/19.
//  Copyright © 2019 Jeasung  Shin. All rights reserved.
//

//import UIKit
//
//class NumberPadStackView: UIStackView {
//    
//    lazy var button1 = creatingButton(title: "1")
//    lazy var button2 = creatingButton(title: "2")
//    lazy var button3 = creatingButton(title: "3")
//    lazy var button4 = creatingButton(title: "4")
//    lazy var button5 = creatingButton(title: "5")
//    lazy var button6 = creatingButton(title: "6")
//    lazy var button7 = creatingButton(title: "7")
//    lazy var button8 = creatingButton(title: "8")
//    lazy var button9 = creatingButton(title: "9")
//    lazy var button0 = creatingButton(title: "0")
//    lazy var buttonDot = creatingButton(title: ".")
//    
//    func createOneAction(target: Any?, selector: Selector) {
//        [button1, button2, button3, button4, button5, button6, button7, button8, button9, button0, buttonDot].forEach { (button) in
//            button.addTarget(target, action: selector, for: .touchUpInside)
//        }
//    }
//    
//    func creatingButton(title: String) -> UIButton {
//        let bt = UIButton(type: .system)
//        bt.setTitle(title, for: .normal)
////        bt.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
//        bt.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
//        bt.layer.cornerRadius = 5
//        bt.layer.borderColor = UIColor.normalBlue.cgColor
//        bt.layer.borderWidth = 1
//        bt.backgroundColor = .normalBlue
//        bt.setTitleColor(.whiteBlue, for: .normal)
//        return bt
//    }
//    
////    @objc func handleButtonPressed(button: UIButton) {
////        print(button.currentTitle)
////    }
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        
//        distribution = .fillEqually
//        axis = .vertical
//        spacing = 2
//        
//        let firstRowStackView = UIStackView(arrangedSubviews: [button1, button2, button3])
//        let secondRowStackView = UIStackView(arrangedSubviews: [button4, button5, button6])
//        let thirdRowStackView = UIStackView(arrangedSubviews: [button7, button8, button9])
//        let lastRowStackView = UIStackView(arrangedSubviews: [button0, buttonDot])
//        
//        let stackViews = [firstRowStackView, secondRowStackView, thirdRowStackView, lastRowStackView]
//        
//        stackViews.forEach{
//            $0.spacing = 2
//            $0.axis = .horizontal
//            $0.distribution = .fillEqually
//            addArrangedSubview($0)
//        }
//        
//        
//        
//        
//        
//        
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
