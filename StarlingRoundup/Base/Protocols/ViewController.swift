//
//  ViewController.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 27/06/2022.
//

protocol ViewController {
    associatedtype viewModelType

    // For reference, I am using ! here just to force the developer to conform to the MVVM structure, no view coltroller without view model
    var viewModel: viewModelType! { get set }
}
