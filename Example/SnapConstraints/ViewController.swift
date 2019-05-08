//
//  ViewController.swift
//  SnapConstraints
//
//  Created by sbrighiu on 04/24/2017.
//  Copyright (c) 2017 sbrighiu. All rights reserved.
//

import UIKit
import SnapConstraints

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TODO: This is currently my testing/example project. It needs some work ;) but it does the job.
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view1.backgroundColor = .red
        self.view.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view2.backgroundColor = .blue
        self.view.addSubview(view2)
        
        let view3 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view3.backgroundColor = .green
        self.view.addSubview(view3)
        
        //        _ = view1.snap.leading.trailing.top(with: 100).height (equalTo: view2, with: 0, multiplier: 0.5)
        _ = view1.snap.mask(.fillHorizontally).height(equalTo: view2, with: 0, multiplier: 0.5).topToSafeArea
        _ = view2.snap.leading.left(of: view3).below(view1).bottomToSafeArea(with: 0, priority: 999)
        view3.snap.bottom.right(of: view2).top(with: 0, to: view2).trailing.width(equalTo: view2, with: 0, multiplier: 0.5)
        view1.snap.leading.tag = "Hello"
        
        print(view.snaps)
        //        print(view.snaps(ofType: .leading))
        //        print(view.snaps(withTag: "Hello"))
        //        print(view.snaps(ofType: .leading, andWithTag: "Hello"))
        
        let view4 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view4.backgroundColor = .yellow
        view2.addSubview(view4)
        
        _ = view4.snap.width(of: 50).height(of: 100).centerX.centerY
        
        let view5 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view5.backgroundColor = .white
        view2.addSubview(view5)
        
        _ = view5.snap.left(of: view4, by: 16).height(equalTo: view4).width(equalTo: view4).centerY
        
        let view6 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view6.backgroundColor = .black
        view6.tag = 6
        view2.addSubview(view6)
        
        _ = view6.snap.right(of: view4, by: 16).height(equalTo: view4).width(equalTo: view4).centerY
        
        let view15 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view15.backgroundColor = .purple
        view2.addSubview(view15)
        
        _ = view15.snap.above(view4, by: 16).height(equalTo: view4).width(equalTo: view4).centerX
        
        let view16 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view16.backgroundColor = .lightGray
        view2.addSubview(view16)
        
        _ = view16.snap.below(view4, by: 16).height(equalTo: view4).width(equalTo: view4).centerX
        
        let view7 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view7.backgroundColor = .orange
        view7.tag = 7
        self.view.addSubview(view7)
        self.view.bringSubviewToFront(view7)
        
        _ = view7.snap.bottom(with: 20, to: view1).top(with: 20).leading(with: 20).trailing(with: 20)
        
        let view8 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view8.backgroundColor = UIColor.darkText
        view8.tag = 8
        view7.addSubview(view8)
        
        _ = view8.snap.leading(with: 40, to: view1).trailing(with: 40, to: view1).top(with: 40, to: view1).bottom(with: 40, to: view1)
        
        let view9 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view9.backgroundColor = UIColor.darkText
        view9.tag = 9
        view3.addSubview(view9)
        
        view9.snap.mask(.fill, with: 8)
        
        let view10 = CustomButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view10.backgroundColor = UIColor.darkGray
        view10.tag = 10
        view10.setTitleColor(.white, for: .normal)
        view10.setTitle("Yellow", for: .normal)
        view3.addSubview(view10)
        
        view10.snap.mask(.trailing, .leading, with: 16, to: view9).mask(.fillVertically, with: 8).tag = "Hey"        
        print("\n", view3.snaps)
        
        let view11 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view11.backgroundColor = UIColor.red
        view11.tag = 11
        view8.addSubview(view11)
        
//        view11.snap.ratioHW(of: 0.5)
        view11.snap.mask(.ratioHW, multiplier: 1.5)
        view11.snap.mask(.center)
        view11.snap.height(of: 50)
        
        let view12 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view12.backgroundColor = UIColor.red
        view8.addSubview(view12)
        
        view12.snap.ratio(equalTo: view11)
        view12.snap.mask(.trailing, .centerVertically)
    }

}

class CustomButton: UIButton { }
