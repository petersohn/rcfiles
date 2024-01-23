Library  OperatingSystem


*** Test Cases ***


*** Keywords ***

Check File
    [Arguments]  ${file}  ${expected}
    Get File  ${

Run Replace Inner
    [Arguments]  @{args}
    Create File  f1  foo1
    Create File  f2  foo2
    Create File  f3  foo3
    Create File  f4  bar1
    Create File  f5  bar2
    Create File  f6  bar3
    Sleep  1s

    ${command} = Catenate  replace.py  @{args}
    Run  ${command}



