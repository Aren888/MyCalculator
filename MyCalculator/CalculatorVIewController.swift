//
//  ViewController.swift
//  MyCalculator
//
//  Created by Aren Musayelyan on 28.05.23.
//

import UIKit

class CalculatorVIewController: UIViewController {
    
    //  MARK: - VARIABLES
    
    let viewModel: CalculatorControllerVIewModel
    
    //  MARK: - UI COMPONENTS
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(CalculatorHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalculatorHeaderCell.identifier)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.identifier)
        return collectionView
    }()
    
    //  MARK: - LIFECICLE
    init(_ viewModel: CalculatorControllerVIewModel = CalculatorControllerVIewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPurple
        setupUI()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.viewModel.updateViews = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    //  MARK: - UI SETUP
    private func setupUI() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}



//  MARK: - CollectionView Methods

extension CalculatorVIewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //    MARK: - Section Header Cell
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CalculatorHeaderCell.identifier, for: indexPath) as? CalculatorHeaderCell else {
            fatalError ("Failed to dequeue CalcHeaderCell in CalcController")
            
        }
        header.configure(curentCalculatorText: self.viewModel.calculatorHeaderLabel)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //      Cell Spacing
        let totalCellHeight = view.frame.size.width
        let totalVerticalCellSpacing = CGFloat(10*4)
        //      Screen height
        let window = view.window?.windowScene?.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let avaliableScreenHeight = view.frame.size.height - topPadding - bottomPadding
        //      Calculate Header Height
        let headerHeight = avaliableScreenHeight - totalCellHeight - totalVerticalCellSpacing
        
        return CGSize (width: view.frame.size.width, height: headerHeight)
    }
    
    //  MARK: - Normal Cells (Buttons)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.CalculatorButtonCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell else {
            fatalError("Failed to dequeue ButtonCel1 in CalculatorVIewController.")
        }
        
        let calculatorButton = self.viewModel.CalculatorButtonCells[indexPath.row]
        cell.configure(with: calculatorButton)
        
        if let operation = self.viewModel.operation, self.viewModel.secondNumber == nil {
            if operation.title == calculatorButton.title {
                cell.setOperationSelected()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let calculatorButton = self.viewModel.CalculatorButtonCells[indexPath.row]
        switch calculatorButton {
        case let .number(int) where int == 0:
            return CGSize(
                width: (view.frame.size.width/5)*2 + ((view.frame.size.width/5)/3),
                height: view.frame.size.width/5
            )
        default:
            return CGSize(
                width: view.frame.size.width/5 - 1,
                height: view.frame.size.width/5 - 1
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width/5)/3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = self.viewModel.CalculatorButtonCells[indexPath.row]
        self.viewModel.didSelectButton(with: buttonCell)
    }
}
