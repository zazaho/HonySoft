�
 TFCONTRACTPRINT 0  TPF0TfContractPrintfContractPrintLeft TopfWidth!HeightHorzScrollBar.Range�VertScrollBar.Range�
AutoScrollCaptionGegevens uit contract database
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style ScaledOnCreate
FormCreatePixelsPerInch`
TextHeight TQRBandTitleLeft Top Width�Height%AlignalTopBandTyperbTitleColorclNavyForceNewPageFrame.Width Frame.DrawTopFrame.DrawBottomFrame.DrawLeftFrame.DrawRightRulerqrrNone 
TQRSysData
QRSysData1Left� TopWidth%Height 	AlignmenttaCenterAlignToBand	AutoSize	DataqrsReportTitle
Font.ColorclWhiteFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  
TQRSysData
QRSysData2Left�TopWidth� Height	AlignmenttaRightJustifyAlignToBand	DataqrsDate
Font.ColorclWhiteFont.Height�	Font.NameArial
Font.Style 
ParentFont   TQRBandQRBand2Left Top%Width�Height9AlignalTopBandTyperbDetailColorclWhiteForceNewPageFrame.DrawTopFrame.DrawBottomFrame.DrawLeftFrame.DrawRightLinkBandQRBand1RulerqrrInchesHV 	TQRDBText	QRDBText6Left
TopWidthAHeight	AlignmenttaCenterAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField
VK_BEDRIJF
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  	TQRDBText	QRDBText2Left� Top Width8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldNAAM  	TQRDBText	QRDBText3Left/Top Width8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldSTRAAT  	TQRDBText	QRDBText4Left�Top Width8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldHSNR  	TQRDBText	QRDBText5Left�Top Width8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldHSTO  	TQRDBText	QRDBText7LeftTop Width8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldPOSTCODE  	TQRDBText	QRDBText8LeftHTop Width8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField
WOONPLAATS  	TQRDBText	QRDBText9LeftHTopWidth8HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldTELEFOON  	TQRDBText
QRDBText10Left� TopWidth>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldCONTRACT  	TQRDBText
QRDBText11Left� Top%Width>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField
DTM_VERZND  	TQRDBText
QRDBText12LeftTopWidth>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldSTATUS  	TQRDBText
QRDBText13Left� TopWidth>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField	PROVTMBDG  	TQRDBText
QRDBText14Left-TopWidth>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldPRODUCT  TQRShapeQRShape1LeftTop5widthHeightShape
qrsHorLine  TQRLabelQRLabel2Left� Top%WidthHHeightCaptionVerzonden op:AlignToBand  TQRShapeQRShape2Left� Top�widthHeight7ShapeqrsVertLine  	TQRDBText	QRDBText1Left
TopWidth@Height	AlignmenttaCenterAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldVK_GROEP
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFont  	TQRDBText
QRDBText15Left
Top#WidthGHeight	AlignmenttaCenterAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField	VK_NUMMER
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFont  TQRLabelQRLabel1Left�Top%Width2HeightCaption
Retour op:AlignToBand  	TQRDBText
QRDBText16Left�Top%Width>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField
DTM_RETOUR  	TQRDBText
QRDBText17LeftTop%Width>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField
WKN_RETOUR  	TQRDBText
QRDBText18Left*Top%Width>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField
WKN_VERZND  	TQRDBText
QRDBText19LeftyTopWidth>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField	OORSPRONG  	TQRDBText
QRDBText20Left�TopWidth>HeightAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldKLANT_STATUS   TQRBandQRBand5Left TopwWidth�HeightAlignalTopBandTyperbPageFooterColorclWhiteForceNewPageFrame.DrawTopFrame.DrawBottomFrame.DrawLeftFrame.DrawRightRulerqrrNone 
TQRSysData
QRSysData3Left�TopWidth)Height	AlignmenttaCenterAlignToBand	AutoSize	DataqrsPageNumberTextPagina    TQRBandQRBand1Left Top^Width�HeightAlignalTopBandType	rbSummaryColorclWhiteForceNewPageFrame.DrawTopFrame.DrawBottomFrame.DrawLeftFrame.DrawRightRulerqrrNone TQRLabelQRLabel3Left� TopWidth� HeightCaptionTotaal aantal contracten:AlignToBand
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TQRLabelQRLabel4Left�TopWidth]HeightCaptionTotaal bedrag:AlignToBand
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  	TQRDBCalc	QRDBCalc1Left\TopWidthHHeight	AlignmenttaRightJustifyAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataFieldCONTRACT
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont	OperationqrcCOUNT  	TQRDBCalc	QRDBCalc2Left=TopWidthHHeight	AlignmenttaRightJustifyAlignToBandAutoSize	AutoStretch
DataSourceDataSource2	DataField	PROVTMBDG
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont	OperationqrcSUM	PrintMaskf #,###,##0.00	ResetBandQRBand1   TQuickReportQuickReport
DataSourceDataSource2ColumnMarginInches ColumnMarginMM ColumnsDisplayPrintDialogLeftMarginInches LeftMarginMM Orientation
poPortraitPageFrame.DrawTopPageFrame.DrawBottomPageFrame.DrawLeftPageFrame.DrawRightPaperLength 	PaperSize
qrpDefault
PaperWidth ReportTitleGegevens uit ContractRestartData	SQLCompatible	TitleBeforeHeader	Left��  Top�   TQueryQuery2AutoCalcFieldsSQL.Stringsselect * from contract UniDirectional	
UpdateModeupWhereKeyOnlyLeftDTop�   TDataSourceDataSource2DataSetQuery2LeftTop�    