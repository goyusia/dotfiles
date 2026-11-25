#Requires AutoHotkey v2.0
#SingleInstance Force

; Esc는 원래 프로그램에 전달하면서 IME를 영문으로 전환한다.
~Esc::
{
    SetImeToEnglish()
}

; Ctrl + B: tmux prefix 입력 전에 영어 IME로 전환하고 키 입력은 그대로 전달한다.
~^b::
{
    SetImeToEnglish()
}

; Ctrl + Alt + I: 현재 IME 상태 확인
^!i::
{
    ShowImeStatus()
}

SetImeToEnglish()
{
    imeWnd := GetDefaultImeWindow()
    if !imeWnd
        return

    ; 변환 모드: 0 = 영문
    ImeControl(imeWnd, 0x0002, 0) ; IMC_SETCONVERSIONMODE

    ; IME 상태: 0 = 닫힘 = 직접 영문 입력
    ImeControl(imeWnd, 0x0006, 0) ; IMC_SETOPENSTATUS
}

GetDefaultImeWindow()
{
    hwnd := WinExist("A")
    if !hwnd
        return 0

    return DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
}

; 숨겨진 기본 IME 창에 Win32 SendMessageW를 직접 전송한다.
ImeControl(imeWnd, command, value := 0)
{
    return DllCall(
        "user32\SendMessageW",
        "Ptr", imeWnd,
        "UInt", 0x0283, ; WM_IME_CONTROL
        "Ptr", command,
        "Ptr", value,
        "Ptr"
    )
}

ShowImeStatus()
{
    imeWnd := GetDefaultImeWindow()

    if !imeWnd {
        ShowTemporaryTip("오류: 기본 IME 창을 찾지 못했습니다.")
        return
    }

    isOpen := ImeControl(imeWnd, 0x0005) ; IMC_GETOPENSTATUS
    mode := ImeControl(imeWnd, 0x0001)   ; IMC_GETCONVERSIONMODE

    ShowTemporaryTip(
        "기본 IME 창: 0x" Format("{:X}", imeWnd)
        "`n열림 상태: " isOpen "  (0 = 영문)"
        "`n변환 모드: 0x" Format("{:04X}", mode & 0xFFFF)
    )
}

ShowTemporaryTip(message)
{
    ToolTip(message)
    SetTimer(ClearToolTip, -3000)
}

ClearToolTip()
{
    ToolTip()
}
