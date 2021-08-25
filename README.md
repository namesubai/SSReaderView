# SSReaderView
A novel reader

使用Swift编写，底层是使用collectView和pageviewcontroller封装的一个阅读器小组件，界面复用，不用考虑内存问题，demo是整个阅读器的实现，基本满足大部分阅读器的需求。
你也可以通过 **CocoaPods**(pod 'SSReaderView') 安装 **SSReaderView** ,自己自定义阅读器。

# 特性
- 支持类似tabelView或者collectionview那样自定义每一页，上下滚动还支持修改每一页的size
- 支持仿真、左右滑动、上下滑动、左右覆盖翻页
- 支持亮度、字体、行距、背景颜色修改
- 支持自定义上、下工具栏
- 界面复用，不用考虑内存问题
# 效果图
<img src="https://github.com/namesubai/SSReaderView/blob/main/demo.gif" />

# Demo说明
[SSReaderManager:](https://github.com/namesubai/SSReaderView/blob/main/SSReaderDemo/SSReaderDemo/SSReaderController/SSReaderManager.swift)
- 本地.txt的解码和转换model
- 亮度、字体、行距、背景颜色、翻页的存储
- 支持全局监听修改进行刷新UI

