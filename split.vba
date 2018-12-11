'Split an Excel Workbook's Sheets in different excel files

Sub Splitbook()
'Updateby20140612
Dim xPath As String
xPath = Application.ActiveWorkbook.Path
Application.ScreenUpdating = False
Application.DisplayAlerts = False
For Each xWs In ThisWorkbook.Sheets
    xWs.Copy
    Application.ActiveWorkbook.SaveAs FileName:=xPath & "/" & xWs.Name & ".xlsx"
    Application.ActiveWorkbook.Close False
Next
Application.DisplayAlerts = True
Application.ScreenUpdating = True
End Sub