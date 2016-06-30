//
//  ViewController.swift
//  demoGame2048
//
//  Created by Quan on 6/30/16.
//  Copyright © 2016 MyStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel!
    var lose: Bool = false
    var b = Array(count: 4, repeatedValue: Array(count: 4, repeatedValue: 0))

    override func viewDidLoad() {
        super.viewDidLoad()
        let directions : [UISwipeGestureRecognizerDirection] = [.Right, .Left, .Up, .Down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
        randomNum(-1)
       
    }
    
    @IBAction func restartGame(sender: UIButton) {
        for(var i = 0; i < 4; i++) {
            for(var j = 0; j < 4; j++) {
                b[i][j] = 0
            }
        }
        self.transfer()
        self.lose = false
        self.randomNum(-1)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                randomNum(1)
            case UISwipeGestureRecognizerDirection.Left:
                randomNum(0)
            case UISwipeGestureRecognizerDirection.Up:
                randomNum(2)
            case UISwipeGestureRecognizerDirection.Down:
                randomNum(3)
            default:
                break
            }
        }
    }
    
    func checkRandom() -> Bool{
        for(var i = 0; i < 4; i++) {
            for(var j = 0; j < 4; j++) {
                if(b[i][j] == 0) {
                    return true
                }
            }
        }
        return false
    }
    
    func checkLose() -> Bool {
        for(var i = 0; i <= 2; i++) {
            for(var j = 0; j <= 2; j++) {
                if(b[i][j] == b[i+1][j] ||
                   b[i][j] == b[i][j+1] ){
                    return false
                }
            }
        }
        
        if b[3][0] == b[3][1] {
            return false
        }
        if b[3][1] == b[3][2] {
            return false
        }
        if b[3][2] == b[3][3] {
            return false
        }
        if b[0][3] == b[1][3] {
            return false
        }
        if b[1][3] == b[2][3] {
            return false
        }
        if b[2][3] == b[3][3] {
            return false
        }
        
        return true
    }
    
    func randomNum(type : Int) {
        if (!self.lose) {
            switch type {
            case 0:
                self.left()
            case 1:
                self.right()
            case 2:
                self.up()
            case 3:
                self.down()
            default:
                break
            }
        }
        if checkRandom() {
            
            var rnlabelX = arc4random_uniform(4)
            var rnlabelY = arc4random_uniform(4)
            var rdNum = arc4random_uniform(2) == 0 ? 2 : 4
            
            while(b[Int(rnlabelX)][Int(rnlabelY)] != 0) {
                rnlabelX = arc4random_uniform(4)
                rnlabelY = arc4random_uniform(4)
                
            }
            
            b[Int(rnlabelX)][Int(rnlabelY)] = rdNum
            let labelNumber = Int(100 + 4 * rnlabelX + rnlabelY)
            self.convertNumLabel(labelNumber, value: String(rdNum))
            self.transfer()
        } else {
            if checkLose() {
                self.lose = true
                let alert = UIAlertController(title: "GameOver", message: "You Lose", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    func changeBackColorAndColor(numberLabel : Int, color : UIColor) {
        let label = self.view.viewWithTag(numberLabel) as! UILabel
        label.backgroundColor = color
        if (color == UIColor(white: 0.00, alpha: 0.24) ||
            color == UIColor.lightGrayColor()) {
            label.textColor = UIColor.blackColor()
        } else {
            label.textColor = UIColor.whiteColor()
        }
    }
    
    func transfer() {
        for(var i = 0; i < 4; i++ ) {
            for(var j = 0; j < 4; j++) {
                let numberLabel = 100 + i * 4 + j
                convertNumLabel(numberLabel, value: String(b[i][j]))
                switch b[i][j] {
                case 2, 4:
                    changeBackColorAndColor(numberLabel, color: UIColor(white: 0.00, alpha: 0.24))
                case 8, 16:
                    changeBackColorAndColor(numberLabel, color: UIColor.orangeColor())
                case 32, 64:
                    changeBackColorAndColor(numberLabel, color: UIColor.redColor())
                case 128, 256, 512:
                    changeBackColorAndColor(numberLabel, color: UIColor.yellowColor())
                case 1024, 2048:
                    changeBackColorAndColor(numberLabel, color: UIColor.blackColor())
                default:
                    changeBackColorAndColor(numberLabel, color: UIColor.lightGrayColor())
                }
            }
        }
    }
    
    func convertNumLabel(numberLabel : Int, value : String) {
        let label = self.view.viewWithTag(numberLabel) as! UILabel
        if Int(value) != 0 {
            label.text = value
        } else {
            label.text = ""
        }
        
    }
    
    func up() {
        for ( var col = 0; col < 4; col++ ) {
            var check = false
            for ( var row = 1; row < 4; row++ ) {
                var tx = row
                
                if (b[row][col] == 0) {
                    continue
                }
                
                for ( var rowc = row - 1; rowc != -1; rowc-- ){
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check)) {
                        break
                    } else {
                        tx = rowc
                    }
                    
                }
                
                if(tx == row) {
                    continue
                }
                
                if(b[row][col] == b[tx][col]) {
                        self.getScore(b[tx][col])
                        b[tx][col] *= 2
                        check = true
                } else {
                    b[tx][col] = b[row][col]
                }
                
                b[row][col] = 0
            }
        }
    }
    
    func down() {
        for ( var col = 0; col < 4; col++ ) {
            var check = false
            for ( var row = 2; row >= 0; row-- ) {
                var tx = row
                
                if (b[row][col] == 0) {
                    continue
                }
                
                for ( var rowc = row + 1; rowc <= 3; rowc++ ){
                    if (b[rowc][col] != 0 && (b[rowc][col] != b[row][col] || check)) {
                        break
                    } else {
                        tx = rowc
                    }
                    
                }
                
                if(tx == row) {
                    continue
                }
                
                if(b[row][col] == b[tx][col]) {
                    self.getScore(b[tx][col])
                    b[tx][col] *= 2
                    check = true
                } else {
                    b[tx][col] = b[row][col]
                }
                
                b[row][col] = 0
            }
        }
    }
    
    func right() {
        for ( var row = 0; row < 4; row++ ) {
            var check = false
            for ( var col = 2; col >= 0; col-- ) {
                var ty = col
                
                if (b[row][col] == 0) {
                    continue
                }
                
                for ( var colc = col + 1; colc <= 3; colc++ ){
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check)) {
                        break
                    } else {
                        ty = colc
                    }
                    
                }
                
                if(ty == col) {
                    continue
                }
                
                if(b[row][col] == b[row][ty]) {
                    self.getScore(b[row][ty])
                    b[row][ty] *= 2
                    check = true
                } else {
                    b[row][ty] = b[row][col]
                }
                
                b[row][col] = 0
            }
        }
    }
    
    func left() {
        for ( var row = 0; row < 4; row++ ) {
            var check = false
            for ( var col = 1; col <= 3; col++ ) {
                var ty = col
                
                if (b[row][col] == 0) {
                    continue
                }
                
                for ( var colc = col - 1; colc >= 0; colc-- ){
                    if (b[row][colc] != 0 && (b[row][colc] != b[row][col] || check)) {
                        break
                    } else {
                        ty = colc
                    }
                    
                }
                
                if(ty == col) {
                    continue
                }
                
                if(b[row][col] == b[row][ty]) {
                    self.getScore(b[row][ty])
                    b[row][ty] *= 2
                    check = true
                } else {
                    b[row][ty] = b[row][col]
                }
                
                b[row][col] = 0
            }
        }
    }
    
    func getScore(value : Int) {
        self.score.text = String(Int(self.score.text!)! + value)
    }


}

