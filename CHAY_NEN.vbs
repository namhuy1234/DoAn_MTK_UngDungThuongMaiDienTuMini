' Chay an back-end va front-end (khong mo trinh duyet) - dung khi tu bat cung Windows
Set fso = CreateObject("Scripting.FileSystemObject")
d = fso.GetParentFolderName(WScript.ScriptFullName)
Set sh = CreateObject("WScript.Shell")
sh.CurrentDirectory = d
sh.Run "cmd /c """"" & d & "\CHAY_CHUONG_TRINH.bat"" /nen""", 0, False
