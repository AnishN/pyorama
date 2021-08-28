from pyorama.libs.c cimport *

cdef extern from "cimgui/cimgui.h" nogil:
    char* igGetVersion()
    pass

    ctypedef struct ImGuiTableColumnSettings
    ctypedef struct ImGuiTableCellData
    ctypedef struct ImGuiViewportP
    ctypedef struct ImGuiPtrOrIndex
    ctypedef struct ImGuiShrinkWidthItem
    ctypedef struct ImGuiWindowStackData
    ctypedef struct ImGuiComboPreviewData
    ctypedef struct ImGuiDataTypeTempStorage
    ctypedef struct ImVec2ih
    ctypedef struct ImVec1
    ctypedef struct StbTexteditRow
    ctypedef struct STB_TexteditState
    ctypedef struct StbUndoState
    ctypedef struct StbUndoRecord
    ctypedef struct ImGuiWindowSettings
    ctypedef struct ImGuiWindowTempData
    ctypedef struct ImGuiWindow
    ctypedef struct ImGuiTableColumnsSettings
    ctypedef struct ImGuiTableSettings
    ctypedef struct ImGuiTableTempData
    ctypedef struct ImGuiTableColumn
    ctypedef struct ImGuiTable
    ctypedef struct ImGuiTabItem
    ctypedef struct ImGuiTabBar
    ctypedef struct ImGuiStyleMod
    ctypedef struct ImGuiStackSizes
    ctypedef struct ImGuiSettingsHandler
    ctypedef struct ImGuiPopupData
    ctypedef struct ImGuiOldColumns
    ctypedef struct ImGuiOldColumnData
    ctypedef struct ImGuiNextItemData
    ctypedef struct ImGuiNextWindowData
    ctypedef struct ImGuiMetricsConfig
    ctypedef struct ImGuiNavItemData
    ctypedef struct ImGuiMenuColumns
    ctypedef struct ImGuiLastItemData
    ctypedef struct ImGuiInputTextState
    ctypedef struct ImGuiGroupData
    ctypedef struct ImGuiDataTypeInfo
    ctypedef struct ImGuiContextHook
    ctypedef struct ImGuiColorMod
    ctypedef struct ImDrawDataBuilder
    ctypedef struct ImRect
    ctypedef struct ImBitVector
    ctypedef struct ImFontAtlasCustomRect
    ctypedef struct ImDrawCmdHeader
    ctypedef struct ImGuiStoragePair
    ctypedef struct ImGuiTextRange
    ctypedef struct ImVec4
    ctypedef struct ImVec2
    ctypedef struct ImGuiViewport
    ctypedef struct ImGuiTextFilter
    ctypedef struct ImGuiTextBuffer
    ctypedef struct ImGuiTableColumnSortSpecs
    ctypedef struct ImGuiTableSortSpecs
    ctypedef struct ImGuiStyle
    ctypedef struct ImGuiStorage
    ctypedef struct ImGuiSizeCallbackData
    ctypedef struct ImGuiPayload
    ctypedef struct ImGuiOnceUponAFrame
    ctypedef struct ImGuiListClipper
    ctypedef struct ImGuiInputTextCallbackData
    ctypedef struct ImGuiIO
    ctypedef struct ImGuiContext
    ctypedef struct ImColor
    ctypedef struct ImFontGlyphRangesBuilder
    ctypedef struct ImFontGlyph
    ctypedef struct ImFontConfig
    ctypedef struct ImFontBuilderIO
    ctypedef struct ImFontAtlas
    ctypedef struct ImFont
    ctypedef struct ImDrawVert
    ctypedef struct ImDrawListSplitter
    ctypedef struct ImDrawListSharedData
    ctypedef struct ImDrawList
    ctypedef struct ImDrawData
    ctypedef struct ImDrawCmd
    ctypedef struct ImDrawChannel

    ctypedef int ImGuiCol
    ctypedef int ImGuiCond
    ctypedef int ImGuiDataType
    ctypedef int ImGuiDir
    ctypedef int ImGuiKey
    ctypedef int ImGuiNavInput
    ctypedef int ImGuiMouseButton
    ctypedef int ImGuiMouseCursor
    ctypedef int ImGuiSortDirection
    ctypedef int ImGuiStyleVar
    ctypedef int ImGuiTableBgTarget
    ctypedef int ImDrawFlags
    ctypedef int ImDrawListFlags
    ctypedef int ImFontAtlasFlags
    ctypedef int ImGuiBackendFlags
    ctypedef int ImGuiButtonFlags
    ctypedef int ImGuiColorEditFlags
    ctypedef int ImGuiConfigFlags
    ctypedef int ImGuiComboFlags
    ctypedef int ImGuiDragDropFlags
    ctypedef int ImGuiFocusedFlags
    ctypedef int ImGuiHoveredFlags
    ctypedef int ImGuiInputTextFlags
    ctypedef int ImGuiKeyModFlags
    ctypedef int ImGuiPopupFlags
    ctypedef int ImGuiSelectableFlags
    ctypedef int ImGuiSliderFlags
    ctypedef int ImGuiTabBarFlags
    ctypedef int ImGuiTabItemFlags
    ctypedef int ImGuiTableFlags
    ctypedef int ImGuiTableColumnFlags
    ctypedef int ImGuiTableRowFlags
    ctypedef int ImGuiTreeNodeFlags
    ctypedef int ImGuiViewportFlags
    ctypedef int ImGuiWindowFlags

    ctypedef void* ImTextureID
    ctypedef unsigned int ImGuiID
    ctypedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData* data)
    ctypedef void (*ImGuiSizeCallback)(ImGuiSizeCallbackData* data)
    ctypedef void* (*ImGuiMemAllocFunc)(size_t sz, void* user_data)
    ctypedef void (*ImGuiMemFreeFunc)(void* ptr, void* user_data)
    ctypedef unsigned short ImWchar16
    ctypedef unsigned int ImWchar32
    ctypedef ImWchar16 ImWchar
    ctypedef signed char ImS8
    ctypedef unsigned char ImU8
    ctypedef signed short ImS16
    ctypedef unsigned short ImU16
    ctypedef signed int ImS32
    ctypedef unsigned int ImU32
    ctypedef int64_t ImS64
    ctypedef uint64_t ImU64
    ctypedef void (*ImDrawCallback)(const ImDrawList* parent_list, const ImDrawCmd* cmd)
    ctypedef unsigned short ImDrawIdx

    ctypedef int ImGuiLayoutType
    ctypedef int ImGuiItemFlags
    ctypedef int ImGuiItemAddFlags
    ctypedef int ImGuiItemStatusFlags
    ctypedef int ImGuiOldColumnFlags
    ctypedef int ImGuiNavHighlightFlags
    ctypedef int ImGuiNavDirSourceFlags
    ctypedef int ImGuiNavMoveFlags
    ctypedef int ImGuiNextItemDataFlags
    ctypedef int ImGuiNextWindowDataFlags
    ctypedef int ImGuiSeparatorFlags
    ctypedef int ImGuiTextFlags
    ctypedef int ImGuiTooltipFlags

    ctypedef void (*ImGuiErrorLogCallback)(void* user_data, const char* fmt, ...)
    extern ImGuiContext* GImGui
    ctypedef FILE* ImFileHandle
    ctypedef int ImPoolIdx
    ctypedef void (*ImGuiContextHookCallback)(ImGuiContext* ctx, ImGuiContextHook* hook)
    ctypedef ImS8 ImGuiTableColumnIdx
    ctypedef ImU8 ImGuiTableDrawChannelIdx

    ctypedef struct ImVector:
        int Size
        int Capacity
        void* Data

    ctypedef struct ImVector_ImGuiTableSettings:
        int Size
        int Capacity
        ImGuiTableSettings* Data

    ctypedef struct ImChunkStream_ImGuiTableSettings:
        ImVector_ImGuiTableSettings Buf

    ctypedef struct ImVector_ImGuiWindowSettings:
        int Size
        int Capacity
        ImGuiWindowSettings* Data

    ctypedef struct ImChunkStream_ImGuiWindowSettings:
        ImVector_ImGuiWindowSettings Buf

    ctypedef struct ImSpan_ImGuiTableCellData:
        ImGuiTableCellData* Data
        ImGuiTableCellData* DataEnd

    ctypedef struct ImSpan_ImGuiTableColumn:
        ImGuiTableColumn* Data
        ImGuiTableColumn* DataEnd

    ctypedef struct ImSpan_ImGuiTableColumnIdx:
        ImGuiTableColumnIdx* Data
        ImGuiTableColumnIdx* DataEnd

    ctypedef struct ImVector_ImDrawChannel:
        int Size
        int Capacity
        ImDrawChannel* Data
        
    ctypedef struct ImVector_ImDrawCmd:
        int Size
        int Capacity
        ImDrawCmd* Data

    ctypedef struct ImVector_ImDrawIdx:
        int Size
        int Capacity
        ImDrawIdx* Data

    ctypedef struct ImVector_ImDrawListPtr:
        int Size
        int Capacity
        ImDrawList** Data
        
    ctypedef struct ImVector_ImDrawVert:
        int Size
        int Capacity
        ImDrawVert* Data

    ctypedef struct ImVector_ImFontPtr:
        int Size
        int Capacity
        ImFont** Data

    ctypedef struct ImVector_ImFontAtlasCustomRect:
        int Size
        int Capacity
        ImFontAtlasCustomRect* Data

    ctypedef struct ImVector_ImFontConfig:
        int Size
        int Capacity
        ImFontConfig* Data

    ctypedef struct ImVector_ImFontGlyph:
        int Size
        int Capacity
        ImFontGlyph* Data

    ctypedef struct ImVector_ImGuiColorMod:
        int Size
        int Capacity
        ImGuiColorMod* Data

    ctypedef struct ImVector_ImGuiContextHook:
        int Size
        int Capacity
        ImGuiContextHook* Data

    ctypedef struct ImVector_ImGuiGroupData:
        int Size
        int Capacity
        ImGuiGroupData* Data

    ctypedef struct ImVector_ImGuiID:
        int Size
        int Capacity
        ImGuiID* Data

    ctypedef struct ImVector_ImGuiItemFlags:
        int Size
        int Capacity
        ImGuiItemFlags* Data

    ctypedef struct ImVector_ImGuiOldColumnData:
        int Size
        int Capacity
        ImGuiOldColumnData* Data

    ctypedef struct ImVector_ImGuiOldColumns:
        int Size
        int Capacity
        ImGuiOldColumns* Data

    ctypedef struct ImVector_ImGuiPopupData:
        int Size
        int Capacity
        ImGuiPopupData* Data

    ctypedef struct ImVector_ImGuiPtrOrIndex:
        int Size
        int Capacity
        ImGuiPtrOrIndex* Data

    ctypedef struct ImVector_ImGuiSettingsHandler:
        int Size
        int Capacity
        ImGuiSettingsHandler* Data

    ctypedef struct ImVector_ImGuiShrinkWidthItem:
        int Size
        int Capacity
        ImGuiShrinkWidthItem* Data

    ctypedef struct ImVector_ImGuiStoragePair:
        int Size
        int Capacity
        ImGuiStoragePair* Data

    ctypedef struct ImVector_ImGuiStyleMod:
        int Size
        int Capacity
        ImGuiStyleMod* Data

    ctypedef struct ImVector_ImGuiTabItem:
        int Size
        int Capacity
        ImGuiTabItem* Data

    ctypedef struct ImVector_ImGuiTableColumnSortSpecs:
        int Size
        int Capacity
        ImGuiTableColumnSortSpecs* Data

    ctypedef struct ImVector_ImGuiTableTempData:
        int Size
        int Capacity
        ImGuiTableTempData* Data

    ctypedef struct ImVector_ImGuiTextRange:
        int Size
        int Capacity
        ImGuiTextRange* Data

    ctypedef struct ImVector_ImGuiViewportPPtr:
        int Size
        int Capacity
        ImGuiViewportP** Data

    ctypedef struct ImVector_ImGuiWindowPtr:
        int Size
        int Capacity
        ImGuiWindow** Data

    ctypedef struct ImVector_ImGuiWindowStackData:
        int Size
        int Capacity
        ImGuiWindowStackData* Data

    ctypedef struct ImVector_ImTextureID:
        int Size
        int Capacity
        ImTextureID* Data

    ctypedef struct ImVector_ImU32:
        int Size
        int Capacity
        ImU32* Data

    ctypedef struct ImVector_ImVec2:
        int Size
        int Capacity
        ImVec2* Data

    ctypedef struct ImVector_ImVec4:
        int Size
        int Capacity
        ImVec4* Data

    ctypedef struct ImVector_ImWchar:
        int Size
        int Capacity
        ImWchar* Data

    ctypedef struct ImVector_char:
        int Size
        int Capacity
        char* Data

    ctypedef struct ImVector_float:
        int Size
        int Capacity
        float* Data

    ctypedef struct ImVector_unsigned_char:
        int Size
        int Capacity
        unsigned char* Data

    ctypedef struct ImVec2:
        float x, y

    ctypedef struct ImVec4:
        float x, y, z, w

    ctypedef enum ImGuiWindowFlags_:
        ImGuiWindowFlags_None = 0,
        ImGuiWindowFlags_NoTitleBar = 1 << 0,
        ImGuiWindowFlags_NoResize = 1 << 1,
        ImGuiWindowFlags_NoMove = 1 << 2,
        ImGuiWindowFlags_NoScrollbar = 1 << 3,
        ImGuiWindowFlags_NoScrollWithMouse = 1 << 4,
        ImGuiWindowFlags_NoCollapse = 1 << 5,
        ImGuiWindowFlags_AlwaysAutoResize = 1 << 6,
        ImGuiWindowFlags_NoBackground = 1 << 7,
        ImGuiWindowFlags_NoSavedSettings = 1 << 8,
        ImGuiWindowFlags_NoMouseInputs = 1 << 9,
        ImGuiWindowFlags_MenuBar = 1 << 10,
        ImGuiWindowFlags_HorizontalScrollbar = 1 << 11,
        ImGuiWindowFlags_NoFocusOnAppearing = 1 << 12,
        ImGuiWindowFlags_NoBringToFrontOnFocus = 1 << 13,
        ImGuiWindowFlags_AlwaysVerticalScrollbar= 1 << 14,
        ImGuiWindowFlags_AlwaysHorizontalScrollbar=1<< 15,
        ImGuiWindowFlags_AlwaysUseWindowPadding = 1 << 16,
        ImGuiWindowFlags_NoNavInputs = 1 << 18,
        ImGuiWindowFlags_NoNavFocus = 1 << 19,
        ImGuiWindowFlags_UnsavedDocument = 1 << 20,
        ImGuiWindowFlags_NoNav = ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,
        ImGuiWindowFlags_NoDecoration = ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar | ImGuiWindowFlags_NoCollapse,
        ImGuiWindowFlags_NoInputs = ImGuiWindowFlags_NoMouseInputs | ImGuiWindowFlags_NoNavInputs | ImGuiWindowFlags_NoNavFocus,
        ImGuiWindowFlags_NavFlattened = 1 << 23,
        ImGuiWindowFlags_ChildWindow = 1 << 24,
        ImGuiWindowFlags_Tooltip = 1 << 25,
        ImGuiWindowFlags_Popup = 1 << 26,
        ImGuiWindowFlags_Modal = 1 << 27,
        ImGuiWindowFlags_ChildMenu = 1 << 28

    ctypedef enum ImGuiInputTextFlags_:
        ImGuiInputTextFlags_None = 0,
        ImGuiInputTextFlags_CharsDecimal = 1 << 0,
        ImGuiInputTextFlags_CharsHexadecimal = 1 << 1,
        ImGuiInputTextFlags_CharsUppercase = 1 << 2,
        ImGuiInputTextFlags_CharsNoBlank = 1 << 3,
        ImGuiInputTextFlags_AutoSelectAll = 1 << 4,
        ImGuiInputTextFlags_EnterReturnsTrue = 1 << 5,
        ImGuiInputTextFlags_CallbackCompletion = 1 << 6,
        ImGuiInputTextFlags_CallbackHistory = 1 << 7,
        ImGuiInputTextFlags_CallbackAlways = 1 << 8,
        ImGuiInputTextFlags_CallbackCharFilter = 1 << 9,
        ImGuiInputTextFlags_AllowTabInput = 1 << 10,
        ImGuiInputTextFlags_CtrlEnterForNewLine = 1 << 11,
        ImGuiInputTextFlags_NoHorizontalScroll = 1 << 12,
        ImGuiInputTextFlags_AlwaysOverwrite = 1 << 13,
        ImGuiInputTextFlags_ReadOnly = 1 << 14,
        ImGuiInputTextFlags_Password = 1 << 15,
        ImGuiInputTextFlags_NoUndoRedo = 1 << 16,
        ImGuiInputTextFlags_CharsScientific = 1 << 17,
        ImGuiInputTextFlags_CallbackResize = 1 << 18,
        ImGuiInputTextFlags_CallbackEdit = 1 << 19

    ctypedef enum ImGuiTreeNodeFlags_:
        ImGuiTreeNodeFlags_None = 0,
        ImGuiTreeNodeFlags_Selected = 1 << 0,
        ImGuiTreeNodeFlags_Framed = 1 << 1,
        ImGuiTreeNodeFlags_AllowItemOverlap = 1 << 2,
        ImGuiTreeNodeFlags_NoTreePushOnOpen = 1 << 3,
        ImGuiTreeNodeFlags_NoAutoOpenOnLog = 1 << 4,
        ImGuiTreeNodeFlags_DefaultOpen = 1 << 5,
        ImGuiTreeNodeFlags_OpenOnDoubleClick = 1 << 6,
        ImGuiTreeNodeFlags_OpenOnArrow = 1 << 7,
        ImGuiTreeNodeFlags_Leaf = 1 << 8,
        ImGuiTreeNodeFlags_Bullet = 1 << 9,
        ImGuiTreeNodeFlags_FramePadding = 1 << 10,
        ImGuiTreeNodeFlags_SpanAvailWidth = 1 << 11,
        ImGuiTreeNodeFlags_SpanFullWidth = 1 << 12,
        ImGuiTreeNodeFlags_NavLeftJumpsBackHere = 1 << 13,
        ImGuiTreeNodeFlags_CollapsingHeader = ImGuiTreeNodeFlags_Framed | ImGuiTreeNodeFlags_NoTreePushOnOpen | ImGuiTreeNodeFlags_NoAutoOpenOnLog
    
    ctypedef enum ImGuiPopupFlags_:
        ImGuiPopupFlags_None = 0,
        ImGuiPopupFlags_MouseButtonLeft = 0,
        ImGuiPopupFlags_MouseButtonRight = 1,
        ImGuiPopupFlags_MouseButtonMiddle = 2,
        ImGuiPopupFlags_MouseButtonMask_ = 0x1F,
        ImGuiPopupFlags_MouseButtonDefault_ = 1,
        ImGuiPopupFlags_NoOpenOverExistingPopup = 1 << 5,
        ImGuiPopupFlags_NoOpenOverItems = 1 << 6,
        ImGuiPopupFlags_AnyPopupId = 1 << 7,
        ImGuiPopupFlags_AnyPopupLevel = 1 << 8,
        ImGuiPopupFlags_AnyPopup = ImGuiPopupFlags_AnyPopupId | ImGuiPopupFlags_AnyPopupLevel

    ctypedef enum ImGuiSelectableFlags_:
        ImGuiSelectableFlags_None = 0,
        ImGuiSelectableFlags_DontClosePopups = 1 << 0,
        ImGuiSelectableFlags_SpanAllColumns = 1 << 1,
        ImGuiSelectableFlags_AllowDoubleClick = 1 << 2,
        ImGuiSelectableFlags_Disabled = 1 << 3,
        ImGuiSelectableFlags_AllowItemOverlap = 1 << 4

    ctypedef enum ImGuiComboFlags_:
        ImGuiComboFlags_None = 0,
        ImGuiComboFlags_PopupAlignLeft = 1 << 0,
        ImGuiComboFlags_HeightSmall = 1 << 1,
        ImGuiComboFlags_HeightRegular = 1 << 2,
        ImGuiComboFlags_HeightLarge = 1 << 3,
        ImGuiComboFlags_HeightLargest = 1 << 4,
        ImGuiComboFlags_NoArrowButton = 1 << 5,
        ImGuiComboFlags_NoPreview = 1 << 6,
        ImGuiComboFlags_HeightMask_ = ImGuiComboFlags_HeightSmall | ImGuiComboFlags_HeightRegular | ImGuiComboFlags_HeightLarge | ImGuiComboFlags_HeightLargest

    ctypedef enum ImGuiTabBarFlags_:
        ImGuiTabBarFlags_None = 0,
        ImGuiTabBarFlags_Reorderable = 1 << 0,
        ImGuiTabBarFlags_AutoSelectNewTabs = 1 << 1,
        ImGuiTabBarFlags_TabListPopupButton = 1 << 2,
        ImGuiTabBarFlags_NoCloseWithMiddleMouseButton = 1 << 3,
        ImGuiTabBarFlags_NoTabListScrollingButtons = 1 << 4,
        ImGuiTabBarFlags_NoTooltip = 1 << 5,
        ImGuiTabBarFlags_FittingPolicyResizeDown = 1 << 6,
        ImGuiTabBarFlags_FittingPolicyScroll = 1 << 7,
        ImGuiTabBarFlags_FittingPolicyMask_ = ImGuiTabBarFlags_FittingPolicyResizeDown | ImGuiTabBarFlags_FittingPolicyScroll,
        ImGuiTabBarFlags_FittingPolicyDefault_ = ImGuiTabBarFlags_FittingPolicyResizeDown

    ctypedef enum ImGuiTabItemFlags_:
        ImGuiTabItemFlags_None = 0,
        ImGuiTabItemFlags_UnsavedDocument = 1 << 0,
        ImGuiTabItemFlags_SetSelected = 1 << 1,
        ImGuiTabItemFlags_NoCloseWithMiddleMouseButton = 1 << 2,
        ImGuiTabItemFlags_NoPushId = 1 << 3,
        ImGuiTabItemFlags_NoTooltip = 1 << 4,
        ImGuiTabItemFlags_NoReorder = 1 << 5,
        ImGuiTabItemFlags_Leading = 1 << 6,
        ImGuiTabItemFlags_Trailing = 1 << 7

    ctypedef enum ImGuiTableFlags_:
        ImGuiTableFlags_None = 0,
        ImGuiTableFlags_Resizable = 1 << 0,
        ImGuiTableFlags_Reorderable = 1 << 1,
        ImGuiTableFlags_Hideable = 1 << 2,
        ImGuiTableFlags_Sortable = 1 << 3,
        ImGuiTableFlags_NoSavedSettings = 1 << 4,
        ImGuiTableFlags_ContextMenuInBody = 1 << 5,
        ImGuiTableFlags_RowBg = 1 << 6,
        ImGuiTableFlags_BordersInnerH = 1 << 7,
        ImGuiTableFlags_BordersOuterH = 1 << 8,
        ImGuiTableFlags_BordersInnerV = 1 << 9,
        ImGuiTableFlags_BordersOuterV = 1 << 10,
        ImGuiTableFlags_BordersH = ImGuiTableFlags_BordersInnerH | ImGuiTableFlags_BordersOuterH,
        ImGuiTableFlags_BordersV = ImGuiTableFlags_BordersInnerV | ImGuiTableFlags_BordersOuterV,
        ImGuiTableFlags_BordersInner = ImGuiTableFlags_BordersInnerV | ImGuiTableFlags_BordersInnerH,
        ImGuiTableFlags_BordersOuter = ImGuiTableFlags_BordersOuterV | ImGuiTableFlags_BordersOuterH,
        ImGuiTableFlags_Borders = ImGuiTableFlags_BordersInner | ImGuiTableFlags_BordersOuter,
        ImGuiTableFlags_NoBordersInBody = 1 << 11,
        ImGuiTableFlags_NoBordersInBodyUntilResize = 1 << 12,
        ImGuiTableFlags_SizingFixedFit = 1 << 13,
        ImGuiTableFlags_SizingFixedSame = 2 << 13,
        ImGuiTableFlags_SizingStretchProp = 3 << 13,
        ImGuiTableFlags_SizingStretchSame = 4 << 13,
        ImGuiTableFlags_NoHostExtendX = 1 << 16,
        ImGuiTableFlags_NoHostExtendY = 1 << 17,
        ImGuiTableFlags_NoKeepColumnsVisible = 1 << 18,
        ImGuiTableFlags_PreciseWidths = 1 << 19,
        ImGuiTableFlags_NoClip = 1 << 20,
        ImGuiTableFlags_PadOuterX = 1 << 21,
        ImGuiTableFlags_NoPadOuterX = 1 << 22,
        ImGuiTableFlags_NoPadInnerX = 1 << 23,
        ImGuiTableFlags_ScrollX = 1 << 24,
        ImGuiTableFlags_ScrollY = 1 << 25,
        ImGuiTableFlags_SortMulti = 1 << 26,
        ImGuiTableFlags_SortTristate = 1 << 27,
        ImGuiTableFlags_SizingMask_ = ImGuiTableFlags_SizingFixedFit | ImGuiTableFlags_SizingFixedSame | ImGuiTableFlags_SizingStretchProp | ImGuiTableFlags_SizingStretchSame

    ctypedef enum ImGuiTableColumnFlags_:
        ImGuiTableColumnFlags_None = 0,
        ImGuiTableColumnFlags_Disabled = 1 << 0,
        ImGuiTableColumnFlags_DefaultHide = 1 << 1,
        ImGuiTableColumnFlags_DefaultSort = 1 << 2,
        ImGuiTableColumnFlags_WidthStretch = 1 << 3,
        ImGuiTableColumnFlags_WidthFixed = 1 << 4,
        ImGuiTableColumnFlags_NoResize = 1 << 5,
        ImGuiTableColumnFlags_NoReorder = 1 << 6,
        ImGuiTableColumnFlags_NoHide = 1 << 7,
        ImGuiTableColumnFlags_NoClip = 1 << 8,
        ImGuiTableColumnFlags_NoSort = 1 << 9,
        ImGuiTableColumnFlags_NoSortAscending = 1 << 10,
        ImGuiTableColumnFlags_NoSortDescending = 1 << 11,
        ImGuiTableColumnFlags_NoHeaderLabel = 1 << 12,
        ImGuiTableColumnFlags_NoHeaderWidth = 1 << 13,
        ImGuiTableColumnFlags_PreferSortAscending = 1 << 14,
        ImGuiTableColumnFlags_PreferSortDescending = 1 << 15,
        ImGuiTableColumnFlags_IndentEnable = 1 << 16,
        ImGuiTableColumnFlags_IndentDisable = 1 << 17,
        ImGuiTableColumnFlags_IsEnabled = 1 << 24,
        ImGuiTableColumnFlags_IsVisible = 1 << 25,
        ImGuiTableColumnFlags_IsSorted = 1 << 26,
        ImGuiTableColumnFlags_IsHovered = 1 << 27,
        ImGuiTableColumnFlags_WidthMask_ = ImGuiTableColumnFlags_WidthStretch | ImGuiTableColumnFlags_WidthFixed,
        ImGuiTableColumnFlags_IndentMask_ = ImGuiTableColumnFlags_IndentEnable | ImGuiTableColumnFlags_IndentDisable,
        ImGuiTableColumnFlags_StatusMask_ = ImGuiTableColumnFlags_IsEnabled | ImGuiTableColumnFlags_IsVisible | ImGuiTableColumnFlags_IsSorted | ImGuiTableColumnFlags_IsHovered,
        ImGuiTableColumnFlags_NoDirectResize_ = 1 << 30

    ctypedef enum ImGuiTableRowFlags_:
        ImGuiTableRowFlags_None = 0,
        ImGuiTableRowFlags_Headers = 1 << 0

    ctypedef enum ImGuiTableBgTarget_:
        ImGuiTableBgTarget_None = 0,
        ImGuiTableBgTarget_RowBg0 = 1,
        ImGuiTableBgTarget_RowBg1 = 2,
        ImGuiTableBgTarget_CellBg = 3

    ctypedef enum ImGuiFocusedFlags_:
        ImGuiFocusedFlags_None = 0,
        ImGuiFocusedFlags_ChildWindows = 1 << 0,
        ImGuiFocusedFlags_RootWindow = 1 << 1,
        ImGuiFocusedFlags_AnyWindow = 1 << 2,
        ImGuiFocusedFlags_RootAndChildWindows = ImGuiFocusedFlags_RootWindow | ImGuiFocusedFlags_ChildWindows

    ctypedef enum ImGuiHoveredFlags_:
        ImGuiHoveredFlags_None = 0,
        ImGuiHoveredFlags_ChildWindows = 1 << 0,
        ImGuiHoveredFlags_RootWindow = 1 << 1,
        ImGuiHoveredFlags_AnyWindow = 1 << 2,
        ImGuiHoveredFlags_AllowWhenBlockedByPopup = 1 << 3,
        ImGuiHoveredFlags_AllowWhenBlockedByActiveItem = 1 << 5,
        ImGuiHoveredFlags_AllowWhenOverlapped = 1 << 6,
        ImGuiHoveredFlags_AllowWhenDisabled = 1 << 7,
        ImGuiHoveredFlags_RectOnly = ImGuiHoveredFlags_AllowWhenBlockedByPopup | ImGuiHoveredFlags_AllowWhenBlockedByActiveItem | ImGuiHoveredFlags_AllowWhenOverlapped,
        ImGuiHoveredFlags_RootAndChildWindows = ImGuiHoveredFlags_RootWindow | ImGuiHoveredFlags_ChildWindows

    ctypedef enum ImGuiDragDropFlags_:
        ImGuiDragDropFlags_None = 0,
        ImGuiDragDropFlags_SourceNoPreviewTooltip = 1 << 0,
        ImGuiDragDropFlags_SourceNoDisableHover = 1 << 1,
        ImGuiDragDropFlags_SourceNoHoldToOpenOthers = 1 << 2,
        ImGuiDragDropFlags_SourceAllowNullID = 1 << 3,
        ImGuiDragDropFlags_SourceExtern = 1 << 4,
        ImGuiDragDropFlags_SourceAutoExpirePayload = 1 << 5,
        ImGuiDragDropFlags_AcceptBeforeDelivery = 1 << 10,
        ImGuiDragDropFlags_AcceptNoDrawDefaultRect = 1 << 11,
        ImGuiDragDropFlags_AcceptNoPreviewTooltip = 1 << 12,
        ImGuiDragDropFlags_AcceptPeekOnly = ImGuiDragDropFlags_AcceptBeforeDelivery | ImGuiDragDropFlags_AcceptNoDrawDefaultRect

    ctypedef enum ImGuiDataType_:
        ImGuiDataType_S8,
        ImGuiDataType_U8,
        ImGuiDataType_S16,
        ImGuiDataType_U16,
        ImGuiDataType_S32,
        ImGuiDataType_U32,
        ImGuiDataType_S64,
        ImGuiDataType_U64,
        ImGuiDataType_Float,
        ImGuiDataType_Double,
        ImGuiDataType_COUNT

    ctypedef enum ImGuiDir_:
        ImGuiDir_None = -1,
        ImGuiDir_Left = 0,
        ImGuiDir_Right = 1,
        ImGuiDir_Up = 2,
        ImGuiDir_Down = 3,
        ImGuiDir_COUNT

    ctypedef enum ImGuiSortDirection_:
        ImGuiSortDirection_None = 0,
        ImGuiSortDirection_Ascending = 1,
        ImGuiSortDirection_Descending = 2

    ctypedef enum ImGuiKey_:
        ImGuiKey_Tab,
        ImGuiKey_LeftArrow,
        ImGuiKey_RightArrow,
        ImGuiKey_UpArrow,
        ImGuiKey_DownArrow,
        ImGuiKey_PageUp,
        ImGuiKey_PageDown,
        ImGuiKey_Home,
        ImGuiKey_End,
        ImGuiKey_Insert,
        ImGuiKey_Delete,
        ImGuiKey_Backspace,
        ImGuiKey_Space,
        ImGuiKey_Enter,
        ImGuiKey_Escape,
        ImGuiKey_KeyPadEnter,
        ImGuiKey_A,
        ImGuiKey_C,
        ImGuiKey_V,
        ImGuiKey_X,
        ImGuiKey_Y,
        ImGuiKey_Z,
        ImGuiKey_COUNT

    ctypedef enum ImGuiKeyModFlags_:
        ImGuiKeyModFlags_None = 0,
        ImGuiKeyModFlags_Ctrl = 1 << 0,
        ImGuiKeyModFlags_Shift = 1 << 1,
        ImGuiKeyModFlags_Alt = 1 << 2,
        ImGuiKeyModFlags_Super = 1 << 3

    ctypedef enum ImGuiNavInput_:
        ImGuiNavInput_Activate,
        ImGuiNavInput_Cancel,
        ImGuiNavInput_Input,
        ImGuiNavInput_Menu,
        ImGuiNavInput_DpadLeft,
        ImGuiNavInput_DpadRight,
        ImGuiNavInput_DpadUp,
        ImGuiNavInput_DpadDown,
        ImGuiNavInput_LStickLeft,
        ImGuiNavInput_LStickRight,
        ImGuiNavInput_LStickUp,
        ImGuiNavInput_LStickDown,
        ImGuiNavInput_FocusPrev,
        ImGuiNavInput_FocusNext,
        ImGuiNavInput_TweakSlow,
        ImGuiNavInput_TweakFast,
        ImGuiNavInput_KeyLeft_,
        ImGuiNavInput_KeyRight_,
        ImGuiNavInput_KeyUp_,
        ImGuiNavInput_KeyDown_,
        ImGuiNavInput_COUNT,
        ImGuiNavInput_InternalStart_ = ImGuiNavInput_KeyLeft_

    ctypedef enum ImGuiConfigFlags_:
        ImGuiConfigFlags_None = 0,
        ImGuiConfigFlags_NavEnableKeyboard = 1 << 0,
        ImGuiConfigFlags_NavEnableGamepad = 1 << 1,
        ImGuiConfigFlags_NavEnableSetMousePos = 1 << 2,
        ImGuiConfigFlags_NavNoCaptureKeyboard = 1 << 3,
        ImGuiConfigFlags_NoMouse = 1 << 4,
        ImGuiConfigFlags_NoMouseCursorChange = 1 << 5,
        ImGuiConfigFlags_IsSRGB = 1 << 20,
        ImGuiConfigFlags_IsTouchScreen = 1 << 21

    ctypedef enum ImGuiBackendFlags_:
        ImGuiBackendFlags_None = 0,
        ImGuiBackendFlags_HasGamepad = 1 << 0,
        ImGuiBackendFlags_HasMouseCursors = 1 << 1,
        ImGuiBackendFlags_HasSetMousePos = 1 << 2,
        ImGuiBackendFlags_RendererHasVtxOffset = 1 << 3

    ctypedef enum ImGuiCol_:
        ImGuiCol_Text,
        ImGuiCol_TextDisabled,
        ImGuiCol_WindowBg,
        ImGuiCol_ChildBg,
        ImGuiCol_PopupBg,
        ImGuiCol_Border,
        ImGuiCol_BorderShadow,
        ImGuiCol_FrameBg,
        ImGuiCol_FrameBgHovered,
        ImGuiCol_FrameBgActive,
        ImGuiCol_TitleBg,
        ImGuiCol_TitleBgActive,
        ImGuiCol_TitleBgCollapsed,
        ImGuiCol_MenuBarBg,
        ImGuiCol_ScrollbarBg,
        ImGuiCol_ScrollbarGrab,
        ImGuiCol_ScrollbarGrabHovered,
        ImGuiCol_ScrollbarGrabActive,
        ImGuiCol_CheckMark,
        ImGuiCol_SliderGrab,
        ImGuiCol_SliderGrabActive,
        ImGuiCol_Button,
        ImGuiCol_ButtonHovered,
        ImGuiCol_ButtonActive,
        ImGuiCol_Header,
        ImGuiCol_HeaderHovered,
        ImGuiCol_HeaderActive,
        ImGuiCol_Separator,
        ImGuiCol_SeparatorHovered,
        ImGuiCol_SeparatorActive,
        ImGuiCol_ResizeGrip,
        ImGuiCol_ResizeGripHovered,
        ImGuiCol_ResizeGripActive,
        ImGuiCol_Tab,
        ImGuiCol_TabHovered,
        ImGuiCol_TabActive,
        ImGuiCol_TabUnfocused,
        ImGuiCol_TabUnfocusedActive,
        ImGuiCol_PlotLines,
        ImGuiCol_PlotLinesHovered,
        ImGuiCol_PlotHistogram,
        ImGuiCol_PlotHistogramHovered,
        ImGuiCol_TableHeaderBg,
        ImGuiCol_TableBorderStrong,
        ImGuiCol_TableBorderLight,
        ImGuiCol_TableRowBg,
        ImGuiCol_TableRowBgAlt,
        ImGuiCol_TextSelectedBg,
        ImGuiCol_DragDropTarget,
        ImGuiCol_NavHighlight,
        ImGuiCol_NavWindowingHighlight,
        ImGuiCol_NavWindowingDimBg,
        ImGuiCol_ModalWindowDimBg,
        ImGuiCol_COUNT

    ctypedef enum ImGuiStyleVar_:
        ImGuiStyleVar_Alpha,
        ImGuiStyleVar_DisabledAlpha,
        ImGuiStyleVar_WindowPadding,
        ImGuiStyleVar_WindowRounding,
        ImGuiStyleVar_WindowBorderSize,
        ImGuiStyleVar_WindowMinSize,
        ImGuiStyleVar_WindowTitleAlign,
        ImGuiStyleVar_ChildRounding,
        ImGuiStyleVar_ChildBorderSize,
        ImGuiStyleVar_PopupRounding,
        ImGuiStyleVar_PopupBorderSize,
        ImGuiStyleVar_FramePadding,
        ImGuiStyleVar_FrameRounding,
        ImGuiStyleVar_FrameBorderSize,
        ImGuiStyleVar_ItemSpacing,
        ImGuiStyleVar_ItemInnerSpacing,
        ImGuiStyleVar_IndentSpacing,
        ImGuiStyleVar_CellPadding,
        ImGuiStyleVar_ScrollbarSize,
        ImGuiStyleVar_ScrollbarRounding,
        ImGuiStyleVar_GrabMinSize,
        ImGuiStyleVar_GrabRounding,
        ImGuiStyleVar_TabRounding,
        ImGuiStyleVar_ButtonTextAlign,
        ImGuiStyleVar_SelectableTextAlign,
        ImGuiStyleVar_COUNT

    ctypedef enum ImGuiButtonFlags_:
        ImGuiButtonFlags_None = 0,
        ImGuiButtonFlags_MouseButtonLeft = 1 << 0,
        ImGuiButtonFlags_MouseButtonRight = 1 << 1,
        ImGuiButtonFlags_MouseButtonMiddle = 1 << 2,
        ImGuiButtonFlags_MouseButtonMask_ = ImGuiButtonFlags_MouseButtonLeft | ImGuiButtonFlags_MouseButtonRight | ImGuiButtonFlags_MouseButtonMiddle,
        ImGuiButtonFlags_MouseButtonDefault_ = ImGuiButtonFlags_MouseButtonLeft

    ctypedef enum ImGuiColorEditFlags_:
        ImGuiColorEditFlags_None = 0,
        ImGuiColorEditFlags_NoAlpha = 1 << 1,
        ImGuiColorEditFlags_NoPicker = 1 << 2,
        ImGuiColorEditFlags_NoOptions = 1 << 3,
        ImGuiColorEditFlags_NoSmallPreview = 1 << 4,
        ImGuiColorEditFlags_NoInputs = 1 << 5,
        ImGuiColorEditFlags_NoTooltip = 1 << 6,
        ImGuiColorEditFlags_NoLabel = 1 << 7,
        ImGuiColorEditFlags_NoSidePreview = 1 << 8,
        ImGuiColorEditFlags_NoDragDrop = 1 << 9,
        ImGuiColorEditFlags_NoBorder = 1 << 10,
        ImGuiColorEditFlags_AlphaBar = 1 << 16,
        ImGuiColorEditFlags_AlphaPreview = 1 << 17,
        ImGuiColorEditFlags_AlphaPreviewHalf= 1 << 18,
        ImGuiColorEditFlags_HDR = 1 << 19,
        ImGuiColorEditFlags_DisplayRGB = 1 << 20,
        ImGuiColorEditFlags_DisplayHSV = 1 << 21,
        ImGuiColorEditFlags_DisplayHex = 1 << 22,
        ImGuiColorEditFlags_Uint8 = 1 << 23,
        ImGuiColorEditFlags_Float = 1 << 24,
        ImGuiColorEditFlags_PickerHueBar = 1 << 25,
        ImGuiColorEditFlags_PickerHueWheel = 1 << 26,
        ImGuiColorEditFlags_InputRGB = 1 << 27,
        ImGuiColorEditFlags_InputHSV = 1 << 28,
        ImGuiColorEditFlags_DefaultOptions_ = ImGuiColorEditFlags_Uint8 | ImGuiColorEditFlags_DisplayRGB | ImGuiColorEditFlags_InputRGB | ImGuiColorEditFlags_PickerHueBar,
        ImGuiColorEditFlags_DisplayMask_ = ImGuiColorEditFlags_DisplayRGB | ImGuiColorEditFlags_DisplayHSV | ImGuiColorEditFlags_DisplayHex,
        ImGuiColorEditFlags_DataTypeMask_ = ImGuiColorEditFlags_Uint8 | ImGuiColorEditFlags_Float,
        ImGuiColorEditFlags_PickerMask_ = ImGuiColorEditFlags_PickerHueWheel | ImGuiColorEditFlags_PickerHueBar,
        ImGuiColorEditFlags_InputMask_ = ImGuiColorEditFlags_InputRGB | ImGuiColorEditFlags_InputHSV

    ctypedef enum ImGuiSliderFlags_:
        ImGuiSliderFlags_None = 0,
        ImGuiSliderFlags_AlwaysClamp = 1 << 4,
        ImGuiSliderFlags_Logarithmic = 1 << 5,
        ImGuiSliderFlags_NoRoundToFormat = 1 << 6,
        ImGuiSliderFlags_NoInput = 1 << 7,
        ImGuiSliderFlags_InvalidMask_ = 0x7000000F

    ctypedef enum ImGuiMouseButton_:
        ImGuiMouseButton_Left = 0,
        ImGuiMouseButton_Right = 1,
        ImGuiMouseButton_Middle = 2,
        ImGuiMouseButton_COUNT = 5

    ctypedef enum ImGuiMouseCursor_:
        ImGuiMouseCursor_None = -1,
        ImGuiMouseCursor_Arrow = 0,
        ImGuiMouseCursor_TextInput,
        ImGuiMouseCursor_ResizeAll,
        ImGuiMouseCursor_ResizeNS,
        ImGuiMouseCursor_ResizeEW,
        ImGuiMouseCursor_ResizeNESW,
        ImGuiMouseCursor_ResizeNWSE,
        ImGuiMouseCursor_Hand,
        ImGuiMouseCursor_NotAllowed,
        ImGuiMouseCursor_COUNT

    ctypedef enum ImGuiCond_:
        ImGuiCond_None = 0,
        ImGuiCond_Always = 1 << 0,
        ImGuiCond_Once = 1 << 1,
        ImGuiCond_FirstUseEver = 1 << 2,
        ImGuiCond_Appearing = 1 << 3

    ctypedef struct ImGuiStyle:
        float Alpha
        float DisabledAlpha
        ImVec2 WindowPadding
        float WindowRounding
        float WindowBorderSize
        ImVec2 WindowMinSize
        ImVec2 WindowTitleAlign
        ImGuiDir WindowMenuButtonPosition
        float ChildRounding
        float ChildBorderSize
        float PopupRounding
        float PopupBorderSize
        ImVec2 FramePadding
        float FrameRounding
        float FrameBorderSize
        ImVec2 ItemSpacing
        ImVec2 ItemInnerSpacing
        ImVec2 CellPadding
        ImVec2 TouchExtraPadding
        float IndentSpacing
        float ColumnsMinSpacing
        float ScrollbarSize
        float ScrollbarRounding
        float GrabMinSize
        float GrabRounding
        float LogSliderDeadzone
        float TabRounding
        float TabBorderSize
        float TabMinWidthForCloseButton
        ImGuiDir ColorButtonPosition
        ImVec2 ButtonTextAlign
        ImVec2 SelectableTextAlign
        ImVec2 DisplayWindowPadding
        ImVec2 DisplaySafeAreaPadding
        float MouseCursorScale
        bint AntiAliasedLines
        bint AntiAliasedLinesUseTex
        bint AntiAliasedFill
        float CurveTessellationTol
        float CircleTessellationMaxError
        #ImVec4 Colors[ImGuiCol_COUNT]
        ImVec4* Colors

    ctypedef struct ImGuiIO:
        ImGuiConfigFlags ConfigFlags
        ImGuiBackendFlags BackendFlags
        ImVec2 DisplaySize
        float DeltaTime
        float IniSavingRate
        const char* IniFilename
        const char* LogFilename
        float MouseDoubleClickTime
        float MouseDoubleClickMaxDist
        float MouseDragThreshold
        #int KeyMap[ImGuiKey_COUNT]
        int* KeyMap
        float KeyRepeatDelay
        float KeyRepeatRate
        void* UserData
        ImFontAtlas*Fonts
        float FontGlobalScale
        bint FontAllowUserScaling
        ImFont* FontDefault
        ImVec2 DisplayFramebufferScale
        bint MouseDrawCursor
        bint ConfigMacOSXBehaviors
        bint ConfigInputTextCursorBlink
        bint ConfigDragClickToInputText
        bint ConfigWindowsResizeFromEdges
        bint ConfigWindowsMoveFromTitleBarOnly
        float ConfigMemoryCompactTimer
        const char* BackendPlatformName
        const char* BackendRendererName
        void* BackendPlatformUserData
        void* BackendRendererUserData
        void* BackendLanguageUserData
        const char* (*GetClipboardTextFn)(void* user_data)
        void (*SetClipboardTextFn)(void* user_data, const char* text)
        void* ClipboardUserData
        void (*ImeSetInputScreenPosFn)(int x, int y)
        void* ImeWindowHandle
        ImVec2 MousePos
        bint MouseDown[5]
        float MouseWheel
        float MouseWheelH
        bint KeyCtrl
        bint KeyShift
        bint KeyAlt
        bint KeySuper
        bint KeysDown[512]
        #float NavInputs[ImGuiNavInput_COUNT]
        float* NavInputs
        bint WantCaptureMouse
        bint WantCaptureKeyboard
        bint WantTextInput
        bint WantSetMousePos
        bint WantSaveIniSettings
        bint NavActive
        bint NavVisible
        float Framerate
        int MetricsRenderVertices
        int MetricsRenderIndices
        int MetricsRenderWindows
        int MetricsActiveWindows
        int MetricsActiveAllocations
        ImVec2 MouseDelta
        ImGuiKeyModFlags KeyMods
        ImGuiKeyModFlags KeyModsPrev
        ImVec2 MousePosPrev
        ImVec2 MouseClickedPos[5]
        double MouseClickedTime[5]
        bint MouseClicked[5]
        bint MouseDoubleClicked[5]
        bint MouseReleased[5]
        bint MouseDownOwned[5]
        bint MouseDownWasDoubleClick[5]
        float MouseDownDuration[5]
        float MouseDownDurationPrev[5]
        ImVec2 MouseDragMaxDistanceAbs[5]
        float MouseDragMaxDistanceSqr[5]
        float KeysDownDuration[512]
        float KeysDownDurationPrev[512]
        #float NavInputsDownDuration[ImGuiNavInput_COUNT]
        float* NavInputsDownDuration
        #float NavInputsDownDurationPrev[ImGuiNavInput_COUNT]
        float* NavInputsDownDurationPrev
        float PenPressure
        ImWchar16 InputQueueSurrogate
        ImVector_ImWchar InputQueueCharacters

    ctypedef struct ImGuiInputTextCallbackData:
        ImGuiInputTextFlags EventFlag
        ImGuiInputTextFlags Flags
        void* UserData
        ImWchar EventChar
        ImGuiKey EventKey
        char* Buf
        int BufTextLen
        int BufSize
        bint BufDirty
        int CursorPos
        int SelectionStart
        int SelectionEnd

    ctypedef struct ImGuiSizeCallbackData:
        void* UserData
        ImVec2 Pos
        ImVec2 CurrentSize
        ImVec2 DesiredSize

    ctypedef struct ImGuiPayload:
        void* Data
        int DataSize
        ImGuiID SourceId
        ImGuiID SourceParentId
        int DataFrameCount
        char DataType[32 + 1]
        bint Preview
        bint Delivery

    ctypedef struct ImGuiTableColumnSortSpecs:
        ImGuiID ColumnUserID
        ImS16 ColumnIndex
        ImS16 SortOrder
        #ImGuiSortDirection SortDirection : 8
        ImGuiSortDirection SortDirection

    ctypedef struct ImGuiTableSortSpecs:
        const ImGuiTableColumnSortSpecs* Specs
        int SpecsCount
        bint SpecsDirty

    ctypedef struct ImGuiOnceUponAFrame:
        int RefFrame

    ctypedef struct ImGuiTextRange:
            const char* b
            const char* e

    ctypedef struct ImGuiTextFilter:
        char InputBuf[256]
        ImVector_ImGuiTextRange Filters
        int CountGrep

    ctypedef struct ImGuiTextBuffer:
        ImVector_char Buf

    ctypedef struct ImGuiStoragePair:
        ImGuiID key
        #union { int val_i float val_f void* val_p }
        int val_i
        float val_f
        void* val_p

    ctypedef struct ImGuiStorage:
        ImVector_ImGuiStoragePair Data

    ctypedef struct ImVector_ImGuiTabBar:
        int Size
        int Capacity
        ImGuiTabBar* Data

    ctypedef struct ImPool_ImGuiTabBar:
        ImVector_ImGuiTabBar Buf
        ImGuiStorage Map
        ImPoolIdx FreeIdx

    ctypedef struct ImVector_ImGuiTable:
        int Size
        int Capacity
        ImGuiTable* Data

    ctypedef struct ImPool_ImGuiTable:
        ImVector_ImGuiTable Buf
        ImGuiStorage Map
        ImPoolIdx FreeIdx

    ctypedef struct ImGuiListClipper:
        int DisplayStart
        int DisplayEnd
        int ItemsCount
        int StepNo
        int ItemsFrozen
        float ItemsHeight
        float StartPosY

    ctypedef struct ImColor:
        ImVec4 Value

    ctypedef struct ImDrawCmd:
        ImVec4 ClipRect
        ImTextureID TextureId
        unsigned int VtxOffset
        unsigned int IdxOffset
        unsigned int ElemCount
        ImDrawCallback UserCallback
        void* UserCallbackData

    ctypedef struct ImDrawVert:
        ImVec2 pos
        ImVec2 uv
        ImU32 col

    ctypedef struct ImDrawCmdHeader:
        ImVec4 ClipRect
        ImTextureID TextureId
        unsigned int VtxOffset

    ctypedef struct ImDrawChannel:
        ImVector_ImDrawCmd _CmdBuffer
        ImVector_ImDrawIdx _IdxBuffer

    ctypedef struct ImDrawListSplitter:
        int _Current
        int _Count
        ImVector_ImDrawChannel _Channels

    ctypedef enum ImDrawFlags_:
        ImDrawFlags_None = 0,
        ImDrawFlags_Closed = 1 << 0,
        ImDrawFlags_RoundCornersTopLeft = 1 << 4,
        ImDrawFlags_RoundCornersTopRight = 1 << 5,
        ImDrawFlags_RoundCornersBottomLeft = 1 << 6,
        ImDrawFlags_RoundCornersBottomRight = 1 << 7,
        ImDrawFlags_RoundCornersNone = 1 << 8,
        ImDrawFlags_RoundCornersTop = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight,
        ImDrawFlags_RoundCornersBottom = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
        ImDrawFlags_RoundCornersLeft = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersTopLeft,
        ImDrawFlags_RoundCornersRight = ImDrawFlags_RoundCornersBottomRight | ImDrawFlags_RoundCornersTopRight,
        ImDrawFlags_RoundCornersAll = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight | ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
        ImDrawFlags_RoundCornersDefault_ = ImDrawFlags_RoundCornersAll,
        ImDrawFlags_RoundCornersMask_ = ImDrawFlags_RoundCornersAll | ImDrawFlags_RoundCornersNone

    ctypedef enum ImDrawListFlags_:
        ImDrawListFlags_None = 0,
        ImDrawListFlags_AntiAliasedLines = 1 << 0,
        ImDrawListFlags_AntiAliasedLinesUseTex = 1 << 1,
        ImDrawListFlags_AntiAliasedFill = 1 << 2,
        ImDrawListFlags_AllowVtxOffset = 1 << 3

    ctypedef struct ImDrawList:
        ImVector_ImDrawCmd CmdBuffer
        ImVector_ImDrawIdx IdxBuffer
        ImVector_ImDrawVert VtxBuffer
        ImDrawListFlags Flags
        unsigned int _VtxCurrentIdx
        const ImDrawListSharedData* _Data
        const char* _OwnerName
        ImDrawVert* _VtxWritePtr
        ImDrawIdx* _IdxWritePtr
        ImVector_ImVec4 _ClipRectStack
        ImVector_ImTextureID _TextureIdStack
        ImVector_ImVec2 _Path
        ImDrawCmdHeader _CmdHeader
        ImDrawListSplitter _Splitter
        float _FringeScale
    
    ctypedef struct ImDrawData:
        bint Valid
        int CmdListsCount
        int TotalIdxCount
        int TotalVtxCount
        ImDrawList** CmdLists
        ImVec2 DisplayPos
        ImVec2 DisplaySize
        ImVec2 FramebufferScale

    ctypedef struct ImFontConfig:
        void* FontData
        int FontDataSize
        bint FontDataOwnedByAtlas
        int FontNo
        float SizePixels
        int OversampleH
        int OversampleV
        bint PixelSnapH
        ImVec2 GlyphExtraSpacing
        ImVec2 GlyphOffset
        const ImWchar* GlyphRanges
        float GlyphMinAdvanceX
        float GlyphMaxAdvanceX
        bint MergeMode
        unsigned int FontBuilderFlags
        float RasterizerMultiply
        ImWchar EllipsisChar
        char Name[40]
        ImFont* DstFont

    ctypedef struct ImFontGlyph:
        #unsigned int Colored : 1
        unsigned int Colored
        #unsigned int Visible : 1
        unsigned int Visible
        #unsigned int Codepoint : 30
        unsigned int Codepoint
        float AdvanceX
        float X0, Y0, X1, Y1
        float U0, V0, U1, V1

    ctypedef struct ImFontGlyphRangesBuilder:
        ImVector_ImU32 UsedChars

    ctypedef struct ImFontAtlasCustomRect:
        unsigned short Width, Height
        unsigned short X, Y
        unsigned int GlyphID
        float GlyphAdvanceX
        ImVec2 GlyphOffset
        ImFont* Font

    ctypedef enum ImFontAtlasFlags_:
        ImFontAtlasFlags_None = 0,
        ImFontAtlasFlags_NoPowerOfTwoHeight = 1 << 0,
        ImFontAtlasFlags_NoMouseCursors = 1 << 1,
        ImFontAtlasFlags_NoBakedLines = 1 << 2

    ctypedef struct ImFontAtlas:
        ImFontAtlasFlags Flags
        ImTextureID TexID
        int TexDesiredWidth
        int TexGlyphPadding
        bint Locked
        bint TexReady
        bint TexPixelsUseColors
        unsigned char* TexPixelsAlpha8
        unsigned int* TexPixelsRGBA32
        int TexWidth
        int TexHeight
        ImVec2 TexUvScale
        ImVec2 TexUvWhitePixel
        ImVector_ImFontPtr Fonts
        ImVector_ImFontAtlasCustomRect CustomRects
        ImVector_ImFontConfig ConfigData
        ImVec4 TexUvLines[(63) + 1]
        const ImFontBuilderIO* FontBuilderIO
        unsigned int FontBuilderFlags
        int PackIdMouseCursors
        int PackIdLines

    ctypedef struct ImFont:
        ImVector_float IndexAdvanceX
        float FallbackAdvanceX
        float FontSize
        ImVector_ImWchar IndexLookup
        ImVector_ImFontGlyph Glyphs
        const ImFontGlyph* FallbackGlyph
        ImFontAtlas* ContainerAtlas
        const ImFontConfig* ConfigData
        short ConfigDataCount
        ImWchar FallbackChar
        ImWchar EllipsisChar
        ImWchar DotChar
        bint DirtyLookupTables
        float Scale
        float Ascent, Descent
        int MetricsTotalSurface
        ImU8 Used4kPagesMap[(0xFFFF +1)/4096/8]

    ctypedef enum ImGuiViewportFlags_:
        ImGuiViewportFlags_None = 0,
        ImGuiViewportFlags_IsPlatformWindow = 1 << 0,
        ImGuiViewportFlags_IsPlatformMonitor = 1 << 1,
        ImGuiViewportFlags_OwnedByApp = 1 << 2

    ctypedef struct ImGuiViewport:
        ImGuiViewportFlags Flags
        ImVec2 Pos
        ImVec2 Size
        ImVec2 WorkPos
        ImVec2 WorkSize

    ctypedef struct StbUndoRecord:
        int where
        int insert_length
        int delete_length
        int char_storage

    ctypedef struct StbUndoState:
        StbUndoRecord undo_rec [99]
        ImWchar undo_char[999]
        short undo_point, redo_point
        int undo_char_point, redo_char_point

    ctypedef struct STB_TexteditState:
        int cursor
        int select_start
        int select_end
        unsigned char insert_mode
        int row_count_per_page
        unsigned char cursor_at_end_of_line
        unsigned char initialized
        unsigned char has_preferred_x
        unsigned char single_line
        unsigned char padding1, padding2, padding3
        float preferred_x
        StbUndoState undostate

    ctypedef struct StbTexteditRow:
        float x0,x1
        float baseline_y_delta
        float ymin,ymax
        int num_chars

    ctypedef struct ImVec1:
        float x

    ctypedef struct ImVec2ih:
        short x, y

    ctypedef struct ImRect:
        ImVec2 Min
        ImVec2 Max

    ctypedef struct ImBitVector:
        ImVector_ImU32 Storage

    ctypedef struct ImDrawListSharedData:
        ImVec2 TexUvWhitePixel
        ImFont* Font
        float FontSize
        float CurveTessellationTol
        float CircleSegmentMaxError
        ImVec4 ClipRectFullscreen
        ImDrawListFlags InitialFlags
        ImVec2 ArcFastVtx[48]
        float ArcFastRadiusCutoff
        ImU8 CircleSegmentCounts[64]
        const ImVec4* TexUvLines

    ctypedef struct ImDrawDataBuilder:
        ImVector_ImDrawListPtr Layers[2]

    ctypedef enum ImGuiItemFlags_:
        ImGuiItemFlags_None = 0,
        ImGuiItemFlags_NoTabStop = 1 << 0,
        ImGuiItemFlags_ButtonRepeat = 1 << 1,
        ImGuiItemFlags_Disabled = 1 << 2,
        ImGuiItemFlags_NoNav = 1 << 3,
        ImGuiItemFlags_NoNavDefaultFocus = 1 << 4,
        ImGuiItemFlags_SelectableDontClosePopup = 1 << 5,
        ImGuiItemFlags_MixedValue = 1 << 6,
        ImGuiItemFlags_ReadOnly = 1 << 7

    ctypedef enum ImGuiItemAddFlags_:
        ImGuiItemAddFlags_None = 0,
        ImGuiItemAddFlags_Focusable = 1 << 0

    ctypedef enum ImGuiItemStatusFlags_:
        ImGuiItemStatusFlags_None = 0,
        ImGuiItemStatusFlags_HoveredRect = 1 << 0,
        ImGuiItemStatusFlags_HasDisplayRect = 1 << 1,
        ImGuiItemStatusFlags_Edited = 1 << 2,
        ImGuiItemStatusFlags_ToggledSelection = 1 << 3,
        ImGuiItemStatusFlags_ToggledOpen = 1 << 4,
        ImGuiItemStatusFlags_HasDeactivated = 1 << 5,
        ImGuiItemStatusFlags_Deactivated = 1 << 6,
        ImGuiItemStatusFlags_HoveredWindow = 1 << 7,
        ImGuiItemStatusFlags_FocusedByCode = 1 << 8,
        ImGuiItemStatusFlags_FocusedByTabbing = 1 << 9,
        ImGuiItemStatusFlags_Focused = ImGuiItemStatusFlags_FocusedByCode | ImGuiItemStatusFlags_FocusedByTabbing

    ctypedef enum ImGuiInputTextFlagsPrivate_:
        ImGuiInputTextFlags_Multiline = 1 << 26,
        ImGuiInputTextFlags_NoMarkEdited = 1 << 27,
        ImGuiInputTextFlags_MergedItem = 1 << 28

    ctypedef enum ImGuiButtonFlagsPrivate_:
        ImGuiButtonFlags_PressedOnClick = 1 << 4,
        ImGuiButtonFlags_PressedOnClickRelease = 1 << 5,
        ImGuiButtonFlags_PressedOnClickReleaseAnywhere = 1 << 6,
        ImGuiButtonFlags_PressedOnRelease = 1 << 7,
        ImGuiButtonFlags_PressedOnDoubleClick = 1 << 8,
        ImGuiButtonFlags_PressedOnDragDropHold = 1 << 9,
        ImGuiButtonFlags_Repeat = 1 << 10,
        ImGuiButtonFlags_FlattenChildren = 1 << 11,
        ImGuiButtonFlags_AllowItemOverlap = 1 << 12,
        ImGuiButtonFlags_DontClosePopups = 1 << 13,
        ImGuiButtonFlags_AlignTextBaseLine = 1 << 15,
        ImGuiButtonFlags_NoKeyModifiers = 1 << 16,
        ImGuiButtonFlags_NoHoldingActiveId = 1 << 17,
        ImGuiButtonFlags_NoNavFocus = 1 << 18,
        ImGuiButtonFlags_NoHoveredOnFocus = 1 << 19,
        ImGuiButtonFlags_PressedOnMask_ = ImGuiButtonFlags_PressedOnClick | ImGuiButtonFlags_PressedOnClickRelease | ImGuiButtonFlags_PressedOnClickReleaseAnywhere | ImGuiButtonFlags_PressedOnRelease | ImGuiButtonFlags_PressedOnDoubleClick | ImGuiButtonFlags_PressedOnDragDropHold,
        ImGuiButtonFlags_PressedOnDefault_ = ImGuiButtonFlags_PressedOnClickRelease

    ctypedef enum ImGuiComboFlagsPrivate_:
        ImGuiComboFlags_CustomPreview = 1 << 20

    ctypedef enum ImGuiSliderFlagsPrivate_:
        ImGuiSliderFlags_Vertical = 1 << 20,
        ImGuiSliderFlags_ReadOnly = 1 << 21

    ctypedef enum ImGuiSelectableFlagsPrivate_:
        ImGuiSelectableFlags_NoHoldingActiveID = 1 << 20,
        ImGuiSelectableFlags_SelectOnNav = 1 << 21,
        ImGuiSelectableFlags_SelectOnClick = 1 << 22,
        ImGuiSelectableFlags_SelectOnRelease = 1 << 23,
        ImGuiSelectableFlags_SpanAvailWidth = 1 << 24,
        ImGuiSelectableFlags_DrawHoveredWhenHeld = 1 << 25,
        ImGuiSelectableFlags_SetNavIdOnHover = 1 << 26,
        ImGuiSelectableFlags_NoPadWithHalfSpacing = 1 << 27

    ctypedef enum ImGuiTreeNodeFlagsPrivate_:
        ImGuiTreeNodeFlags_ClipLabelForTrailingButton = 1 << 20

    ctypedef enum ImGuiSeparatorFlags_:
        ImGuiSeparatorFlags_None = 0,
        ImGuiSeparatorFlags_Horizontal = 1 << 0,
        ImGuiSeparatorFlags_Vertical = 1 << 1,
        ImGuiSeparatorFlags_SpanAllColumns = 1 << 2

    ctypedef enum ImGuiTextFlags_:
        ImGuiTextFlags_None = 0,
        ImGuiTextFlags_NoWidthForLargeClippedText = 1 << 0

    ctypedef enum ImGuiTooltipFlags_:
        ImGuiTooltipFlags_None = 0,
        ImGuiTooltipFlags_OverridePreviousTooltip = 1 << 0

    ctypedef enum ImGuiLayoutType_:
        ImGuiLayoutType_Horizontal = 0,
        ImGuiLayoutType_Vertical = 1

    ctypedef enum ImGuiLogType:
        ImGuiLogType_None = 0,
        ImGuiLogType_TTY,
        ImGuiLogType_File,
        ImGuiLogType_Buffer,
        ImGuiLogType_Clipboard

    ctypedef enum ImGuiAxis:
        ImGuiAxis_None = -1,
        ImGuiAxis_X = 0,
        ImGuiAxis_Y = 1

    ctypedef enum ImGuiPlotType:
        ImGuiPlotType_Lines,
        ImGuiPlotType_Histogram

    ctypedef enum ImGuiInputSource:
        ImGuiInputSource_None = 0,
        ImGuiInputSource_Mouse,
        ImGuiInputSource_Keyboard,
        ImGuiInputSource_Gamepad,
        ImGuiInputSource_Nav,
        ImGuiInputSource_Clipboard,
        ImGuiInputSource_COUNT

    ctypedef enum ImGuiInputReadMode:
        ImGuiInputReadMode_Down,
        ImGuiInputReadMode_Pressed,
        ImGuiInputReadMode_Released,
        ImGuiInputReadMode_Repeat,
        ImGuiInputReadMode_RepeatSlow,
        ImGuiInputReadMode_RepeatFast

    ctypedef enum ImGuiNavHighlightFlags_:
        ImGuiNavHighlightFlags_None = 0,
        ImGuiNavHighlightFlags_Ctypedefault = 1 << 0,
        ImGuiNavHighlightFlags_TypeThin = 1 << 1,
        ImGuiNavHighlightFlags_AlwaysDraw = 1 << 2,
        ImGuiNavHighlightFlags_NoRounding = 1 << 3

    ctypedef enum ImGuiNavDirSourceFlags_:
        ImGuiNavDirSourceFlags_None = 0,
        ImGuiNavDirSourceFlags_Keyboard = 1 << 0,
        ImGuiNavDirSourceFlags_PadDPad = 1 << 1,
        ImGuiNavDirSourceFlags_PadLStick = 1 << 2

    ctypedef enum ImGuiNavMoveFlags_:
        ImGuiNavMoveFlags_None = 0,
        ImGuiNavMoveFlags_LoopX = 1 << 0,
        ImGuiNavMoveFlags_LoopY = 1 << 1,
        ImGuiNavMoveFlags_WrapX = 1 << 2,
        ImGuiNavMoveFlags_WrapY = 1 << 3,
        ImGuiNavMoveFlags_AllowCurrentNavId = 1 << 4,
        ImGuiNavMoveFlags_AlsoScoreVisibleSet = 1 << 5,
        ImGuiNavMoveFlags_ScrollToEdge = 1 << 6

    ctypedef enum ImGuiNavForward:
        ImGuiNavForward_None,
        ImGuiNavForward_ForwardQueued,
        ImGuiNavForward_ForwardActive

    ctypedef enum ImGuiNavLayer:
        ImGuiNavLayer_Main = 0,
        ImGuiNavLayer_Menu = 1,
        ImGuiNavLayer_COUNT

    ctypedef enum ImGuiPopupPositionPolicy:
        ImGuiPopupPositionPolicy_Default,
        ImGuiPopupPositionPolicy_ComboBox,
        ImGuiPopupPositionPolicy_Tooltip

    ctypedef struct ImGuiDataTypeTempStorage:
        ImU8 Data[8]

    ctypedef struct ImGuiDataTypeInfo:
        size_t Size
        const char* Name
        const char* PrintFmt
        const char* ScanFmt

    ctypedef enum ImGuiDataTypePrivate_:
        ImGuiDataType_String = ImGuiDataType_COUNT + 1,
        ImGuiDataType_Pointer,
        ImGuiDataType_ID

    ctypedef struct ImGuiColorMod:
        ImGuiCol Col
        ImVec4 BackupValue

    ctypedef struct ImGuiStyleMod:
        ImGuiStyleVar VarIdx
        #union { int BackupInt[2] float BackupFloat[2] }
        int BackupInt[2] 
        float BackupFloat[2] 

    ctypedef struct ImGuiComboPreviewData:
        ImRect PreviewRect
        ImVec2 BackupCursorPos
        ImVec2 BackupCursorMaxPos
        ImVec2 BackupCursorPosPrevLine
        float BackupPrevLineTextBaseOffset
        ImGuiLayoutType BackupLayout

    ctypedef struct ImGuiGroupData:
        ImGuiID WindowID
        ImVec2 BackupCursorPos
        ImVec2 BackupCursorMaxPos
        ImVec1 BackupIndent
        ImVec1 BackupGroupOffset
        ImVec2 BackupCurrLineSize
        float BackupCurrLineTextBaseOffset
        ImGuiID BackupActiveIdIsAlive
        bint BackupActiveIdPreviousFrameIsAlive
        bint BackupHoveredIdIsAlive
        bint EmitItem

    ctypedef struct ImGuiMenuColumns:
        ImU32 TotalWidth
        ImU32 NextTotalWidth
        ImU16 Spacing
        ImU16 OffsetIcon
        ImU16 OffsetLabel
        ImU16 OffsetShortcut
        ImU16 OffsetMark
        ImU16 Widths[4]

    ctypedef struct ImGuiInputTextState:
        ImGuiID ID
        int CurLenW, CurLenA
        ImVector_ImWchar TextW
        ImVector_char TextA
        ImVector_char InitialTextA
        bint TextAIsValid
        int BufCapacityA
        float ScrollX
        STB_TexteditState Stb
        float CursorAnim
        bint CursorFollow
        bint SelectedAllMouseLock
        bint Edited
        ImGuiInputTextFlags Flags
        ImGuiInputTextCallback UserCallback
        void* UserCallbackData

    ctypedef struct ImGuiPopupData:
        ImGuiID PopupId
        ImGuiWindow* Window
        ImGuiWindow* SourceWindow
        int OpenFrameCount
        ImGuiID OpenParentId
        ImVec2 OpenPopupPos
        ImVec2 OpenMousePos

    ctypedef struct ImGuiNavItemData:
        ImGuiWindow* Window
        ImGuiID ID
        ImGuiID FocusScopeId
        ImRect RectRel
        float DistBox
        float DistCenter
        float DistAxial

    ctypedef enum ImGuiNextWindowDataFlags_:
        ImGuiNextWindowDataFlags_None = 0,
        ImGuiNextWindowDataFlags_HasPos = 1 << 0,
        ImGuiNextWindowDataFlags_HasSize = 1 << 1,
        ImGuiNextWindowDataFlags_HasContentSize = 1 << 2,
        ImGuiNextWindowDataFlags_HasCollapsed = 1 << 3,
        ImGuiNextWindowDataFlags_HasSizeConstraint = 1 << 4,
        ImGuiNextWindowDataFlags_HasFocus = 1 << 5,
        ImGuiNextWindowDataFlags_HasBgAlpha = 1 << 6,
        ImGuiNextWindowDataFlags_HasScroll = 1 << 7

    ctypedef struct ImGuiNextWindowData:
        ImGuiNextWindowDataFlags Flags
        ImGuiCond PosCond
        ImGuiCond SizeCond
        ImGuiCond CollapsedCond
        ImVec2 PosVal
        ImVec2 PosPivotVal
        ImVec2 SizeVal
        ImVec2 ContentSizeVal
        ImVec2 ScrollVal
        bint CollapsedVal
        ImRect SizeConstraintRect
        ImGuiSizeCallback SizeCallback
        void* SizeCallbackUserData
        float BgAlphaVal
        ImVec2 MenuBarOffsetMinVal

    ctypedef enum ImGuiNextItemDataFlags_:
        ImGuiNextItemDataFlags_None = 0,
        ImGuiNextItemDataFlags_HasWidth = 1 << 0,
        ImGuiNextItemDataFlags_HasOpen = 1 << 1

    ctypedef struct ImGuiNextItemData:
        ImGuiNextItemDataFlags Flags
        float Width
        ImGuiID FocusScopeId
        ImGuiCond OpenCond
        bint OpenVal

    ctypedef struct ImGuiLastItemData:
        ImGuiID ID
        ImGuiItemFlags InFlags
        ImGuiItemStatusFlags StatusFlags
        ImRect Rect
        ImRect DisplayRect

    ctypedef struct ImGuiWindowStackData:
        ImGuiWindow* Window
        ImGuiLastItemData ParentLastItemDataBackup

    ctypedef struct ImGuiShrinkWidthItem:
        int Index
        float Width

    ctypedef struct ImGuiPtrOrIndex:
        void* Ptr
        int Index

    ctypedef enum ImGuiOldColumnFlags_:
        ImGuiOldColumnFlags_None = 0,
        ImGuiOldColumnFlags_NoBorder = 1 << 0,
        ImGuiOldColumnFlags_NoResize = 1 << 1,
        ImGuiOldColumnFlags_NoPreserveWidths = 1 << 2,
        ImGuiOldColumnFlags_NoForceWithinWindow = 1 << 3,
        ImGuiOldColumnFlags_GrowParentContentsSize = 1 << 4

    ctypedef struct ImGuiOldColumnData:
        float OffsetNorm
        float OffsetNormBeforeResize
        ImGuiOldColumnFlags Flags
        ImRect ClipRect

    ctypedef struct ImGuiOldColumns:
        ImGuiID ID
        ImGuiOldColumnFlags Flags
        bint IsFirstFrame
        bint IsBeingResized
        int Current
        int Count
        float OffMinX, OffMaxX
        float LineMinY, LineMaxY
        float HostCursorPosY
        float HostCursorMaxPosX
        ImRect HostInitialClipRect
        ImRect HostBackupClipRect
        ImRect HostBackupParentWorkRect
        ImVector_ImGuiOldColumnData Columns
        ImDrawListSplitter Splitter

    ctypedef struct ImGuiViewportP:
        ImGuiViewport _ImGuiViewport
        int DrawListsLastFrame[2]
        ImDrawList* DrawLists[2]
        ImDrawData DrawDataP
        ImDrawDataBuilder DrawDataBuilder
        ImVec2 WorkOffsetMin
        ImVec2 WorkOffsetMax
        ImVec2 BuildWorkOffsetMin
        ImVec2 BuildWorkOffsetMax

    ctypedef struct ImGuiWindowSettings:
        ImGuiID ID
        ImVec2ih Pos
        ImVec2ih Size
        bint Collapsed
        bint WantApply

    ctypedef struct ImGuiSettingsHandler:
        const char* TypeName
        ImGuiID TypeHash
        void (*ClearAllFn)(ImGuiContext* ctx, ImGuiSettingsHandler* handler)
        void (*ReadInitFn)(ImGuiContext* ctx, ImGuiSettingsHandler* handler)
        void* (*ReadOpenFn)(ImGuiContext* ctx, ImGuiSettingsHandler* handler, const char* name)
        void (*ReadLineFn)(ImGuiContext* ctx, ImGuiSettingsHandler* handler, void* entry, const char* line)
        void (*ApplyAllFn)(ImGuiContext* ctx, ImGuiSettingsHandler* handler)
        void (*WriteAllFn)(ImGuiContext* ctx, ImGuiSettingsHandler* handler, ImGuiTextBuffer* out_buf)
        void* UserData

    ctypedef struct ImGuiMetricsConfig:
        bint ShowWindowsRects
        bint ShowWindowsBeginOrder
        bint ShowTablesRects
        bint ShowDrawCmdMesh
        bint ShowDrawCmdBoundingBoxes
        int ShowWindowsRectsType
        int ShowTablesRectsType

    ctypedef struct ImGuiStackSizes:
        short SizeOfIDStack
        short SizeOfColorStack
        short SizeOfStyleVarStack
        short SizeOfFontStack
        short SizeOfFocusScopeStack
        short SizeOfGroupStack
        short SizeOfBeginPopupStack

    ctypedef enum ImGuiContextHookType:
        ImGuiContextHookType_NewFramePre
        ImGuiContextHookType_NewFramePost
        ImGuiContextHookType_EndFramePre
        ImGuiContextHookType_EndFramePost
        ImGuiContextHookType_RenderPre
        ImGuiContextHookType_RenderPost
        ImGuiContextHookType_Shutdown
        ImGuiContextHookType_PendingRemoval

    ctypedef struct ImGuiContextHook:
        ImGuiID HookId
        ImGuiContextHookType Type
        ImGuiID Owner
        ImGuiContextHookCallback Callback
        void* UserData

    ctypedef struct ImGuiContext:
        bint Initialized
        bint FontAtlasOwnedByContext
        ImGuiIO IO
        ImGuiStyle Style
        ImFont* Font
        float FontSize
        float FontBaseSize
        ImDrawListSharedData DrawListSharedData
        double Time
        int FrameCount
        int FrameCountEnded
        int FrameCountRendered
        bint WithinFrameScope
        bint WithinFrameScopeWithImplicitWindow
        bint WithinEndChild
        bint GcCompactAll
        bint TestEngineHookItems
        ImGuiID TestEngineHookIdInfo
        void* TestEngine
        ImVector_ImGuiWindowPtr Windows
        ImVector_ImGuiWindowPtr WindowsFocusOrder
        ImVector_ImGuiWindowPtr WindowsTempSortBuffer
        ImVector_ImGuiWindowStackData CurrentWindowStack
        ImGuiStorage WindowsById
        int WindowsActiveCount
        ImVec2 WindowsHoverPadding
        ImGuiWindow* CurrentWindow
        ImGuiWindow* HoveredWindow
        ImGuiWindow* HoveredWindowUnderMovingWindow
        ImGuiWindow* MovingWindow
        ImGuiWindow* WheelingWindow
        ImVec2 WheelingWindowRefMousePos
        float WheelingWindowTimer
        ImGuiID HoveredId
        ImGuiID HoveredIdPreviousFrame
        bint HoveredIdAllowOverlap
        bint HoveredIdUsingMouseWheel
        bint HoveredIdPreviousFrameUsingMouseWheel
        bint HoveredIdDisabled
        float HoveredIdTimer
        float HoveredIdNotActiveTimer
        ImGuiID ActiveId
        ImGuiID ActiveIdIsAlive
        float ActiveIdTimer
        bint ActiveIdIsJustActivated
        bint ActiveIdAllowOverlap
        bint ActiveIdNoClearOnFocusLoss
        bint ActiveIdHasBeenPressedBefore
        bint ActiveIdHasBeenEditedBefore
        bint ActiveIdHasBeenEditedThisFrame
        bint ActiveIdUsingMouseWheel
        ImU32 ActiveIdUsingNavDirMask
        ImU32 ActiveIdUsingNavInputMask
        ImU64 ActiveIdUsingKeyInputMask
        ImVec2 ActiveIdClickOffset
        ImGuiWindow* ActiveIdWindow
        ImGuiInputSource ActiveIdSource
        int ActiveIdMouseButton
        ImGuiID ActiveIdPreviousFrame
        bint ActiveIdPreviousFrameIsAlive
        bint ActiveIdPreviousFrameHasBeenEditedBefore
        ImGuiWindow* ActiveIdPreviousFrameWindow
        ImGuiID LastActiveId
        float LastActiveIdTimer
        ImGuiItemFlags CurrentItemFlags
        ImGuiNextItemData NextItemData
        ImGuiLastItemData LastItemData
        ImGuiNextWindowData NextWindowData
        ImVector_ImGuiColorMod ColorStack
        ImVector_ImGuiStyleMod StyleVarStack
        ImVector_ImFontPtr FontStack
        ImVector_ImGuiID FocusScopeStack
        ImVector_ImGuiItemFlags ItemFlagsStack
        ImVector_ImGuiGroupData GroupStack
        ImVector_ImGuiPopupData OpenPopupStack
        ImVector_ImGuiPopupData BeginPopupStack
        ImVector_ImGuiViewportPPtr Viewports
        ImGuiWindow* NavWindow
        ImGuiID NavId
        ImGuiID NavFocusScopeId
        ImGuiID NavActivateId
        ImGuiID NavActivateDownId
        ImGuiID NavActivatePressedId
        ImGuiID NavInputId
        ImGuiID NavJustTabbedId
        ImGuiID NavJustMovedToId
        ImGuiID NavJustMovedToFocusScopeId
        ImGuiKeyModFlags NavJustMovedToKeyMods
        ImGuiID NavNextActivateId
        ImGuiInputSource NavInputSource
        ImRect NavScoringRect
        int NavScoringCount
        ImGuiNavLayer NavLayer
        int NavIdTabCounter
        bint NavIdIsAlive
        bint NavMousePosDirty
        bint NavDisableHighlight
        bint NavDisableMouseHover
        bint NavAnyRequest
        bint NavInitRequest
        bint NavInitRequestFromMove
        ImGuiID NavInitResultId
        ImRect NavInitResultRectRel
        bint NavMoveRequest
        ImGuiNavMoveFlags NavMoveRequestFlags
        ImGuiNavForward NavMoveRequestForward
        ImGuiKeyModFlags NavMoveRequestKeyMods
        ImGuiDir NavMoveDir, NavMoveDirLast
        ImGuiDir NavMoveClipDir
        ImGuiNavItemData NavMoveResultLocal
        ImGuiNavItemData NavMoveResultLocalVisibleSet
        ImGuiNavItemData NavMoveResultOther
        ImGuiWindow* NavWrapRequestWindow
        ImGuiNavMoveFlags NavWrapRequestFlags
        ImGuiWindow* NavWindowingTarget
        ImGuiWindow* NavWindowingTargetAnim
        ImGuiWindow* NavWindowingListWindow
        float NavWindowingTimer
        float NavWindowingHighlightAlpha
        bint NavWindowingToggleLayer
        ImGuiWindow* TabFocusRequestCurrWindow
        ImGuiWindow* TabFocusRequestNextWindow
        int TabFocusRequestCurrCounterRegular
        int TabFocusRequestCurrCounterTabStop
        int TabFocusRequestNextCounterRegular
        int TabFocusRequestNextCounterTabStop
        bint TabFocusPressed
        float DimBgRatio
        ImGuiMouseCursor MouseCursor
        bint DragDropActive
        bint DragDropWithinSource
        bint DragDropWithinTarget
        ImGuiDragDropFlags DragDropSourceFlags
        int DragDropSourceFrameCount
        int DragDropMouseButton
        ImGuiPayload DragDropPayload
        ImRect DragDropTargetRect
        ImGuiID DragDropTargetId
        ImGuiDragDropFlags DragDropAcceptFlags
        float DragDropAcceptIdCurrRectSurface
        ImGuiID DragDropAcceptIdCurr
        ImGuiID DragDropAcceptIdPrev
        int DragDropAcceptFrameCount
        ImGuiID DragDropHoldJustPressedId
        ImVector_unsigned_char DragDropPayloadBufHeap
        unsigned char DragDropPayloadBufLocal[16]
        ImGuiTable* CurrentTable
        int CurrentTableStackIdx
        ImPool_ImGuiTable Tables
        ImVector_ImGuiTableTempData TablesTempDataStack
        ImVector_float TablesLastTimeActive
        ImVector_ImDrawChannel DrawChannelsTempMergeBuffer
        ImGuiTabBar* CurrentTabBar
        ImPool_ImGuiTabBar TabBars
        ImVector_ImGuiPtrOrIndex CurrentTabBarStack
        ImVector_ImGuiShrinkWidthItem ShrinkWidthBuffer
        ImVec2 LastValidMousePos
        ImGuiInputTextState InputTextState
        ImFont InputTextPasswordFont
        ImGuiID TempInputId
        ImGuiColorEditFlags ColorEditOptions
        float ColorEditLastHue
        float ColorEditLastSat
        float ColorEditLastColor[3]
        ImVec4 ColorPickerRef
        ImGuiComboPreviewData ComboPreviewData
        float SliderCurrentAccum
        bint SliderCurrentAccumDirty
        bint DragCurrentAccumDirty
        float DragCurrentAccum
        float DragSpeedDefaultRatio
        float DisabledAlphaBackup
        float ScrollbarClickDeltaToGrabCenter
        int TooltipOverrideCount
        float TooltipSlowDelay
        ImVector_char ClipboardHandlerData
        ImVector_ImGuiID MenusIdSubmittedThisFrame
        ImVec2 PlatformImePos
        ImVec2 PlatformImeLastPos
        char PlatformLocaleDecimalPoint
        bint SettingsLoaded
        float SettingsDirtyTimer
        ImGuiTextBuffer SettingsIniData
        ImVector_ImGuiSettingsHandler SettingsHandlers
        ImChunkStream_ImGuiWindowSettings SettingsWindows
        ImChunkStream_ImGuiTableSettings SettingsTables
        ImVector_ImGuiContextHook Hooks
        ImGuiID HookIdNext
        bint LogEnabled
        ImGuiLogType LogType
        ImFileHandle LogFile
        ImGuiTextBuffer LogBuffer
        const char* LogNextPrefix
        const char* LogNextSuffix
        float LogLinePosY
        bint LogLineFirstItem
        int LogDepthRef
        int LogDepthToExpand
        int LogDepthToExpandDefault
        bint DebugItemPickerActive
        ImGuiID DebugItemPickerBreakId
        ImGuiMetricsConfig DebugMetricsConfig
        float FramerateSecPerFrame[120]
        int FramerateSecPerFrameIdx
        int FramerateSecPerFrameCount
        float FramerateSecPerFrameAccum
        int WantCaptureMouseNextFrame
        int WantCaptureKeyboardNextFrame
        int WantTextInputNextFrame
        char TempBuffer[1024 * 3 + 1]

    ctypedef struct ImGuiWindowTempData:
        ImVec2 CursorPos
        ImVec2 CursorPosPrevLine
        ImVec2 CursorStartPos
        ImVec2 CursorMaxPos
        ImVec2 IdealMaxPos
        ImVec2 CurrLineSize
        ImVec2 PrevLineSize
        float CurrLineTextBaseOffset
        float PrevLineTextBaseOffset
        ImVec1 Indent
        ImVec1 ColumnsOffset
        ImVec1 GroupOffset
        ImGuiNavLayer NavLayerCurrent
        short NavLayersActiveMask
        short NavLayersActiveMaskNext
        ImGuiID NavFocusScopeIdCurrent
        bint NavHideHighlightOneFrame
        bint NavHasScroll
        bint MenuBarAppending
        ImVec2 MenuBarOffset
        ImGuiMenuColumns MenuColumns
        int TreeDepth
        ImU32 TreeJumpToParentOnPopMask
        ImVector_ImGuiWindowPtr ChildWindows
        ImGuiStorage* StateStorage
        ImGuiOldColumns* CurrentColumns
        int CurrentTableIdx
        ImGuiLayoutType LayoutType
        ImGuiLayoutType ParentLayoutType
        int FocusCounterRegular
        int FocusCounterTabStop
        float ItemWidth
        float TextWrapPos
        ImVector_float ItemWidthStack
        ImVector_float TextWrapPosStack
        ImGuiStackSizes StackSizesOnBegin

    ctypedef struct ImGuiWindow:
        char* Name
        ImGuiID ID
        ImGuiWindowFlags Flags
        ImVec2 Pos
        ImVec2 Size
        ImVec2 SizeFull
        ImVec2 ContentSize
        ImVec2 ContentSizeIdeal
        ImVec2 ContentSizeExplicit
        ImVec2 WindowPadding
        float WindowRounding
        float WindowBorderSize
        int NameBufLen
        ImGuiID MoveId
        ImGuiID ChildId
        ImVec2 Scroll
        ImVec2 ScrollMax
        ImVec2 ScrollTarget
        ImVec2 ScrollTargetCenterRatio
        ImVec2 ScrollTargetEdgeSnapDist
        ImVec2 ScrollbarSizes
        bint ScrollbarX, ScrollbarY
        bint Active
        bint WasActive
        bint WriteAccessed
        bint Collapsed
        bint WantCollapseToggle
        bint SkipItems
        bint Appearing
        bint Hidden
        bint IsFallbackWindow
        bint HasCloseButton
        signed char ResizeBorderHeld
        short BeginCount
        short BeginOrderWithinParent
        short BeginOrderWithinContext
        short FocusOrder
        ImGuiID PopupId
        ImS8 AutoFitFramesX, AutoFitFramesY
        ImS8 AutoFitChildAxises
        bint AutoFitOnlyGrows
        ImGuiDir AutoPosLastDirection
        ImS8 HiddenFramesCanSkipItems
        ImS8 HiddenFramesCannotSkipItems
        ImS8 HiddenFramesForRenderOnly
        ImS8 DisableInputsFrames
        #ImGuiCond SetWindowPosAllowFlags : 8
        ImGuiCond SetWindowPosAllowFlags
        #ImGuiCond SetWindowSizeAllowFlags : 8
        ImGuiCond SetWindowSizeAllowFlags
        #ImGuiCond SetWindowCollapsedAllowFlags : 8
        ImGuiCond SetWindowCollapsedAllowFlags
        ImVec2 SetWindowPosVal
        ImVec2 SetWindowPosPivot
        ImVector_ImGuiID IDStack
        ImGuiWindowTempData DC
        ImRect OuterRectClipped
        ImRect InnerRect
        ImRect InnerClipRect
        ImRect WorkRect
        ImRect ParentWorkRect
        ImRect ClipRect
        ImRect ContentRegionRect
        ImVec2ih HitTestHoleSize
        ImVec2ih HitTestHoleOffset
        int LastFrameActive
        float LastTimeActive
        float ItemWidthDefault
        ImGuiStorage StateStorage
        ImVector_ImGuiOldColumns ColumnsStorage
        float FontWindowScale
        int SettingsOffset
        ImDrawList* DrawList
        ImDrawList DrawListInst
        ImGuiWindow* ParentWindow
        ImGuiWindow* RootWindow
        ImGuiWindow* RootWindowForTitleBarHighlight
        ImGuiWindow* RootWindowForNav
        ImGuiWindow* NavLastChildNavWindow
        #ImGuiID NavLastIds[ImGuiNavLayer_COUNT]
        ImGuiID* NavLastIds
        #ImRect NavRectRel[ImGuiNavLayer_COUNT]
        ImRect* NavRectRel
        int MemoryDrawListIdxCapacity
        int MemoryDrawListVtxCapacity
        bint MemoryCompacted

    ctypedef enum ImGuiTabBarFlagsPrivate_:
        ImGuiTabBarFlags_DockNode = 1 << 20,
        ImGuiTabBarFlags_IsFocused = 1 << 21,
        ImGuiTabBarFlags_SaveSettings = 1 << 22

    ctypedef enum ImGuiTabItemFlagsPrivate_:
        ImGuiTabItemFlags_SectionMask_ = ImGuiTabItemFlags_Leading | ImGuiTabItemFlags_Trailing,
        ImGuiTabItemFlags_NoCloseButton = 1 << 20,
        ImGuiTabItemFlags_Button = 1 << 21

    ctypedef struct ImGuiTabItem:
        ImGuiID ID
        ImGuiTabItemFlags Flags
        int LastFrameVisible
        int LastFrameSelected
        float Offset
        float Width
        float ContentWidth
        ImS32 NameOffset
        ImS16 BeginOrder
        ImS16 IndexDuringLayout
        bint WantClose

    ctypedef struct ImGuiTabBar:
        ImVector_ImGuiTabItem Tabs
        ImGuiTabBarFlags Flags
        ImGuiID ID
        ImGuiID SelectedTabId
        ImGuiID NextSelectedTabId
        ImGuiID VisibleTabId
        int CurrFrameVisible
        int PrevFrameVisible
        ImRect BarRect
        float CurrTabsContentsHeight
        float PrevTabsContentsHeight
        float WidthAllTabs
        float WidthAllTabsIdeal
        float ScrollingAnim
        float ScrollingTarget
        float ScrollingTargetDistToVisibility
        float ScrollingSpeed
        float ScrollingRectMinX
        float ScrollingRectMaxX
        ImGuiID ReorderRequestTabId
        ImS16 ReorderRequestOffset
        ImS8 BeginCount
        bint WantLayout
        bint VisibleTabWasSubmitted
        bint TabsAddedNew
        ImS16 TabsActiveCount
        ImS16 LastTabItemIdx
        float ItemSpacingY
        ImVec2 FramePadding
        ImVec2 BackupCursorPos
        ImGuiTextBuffer TabsNames

    ctypedef struct ImGuiTableColumn:
        ImGuiTableColumnFlags Flags
        float WidthGiven
        float MinX
        float MaxX
        float WidthRequest
        float WidthAuto
        float StretchWeight
        float InitStretchWeightOrWidth
        ImRect ClipRect
        ImGuiID UserID
        float WorkMinX
        float WorkMaxX
        float ItemWidth
        float ContentMaxXFrozen
        float ContentMaxXUnfrozen
        float ContentMaxXHeadersUsed
        float ContentMaxXHeadersIdeal
        ImS16 NameOffset
        ImGuiTableColumnIdx DisplayOrder
        ImGuiTableColumnIdx IndexWithinEnabledSet
        ImGuiTableColumnIdx PrevEnabledColumn
        ImGuiTableColumnIdx NextEnabledColumn
        ImGuiTableColumnIdx SortOrder
        ImGuiTableDrawChannelIdx DrawChannelCurrent
        ImGuiTableDrawChannelIdx DrawChannelFrozen
        ImGuiTableDrawChannelIdx DrawChannelUnfrozen
        bint IsEnabled
        bint IsUserEnabled
        bint IsUserEnabledNextFrame
        bint IsVisibleX
        bint IsVisibleY
        bint IsRequestOutput
        bint IsSkipItems
        bint IsPreserveWidthAuto
        ImS8 NavLayerCurrent
        ImU8 AutoFitQueue
        ImU8 CannotSkipItemsQueue
        #ImU8 SortDirection : 2
        ImU8 SortDirection
        #ImU8 SortDirectionsAvailCount : 2
        ImU8 SortDirectionsAvailCount
        #ImU8 SortDirectionsAvailMask : 4
        ImU8 SortDirectionsAvailMask
        ImU8 SortDirectionsAvailList

    ctypedef struct ImGuiTableCellData:
        ImU32 BgColor
        ImGuiTableColumnIdx Column

    ctypedef struct ImGuiTable:
        ImGuiID ID
        ImGuiTableFlags Flags
        void* RawData
        ImGuiTableTempData* TempData
        ImSpan_ImGuiTableColumn Columns
        ImSpan_ImGuiTableColumnIdx DisplayOrderToIndex
        ImSpan_ImGuiTableCellData RowCellData
        ImU64 EnabledMaskByDisplayOrder
        ImU64 EnabledMaskByIndex
        ImU64 VisibleMaskByIndex
        ImU64 RequestOutputMaskByIndex
        ImGuiTableFlags SettingsLoadedFlags
        int SettingsOffset
        int LastFrameActive
        int ColumnsCount
        int CurrentRow
        int CurrentColumn
        ImS16 InstanceCurrent
        ImS16 InstanceInteracted
        float RowPosY1
        float RowPosY2
        float RowMinHeight
        float RowTextBaseline
        float RowIndentOffsetX
        #ImGuiTableRowFlags RowFlags : 16
        ImGuiTableRowFlags RowFlags
        #ImGuiTableRowFlags LastRowFlags : 16
        ImGuiTableRowFlags LastRowFlags
        int RowBgColorCounter
        ImU32 RowBgColor[2]
        ImU32 BorderColorStrong
        ImU32 BorderColorLight
        float BorderX1
        float BorderX2
        float HostIndentX
        float MinColumnWidth
        float OuterPaddingX
        float CellPaddingX
        float CellPaddingY
        float CellSpacingX1
        float CellSpacingX2
        float LastOuterHeight
        float LastFirstRowHeight
        float InnerWidth
        float ColumnsGivenWidth
        float ColumnsAutoFitWidth
        float ResizedColumnNextWidth
        float ResizeLockMinContentsX2
        float RefScale
        ImRect OuterRect
        ImRect InnerRect
        ImRect WorkRect
        ImRect InnerClipRect
        ImRect BgClipRect
        ImRect Bg0ClipRectForDrawCmd
        ImRect Bg2ClipRectForDrawCmd
        ImRect HostClipRect
        ImRect HostBackupInnerClipRect
        ImGuiWindow* OuterWindow
        ImGuiWindow* InnerWindow
        ImGuiTextBuffer ColumnsNames
        ImDrawListSplitter* DrawSplitter
        ImGuiTableColumnSortSpecs SortSpecsSingle
        ImVector_ImGuiTableColumnSortSpecs SortSpecsMulti
        ImGuiTableSortSpecs SortSpecs
        ImGuiTableColumnIdx SortSpecsCount
        ImGuiTableColumnIdx ColumnsEnabledCount
        ImGuiTableColumnIdx ColumnsEnabledFixedCount
        ImGuiTableColumnIdx DeclColumnsCount
        ImGuiTableColumnIdx HoveredColumnBody
        ImGuiTableColumnIdx HoveredColumnBorder
        ImGuiTableColumnIdx AutoFitSingleColumn
        ImGuiTableColumnIdx ResizedColumn
        ImGuiTableColumnIdx LastResizedColumn
        ImGuiTableColumnIdx HeldHeaderColumn
        ImGuiTableColumnIdx ReorderColumn
        ImGuiTableColumnIdx ReorderColumnDir
        ImGuiTableColumnIdx LeftMostEnabledColumn
        ImGuiTableColumnIdx RightMostEnabledColumn
        ImGuiTableColumnIdx LeftMostStretchedColumn
        ImGuiTableColumnIdx RightMostStretchedColumn
        ImGuiTableColumnIdx ContextPopupColumn
        ImGuiTableColumnIdx FreezeRowsRequest
        ImGuiTableColumnIdx FreezeRowsCount
        ImGuiTableColumnIdx FreezeColumnsRequest
        ImGuiTableColumnIdx FreezeColumnsCount
        ImGuiTableColumnIdx RowCellDataCurrent
        ImGuiTableDrawChannelIdx DummyDrawChannel
        ImGuiTableDrawChannelIdx Bg2DrawChannelCurrent
        ImGuiTableDrawChannelIdx Bg2DrawChannelUnfrozen
        bint IsLayoutLocked
        bint IsInsideRow
        bint IsInitializing
        bint IsSortSpecsDirty
        bint IsUsingHeaders
        bint IsContextPopupOpen
        bint IsSettingsRequestLoad
        bint IsSettingsDirty
        bint IsDefaultDisplayOrder
        bint IsResetAllRequest
        bint IsResetDisplayOrderRequest
        bint IsUnfrozenRows
        bint IsDefaultSizingPolicy
        bint MemoryCompacted
        bint HostSkipItems

    ctypedef struct ImGuiTableTempData:
        int TableIndex
        float LastTimeActive
        ImVec2 UserOuterSize
        ImDrawListSplitter DrawSplitter
        ImRect HostBackupWorkRect
        ImRect HostBackupParentWorkRect
        ImVec2 HostBackupPrevLineSize
        ImVec2 HostBackupCurrLineSize
        ImVec2 HostBackupCursorMaxPos
        ImVec1 HostBackupColumnsOffset
        float HostBackupItemWidth
        int HostBackupItemWidthStackSize

    ctypedef struct ImGuiTableColumnSettings:
        float WidthOrWeight
        ImGuiID UserID
        ImGuiTableColumnIdx Index
        ImGuiTableColumnIdx DisplayOrder
        ImGuiTableColumnIdx SortOrder
        #ImU8 SortDirection : 2
        ImU8 SortDirection
        #ImU8 IsEnabled : 1
        ImU8 IsEnabled
        #ImU8 IsStretch : 1
        ImU8 IsStretch

    ctypedef struct ImGuiTableSettings:
        ImGuiID ID
        ImGuiTableFlags SaveFlags
        float RefScale
        ImGuiTableColumnIdx ColumnsCount
        ImGuiTableColumnIdx ColumnsCountMax
        bint WantApply

    ctypedef struct ImFontBuilderIO:
        bint (*FontBuilder_Build)(ImFontAtlas* atlas)

    #struct GLFWwindow
    #struct SDL_Window
    #ctypedef union SDL_Event SDL_Event

    ImVec2* ImVec2_ImVec2_Nil()
    void ImVec2_destroy(ImVec2* self)
    ImVec2* ImVec2_ImVec2_Float(float _x,float _y)
    ImVec4* ImVec4_ImVec4_Nil()
    void ImVec4_destroy(ImVec4* self)
    ImVec4* ImVec4_ImVec4_Float(float _x,float _y,float _z,float _w)
    ImGuiContext* igCreateContext(ImFontAtlas* shared_font_atlas)
    void igDestroyContext(ImGuiContext* ctx)
    ImGuiContext* igGetCurrentContext()
    void igSetCurrentContext(ImGuiContext* ctx)
    ImGuiIO* igGetIO()
    ImGuiStyle* igGetStyle()
    void igNewFrame()
    void igEndFrame()
    void igRender()
    ImDrawData* igGetDrawData()
    void igShowDemoWindow(bint* p_open)
    void igShowMetricsWindow(bint* p_open)
    void igShowAboutWindow(bint* p_open)
    void igShowStyleEditor(ImGuiStyle* ref)
    bint igShowStyleSelector(const char* label)
    void igShowFontSelector(const char* label)
    void igShowUserGuide()
    const char* igGetVersion()
    void igStyleColorsDark(ImGuiStyle* dst)
    void igStyleColorsLight(ImGuiStyle* dst)
    void igStyleColorsClassic(ImGuiStyle* dst)
    bint igBegin(const char* name,bint* p_open,ImGuiWindowFlags flags)
    void igEnd()
    bint igBeginChild_Str(const char* str_id,const ImVec2 size,bint border,ImGuiWindowFlags flags)
    bint igBeginChild_ID(ImGuiID id,const ImVec2 size,bint border,ImGuiWindowFlags flags)
    void igEndChild()
    bint igIsWindowAppearing()
    bint igIsWindowCollapsed()
    bint igIsWindowFocused(ImGuiFocusedFlags flags)
    bint igIsWindowHovered(ImGuiHoveredFlags flags)
    ImDrawList* igGetWindowDrawList()
    void igGetWindowPos(ImVec2 *pOut)
    void igGetWindowSize(ImVec2 *pOut)
    float igGetWindowWidth()
    float igGetWindowHeight()
    void igSetNextWindowPos(const ImVec2 pos,ImGuiCond cond,const ImVec2 pivot)
    void igSetNextWindowSize(const ImVec2 size,ImGuiCond cond)
    void igSetNextWindowSizeConstraints(const ImVec2 size_min,const ImVec2 size_max,ImGuiSizeCallback custom_callback,void* custom_callback_data)
    void igSetNextWindowContentSize(const ImVec2 size)
    void igSetNextWindowCollapsed(bint collapsed,ImGuiCond cond)
    void igSetNextWindowFocus()
    void igSetNextWindowBgAlpha(float alpha)
    void igSetWindowPos_Vec2(const ImVec2 pos,ImGuiCond cond)
    void igSetWindowSize_Vec2(const ImVec2 size,ImGuiCond cond)
    void igSetWindowCollapsed_Bool(bint collapsed,ImGuiCond cond)
    void igSetWindowFocus_Nil()
    void igSetWindowFontScale(float scale)
    void igSetWindowPos_Str(const char* name,const ImVec2 pos,ImGuiCond cond)
    void igSetWindowSize_Str(const char* name,const ImVec2 size,ImGuiCond cond)
    void igSetWindowCollapsed_Str(const char* name,bint collapsed,ImGuiCond cond)
    void igSetWindowFocus_Str(const char* name)
    void igGetContentRegionAvail(ImVec2 *pOut)
    void igGetContentRegionMax(ImVec2 *pOut)
    void igGetWindowContentRegionMin(ImVec2 *pOut)
    void igGetWindowContentRegionMax(ImVec2 *pOut)
    float igGetWindowContentRegionWidth()
    float igGetScrollX()
    float igGetScrollY()
    void igSetScrollX_Float(float scroll_x)
    void igSetScrollY_Float(float scroll_y)
    float igGetScrollMaxX()
    float igGetScrollMaxY()
    void igSetScrollHereX(float center_x_ratio)
    void igSetScrollHereY(float center_y_ratio)
    void igSetScrollFromPosX_Float(float local_x,float center_x_ratio)
    void igSetScrollFromPosY_Float(float local_y,float center_y_ratio)
    void igPushFont(ImFont* font)
    void igPopFont()
    void igPushStyleColor_U32(ImGuiCol idx,ImU32 col)
    void igPushStyleColor_Vec4(ImGuiCol idx,const ImVec4 col)
    void igPopStyleColor(int count)
    void igPushStyleVar_Float(ImGuiStyleVar idx,float val)
    void igPushStyleVar_Vec2(ImGuiStyleVar idx,const ImVec2 val)
    void igPopStyleVar(int count)
    void igPushAllowKeyboardFocus(bint allow_keyboard_focus)
    void igPopAllowKeyboardFocus()
    void igPushButtonRepeat(bint repeat)
    void igPopButtonRepeat()
    void igPushItemWidth(float item_width)
    void igPopItemWidth()
    void igSetNextItemWidth(float item_width)
    float igCalcItemWidth()
    void igPushTextWrapPos(float wrap_local_pos_x)
    void igPopTextWrapPos()
    ImFont* igGetFont()
    float igGetFontSize()
    void igGetFontTexUvWhitePixel(ImVec2 *pOut)
    ImU32 igGetColorU32_Col(ImGuiCol idx,float alpha_mul)
    ImU32 igGetColorU32_Vec4(const ImVec4 col)
    ImU32 igGetColorU32_U32(ImU32 col)
    const ImVec4* igGetStyleColorVec4(ImGuiCol idx)
    void igSeparator()
    void igSameLine(float offset_from_start_x,float spacing)
    void igNewLine()
    void igSpacing()
    void igDummy(const ImVec2 size)
    void igIndent(float indent_w)
    void igUnindent(float indent_w)
    void igBeginGroup()
    void igEndGroup()
    void igGetCursorPos(ImVec2 *pOut)
    float igGetCursorPosX()
    float igGetCursorPosY()
    void igSetCursorPos(const ImVec2 local_pos)
    void igSetCursorPosX(float local_x)
    void igSetCursorPosY(float local_y)
    void igGetCursorStartPos(ImVec2 *pOut)
    void igGetCursorScreenPos(ImVec2 *pOut)
    void igSetCursorScreenPos(const ImVec2 pos)
    void igAlignTextToFramePadding()
    float igGetTextLineHeight()
    float igGetTextLineHeightWithSpacing()
    float igGetFrameHeight()
    float igGetFrameHeightWithSpacing()
    void igPushID_Str(const char* str_id)
    void igPushID_StrStr(const char* str_id_begin,const char* str_id_end)
    void igPushID_Ptr(const void* ptr_id)
    void igPushID_Int(int int_id)
    void igPopID()
    ImGuiID igGetID_Str(const char* str_id)
    ImGuiID igGetID_StrStr(const char* str_id_begin,const char* str_id_end)
    ImGuiID igGetID_Ptr(const void* ptr_id)
    void igTextUnformatted(const char* text,const char* text_end)
    void igText(const char* fmt,...)
    void igTextV(const char* fmt,va_list args)
    void igTextColored(const ImVec4 col,const char* fmt,...)
    void igTextColoredV(const ImVec4 col,const char* fmt,va_list args)
    void igTextDisabled(const char* fmt,...)
    void igTextDisabledV(const char* fmt,va_list args)
    void igTextWrapped(const char* fmt,...)
    void igTextWrappedV(const char* fmt,va_list args)
    void igLabelText(const char* label,const char* fmt,...)
    void igLabelTextV(const char* label,const char* fmt,va_list args)
    void igBulletText(const char* fmt,...)
    void igBulletTextV(const char* fmt,va_list args)
    bint igButton(const char* label,const ImVec2 size)
    bint igSmallButton(const char* label)
    bint igInvisibleButton(const char* str_id,const ImVec2 size,ImGuiButtonFlags flags)
    bint igArrowButton(const char* str_id,ImGuiDir dir)
    void igImage(ImTextureID user_texture_id,const ImVec2 size,const ImVec2 uv0,const ImVec2 uv1,const ImVec4 tint_col,const ImVec4 border_col)
    bint igImageButton(ImTextureID user_texture_id,const ImVec2 size,const ImVec2 uv0,const ImVec2 uv1,int frame_padding,const ImVec4 bg_col,const ImVec4 tint_col)
    bint igCheckbox(const char* label,bint* v)
    bint igCheckboxFlags_IntPtr(const char* label,int* flags,int flags_value)
    bint igCheckboxFlags_UintPtr(const char* label,unsigned int* flags,unsigned int flags_value)
    bint igRadioButton_Bool(const char* label,bint active)
    bint igRadioButton_IntPtr(const char* label,int* v,int v_button)
    void igProgressBar(float fraction,const ImVec2 size_arg,const char* overlay)
    void igBullet()
    bint igBeginCombo(const char* label,const char* preview_value,ImGuiComboFlags flags)
    void igEndCombo()
    bint igCombo_Str_arr(const char* label,int* current_item,const char* const items[],int items_count,int popup_max_height_in_items)
    bint igCombo_Str(const char* label,int* current_item,const char* items_separated_by_zeros,int popup_max_height_in_items)
    bint igCombo_FnBoolPtr(const char* label,int* current_item,bint(*items_getter)(void* data,int idx,const char** out_text),void* data,int items_count,int popup_max_height_in_items)
    bint igDragFloat(const char* label,float* v,float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragFloat2(const char* label,float v[2],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragFloat3(const char* label,float v[3],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragFloat4(const char* label,float v[4],float v_speed,float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragFloatRange2(const char* label,float* v_current_min,float* v_current_max,float v_speed,float v_min,float v_max,const char* format,const char* format_max,ImGuiSliderFlags flags)
    bint igDragInt(const char* label,int* v,float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragInt2(const char* label,int v[2],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragInt3(const char* label,int v[3],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragInt4(const char* label,int v[4],float v_speed,int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igDragIntRange2(const char* label,int* v_current_min,int* v_current_max,float v_speed,int v_min,int v_max,const char* format,const char* format_max,ImGuiSliderFlags flags)
    bint igDragScalar(const char* label,ImGuiDataType data_type,void* p_data,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags)
    bint igDragScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderFloat(const char* label,float* v,float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderFloat2(const char* label,float v[2],float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderFloat3(const char* label,float v[3],float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderFloat4(const char* label,float v[4],float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderAngle(const char* label,float* v_rad,float v_degrees_min,float v_degrees_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderInt(const char* label,int* v,int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderInt2(const char* label,int v[2],int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderInt3(const char* label,int v[3],int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderInt4(const char* label,int v[4],int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderScalar(const char* label,ImGuiDataType data_type,void* p_data,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags)
    bint igVSliderFloat(const char* label,const ImVec2 size,float* v,float v_min,float v_max,const char* format,ImGuiSliderFlags flags)
    bint igVSliderInt(const char* label,const ImVec2 size,int* v,int v_min,int v_max,const char* format,ImGuiSliderFlags flags)
    bint igVSliderScalar(const char* label,const ImVec2 size,ImGuiDataType data_type,void* p_data,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags)
    bint igInputText(const char* label,char* buf,size_t buf_size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data)
    bint igInputTextMultiline(const char* label,char* buf,size_t buf_size,const ImVec2 size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data)
    bint igInputTextWithHint(const char* label,const char* hint,char* buf,size_t buf_size,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data)
    bint igInputFloat(const char* label,float* v,float step,float step_fast,const char* format,ImGuiInputTextFlags flags)
    bint igInputFloat2(const char* label,float v[2],const char* format,ImGuiInputTextFlags flags)
    bint igInputFloat3(const char* label,float v[3],const char* format,ImGuiInputTextFlags flags)
    bint igInputFloat4(const char* label,float v[4],const char* format,ImGuiInputTextFlags flags)
    bint igInputInt(const char* label,int* v,int step,int step_fast,ImGuiInputTextFlags flags)
    bint igInputInt2(const char* label,int v[2],ImGuiInputTextFlags flags)
    bint igInputInt3(const char* label,int v[3],ImGuiInputTextFlags flags)
    bint igInputInt4(const char* label,int v[4],ImGuiInputTextFlags flags)
    bint igInputDouble(const char* label,double* v,double step,double step_fast,const char* format,ImGuiInputTextFlags flags)
    bint igInputScalar(const char* label,ImGuiDataType data_type,void* p_data,const void* p_step,const void* p_step_fast,const char* format,ImGuiInputTextFlags flags)
    bint igInputScalarN(const char* label,ImGuiDataType data_type,void* p_data,int components,const void* p_step,const void* p_step_fast,const char* format,ImGuiInputTextFlags flags)
    bint igColorEdit3(const char* label,float col[3],ImGuiColorEditFlags flags)
    bint igColorEdit4(const char* label,float col[4],ImGuiColorEditFlags flags)
    bint igColorPicker3(const char* label,float col[3],ImGuiColorEditFlags flags)
    bint igColorPicker4(const char* label,float col[4],ImGuiColorEditFlags flags,const float* ref_col)
    bint igColorButton(const char* desc_id,const ImVec4 col,ImGuiColorEditFlags flags,ImVec2 size)
    void igSetColorEditOptions(ImGuiColorEditFlags flags)
    bint igTreeNode_Str(const char* label)
    bint igTreeNode_StrStr(const char* str_id,const char* fmt,...)
    bint igTreeNode_Ptr(const void* ptr_id,const char* fmt,...)
    bint igTreeNodeV_Str(const char* str_id,const char* fmt,va_list args)
    bint igTreeNodeV_Ptr(const void* ptr_id,const char* fmt,va_list args)
    bint igTreeNodeEx_Str(const char* label,ImGuiTreeNodeFlags flags)
    bint igTreeNodeEx_StrStr(const char* str_id,ImGuiTreeNodeFlags flags,const char* fmt,...)
    bint igTreeNodeEx_Ptr(const void* ptr_id,ImGuiTreeNodeFlags flags,const char* fmt,...)
    bint igTreeNodeExV_Str(const char* str_id,ImGuiTreeNodeFlags flags,const char* fmt,va_list args)
    bint igTreeNodeExV_Ptr(const void* ptr_id,ImGuiTreeNodeFlags flags,const char* fmt,va_list args)
    void igTreePush_Str(const char* str_id)
    void igTreePush_Ptr(const void* ptr_id)
    void igTreePop()
    float igGetTreeNodeToLabelSpacing()
    bint igCollapsingHeader_TreeNodeFlags(const char* label,ImGuiTreeNodeFlags flags)
    bint igCollapsingHeader_BoolPtr(const char* label,bint* p_visible,ImGuiTreeNodeFlags flags)
    void igSetNextItemOpen(bint is_open,ImGuiCond cond)
    bint igSelectable_Bool(const char* label,bint selected,ImGuiSelectableFlags flags,const ImVec2 size)
    bint igSelectable_BoolPtr(const char* label,bint* p_selected,ImGuiSelectableFlags flags,const ImVec2 size)
    bint igBeginListBox(const char* label,const ImVec2 size)
    void igEndListBox()
    bint igListBox_Str_arr(const char* label,int* current_item,const char* const items[],int items_count,int height_in_items)
    bint igListBox_FnBoolPtr(const char* label,int* current_item,bint(*items_getter)(void* data,int idx,const char** out_text),void* data,int items_count,int height_in_items)
    void igPlotLines_FloatPtr(const char* label,const float* values,int values_count,int values_offset,const char* overlay_text,float scale_min,float scale_max,ImVec2 graph_size,int stride)
    void igPlotLines_FnFloatPtr(const char* label,float(*values_getter)(void* data,int idx),void* data,int values_count,int values_offset,const char* overlay_text,float scale_min,float scale_max,ImVec2 graph_size)
    void igPlotHistogram_FloatPtr(const char* label,const float* values,int values_count,int values_offset,const char* overlay_text,float scale_min,float scale_max,ImVec2 graph_size,int stride)
    void igPlotHistogram_FnFloatPtr(const char* label,float(*values_getter)(void* data,int idx),void* data,int values_count,int values_offset,const char* overlay_text,float scale_min,float scale_max,ImVec2 graph_size)
    void igValue_Bool(const char* prefix,bint b)
    void igValue_Int(const char* prefix,int v)
    void igValue_Uint(const char* prefix,unsigned int v)
    void igValue_Float(const char* prefix,float v,const char* float_format)
    bint igBeginMenuBar()
    void igEndMenuBar()
    bint igBeginMainMenuBar()
    void igEndMainMenuBar()
    bint igBeginMenu(const char* label,bint enabled)
    void igEndMenu()
    bint igMenuItem_Bool(const char* label,const char* shortcut,bint selected,bint enabled)
    bint igMenuItem_BoolPtr(const char* label,const char* shortcut,bint* p_selected,bint enabled)
    void igBeginTooltip()
    void igEndTooltip()
    void igSetTooltip(const char* fmt,...)
    void igSetTooltipV(const char* fmt,va_list args)
    bint igBeginPopup(const char* str_id,ImGuiWindowFlags flags)
    bint igBeginPopupModal(const char* name,bint* p_open,ImGuiWindowFlags flags)
    void igEndPopup()
    void igOpenPopup_Str(const char* str_id,ImGuiPopupFlags popup_flags)
    void igOpenPopup_ID(ImGuiID id,ImGuiPopupFlags popup_flags)
    void igOpenPopupOnItemClick(const char* str_id,ImGuiPopupFlags popup_flags)
    void igCloseCurrentPopup()
    bint igBeginPopupContextItem(const char* str_id,ImGuiPopupFlags popup_flags)
    bint igBeginPopupContextWindow(const char* str_id,ImGuiPopupFlags popup_flags)
    bint igBeginPopupContextVoid(const char* str_id,ImGuiPopupFlags popup_flags)
    bint igIsPopupOpen_Str(const char* str_id,ImGuiPopupFlags flags)
    bint igBeginTable(const char* str_id,int column,ImGuiTableFlags flags,const ImVec2 outer_size,float inner_width)
    void igEndTable()
    void igTableNextRow(ImGuiTableRowFlags row_flags,float min_row_height)
    bint igTableNextColumn()
    bint igTableSetColumnIndex(int column_n)
    void igTableSetupColumn(const char* label,ImGuiTableColumnFlags flags,float init_width_or_weight,ImGuiID user_id)
    void igTableSetupScrollFreeze(int cols,int rows)
    void igTableHeadersRow()
    void igTableHeader(const char* label)
    ImGuiTableSortSpecs* igTableGetSortSpecs()
    int igTableGetColumnCount()
    int igTableGetColumnIndex()
    int igTableGetRowIndex()
    const char* igTableGetColumnName_Int(int column_n)
    ImGuiTableColumnFlags igTableGetColumnFlags(int column_n)
    void igTableSetColumnEnabled(int column_n,bint v)
    void igTableSetBgColor(ImGuiTableBgTarget target,ImU32 color,int column_n)
    void igColumns(int count,const char* id,bint border)
    void igNextColumn()
    int igGetColumnIndex()
    float igGetColumnWidth(int column_index)
    void igSetColumnWidth(int column_index,float width)
    float igGetColumnOffset(int column_index)
    void igSetColumnOffset(int column_index,float offset_x)
    int igGetColumnsCount()
    bint igBeginTabBar(const char* str_id,ImGuiTabBarFlags flags)
    void igEndTabBar()
    bint igBeginTabItem(const char* label,bint* p_open,ImGuiTabItemFlags flags)
    void igEndTabItem()
    bint igTabItemButton(const char* label,ImGuiTabItemFlags flags)
    void igSetTabItemClosed(const char* tab_or_docked_window_label)
    void igLogToTTY(int auto_open_depth)
    void igLogToFile(int auto_open_depth,const char* filename)
    void igLogToClipboard(int auto_open_depth)
    void igLogFinish()
    void igLogButtons()
    void igLogTextV(const char* fmt,va_list args)
    bint igBeginDragDropSource(ImGuiDragDropFlags flags)
    bint igSetDragDropPayload(const char* type,const void* data,size_t sz,ImGuiCond cond)
    void igEndDragDropSource()
    bint igBeginDragDropTarget()
    const ImGuiPayload* igAcceptDragDropPayload(const char* type,ImGuiDragDropFlags flags)
    void igEndDragDropTarget()
    const ImGuiPayload* igGetDragDropPayload()
    void igBeginDisabled(bint disabled)
    void igEndDisabled()
    void igPushClipRect(const ImVec2 clip_rect_min,const ImVec2 clip_rect_max,bint intersect_with_current_clip_rect)
    void igPopClipRect()
    void igSetItemDefaultFocus()
    void igSetKeyboardFocusHere(int offset)
    bint igIsItemHovered(ImGuiHoveredFlags flags)
    bint igIsItemActive()
    bint igIsItemFocused()
    bint igIsItemClicked(ImGuiMouseButton mouse_button)
    bint igIsItemVisible()
    bint igIsItemEdited()
    bint igIsItemActivated()
    bint igIsItemDeactivated()
    bint igIsItemDeactivatedAfterEdit()
    bint igIsItemToggledOpen()
    bint igIsAnyItemHovered()
    bint igIsAnyItemActive()
    bint igIsAnyItemFocused()
    void igGetItemRectMin(ImVec2 *pOut)
    void igGetItemRectMax(ImVec2 *pOut)
    void igGetItemRectSize(ImVec2 *pOut)
    void igSetItemAllowOverlap()
    ImGuiViewport* igGetMainViewport()
    bint igIsRectVisible_Nil(const ImVec2 size)
    bint igIsRectVisible_Vec2(const ImVec2 rect_min,const ImVec2 rect_max)
    double igGetTime()
    int igGetFrameCount()
    ImDrawList* igGetBackgroundDrawList_Nil()
    ImDrawList* igGetForegroundDrawList_Nil()
    ImDrawListSharedData* igGetDrawListSharedData()
    const char* igGetStyleColorName(ImGuiCol idx)
    void igSetStateStorage(ImGuiStorage* storage)
    ImGuiStorage* igGetStateStorage()
    void igCalcListClipping(int items_count,float items_height,int* out_items_display_start,int* out_items_display_end)
    bint igBeginChildFrame(ImGuiID id,const ImVec2 size,ImGuiWindowFlags flags)
    void igEndChildFrame()
    void igCalcTextSize(ImVec2 *pOut,const char* text,const char* text_end,bint hide_text_after_double_hash,float wrap_width)
    #void igColorConvertU32ToFloat4(ImVec4 *pOut,ImU32 in)
    #ImU32 igColorConvertFloat4ToU32(const ImVec4 in)
    void igColorConvertRGBtoHSV(float r,float g,float b,float* out_h,float* out_s,float* out_v)
    void igColorConvertHSVtoRGB(float h,float s,float v,float* out_r,float* out_g,float* out_b)
    int igGetKeyIndex(ImGuiKey imgui_key)
    bint igIsKeyDown(int user_key_index)
    bint igIsKeyPressed(int user_key_index,bint repeat)
    bint igIsKeyReleased(int user_key_index)
    int igGetKeyPressedAmount(int key_index,float repeat_delay,float rate)
    void igCaptureKeyboardFromApp(bint want_capture_keyboard_value)
    bint igIsMouseDown(ImGuiMouseButton button)
    bint igIsMouseClicked(ImGuiMouseButton button,bint repeat)
    bint igIsMouseReleased(ImGuiMouseButton button)
    bint igIsMouseDoubleClicked(ImGuiMouseButton button)
    bint igIsMouseHoveringRect(const ImVec2 r_min,const ImVec2 r_max,bint clip)
    bint igIsMousePosValid(const ImVec2* mouse_pos)
    bint igIsAnyMouseDown()
    void igGetMousePos(ImVec2 *pOut)
    void igGetMousePosOnOpeningCurrentPopup(ImVec2 *pOut)
    bint igIsMouseDragging(ImGuiMouseButton button,float lock_threshold)
    void igGetMouseDragDelta(ImVec2 *pOut,ImGuiMouseButton button,float lock_threshold)
    void igResetMouseDragDelta(ImGuiMouseButton button)
    ImGuiMouseCursor igGetMouseCursor()
    void igSetMouseCursor(ImGuiMouseCursor cursor_type)
    void igCaptureMouseFromApp(bint want_capture_mouse_value)
    const char* igGetClipboardText()
    void igSetClipboardText(const char* text)
    void igLoadIniSettingsFromDisk(const char* ini_filename)
    void igLoadIniSettingsFromMemory(const char* ini_data,size_t ini_size)
    void igSaveIniSettingsToDisk(const char* ini_filename)
    const char* igSaveIniSettingsToMemory(size_t* out_ini_size)
    bint igDebugCheckVersionAndDataLayout(const char* version_str,size_t sz_io,size_t sz_style,size_t sz_vec2,size_t sz_vec4,size_t sz_drawvert,size_t sz_drawidx)
    void igSetAllocatorFunctions(ImGuiMemAllocFunc alloc_func,ImGuiMemFreeFunc free_func,void* user_data)
    void igGetAllocatorFunctions(ImGuiMemAllocFunc* p_alloc_func,ImGuiMemFreeFunc* p_free_func,void** p_user_data)
    void* igMemAlloc(size_t size)
    void igMemFree(void* ptr)
    ImGuiStyle* ImGuiStyle_ImGuiStyle()
    void ImGuiStyle_destroy(ImGuiStyle* self)
    void ImGuiStyle_ScaleAllSizes(ImGuiStyle* self,float scale_factor)
    void ImGuiIO_AddInputCharacter(ImGuiIO* self,unsigned int c)
    void ImGuiIO_AddInputCharacterUTF16(ImGuiIO* self,ImWchar16 c)
    void ImGuiIO_AddInputCharactersUTF8(ImGuiIO* self,const char* str)
    void ImGuiIO_ClearInputCharacters(ImGuiIO* self)
    void ImGuiIO_AddFocusEvent(ImGuiIO* self,bint focused)
    ImGuiIO* ImGuiIO_ImGuiIO()
    void ImGuiIO_destroy(ImGuiIO* self)
    ImGuiInputTextCallbackData* ImGuiInputTextCallbackData_ImGuiInputTextCallbackData()
    void ImGuiInputTextCallbackData_destroy(ImGuiInputTextCallbackData* self)
    void ImGuiInputTextCallbackData_DeleteChars(ImGuiInputTextCallbackData* self,int pos,int bytes_count)
    void ImGuiInputTextCallbackData_InsertChars(ImGuiInputTextCallbackData* self,int pos,const char* text,const char* text_end)
    void ImGuiInputTextCallbackData_SelectAll(ImGuiInputTextCallbackData* self)
    void ImGuiInputTextCallbackData_ClearSelection(ImGuiInputTextCallbackData* self)
    bint ImGuiInputTextCallbackData_HasSelection(ImGuiInputTextCallbackData* self)
    ImGuiPayload* ImGuiPayload_ImGuiPayload()
    void ImGuiPayload_destroy(ImGuiPayload* self)
    void ImGuiPayload_Clear(ImGuiPayload* self)
    bint ImGuiPayload_IsDataType(ImGuiPayload* self,const char* type)
    bint ImGuiPayload_IsPreview(ImGuiPayload* self)
    bint ImGuiPayload_IsDelivery(ImGuiPayload* self)
    ImGuiTableColumnSortSpecs* ImGuiTableColumnSortSpecs_ImGuiTableColumnSortSpecs()
    void ImGuiTableColumnSortSpecs_destroy(ImGuiTableColumnSortSpecs* self)
    ImGuiTableSortSpecs* ImGuiTableSortSpecs_ImGuiTableSortSpecs()
    void ImGuiTableSortSpecs_destroy(ImGuiTableSortSpecs* self)
    ImGuiOnceUponAFrame* ImGuiOnceUponAFrame_ImGuiOnceUponAFrame()
    void ImGuiOnceUponAFrame_destroy(ImGuiOnceUponAFrame* self)
    ImGuiTextFilter* ImGuiTextFilter_ImGuiTextFilter(const char* default_filter)
    void ImGuiTextFilter_destroy(ImGuiTextFilter* self)
    bint ImGuiTextFilter_Draw(ImGuiTextFilter* self,const char* label,float width)
    bint ImGuiTextFilter_PassFilter(ImGuiTextFilter* self,const char* text,const char* text_end)
    void ImGuiTextFilter_Build(ImGuiTextFilter* self)
    void ImGuiTextFilter_Clear(ImGuiTextFilter* self)
    bint ImGuiTextFilter_IsActive(ImGuiTextFilter* self)
    ImGuiTextRange* ImGuiTextRange_ImGuiTextRange_Nil()
    void ImGuiTextRange_destroy(ImGuiTextRange* self)
    ImGuiTextRange* ImGuiTextRange_ImGuiTextRange_Str(const char* _b,const char* _e)
    bint ImGuiTextRange_empty(ImGuiTextRange* self)
    void ImGuiTextRange_split(ImGuiTextRange* self,char separator,ImVector_ImGuiTextRange* out)
    ImGuiTextBuffer* ImGuiTextBuffer_ImGuiTextBuffer()
    void ImGuiTextBuffer_destroy(ImGuiTextBuffer* self)
    const char* ImGuiTextBuffer_begin(ImGuiTextBuffer* self)
    const char* ImGuiTextBuffer_end(ImGuiTextBuffer* self)
    int ImGuiTextBuffer_size(ImGuiTextBuffer* self)
    bint ImGuiTextBuffer_empty(ImGuiTextBuffer* self)
    void ImGuiTextBuffer_clear(ImGuiTextBuffer* self)
    void ImGuiTextBuffer_reserve(ImGuiTextBuffer* self,int capacity)
    const char* ImGuiTextBuffer_c_str(ImGuiTextBuffer* self)
    void ImGuiTextBuffer_append(ImGuiTextBuffer* self,const char* str,const char* str_end)
    void ImGuiTextBuffer_appendfv(ImGuiTextBuffer* self,const char* fmt,va_list args)
    ImGuiStoragePair* ImGuiStoragePair_ImGuiStoragePair_Int(ImGuiID _key,int _val_i)
    void ImGuiStoragePair_destroy(ImGuiStoragePair* self)
    ImGuiStoragePair* ImGuiStoragePair_ImGuiStoragePair_Float(ImGuiID _key,float _val_f)
    ImGuiStoragePair* ImGuiStoragePair_ImGuiStoragePair_Ptr(ImGuiID _key,void* _val_p)
    void ImGuiStorage_Clear(ImGuiStorage* self)
    int ImGuiStorage_GetInt(ImGuiStorage* self,ImGuiID key,int default_val)
    void ImGuiStorage_SetInt(ImGuiStorage* self,ImGuiID key,int val)
    bint ImGuiStorage_GetBool(ImGuiStorage* self,ImGuiID key,bint default_val)
    void ImGuiStorage_SetBool(ImGuiStorage* self,ImGuiID key,bint val)
    float ImGuiStorage_GetFloat(ImGuiStorage* self,ImGuiID key,float default_val)
    void ImGuiStorage_SetFloat(ImGuiStorage* self,ImGuiID key,float val)
    void* ImGuiStorage_GetVoidPtr(ImGuiStorage* self,ImGuiID key)
    void ImGuiStorage_SetVoidPtr(ImGuiStorage* self,ImGuiID key,void* val)
    int* ImGuiStorage_GetIntRef(ImGuiStorage* self,ImGuiID key,int default_val)
    bint* ImGuiStorage_GetBoolRef(ImGuiStorage* self,ImGuiID key,bint default_val)
    float* ImGuiStorage_GetFloatRef(ImGuiStorage* self,ImGuiID key,float default_val)
    void** ImGuiStorage_GetVoidPtrRef(ImGuiStorage* self,ImGuiID key,void* default_val)
    void ImGuiStorage_SetAllInt(ImGuiStorage* self,int val)
    void ImGuiStorage_BuildSortByKey(ImGuiStorage* self)
    ImGuiListClipper* ImGuiListClipper_ImGuiListClipper()
    void ImGuiListClipper_destroy(ImGuiListClipper* self)
    void ImGuiListClipper_Begin(ImGuiListClipper* self,int items_count,float items_height)
    void ImGuiListClipper_End(ImGuiListClipper* self)
    bint ImGuiListClipper_Step(ImGuiListClipper* self)
    ImColor* ImColor_ImColor_Nil()
    void ImColor_destroy(ImColor* self)
    ImColor* ImColor_ImColor_Int(int r,int g,int b,int a)
    ImColor* ImColor_ImColor_U32(ImU32 rgba)
    ImColor* ImColor_ImColor_Float(float r,float g,float b,float a)
    ImColor* ImColor_ImColor_Vec4(const ImVec4 col)
    void ImColor_SetHSV(ImColor* self,float h,float s,float v,float a)
    void ImColor_HSV(ImColor *pOut,float h,float s,float v,float a)
    ImDrawCmd* ImDrawCmd_ImDrawCmd()
    void ImDrawCmd_destroy(ImDrawCmd* self)
    ImTextureID ImDrawCmd_GetTexID(ImDrawCmd* self)
    ImDrawListSplitter* ImDrawListSplitter_ImDrawListSplitter()
    void ImDrawListSplitter_destroy(ImDrawListSplitter* self)
    void ImDrawListSplitter_Clear(ImDrawListSplitter* self)
    void ImDrawListSplitter_ClearFreeMemory(ImDrawListSplitter* self)
    void ImDrawListSplitter_Split(ImDrawListSplitter* self,ImDrawList* draw_list,int count)
    void ImDrawListSplitter_Merge(ImDrawListSplitter* self,ImDrawList* draw_list)
    void ImDrawListSplitter_SetCurrentChannel(ImDrawListSplitter* self,ImDrawList* draw_list,int channel_idx)
    ImDrawList* ImDrawList_ImDrawList(const ImDrawListSharedData* shared_data)
    void ImDrawList_destroy(ImDrawList* self)
    void ImDrawList_PushClipRect(ImDrawList* self,ImVec2 clip_rect_min,ImVec2 clip_rect_max,bint intersect_with_current_clip_rect)
    void ImDrawList_PushClipRectFullScreen(ImDrawList* self)
    void ImDrawList_PopClipRect(ImDrawList* self)
    void ImDrawList_PushTextureID(ImDrawList* self,ImTextureID texture_id)
    void ImDrawList_PopTextureID(ImDrawList* self)
    void ImDrawList_GetClipRectMin(ImVec2 *pOut,ImDrawList* self)
    void ImDrawList_GetClipRectMax(ImVec2 *pOut,ImDrawList* self)
    void ImDrawList_AddLine(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,ImU32 col,float thickness)
    void ImDrawList_AddRect(ImDrawList* self,const ImVec2 p_min,const ImVec2 p_max,ImU32 col,float rounding,ImDrawFlags flags,float thickness)
    void ImDrawList_AddRectFilled(ImDrawList* self,const ImVec2 p_min,const ImVec2 p_max,ImU32 col,float rounding,ImDrawFlags flags)
    void ImDrawList_AddRectFilledMultiColor(ImDrawList* self,const ImVec2 p_min,const ImVec2 p_max,ImU32 col_upr_left,ImU32 col_upr_right,ImU32 col_bot_right,ImU32 col_bot_left)
    void ImDrawList_AddQuad(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,ImU32 col,float thickness)
    void ImDrawList_AddQuadFilled(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,ImU32 col)
    void ImDrawList_AddTriangle(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,ImU32 col,float thickness)
    void ImDrawList_AddTriangleFilled(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,ImU32 col)
    void ImDrawList_AddCircle(ImDrawList* self,const ImVec2 center,float radius,ImU32 col,int num_segments,float thickness)
    void ImDrawList_AddCircleFilled(ImDrawList* self,const ImVec2 center,float radius,ImU32 col,int num_segments)
    void ImDrawList_AddNgon(ImDrawList* self,const ImVec2 center,float radius,ImU32 col,int num_segments,float thickness)
    void ImDrawList_AddNgonFilled(ImDrawList* self,const ImVec2 center,float radius,ImU32 col,int num_segments)
    void ImDrawList_AddText_Vec2(ImDrawList* self,const ImVec2 pos,ImU32 col,const char* text_begin,const char* text_end)
    void ImDrawList_AddText_FontPtr(ImDrawList* self,const ImFont* font,float font_size,const ImVec2 pos,ImU32 col,const char* text_begin,const char* text_end,float wrap_width,const ImVec4* cpu_fine_clip_rect)
    void ImDrawList_AddPolyline(ImDrawList* self,const ImVec2* points,int num_points,ImU32 col,ImDrawFlags flags,float thickness)
    void ImDrawList_AddConvexPolyFilled(ImDrawList* self,const ImVec2* points,int num_points,ImU32 col)
    void ImDrawList_AddBezierCubic(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,ImU32 col,float thickness,int num_segments)
    void ImDrawList_AddBezierQuadratic(ImDrawList* self,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,ImU32 col,float thickness,int num_segments)
    void ImDrawList_AddImage(ImDrawList* self,ImTextureID user_texture_id,const ImVec2 p_min,const ImVec2 p_max,const ImVec2 uv_min,const ImVec2 uv_max,ImU32 col)
    void ImDrawList_AddImageQuad(ImDrawList* self,ImTextureID user_texture_id,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,const ImVec2 uv1,const ImVec2 uv2,const ImVec2 uv3,const ImVec2 uv4,ImU32 col)
    void ImDrawList_AddImageRounded(ImDrawList* self,ImTextureID user_texture_id,const ImVec2 p_min,const ImVec2 p_max,const ImVec2 uv_min,const ImVec2 uv_max,ImU32 col,float rounding,ImDrawFlags flags)
    void ImDrawList_PathClear(ImDrawList* self)
    void ImDrawList_PathLineTo(ImDrawList* self,const ImVec2 pos)
    void ImDrawList_PathLineToMergeDuplicate(ImDrawList* self,const ImVec2 pos)
    void ImDrawList_PathFillConvex(ImDrawList* self,ImU32 col)
    void ImDrawList_PathStroke(ImDrawList* self,ImU32 col,ImDrawFlags flags,float thickness)
    void ImDrawList_PathArcTo(ImDrawList* self,const ImVec2 center,float radius,float a_min,float a_max,int num_segments)
    void ImDrawList_PathArcToFast(ImDrawList* self,const ImVec2 center,float radius,int a_min_of_12,int a_max_of_12)
    void ImDrawList_PathBezierCubicCurveTo(ImDrawList* self,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,int num_segments)
    void ImDrawList_PathBezierQuadraticCurveTo(ImDrawList* self,const ImVec2 p2,const ImVec2 p3,int num_segments)
    void ImDrawList_PathRect(ImDrawList* self,const ImVec2 rect_min,const ImVec2 rect_max,float rounding,ImDrawFlags flags)
    void ImDrawList_AddCallback(ImDrawList* self,ImDrawCallback callback,void* callback_data)
    void ImDrawList_AddDrawCmd(ImDrawList* self)
    ImDrawList* ImDrawList_CloneOutput(ImDrawList* self)
    void ImDrawList_ChannelsSplit(ImDrawList* self,int count)
    void ImDrawList_ChannelsMerge(ImDrawList* self)
    void ImDrawList_ChannelsSetCurrent(ImDrawList* self,int n)
    void ImDrawList_PrimReserve(ImDrawList* self,int idx_count,int vtx_count)
    void ImDrawList_PrimUnreserve(ImDrawList* self,int idx_count,int vtx_count)
    void ImDrawList_PrimRect(ImDrawList* self,const ImVec2 a,const ImVec2 b,ImU32 col)
    void ImDrawList_PrimRectUV(ImDrawList* self,const ImVec2 a,const ImVec2 b,const ImVec2 uv_a,const ImVec2 uv_b,ImU32 col)
    void ImDrawList_PrimQuadUV(ImDrawList* self,const ImVec2 a,const ImVec2 b,const ImVec2 c,const ImVec2 d,const ImVec2 uv_a,const ImVec2 uv_b,const ImVec2 uv_c,const ImVec2 uv_d,ImU32 col)
    void ImDrawList_PrimWriteVtx(ImDrawList* self,const ImVec2 pos,const ImVec2 uv,ImU32 col)
    void ImDrawList_PrimWriteIdx(ImDrawList* self,ImDrawIdx idx)
    void ImDrawList_PrimVtx(ImDrawList* self,const ImVec2 pos,const ImVec2 uv,ImU32 col)
    void ImDrawList__ResetForNewFrame(ImDrawList* self)
    void ImDrawList__ClearFreeMemory(ImDrawList* self)
    void ImDrawList__PopUnusedDrawCmd(ImDrawList* self)
    void ImDrawList__TryMergeDrawCmds(ImDrawList* self)
    void ImDrawList__OnChangedClipRect(ImDrawList* self)
    void ImDrawList__OnChangedTextureID(ImDrawList* self)
    void ImDrawList__OnChangedVtxOffset(ImDrawList* self)
    int ImDrawList__CalcCircleAutoSegmentCount(ImDrawList* self,float radius)
    void ImDrawList__PathArcToFastEx(ImDrawList* self,const ImVec2 center,float radius,int a_min_sample,int a_max_sample,int a_step)
    void ImDrawList__PathArcToN(ImDrawList* self,const ImVec2 center,float radius,float a_min,float a_max,int num_segments)
    ImDrawData* ImDrawData_ImDrawData()
    void ImDrawData_destroy(ImDrawData* self)
    void ImDrawData_Clear(ImDrawData* self)
    void ImDrawData_DeIndexAllBuffers(ImDrawData* self)
    void ImDrawData_ScaleClipRects(ImDrawData* self,const ImVec2 fb_scale)
    ImFontConfig* ImFontConfig_ImFontConfig()
    void ImFontConfig_destroy(ImFontConfig* self)
    ImFontGlyphRangesBuilder* ImFontGlyphRangesBuilder_ImFontGlyphRangesBuilder()
    void ImFontGlyphRangesBuilder_destroy(ImFontGlyphRangesBuilder* self)
    void ImFontGlyphRangesBuilder_Clear(ImFontGlyphRangesBuilder* self)
    bint ImFontGlyphRangesBuilder_GetBit(ImFontGlyphRangesBuilder* self,size_t n)
    void ImFontGlyphRangesBuilder_SetBit(ImFontGlyphRangesBuilder* self,size_t n)
    void ImFontGlyphRangesBuilder_AddChar(ImFontGlyphRangesBuilder* self,ImWchar c)
    void ImFontGlyphRangesBuilder_AddText(ImFontGlyphRangesBuilder* self,const char* text,const char* text_end)
    void ImFontGlyphRangesBuilder_AddRanges(ImFontGlyphRangesBuilder* self,const ImWchar* ranges)
    void ImFontGlyphRangesBuilder_BuildRanges(ImFontGlyphRangesBuilder* self,ImVector_ImWchar* out_ranges)
    ImFontAtlasCustomRect* ImFontAtlasCustomRect_ImFontAtlasCustomRect()
    void ImFontAtlasCustomRect_destroy(ImFontAtlasCustomRect* self)
    bint ImFontAtlasCustomRect_IsPacked(ImFontAtlasCustomRect* self)
    ImFontAtlas* ImFontAtlas_ImFontAtlas()
    void ImFontAtlas_destroy(ImFontAtlas* self)
    ImFont* ImFontAtlas_AddFont(ImFontAtlas* self,const ImFontConfig* font_cfg)
    ImFont* ImFontAtlas_AddFontDefault(ImFontAtlas* self,const ImFontConfig* font_cfg)
    ImFont* ImFontAtlas_AddFontFromFileTTF(ImFontAtlas* self,const char* filename,float size_pixels,const ImFontConfig* font_cfg,const ImWchar* glyph_ranges)
    ImFont* ImFontAtlas_AddFontFromMemoryTTF(ImFontAtlas* self,void* font_data,int font_size,float size_pixels,const ImFontConfig* font_cfg,const ImWchar* glyph_ranges)
    ImFont* ImFontAtlas_AddFontFromMemoryCompressedTTF(ImFontAtlas* self,const void* compressed_font_data,int compressed_font_size,float size_pixels,const ImFontConfig* font_cfg,const ImWchar* glyph_ranges)
    ImFont* ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(ImFontAtlas* self,const char* compressed_font_data_base85,float size_pixels,const ImFontConfig* font_cfg,const ImWchar* glyph_ranges)
    void ImFontAtlas_ClearInputData(ImFontAtlas* self)
    void ImFontAtlas_ClearTexData(ImFontAtlas* self)
    void ImFontAtlas_ClearFonts(ImFontAtlas* self)
    void ImFontAtlas_Clear(ImFontAtlas* self)
    bint ImFontAtlas_Build(ImFontAtlas* self)
    void ImFontAtlas_GetTexDataAsAlpha8(ImFontAtlas* self,unsigned char** out_pixels,int* out_width,int* out_height,int* out_bytes_per_pixel)
    void ImFontAtlas_GetTexDataAsRGBA32(ImFontAtlas* self,unsigned char** out_pixels,int* out_width,int* out_height,int* out_bytes_per_pixel)
    bint ImFontAtlas_IsBuilt(ImFontAtlas* self)
    void ImFontAtlas_SetTexID(ImFontAtlas* self,ImTextureID id)
    const ImWchar* ImFontAtlas_GetGlyphRangesDefault(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesKorean(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesJapanese(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesChineseFull(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesCyrillic(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesThai(ImFontAtlas* self)
    const ImWchar* ImFontAtlas_GetGlyphRangesVietnamese(ImFontAtlas* self)
    int ImFontAtlas_AddCustomRectRegular(ImFontAtlas* self,int width,int height)
    int ImFontAtlas_AddCustomRectFontGlyph(ImFontAtlas* self,ImFont* font,ImWchar id,int width,int height,float advance_x,const ImVec2 offset)
    ImFontAtlasCustomRect* ImFontAtlas_GetCustomRectByIndex(ImFontAtlas* self,int index)
    void ImFontAtlas_CalcCustomRectUV(ImFontAtlas* self,const ImFontAtlasCustomRect* rect,ImVec2* out_uv_min,ImVec2* out_uv_max)
    bint ImFontAtlas_GetMouseCursorTexData(ImFontAtlas* self,ImGuiMouseCursor cursor,ImVec2* out_offset,ImVec2* out_size,ImVec2 out_uv_border[2],ImVec2 out_uv_fill[2])
    ImFont* ImFont_ImFont()
    void ImFont_destroy(ImFont* self)
    const ImFontGlyph* ImFont_FindGlyph(ImFont* self,ImWchar c)
    const ImFontGlyph* ImFont_FindGlyphNoFallback(ImFont* self,ImWchar c)
    float ImFont_GetCharAdvance(ImFont* self,ImWchar c)
    bint ImFont_IsLoaded(ImFont* self)
    const char* ImFont_GetDebugName(ImFont* self)
    void ImFont_CalcTextSizeA(ImVec2 *pOut,ImFont* self,float size,float max_width,float wrap_width,const char* text_begin,const char* text_end,const char** remaining)
    const char* ImFont_CalcWordWrapPositionA(ImFont* self,float scale,const char* text,const char* text_end,float wrap_width)
    void ImFont_RenderChar(ImFont* self,ImDrawList* draw_list,float size,ImVec2 pos,ImU32 col,ImWchar c)
    void ImFont_RenderText(ImFont* self,ImDrawList* draw_list,float size,ImVec2 pos,ImU32 col,const ImVec4 clip_rect,const char* text_begin,const char* text_end,float wrap_width,bint cpu_fine_clip)
    void ImFont_BuildLookupTable(ImFont* self)
    void ImFont_ClearOutputData(ImFont* self)
    void ImFont_GrowIndex(ImFont* self,int new_size)
    void ImFont_AddGlyph(ImFont* self,const ImFontConfig* src_cfg,ImWchar c,float x0,float y0,float x1,float y1,float u0,float v0,float u1,float v1,float advance_x)
    void ImFont_AddRemapChar(ImFont* self,ImWchar dst,ImWchar src,bint overwrite_dst)
    void ImFont_SetGlyphVisible(ImFont* self,ImWchar c,bint visible)
    bint ImFont_IsGlyphRangeUnused(ImFont* self,unsigned int c_begin,unsigned int c_last)
    ImGuiViewport* ImGuiViewport_ImGuiViewport()
    void ImGuiViewport_destroy(ImGuiViewport* self)
    void ImGuiViewport_GetCenter(ImVec2 *pOut,ImGuiViewport* self)
    void ImGuiViewport_GetWorkCenter(ImVec2 *pOut,ImGuiViewport* self)
    ImGuiID igImHashData(const void* data,size_t data_size,ImU32 seed)
    ImGuiID igImHashStr(const char* data,size_t data_size,ImU32 seed)
    ImU32 igImAlphaBlendColors(ImU32 col_a,ImU32 col_b)
    bint igImIsPowerOfTwo_Int(int v)
    bint igImIsPowerOfTwo_U64(ImU64 v)
    int igImUpperPowerOfTwo(int v)
    int igImStricmp(const char* str1,const char* str2)
    int igImStrnicmp(const char* str1,const char* str2,size_t count)
    void igImStrncpy(char* dst,const char* src,size_t count)
    char* igImStrdup(const char* str)
    char* igImStrdupcpy(char* dst,size_t* p_dst_size,const char* str)
    const char* igImStrchrRange(const char* str_begin,const char* str_end,char c)
    int igImStrlenW(const ImWchar* str)
    const char* igImStreolRange(const char* str,const char* str_end)
    const ImWchar* igImStrbolW(const ImWchar* buf_mid_line,const ImWchar* buf_begin)
    const char* igImStristr(const char* haystack,const char* haystack_end,const char* needle,const char* needle_end)
    void igImStrTrimBlanks(char* str)
    const char* igImStrSkipBlank(const char* str)
    int igImFormatString(char* buf,size_t buf_size,const char* fmt,...)
    int igImFormatStringV(char* buf,size_t buf_size,const char* fmt,va_list args)
    const char* igImParseFormatFindStart(const char* format)
    const char* igImParseFormatFindEnd(const char* format)
    const char* igImParseFormatTrimDecorations(const char* format,char* buf,size_t buf_size)
    int igImParseFormatPrecision(const char* format,int default_value)
    bint igImCharIsBlankA(char c)
    bint igImCharIsBlankW(unsigned int c)
    const char* igImTextCharToUtf8(char out_buf[5],unsigned int c)
    int igImTextStrToUtf8(char* out_buf,int out_buf_size,const ImWchar* in_text,const ImWchar* in_text_end)
    int igImTextCharFromUtf8(unsigned int* out_char,const char* in_text,const char* in_text_end)
    int igImTextStrFromUtf8(ImWchar* out_buf,int out_buf_size,const char* in_text,const char* in_text_end,const char** in_remaining)
    int igImTextCountCharsFromUtf8(const char* in_text,const char* in_text_end)
    int igImTextCountUtf8BytesFromChar(const char* in_text,const char* in_text_end)
    int igImTextCountUtf8BytesFromStr(const ImWchar* in_text,const ImWchar* in_text_end)
    ImFileHandle igImFileOpen(const char* filename,const char* mode)
    bint igImFileClose(ImFileHandle file)
    ImU64 igImFileGetSize(ImFileHandle file)
    ImU64 igImFileRead(void* data,ImU64 size,ImU64 count,ImFileHandle file)
    ImU64 igImFileWrite(const void* data,ImU64 size,ImU64 count,ImFileHandle file)
    void* igImFileLoadToMemory(const char* filename,const char* mode,size_t* out_file_size,int padding_bytes)
    float igImPow_Float(float x,float y)
    double igImPow_double(double x,double y)
    float igImLog_Float(float x)
    double igImLog_double(double x)
    int igImAbs_Int(int x)
    float igImAbs_Float(float x)
    double igImAbs_double(double x)
    float igImSign_Float(float x)
    double igImSign_double(double x)
    float igImRsqrt_Float(float x)
    double igImRsqrt_double(double x)
    void igImMin(ImVec2 *pOut,const ImVec2 lhs,const ImVec2 rhs)
    void igImMax(ImVec2 *pOut,const ImVec2 lhs,const ImVec2 rhs)
    void igImClamp(ImVec2 *pOut,const ImVec2 v,const ImVec2 mn,ImVec2 mx)
    void igImLerp_Vec2Float(ImVec2 *pOut,const ImVec2 a,const ImVec2 b,float t)
    void igImLerp_Vec2Vec2(ImVec2 *pOut,const ImVec2 a,const ImVec2 b,const ImVec2 t)
    void igImLerp_Vec4(ImVec4 *pOut,const ImVec4 a,const ImVec4 b,float t)
    float igImSaturate(float f)
    float igImLengthSqr_Vec2(const ImVec2 lhs)
    float igImLengthSqr_Vec4(const ImVec4 lhs)
    float igImInvLength(const ImVec2 lhs,float fail_value)
    float igImFloor_Float(float f)
    float igImFloorSigned(float f)
    void igImFloor_Vec2(ImVec2 *pOut,const ImVec2 v)
    int igImModPositive(int a,int b)
    float igImDot(const ImVec2 a,const ImVec2 b)
    void igImRotate(ImVec2 *pOut,const ImVec2 v,float cos_a,float sin_a)
    float igImLinearSweep(float current,float target,float speed)
    void igImMul(ImVec2 *pOut,const ImVec2 lhs,const ImVec2 rhs)
    void igImBezierCubicCalc(ImVec2 *pOut,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,float t)
    void igImBezierCubicClosestPoint(ImVec2 *pOut,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,const ImVec2 p,int num_segments)
    void igImBezierCubicClosestPointCasteljau(ImVec2 *pOut,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,const ImVec2 p4,const ImVec2 p,float tess_tol)
    void igImBezierQuadraticCalc(ImVec2 *pOut,const ImVec2 p1,const ImVec2 p2,const ImVec2 p3,float t)
    void igImLineClosestPoint(ImVec2 *pOut,const ImVec2 a,const ImVec2 b,const ImVec2 p)
    bint igImTriangleContainsPoint(const ImVec2 a,const ImVec2 b,const ImVec2 c,const ImVec2 p)
    void igImTriangleClosestPoint(ImVec2 *pOut,const ImVec2 a,const ImVec2 b,const ImVec2 c,const ImVec2 p)
    void igImTriangleBarycentricCoords(const ImVec2 a,const ImVec2 b,const ImVec2 c,const ImVec2 p,float* out_u,float* out_v,float* out_w)
    float igImTriangleArea(const ImVec2 a,const ImVec2 b,const ImVec2 c)
    ImGuiDir igImGetDirQuadrantFromDelta(float dx,float dy)
    ImVec1* ImVec1_ImVec1_Nil()
    void ImVec1_destroy(ImVec1* self)
    ImVec1* ImVec1_ImVec1_Float(float _x)
    ImVec2ih* ImVec2ih_ImVec2ih_Nil()
    void ImVec2ih_destroy(ImVec2ih* self)
    ImVec2ih* ImVec2ih_ImVec2ih_short(short _x,short _y)
    ImVec2ih* ImVec2ih_ImVec2ih_Vec2(const ImVec2 rhs)
    ImRect* ImRect_ImRect_Nil()
    void ImRect_destroy(ImRect* self)
    ImRect* ImRect_ImRect_Vec2(const ImVec2 min,const ImVec2 max)
    ImRect* ImRect_ImRect_Vec4(const ImVec4 v)
    ImRect* ImRect_ImRect_Float(float x1,float y1,float x2,float y2)
    void ImRect_GetCenter(ImVec2 *pOut,ImRect* self)
    void ImRect_GetSize(ImVec2 *pOut,ImRect* self)
    float ImRect_GetWidth(ImRect* self)
    float ImRect_GetHeight(ImRect* self)
    float ImRect_GetArea(ImRect* self)
    void ImRect_GetTL(ImVec2 *pOut,ImRect* self)
    void ImRect_GetTR(ImVec2 *pOut,ImRect* self)
    void ImRect_GetBL(ImVec2 *pOut,ImRect* self)
    void ImRect_GetBR(ImVec2 *pOut,ImRect* self)
    bint ImRect_Contains_Vec2(ImRect* self,const ImVec2 p)
    bint ImRect_Contains_Rect(ImRect* self,const ImRect r)
    bint ImRect_Overlaps(ImRect* self,const ImRect r)
    void ImRect_Add_Vec2(ImRect* self,const ImVec2 p)
    void ImRect_Add_Rect(ImRect* self,const ImRect r)
    void ImRect_Expand_Float(ImRect* self,const float amount)
    void ImRect_Expand_Vec2(ImRect* self,const ImVec2 amount)
    void ImRect_Translate(ImRect* self,const ImVec2 d)
    void ImRect_TranslateX(ImRect* self,float dx)
    void ImRect_TranslateY(ImRect* self,float dy)
    void ImRect_ClipWith(ImRect* self,const ImRect r)
    void ImRect_ClipWithFull(ImRect* self,const ImRect r)
    void ImRect_Floor(ImRect* self)
    bint ImRect_IsInverted(ImRect* self)
    void ImRect_ToVec4(ImVec4 *pOut,ImRect* self)
    bint igImBitArrayTestBit(const ImU32* arr,int n)
    void igImBitArrayClearBit(ImU32* arr,int n)
    void igImBitArraySetBit(ImU32* arr,int n)
    void igImBitArraySetBitRange(ImU32* arr,int n,int n2)
    void ImBitVector_Create(ImBitVector* self,int sz)
    void ImBitVector_Clear(ImBitVector* self)
    bint ImBitVector_TestBit(ImBitVector* self,int n)
    void ImBitVector_SetBit(ImBitVector* self,int n)
    void ImBitVector_ClearBit(ImBitVector* self,int n)
    ImDrawListSharedData* ImDrawListSharedData_ImDrawListSharedData()
    void ImDrawListSharedData_destroy(ImDrawListSharedData* self)
    void ImDrawListSharedData_SetCircleTessellationMaxError(ImDrawListSharedData* self,float max_error)
    void ImDrawDataBuilder_Clear(ImDrawDataBuilder* self)
    void ImDrawDataBuilder_ClearFreeMemory(ImDrawDataBuilder* self)
    int ImDrawDataBuilder_GetDrawListCount(ImDrawDataBuilder* self)
    void ImDrawDataBuilder_FlattenIntoSingleLayer(ImDrawDataBuilder* self)
    ImGuiStyleMod* ImGuiStyleMod_ImGuiStyleMod_Int(ImGuiStyleVar idx,int v)
    void ImGuiStyleMod_destroy(ImGuiStyleMod* self)
    ImGuiStyleMod* ImGuiStyleMod_ImGuiStyleMod_Float(ImGuiStyleVar idx,float v)
    ImGuiStyleMod* ImGuiStyleMod_ImGuiStyleMod_Vec2(ImGuiStyleVar idx,ImVec2 v)
    ImGuiComboPreviewData* ImGuiComboPreviewData_ImGuiComboPreviewData()
    void ImGuiComboPreviewData_destroy(ImGuiComboPreviewData* self)
    ImGuiMenuColumns* ImGuiMenuColumns_ImGuiMenuColumns()
    void ImGuiMenuColumns_destroy(ImGuiMenuColumns* self)
    void ImGuiMenuColumns_Update(ImGuiMenuColumns* self,float spacing,bint window_reappearing)
    float ImGuiMenuColumns_DeclColumns(ImGuiMenuColumns* self,float w_icon,float w_label,float w_shortcut,float w_mark)
    void ImGuiMenuColumns_CalcNextTotalWidth(ImGuiMenuColumns* self,bint update_offsets)
    ImGuiInputTextState* ImGuiInputTextState_ImGuiInputTextState()
    void ImGuiInputTextState_destroy(ImGuiInputTextState* self)
    void ImGuiInputTextState_ClearText(ImGuiInputTextState* self)
    void ImGuiInputTextState_ClearFreeMemory(ImGuiInputTextState* self)
    int ImGuiInputTextState_GetUndoAvailCount(ImGuiInputTextState* self)
    int ImGuiInputTextState_GetRedoAvailCount(ImGuiInputTextState* self)
    void ImGuiInputTextState_OnKeyPressed(ImGuiInputTextState* self,int key)
    void ImGuiInputTextState_CursorAnimReset(ImGuiInputTextState* self)
    void ImGuiInputTextState_CursorClamp(ImGuiInputTextState* self)
    bint ImGuiInputTextState_HasSelection(ImGuiInputTextState* self)
    void ImGuiInputTextState_ClearSelection(ImGuiInputTextState* self)
    int ImGuiInputTextState_GetCursorPos(ImGuiInputTextState* self)
    int ImGuiInputTextState_GetSelectionStart(ImGuiInputTextState* self)
    int ImGuiInputTextState_GetSelectionEnd(ImGuiInputTextState* self)
    void ImGuiInputTextState_SelectAll(ImGuiInputTextState* self)
    ImGuiPopupData* ImGuiPopupData_ImGuiPopupData()
    void ImGuiPopupData_destroy(ImGuiPopupData* self)
    ImGuiNavItemData* ImGuiNavItemData_ImGuiNavItemData()
    void ImGuiNavItemData_destroy(ImGuiNavItemData* self)
    void ImGuiNavItemData_Clear(ImGuiNavItemData* self)
    ImGuiNextWindowData* ImGuiNextWindowData_ImGuiNextWindowData()
    void ImGuiNextWindowData_destroy(ImGuiNextWindowData* self)
    void ImGuiNextWindowData_ClearFlags(ImGuiNextWindowData* self)
    ImGuiNextItemData* ImGuiNextItemData_ImGuiNextItemData()
    void ImGuiNextItemData_destroy(ImGuiNextItemData* self)
    void ImGuiNextItemData_ClearFlags(ImGuiNextItemData* self)
    ImGuiLastItemData* ImGuiLastItemData_ImGuiLastItemData()
    void ImGuiLastItemData_destroy(ImGuiLastItemData* self)
    ImGuiPtrOrIndex* ImGuiPtrOrIndex_ImGuiPtrOrIndex_Ptr(void* ptr)
    void ImGuiPtrOrIndex_destroy(ImGuiPtrOrIndex* self)
    ImGuiPtrOrIndex* ImGuiPtrOrIndex_ImGuiPtrOrIndex_Int(int index)
    ImGuiOldColumnData* ImGuiOldColumnData_ImGuiOldColumnData()
    void ImGuiOldColumnData_destroy(ImGuiOldColumnData* self)
    ImGuiOldColumns* ImGuiOldColumns_ImGuiOldColumns()
    void ImGuiOldColumns_destroy(ImGuiOldColumns* self)
    ImGuiViewportP* ImGuiViewportP_ImGuiViewportP()
    void ImGuiViewportP_destroy(ImGuiViewportP* self)
    void ImGuiViewportP_CalcWorkRectPos(ImVec2 *pOut,ImGuiViewportP* self,const ImVec2 off_min)
    void ImGuiViewportP_CalcWorkRectSize(ImVec2 *pOut,ImGuiViewportP* self,const ImVec2 off_min,const ImVec2 off_max)
    void ImGuiViewportP_UpdateWorkRect(ImGuiViewportP* self)
    void ImGuiViewportP_GetMainRect(ImRect *pOut,ImGuiViewportP* self)
    void ImGuiViewportP_GetWorkRect(ImRect *pOut,ImGuiViewportP* self)
    void ImGuiViewportP_GetBuildWorkRect(ImRect *pOut,ImGuiViewportP* self)
    ImGuiWindowSettings* ImGuiWindowSettings_ImGuiWindowSettings()
    void ImGuiWindowSettings_destroy(ImGuiWindowSettings* self)
    char* ImGuiWindowSettings_GetName(ImGuiWindowSettings* self)
    ImGuiSettingsHandler* ImGuiSettingsHandler_ImGuiSettingsHandler()
    void ImGuiSettingsHandler_destroy(ImGuiSettingsHandler* self)
    ImGuiMetricsConfig* ImGuiMetricsConfig_ImGuiMetricsConfig()
    void ImGuiMetricsConfig_destroy(ImGuiMetricsConfig* self)
    ImGuiStackSizes* ImGuiStackSizes_ImGuiStackSizes()
    void ImGuiStackSizes_destroy(ImGuiStackSizes* self)
    void ImGuiStackSizes_SetToCurrentState(ImGuiStackSizes* self)
    void ImGuiStackSizes_CompareWithCurrentState(ImGuiStackSizes* self)
    ImGuiContextHook* ImGuiContextHook_ImGuiContextHook()
    void ImGuiContextHook_destroy(ImGuiContextHook* self)
    ImGuiContext* ImGuiContext_ImGuiContext(ImFontAtlas* shared_font_atlas)
    void ImGuiContext_destroy(ImGuiContext* self)
    ImGuiWindow* ImGuiWindow_ImGuiWindow(ImGuiContext* context,const char* name)
    void ImGuiWindow_destroy(ImGuiWindow* self)
    ImGuiID ImGuiWindow_GetID_Str(ImGuiWindow* self,const char* str,const char* str_end)
    ImGuiID ImGuiWindow_GetID_Ptr(ImGuiWindow* self,const void* ptr)
    ImGuiID ImGuiWindow_GetID_Int(ImGuiWindow* self,int n)
    ImGuiID ImGuiWindow_GetIDNoKeepAlive_Str(ImGuiWindow* self,const char* str,const char* str_end)
    ImGuiID ImGuiWindow_GetIDNoKeepAlive_Ptr(ImGuiWindow* self,const void* ptr)
    ImGuiID ImGuiWindow_GetIDNoKeepAlive_Int(ImGuiWindow* self,int n)
    ImGuiID ImGuiWindow_GetIDFromRectangle(ImGuiWindow* self,const ImRect r_abs)
    void ImGuiWindow_Rect(ImRect *pOut,ImGuiWindow* self)
    float ImGuiWindow_CalcFontSize(ImGuiWindow* self)
    float ImGuiWindow_TitleBarHeight(ImGuiWindow* self)
    void ImGuiWindow_TitleBarRect(ImRect *pOut,ImGuiWindow* self)
    float ImGuiWindow_MenuBarHeight(ImGuiWindow* self)
    void ImGuiWindow_MenuBarRect(ImRect *pOut,ImGuiWindow* self)
    ImGuiTabItem* ImGuiTabItem_ImGuiTabItem()
    void ImGuiTabItem_destroy(ImGuiTabItem* self)
    ImGuiTabBar* ImGuiTabBar_ImGuiTabBar()
    void ImGuiTabBar_destroy(ImGuiTabBar* self)
    int ImGuiTabBar_GetTabOrder(ImGuiTabBar* self,const ImGuiTabItem* tab)
    const char* ImGuiTabBar_GetTabName(ImGuiTabBar* self,const ImGuiTabItem* tab)
    ImGuiTableColumn* ImGuiTableColumn_ImGuiTableColumn()
    void ImGuiTableColumn_destroy(ImGuiTableColumn* self)
    ImGuiTable* ImGuiTable_ImGuiTable()
    void ImGuiTable_destroy(ImGuiTable* self)
    ImGuiTableTempData* ImGuiTableTempData_ImGuiTableTempData()
    void ImGuiTableTempData_destroy(ImGuiTableTempData* self)
    ImGuiTableColumnSettings* ImGuiTableColumnSettings_ImGuiTableColumnSettings()
    void ImGuiTableColumnSettings_destroy(ImGuiTableColumnSettings* self)
    ImGuiTableSettings* ImGuiTableSettings_ImGuiTableSettings()
    void ImGuiTableSettings_destroy(ImGuiTableSettings* self)
    ImGuiTableColumnSettings* ImGuiTableSettings_GetColumnSettings(ImGuiTableSettings* self)
    ImGuiWindow* igGetCurrentWindowRead()
    ImGuiWindow* igGetCurrentWindow()
    ImGuiWindow* igFindWindowByID(ImGuiID id)
    ImGuiWindow* igFindWindowByName(const char* name)
    void igUpdateWindowParentAndRootLinks(ImGuiWindow* window,ImGuiWindowFlags flags,ImGuiWindow* parent_window)
    void igCalcWindowNextAutoFitSize(ImVec2 *pOut,ImGuiWindow* window)
    bint igIsWindowChildOf(ImGuiWindow* window,ImGuiWindow* potential_parent)
    bint igIsWindowAbove(ImGuiWindow* potential_above,ImGuiWindow* potential_below)
    bint igIsWindowNavFocusable(ImGuiWindow* window)
    void igSetWindowPos_WindowPtr(ImGuiWindow* window,const ImVec2 pos,ImGuiCond cond)
    void igSetWindowSize_WindowPtr(ImGuiWindow* window,const ImVec2 size,ImGuiCond cond)
    void igSetWindowCollapsed_WindowPtr(ImGuiWindow* window,bint collapsed,ImGuiCond cond)
    void igSetWindowHitTestHole(ImGuiWindow* window,const ImVec2 pos,const ImVec2 size)
    void igFocusWindow(ImGuiWindow* window)
    void igFocusTopMostWindowUnderOne(ImGuiWindow* under_this_window,ImGuiWindow* ignore_window)
    void igBringWindowToFocusFront(ImGuiWindow* window)
    void igBringWindowToDisplayFront(ImGuiWindow* window)
    void igBringWindowToDisplayBack(ImGuiWindow* window)
    void igSetCurrentFont(ImFont* font)
    ImFont* igGetDefaultFont()
    ImDrawList* igGetForegroundDrawList_WindowPtr(ImGuiWindow* window)
    ImDrawList* igGetBackgroundDrawList_ViewportPtr(ImGuiViewport* viewport)
    ImDrawList* igGetForegroundDrawList_ViewportPtr(ImGuiViewport* viewport)
    void igInitialize(ImGuiContext* context)
    void igShutdown(ImGuiContext* context)
    void igUpdateHoveredWindowAndCaptureFlags()
    void igStartMouseMovingWindow(ImGuiWindow* window)
    void igUpdateMouseMovingWindowNewFrame()
    void igUpdateMouseMovingWindowEndFrame()
    ImGuiID igAddContextHook(ImGuiContext* context,const ImGuiContextHook* hook)
    void igRemoveContextHook(ImGuiContext* context,ImGuiID hook_to_remove)
    void igCallContextHooks(ImGuiContext* context,ImGuiContextHookType type)
    void igMarkIniSettingsDirty_Nil()
    void igMarkIniSettingsDirty_WindowPtr(ImGuiWindow* window)
    void igClearIniSettings()
    ImGuiWindowSettings* igCreateNewWindowSettings(const char* name)
    ImGuiWindowSettings* igFindWindowSettings(ImGuiID id)
    ImGuiWindowSettings* igFindOrCreateWindowSettings(const char* name)
    ImGuiSettingsHandler* igFindSettingsHandler(const char* type_name)
    void igSetNextWindowScroll(const ImVec2 scroll)
    void igSetScrollX_WindowPtr(ImGuiWindow* window,float scroll_x)
    void igSetScrollY_WindowPtr(ImGuiWindow* window,float scroll_y)
    void igSetScrollFromPosX_WindowPtr(ImGuiWindow* window,float local_x,float center_x_ratio)
    void igSetScrollFromPosY_WindowPtr(ImGuiWindow* window,float local_y,float center_y_ratio)
    void igScrollToBringRectIntoView(ImVec2 *pOut,ImGuiWindow* window,const ImRect item_rect)
    ImGuiID igGetItemID()
    ImGuiItemStatusFlags igGetItemStatusFlags()
    ImGuiItemFlags igGetItemFlags()
    ImGuiID igGetActiveID()
    ImGuiID igGetFocusID()
    void igSetActiveID(ImGuiID id,ImGuiWindow* window)
    void igSetFocusID(ImGuiID id,ImGuiWindow* window)
    void igClearActiveID()
    ImGuiID igGetHoveredID()
    void igSetHoveredID(ImGuiID id)
    void igKeepAliveID(ImGuiID id)
    void igMarkItemEdited(ImGuiID id)
    void igPushOverrideID(ImGuiID id)
    ImGuiID igGetIDWithSeed(const char* str_id_begin,const char* str_id_end,ImGuiID seed)
    void igItemSize_Vec2(const ImVec2 size,float text_baseline_y)
    void igItemSize_Rect(const ImRect bb,float text_baseline_y)
    bint igItemAdd(const ImRect bb,ImGuiID id,const ImRect* nav_bb,ImGuiItemAddFlags flags)
    bint igItemHoverable(const ImRect bb,ImGuiID id)
    void igItemFocusable(ImGuiWindow* window,ImGuiID id)
    bint igIsClippedEx(const ImRect bb,ImGuiID id,bint clip_even_when_logged)
    void igCalcItemSize(ImVec2 *pOut,ImVec2 size,float default_w,float default_h)
    float igCalcWrapWidthForPos(const ImVec2 pos,float wrap_pos_x)
    void igPushMultiItemsWidths(int components,float width_full)
    bint igIsItemToggledSelection()
    void igGetContentRegionMaxAbs(ImVec2 *pOut)
    void igShrinkWidths(ImGuiShrinkWidthItem* items,int count,float width_excess)
    void igPushItemFlag(ImGuiItemFlags option,bint enabled)
    void igPopItemFlag()
    void igLogBegin(ImGuiLogType type,int auto_open_depth)
    void igLogToBuffer(int auto_open_depth)
    void igLogRenderedText(const ImVec2* ref_pos,const char* text,const char* text_end)
    void igLogSetNextTextDecoration(const char* prefix,const char* suffix)
    bint igBeginChildEx(const char* name,ImGuiID id,const ImVec2 size_arg,bint border,ImGuiWindowFlags flags)
    void igOpenPopupEx(ImGuiID id,ImGuiPopupFlags popup_flags)
    void igClosePopupToLevel(int remaining,bint restore_focus_to_window_under_popup)
    void igClosePopupsOverWindow(ImGuiWindow* ref_window,bint restore_focus_to_window_under_popup)
    bint igIsPopupOpen_ID(ImGuiID id,ImGuiPopupFlags popup_flags)
    bint igBeginPopupEx(ImGuiID id,ImGuiWindowFlags extra_flags)
    void igBeginTooltipEx(ImGuiWindowFlags extra_flags,ImGuiTooltipFlags tooltip_flags)
    void igGetPopupAllowedExtentRect(ImRect *pOut,ImGuiWindow* window)
    ImGuiWindow* igGetTopMostPopupModal()
    void igFindBestWindowPosForPopup(ImVec2 *pOut,ImGuiWindow* window)
    void igFindBestWindowPosForPopupEx(ImVec2 *pOut,const ImVec2 ref_pos,const ImVec2 size,ImGuiDir* last_dir,const ImRect r_outer,const ImRect r_avoid,ImGuiPopupPositionPolicy policy)
    bint igBeginViewportSideBar(const char* name,ImGuiViewport* viewport,ImGuiDir dir,float size,ImGuiWindowFlags window_flags)
    bint igMenuItemEx(const char* label,const char* icon,const char* shortcut,bint selected,bint enabled)
    bint igBeginComboPopup(ImGuiID popup_id,const ImRect bb,ImGuiComboFlags flags)
    bint igBeginComboPreview()
    void igEndComboPreview()
    void igNavInitWindow(ImGuiWindow* window,bint force_reinit)
    bint igNavMoveRequestButNoResultYet()
    void igNavMoveRequestCancel()
    void igNavMoveRequestForward(ImGuiDir move_dir,ImGuiDir clip_dir,const ImRect bb_rel,ImGuiNavMoveFlags move_flags)
    void igNavMoveRequestTryWrapping(ImGuiWindow* window,ImGuiNavMoveFlags move_flags)
    float igGetNavInputAmount(ImGuiNavInput n,ImGuiInputReadMode mode)
    void igGetNavInputAmount2d(ImVec2 *pOut,ImGuiNavDirSourceFlags dir_sources,ImGuiInputReadMode mode,float slow_factor,float fast_factor)
    int igCalcTypematicRepeatAmount(float t0,float t1,float repeat_delay,float repeat_rate)
    void igActivateItem(ImGuiID id)
    void igSetNavID(ImGuiID id,ImGuiNavLayer nav_layer,ImGuiID focus_scope_id,const ImRect rect_rel)
    void igPushFocusScope(ImGuiID id)
    void igPopFocusScope()
    ImGuiID igGetFocusedFocusScope()
    ImGuiID igGetFocusScope()
    void igSetItemUsingMouseWheel()
    void igSetActiveIdUsingNavAndKeys()
    bint igIsActiveIdUsingNavDir(ImGuiDir dir)
    bint igIsActiveIdUsingNavInput(ImGuiNavInput input)
    bint igIsActiveIdUsingKey(ImGuiKey key)
    bint igIsMouseDragPastThreshold(ImGuiMouseButton button,float lock_threshold)
    bint igIsKeyPressedMap(ImGuiKey key,bint repeat)
    bint igIsNavInputDown(ImGuiNavInput n)
    bint igIsNavInputTest(ImGuiNavInput n,ImGuiInputReadMode rm)
    ImGuiKeyModFlags igGetMergedKeyModFlags()
    bint igBeginDragDropTargetCustom(const ImRect bb,ImGuiID id)
    void igClearDragDrop()
    bint igIsDragDropPayloadBeingAccepted()
    void igSetWindowClipRectBeforeSetChannel(ImGuiWindow* window,const ImRect clip_rect)
    void igBeginColumns(const char* str_id,int count,ImGuiOldColumnFlags flags)
    void igEndColumns()
    void igPushColumnClipRect(int column_index)
    void igPushColumnsBackground()
    void igPopColumnsBackground()
    ImGuiID igGetColumnsID(const char* str_id,int count)
    ImGuiOldColumns* igFindOrCreateColumns(ImGuiWindow* window,ImGuiID id)
    float igGetColumnOffsetFromNorm(const ImGuiOldColumns* columns,float offset_norm)
    float igGetColumnNormFromOffset(const ImGuiOldColumns* columns,float offset)
    void igTableOpenContextMenu(int column_n)
    void igTableSetColumnWidth(int column_n,float width)
    void igTableSetColumnSortDirection(int column_n,ImGuiSortDirection sort_direction,bint append_to_sort_specs)
    int igTableGetHoveredColumn()
    float igTableGetHeaderRowHeight()
    void igTablePushBackgroundChannel()
    void igTablePopBackgroundChannel()
    ImGuiTable* igGetCurrentTable()
    ImGuiTable* igTableFindByID(ImGuiID id)
    bint igBeginTableEx(const char* name,ImGuiID id,int columns_count,ImGuiTableFlags flags,const ImVec2 outer_size,float inner_width)
    void igTableBeginInitMemory(ImGuiTable* table,int columns_count)
    void igTableBeginApplyRequests(ImGuiTable* table)
    void igTableSetupDrawChannels(ImGuiTable* table)
    void igTableUpdateLayout(ImGuiTable* table)
    void igTableUpdateBorders(ImGuiTable* table)
    void igTableUpdateColumnsWeightFromWidth(ImGuiTable* table)
    void igTableDrawBorders(ImGuiTable* table)
    void igTableDrawContextMenu(ImGuiTable* table)
    void igTableMergeDrawChannels(ImGuiTable* table)
    void igTableSortSpecsSanitize(ImGuiTable* table)
    void igTableSortSpecsBuild(ImGuiTable* table)
    ImGuiSortDirection igTableGetColumnNextSortDirection(ImGuiTableColumn* column)
    void igTableFixColumnSortDirection(ImGuiTable* table,ImGuiTableColumn* column)
    float igTableGetColumnWidthAuto(ImGuiTable* table,ImGuiTableColumn* column)
    void igTableBeginRow(ImGuiTable* table)
    void igTableEndRow(ImGuiTable* table)
    void igTableBeginCell(ImGuiTable* table,int column_n)
    void igTableEndCell(ImGuiTable* table)
    void igTableGetCellBgRect(ImRect *pOut,const ImGuiTable* table,int column_n)
    const char* igTableGetColumnName_TablePtr(const ImGuiTable* table,int column_n)
    ImGuiID igTableGetColumnResizeID(const ImGuiTable* table,int column_n,int instance_no)
    float igTableGetMaxColumnWidth(const ImGuiTable* table,int column_n)
    void igTableSetColumnWidthAutoSingle(ImGuiTable* table,int column_n)
    void igTableSetColumnWidthAutoAll(ImGuiTable* table)
    void igTableRemove(ImGuiTable* table)
    void igTableGcCompactTransientBuffers_TablePtr(ImGuiTable* table)
    void igTableGcCompactTransientBuffers_TableTempDataPtr(ImGuiTableTempData* table)
    void igTableGcCompactSettings()
    void igTableLoadSettings(ImGuiTable* table)
    void igTableSaveSettings(ImGuiTable* table)
    void igTableResetSettings(ImGuiTable* table)
    ImGuiTableSettings* igTableGetBoundSettings(ImGuiTable* table)
    void igTableSettingsInstallHandler(ImGuiContext* context)
    ImGuiTableSettings* igTableSettingsCreate(ImGuiID id,int columns_count)
    ImGuiTableSettings* igTableSettingsFindByID(ImGuiID id)
    bint igBeginTabBarEx(ImGuiTabBar* tab_bar,const ImRect bb,ImGuiTabBarFlags flags)
    ImGuiTabItem* igTabBarFindTabByID(ImGuiTabBar* tab_bar,ImGuiID tab_id)
    void igTabBarRemoveTab(ImGuiTabBar* tab_bar,ImGuiID tab_id)
    void igTabBarCloseTab(ImGuiTabBar* tab_bar,ImGuiTabItem* tab)
    void igTabBarQueueReorder(ImGuiTabBar* tab_bar,const ImGuiTabItem* tab,int offset)
    void igTabBarQueueReorderFromMousePos(ImGuiTabBar* tab_bar,const ImGuiTabItem* tab,ImVec2 mouse_pos)
    bint igTabBarProcessReorder(ImGuiTabBar* tab_bar)
    bint igTabItemEx(ImGuiTabBar* tab_bar,const char* label,bint* p_open,ImGuiTabItemFlags flags)
    void igTabItemCalcSize(ImVec2 *pOut,const char* label,bint has_close_button)
    void igTabItemBackground(ImDrawList* draw_list,const ImRect bb,ImGuiTabItemFlags flags,ImU32 col)
    void igTabItemLabelAndCloseButton(ImDrawList* draw_list,const ImRect bb,ImGuiTabItemFlags flags,ImVec2 frame_padding,const char* label,ImGuiID tab_id,ImGuiID close_button_id,bint is_contents_visible,bint* out_just_closed,bint* out_text_clipped)
    void igRenderText(ImVec2 pos,const char* text,const char* text_end,bint hide_text_after_hash)
    void igRenderTextWrapped(ImVec2 pos,const char* text,const char* text_end,float wrap_width)
    void igRenderTextClipped(const ImVec2 pos_min,const ImVec2 pos_max,const char* text,const char* text_end,const ImVec2* text_size_if_known,const ImVec2 align,const ImRect* clip_rect)
    void igRenderTextClippedEx(ImDrawList* draw_list,const ImVec2 pos_min,const ImVec2 pos_max,const char* text,const char* text_end,const ImVec2* text_size_if_known,const ImVec2 align,const ImRect* clip_rect)
    void igRenderTextEllipsis(ImDrawList* draw_list,const ImVec2 pos_min,const ImVec2 pos_max,float clip_max_x,float ellipsis_max_x,const char* text,const char* text_end,const ImVec2* text_size_if_known)
    void igRenderFrame(ImVec2 p_min,ImVec2 p_max,ImU32 fill_col,bint border,float rounding)
    void igRenderFrameBorder(ImVec2 p_min,ImVec2 p_max,float rounding)
    void igRenderColorRectWithAlphaCheckerboard(ImDrawList* draw_list,ImVec2 p_min,ImVec2 p_max,ImU32 fill_col,float grid_step,ImVec2 grid_off,float rounding,ImDrawFlags flags)
    void igRenderNavHighlight(const ImRect bb,ImGuiID id,ImGuiNavHighlightFlags flags)
    const char* igFindRenderedTextEnd(const char* text,const char* text_end)
    void igRenderArrow(ImDrawList* draw_list,ImVec2 pos,ImU32 col,ImGuiDir dir,float scale)
    void igRenderBullet(ImDrawList* draw_list,ImVec2 pos,ImU32 col)
    void igRenderCheckMark(ImDrawList* draw_list,ImVec2 pos,ImU32 col,float sz)
    void igRenderMouseCursor(ImDrawList* draw_list,ImVec2 pos,float scale,ImGuiMouseCursor mouse_cursor,ImU32 col_fill,ImU32 col_border,ImU32 col_shadow)
    void igRenderArrowPointingAt(ImDrawList* draw_list,ImVec2 pos,ImVec2 half_sz,ImGuiDir direction,ImU32 col)
    void igRenderRectFilledRangeH(ImDrawList* draw_list,const ImRect rect,ImU32 col,float x_start_norm,float x_end_norm,float rounding)
    void igRenderRectFilledWithHole(ImDrawList* draw_list,ImRect outer,ImRect inner,ImU32 col,float rounding)
    void igTextEx(const char* text,const char* text_end,ImGuiTextFlags flags)
    bint igButtonEx(const char* label,const ImVec2 size_arg,ImGuiButtonFlags flags)
    bint igCloseButton(ImGuiID id,const ImVec2 pos)
    bint igCollapseButton(ImGuiID id,const ImVec2 pos)
    bint igArrowButtonEx(const char* str_id,ImGuiDir dir,ImVec2 size_arg,ImGuiButtonFlags flags)
    void igScrollbar(ImGuiAxis axis)
    bint igScrollbarEx(const ImRect bb,ImGuiID id,ImGuiAxis axis,float* p_scroll_v,float avail_v,float contents_v,ImDrawFlags flags)
    bint igImageButtonEx(ImGuiID id,ImTextureID texture_id,const ImVec2 size,const ImVec2 uv0,const ImVec2 uv1,const ImVec2 padding,const ImVec4 bg_col,const ImVec4 tint_col)
    void igGetWindowScrollbarRect(ImRect *pOut,ImGuiWindow* window,ImGuiAxis axis)
    ImGuiID igGetWindowScrollbarID(ImGuiWindow* window,ImGuiAxis axis)
    ImGuiID igGetWindowResizeCornerID(ImGuiWindow* window,int n)
    ImGuiID igGetWindowResizeBorderID(ImGuiWindow* window,ImGuiDir dir)
    void igSeparatorEx(ImGuiSeparatorFlags flags)
    bint igCheckboxFlags_S64Ptr(const char* label,ImS64* flags,ImS64 flags_value)
    bint igCheckboxFlags_U64Ptr(const char* label,ImU64* flags,ImU64 flags_value)
    bint igButtonBehavior(const ImRect bb,ImGuiID id,bint* out_hovered,bint* out_held,ImGuiButtonFlags flags)
    bint igDragBehavior(ImGuiID id,ImGuiDataType data_type,void* p_v,float v_speed,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags)
    bint igSliderBehavior(const ImRect bb,ImGuiID id,ImGuiDataType data_type,void* p_v,const void* p_min,const void* p_max,const char* format,ImGuiSliderFlags flags,ImRect* out_grab_bb)
    bint igSplitterBehavior(const ImRect bb,ImGuiID id,ImGuiAxis axis,float* size1,float* size2,float min_size1,float min_size2,float hover_extend,float hover_visibility_delay)
    bint igTreeNodeBehavior(ImGuiID id,ImGuiTreeNodeFlags flags,const char* label,const char* label_end)
    bint igTreeNodeBehaviorIsOpen(ImGuiID id,ImGuiTreeNodeFlags flags)
    void igTreePushOverrideID(ImGuiID id)
    const ImGuiDataTypeInfo* igDataTypeGetInfo(ImGuiDataType data_type)
    int igDataTypeFormatString(char* buf,int buf_size,ImGuiDataType data_type,const void* p_data,const char* format)
    void igDataTypeApplyOp(ImGuiDataType data_type,int op,void* output,const void* arg_1,const void* arg_2)
    bint igDataTypeApplyOpFromText(const char* buf,const char* initial_value_buf,ImGuiDataType data_type,void* p_data,const char* format)
    int igDataTypeCompare(ImGuiDataType data_type,const void* arg_1,const void* arg_2)
    bint igDataTypeClamp(ImGuiDataType data_type,void* p_data,const void* p_min,const void* p_max)
    bint igInputTextEx(const char* label,const char* hint,char* buf,int buf_size,const ImVec2 size_arg,ImGuiInputTextFlags flags,ImGuiInputTextCallback callback,void* user_data)
    bint igTempInputText(const ImRect bb,ImGuiID id,const char* label,char* buf,int buf_size,ImGuiInputTextFlags flags)
    bint igTempInputScalar(const ImRect bb,ImGuiID id,const char* label,ImGuiDataType data_type,void* p_data,const char* format,const void* p_clamp_min,const void* p_clamp_max)
    bint igTempInputIsActive(ImGuiID id)
    ImGuiInputTextState* igGetInputTextState(ImGuiID id)
    void igColorTooltip(const char* text,const float* col,ImGuiColorEditFlags flags)
    void igColorEditOptionsPopup(const float* col,ImGuiColorEditFlags flags)
    void igColorPickerOptionsPopup(const float* ref_col,ImGuiColorEditFlags flags)
    int igPlotEx(ImGuiPlotType plot_type,const char* label,float(*values_getter)(void* data,int idx),void* data,int values_count,int values_offset,const char* overlay_text,float scale_min,float scale_max,ImVec2 frame_size)
    void igShadeVertsLinearColorGradientKeepAlpha(ImDrawList* draw_list,int vert_start_idx,int vert_end_idx,ImVec2 gradient_p0,ImVec2 gradient_p1,ImU32 col0,ImU32 col1)
    void igShadeVertsLinearUV(ImDrawList* draw_list,int vert_start_idx,int vert_end_idx,const ImVec2 a,const ImVec2 b,const ImVec2 uv_a,const ImVec2 uv_b,bint clamp)
    void igGcCompactTransientMiscBuffers()
    void igGcCompactTransientWindowBuffers(ImGuiWindow* window)
    void igGcAwakeTransientWindowBuffers(ImGuiWindow* window)
    void igErrorCheckEndFrameRecover(ImGuiErrorLogCallback log_callback,void* user_data)
    void igDebugDrawItemRect(ImU32 col)
    void igDebugStartItemPicker()
    void igShowFontAtlas(ImFontAtlas* atlas)
    void igDebugNodeColumns(ImGuiOldColumns* columns)
    void igDebugNodeDrawList(ImGuiWindow* window,const ImDrawList* draw_list,const char* label)
    void igDebugNodeDrawCmdShowMeshAndBoundingBox(ImDrawList* out_draw_list,const ImDrawList* draw_list,const ImDrawCmd* draw_cmd,bint show_mesh,bint show_aabb)
    void igDebugNodeFont(ImFont* font)
    void igDebugNodeStorage(ImGuiStorage* storage,const char* label)
    void igDebugNodeTabBar(ImGuiTabBar* tab_bar,const char* label)
    void igDebugNodeTable(ImGuiTable* table)
    void igDebugNodeTableSettings(ImGuiTableSettings* settings)
    void igDebugNodeWindow(ImGuiWindow* window,const char* label)
    void igDebugNodeWindowSettings(ImGuiWindowSettings* settings)
    void igDebugNodeWindowsList(ImVector_ImGuiWindowPtr* windows,const char* label)
    void igDebugNodeViewport(ImGuiViewportP* viewport)
    void igDebugRenderViewportThumbnail(ImDrawList* draw_list,ImGuiViewportP* viewport,const ImRect bb)
    const ImFontBuilderIO* igImFontAtlasGetBuilderForStbTruetype()
    void igImFontAtlasBuildInit(ImFontAtlas* atlas)
    void igImFontAtlasBuildSetupFont(ImFontAtlas* atlas,ImFont* font,ImFontConfig* font_config,float ascent,float descent)
    void igImFontAtlasBuildPackCustomRects(ImFontAtlas* atlas,void* stbrp_context_opaque)
    void igImFontAtlasBuildFinish(ImFontAtlas* atlas)
    void igImFontAtlasBuildRender8bppRectFromString(ImFontAtlas* atlas,int x,int y,int w,int h,const char* in_str,char in_marker_char,unsigned char in_marker_pixel_value)
    void igImFontAtlasBuildRender32bppRectFromString(ImFontAtlas* atlas,int x,int y,int w,int h,const char* in_str,char in_marker_char,unsigned int in_marker_pixel_value)
    void igImFontAtlasBuildMultiplyCalcLookupTable(unsigned char out_table[256],float in_multiply_factor)
    void igImFontAtlasBuildMultiplyRectAlpha8(const unsigned char table[256],unsigned char* pixels,int x,int y,int w,int h,int stride)

    void igLogText(const char *fmt, ...)
    void ImGuiTextBuffer_appendf(ImGuiTextBuffer *buffer, const char *fmt, ...)
    float igGET_FLT_MAX()
    float igGET_FLT_MIN()

    ImVector_ImWchar* ImVector_ImWchar_create()
    void ImVector_ImWchar_destroy(ImVector_ImWchar* self)
    void ImVector_ImWchar_Init(ImVector_ImWchar* p)
    void ImVector_ImWchar_UnInit(ImVector_ImWchar* p)

#silly wrappers needed since cython cannot rename python reserved keyword arguments in c functions
cdef extern from "cimgui/cimgui.h" nogil:
    """
    void igColorConvertU32ToFloat4(ImVec4 *pOut,ImU32 in_)
    {
        igColorConvertU32ToFloat4(pOut, in_);
    }

    ImU32 igColorConvertFloat4ToU32(const ImVec4 in_)
    {
        return igColorConvertFloat4ToU32(in_);
    }
    """
    void igColorConvertU32ToFloat4(ImVec4 *pOut,ImU32 in_)
    ImU32 igColorConvertFloat4ToU32(const ImVec4 in_)