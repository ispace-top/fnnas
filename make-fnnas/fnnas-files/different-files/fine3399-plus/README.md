# Fine3399-Plus 设备配置

## 设备信息

- **型号**：Fine3399-Plus
- **SOC**：RK3399（超频版本）
- **基于**：Fine3399 标准版
- **配置 ID**：r428

## 硬件规格

- **CPU**：RK3399（超频）
- **内存**：4GB RAM
- **存储**：8GB/16GB/64GB/128GB eMMC，支持 TF 卡
- **网络**：1Gb 以太网
- **特点**：相比标准版 Fine3399 提升了 CPU/GPU 频率

## 文件说明

### 设备树文件（DTB）
- **位置**：`make-fnnas/fnnas-files/platform-files/rockchip/bootfs/dtb/rockchip/`
- **文件名**：`rk3399-fine3399-plus.dtb`
- **来源**：自定义 DTB，基于 Fine3399 调整超频参数

### 设备配置
- **位置**：`make-fnnas/fnnas-files/different-files/fine3399-plus/`
- **配置文件**：`rootfs/etc/fnnas-board-release.conf`

### 数据库条目
- **文件**：`make-fnnas/fnnas-files/common-files/etc/model_database.conf`
- **行号**：301
- **板型标识**：`fine3399-plus`

## 构建命令

### 本地构建

```bash
# 准备基础镜像（放入 fnnas-arm64/ 目录）
# 示例：fnnas-arm64/fnos_arm_rockchip_330.img.xz

# 为 Fine3399-Plus 构建（使用 6.1.y 内核）
sudo ./renas -b fine3399-plus -k 6.1.y

# 使用特定内核版本
sudo ./renas -b fine3399-plus -k 6.1.75

# 输出文件位置
ls -lh fnnas/out/
```

### GitHub Actions 构建

1. 进入仓库 Actions 页面
2. 选择 "Build FnNAS Image" 工作流
3. 点击 "Run workflow"
4. 配置参数：
   - `fnnas_base_version`: `rockchip_330`
   - `fnnas_board`: `fine3399-plus`
   - `fnnas_kernel`: `6.1.y`
   - `auto_kernel`: `true`
5. 点击 "Run workflow" 开始构建

## 与 Fine3399 标准版的区别

| 特性 | Fine3399 | Fine3399-Plus |
|------|----------|---------------|
| DTB 文件 | rk3399-fine3399.dtb | rk3399-fine3399-plus.dtb |
| CPU 频率 | 标准频率 | 超频 |
| GPU 频率 | 标准频率 | 超频 |
| 板型标识 | fine3399 | fine3399-plus |
| 设备 ID | r416 | r428 |

## 安装和使用

### 1. 写入镜像

使用 Rufus（Windows）或 balenaEtcher（跨平台）将构建的镜像写入 TF 卡或 USB 设备。

### 2. 启动系统

1. 将 TF 卡插入 Fine3399-Plus
2. 接通电源启动
3. 通过路由器查找设备 IP 地址
4. 浏览器访问：`http://设备IP:5666`
5. 创建账户并登录

### 3. 安装到 eMMC

SSH 连接到系统后：

```bash
# 安装到 eMMC
fnnas-install

# 根据提示选择安装选项
```

### 4. 内核更新

```bash
# 更新到最新 6.1.y 系列内核
fnnas-update -k 6.1.y

# 更新到特定版本
fnnas-update -k 6.1.75

# SOS 恢复（如果更新后无法启动）
fnnas-update -s
```

## 技术细节

### 内核兼容性
- **KERNEL_TAGS**：`stable/6.1.y`
- 推荐使用 6.1.y 系列内核，与 RK3399 优化匹配

### 启动配置
- **BOOT_CONF**：`armbianEnv.txt`
- 使用 Armbian 风格的环境配置文件

### Bootloader
- **TRUST_IMG**：trust.bin
- **MAINLINE_UBOOT**：uboot.img
- **BOOTLOADER_IMG**：idbloader.bin

## 注意事项

1. **超频风险**：由于是超频版本，可能会产生更多热量，建议确保散热良好
2. **稳定性测试**：首次使用建议进行充分的稳定性测试
3. **内核选择**：建议使用经过验证的 6.1.y 系列内核
4. **备份**：安装到 eMMC 前建议备份原系统（使用 `fnnas-ddbr`）

## 贡献者

- **isapce** - 添加 Fine3399-Plus 支持和超频 DTB

## 相关链接

- [FnNAS 官方网站](https://fnnas.com/)
- [项目主页](https://github.com/ophub/fnnas)
- [Fine3399 标准版配置](../../../README.md#fine3399)
- [添加新设备指南](../../../docs/添加新设备指南.md)
