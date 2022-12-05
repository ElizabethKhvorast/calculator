//
//  CalculatorButton.swift
//  calculator
//
//  Created by Елизавета Хворост on 16/11/2022.
//

import UIKit

class CalculatorButton: UIButton
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height * 0.5
    }
}
