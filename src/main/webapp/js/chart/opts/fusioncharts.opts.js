var pColors = '1aa1b5,2dcdb1,2dcd6d,eab543,f69e3f,dba2f9,358ada,f17c8a,ea8bba,f196e5,F6BD0F,8BBA00,FF8E46,008E8E,D64646,8E468E,588526,B3AA00,008ED6,9D080D,A186BE,CC6600,FDC689,ABA000,F26D7D,FFF200,0054A6';
var fillColors = new Array( "1aa1b5","2dcdb1","2dcd6d","eab543","f69e3f","dba2f9","358ada","f17c8a","ea8bba","f196e5","F6BD0F","8BBA00","FF8E46","008E8E","D64646","8E468E","588526","B3AA00","008ED6","9D080D","A186BE","CC6600","FDC689","ABA000","F26D7D","FFF200","0054A6");
var pieColors = '#7ab4df,#0093d8,#00a4e3,#00b6e0,#66cbe8,#abdae7,#70cee1,#009cb9,#00adc9,#14c4e0,#71cee1,#1fc6d6,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3,#62e6f3';

var chartOpt = {
    id: '',
    type:'',
    renderAt:'',
    width:'100%',
    height:'',
    dataFormat:'json',
    containerBackgroundOpacity:'0',
    dataSource:{
        chart:{
            caption: '',
            pYAxisName: '', sYAxisName: '',
            baseFont : 'Malgun Gothic',
            baseFontColor: '#000000',
            baseFontSize: '11',
            subcaptionFontBold: '0',
            canvasBgAlpha: '0',
            showValues: '0',
            paletteColors: pColors,
            bgAlpha: '0',
            canvasBgColor: '#ffffff',
            lineThickness: '4',
            formatNumberScale: '0',
            labelDisplay: 'rotate',
            slantLabels: '1',
            showBorder: '0', showShadow: '0', showAlternateHGridColor: '0', showCanvasBorder: '0', showXAxisLine: '1', showHoverEffect: '1', plotBorderColor: '#ffffff', usePlotGradientColor: '0',
            xAxisLineThickness: '1', xAxisLineColor: '#cdcdcd', xAxisNameFontColor: '#000000', yAxisNameFontColor: '#000000',
            legendBgColor: '#ffffff', legendBgAlpha: '100', legendBorderAlpha: '50', legendBorderColor: '#888888', legendShadow: '0',
            divlineAlpha: '0', numDivLines: '10', divlineColor: '#999999', divlineThickness: '1', divLineIsDashed: '1', divLineDashLen: '1', divLineGapLen: '1',
            toolTipColor: '#ffffff', toolTipBorderColor: '#ffffff', toolTipBorderThickness: '1', toolTipBgColor: '#000000',
            toolTipBgAlpha: '80', toolTipBorderRadius: '4', toolTipPadding: '10', toolTipFontSize : '20',
            anchorBgColor: '#ffffff', anchorRadius: '5', anchorBorderThickness: '3', anchorTrackingRadius: '15',
            exportEnabled: '1', exportAtClient: '0', exportAction: 'save', exportAtClientSide: '0', exportShowMenuItem: '0', exportDialogMessage: 'Building chart output', exportCallBack: 'exportAfter'
        }
    }
};

var shareChartOpt = {
    id: '',
    type:'',
    renderAt:'',
    width:'100%',
    height:'',
    dataFormat:'json',
    containerBackgroundOpacity:'0',
    dataSource:{
        chart:{
            exportCallBack: 'myFN'
            ,caption: ''
            ,subcaption: ''
            ,exportHandler: '${contextPath}/servlet/FCExporter/export.do'
            ,baseFontColor: '#666666'
            ,baseFontSize: '11'
            ,subcaptionFontBold: '0'
            ,canvasBgAlpha: '0'
            ,showValues: '0'
            ,paletteColors: pColors
            ,bgAlpha: '0'
            ,showBorder: '0'
            ,showShadow: '0'
            ,showAlternateHGridColor: '0'
            ,showCanvasBorder: '0'
            ,showformbtn: '0'
            ,showRestoreBtn: '0'
            ,viewmode: '1'
            ,xAxisMaxValue: '100'
            ,yAxisMinValue: '0'
            ,yAxisMaxValue: '100'
            ,chartTopMargin: '3'
            ,chartLeftMargin: '3'
            ,chartRightMargin: '3'
            ,chartBottomMargin: '3'
            ,xAxisName: ''
            ,showXAxisLine: '0'
            ,xAxisLineThickness: '0'
            ,xAxisLineColor: '#cdcdcd'
            ,xAxisNameFontColor: '#8d8d8d'
            ,yAxisName: ''
            ,yAxisNameFontColor: '#8d8d8d'
            ,canvasBgColor: '#ffffff'
            ,lineThickness: '4'
            ,legendBgColor: '#ffffff'
            ,legendBgAlpha: '100'
            ,legendBorderAlpha: '50'
            ,legendBorderColor: '#888888'
            ,legendShadow: '0'
            ,legendPosition: 'CENTER'
            ,divlineAlpha: '100'
            ,numDivLines: '10'
            ,divlineThickness: '0'
            ,toolTipColor: '#ffffff'
            ,toolTipBorderColor: '#ffffff'
            ,toolTipBorderThickness: '1'
            ,toolTipBgColor: '#000000'
            ,toolTipBgAlpha: '80'
            ,toolTipBorderRadius: '4'
            ,toolTipPadding: '10'
            ,toolTipFontSize : '20'
            ,anchorBgColor: '#ffffff'
            ,anchorRadius: '5'
            ,anchorBorderThickness: '3'
            ,anchorTrackingRadius: '15'
            ,showHoverEffect: '1'
            ,formatNumberScale: '0'
            ,labelDisplay: 'rotate'
            ,slantLabels: '1'
            ,exportEnabled: '1'
            ,exportAtClient: '0'
            ,exportAction: 'save'
            ,exportShowMenuItem: '0'
            ,exportDialogMessage: 'Building chart output'
            ,CaptionFont: '12'
        }
    }
};

var pieChartOpt = {
    id: '',
    type:'',
    renderAt:'',
    width:'100%',
    height:'',
    dataFormat:'json',
    containerBackgroundOpacity:'0',
    dataSource:{
        chart:{
            baseFontSize: '12',
            toolTipColor: '#ffffff',
            toolTipBorderColor: '#ffffff',
            toolTipBorderThickness: '1',
            toolTipBgColor: '#000000',
            toolTipBgAlpha: '80',
            toolTipBorderRadius: '4',
            toolTipPadding: '10',
            toolTipFontSize : '20',
            bgcolor: 'FFFFFF',
            enablesmartlabels: "1",
            use3dlighting: "0",
            showshadow: "0",
            palettecolors: pieColors,
            showborder: "0",
            showPercentValues: 1
        }
    }
};