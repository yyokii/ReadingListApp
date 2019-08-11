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
        configureChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
        configureChart()
    }
    
    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    private func configureChart() {
        lineChartView.xAxis.labelPosition = .bottom //x軸ラベル下側に表示
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 11) //x軸のフォントの大きさ
        lineChartView.xAxis.labelCount = 5 //x軸に表示するラベルの数
        lineChartView.xAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //x軸ラベルの色
        lineChartView.xAxis.axisLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //x軸の色
        lineChartView.xAxis.axisLineWidth = 1 //x軸の太さ
        lineChartView.xAxis.drawGridLinesEnabled = false //x軸のグリッド表示(今回は表示しない)
        lineChartView.xAxis.valueFormatter = BarChartFormatter() //x軸の仕様
        
        
        //y軸設定
        lineChartView.rightAxis.enabled = false //右軸(値)の表示
        lineChartView.leftAxis.enabled = true //左軸（値)の表示
        lineChartView.leftAxis.axisMaximum = 40 //y左軸最大値
        lineChartView.leftAxis.axisMinimum = 0 //y左軸最小値
        lineChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11) //y左軸のフォントの大きさ
        lineChartView.leftAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //y軸ラベルの色
        lineChartView.leftAxis.axisLineColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) //y左軸の色(今回はy軸消すためにBGと同じ色にしている)
        lineChartView.leftAxis.drawAxisLineEnabled = false //y左軸の表示(今回は表示しない)
        lineChartView.leftAxis.labelCount = Int(4) //y軸ラベルの表示数
        lineChartView.leftAxis.drawGridLinesEnabled = false //y軸のグリッド表示
        lineChartView.leftAxis.gridColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) //y軸グリッドの色
        
        //その他UI設定
        lineChartView.noDataFont = UIFont.systemFont(ofSize: 30) //Noデータ時の表示フォント
        lineChartView.noDataTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //Noデータ時の文字色
        lineChartView.noDataText = "No Data..." //Noデータ時に表示する文字
        lineChartView.legend.enabled = false //"■ months"のlegendの表示
        lineChartView.dragDecelerationEnabled = true //指を離してもスクロール続くか
        lineChartView.dragDecelerationFrictionCoef = 0.6 //ドラッグ時の減速スピード(0-1)
        lineChartView.chartDescription?.text = nil //Description(今回はなし)
        lineChartView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) //Background Color
    }
    
    //グラフ描画部分
    public func drawLineChart(xValArr: [String], yValArr: [Double]) {
        
        var dataEntries : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< xValArr.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: yValArr[i])
            dataEntries.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
        }
        
        let data = LineChartData()
        let ds = LineChartDataSet(entries: dataEntries, label: "Months") //ds means DataSet
        
        ////グラフのUI設定
        //グラフのグラデーション有効化
        let gradientColors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.2196078449, green: 1, blue: 0.8549019694, alpha: 1).withAlphaComponent(0.3).cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.7, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        ds.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        
        
        //その他UI設定
        ds.lineWidth = 3.0 //線の太さ
        //ds.circleRadius = 0 //プロットの大きさ
        ds.drawCirclesEnabled = false //プロットの表示(今回は表示しない)
        ds.mode = .cubicBezier //曲線にする
        ds.fillAlpha = 1 //グラフの透過率(曲線は投下しない)
        ds.drawFilledEnabled = true //グラフ下の部分塗りつぶし
        //ds.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //グラフ塗りつぶし色
        ds.drawValuesEnabled = false //各プロットのラベル表示(今回は表示しない)
        ds.highlightColor = UIColor.clear //各点を選択した時に表示されるx,yの線
        ds.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] //Drawing graph
        ////グラフのUI設定
        
        data.addDataSet(ds)
        
        lineChartView.data = data
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.animate(xAxisDuration: 1.2, yAxisDuration: 1.5, easingOption: .easeInOutElastic)//グラフのアニメーション(秒数で設定)
    }
}

//x軸のラベルを設定する
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    let months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 0 -> Jan, 1 -> Feb...
        return months[Int(value)]
    }
}
