//
//  CalculatorVIewModel.swift
//  MyCalculator
//
//  Created by Aren Musayelyan on 28.05.23.
//

import Foundation


class CalculatorControllerVIewModel {
    //  MARK: - TableView DataSource Array

    let CalculatorButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .subtract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .decimal, .equals
    ]
    
    private(set) lazy var calculatorHeaderLabel: String = "42"
}
