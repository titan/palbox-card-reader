# card-reader

## 编译方法

1. cp .config.orig .config

2. 编辑 .config 文件，设置正确的 libopencm3 路径(libopencm3 必须编译成 cortex m0 的库)，刷卡器 ID 和数码管驱动

3. make