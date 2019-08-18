//
//  YomuLineChartView.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/11.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import Charts

class YomuLineChartView: UIView {
    @IBOutlet weak var lineChartView: LineChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            configureChart()
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    private func configureChart() {
        lineChartView.xAxis.enabled = false
        lineChartView.xAxis.labelPosition = .bottom //x軸ラベル下側に表示
        lineChartView.xAxis.labelCount = 7 //x軸に表示するラベルの数
        lineChartView.xAxis.labelTextColor = UIColor.white //x軸ラベルの色
        lineChartView.xAxis.axisLineColor = UIColor.white //x軸の色
        lineChartView.xAxis.axisLineWidth = 1 //x軸の太さ
        lineChartView.xAxis.drawGridLinesEnabled = false //x軸のグリッド表示(今回は表示しない)
        
        //y軸設定
        lineChartView.rightAxis.enabled = false //右軸(値)の表示
        lineChartView.leftAxis.enabled = true //左軸（値)の表示
        lineChartView.leftAxis.axisMinimum = 0 //y左軸最小値
        lineChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11) //y左軸のフォントの大きさ
        lineChartView.leftAxis.labelTextColor = UIColor.white //y軸ラベルの色
        lineChartView.leftAxis.axisLineColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) //y左軸の色(今回はy軸消すためにBGと同じ色にしている)
        lineChartView.leftAxis.drawAxisLineEnabled = false //y左軸の表示(今回は表示しない)
        lineChartView.leftAxis.drawGridLinesEnabled = false //y軸のグリッド表示
        
        //その他UI設定
        lineChartView.noDataFont = UIFont.systemFont(ofSize: 30) //Noデータ時の表示フォント
        lineChartView.noDataTextColor = UIColor.white //Noデータ時の文字色
        lineChartView.noDataText = "No Data..." //Noデータ時に表示する文字
        lineChartView.legend.enabled = false //"■ months"のlegendの表示
        lineChartView.dragDecelerationEnabled = true //指を離してもスクロール続くか
        lineChartView.dragDecelerationFrictionCoef = 0.6 //ドラッグ時の減速スピード(0-1)
        lineChartView.backgroundColor = UIColor.init(named: Constant.Color.greenSheen)
    }
    
    //グラフ描画部分
    public func drawLineChart(xValArr: [String], yValArr: [Double]) {
        
        lineChartView.leftAxis.axisMaximum = (yValArr.max() ??  10) * 1.1 //y左軸最大値
        
        var dataEntries : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< xValArr.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: yValArr[i])
            dataEntries.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(entries: dataEntries, label: "Months") //ds means DataSet
        
        ////グラフのUI設定
        //グラフのグラデーション有効化
        let gradientColors = [UIColor.init(named: Constant.Color.pinkSherbet)?.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.7, 0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object

        ds.fill = Fill.fillWithLinearGradient(gradient!, angle: 90) // Set the Gradient

        //その他UI設定
        ds.lineWidth = 0 //線の太さ
        //ds.circleRadius = 0 //プロットの大きさ
        ds.drawCirclesEnabled = false //プロットの表示(今回は表示しない)
        ds.mode = .cubicBezier //曲線にする
        ds.drawFilledEnabled = true //グラフ下の部分塗りつぶし
        // ds.fillColor = UIColor.init(named: Constant.Color.pinkSherbet)! //グラフ塗りつぶし色
        ds.fillAlpha = 0.7
        ds.drawValuesEnabled = false //各プロットのラベル表示(今回は表示しない)
        ds.highlightColor = UIColor.clear //各点を選択した時に表示されるx,yの線
        
        ////グラフのUI設定
        
        data.addDataSet(ds)
        
        lineChartView.data = data
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
    }
}

